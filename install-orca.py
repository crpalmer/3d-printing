#!/usr/bin/python3

import json
from pathlib import Path
import subprocess
import shutil

version = "2.3.1.0"

def mkdir_recursive(path):
    if path != path.parent:
        mkdir_recursive(path.parent)
    if not path.exists():
        path.mkdir()

def get_name(config):
    for key in [ "name", "printer_settings_id" ]:
        if key in config and config[key] != "":
            return config[key]

def set_name(config, name, subsystem):
    config["name"] = name
    if subsystem == "process":
        type = "print"
    else:
        type = subsystem
    config[type + "_settings_id"] = name
    return config

def write_json(dest, config):
    mkdir_recursive(dest.parent)
    with open(dest, "w") as f:
        # config["version"] = version
        json.dump(config, f, indent=4)

printer_notes = {}

def read_json(path):
    with open(str(path), "r") as f:
        return json.load(f)

def combine_json(config1, config2, overwrite_name=False):
    config = { }
    for key in config1.keys():
        config[key] = config1[key]
    for key in config2.keys():
        if key == "compatible_printers_condition" and key in config:
            config[key] = "(" + config[key] + ") and (" + config2[key] + ")"
        elif key == "name" and key in config:
            config["name"] += config2["name"]
        elif key == "printer_notes" and key in config:
            config["printer_notes"] += config2["printer_notes"]
        else:
            config[key] = config2[key]
    return config

def read_json_and_handle_lamb_includes(includes_path, filename):
    json = read_json(filename)
    if "lamb-includes" in json:
        for i in json["lamb-includes"]:
            print("    Including " + i)
            include_json = read_json_and_handle_lamb_includes(includes_path, includes_path / i)
            json = combine_json(json, include_json, True)
        json.pop("lamb-includes", None)
    return json

def handle_system_preset(name, sub_path, prefix, vendor_dir):
    src_path = system_dir /vendor_dir 
    for p in sub_path.parts:
        if p.startswith(prefix):
            src_path /= p[len(prefix):]
        else:
            src_path /= p
    print("   " + vendor_dir + " " + str(src_path) + " to " + str(sub_path))

    json = read_json(src_path)
    json["name"] = name
    json["instantiation"] = "false"
    if "inherits" in json:
        json["inherits"] += " @lamb"

    write_json(system_dir / 'lamb' / sub_path, json)

def clean_name_for_filtering(name):
    while "/" in name:
        name = name.partition("/")[2]
    name = name.replace(".json", "").replace(" @lamb", "")
    return name.strip()

def should_filter(json, filtered):
    if not "inherits" in json:
        return False
    inherits = clean_name_for_filtering(json["inherits"])
    if "H2D" in inherits:
        print("consider '" + str(inherits) + "' in " + str(filtered))
    return inherits in filtered

def install_lamb():
    global new_filaments
    lamb = read_json('lamb.json')
    filtered = []
    new_lamb = {}
    processed_sections = [ "machine_model_list", "process_list", "machine_list", "filament_list"]
    for section in lamb:
        if section not in processed_sections:
            new_lamb[section] = lamb[section]
        else:
            new_section = []
            for p in lamb[section]:
                if "name" in p:
                    filter = False
                    name = p["name"]
                    sub_path = Path(p["sub_path"])
                    mkdir_recursive(system_dir / sub_path)
                    if "BBL-process" in sub_path.parts:
                        if has_BBL:
                            filter = True
                        else:
                            handle_system_preset(name, sub_path, 'BBL-', 'BBL')
                    elif 'U1-process' in sub_path.parts:
                        handle_system_preset(name, sub_path, 'U1-', 'Snapmaker')
                    else:
                        print("Lamb " + str(sub_path))
                        path = Path("lamb") / Path(sub_path)
                        while not (path / "include").exists():
                            if path == path.parent:
                                raise Exception("Could not find includes directory for " + str(sub_path))
                            path = path.parent
                        json = read_json_and_handle_lamb_includes(path / "include", Path("lamb") / sub_path)
                        if should_filter(json, filtered):
                            filter = True
                        else:
                            write_json(system_dir / "lamb" / sub_path, json)
                            if "type" in json and json["type"] == "filament":
                                print("    Adding custom filament " + json["name"])
                                new_filaments.append(json["name"])
                    if filter:
                        to_filter = str(sub_path)
                        print("    skipping " + to_filter)
                        to_filter = clean_name_for_filtering(to_filter)
                        print("    skipping " + to_filter)
                        filtered.append(to_filter)
                    else:
                        new_entry = {}
                        new_entry["name"] = name
                        new_entry["sub_path"] = str(sub_path)
                        new_section.append(new_entry)
            new_lamb[section] = new_section
    write_json(system_dir / "lamb.json", new_lamb)
    print(filtered)

def do_it_all(config_fname):
    global new_filaments

    print()
    print("**** Installing to: ", orca_root)
    print()

    if not system_dir.exists():
        print("--- no installation found ---")
        return

    orcaslicer_conf = orca_root / config_fname
    print("Removing our filaments from " + str(orcaslicer_conf))
    config = read_json(orcaslicer_conf)
    filaments = config["filaments"]
    new_filaments = []
    for filament in filaments:
        if "@lamb" not in filament:
            new_filaments.append(filament)
        else:
            print("    Removing " + filament)

    install_lamb()

    config["filaments"] = new_filaments
    write_json(orcaslicer_conf, config)

# --------------------------------------------------------------------------

orca_root = Path("/cygdrive/c/Users/crpalmer/AppData/Roaming/OrcaSlicer")
if not orca_root.exists():
    orca_root = Path("/home/crpalmer/.config/OrcaSlicer/")
system_dir = orca_root / "system"

has_BBL = (system_dir / "BBL").exists()
if has_BBL:
    do_it_all("OrcaSlicer.conf")
else:
    print("Bambu Lab printer is not installed, skipping this installation")

orca_root = Path("/cygdrive/c/Users/crpalmer/AppData/Roaming/Snapmaker_Orca")
if not orca_root.exists():
    orca_root = Path("/home/crpalmer/.config/Snapmaker_Orca/")
system_dir = orca_root / "system"

do_it_all("Snapmaker_Orca.conf")


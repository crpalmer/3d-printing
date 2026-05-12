#!/usr/bin/python3

import json
from pathlib import Path
import shutil
import subprocess

version = "2.3.1.0"
orca_path = Path("/home/crpalmer/.config/OrcaSlicer/user/default")

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
        config["version"] = version
        json.dump(config, f, indent=4)

printer_notes = {}

def write_config(config, subsystem):
    name = get_name(config)
    config = set_name(config, name, subsystem)
    if "printer_notes" in config:
        printer_notes[name] = config["printer_notes"]
    if "compatible_printers" not in config and "compatible_printers_condition" in config:
        config["compatible_printers"] = []
        for printer in printer_notes.keys():
            satisfied = True
            notes = printer_notes[printer]
            for condition in config["compatible_printers_condition"].split("\n"):
                if condition not in notes:
                    satisfied = False
                    break
            if satisfied:
                config["compatible_printers"].append(printer)
        config["compatible_printers"].sort()
        config["compatible_printers_condition"] = ""
    write_json(orca_path / subsystem / (name + ".json"), config)

def write_base(config, subsystem, name):
    config = set_name(config, name, subsystem)
    write_json(orca_path / subsystem / 'base' / (name + ".json"), config)

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

def apply_chain(base, path, subsystem, chain):
    if len(chain) == 0:
        write_config(base, subsystem)
    elif chain[0].endswith('.json'):
        print("        Combining: " + chain[0])
        config = combine_json(base, read_json(path / chain[0]))
        apply_chain(config, path, subsystem, chain[1:])
    else:
        chain_path = path / chain[0]
        for file in chain_path.iterdir():
            if file.name != "base.json" and file.name != "modifiers.json" and file.suffix == '.json':
                print("        Combining: " + str(file))
                config = combine_json(base, read_json(file))
                apply_chain(config, path, subsystem, chain[1:])

def apply_modifiers_to_dir(path, subsystem):
    print("     Processing " + str(path))
    modifiers = read_json(path / "modifiers.json")
    base = read_json(path / "base.json")
    write_base(base, subsystem, base["name"])

    base_config = { "inherits": base["name"] }
    if "printer_notes" in base:
        base_config["printer_notes"] = base["printer_notes"]
    if "compatible_printers_condition" in base:
        base_config["compatible_printers_condition"] = base["compatible_printers_condition"]

    for chain in modifiers["chains"]:
        apply_chain(base_config, path, subsystem, chain)
        
def process(path, subsystem):
    m = path / 'modifiers.json'
    if m.exists():
        apply_modifiers_to_dir(path, subsystem)
        return

    for file in path.iterdir():
        if file.is_dir():
            process(file, subsystem)
        elif file.suffix == '.json':
            print("Processing: " + str(file))
            config = read_json(file)
            if file == "base.json":
                write_base(config, subsystem, name)
            else:
                write_config(config, subsystem)

def read_json_and_handle_lamb_includes(includes_path, filename):
    json = read_json(filename)
    if "lamb-includes" in json:
        for i in json["lamb-includes"]:
            print("    Including " + i)
            include_json = read_json_and_handle_lamb_includes(includes_path, includes_path / i)
            json = combine_json(json, include_json, True)
        json.pop("lamb-includes", None)
    return json

def install_lamb():
    system_dir = orca_path.parent.parent / "system"
    shutil.copy('lamb.json', system_dir / 'lamb.json')
    lamb = read_json('lamb.json')
    for p in lamb["machine_model_list"] + lamb["process_list"] + lamb["machine_list"]:
        name = p["name"]
        sub_path = Path(p["sub_path"])
        mkdir_recursive(system_dir / sub_path)
        if "BBL-process" in sub_path.parts:
            bbl_path = system_dir / 'BBL'
            for p in sub_path.parts:
                if p.startswith("BBL-"):
                    bbl_path /= p[4:]
                else:
                    bbl_path /= p
            print("   BBL " + str(bbl_path) + " to " + str(sub_path))

            bbl = read_json(system_dir / bbl_path)
            bbl["name"] = name
            bbl["instantiation"] = "false"
            if "inherits" in bbl:
                bbl["inherits"] += " @lamb"

            write_json(system_dir / 'lamb' / sub_path, bbl)
        else:
            print("Lamb " + str(sub_path))
            path = Path("lamb") / Path(sub_path)
            while not (path / "include").exists():
                if path == path.parent:
                    raise Exception("Could not find includes directory for " + sub_path)
                path = path.parent
                print("next: " + str(path))
            json = read_json_and_handle_lamb_includes(path / "include", Path("lamb") / sub_path)
            write_json(system_dir / "lamb" / sub_path, json)

# --------------------------------------------------------------------------

print()
print("**** Installing to: ", orca_path)
print()
for subsystem in [ "filament" ]:
    mkdir_recursive(orca_path / subsystem / "base")
    process(Path("orca") / subsystem, subsystem)
print("")
install_lamb()

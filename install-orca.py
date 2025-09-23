#!/usr/bin/python3

import json
import os

version = "2.3.1.0"

post_process_prefix = ""
dirs = [ "/home/crpalmer/.config/OrcaSlicer/user/default", "/home/crpalmer/.var/app/io.github.softfever.OrcaSlicer/config/OrcaSlicer/user/default", "/cygdrive/c/Users/crpalmer/AppData/Local/OrcaSlicer/user/default", "/cygdrive/c/Users/crpalmer/AppData/Roaming/OrcaSlicer/user/default" ]
orca_dir = dirs[0]
for dir in dirs:
    if os.path.exists(dir):
        orca_dir = dir
        if dir.startswith("/cygdrive"):
            post_process_prefix = "c:/cygwin64/bin/bash.exe --login"
        break

def mkdir_recursive(path):
    if path[0] == '/':
        base = '/'
    else:
        base = "."
    for path in path.split('/'):
        base = base + "/" + path
        if not os.path.exists(base):
            os.mkdir(base)

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
    if not orca_dir.startswith("/home/crpalmer") and "post_process" in config:
        cmds = []
        for cmd in config["post_process"]:
            cmds.append(post_process_prefix + cmd)
        config["post_process"] = cmds
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
    write_json(orca_dir + "/" + subsystem + "/" + name + ".json", config)

def write_base(config, subsystem, name):
    config = set_name(config, name, subsystem)
    write_json(orca_dir + "/" + subsystem + "/base/" + name + ".json", config)

def read_json(path):
    print("   Loading: " + path)
    with open(path, "r") as f:
        return json.load(f)

def combine_json(config1, config2):
    config = { }
    for key in config1.keys():
        config[key] = config1[key]
    for key in config2.keys():
        if key == "compatible_printers_condition" and key in config:
            config[key] += config2[key]
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
    elif chain[0].endswith(".json"):
        config = combine_json(base, read_json(path + "/" + chain[0]))
        apply_chain(config, path, subsystem, chain[1:])
    else:
        chain_path = path + "/" + chain[0]
        for file in os.listdir(chain_path):
            if file != "base.json" and file != "modifiers.json" and file.endswith(".json"):
                full = chain_path + "/" + file
                config = combine_json(base, read_json(full))
                apply_chain(config, path, subsystem, chain[1:])

def apply_modifiers_to_dir(path, subsystem):
    modifiers = read_json(path + "/modifiers.json")
    base = read_json(path + "/base.json")
    write_base(base, subsystem, base["name"])

    base_config = { "inherits": base["name"] }
    if "printer_notes" in base:
        base_config["printer_notes"] = base["printer_notes"]
    if "compatible_printers_condition" in base:
        base_config["compatible_printers_condition"] = base["compatible_printers_condition"]

    for chain in modifiers["chains"]:
        apply_chain(base_config, path, subsystem, chain)
        
def process(path, subsystem, name):
    if os.path.exists(path + "/modifiers.json"):
        apply_modifiers_to_dir(path, subsystem)
        return

    for file in os.listdir(path):
        full_file = path + "/" + file
        if os.path.isdir(full_file):
            process(full_file, subsystem, file)
        elif file.endswith(".json"):
            print("Processing: " + full_file)
            config = read_json(full_file)
            if file == "base.json":
                write_base(config, subsystem, name)
            else:
                write_config(config, subsystem)

for subsystem in [ "machine", "filament", "process" ]:
    mkdir_recursive(orca_dir + "/" + subsystem + "/base")
    process("orca/" + subsystem, subsystem, None)

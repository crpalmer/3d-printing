#!/usr/bin/python3

import json
import os

version = "2.3.1.0"

post_process_prefix = ""
for dir in [ "/home/crpalmer/.config/OrcaSlicer/user/default", "/cygdrive/c/Users/crpalmer/AppData/Local/OrcaSlicer/user/default", "/cygdrive/c/Users/crpalmer/AppData/Roaming/OrcaSlicer/user/default" ]:
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

def set_name(config, name):
    config["name"] = name
    if "printer_settings_id" in config:
        config["printer_settings_id"] = name
    return config

def write_json(dest, config):
    if "post_process" in config:
        cmds = []
        for cmd in config["post_process"]:
            cmds.append(post_process_prefix + cmd)
        config["post_process"] = cmds
    with open(dest, "w") as f:
        config["version"] = version
        json.dump(config, f, indent=4)

def write_config(config, subsystem, inherits = None):
    name = get_name(config)
    if inherits != None:
        config["inherits"] = inherits
    config = set_name(config, name)
    write_json(orca_dir + "/" + subsystem + "/" + name + ".json", config)

def write_base(config, subsystem, name):
    config = set_name(config, name)
    config["inherits"] = ""
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
        if key == "compatible_printers_condition" and key in config and key in config2 and config[key].strip() != '':
            config[key] = "(" + config[key] + ") and (" + config2[key] + ")"
        elif key == "name" and key in config and key in config2:
            config["name"] += config2["name"]
        else:
            config[key] = config2[key]
    return config

def apply_chain(base, path, subsystem, chain):
    if len(chain) == 0:
        write_config(base, subsystem)
    elif chain[0].endswith(".json"):
        config = combine_json(base, read_json(path + "/" + chain[0]))
        if "name" in config:
            write_config(config, subsystem)
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
    for chain in modifiers["chains"]:
        apply_chain(base, path, subsystem, chain)
        
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

for subsystem in [ "filament", "machine", "process" ]:
    mkdir_recursive(orca_dir + "/" + subsystem + "/base")
    process("orca/" + subsystem, subsystem, None)

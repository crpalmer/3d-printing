#!/usr/bin/python3

import json
import os
import hashlib

version = "2.3.1.0"

post_process_prefix = ""
dirs = [ "/home/crpalmer/.config/OrcaSlicer", "/cygdrive/c/Users/crpalmer/AppData/Local/OrcaSlicer/", "/cygdrive/c/Users/crpalmer/AppData/Roaming/OrcaSlicer/" ]
orca_root = dirs[0]
orca_subdir = "/user/default"
for dir in dirs:
    if os.path.exists(dir + orca_subdir):
        orca_root = dir
        if dir.startswith("/cygdrive"):
            post_process_prefix = "c:/cygwin64/bin/bash.exe --login"
        break
orca_dir = orca_root + orca_subdir

def mkdir_recursive(path):
    if path[0] == '/':
        base = '/'
    else:
        base = "."
    for path in path.split('/'):
        base = base + "/" + path
        if not os.path.exists(base):
            os.mkdir(base)

def generate_filament_id(str):
    md5 = hashlib.md5()
    md5.update(str.encode("UTF-8"))
    return "L" + md5.hexdigest()[0:7]

def get_name(config):
    for key in [ "name", "printer_settings_id" ]:
        if key in config and config[key] != "":
            return config[key]

def set_name(config, name, full_subsystem):
    config["name"] = name
    subsystem_split = full_subsystem.split("/")
    if subsystem_split[0] == "process":
        type = "print"
    else:
        type = subsystem_split[0]
    config[type + "_settings_id"] = name
    if len(subsystem_split) > 1 and subsystem_split[1] == "base":
        config["filament_id"] = generate_filament_id(name)
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

def write_config(config, subsystem):
    name = get_name(config)
    if subsystem == "filament" and "inherits" in config and config["inherits"] != '':
        config = handle_filament_inherits(config)
    config = set_name(config, name, subsystem)
    if subsystem == "filament":
        write_json(orca_dir + "/" + subsystem + "/base/" + name + ".json", config)
    else:
        write_json(orca_dir + "/" + subsystem + "/" + name + ".json", config)

def write_base(config, subsystem, name):
    config = set_name(config, name, subsystem)
    config["inherits"] = ""
    write_json(orca_dir + "/" + subsystem + "/base/" + name + ".json", config)

def read_json(path):
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

def handle_filament_inherits(config):
    base = None
    inherits = config["inherits"]
    for dir in [ "orca/filament", orca_root + "/system/BBL/filament", orca_root + "/system/OrcaFilamentLibrary/filament", orca_root + "/system/OrcaFilamentLibrary/filament/base" ]:
        path = dir + "/" + inherits + ".json"
        if os.path.exists(path):
            print("            -> " + path)
            base = read_json(path)
            if "inherits" in base and base["inherits"] != "":
                base = handle_filament_inherits(base)
                break
    if base == None:
        raise Exception("Could not handle inherits for " + inherits)
    config = combine_json(base, config)
    for key in [ "inherits", "renamed_from", "instantiation", "filament_id"]:
        if key in config:
            del config[key]
    return config

def apply_chain(base, path, subsystem, chain):
    if len(chain) == 0:
        print("    => " + base["name"])
        write_config(base, subsystem)
    elif chain[0].endswith(".json"):
        file = path + "/" + chain[0]
        print("          + " + file)
        config = combine_json(base, read_json(file))
        if "name" in config:
            write_config(config, subsystem)
        apply_chain(config, path, subsystem, chain[1:])
    else:
        chain_path = path + "/" + chain[0]
        for file in os.listdir(chain_path):
            if file != "base.json" and file != "modifiers.json" and file.endswith(".json"):
                full = chain_path + "/" + file
                print("          + " + full)
                config = combine_json(base, read_json(full))
                apply_chain(config, path, subsystem, chain[1:])

def apply_modifiers_to_dir(path, subsystem):
    print("STARTING: " + path)
    modifiers = read_json(path + "/modifiers.json")
    base = read_json(path + "/base.json")
    for chain in modifiers["chains"]:
        apply_chain(base, path, subsystem, chain)
        
def process(path, subsystem, name = None):
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
    process("orca/" + subsystem, subsystem)

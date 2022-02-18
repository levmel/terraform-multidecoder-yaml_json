# terraform-multiple-yamldecode
Access multiple YAML files with their relative paths in one run.

## Usage
Place this module in the location where you need to access one or many different YAML files (different paths possible) and pass
the variable **filepaths** which takes a set of strings of the relative paths of YAML files as an argument. You can change the module name if you want!
```
module "yamlextractor" {
  source  = "leothereal/yamlextractor/multifile"
  version = "1.0.0"
  filepaths = ["routes/nsg_rules.yaml.", "network/private_endpoints/*.yaml", "network/private_links/config_file.yaml"]
}
```
Relative path pattern to YAML files:   **"folder/../name_of_yaml.yaml"** or **"folder/../*.yaml"**

If all YAML files within a relative path are to be selected, then use the star notation before format **"*.yaml"** otherwise
name the file you like to select explicitly (see above).

**WARNING:** Only the relative path must be specified. The path.root should not be passed, but everything after that.

## Access YAML entries
Now you can access all entries within all the YAML files you've selected like that: **"module.yamlextractor.files.nsg_rules.entry"** or **"module.yamlextractor.files.config_file.entry"**. 
Explanation of entry access: Before you write your **".entry"** you have to write the file name you like to access. (see filepaths)


## Example
routes/nsg_rules.yaml
```
aks:
  rdp:
    name: rdp
    priority: 80
    direction: Inbound
    access: Allow
    protocol: Tcp
    source_port_range: "*"
    destination_port_range: 3399
    source_address_prefix: VirtualNetwork
    destination_address_prefix: "*"
  ssh:
    name: ssh
    priority: 70
    direction: Inbound
    access: Allow
    protocol: Tcp
    source_port_range: "*"
    destination_port_range: 24
    source_address_prefix: VirtualNetwork
    destination_address_prefix: "*"
```

main.tf
```
module "yamlextractor" {
  source  = "leothereal/yamlextractor/multifile"
  version = "1.0.0"
  filepaths = ["routes/nsg_rules.yaml."]
}

output "variables" {
  value = module.yamlextractor.nsg_rules.aks.ssh.source_address_prefix
}
```

---
Changes to Outputs:
  + variables = "VirtualNetwork"


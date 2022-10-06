# terraform-multidecoder-yaml_json
Access multiple YAML and/or JSON files with their relative paths in one step.

## Usage
Place this module in the location where you need to access multiple different YAML and/or JSON files (different paths possible) and pass
your path/-s in the parameter **filepaths** which takes a set of strings of the relative paths of YAML and/or JSON files as an argument. You can change the module name if you want!
```
module "yaml_json_decoder" {
  source  = "levmel/yaml_json/multidecoder"
  version = "0.2.1"
  filepaths = ["routes/nsg_rules.yml", "failover/cosmosdb.json", "network/private_endpoints/*.yaml", "network/private_links/config_file.yml", "network/private_endpoints/*.yml", "pipeline/config/*.json"]
}
```

### Patterns to access YAML and/or JSON files from relative paths:

To be able to access all YAML and/or JSON files in a folder entern your path as follows ```"folder/rest_of_folders/*.yaml"```, ```"folder/rest_of_folders/*.yml"``` or ```"folder/rest_of_folders/*.json"```.

To be able to access a specific YAML and/or a JSON file in a folder structure use this ```"folder/rest_of_folders/name_of_yaml.yaml"```, ```"folder/rest_of_folders/name_of_yaml.yml"``` or ```"folder/rest_of_folders/name_of_yaml.json"```

If you like to select all YAML and/or JSON files within a folder, then you should use **"*.yml"**, **"*.yaml"**, **"*.json"** format notation. (see above in the USAGE section)

### YAML delimiter support is available from version 0.1.0!

**WARNING:** Only the relative path must be specified. The path.root (it is included in the module by default) should not be passed, but everything after it.

## Access YAML and JSON entries
Now you can access all entries within all the YAML and/or JSON files you've selected like that: **"module.yaml_json_decoder.files.[name of your YAML or JSON file].entry"**. If the name of your YAML or JSON file is "name_of_your_config_file" then access it as follows **"module.yaml_json_decoder.files.name_of_your_config_file.entry"**.


## Example of multi YAML and JSON file accesses from different paths (directories)
### first YAML file:
routes/nsg_rules.yml
```
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
  
---
  
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
### second YAML file:
services/logging/monitoring.yml
```
application_insights:
  application_type: other
  retention_in_days: 30
  daily_data_cap_in_gb: 20
  daily_data_cap_notifications_disabled: true
  logs:
  # Optional fields
   - "AppMetrics"
   - "AppAvailabilityResults"
   - "AppEvents"
   - "AppDependencies"
   - "AppBrowserTimings"
   - "AppExceptions"
   - "AppExceptions"
   - "AppPerformanceCounters"
   - "AppRequests"
   - "AppSystemEvents"
   - "AppTraces"
```
### first JSON file:
test/config/json_history.json
```
{
    "glossary": {
        "title": "example glossary",
		"GlossDiv": {
            "title": "S",
			"GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
					"SortAs": "SGML",
					"GlossTerm": "Standard Generalized Markup Language",
					"Acronym": "SGML",
					"Abbrev": "ISO 8879:1986",
					"GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
						"GlossSeeAlso": ["GML", "XML"]
                    },
					"GlossSee": "markup"
                }
            }
        }
    }
}

```

main.tf
```
module "yaml_json_multidecoder" {
  source  = "levmel/yaml_json/multidecoder"
  version = "0.2.1"
  filepaths = ["routes/nsg_rules.yml", "services/logging/monitoring.yml", test/config/*.json]
}

output "nsg_rules_entry" {
  value = module.yaml_json_multidecoder.files.nsg_rules.aks.ssh.source_address_prefix
}

output "application_insights_entry" {
  value = module.yaml_json_multidecoder.files.monitoring.application_insights.daily_data_cap_in_gb
}

output "json_history" {
  value = module.yaml_json_multidecoder.files.json_history.glossary.title
}
```

---
Changes to Outputs:
  + nsg_rules_entry            = "VirtualNetwork"
  + application_insights_entry = 20
  + json_history               = "example glossary"

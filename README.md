# terraform-multidecoder-yaml_json
Access multiple YAML and JSON files using their relative paths in a single step.

## Usage
Place this module in the location where you need to access multiple YAML and JSON files from various paths. Provide your paths using the **filepaths** parameter, which accepts a set of string values representing the relative paths of the YAML and JSON files. If desired, you can rename the module.
```
module "yaml_json_decoder" {
  source  = "levmel/yaml_json/multidecoder"
  version = "0.2.3"
  filepaths = ["routes/nsg_rules.yml", "failover/cosmosdb.json", "network/private_endpoints/*.yaml", "network/private_links/config_file.yml", "network/private_endpoints/*.yml", "pipeline/config/*.json"]
}
```

### Patterns for accessing YAML and JSON files using relative paths::

To access all YAML and JSON files within a folder, structure your path as follows:  
```"folder/rest_of_folders/*.yaml"```, ```"folder/rest_of_folders/*.yml"``` 
or ```"folder/rest_of_folders/*.json"```.

For specific YAML or JSON files within a directory, use the format: 
```"folder/rest_of_folders/<name_of_yaml_file>.yaml"```, ```"folder/rest_of_folders/<name_of_yml_file>.yml"``` or ```"folder/rest_of_folders/<name_of_json_file>.json"```

To select all YAML and JSON files within a folder, use the following format notation:  
```"*.yml", "*.yaml", "*.json"``` (Refer to the USAGE section above for more details.)

### Support for YAML delimiters is introduced in version 0.1.0!

**WARNING:** Specify only the relative path. Do not include the path.root, as it's already incorporated within the module. Instead, provide everything that follows it.

## Access YAML and JSON Entries
You can now access all entries within the selected YAML and JSON files using the format: **"module.yaml_json_decoder.files.[name_of_your_file].entry"**. For instance, if your file is named "name_of_your_config_file", access its entries with **"module.yaml_json_decoder.files.name_of_your_config_file.entry"**.


## Example of accessing multiple YAML and JSON files from various directories:
### first YAML file:
routes/nsg_rules.yaml
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
  version = "0.2.3"
  filepaths = ["routes/nsg_rules.yaml", "services/logging/monitoring.yml", test/config/*.json]
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



Buy me a coffee on PayPal if you find my code useful and it has made your life easier:
```levonmelikbekjan@yahoo.de```
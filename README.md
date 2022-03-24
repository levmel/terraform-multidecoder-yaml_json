# terraform-multiple-yamldecode
Access multiple YAML files with their relative paths in one run.

## Usage
Place this module in the location where you need to access one or multiple different YAML files (different paths possible) and pass
your path/-s in the parameter **filepaths** which takes a set of strings of the relative paths of YAML files as an argument. You can change the module name if you want!
```
module "yamldecode" {
  source  = "levmel/yamldecode/multiple"
  version = "0.0.4"
  filepaths = ["routes/nsg_rules.yml.", "network/private_endpoints/*.yml", "network/private_links/config_file.yml"]
}
```
Relative path pattern to YAML files:   **"folder/../name_of_yaml.yml"** or **"folder/../*.yml"**

If all YAML files within a relative path are to be selected, then use the star notation before format **"*.yml"** otherwise
name the file you like to select explicitly (see above).

**WARNING:** Only the relative path must be specified. The path.root (it is included in the module by default) should not be passed, but everything after it.

## Access YAML entries
Now you can access all entries within all the YAML files you've selected like that: **"module.yamldecode.files.[name of your YAML file].entry"**. If the name of your YAML file is "config" then access it as follows **"module.yamldecode.files.config.[the field name you like to access]"**
**"module.yamldecode.files.config_file.entry"**.


## Example of multiple YAML file accesses from different paths (directories)
### first YAML file:
routes/nsg_rules.yml
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

main.tf
```
module "yamldecode" {
  source  = "levmel/yamldecode/multiple"
  version = "0.0.4"
  filepaths = ["routes/nsg_rules.yml", "services/logging/monitoring.yml"]
}

output "nsg_rules_entry" {
  value = module.yamldecode.files.nsg_rules.aks.ssh.source_address_prefix
}

output "application_insights_entry" {
  value = module.yamldecode.files.monitoring.application_insights.daily_data_cap_in_gb
}
```

---
Changes to Outputs:
  + nsg_rules_entry = "VirtualNetwork"
  + application_insights_entry = 20

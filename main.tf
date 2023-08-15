terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}

variable "filepaths" {
  description = "Set of strings of relative YAML and/or JSON paths including their file extension."
  type        = set(string)
}

data "local_file" "yaml_json_standard" {
  for_each = toset(flatten([for relative_path in var.filepaths : fileset(path.root, relative_path)]))
  filename = "${path.root}/${each.value}"
}

output "files" {
  description = "Contents of the YAML and/or JSON files."
  value = {for i, file in data.local_file.yaml_json_standard : 
              element(split(".", replace(basename(file.filename), "\\.(yaml|yml|json)$", "")), 0) => 
                  try(yamldecode(join("", split("---", file.content))), {})}
}

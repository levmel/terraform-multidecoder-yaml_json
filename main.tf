terraform {
  required_version = "~> 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
  }
}

variable "filepaths" {
  description = "Set of strings of relative YAML paths including their file extension."
  type        = set(string)
}

data "local_file" "yaml" {
  for_each = toset(flatten([for relative_path in var.filepaths : fileset(path.root, relative_path)]))
  filename = "${path.root}/${each.value}"
}

output "files" {
  description = "Contents of the YAML files."
  value       = {for i, file in data.local_file.yaml : element(split("/", trim(file.filename, ".yaml")), length(split("/", trim(file.filename, ".yaml")))-1)  => try(yamldecode(trimprefix(file.content, "---")), {})}
}

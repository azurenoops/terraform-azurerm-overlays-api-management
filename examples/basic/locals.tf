# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  tags = {
    Project = "Azure NoOps"
    Module  = "overlays-api-management"
    Toolkit = "Terraform"
    Example = "basic deployment of apim"
  }
}
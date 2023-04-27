#NoOps general settings
environment ="public"
location ="eastus"
org_name = "anoa"
#APIM Settings
publisher_email = "joscot@microsoft.com"
publisher_name = "anoa"
use_location_short_name = true
workload_name = "NoOps Testing"
sku_tier = "Developer"
sku_capacity = 1
enable_redis_cache = true
enable_user_identity = true
virtual_network_type = "Internal"
create_resource_group = false
existing_resource_group_name = "anoa-eus-NoOpsTest-Dev"
apim_subnet_name = "ampe-gsa-eastus-apim-snet"
private_endpoint_subnet_name = "ampe-gsa-eastus-pe-snet"
virtual_network_name = "noops-vnet"
deploy_environment = "Dev"
private_endpoint_subnet_prefix = ["10.0.125.64/27"]
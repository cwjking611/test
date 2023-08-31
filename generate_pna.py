// Query Azure Rest API to get publicNetworkAccess property of all resources types and build a dynamic list of resources that support publicNetworkAccess that can be used in a policy definition json file.
// This script is used to generate the list of resources in the file pna_resources.json
// The list of resources in pna_resources.json is used in the policy definition file pna_policy.json
// The policy definition file pna_policy.json is used to create a policy definition in Azure for each pna_resources.json resource.
#
# Usage: python generate_pna.py
#
# Example:  python generate_pna.py  > pna_resources.json
#
# Note: This script requires the Azure CLI to be installed and logged in to an Azure subscription.
#
az login
#   Get list of all resource types
resource_types=$(az provider list --query [].namespace --output tsv)
#   Loop through each resource type and get publicNetworkAccess property
for resource_type in $resource_types
do
    public_network_access=$(az provider show --namespace $resource_type --query "resourceTypes[?resourceType=='*'].properties.publicNetworkAccess" --output tsv)
    #   If publicNetworkAccess property is not null, then add resource type to list of resources that support publicNetworkAccess
    if [ "$public_network_access" != "None" ]
    then
        echo $resource_type
    fi
done
```

## Create policy definitions

The following script creates a policy definition in Azure for each resource type in the pna_resources.json file.
    
    ```bash
    #!/bin/bash
    #
    # Path: create_pna_policy_definitions.sh
    # Create a policy definition in Azure for each resource type in the pna_resources.json file.
    #       
    # Usage: ./create_pna_policy_definitions.sh
    #                           
    # Example:  ./create_pna_policy_definitions.sh
    #
    # Note: This script requires the Azure CLI to be installed and logged in to an Azure subscription.
    #
    # Get list of resource types that support publicNetworkAccess
    resource_types=$(cat pna_resources.json | jq -r '.[]')
    # Loop through each resource type and create policy definition
    for resource_type in $resource_types
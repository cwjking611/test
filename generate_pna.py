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
What do I code next?
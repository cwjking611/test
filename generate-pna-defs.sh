# generate a list of resource types that have an alias for publicNetworkAccess that can be used for azure policy definitions
# we want to define a list of resource types that have an alias for publicNetworkAccess that can be used for azure policy definitions
# this script will generate a list of resource types that have an alias for publicNetworkAccess that can be used for azure policy definitions
#

# get the list of resource types that have an alias for publicNetworkAccess
# this will be used to generate the list of resource types that can be used for azure policy definitions
#
# the output of this command will be a list of resource types that have an alias for publicNetworkAccess
# the output will be in the following format:
#   Microsoft.Compute/virtualMachines
#   Microsoft.Compute/virtualMachines/extensions
#   Microsoft.Compute/virtualMachineScaleSets
#
# the output of this command will be used to generate the list of resource types that can be used for azure policy definitions
#
az provider show --namespace Microsoft.Network --query resourceTypes[].resourceType --output tsv | grep -i publicNetworkAccess > pna-aliases.txt
# query all providers for the list of resource types that have an alias for publicNetworkAccess
az provider show --namespace Microsoft.Network --query resourceTypes[].resourceType --output tsv | grep -i publicNetworkAccess > pna-aliases.txt
# we can make a list of providers to loop through by using the following command and store it as a variable like below
providers=$(az provider list --query [].namespace --output tsv)
# we can loop through the list of providers and query each provider for the list of resource types that have an alias for publicNetworkAccess
for provider in $providers; do az provider show --namespace $provider --query resourceTypes[].resourceType --output tsv | grep -i publicNetworkAccess >> pna-aliases.txt; done
# you can do this with jq as well output as json
for provider in $providers; do az provider show --namespace $provider --query resourceTypes[].resourceType --output json | jq -r '.[] | select(.aliases[] | contains("publicNetworkAccess"))' >> pna-aliases.txt; done
# you can also do this with jq and output as tsv
az provider list --query [].namespace --output tsv | xargs -I {} az provider show --namespace {} --query resourceTypes[].resourceType --output tsv | grep -i publicNetworkAccess > pna-aliases.txt
# Each resource type will have a list of aliases. We want to get the list of aliases that have publicNetworkAccess
# The output of this command will be a list of aliases that have publicNetworkAccess in the following format:
#  Microsoft.<provider-variable>/<resource-type-variable>/publicNetworkAccess
#
# The resource types will be used to create individual azure policy definitions for each resource type. They will use the resource types output as part of the policy definition variables.
# these variables will be defined in the jinja and passed into each individual policy json definition file
# The policy rules should be the same for each resource type. The only thing that will change is the resource type in the policy definition
# The policy definitions will be created using the jinja template and the resource types output
#
# define variables for the resource types and aliases that have publicNetworkAccess in the jinja template
# The variables will be used for the jinja template to create individual policy definitions for each resource type.
# We can define the Jinja Variables using python
import jinja2
import json

# pna-aliases.json output is the variable that will be used for the jinja template. It will use provider and resource type variables.
# The variables will be path, namespace, and resourceType.
# The jinja definition is defined below
#
template = """{
    "policyDefinitionMode": "All",
    "parameters": {
        "effect": {
            "type": "String",
            "metadata": {
                "displayName": "Effect",
                "description": "Enable or disable the execution of the policy"
            },
            "allowedValues": [
                "Audit",
                "Deny",
                "Disabled"
            ],
            "defaultValue": "Audit"
        }
    },
    "policyRule": {
        "if": {
            "allOf": [
                {
                    "field": "type",
                    "equals": "{{ namespace }}/{{ resourceType }}"
                },
                {
                    "field": "{{ namespace }}/{{ resourceType }}/publicNetworkAccess",
                    "notEquals": "Disabled"
                }
            ]
        },
        "then": {
            "effect": "[parameters('effect')]"
        }
    }
}"""
# load the pnas-aliases.json file into a variable using python
with open('pna-aliases.json') as f:
    data = json.load(f)
# define the jinja template
template = jinja2.Template(template)
# loop through the data variable and define the variables for the jinja template
for item in data:
    namespace = item.split('/')[0]
    resourceType = item.split('/')[1]
    # render the jinja template and output the policy definition json file
    output = template.render(namespace=namespace, resourceType=resourceType)
    # write the output to a file
    with open('pna-{}.json'.format(resourceType), 'w') as f:
        f.write(output)
        


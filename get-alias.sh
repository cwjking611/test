# # Step 1 - Get all the Azure Resource Types using the Azure CLI Rest Commands
# Step 2 - Get the Azure Resource Type Aliases using the Azure CLI Rest Commands
# Step 3 - Get the Azure Resource Types and Aliases in a single list
# Step 4 - Get the Azure Resource Types and Aliases in a single list, sorted by the Azure Resource Type

# Step 1 - Get all the Azure Resource Types using the Azure CLI Rest Commands
# https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups/list#resourcegroups_list
az rest --method get --uri "https://management.azure.com/providers?api-version=2019-10-01" > providers.json

# Step 2 - Get the Azure Resource Type Aliases using the Azure CLI Rest Commands
# https://docs.microsoft.com/en-us/rest/api/resources/providers/list#providers_list
az rest --method get --uri "https://management.azure.com/providers/Microsoft.Resources?api-version=2019-10-01" > provider.json

# Step 3 - Get the Azure Resource Types and Aliases in a single list
# https://docs.python.org/3/tutorial/datastructures.html
python3 -c "import json; providers = json.load(open('providers.json')); provider = json.load(open('provider.json')); print(json.dumps(providers['value'] + provider['resourceTypes']))" > providersAndResourceTypes.json

# Step 4 - Get the Azure Resource Types and Aliases in a single list, sorted by the Azure Resource Type
# https://docs.python.org/3/tutorial/datastructures.html
python3 -c "import json; providersAndResourceTypes = json.load(open('providersAndResourceTypes.json')); print(json.dumps(sorted(providersAndResourceTypes, key=lambda k: k['resourceType'])))" > providersAndResourceTypesSorted.json
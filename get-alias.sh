# Run a command to create a list of name space providers from azure using az rest


# Get the list of providers
az rest --method get --uri https://management.azure.com/providers?api-version=2019-05-01 | jq '.value[].namespace' | tr -d '"' > providers.txt

# Now get the list of resource Types and their aliases
while read provider; do
    az rest --method get --uri https://management.azure.com/providers/$provider?api-version=2019-05-01 | jq '.resourceTypes[].aliases[].name' | tr -d '"' | sed 's/^/'$provider' /' >> aliases.txt
done < providers.txt

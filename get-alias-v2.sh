#!/bin/bash

# Run a command to create a list of name space providers from azure using az rest


# Get the list of providers
az rest --method get --uri https://management.azure.com/providers?api-version=2019-05-01 | jq '.value[].namespace' | tr -d '"' > providers.txt

# Now get a list of resource types and append the provider name to the front of the resource type use azure cli provider command


# Now get the list of resource Types and their aliases
while read provider; do
    az rest --method get --uri https://management.azure.com/providers/$provider?api-version=2019-05-01 | jq '.resourceTypes[].aliases[].name' | tr -d '"' | sed 's/^/'$provider' /' >> aliases.txt
done < providers.txt

# Now sort the list of aliases and remove duplicates
sort aliases.txt | uniq > aliases-sorted.txt

# Now remove the providers.txt and aliases.txt files
rm providers.txt aliases.txt

# Now create the alias file as a json file in list format of namespace.provider/resourceType/alias
echo "[" > alias.json
while read line; do
    echo "  \"$line\"," >> alias.json
done < aliases-sorted.txt
echo "]" >> alias.json

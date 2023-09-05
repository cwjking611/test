bash
# Query Azure Providers for alias found in alias-list.txt
alias_list=$(cat alias-list.txt)
# Get a list of the supported resources types in the alias-list from every Azure Provider
for alias in $alias_list; do
    az provider show --namespace $(echo $alias | cut -d'/' -f1) --query resourceTypes[].resourceType --output tsv | grep -i $(echo $alias | cut -d'/' -f2) >> alias-resource-types.txt
    echo "Alias $alias processed"
done

bash
# Query Azure Providers for alias found in alias-list.txt
alias_list=$(cat alias-list.txt)
echo "Querying Azure Providers for alias found in alias-list.txt"
# Get a list of the supported resources types in the alias-list from every Azure Provider
for alias in $alias_list; do 
    echo "Querying Azure Provider for namespace: $(echo $alias | cut -d'/' -f1) for resourceType: $(echo $alias | cut -d'/' -f2)"
    az provider show --namespace $(echo $alias | cut -d'/' -f1) --query resourceTypes[].resourceType --output tsv | grep -i $(echo $alias | cut -d'/' -f2) >> alias-resource-types.txt
done
echo "Done querying Azure Providers for alias found in alias-list.txt"
# test
Test repo
# To Do
1. Create a python script that creates a list of resources used in your azure tenant that support the `publicNetworkAccess` alias
2. The python script create a dynamic list of supported resources types will will create policy definition json files for `publicNetworkAccess`
3. The pyhon script will use Azure CLI Rest commands to perform the task
4. The JSON files will be created in a directory called `policyDefinitions/internet-exposed`
5. After the variables are parsed through the Jinja templates the python script will then create a unique policy definition for each resource type that has an alias for `publicNetworkAccess`


# we can make a list of providers to loop through by using the following command and store it as a variable like below
providers=$(az provider list --query [].namespace --output tsv)
# we can loop through the list of providers and query each provider for the list of resource types that have an alias for publicNetworkAccess
for provider in $providers; do az provider show --namespace $provider --query resourceTypes[].resourceType --output tsv | grep -i publicNetworkAccess >> pna-aliases.txt; done
# you can do this with jq as well output as json
for provider in $providers; do az provider show --namespace $provider --query resourceTypes[].resourceType --output json | jq -r '.[] | select(.aliases[] | contains("publicNetworkAccess"))' >> pna-aliases.txt; done
# you can also do this with jq and output as tsv
az provider list --query [].namespace --output tsv | xargs -I {} az provider show --namespace {} --query resourceTypes[].resourceType --output tsv | grep -i publicNetworkAccess > pna-aliases.txt
# A python function using azure rest can do the same thing
import requests
import json
import os
import sys
import argparse
import logging
import time
import datetime
import re
import jinja2
from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.resource.resources.models import ProviderResourceType
from azure.mgmt.resource.resources.models import Provider


# define the variables
subscription_id = os.environ["AZURE_SUBSCRIPTION_ID"]
credential = DefaultAzureCredential()
client = ResourceManagementClient(credential, subscription_id)
providers = client.providers.list()
# loop through the providers and get the list of resource types that have an alias for publicNetworkAccess
for provider in providers:
    for resource_type in provider.resource_types:
        if resource_type.aliases:
            for alias in resource_type.aliases:
                if alias == "publicNetworkAccess":
                    print(resource_type.resource_type)
# Create a list of providers that are not allowed

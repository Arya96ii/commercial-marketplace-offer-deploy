# Commercial Marketplace Offer Deployment Manager (MODM)

MODM Development CLI library


## Package building

```
# packaged using 1st party VM offer
modm package build \
    --name "simple terraform app" \
    --description "Simple Terraform application template that deploys a storage account" \
    --version v2.0.0 \
    --main-template build/managedapp/terraform/simple/templates/main.tf \
    --create-ui-definition build/managedapp/terraform/simple/createUiDefinition.json \
    --out-dir ./bin

# packaged using vmi reference
modm package build \
    --name "simple terraform app" \
    --description "Simple Terraform application template that deploys a storage account" \
    --version v2.0.0 \
    --vmi-reference true \
    --main-template build/managedapp/terraform/simple/templates/main.tf \
    --create-ui-definition build/managedapp/terraform/simple/createUiDefinition.json \
    --out-dir ./bin

# packaged using vmi reference id that will be used directly
modm package build \
    --name "simple terraform app" \
    --description "Simple Terraform application template that deploys a storage account" \
    --version v2.0.0 \
    --vmi-reference-id /subscriptions/31e9f9a0-9fd2-4294-a0a3-0101246d9700/resourceGroups/modm-dev-vmi/providers/Microsoft.Compute/galleries/modm.dev.sig/images/modm/versions/0.1.96 \
    --main-template build/managedapp/terraform/simple/templates/main.tf \
    --create-ui-definition build/managedapp/terraform/simple/createUiDefinition.json \
    --out-dir ./bin
```

## resources file

```
modm util create-resources-archive -v 2.0.0 -t ./templates -f src/Functions/Functions.csproj -o ./dist

# reference the resource file directly
modm package build \
    --name "simple terraform app" \
    --description "Simple Terraform application template that deploys a storage account" \
    --resources-file ./dist/resources-v2.0.0.tar.gz \
    --vmi-reference-id /subscriptions/31e9f9a0-9fd2-4294-a0a3-0101246d9700/resourceGroups/modm-dev-vmi/providers/Microsoft.Compute/galleries/modm.dev.sig/images/modm/versions/0.1.96 \
    --main-template build/managedapp/terraform/simple/templates/main.tf \
    --create-ui-definition build/managedapp/terraform/simple/createUiDefinition.json \
    --out-dir ./bin
```
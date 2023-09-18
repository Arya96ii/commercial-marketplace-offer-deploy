#!/bin/bash

# Check if all required parameters are provided
if [ $# -ne 3 ]; then
  echo "Usage: $0 <managed_app_version> <deployed_image_reference> <scenario_name>"
  exit 1
fi

MANAGED_APP_VERSION="$1"

echo "creating directories in $(pwd)"
mkdir -p ./obj
mkdir -p ./bin

#DEPLOYED_IMAGE_REFERENCE="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$GALLERY_RESOURCE_GROUP/providers/Microsoft.Compute/galleries/$GALLERY_NAME/images/$GALLERY_IMAGE_DEFINITION/versions/$GALLERY_IMAGE_VERSION"
DEPLOYED_IMAGE_REFERENCE="$2"
echo "The deployed image reference is: $DEPLOYED_IMAGE_REFERENCE"
UIDEF_FILE="./build/managedapp/createUiDefinition.json"
TEMP_FILE="./obj/createUiDefinition.json"


# Assign the Reader role to the Managed Application Service Principal
az role assignment create --assignee c3551f1c-671e-4495-b9aa-8d4adcd62976 --role acdd72a7-3385-48ef-bd42-f606fba81ae7 --scope "$DEPLOYED_IMAGE_REFERENCE"

# Use sed to replace <IMAGE_REFERENCE> with the DEPLOYED_IMAGE_REFERENCE
# The -i option has issues with certain platform implementations of the sed command,
# so we use a temporary file for the output and then overwrite the original file
rm $TEMP_FILE 2> /dev/null
sed "s|<IMAGE_REFERENCE>|$DEPLOYED_IMAGE_REFERENCE|g" "$UIDEF_FILE" > "$TEMP_FILE"

rm ./obj/mainTemplate.json 2> /dev/null
cp -f ./build/managedapp/mainTemplate.json ./obj/mainTemplate.json
#cp -f ./build/managedapp/content.zip ./obj/content.zip

echo "The ./obj directory contains: $(ls -la ./obj)"

scenario_name="$3"
echo "The scenario name is: $scenario_name"
# Zip up the package for the managed application
./build/managedapp/createAppZip.sh $scenario_name

# Create the Service Definition
STORAGE_ACC_RESOURCE_GROUP=$MANAGED_APP_STORAGE_RG
STORAGE_ACC_NAME=$MANAGED_APP_STORAGE_NAME
BUILDNUM=$(echo "$MANAGED_APP_VERSION" | awk -F. '{print $3}')
STORAGE_CONTAINER_NAME="modm$BUILDNUM"
MA_RESOURCE_GROUP=$STORAGE_ACC_RESOURCE_GROUP
MA_DEFINITION_NAME="modm$MANAGED_APP_VERSION"

./build/managedapp/createServiceDefinition.sh $STORAGE_ACC_RESOURCE_GROUP $STORAGE_ACC_NAME $STORAGE_CONTAINER_NAME $MA_RESOURCE_GROUP $MA_DEFINITION_NAME

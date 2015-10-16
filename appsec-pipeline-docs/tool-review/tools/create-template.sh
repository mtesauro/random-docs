#!/bin/bash

# Create template function
function create_template {
    name=$(echo ${2} | tr '~' ' ')
    file="$1.md"
    echo "Writing $name in current directory..."
    # TODO: Check if file already exists
    echo "## $name" >> $file
    echo "" >> $file
    echo "### Description" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### URL" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### Pipeline Position" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### Tool Type" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### License" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### API Coverage" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### API Type" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### API Docs" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### Cloud Scalable" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### Run as a Service" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### Pipeline Example" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### Client Libraries" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### CI/CD Plugins" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### Data Sent to the Cloud" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "### Last Evaluated" >> $file
    echo "" >> $file
    echo `date -R` >> $file
    echo "" >> $file
    echo ""
    echo "Done"
}

echo "Creating AppSec Pipeline Tool Review template"
echo ""

echo "Please enter the tools name: "
read n
echo "You entered: $n"
echo ""

# Translate " " to "-" for $name so function args work as expected
name="$(echo ${n} | tr ' ' '-')"


while true; do
    read -p "Do you wish to create template $name.md? (Y/N) " yn
    case $yn in
        [Yy]* ) create_template $name $(echo ${n} | tr ' ' '~'); break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y, Y or n, N.";;
    esac
done


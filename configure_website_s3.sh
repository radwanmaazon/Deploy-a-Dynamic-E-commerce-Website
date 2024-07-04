#!/bin/bash

bucket_name="vat-06-radwan-varrow"
bucket_created_name=`aws s3 ls |cut -f3  -d" " >> s3_buckets`  # by grep 
project_path="/media/radwan/2B90ADD55266CE5B1/Projects/Terraform/VAT-06/kool_form"

# This condition to check if bucket name is not exe\ist to create it.
if grep -Fxq "$bucket_name" "./s3_buckets"; then
    echo "$bucket_name is exist"
else
    aws s3api create-bucket --bucket $bucket_name
fi
rm s3_buckets

read -p "Do you wand to Copy your code to s3 bucket (y/n): " response

if [ $response == "y" ] || [ $response == "Y" ]; then
    # Copy my static website files
    echo "Copying data to $bucket_name bucket"
    aws s3 sync $project_path s3://$bucket_name/     
    echo "Data copied to $bucket_name bucket"
else 
    echo "Data not updated "
fi
# This command to allow public access 
aws s3api put-public-access-block --bucket $bucket_name  --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false

# Permission by ACLs
aws s3api put-bucket-policy --bucket $bucket_name --policy file://bucket-policy.json

# Configure Index and error
aws s3 website s3://$bucket_name --index-document index.html --error-document 404.html
echo -e "\nMain page and error page are configured\n"

read -p "Do you wand to remove s3 (y/n): " response

if [ $response == "y" ] || [ $response == "Y" ]; then
    aws s3 rm s3://$bucket_name --recursive   # To permenantly delete for all file in this bucket 
    aws s3api delete-bucket --bucket $bucket_name 
    echo "$bucket_name is deleted"
else 
    echo "Thanks! "
fi


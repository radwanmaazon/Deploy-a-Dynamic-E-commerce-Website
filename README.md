# S3 Static Website with AWS-CLI
This is bash script to Create s3 bucket and host static website and give it appropriate permissions.

To run script 
``` sh
    chmod +x configure_website_s3.sh
    ./configure_website_s3.sh
```
# to run in separate commands
#### first should export your variables 
``` sh
    export bucket_name="vat-06-radwan-varrow"
    export project_path="/media/radwan/2B90ADD55266CE5B1/Projects/Terraform/VAT-06"
```

## Create s3 bucket 
``` sh
    aws s3api create-bucket --bucket $bucket_name
```
## To set the public access block configuration on your S3 bucket.
``` sh
    aws s3api put-public-access-block --bucket $bucket_name  --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
```
## To set a bucket policy on your S3 bucket.
``` sh
    aws s3api put-bucket-policy --bucket $bucket_name --policy file://bucket-policy.json
```
## To sync your local project directory to an S3 bucket 
``` sh 
    aws s3 sync $project_path s3://$bucket_name/kool_form/
```
## To configure your S3 bucket as a static website
``` sh
    aws s3 website s3://$bucket_name --index-document index.html --error-document 404.html
```
# To cleanup your s3 bucket 
## For permenantly delete for all file in this bucket
``` sh 
    aws s3 rm s3://$bucket_name --recursive
```
## delete the bucket 
``` sh
    aws s3api delete-bucket --bucket $bucket_name 
```
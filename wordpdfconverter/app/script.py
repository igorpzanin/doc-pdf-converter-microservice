import os
import subprocess
import boto3

# Input folder ( .doc/.docx files)
input_folder = '/app/tmp/'
# Output folder (.pdf files)
output_folder = '/app/pdf/'
# S3 bucket name
bucket_name = 'YourS3Bucket'

# AWS credentials
aws_access_key_id = 'YourAcessKeyID'
aws_secret_access_key = 'YourSecretAcessKey'

# Initialize S3 client with credentials
session = boto3.Session(
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
)
s3_client = session.client('s3')

# Create output folder if it doesn't exist
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# Check all files in input folder
for filename in os.listdir(input_folder):
    input_file = os.path.join(input_folder, filename)

    # Check if the file is .doc or .docx
    if input_file.lower().endswith(('.doc', '.docx')):
        # Create the output file name with .pdf extension
        output_file = os.path.join(output_folder, f'{os.path.splitext(filename)[0]}.pdf')

        # Execute unoconv command to convert the file
        subprocess.run(['unoconv', '-f', 'pdf', '-o', output_file, input_file])

        print(f'File converted to PDF: {output_file}')

        # Remove the file from the tmp folder after conversion
        os.remove(input_file)
        print(f'File removed: {input_file}')

        # Upload the converted file to the S3 bucket
        with open(output_file, 'rb') as file:
            s3_client.upload_fileobj(file, bucket_name, f'pdf/{os.path.basename(output_file)}')
        print(f'File uploaded to S3 bucket: pdf/{os.path.basename(output_file)}')
    else:
        print(f'Unsupported file format: {input_file}. Only .doc, .docx are supported.')
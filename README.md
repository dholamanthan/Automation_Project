This is developed for autmation of the HTTPD - Apache2 server logs to export it to aws s3 bucket.

You can add this script when creating instance.

What this script does :
1. Install apache2 if not installed
2. Automatically enable apache2 on server start/restart
3. Tar/Zip apache server logs(error,access and others)
4. Move the zip /tmp folder
5. Export the tar to s3 bucket

Requirements :

OS - Ubuntu 18.4 LTS

Instructtion :

- This file needs preconfigured AWS CLI installed and configured with Access Key.

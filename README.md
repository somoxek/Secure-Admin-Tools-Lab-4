# Secure Admin Tools - Lab 4 Bash
#### Author: Dominik Hackl
These scripts are used to archive and encrypt given user folders and to restore them.

## Prerequisites
Make sure you have execute rights on the scripts.

## Backup
### Description
This script is used to archive and encrypt one or more user folders.
The resulting `.tar.gz.enc`-files are saved under `/tmp`. If no user-folder is specified, the currently logged on user will be used.

Before creating the backup-file a password is requested, which will be used to encrypt the resulting file.

The script checks if the number of files and directories in the backup-file have the same count as in the user-folder. Only if the results are the same, the backup is successful.

### Usage
`./backup.sh [<user-folder 1> <user-folder 2> <user-folder 3> ... ]`

### Example
`./backup.sh`
> Backups the user-folder of the currently logged in user.

`./backup.sh mmustermann`
> Backups the user-folder of mmustermann.

`./backup.sh mmustermann emustermann`
> Backups the user-folder of mmustermann and emustermann.

## Restore
### Description
This script is used to restore a given backup file which was created and encrypted with the backup script. The unzipped folder will be placed where the script is executed.

### Usage
`./restore_backup.sh <File>`

### Example
`./restore_backup.sh /tmp/mmustermann_2021-05-04_16-54-04.tar.gz.enc`

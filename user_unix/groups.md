# Create a group and add users to it
In this document you will find instructions on how to create a user-group, add permissions to selected directories, and add users to that group.

## Create a group
Note that only users with sudo privileges can create and manage groups.
To check the already available groups, use:
```
getent group
```
To create a new group:
```
sudo addgroup <group_name>
```

## Assign users to that group
There are two steps necessary.
First you need to add the user to the group.
```
sudo usermod -a -G <group_name> <user_name>
```
Then you need to log out and log back in that user
```
exit
```
Sometimes it may be necessary to reboot the machine
```
sudo shutdown -r now
```
Finally, to check that everything worked, you can check the groups of that user with:
```
id <user_name>
```

## Assign directories to that group, and give permissions
This is necessary to allow people assigned to the group to have the desired permissions.
To assign a directory to a group (-R is recursively applied to all subdirectories):
```
sudo chgrp -R <group_name> <path to dir>
```
Then we need to give the desired permissions to that group
```
sudo chmod -R g+rwx <path to dir>
```



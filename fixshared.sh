# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "Please make sure to run this as root or sudo" 1>&2
   exit 1
fi

## CREDIT:
## +flamethrower1982 @flamethrower82
## You're welcome to use my script. You can even borrow my file structure
## if you find it useful.
##
## If you have any questions, message me on Twitter @flamethrower82
##
## GNU Standard License 3.0
##
## Written summer 2016
##
## You are free to distribute, just please make sure to keep my original
## comment if you modify it.

# Define main user and public folders
USEREDIT=user
SHARED=shared

# Fix Shared Files
echo "Administrator taking ownership of files..."
chown -R -v root /home/$SHARED/*
echo "Users group taking group ownership of all files..."
chgrp -R -v users /home/$SHARED/*
echo "Administrator and Users can read, write, and execute or open files..."
chmod -R -v ug+rwx /home/$SHARED/*
echo "All Others are denied write access..."
chmod -R -v o-w /home/$SHARED/*
echo "All Others can read and execute..."
chmod -R -v o+rx /home/$SHARED/*

# User owns user files
echo "$USEREDIT owns $USEREDIT's files"
chown -R -v robert /home/$USEREDIT/*
chgrp -R -v users /home/$USEREDIT/*
chmod -R -v u+rwx /home/$USEREDIT/*
chmod -R -v g+rx /home/$USEREDIT/*
chmod -R -v o-rwx /home/$USEREDIT/*

# Add user to Users Group (100)
adduser $USEREDIT users

# Make sure files are UTF-8
convmv -r -f windows-1252 -t UTF-8 /home/$USEREDIT/*
convmv -r -f windows-1252 -t UTF-8 /home/$SHARED/*

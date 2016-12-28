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
## It's a good idea to un-comment the fixshared.sh after downloading that
## Script. You can find it on my GitHub channel.
##
## If you have any questions, message me on Twitter @flamethrower82
##
## GNU Standard License 3.0
##
## Written 12/28/2016
##
## You are free to distribute, just please make sure to keep my original
## comment if you modify it. Please leave contact info and modified date
## in modified lines and/or sections

# Set NOW variable to date and time
NOW=$(date+"_%H.%M.%S-on-%m-%e-%Y")
HOMEDIR="/home"
SHAREDDIR="/home/shared"
LOGDIR="/home/shared/backup"
BACKUP1="/backup/home"
BACKUP2="/backup/shared"
FILE="/home/shared/fixshared.sh"

# create backup report
touch $LOGDIR/backup-report-$NOW.txt

# fix file permissions and encoding
#if [ -f $FILE ];
#then
#   echo "Running script $FILE to check file permissions and encoding"
#   sh -c /home/shared/fixshared.sh
#else
#   echo "Please locate fixshared.sh and move it to /home/shared before running #this script"
#   exit 1
#fi

echo "Accounting for changes from Windows" >> $LOGDIR/backup-report-$NOW.txt
echo "" >> $LOGDIR/backup-report-$NOW.txt

# Downloads from Windows
if [ -d $BACKUP2/downloads/Windows ];
then
    echo "Windows download directory exists. Syncing..."
    cd $BACKUP2/downloads/Windows
    rsync -vziru --ignore-errors --human-readable --modify-window=7 --progress --delete-excluded --itemize-changes --partial --exclude '.Trash-'  --log-file=$LOGDIR/backup-rsync-$NOW.txt . $SHAREDDIR/downloads/Windows
    cat $LOGDIR/backup-rsync-$NOW.txt >> $LOGDIR/backup-report-$NOW.txt
    echo "" >> $LOGDIR/backup-report-$NOW.txt

else
   echo "Windows download directory does not exist on backup drive. Skipping..."
fi

# Steam for Windows
if [ -d $BACKUP2/RegGames/SteamLibrary-Win];
then
    echo "Steam library exists. Syncing..."
    cd $BACKUP2/RegGames/SteamLibrary-Win
    rsync -vziru --ignore-errors --human-readable --modify-window=7 --progress --delete-excluded --delete --itemize-changes --partial --exclude '.Trash-'--log-file=$LOGDIR/backup-rsync-$NOW.txt . $SHAREDDIR/RegGames/SteamLibrary-Win
cat $LOGDIR/backup-rsync-$NOW.txt >> $LOGDIR/backup-report-$NOW.txt
    echo "" >> $LOGDIR/backup-report-$NOW.txt

else
   echo "Steam library does not exist on backup drive. Skipping..."
fi

# GOG for Windows
if [ -d $BACKUP2/RegGames/GOG ];
then
    echo "Good Old Games library exists. Syncing..."
    cd $BACKUP2/RegGames/GOG
    rsync -vziru --ignore-errors --human-readable --modify-window=7 --progress --delete-excluded --delete --itemize-changes --partial --exclude '.Trash-'--log-file=$LOGDIR/backup-rsync-$NOW.#txt . $SHAREDDIR/RegGames/GOG
    cat $LOGDIR/backup-rsync-$NOW.txt >> $LOGDIR/backup-report-$NOW.txt
    echo "" >> $LOGDIR/backup-report-$NOW.txt

else
   echo "Good Old Games library does not exist on backup drive. Skipping..."
fi

# Origin for Windows
if [ -d $BACKUP2/RegGames/Origin ];
then
    echo "Origin (Electronic Arts) library exists. Syncing..."
    cd $BACKUP2/RegGames/Origin
    rsync -vziru --ignore-errors --human-readable --modify-window=7 --progress --delete-excluded --delete --itemize-changes --partial --exclude '.Trash-' --log-file=$LOGDIR/backup-rsync-$NOW.txt . $SHAREDDIR/RegGames/Origin
    cat $LOGDIR/backup-rsync-$NOW.txt >> $LOGDIR/backup-report-$NOW.txt
    echo "" >> $LOGDIR/backup-report-$NOW.txt

else
   echo "Origin (Electronic Arts) library does not exist on backup drive. Skipping..."
fi

# Linux home directories on /dev/sdc1
echo "Backing up Linux users home directory $HOMEDIR to external drive $BACKUP1" >> $LOGDIR/backup-report-$NOW.txt
cd $HOMEDIR
rsync -vziru --ignore-errors --human-readable --modify-window=7 --progress --delete-excluded --exclude '.Trash-' --exclude 'tmp' --exclude '.cache' --exclude 'cache' --exclude 'akonadi' --exclude 'Cache' --exclude 'shared' --exclude '.thumbnails' --exclude 'dvr-svc' --itemize-changes --partial --log-file=$LOGDIR/backup-rsync-$NOW.txt . $BACKUP1
cat $LOGDIR/backup-rsync-$NOW.txt >> $LOGDIR/backup-report-$NOW.txt
echo "Backed up Linux users home directory" >> $LOGDIR/backup-report-$NOW.txt
echo "" >> $LOGDIR/backup-report-$NOW.txt

# Linux shared directories on /dev/sdc2
echo "Backing up Linux shared directory to external drive $BACKUP2" >> $LOGDIR/backup-report-$NOW.txt
cd $SHAREDDIR
rsync -vziru --ignore-errors --human-readable --modify-window=7 --progress --delete-excluded --exclude '.Trash-' --exclude 'tmp' --exclude '.cache' --exclude 'cache' --exclude 'akonadi' --exclude 'Cache' --itemize-changes --partial --log-file=$LOGDIR/backup-rsync-$NOW.txt . $BACKUP2 
cat $LOGDIR/backup-rsync-$NOW.txt >> $LOGDIR/backup-report-$NOW.txt
echo "Backed up Linux shared directory $SHAREDDIR to external drive $SHAREDDIR" >> $LOGDIR/backup-report-$NOW.txt
echo "" >> $LOGDIR/backup-report-$NOW.txt

# Record current drive space
echo "Current drive available space:" >> $LOGDIR/backup-report-$NOW.txt
df -h >> $LOGDIR/backup-report-$NOW.txt

# Record directory storage use
echo "Backup drive use for home"
du -d 1 -h $BACKUP1 >> $LOGDIR/backup-report-$NOW.txt
echo "Backup drive use for shared"
du -d 1 -h $BACKUP2 >> $LOGDIR/backup-report-$NOW.txt

echo "Fixing permissions..." >> $LOGDIR/backup-report-$NOW.txt
$SHAREDDIR/fixshared.sh
df -HhlT >> $LOGDIR/backup-report-$NOW.txt

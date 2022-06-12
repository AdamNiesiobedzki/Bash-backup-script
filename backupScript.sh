#!/bin/bash
BACKUPTIME=$(date +%Y.%m.%d.%H.%M.%S)
while getopts a:b: OPT; do
	case "$OPT" in 
		a) BACKUPDIR=$OPTARG;;
		b) DESTINATION=$OPTARG;;
	esac
done

if [ -z "$BACKUPDIR" ]
then
	echo "wrong arguments"
	exit 0
elif [ -z "$DESTINATION" ]
then
	echo "wrong arguments"
	exit 0
fi
echo $BACKUPTIME
tar -cvf $DESTINATION"/"$BACKUPTIME".tar" $BACKUPDIR






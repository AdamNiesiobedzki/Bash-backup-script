#!/bin/bash
while getopts a:b: OPT; do
	case "$OPT" in 
		a) DIR=$OPTARG;;
		b) TIMETODELETE=$OPTARG;;
	esac
done
echo halo $TIMETODELETE

if [ -z $DIR ]
then
	echo "Wrong arguments"
elif [ -z $TIMETODELETE ]
then 
	echo "Wrong arguments11"
else
	find $DIR -mmin '+'$TIMETODELETE -type f -exec rm -fv {} \;
fi

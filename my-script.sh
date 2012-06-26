#!/bin/sh

echo 'starting'
lookDir='/media/HITACHI/finished'
videoDir='/media/HITACHI/videos'

run_extractor()
{
FULLFILEPATH=$1
echo 'Running on ' $FULLFILEPATH

if unrar t $f 2>&1 >/dev/null
then
        newDir=`basename $FULLFILEPATH`
        oldDir=`dirname $FULLFILEPATH`
        mkdir $newDir
        echo 'success in testing ' $f
        unrar e -y $f $newDir
	mv $newDir/*.mkv $videoDir
	mv $newDir/*.mp4 $videoDir
	mv $newDir/*.avi $videoDir
	if [ "$(ls -A $newDir)" ]; then
	     echo 'Directory not empty, keeping ' $newDir
	else
	    echo $newDir 'is Empty, removing.'
	    rm -rf $newDir	
	fi
	
	if [ "$lookDir" != "$oldDir" ];
	then
        	mv $FULLFILEPATH $FULLFILEPATH.done
		mv $oldDir /mnt/vol1/torrents/old/$newDir.done 
        	--rm -rf $oldDir
	else
		mv $FULLFILEPATH /mnt/vol1/torrents/old/$newDir.done
	fi

else
        echo "\n  TEST FAILED FOR " $FULLFILEPATH
fi
}

if ps -ef | grep -v grep | grep -v unrarall | grep unrar ; then
  message error "unrar is allready running. Please only run this script once"
  exit 0
fi

cd /media/HITACHI/finished/

for f in `find $lookDir -type f -name '*.part01.rar'`
do
run_extractor $f
done

for f in `find $lookDir -type f -name '*.part001.rar'`
do
run_extractor $f
done

for f in `find $lookDir -type f -name '*.rar'`
do
run_extractor $f
done

echo 'Done'


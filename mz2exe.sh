#!/bin/bash
FILE="$1"   #parameter 1 = filename
OUTPUT="$2" #parameter 2 = output filename
#for instance where exe is embedded in file

findMZ=$(cat $FILE | head -c2)

if [ $findMZ == "MZ" ]; then
	echo "This is already an executable. No need for conversion"
	echo "MD5 Hash: $(md5sum $FILE)"
	echo "SHA 1 Hash: $(sha1sum $FILE)"
	echo "SHA 256 Hash: $(sha256sum $FILE)"
elif [ $findMZ == "4D" ] || [ $findMZ == '4d' ]; then
	if [ $(cat $FILE | head -c4) == "4D5A" ] || [ $(cat $FILE | head -c5) == "4D 5A" ] || [ $(cat $FILE | head -c4) == "4d5a" ] || [ $(cat $FILE | head -c5) == "4d 5a" ] ; then #looks for MZ
		echo "Pulling out EXE from file"
		cat $FILE | xxd -p -r > $OUTPUT.exe #will turn the file you have to the exe that it is supposed to be if it has the MZ header

		filename=$(file $OUTPUT.exe)
		if [[ "$filename" =~ "DLL" ]]; then #if file is DLL instead change the file to DLL
			mv $OUTPUT.exe $OUTPUT.dll
			echo "You have a DLL. You might want to put this in the PE Explorer to see what libraries have been accessed and who else has this on ECAT"
			echo "Your file: $filename"
			echo "MD5 Hash: $(md5sum $OUTPUT.dll)"
			echo "SHA 1 Hash: $(sha1sum $OUTPUT.dll)"
			echo "SHA 256 Hash: $(sha256sum $OUTPUT.dll)"
		else
			echo "You have a EXE."
			echo "Your file: $filename"
			echo "MD5 Hash: $(md5sum $OUTPUT.exe)"
			echo "SHA 1 Hash: $(sha1sum $OUTPUT.exe)"
			echo "SHA 256 Hash: $(sha256sum $OUTPUT.exe)"
		fi
		echo "Check this file against Virus Total. If no results come up try to sandbox the exe (i.e. cuckoo sandbox)"
	fi
fi

#!/usr/bin/bash
for i in {A..Z}
#for i in {A..A}
do
	if [ "$i" == "P" ]; then i="P-Q"; elif [ "$i" == "Q" ]; then continue
	elif [ "$i" == "U" ]; then i="U-V"; elif [ "$i" == "V" ]; then continue
	elif [ "$i" == "W" ]; then i="W-X"; elif [ "$i" == "X" ]; then continue
	elif [ "$i" == "Y" ]; then i="Y-Z"; elif [ "$i" == "Z" ]; then continue
	fi
	cmd="curl -o ${i}.html https://en.wikipedia.org/wiki/List_of_minerals_recognized_by_the_International_Mineralogical_Association_($i)"
	echo $cmd
	if [ -f ${i}.html ]; then
		echo "Skipping $i"
	else
	$cmd
	fi

	# Find what we are interested in
	firstLine=0
	regexStr="<li><a href[^\>]+([^\<]+)"
	#echo "regex: $regexStr"
	while IFS= read -r line
	do
		if [[ $line =~ ^\<ol ]]; then
			if [ $firstLine == 0 ]; then
				#echo "//START: $line"
				firstLine=1
			fi
		fi
		if [ $firstLine == 1 ]; then
			#echo "TO MATCH: $line"
			echo $line | egrep -oa "$regexStr" | sed -e "s/.*>//" | sed -e "s/\-.*//" >> ${i}.txt
		fi
	done < "${i}.html"
done

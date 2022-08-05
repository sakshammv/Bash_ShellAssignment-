#!/bin/bash

current_time=`date "+%Y-%m-%d %H:%M:%S"`
trap 'catch $LINENO' ERR

catch() {
	echo "$current_time Error in Line: $1" >> errors.log
        echo Script was interrupted at line $1
        exit
}

echo  "What is your component ? INGESTOR/JOINER/WRANGLER/VALIDATOR?"
read input1
if [[ $input1 == "INGESTOR" || $input1 == "JOINER" || $input1 == "WRANGLER" || $input1 == "VALIDATOR" ]]; then
        echo "Component:" $input1
else
        echo "$current_time Invalid Component name" >> errors.log
	
	echo "Please enter valid input"
	exit
fi

echo "What is your scale ? MID/HIGH/LOW?"
read input2
if  [[ $input2 == "MID" || $input2 == "HIGH" || $input2 == "LOW"  ]]; then
        echo "Scale:" $input2
else
       echo "$current_time Invalid Scale" >> errors.log
       	echo "Please enter valid input"
	exit
fi

echo "What you want to do ? AUCTION/BID?"
read input3
if  [[ $input3 == "BID" || $input3 == "AUCTION"  ]]; then
        echo "$current_time Invalid Input" >> errors.log
	echo "You want to "$input3
else
        echo "Please enter valid input"
	exit
fi

echo "What is your count ? 1-9?"
read input4
if  [[ "$input4" =~ ^[1-9]$ ]]; then
	echo "$current_time Error: Range <1-9>" >> errors.log
       	echo "Count is:" $input4
	
else
        echo "Please enter valid input"
	exit
fi

if [[ $input3 == "BID" ]]; then
	input3="vdopiasample-bid"
else
	input3="vdopiasample"
fi

> temp

err=0
for x in $(cat sig.conf); do
	if [[ $(echo $x | awk -F';' '{print $1}') == "$input3" && $(echo $x | awk -F';' '{print $3}') == "$input1" ]]; then
	       	echo "$x" | sed  "s/[0-9]/$input4/g; s/LOW/$input2/g; s/MID/$input2/g; s/HIGH/$input2/g" >> temp
		err=1
	else 
		echo "$x" >> temp
	fi
done

if [[ $err == 0 ]]; then
	echo "$current_time Invalid Input" >> errors.log
	echo "Error: Input not found"
	exit
fi

mv temp sig.conf

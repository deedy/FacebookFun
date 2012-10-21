#!/bin/bash
#Lists all the friends of whoever's graph api friends with access token has been used as $url and saves it to a file FBfriends.txt
echo "Enter Access Code (Obtainable from FB graph API)"
read -e accesscode
url="https://graph.facebook.com/me/friends?fields=name,gender&access_token="$accesscode
sample=`curl $url`


if [ $(echo $sample | wc -c) -lt 500 ]
then 
echo "Invalid"
exit
fi

totalcount=`echo $sample | grep -Eo "\"gender\":\"[^\"]{1,}\"" | sed s/\"gender\":\"//g | tr -d '\"' | wc -l`
femalecount=`echo $sample | grep -Eo "\"gender\":\"[^\"]{1,}\"" | sed s/\"gender\":\"//g | tr -d '\"' | grep "female" | wc -l`
malecount=$(($totalcount - $femalecount))

name=`echo $sample | grep -Eo '\/[[:digit:]]{2,}' | tr -d '\/'`
user_url="https://graph.facebook.com/"$name
user_name=`curl $user_url | grep -Eo "\"name\":\"[^\"]{1,}\"" | sed s/\"name\":\"//g | tr -d '\"' | tr -d ' '`
filename=$user_name"FBgenderstats.txt"


echo "Male Count: "$malecount  > $filename
echo "Female Count: "$femalecount  >> $filename
echo "Total Count: "$totalcount  >> $filename
echo "Female Percentage: "$(echo "scale=2; $femalecount*100/$totalcount" | bc)"%"  >> $filename
echo "Male Percentage: "$(echo "scale=2; $malecount*100/$totalcount" | bc)"%"  >> $filename
clear
echo "DATA SAVED TO "$filename



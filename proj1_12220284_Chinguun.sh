#! /bin/bash

echo "---------------------------------"
echo "User Name : Chinguun"
echo "Student Number: 12220284"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of ‘action’ genre movies from 'u.item’"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’"
echo "4. Delete the ‘IMDb URL’ from ‘u.item’"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "---------------------------------"

while true; 
do	
	read -p "Enter your choice [ 1-9 ] " number
	case $number in
	1)
		echo ""	
		read -p "Please enter the 'movie id'(1~1682) :" movie_id
		echo ""
		awk -F '|' -v movie_id="$movie_id" '$1==movie_id {print}' u.item
		echo ""
		;;
	2)	
		echo ""
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n) :" res
		echo ""
		if [ "$res" == "y" ];
		then
			awk -F '|' '$7==1 {print $1, $2}' u.item | head -n 10
		fi
		echo ""
		;;
	3)
		echo ""	
		read -p "Please enter the 'movie id'(1~1682) :" movie_id
		echo ""
		average=$(awk -v movie_id="$movie_id" '$2==movie_id {sum += $3; count++} END {print sum/count}' u.data)
		roundAverage=$(printf "%.6f" "$average")
		printf "average rating of $movie_id: %.5f" "$roundAverage" 
		echo ""
		echo ""
		;;
	4)
		echo ""
		read -p "Do you want to delete the ‘IMDb URL’ from ‘u.item’?(y/n) :" res
		echo ""
		if [ "$res" == "y" ];
		then
			cat u.item | sed 's/|*|http:[^|]*|/|||/' | head -n 10
		fi
		echo ""
		;;
	5)
		echo ""
		read -p "Do you want to get the data about users from ‘u.user’?(y/n) :" res
		echo ""
		if [ "$res" == "y" ];
		then
			cat u.user | sed 's/^/user /; s/|/ is /; s/|/ years old /; s/M/male /; s/F/female /; s/|//; s/|[0-9]*$//' | head -n 10
		fi
 		echo ""
		;;
	6)
		echo ""
		read -p "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n) :" res
		echo ""
		if [ "$res" == "y" ];
		then
			cat u.item | sed 's/|\([0-9][0-9]\)-\([A-Za-z][A-Za-z][A-Za-z]\)-\([0-9][0-9][0-9][0-9]\)|/|\3\2\1|/; s/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/;' | tail -n 10
		fi
		echo ""
		;;
	7)
		echo ""	
		read -p "Please enter the ‘user id’(1~943) :" user_id
		echo ""
		movie_id=$(awk -v user_id="$user_id" '$1==user_id {print $2}' u.data | sort -n | tr '\n' ' ' | sed 's/ /|/g; s/|$//')
		echo "$movie_id" 
		echo ""
		grep -E "^(($movie_id))\|" u.item | awk -F '|' '{print $1 "|" $2}' | head -n 10
		echo ""
		;;
	8)
		echo ""
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) :" res
		echo ""
		if [ "$res" == "y" ];
		then
			user_ids=$(awk -F '|' '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1}' u.user)
			grep -E "^$user_id\|" u.data | awk -F '|' '{print "Movie ID:", $2, "Rating:", $3}'
		fi
		echo ""
		;;		
	9)
		echo "Bye!"
		echo ""
		exit 0
		;;
	*)
		echo "Invalid number!"
		echo ""
		;;
	esac
done
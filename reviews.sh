#!/bin/bash
#
# Filename: reviews.sh
# Author: Geoff Norman
# Contact: gnorman1@mail.ccsf.edu
# Date: 03/23/20
# Purpose: Utility script to assist in peer reviews for cs131B Intermediate Python at SF City College.
# 

read_file()
{
        if [ -f $1 ]; then
                while read x; do
                        echo
                        echo
                        echo "=========="
                        echo "reading $x"
                        echo "=========="
                        echo
                        cat "$x"
                done < $1
        fi
}

execute_file()
{
        if [ -f $1 ]; then
                while read x; do
                        echo
                        echo 
                        echo "============"
                        echo "executing $x"
                        echo "============"
                        echo
                        python3 "$x"
                done < $1
        fi
}

collect_pr_script_names()
{
	~abrick/tally | tail -15 | grep ^/users > latest.pr
}

write_file()
{
	echo "$2" >> "$2"
    echo -n "PR list generated on: "
	date >> "$2";
	echo >> "$2";
	cat "$1" >> "$2";
	echo >> "$2";
	read_file "$1" >> "$2";
}

manual_pr_list()
{
	if [ -s latest.pr ]; then
		if [[ -n "$1" ]]; then
			echo "generating file: week$1_reference.txt"
			if [ -f "week$1_reference.txt" ]; then
				echo "week$1_reference.txt already exists"
				echo -n "overwrite (y/n)?: ";
				read input;
				if [[ "$input" =~ 'y' ]]; then
					$(rm -f "$output_name")
					echo "generating file: week$1_reference.txt"
					write_file latest.pr "week$1_reference.txt";
				else
					echo "Ok, please try again with another filename."
					exit 0;
				fi
			fi
		else
			echo "generating file: this_weeks_pr_reference.txt";
			> this_weeks_pr_reference.txt
			write_file latest.pr "this_weeks_pr_reference.txt";
		fi
	else
		echo "This week's peer review list appears to be empty!"
		echo "Goodbye!"
		exit 0;
	fi
}

generate_weekpr_list()
{
	collect_pr_script_names

	echo -n "Please enter this week's #, between 1-12: ";
	read week_number;
	output_name="week${week_number}_reference.txt"

	if [ -f "$output_name" ]; then
		echo "$output_name already exists."
		echo -n "Would you like to overwrite it? (y/n): "
		read -n 1 input
		if [ "$input" =~ 'y' ]; then
			$(rm -f "$output_name")
			manual_pr_list "$output_name"

		else
			echo -n "Please choose another week number or enter 'd' for default: "
			read second_try;
			if [ "$second_try" =~ 'd' ]; then
				echo "The default filenames will be 'latest.pr' & 'this_weeks_pr_reference.txt'"
				manual_pr_list
			else
				output_name="week${second_try}_reference.txt"
				echo "This will create the files 'latest.pr' & '$output_name'"
				manual_pr_list "$output_name"
			fi
		fi
	else
		echo "generating $output_name"
		manual_pr_list "$output_name"
	fi
}

help()
{
	cat <<EOF
	File: $(basename "$0")
	usage: <-h> <-g> <-c> <-m:(optional)> <-r: file1> <-e: file1> 

	-h : this help dialog
	-c : outputs this week's pr list to stdout
	-g : if user gives a weeknumber, writes contents of week's pr files to "week{\$x}_reference.txt"
	-m (optional) : -g without interaction, argument changes output filename: "week{\$optional}_reference.txt"
	-r <filename> : read filenames from text file, then read contents of each filename to stdout
	-e <filename> : read filenames from text file, execute each filename

EOF
}

if [ $# -eq 0 ]; then
	echo "Script requires a command line option."
	help
	exit 1;
fi

while getopts ":hcgmr:e:" opt; do
        case $opt in
        		h) help;;
        		c) collect_pr_script_names;;
        		g) generate_weekpr_list;;
        		m) manual_pr_list $2;;
                r) read_file $2;;
                e) execute_file $2;;
                *) echo "Bad option input!"; help; exit 1;;
        esac
done

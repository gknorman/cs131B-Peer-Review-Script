# reviews.sh
Bash utility script to help folks in ccsf's cs131B Intermediate Python perform their weekly Peer Review.

Filename: reviews.sh 

In Repository: https://github.com/gknorman/cs131B-Peer-Review-Script/blob/master/reviews.sh

Author: Geoff Norman

Contact: gnorman1@mail.ccsf.edu

Date: 03/23/20


	File: reviews.sh
	usage: <-h> <-g> <-c> <-m:(optional)> <-r: file1> <-e: file1> 

	-h : this help dialog
	-c : outputs this week's pr list to stdout
	-g : if user gives a weeknumber, writes contents of week's pr files to "week{\$x}_reference.txt"
	-m (optional) : -g without interaction, argument changes output filename: "week{\$optional}_reference.txt"
	-r <filename> : read filenames from text file, then read contents of each filename to stdout
	-e <filename> : read filenames from text file, execute each filename

#! /usr/bin/env bash

# 
# small script to send spam mails using mutt
# @author: Lars Groeber
# 
# Usage:
#       SCRIPTNAME [-T %Y%m%d%H%M] [-t timeInterval-in-min] [-m maxMails]
#                  (-s subject,email,body) | (-f subject,file-with-emails,body)
# 
# Example: SCRIPTNAME -T 201610301200 -t 5 -m 10 -s subject,name@example,body
#           sends 1 mail every 5 minutes to name@example.com starting at 
#           10/30/2016 12:00 until 10 mails are send 
#           
# Use -t 0 to send all emails immediately
# 

# terminate on error
set -e

#### GLOBALS ####

maxMails=5
timeInterval=1  # in minutes
nameOfScript="./LarsGroeber_problem1.sh"
timestamp=`date '+%Y%m%d%H%M'`

usage="\nUsage:\n \t$nameOfScript [-T %Y%m%d%H%M] [-t timeInterval-in-min] [-m maxMails]\n\
\t \t(-s subject,email,body) | (-f subject,file-with-emails,body)\n\
              Defaults: maxMails: $maxMails, timeInterval: $timeInterval"

#### FUNCTIONS ####

# function which sends the mails
# @param: subject
#         email
#         body
function sendMail
{
  echo -e ""
  #echo $3 | mutt -s $1 -- $2
}

# function which waits until a given timestamp is in the past
# @param: timestamp to check with format %Y%m%d%H%M
function checkTimeStamp
{
  secondsDiff=$(( $1 - `date '+%Y%m%d%H%M'` ))
  while test $secondsDiff -gt 0; do
    echo "Waiting..."
    sleep 5
  done
}

# simple implementation, takes only arguments from commandline as inputs
# @param: subject
#         email
#         body
function simple
{
  # split input to -s
  inputArr=( $( echo $1 | sed "s/,/ /g" ) )
  
  if test ${#inputArr[@]} -ne 3; then
    echo "Invalid number of arguments!" >&2
    echo "Usage: -s subject,email,body" >&2
    exit 2
  fi
 
  checkTimeStamp $timestamp

  subject=${inputArr[0]}
  email=${inputArr[1]}
  body=${inputArr[2]}

  for (( i = 1; i <= $maxMails; i++ )); do
    sendMail $subject $email $body
    echo "Send "$i". mail to \""$email"\", going to sleep for "$timeInterval"min."\
         $(($maxMails-$i))" mails left."
    # go to sleep if there are mails left to send
    if test $i -ne $maxMails; then sleep $(( $timeInterval*60 )); fi
  done
}

# this implimentation takes a file with adresses and sends mails to each of them
# and bodys
# @param: subject
#         file-with-emails
#         body
function advanced
{
  inputArr=( $( echo $1 | sed "s/,/ /g" ) )
  
  if test ${#inputArr[@]} -ne 3; then
    echo "Invalid number of arguments!" >&2
    echo "Usage: -f subject,path-to-file,body" >&2
    exit 2
  fi
 
  checkTimeStamp $timestamp

  subject=${inputArr[0]}
  pathToFile=${inputArr[1]}
  body=${inputArr[2]}

  emails=""

  # read file line by line into $emails
  while read -r line; do
    emails="$emails $line"
  done < "$pathToFile"

  emailsArr=( $emails )

  for (( i = 1; i <= $maxMails; i++ )); do
    # here we send one email per entry in file
    for email in ${emailsArr[@]}; do
      sendMail $subject $email $body
      echo "Send "$i". mail to \""$email"\""
    done

    echo -e "Going to sleep for "$timeInterval"min. "$(( $maxMails-$i ))\
            " mails left.\n"
    if test $i -ne $maxMails; then sleep $(( $timeInterval*60 )); fi
  done
}

#### END FUNCTIONS ####

# show usage information if no parameters are specified
if test $# -eq 0; then
  echo -e $usage >&2
  exit 1
fi

cmd=""
param=""

# go through arguments
while getopts "f:s:t:T:m:" opt; do
  case $opt in
    T)
      timestamp=$OPTARG
      ;;
    t)
      timeInterval=$OPTARG
      ;;
    m)
      maxMails=$OPTARG
      ;;
    f)
      cmd="advanced"
      param=$OPTARG
      ;;
    s)
      cmd="simple"
      param=$OPTARG
      ;;
  esac
done

$cmd $param

exit 0
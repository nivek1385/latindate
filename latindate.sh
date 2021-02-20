#!/bin/bash
#Bash script to convert the current date to Latin date including AUC year.
#Author: Kevin Hartley
#Version: 2021-02-19
#Future versions to accept dates other than current date and output formats beyond AUC year.
#Future versions also to include the following holidays:
#   1  APR - Veneralia
#   4-10 APR - Ludi Megalenses
#   12-19 APR - Ludi Cereri\Cerialia
#   9,11,13 MAY - Lemuria, festival of the dead
#   15 May - Mercuralia
#   7 Jun - Ludi Piscatorii
#   7-15 Jun - Vestalia
#   12 JUL - CIC's bday
#   6-13 JUL - Ludi Apollinares
#   18 JUL - dies ater (defeat of Rome by Gauls at the Battle of the Allia in 390BC)
#   23 JUL - Neptunalia
#   2 AUG - Hannibal's defeat at the Battle of Cannae
#   19 OCT - Scipio Africanus defeats Carthage at the Battle of Zama
#   6 May - Crassus killed at the Battle of Carrhae
#   15 MAR - Assassination of CIC
#   23 OCT - Brutus commits suicide 
#   2 SEP - Battle of Actium
#   1 AUG - Antony commits suicide
#   30 AUG - Cleopatra commits suicide
#   19 AUG - Death of Augustus
#   18 JUL - Great Fire of Rome, Nero "fiddles"
#   24 AUG - Vesuvius
#   10 AUG - Hadrian named Trajan's heir
#   4 SEP - Fall of western empire to Odoacer
#   

#Defaults
holidaygreeting=""

day=$(date +%d | sed 's/^0*//')
month=$(date +%b)
year=$(date +%Y)

#day=21
#month="Apr"
#year=2016

main() {
  one="1"
  case $month in
    "Mar"|"May"|"Jul"|"Oct")
      ides=15
    ;;
    *)
      ides=13
    ;;
  esac
  nones=$((ides-8))

  if [[ $day == "$one" || $day == "$nones" || $day == "$ides" ]]; then
    ablmonth
    if [[ $day == "$one" ]]; then
      latindate="Hodie est Kalendis $latmon "
    elif [[ $day == "$nones" ]]; then
      latindate="Hodie est Nonis $latmon "
    elif [[ $day == "$ides" ]]; then
      latindate="Hodie est Idibus $latmon "
    else
      echo "ERROR: day variable isn't 1, Nones, or Ides, but was at one point."
    fi
  elif [[ $day -ge 2 && $day -lt $((nones - one)) ]]; then
    accmonth
    num=$((nones - day + one))
    num=$(./num2roman.sh $num)
    num=$(echo "$num" | tr '[:upper:]' '[:lower:]')
    latindate="Hodie est ante diem $num Nonas $latmon "
  elif [[ $day -gt $nones && $day -lt $((ides - one)) ]]; then
    accmonth
    num=$((ides - day + one))
    num=$(./num2roman.sh $num)
    num=$(echo "$num" | tr '[:upper:]' '[:lower:]')
    latindate="Hodie est ante diem $num Idus $latmon "
  elif [[ $day == $((nones - one)) ]]; then
    accmonth
    latindate="Hodie est pridie Nonas $latmon "
  elif [[ $day == $((ides - one)) ]]; then
    accmonth
    latindate="Hodie est pridie Idus $latmon "
  elif [[ $day -gt $ides ]]; then
    accmonth
    case $month in
      "Jan"|"Mar"|"May"|"Jul"|"Aug"|"Oct"|"Dec")
        numdays=32
      ;;
      "Feb")
        if [[ $(isLeap "$year") == "It's a leap year" ]]; then
          numdays=30
        else
          numdays=29
        fi
      ;;
      "Apr"|"Jun"|"Sep"|"Nov")
        numdays=31
      ;;
    esac
    num=$((numdays - day + one)) #Add one for Roman-style inclusive counting
    num=$(./num2roman.sh $num)
    num=$(echo "$num" | tr '[:upper:]' '[:lower:]')
    if [[ $num == "ii" ]]; then
      latindate="Hodie est pridie Kalendas $latmon "
    else
      latindate="Hodie est ante diem $num Kalendas $latmon "
    fi
  else
    echo "ERROR: day var didn't match any if statement."
  fi
  aucyear=$(toAUC "$year")
  convyear=$(./num2roman.sh "$aucyear")
  if [[ "$holidaygreeting" != "" ]]; then
    echo "$holidaygreeting"
  fi
  echo "$latindate$convyear a.u.c."
} #main

isLeap() {
    date -d "$1-02-29" >/dev/null 2>&1 && echo "It's a leap year" || echo "It's not a leap year"
} #isLeap

toAUC() {
    input=$1
    founding=753
    aucyear=$((input + founding))
    echo $aucyear
} #toAUC

holiday() {
  case $month in
    "Jan")
      case $day in
        "3")
          holselect=$(($((RANDOM%10))%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Dies Primus Compitalia"
          else #90% chance
            holidaygreeting="Laetus natalis dies, Marce Tullie Cicero!"
          fi
        ;;
        "4"|"5")
          holidaygreeting="Continuation of the Compitalia festival!"
        ;;
        "9")
          holidaygreeting="Celebration of the Agonalia in honor of Janus"
        ;;
        "10")
          holidaygreeting="Alea iacta est! Caesar crosses the Rubicon."
        ;;
        "11"|"15")
          holidaygreeting="Celebration of the Carmentalia"
        ;;
        "16")
          holidaygreeting="Ave, Auguste! Ave, Princeps! Octavian granted the titles of Augustus and Princeps"
        ;;
        "24")
          holselect=$(($((RANDOM%10))%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Celebration of the Sementivae"
          else #90% chance
            holidaygreeting="Assassination of Caligula by the Praetorian Guard"
          fi
        ;;
        "25"|"26")
          holidaygreeting="Celebration of the Sementivae"
        ;;
        "27")
          holidaygreeting="Laetus natalis dies, Castor et Pollux"
        ;;
      esac
    ;; #Jan
    "Feb")
      case $day in
        "13"|"14"|"16"|"18"|"19"|"20")
          holidaygreeting="Celebration of the Parentalia"
        ;;
        "15")
          holselect=$(($((RANDOM%10))%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Celebration of the Parentalia"
          else #90% chance
            holidaygreeting="Celebration of the Lupercalia"
          fi
        ;;
        "17")
          holselect=$(($((RANDOM%10))%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Celebration of the Parentalia"
          else #90% chance
            holidaygreeting="Celebration of the Fornacalia, go bake something!"
          fi
        ;;
        "21")
          holselect=$(($((RANDOM%10))%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Celebration of the Parentalia"
          else #90% chance
            holidaygreeting="Celebration of the Feralia"
          fi
        ;;
        "22")
          holselect=$(($((RANDOM%10))%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Celebration of the Parentalia"
          else #90% chance
            holidaygreeting="Celebration of the Caristia"
          fi
        ;;
        "23")
          holidaygreeting="Celebration of the Terminalia"
        ;;
        "27")
          holidaygreeting="Celebration of the Equirria"
        ;;
      esac
    ;; #Feb
    "Mar")
      case $day in
        "14")
          holselect=$(($((RANDOM%10))%2)) #random number 0-1
          if [ $holselect -eq 0 ]; then #50% chance
            holidaygreeting="Celebration of the second Equirria"
          else #50% chance
            holidaygreeting="Celebration of the Mamuralia"
          fi
        ;;
        "15")
          holidaygreeting="Cave Idus! Anniversary of the assassination of Julius Caesar"
        ;;
      esac 
    ;; #Mar
    "Apr")
      case $day in
        "21")
          holidaygreeting="LAETUS NATALIS DIES, ROMAE! Rome was founded by Romulus on this day!"
        ;;
      esac
    ;; #Apr
  esac
#   1  APR - Veneralia
#   4-10 APR - Ludi Megalenses
#   12-19 APR - Ludi Cereri\Cerialia
#   6 May - Crassus killed at the Battle of Carrhae
#   9,11,13 MAY - Lemuria, festival of the dead
#   15 May - Mercuralia
#   7 Jun - Ludi Piscatorii
#   7-15 Jun - Vestalia
#   12 JUL - CIC's bday
#   6-13 JUL - Ludi Apollinares
#   18 JUL - dies ater (defeat of Rome by Gauls at the Battle of the Allia in 390BC)
#   18 JUL - Great Fire of Rome, Nero "fiddles"
#   23 JUL - Neptunalia
#   1 AUG - Antony commits suicide
#   2 AUG - Hannibal's defeat at the Battle of Cannae
#   10 AUG - Hadrian named Trajan's heir
#   19 AUG - Death of Augustus
#   24 AUG - Vesuvius
#   30 AUG - Cleopatra commits suicide
#   2 SEP - Battle of Actium
#   4 SEP - Fall of western empire to Odoacer
#   19 OCT - Scipio Africanus defeats Carthage at the Battle of Zama
#   23 OCT - Brutus commits suicide 
} #holiday

ablmonth() { #month in ablative case
  case $month in
    "Jan")
      latmon="Ianuariis"
    ;;
    "Feb")
      latmon="Februariis"
    ;;
    "Mar")
      latmon="Martiis"
    ;;
    "Apr")
      latmon="Aprilibus"
    ;;
    "May")
      latmon="Maiis"
    ;;
    "Jun")
      latmon="Juniis"
    ;;
    "Jul")
      latmon="Juliis"
    ;;
    "Aug")
      latmon="Augustis"
    ;;
    "Sep")
      latmon="Septembribus"
    ;;
    "Oct")
      latmon="Octobribus"
    ;;
    "Nov")
      latmon="Novembribus"
    ;;
    "Dec")
      latmon="Decembribus"
    ;;
  esac
} #ablmonth

accmonth() { #month in accusative case
  case $month in
    "Jan")
      latmon="Ianuarias"
    ;;
    "Feb")
      latmon="Februarias"
    ;;
    "Mar")
      latmon="Martias"
    ;;
    "Apr")
      latmon="Apriles"
    ;;
    "May")
      latmon="Maias"
    ;;
    "Jun")
      latmon="Junias"
    ;;
    "Jul")
      latmon="Julias"
    ;;
    "Aug")
      latmon="Augustas"
    ;;
    "Sep")
      latmon="Septembres"
    ;;
    "Oct")
      latmon="Octobres"
    ;;
    "Nov")
      latmon="Novembres"
    ;;
    "Dec")
      latmon="Decembres"
    ;;
  esac
} #accmonth

holiday
main

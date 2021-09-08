#!/bin/bash
#Bash script to convert the current date to Latin date including AUC year.
#Author: Kevin Hartley
#Version: 2021-08-09
#Future Features:
#-Accept dates other than current date and output formats beyond AUC year.

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
    num=$(~/repositories/latindate/num2roman.sh $num)
    num=$(echo "$num" | tr '[:upper:]' '[:lower:]')
    latindate="Hodie est ante diem $num Nonas $latmon "
  elif [[ $day -gt $nones && $day -lt $((ides - one)) ]]; then
    accmonth
    num=$((ides - day + one))
    num=$(~/repositories/latindate/num2roman.sh $num)
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
    num=$(~/repositories/latindate/num2roman.sh $num)
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
  convyear=$(~/repositories/latindate/num2roman.sh "$aucyear")
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
          holselect=$((RANDOM%10)) #random number 0-9
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
          holselect=$((RANDOM%10)) #random number 0-9
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
          holselect=$((RANDOM%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Celebration of the Parentalia"
          else #90% chance
            holidaygreeting="Celebration of the Lupercalia"
          fi
        ;;
        "17")
          holselect=$((RANDOM%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Celebration of the Parentalia"
          else #90% chance
            holidaygreeting="Celebration of the Fornacalia, go bake something!"
          fi
        ;;
        "21")
          holselect=$((RANDOM%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Celebration of the Parentalia"
          else #90% chance
            holidaygreeting="Celebration of the Feralia"
          fi
        ;;
        "22")
          holselect=$((RANDOM%10)) #random number 0-9
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
          holselect=$((RANDOM%2)) #random number 0-1
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
        "1")
          holidaygreeting="Celebration of the Veneralia"
        ;;
        "4"|"5"|"6"|"7"|"8"|"9"|"10")
          holidaygreeting="Ludi Megalenses, enjoy the games!"
        ;;
        "12"|"13"|"14"|"15"|"16"|"17"|"18"|"19")
          holselect=$((RANDOM%4)) #random number 0-3
          case $holselect in
            "0")
              games="greens"
            ;;
            "1")
              games="reds"
            ;;
            "2")
              games="blues"
            ;;
            "3")
              games="whites"
            ;;
          esac
          holidaygreeting="Ludi Cereri\Cerialia, let's go $games!"
        ;;
        "21")
          holidaygreeting="LAETUS NATALIS DIES, ROMAE! Rome was founded by Romulus on this day!"
        ;;
      esac
    ;; #Apr
    "May")
      case $day in
        "6")
          holidaygreeting="Requiescat in pace, Crasse! Crassus killed at the battle of Carrhae."
        ;;
        "9"|"11"|"13")
          holidaygreeting="Celebration of the Lemuria, the festival of the dead"
        ;;
        "15")
          holidaygreeting="Celebration of the Mercuralia"
        ;;
      esac
    ;; #May
    "Jun")
      case $day in
        "7")
          holselect=$((RANDOM%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Celebration of the Vestalia"
          else #90% chance
            holidaygreeting="Ludi Piscatorii, remember to dedicate your fish to Vulcan!"
          fi
        ;;
        "8"|"9"|"10"|"11"|"12"|"13"|"14"|"15")
          holidaygreeting="Celebration of the Vestalia"
        ;;
      esac
    ;; #Jun
    "Jul")
      case $day in
        "12")
          holselect=$((RANDOM%10)) #random number 0-9
          if [ $holselect -eq 0 ]; then #10% chance
            holidaygreeting="Ludi Apollinares, enjoy the theatre performances!"
          else #90% chance
            holidaygreeting="Laetus natalis dies, Gaie Iulie Caesar! Birthday of Julius Caesar"
          fi
        ;;
        "6"|"7"|"8"|"9"|"10"|"11"|"13")
          holidaygreeting="Ludi Apollinares, enjoy the theatre performances!"
        ;;
        "18")
          holselect=$((RANDOM%2)) #random number 0-1
          if [ $holselect -eq 0 ]; then #50% chance
            holidaygreeting="Rememberence of the Dies Ater (defeat by the Gauls at the Battle of the Allia in 390BC)"
          else #50% chance
            holidaygreeting="Great fire of Rome, grab a fiddle and join Emperor Nero."
          fi
        ;;
        "23")
          holidaygreeting="Celebration of the Neptunalia"
        ;;
      esac
    ;; #Jul
    "Aug")
      case $day in
        "1")
          holidaygreeting="Requiescat in pace, Marce Antonie!"
        ;;
        "2")
          holidaygreeting="Loss to Hannibal at the battle of Cannae!"
        ;;
        "10")
          holselect=$((RANDOM%2)) #random number 0-1
          if [ $holselect -eq 0 ]; then #50% chance
            holidaygreeting="Trajan named Hadrian as his heir."
          else #50% chance
            holidaygreeting="Requiescat in pace, Cleopatra. Cleopatra commits suicide."
          fi
        ;;
        "19")
          holidaygreeting="Requiescat in pace, Auguste! Death of Augustus"
        ;;
        "24")
          holidaygreeting="Cave Vesuvium Montem!"
        ;;
        "29")
          holidaygreeting="Requiescat in pace, Caesarion. With his death, Egypt becomes a province of Rome."
        ;;
      esac
    ;; #Aug
    "Sep")
      case $day in
        "2")
          holidaygreeting="Anniversary of the battle of Actium"
        ;;
        "4")
          holidaygreeting="Fall of the western empire to Odoacer"
        ;;
      esac
    ;; #Sep
    "Oct")
      case $day in
        "19")
          holidaygreeting="Carthago delenda erat! Scipio Africanus defeated Carthage at the Battle of Zama ending the Second Punic War."
        ;;
        "23")
          holidaygreeting="Requiescat in pace, Marce Iunie Brute! Brutus commits suicide."
        ;;
      esac
    ;; #Oct
    "Nov")
      case $day in
        "1")
          holidaygreeting="Ludi Circenses, enjoy the races!"
        ;;
        "4"|"5"|"6"|"7"|"9"|"10"|"11"|"12"|"15"|"16"|"17")
          holidaygreeting="Ludi Plebeii, enjoy the shows!"
        ;;
        "8")
          holselect=$((RANDOM%4)) #random number 0-3
          if [ $holselect -eq 0 ]; then #25% chance
            holidaygreeting="Ludi Plebeii, enjoy the shows!"
          else #75% chance
            holidaygreeting="Opening of the Mundus pit."
          fi
        ;;
        "13")
          holselect=$((RANDOM%4)) #random number 0-3
          if [ $holselect -eq 0 ]; then #25% chance
            holidaygreeting="Ludi Plebeii, enjoy the shows!"
          else #75% chance
            holidaygreeting="Celebration of the Epulum Jovis"
          fi
        ;;
        "14")
          holselect=$((RANDOM%4)) #random number 0-3
          if [ $holselect -eq 0 ]; then #25% chance
            holidaygreeting="Ludi Plebeii, enjoy the shows!"
          else #75% chance
            holidaygreeting="The second Equorum Probatio, watch the horses!"
          fi
        ;;
      esac
    ;; #Nov
    "Dec")
      case $day in
        "3")
          holidaygreeting="Celebration of Bona Dea, remember this one is just for the ladies."
        ;;
        "8")
          holidaygreeting="Festival for Tiberinus Pater and Gaia."
        ;;
        "9")
          holselect=$((RANDOM%2)) #random number 0-1
          if [ $holselect -eq 0 ]; then #50% chance
            holidaygreeting="Celebration of the Agonalia in honor of Indiges"
          else #50% chance
            holidaygreeting="Celebration of the Septimontium, enjoy the 7 hills!"
          fi
        ;;
        "15")
          holidaygreeting="Second Consualia Celebration, hope you have your winter food stored safely."
        ;;
        "17"|"18"|"19"|"20"|"21"|"22")
          holidaygreeting="Io Saturnalia!"
        ;;
        "23")
          holidaygreeting="Io Saturnalia! Don't forget your gifts for Sigillaria!"
        ;;
        "25")
          holidaygreeting="Dies Natalis Solis Invicti, summer is coming."
        ;;
      esac
    ;; #Dec
  esac
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

#!/bin/bash
#Bash script to convert the current date to Latin date including AUC year.
#Future versions to accept dates other than current date and output formats beyond AUC year.
#Future versions also to include the following holidays:
#   3 Jan - Cicero's birthday
#   3-5 Jan - Compitalia
#   9 Jan - Agonalia in honor of Janus
#   11 and 15 JAN - Carmentalia
#   11 Jan - Juturna festival
#   24-26 JAN - Sementivae
#   27 Jan - Dies natalis Castor & Pollux
#   13-22 FEB - Parentalia
#   15 FEB - LUPERCALIA
#   17 FEB - Fornacalia, the baking\oven festival
#   21 FEB - Feralia
#   22 FEB - Caristia
#   23 FEB - Terminalia
#   27 FEB - Equirria
#   14 MAR - Second Equirria\Mamuralia
#   1  APR - Veneralia
#   4-10 APR - Ludi Megalenses
#   12-19 APR - Ludi Cereri\Cerialia
#   21 APR - DIES NATALIS ROMAE
#   9,11,13 MAY - Lemuria, festival of the dead
#   15 May - Mercuralia
#   7 Jun - Ludi Piscatorii
#   7-15 Jun - Vestalia
#   12 JUL - CIC's bday
#   6-13 JUL - Ludi Apollinares
#   18 JUL - dies ater (defeat of Rome by Gauls at the Battle of the Allia in 390BC)
#   23 JUL - Neptunalia
##
#   2 AUG - Hannibal's defeat at the Battle of Cannae
#   19 OCT - Scipio Africanus defeats Carthage at the Battle of Zama
#   6 May - Crassus killed at the Battle of Carrhae
#   10 JAN - Caesar crosses the Rubicon
#   15 MAR - Assassination of CIC
#   23 OCT - Brutus commits suicide 
#   2 SEP - Battle of Actium
#   1 AUG - Antony commits suicide
#   30 AUG - Cleopatra commits suicide
#   16 JAN - Octavian granted titles of Augustus and Princeps
#   19 AUG - Death of Augustus
#   24 JAN - Caligula assassinated
#   18 JUL - Great Fire of Rome, Nero "fiddles"
#   24 AUG - Vesuvius
#   10 AUG - Hadrian named Trajan's heir
#   4 SEP - Fall of western empire to Odoacer
#   

isLeap() {
    date -d "$1-02-29" >/dev/null 2>&1 && echo "It's a leap year" || echo "It's not a leap year"
}

toAUC() {
    input=$1
    founding=753
    aucyear=$((input + founding))
    echo $aucyear
}

day=$(date +%d | sed 's/^0*//')
month=$(date +%b)
year=$(date +%Y)

#day=1
#month="Feb"
#year=2016

one="1"
case $month in
    "Mar"|"May"|"Jul"|"Oct")
        ides=15
        ;;
    *)
        ides=13
esac
nones=$((ides-8))

if [[ $day == "$one" || $day == "$nones" || $day == "$ides" ]]; then
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
    num=$((nones - day + one))
    num=$(~/utilities/num2roman.sh $num)
    num=$(echo "$num" | tr '[:upper:]' '[:lower:]')
    latindate="Hodie est ante diem $num Nonas $latmon "
elif [[ $day -gt $nones && $day -lt $((ides - one)) ]]; then
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
    num=$((ides - day + one))
    num=$(~/utilities/num2roman.sh $num)
    num=$(echo "$num" | tr '[:upper:]' '[:lower:]')
    latindate="Hodie est ante diem $num Idus $latmon "
elif [[ $day == $((nones - one)) ]]; then
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
    latindate="Hodie est pridie Nonas $latmon "
elif [[ $day == $((ides - one)) ]]; then
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
    latindate="Hodie est pridie Idus $latmon "
elif [[ $day -gt $ides ]]; then
    case $month in
        "Jan")
            latmon="Februarias"
            numdays=32
            ;;
        "Feb")
            latmon="Martias"
            if [[ $(isLeap "$year") == "It's a leap year" ]]; then
                numdays=30
            else
                numdays=29
            fi
            ;;
        "Mar")
            latmon="Apriles"
            numdays=32
            ;;
        "Apr")
            latmon="Maias"
            numdays=31
            ;;
        "May")
            latmon="Junias"
            numdays=32
            ;;
        "Jun")
            latmon="Julias"
            numdays=31
            ;;
        "Jul")
            latmon="Augustas"
            numdays=32
            ;;
        "Aug")
            latmon="Septembres"
            numdays=32
            ;;
        "Sep")
            latmon="Octobres"
            numdays=31
            ;;
        "Oct")
            latmon="Novembres"
            numdays=32
            ;;
        "Nov")
            latmon="Decembres"
            numdays=31
            ;;
        "Dec")
            latmon="Ianuarias"
            numdays=32
            ;;
    esac
    num=$((numdays - day + one)) #Add one for Roman-style inclusive counting
    num=$(~/utilities/num2roman.sh $num)
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
convyear=$(~/utilities/num2roman.sh "$aucyear")
echo "$latindate$convyear a.u.c."

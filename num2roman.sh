#!/bin/bash
#
#	Function
#
	num2roman() { # NUM
	# Returns NUM in roman letters
	#
		input=$1	# input num
		output=""	# Clear output string
		len=${#input}	# Initial length to count down
		U="\\033[4m"	# Underscore, multiplies with 1000
		R="\\033[0m"	# Resets the underscore

		roman_val() { # NUM one five ten
		# This sub does the basic 'roman' algorythm
		#
			N=$1
			one=$2
			five=$3
			ten=$4
			out=""

			case $N in
			0)	out+=""	;;
			[123])	while [[ $N -gt 0 ]]
				do	out+="$one"
					N=$((N-1))
				done
				;;
			4)	out+="$one$five"	;;
			5)	out+="$five"	;;
			[678])	out+="$five"
				N=$((N-5))
				while [[ $N -gt 0 ]]
				do	out+="$one"
					N=$((N-1))
				done
				;;
			9)	while [[ $N -lt 10 ]]
				do	out+="$one"
					N=$((N+1))
				done
				out+="$ten"
				;;
			esac
			echo "$out"
		}

		while [[ $len -gt 0 ]]
		do	# There are letters to add
			num=${input:0:1}
			# Do action according position
			case $len in
			1)	output+="$(roman_val "$num" I V X)"	;;
			2)	output+="$(roman_val "$num" X L C)"	;;
			3)	output+="$(roman_val "$num" C D M)"	;;
			4)	output+="$(roman_val "$num" M "${U}"V"${R}" "${U}"X"${R}")"	;;
			5)	output+="$(roman_val "$num" "${U}"X"${R}" "${U}"L"${R}" "${U}"C"${R}")"	;;
			*)	# Fallback 'failsafe'
				num=${input:0:(-3)}
				while [[ $num -gt 0 ]]
				do	output+="M"
					num=$((num-1))
				done
				;;
			esac
			input=${input:1} ; len=${#input}
		done
		echo -e $output
	}
#
#	Call it
#
	for A in $@;do
		num2roman "$A"
	done

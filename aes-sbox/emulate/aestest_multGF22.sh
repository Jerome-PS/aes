#!/bin/sh
#Before anything else, set the PATH_SCRIPT variable
	pushd `dirname $0` > /dev/null; PATH_SCRIPT=`pwd -P`; popd > /dev/null
	PROGNAME=${0##*/}; 

####################################################################################
#  TEST FUNCTION for an AES component
#

aestest_multGF2()
{
  #make a LaTeX table to verify the subbytes
  rowcounter=0
  rowcountermax=4
  columncounter=0
  columncountermax=4
  
  
  printf "\\\begin{tabular}{c|"
  while [[ $columncounter -lt $columncountermax ]]
  do 
  # your-unix-command-here
   printf "c" 
   let columncounter=columncounter+1
   if [ $columncounter -eq $columncountermax ]; then
     printf "|}\n"
   else
     printf "|"
   fi
  done 
  
  columncounter=0
  printf " & "
  while [[ $columncounter -lt $columncountermax ]]
  do 
  # your-unix-command-here
   printf "%x" "$columncounter"
   let columncounter=columncounter+1
   if [ $columncounter -eq $columncountermax ]; then
     printf " \\\\\ \n \\\hline\n"
   else
     printf " & "
   fi
  done

  rowcounter=0
  columncounter=0
  while [[ $rowcounter -lt $rowcountermax ]]
  do 
     printf "%x &" "$rowcounter"
	 while [[ $columncounter -lt $columncountermax ]]
	 do 
      #we take the index and turn it into hex
      #turn the hex into binary, and then up it into the Subbyte	
      #bashbignumbers doesn't do a good job at SMALL numbers.
      printf -v INDEXROW "%x"  "$rowcounter"
      printf -v INDEXCOL "%x"  "$columncounter"
	  #printf -v INDEXVAL "%x%x" "$rowcounter" "$columncounter"
	  BINROW=$(bashUTILhex2bin "$INDEXROW") 
	  BINCOL=$(bashUTILhex2bin "$INDEXCOL") 
	  BINROW=$(bashSHLbinstring "$BINROW")
	  BINROW=$(bashSHLbinstring "$BINROW")
	  BINARG=$(bashADDbinstring $BINROW $BINCOL)
	  #BINARG=$(bashUTILhex2bin "$INDEXVAL") 
	  #printf "%s,%s" "$BINROW" "$BINCOL" 
	  #printf "%s" "$BINARG" 
	  BINRES=$(aes_multGF2 "$BINARG")  #binary string result from subbyte
	  printf "%s" "$BINRES" 
	  #HEXRES=$(bashUTILbin2hex $BINRES) #hex conversion
	  #printf "%s" "$HEXRES" 
	  let columncounter=columncounter+1
	  if [ $columncounter -eq $columncountermax ]; then
		printf " \\\\\ \n \\\hline\n"
	  else
		printf " & "
	  fi
	 done
	 columncounter=0
	 let rowcounter=rowcounter+1
  done


  printf "\\\end{tabular}\n"

}



####################################################################################
#  Main block
#

	
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/aesbash.sh"

#load requirements or AES
aesbash_verify_dependencies
# run the test function
aestest_multGF2

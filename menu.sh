#!/bin/bash 

choice=1
choiceSub=1
newFile=Y
nm=$USER
dt=$(date)
chng=""
repo=$REPO_DIR/$SELECTED_REPO
locallog="repoLog/repoTrack.log"

createRepsitory()
{
    while [[ -z $repo ]] 
    do
        read -p "Please enter the name of the new Repository:" repo
        echo "Invalid input"
    done

    mkdir $repo
}

addFile()
{   
    while [[ -z $location ]] 
    do
        echo "Please enter the directory you would like to add the files to."
        read location
    done
    
    cd $location
    
    while [[ -z $fileName ]]; 
    do
        echo 'Please enter the name of the file you would like to create.'
        read fileName
    done
    
    cat > $fileName
}

#Check in
#The file will be checked to see if it exists
#Then a check for a lockfile
#The check in will then be completed

chkingit()
{
    if [[ ! -e "$REPO_DIR/$SELECTED_REPO/$CHECK_OUT_FILE" ]]
        then
            echo "This file does not exist."
            echo "EXITING"
            exit 1
    fi
    
    if [[ ! -e "$REPO_DIR/$SELECTED_REPO/$CHECK_OUT_FILE.lock" ]] 
        then
            echo "This file cannot be checked out currently."
            echo "EXITING"
            exit 1
    fi
    rm "$REPO_DIR/$SELECTED_REPO/$CHECK_OUT_FILE.lock"
}

#Check File
#The file that the user wishes to check out is checked for
#Its existence and a lock file
#The user is then given a response on the status of the file check

checkFile()
{
    
    if [[ ! -e "$REPO_DIR/$SELECTED_REPO/$FILE_TO_CHECK" ]]
        then
	        echo "Check complete: "
            echo "The file does not exist"
            exit 1
    fi
    
    if [[ -e "$REPO_DIR/$SELECTED_REPO/$FILE_TO_CHECK.lock" ]] 
        then 
            echo "Check complete: "
            echo "The following user already checked out this file:"
            cat "$REPO_DIR/$SELECTED_REPO/$FILE_TO_CHECK.lock"
            exit 1
    fi  

    echo "Check complete: "
    echo "The file is not checked out"
}

#Check out
#The file will be checked to see if it exists
#Then a check for a lockfile and display who is edititing the file
#If the file can be checked out a lock file will be made


chkOutGit()
{
    if [[ ! -e "$REPO_DIR/$SELECTED_REPO" ]]
        then 
            echo "This file does not exist."
            echo "UNSUCCESSFUL: EXITING"
            exit 1
    fi
    
    if [[ -e "$REPO_DIR/$SELECTED_REPO/$CHECK_OUT_FILE.lock" ]] 
        then 
            echo "This file has already been checked out by "
            cat "$REPO_DIR/$SELECTED_REPO/$CHECK_OUT_FILE.lock"
            echo "UNSUCCESSFUL: EXITING"
            exit 1
    fi  
    touch "$REPO_DIR/$SELECTED_REPO/$CHECK_OUT_FILE.lock"
    echo "$USER @ $(date)" > "$REPO_DIR/$SELECTED_REPO/$CHECK_OUT_FILE.lock"
}

#Log script
#logs all changes with the users name and the date and time of a change

#Create temp variables for all aspects of the log
#name, date, changes, location of log

log()
{
	if [-f "$locallog"]
    then
            echo "what changes have you made?"
            read chng
            $nm >> $locallog
            $dt >> $locallog
            $chng >> $locallog
            echo "LOG SUCCESSFUL"
	else
		echo "LOG UNSUCCESSFUL: "
		echo EXITING
		exit 1
	fi
}


displayMenu()
{
    echo "- - - - - - - - - - - - - -"
    echo "1) Add a new Repository"
    echo "2) View existing Repositories"
    echo "3) Log File"
    echo "4) Exit"
    echo "- - - - - - - - - - - - - -"
}

displayFileSub()
{
    echo "- - - - - - - - - - - - - -"
    echo "1) Add a new File"
    echo "2) Check a File in"
    echo "3) Check a file Out"
    echo "4) Exit"
    echo "- - - - - - - - - - - - - -"

while [ $choiceSub -ne 0 ]
do
    #displayFileSub
    read choiceSub 2> invalid_input
    echo
    case $choiceSub in
    1 ) addFile
    echo "Work 1" #run the add repo command
    ;;
    2 ) chkingit
    echo "Work 2" #Display repo's
    ;;
    3 ) chkOutGit
    echo "Work 3" #Display error log
    ;;
    4 )  break #exit program
        echo
        ;;
    *) echo "Invalid Input. Please choose a valid option"
        echo
        choiceSub=1
        ;;
    esac
done
}

while [ $choice -ne 0 ]
do
    displayMenu
    read choice 2> invalid_input
    echo
    case $choice in
    1 ) createRepsitory
        #run the add repo command
    ;;
    2 ) displayFileSub
        #Display repo's
    ;;
    3 ) log
        #Display error log
    ;;
    4 ) break #exit program
        echo
        ;;
    * ) echo "Invalid Input. Please choose a valid option"
        echo
        choice=1
        ;;
    esac
done

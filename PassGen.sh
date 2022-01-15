#!/bin/bash
echo "####################################################################"
echo "#    __________                        ________                    #"
echo "#    \______   \_____    ______ ______/  _____/  ____   ____       #"
echo "#     |     ___/\__  \  /  ___//  ___/   \  ____/ __ \ /    \      #"
echo "#     |    |     / __ \_\___ \ \___ \\     \_\  \  ___/|   |  \     #"
echo "#     |____|    (____  /____  >____  >\______  /\___  >___|  /     #"
echo "#                    \/     \/     \/        \/     \/     \/      #"
echo "#     Developed by Munazir                                    v1.3 #"                                  
echo "#     github: github.com/Munazirul/PassGen                         #"
echo "#                                                                  #"
echo "####################################################################"
echo ""
echo ""
echo -e "->Specify the name of output file (for example, if you want to generate the password for discord, enter 'discord'):\c"
read output_file
echo -e "->Enter the password length (By default 12 digit password will be generated if you do not specify the lenght):\c"
read pass_length

#install openssl
# function openssl(){
#     if [[ `command -v openssl` ]];
#     then
#         echo ''
#         else
#             apt-get install openssl -y >/dev/null 2>&1 
#     fi          
# }

#generate password
function generate(){
    for P in $(seq 1);
do
    if [[ -z $pass_length ]]
        then
        #openssl rand -base64 48 | cut -c1-12 > $output_file.txt
        </dev/urandom tr -dc 'A-Za-z0-9@#$%^&*/_+=' | head -c 12 > $output_file.txt
        echo "->Generating 12 digit password"
        sleep 2
        else
    </dev/urandom tr -dc 'A-Za-z0-9@#$%^&*/_+=' | head -c $pass_length > $output_file.txt
    #openssl rand -base64 48 | cut -c1-$pass_length > $output_file.txt
    echo "->Generating $pass_length digit password"
    sleep 2
    fi
    done 
    echo "->Password is generated and saved in $output_file.txt"
}
generate

#copy the generated password to clipboard
function clipboard(){
    if [[ `command -v xclip` ]];
    then
    cat $output_file.txt | xclip -sel clip
    else
        printf "\n\n->Required packages are not installed. Installing it for you.\n\n"
        sleep 1
        sudo apt-get install xclip -y >/dev/null 2>&1
        sleep 2
        clipboard
        fi
}

#write ssmtp file
function ssmtp_write(){
    echo "UseSTARTTLS=YES
UserTLS=YES
hostname=localhost
root=postmaster
mailhub=smtp.gmail.com:587
AuthUser=$mail
AuthPass=$password
TLS_CA_FILE=/etc/ssl/certs/ca-certificates.crt
FromLineOverride=YES" > /etc/ssmtp/ssmtp.conf
}
#configure ssmtp
function ssmtp_conf(){
    if [[ `command -v ssmtp` && `command -v mpack` ]];
        then 
            ssmtp_write
            else 
            echo "->Required packages are not installed. Installing it for you."
            sleep 1
            sudo apt-get -y install ssmtp -y >/dev/null 2>&1 && apt-get install mpack -y >/dev/null 2>&1
            printf "\n\n->Required packages are Installed\n\n"
            sleep 2
            ssmtp_write
            fi
}

#output
function pass_gen(){
    if [[ $ynmail == 'y' || $ynmail == 'Y' ]]
        then 
        echo "->Before using this feature, Make sure that you have 
enabled less secure app access under 'security' in your google account!"
        echo -e "->Enter your gmail address:\c"
        read mail
        echo -e "->Enter your Password:\c"
        read -s password
        ssmtp_conf
        sleep 1
        cat $output_file.txt | xclip -sel clip
        mpack -s "->Password generated using PassGen for $output_file" $output_file.txt $mail
        printf "\n\n->The file containing password has been sent to your gmail\n\n"
        # elif [[ $ynmail == 'n' || $ynmail == 'N' ]]
        # then
        exit 0
        else
        printf "\n->Your password has been saved to $output_file.txt\n"
        sleep 1
            echo "->Thank you for using PassGen, See you next time...."
            exit 0
        fi
}
echo -e "->Do you want to copy the generated password to clipboard (Y/N) ?: "
read yn
if [[ $yn == 'y' || $yn == 'Y' ]]
       then 
    clipboard
    echo "->Your password has been copied to clipboard"
    exit 0
    elif [[ $yn == 'n' || $yn == 'N' ]]
       then
    echo -e "->Do you want to send the password to your gmail (Y/N) ?: "
    read ynmail
    pass_gen
    else 
    echo "->Invalid Input!!"
    exit 0 
    fi 

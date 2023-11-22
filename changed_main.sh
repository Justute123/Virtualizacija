#!/bin/sh
#echo "Please enter password for your SSH key:"
#eval `ssh-agent -s`
#ssh-add

function() {
        echo "Please enter username for your VU MIF cloud infrastructure"
        read  CUSER
        echo "Please enter password for your VU MIF cloud infrastructure"
        CPASS="something"
        #stty -echo
        #read CPASS
        #stty echo
        CENDPOINT=https://grid5.mif.vu.lt/cloud3/RPC2
        CVMREZ=$(onetemplate instantiate "debian12-password" --user $CUSER --name $1 --password $CPASS  --endpoint $CENDPOINT)
        CVMID=$(echo $CVMREZ |cut -d ' ' -f 3)
        echo $CVMID
        echo "Waiting for VM to RUN 60 sec."
        sleep 60
        $(onevm show $CVMID --user $CUSER --password $CPASS  --endpoint $CENDPOINT >$CVMID.txt)
        CSSH_CON=$(cat $CVMID.txt | grep CONNECT\_INFO1| cut -d '=' -f 2 | tr -d '"'|sed 's/'$CUSER'/root/')
        CSSH_PRIP=$(cat $CVMID.txt | grep PRIVATE\_IP| cut -d '=' -f 2 | tr -d '"')
        echo "Connection string: $CSSH_CON"
        echo "Local IP: $CSSH_PRIP"

        # suranda slaptažodį tempalte
        CSSH_PASSWORD=$(cat $CVMID.txt | grep USER\_PASSWORD| cut -d '=' -f 2 | tr -d '"' | tr -d ',')
        echo $CSSH_PASSWORD
        echo $CUSER@$CSSH_PRIP

        # nukopijuoja ssh rakta
        sshpass -p $CSSH_PASSWORD ssh-copy-id -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa.pub $CUSER@$CSSH_PRIP

}

function "client_vm"
exit 0

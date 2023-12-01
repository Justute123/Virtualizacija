#!/bin/sh
TIME_TO_SLEEP=60
CENDPOINT=https://grid5.mif.vu.lt/cloud3/RPC2
VAULT_PASSWORD_FILE=../Miscellaneous/vault_password

DB_NAME="db_vm_a"
DB_USER="juur8306"
DB_PASSWORD="5f65b771dd2fdc1d232ea35bdbfed020f85e186b"
DB_TEMPLATE="debian12-password"

WEB_NAME="webserver"
WEB_USER="juur8306"
WEB_PASSWORD="5f65b771dd2fdc1d232ea35bdbfed020f85e186b"
WEB_TEMPLATE="debian12-password-www"

CLIENT_NAME="c_vm"
CLIENT_USER="juur8306"
CLIENT_PASSWORD="5f65b771dd2fdc1d232ea35bdbfed020f85e186b"
CLIENT_TEMPLATE="debian12-password"

create_vm() {
        echo "Creating $1 VM in $2 opennebula account using $4 template"
        CVMREZ=$(onetemplate instantiate $4 --user $2 --name $1 --password $3  --endpoint $CENDPOINT)
        CVMID=$(echo $CVMREZ |cut -d ' ' -f 3)
        echo $CVMID
        echo "Waiting for VM to RUN $TIME_TO_SLEEP sec."
        sleep $TIME_TO_SLEEP
        echo "Getting $1 VM details."
        $(onevm show $CVMID --user $2 --password $3  --endpoint $CENDPOINT >$CVMID.txt)
        CSSH_CON=$(cat $CVMID.txt | grep CONNECT\_INFO1| cut -d '=' -f 2 | tr -d '"'|sed 's/'$CUSER'/root/')
        CSSH_PRIP=$(cat $CVMID.txt | grep PRIVATE\_IP| cut -d '=' -f 2 | tr -d '"')
        echo "Connection string: $CSSH_CON"
        echo "Local IP: $CSSH_PRIP"

        # suranda slaptažodį tempalte
        CSSH_PASSWORD=$(cat $CVMID.txt | grep USER\_PASSWORD| cut -d '=' -f 2 | tr -d '"' | tr -d ',')
        echo $CSSH_PASSWORD
        echo $2@$CSSH_PRIP


        # kad neklaustu ar norit pridėt vėliau ir nemestų error jei netyčia ip jau būtų pridėtas, kai priklausė kitai mašinai
        echo "removing ip from known_hosts, and adding it agian"
        ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$CSSH_PRIP"
        ssh-keyscan -H $CSSH_PRIP >> ~/.ssh/known_hosts
        # nukopijuoja ssh rakta
        sshpass -p $CSSH_PASSWORD ssh-copy-id -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa.pub $2@$CSSH_PRIP

        #užpildom hosts failą
        echo "[$1]" >> $ANSIBLE_HOSTS
        echo $CSSH_PRIP >> $ANSIBLE_HOSTS


        if [ "$1" = "$DB_NAME" ]
        then
                DB_IP=$CSSH_PRIP
        fi
        if [ "$1" = "$WEB_NAME" ]
        then
                WEB_IP=$CSSH_PRIP
        fi
        if [ "$1" = "$CLIENT_NAME" ]
        then
                CLIENT_IP=$CSSH_PRIP
        fi

}

# ------------------- ATSARGIAI -----------------------
# scriptas keicia ansible hosts direktoija
ANSIBLE_CONFIG=~/.ansible.cfg
ANSIBLE_HOSTS=~/.ansible-hosts
echo "updating ansible.cfg to use inventory file in $ANSIBLE_HOSTS"
# ansible-config init --disabled > $ANSIBLE_CONFIG
echo "[defaults]" > $ANSIBLE_CONFIG
echo "inventory = $ANSIBLE_HOSTS" >> $ANSIBLE_CONFIG
truncate -s 0 $ANSIBLE_HOSTS
# ------------------- ATSARGIAI -----------------------

create_vm $DB_NAME $DB_USER $DB_PASSWORD $DB_TEMPLATE
create_vm $WEB_NAME $WEB_USER $WEB_PASSWORD $WEB_TEMPLATE
create_vm $CLIENT_NAME $CLIENT_USER $CLIENT_PASSWORD $CLIENT_TEMPLATE

echo "db ip:$DB_IP, web ip:$WEB_IP, client ip:$CLIENT_IP"

sed -i "1s/.*/spring.datasource.url=jdbc:postgresql:\/\/$DB_IP:5432\/serveriai/" ../Product/application.properties

ansible-playbook ../Ansible/db-vm.yml --vault-password-file $VAULT_PASSWORD_FILE -u $DB_USER
ansible-playbook ../Ansible/web.yml --vault-password-file $VAULT_PASSWORD_FILE -u $WEB_USER
ansible-playbook ../Ansible/Client.yml  --vault-password-file $VAULT_PASSWORD_FILE -u $CLIENT_USER



exit 0

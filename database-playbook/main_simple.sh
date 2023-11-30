#!/bin/sh
# echo "Please enter password for your SSH key:"
# ssh-add

VAULT_PASSWORD_FILE=vault_password

echo "Please enter password for ansible vault(dabar vault slaptazodis yra "labas")"
read VAULT_PASSWORD
echo $VAULT_PASSWORD > $VAULT_PASSWORD_FILE


CUSER=juur8306
# echo "Please enter password for your VU MIF cloud infrastructure"
CPASS="5f65b771dd2fdc1d232ea35bdbfed020f85e186b"
CENDPOINT=https://grid5.mif.vu.lt/cloud3/RPC2
CVMREZ=$(onetemplate instantiate "debian12-password" --user $CUSER --password $CPASS  --endpoint $CENDPOINT)
echo $CVMREZ
CVMID=$(echo $CVMREZ |cut -d ' ' -f 3) 
echo $CVMID
echo "Waiting for VM to RUN 20 sec."
sleep 20
$(onevm show $CVMID --user $CUSER --password $CPASS  --endpoint $CENDPOINT >$CVMID.txt)
CSSH_CON=$(cat $CVMID.txt | grep CONNECT\_INFO1| cut -d '=' -f 2 | tr -d '"'|sed 's/'$CUSER'/root/')
CSSH_PRIP=$(cat $CVMID.txt | grep PRIVATE\_IP| cut -d '=' -f 2 | tr -d '"')
# echo "Connection string: $CSSH_CON"
# echo "Local IP: $CSSH_PRIP"
# echo "username: $CUSER"


# suranda slaptažodį tempalte
CSSH_PASSWORD=$(cat $CVMID.txt | grep USER\_PASSWORD| cut -d '=' -f 2 | tr -d '"' | tr -d ',')
echo "password: $CSSH_PASSWORD"
echo $CUSER@$CSSH_PRIP


# removes ip from known_hosts
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$CSSH_PRIP"
ssh-keyscan -H $CSSH_PRIP >> ~/.ssh/known_hosts
# nukopijuoja ssh rakta
sshpass -p $CSSH_PASSWORD ssh-copy-id -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa.pub $CUSER@$CSSH_PRIP



# ------------------- ATSARGIAI -----------------------
# scriptas keicia ansible hosts direktoija
ANSIBLE_CONFIG=~/.ansible.cfg
ANSIBLE_HOSTS=~/.ansible-hosts
# ansible-config init --disabled > $ANSIBLE_CONFIG
echo "[defaults]" > $ANSIBLE_CONFIG
echo "inventory = $ANSIBLE_HOSTS" >> $ANSIBLE_CONFIG
echo "[db_vm_a]" > $ANSIBLE_HOSTS
echo $CSSH_PRIP >> $ANSIBLE_HOSTS
# ------------------- ATSARGIAI -----------------------

# ansible-playbook ping-db.yml
ansible-playbook db-vm.yml --vault-password-file $VAULT_PASSWORD_FILE

exit 0
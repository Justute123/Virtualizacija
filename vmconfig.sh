#!/bin/bash
ENDPOINT=https://grid5.mif.vu.lt/cloud3/RPC2  
WEBSERVER_FILE="webserver.yml"
CLIENT_ORDER_FILE="client_order_template.yml"
NETWORK_FILE="network_template.yml"

upload_template() {
    template_file=$1
    template_name=$(grep 'name:' "$template_file" | awk '{print $2}')
    
    echo "Uploading template: $template_name"
    onetemplate create "$template_file" -v
}

instantiate_vm() {
    template_name=$1
    vm_name=$2
    client_cpu=$3
    client_memory=$4
    client_os_type=$5
    client_days=$6

    echo "Instantiating VM: $vm_name"
    onevm create "$template_name" --name "$vm_name" \
        --variable CPU="$client_cpu" \
        --variable MEMORY="$client_memory" \
        --variable OS_TYPE="$client_os_type" \
        --variable DAYS="$client_days" -v
}
upload_template "$NETWORK_FILE"
upload_template "$WEBSERVER_FILE"
upload_template "$CLIENT_ORDER_FILE"

instantiate_vm "webserver-vm" "webserver" 2 2048 "debian" 5
instantiate_vm "order-vm" "clientorder" 1 1024 "debian" 5
#!/usr/bin/env bash

OUTPUT_TLS_ASSETS_DIR="${1:-none}"
TLS_DIR="gentls"

usage() {
    echo ""
    echo "Usage:"
    echo ""
    echo "$0 <tls_assets_dir_path>           # tls_assets_dir_path should contain all json files needed by cfssl. The output tls/ dir, containing generated TLS assets, will also be created inside this directory."
    echo ""
    echo "Example dir tree structure"
    echo ""
    cat<< EOF
.
├── ca-config.json
├── ca-csr.json
├── vault-server.json
└── tls
    ├── ca
    │   ├── vault_ca.csr
    │   ├── vault_ca-key.pem
    │   └── vault_ca.pem
    ├── vault
    │   ├── vault-key.pem
        └── vault.pem

EOF
    echo ""
    echo "Example command call:"
    echo "$0 ./mytlsdir"

}

echov(){
    printf "%b\n" "=== $*"
}


mkdirtree(){
    rm -rf ${TLS_DIR}
    mkdir -p ${TLS_DIR}/{ca,vault,concourse} 2>/dev/null
}

genCa(){
    OLDPWD="$CWD"
    DIR="$1"
    cd "$DIR" || exit 1

    if [[ ! -d "./${TLS_DIR}/" ]];
    then
        mkdirtree
    fi

    echov "\n generating ca TLS assets\n"
    cfssl gencert -initca ca-csr.json | cfssljson -bare ${TLS_DIR}/ca/vault_ca
    cd "$OLDPWD" || exit 1
}

genVault(){

    OLDPWD="$CWD"
    DIR="$1"

    cd "$DIR" || exit 1

    echov "\n generating vault TLS assets\n"
    echov "=== generating vault server assets\n"
    CA_DIR="${TLS_DIR}/ca"
    cfssl gencert -config=ca-config.json \
          -ca-key="$CA_DIR"/vault_ca-key.pem \
          -ca="$CA_DIR"/vault_ca.pem \
          -profile=server vault.json | cfssljson -bare ${TLS_DIR}/vault/vault

    echov "=== generating vault client assets\n"
    CA_DIR="${TLS_DIR}/ca"
    cfssl gencert -config=ca-config.json \
          -ca-key="$CA_DIR"/vault_ca-key.pem \
          -ca="$CA_DIR"/vault_ca.pem \
          -profile=client vault-client.json | cfssljson -bare ${TLS_DIR}/vault/vault-client
    cd "$OLDPWD" || exit 1
}

genConcourse(){

    OLDPWD="$CWD"
    DIR="$1"

    cd "$DIR" || exit 1

    echov "\n generating concourse TLS assets\n"
    echov "=== generating concourse client assets\n"
    CA_DIR="${TLS_DIR}/ca"
    cfssl gencert -config=ca-config.json \
          -ca-key="$CA_DIR"/vault_ca-key.pem \
          -ca="$CA_DIR"/vault_ca.pem \
          -profile=client vault-client.json | cfssljson -bare ${TLS_DIR}/vault/vault-client
    cd "$OLDPWD" || exit 1
}

# main()
if [[ "$OUTPUT_TLS_ASSETS_DIR" = "none" ]] || [[ "$OUTPUT_TLS_ASSETS_DIR" = "-h" ]] || [[ "$OUTPUT_TLS_ASSETS_DIR" = "--help" ]]
then
    echo "please pass the TLS assets dir path"
    usage
    exit 1
fi

genCa "$OUTPUT_TLS_ASSETS_DIR"
genVault "$OUTPUT_TLS_ASSETS_DIR"
genConcourse "$OUTPUT_TLS_ASSETS_DIR"

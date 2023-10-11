# read secrets in the kvv2 secrets engine
path "kvv2/data/*" {
  capabilities = [ "read", "list"]
}

# create secrets in the kvv2 secrets engine, but only at the subpath /generated/
# you need this if you deploy the vault config operator
path "kvv2/data/generated/*" {
  capabilities = [ "read", "list", "create", "update" ]
}
# read secrets in the kvv2 secrets engine
path "kvv2/data/*" {
  capabilities = [ "read", "list"]
}

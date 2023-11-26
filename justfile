clean: clean-server clean-client

clean-server:
  #!/usr/bin/env bash
  rm -rf api/api.gen.go

clean-client:
  #!/usr/bin/env bash
  rm -rf pkg/client/client.gen.go

gen: clean gen-server gen-client

gen-server:
  #!/usr/bin/env bash
  oapi-codegen \
    -package api \
    -generate types,fiber \
    api/openapi.yaml > api/api.gen.go

gen-client:
  #!/usr/bin/env bash
  mkdir -p pkg/client
  oapi-codegen \
    -package client \
    -generate client \
    api/openapi.yaml > pkg/client/client.gen.go
  cd pkg/client && go mod tidy

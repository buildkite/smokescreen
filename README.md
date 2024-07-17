# Smokescreen [![Build status](https://badge.buildkite.com/0d59551a64ba126b999ce6327651ccb28b1848ea85bd77a57f.svg)](https://buildkite.com/buildkite/smokescreen?branch=master)

> Archived in favour of https://github.com/buildkite/buildkite-smokescreen

Smokescreen is a HTTP CONNECT proxy. It proxies most traffic from Buildkite to the external world (e.g., webhooks).

Smokescreen is used at Buildkite in local development, CI builds and in production as an internal proxy. This fork is used to package and release Smokescreen binaries for the different platforms we target. For information about Smokescreen itself, please [check out the full upstream repository](https://github.com/stripe/smokescreen). We manage the production Smokescreen proxy as a [Fargate Docker image in the buildkite/ops repository](https://github.com/buildkite/ops/tree/main/docker/smokescreen).

Smokescreen restricts which URLs it connects to: it resolves each domain name that is requested and ensures that it is a publicly routable IP and not an internal IP. This prevents a class of attacks where, for instance, our own webhooks infrastructure is used to scan our internal network.

Smokescreen can be contacted over TLS. You can provide it with one or more client certificate authority certificates as well as their CRLs. Smokescreen will warn you if you load a CA certificate with no associated CRL and will abort if you try to load a CRL which cannot be used (ex.: cannot be associated with loaded CA).

Smokescreen can be provided with an ACL to determine which remote hosts a service is allowed to interact with. 

## Dependencies

Smokescreen uses [go modules][mod] to manage dependencies. The
linked page contains documentation, but some useful commands are reproduced
below:

- **Adding a dependency**: `go build` `go test` `go mod tidy` will automatically fetch the latest version of any new dependencies. Running `go mod vendor` will vendor the dependency.
- **Updating a dependency**: `go get dep@v1.1.1` or `go get dep@commit-hash` will bring in specific versions of a dependency. The updated dependency should be vendored using `go mod vendor`.

Smokescreen uses a [custom fork](https://github.com/stripe/goproxy) of goproxy to allow us to support context passing and setting granular timeouts on proxy connections.

Smokescreen is built and tested using the following Go releases. Generally, Smokescreen will only support the two most recent Go versions.

- go1.14.x
- go1.15.x

[mod]: https://github.com/golang/go/wiki/Modules

## Usage

### CLI

Here are the options you can give Smokescreen:

```
   --help                                      Show this help text.
   --config-file FILE                          Load configuration from FILE.  Command line options override values in the file.
   --listen-ip IP                              Listen on interface with address IP.
                                                 This argument is ignored when running under Einhorn. (default: any)
   --listen-port PORT                          Listen on port PORT.
                                                 This argument is ignored when running under Einhorn. (default: 4750)
   --timeout DURATION                          Time out after DURATION when connecting. (default: 10s)
   --proxy-protocol                            Enable PROXY protocol support.
   --deny-range RANGE                          Add RANGE(in CIDR notation) to list of blocked IP ranges.  Repeatable.
   --allow-range RANGE                         Add RANGE (in CIDR notation) to list of allowed IP ranges.  Repeatable.
   --deny-address value                        Add IP[:PORT] to list of blocked IPs.  Repeatable.
   --allow-address value                       Add IP[:PORT] to list of allowed IPs.  Repeatable.
   --egress-acl-file FILE                      Validate egress traffic against FILE
   --resolver-address ADDRESS                  Make DNS requests to ADDRESS (IP:port).  Repeatable.
   --statsd-address ADDRESS                    Send metrics to statsd at ADDRESS (IP:port). (default: "127.0.0.1:8200")
   --tls-server-bundle-file FILE               Authenticate to clients using key and certs from FILE
   --tls-client-ca-file FILE                   Validate client certificates using Certificate Authority from FILE
   --tls-crl-file FILE                         Verify validity of client certificates against Certificate Revocation List from FILE
   --additional-error-message-on-deny MESSAGE  Display MESSAGE in the HTTP response if proxying request is denied
   --disable-acl-policy-action POLICY ACTION   Disable usage of a POLICY ACTION such as "open" in the egress ACL
   --stats-socket-dir DIR                      Enable connection tracking. Will expose one UDS in DIR going by the name of "track-{pid}.sock".
                                                 This should be an absolute path with all symlinks, if any, resolved.
   --stats-socket-file-mode FILE_MODE          Set the filemode to FILE_MODE on the statistics socket (default: "700")
   --version, -v                               print the version
```

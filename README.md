# Backstage with Nomad

What is [Backstage](https://backstage.io/). Backstage is a powerful service catalog & extensible tools for driving production readiness developed by Spotify.

## Getting Started

### Start Nomad

```bash
sudo nomad agent -dev -bind 0.0.0.0 -network-interface=en0 -log-level INFO -config client.hcl
```

### Start Consul

In a separate console window run:

```bash
nomad job run consul.hcl
```

## Start Postgres and PgWeb


```bash
nomad job run postgres.hcl
nomad job run pgweb.hcl
```

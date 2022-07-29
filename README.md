# Backstage with Nomad

What is [Backstage](https://backstage.io/). Backstage is a powerful service catalog & extensible tools for driving production readiness developed by Spotify.

## Getting Started

### Prerequisites

- Nomad - [here for install guide](https://www.nomadproject.io/docs/install)

### Start Nomad

```bash
sudo nomad agent -dev -bind 0.0.0.0 -network-interface=en0 -log-level INFO -config client.hcl
```

Nomad URL: http://localhost:4646/

### Start Consul

In a separate console window run:

```bash
nomad job run consul.hcl
```

Consul URL: http://localhost:8500/

## Start Postgres and Pgweb

```bash
nomad job run postgres.hcl
nomad job run pgweb.hcl ## Optional
```

PGWeb URL: http://pgweb.service.consul:8081/

## Start Backstage

For Backstage to read pull the catalog information you will need to create a [Github Personal Access Token](https://backstage.io/docs/getting-started/configuration#setting-up-a-github-integration).

Then you need to modify the [backstage.hcl](./backstage.hcl) with your token (**DO NOT** commit your token to Github) and your repo URL like below:

```terraform
locals {
  image = "brucedominguez/backstage-nomad-example:1.0.0" ## Or the image you have built from source
  github_token = "<ADD PERSONAL ACCESS TOKEN HERE>"
  cataglog_info_url = "https://github.com/<YOUR ORG>/backstage-nomad-local/blob/main/catalog/all.yaml"
}
```

```bash
nomad job run backstage.hcl
```

Backstage URL: http://backstage.service.consul:7007

## Build Backstage from source

1. Clone the backstage repo https://github.com/backstage/backstage
2. Follow the [Getting Started Guide](https://backstage.io/docs/getting-started/).
Ensure that you have all the [Prerequisites](https://backstage.io/docs/getting-started/#prerequisites), especially the correct version of Node (I used v14.20.0).
3. In the root of the folder, create your version of the app by running `npx @backstage/create-app` and follow the prompts
4. Modify the `app-config.yaml` under the newly created folder (new app name) with the below?:

```yaml
app:
  title: Backstage App
+  baseUrl: http://backstage.service.consul:3000  # Replace localhost and add the consul dns name of the service

organization:
  name: <ADD YOUR ORG NAME HERE>

...
backend:
+  baseUrl: http://backstage.service.consul:7007 # Replace localhost and add the consul dns name of the service
  csp:
      connect-src: ["'self'", 'http:', 'https:']
+     upgrade-insecure-requests: false # This will prevent urls being upgraded to https since it is local
  database: # Update the database connection to use postgres
+    client: pg
+    connection:
+      host: ${POSTGRES_HOST}
+      port: ${POSTGRES_PORT}
+      user: ${POSTGRES_USER}
+      password: ${POSTGRES_PASSWORD}

+ catalog: ## Remove the catalog section and add the below to pull the catalog from your Github repo
+   rules:
+     - allow: [Component, System, API, Resource, Location, Domain]
+   locations:
+     - type: github-discovery
+       target: ${GITHUB_CATALOG_URL}
  
```

5. _Optional_ Remove the reference to the `app-config.production.yaml` in the Dockerfile prior to building by removing `"--config", "app-config.production.yaml"` from `./<your app directory>/packages/backend/Dockerfile`
6. From the root of you new app folder run the below:

```bash
yarn install
yarn tsc
yarn build
```

8. Enable [Github Discovery](https://backstage.io/docs/integrations/github/discovery) by following the steps outlined.
7. Next build your Dockerfile from the root of your new app directory

```bash
docker image build . -f packages/backend/Dockerfile --tag <your dockerhub repo>/backstage-nomad-example:<add-tag-version>
```
8. Push the image to your dockerhub repo

```bash
docker push  <your dockerhub repo>/backstage-nomad-example:<add-tag-version>
```
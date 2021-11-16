# Docker Tips

## Waiting for Database to Start

[Example](https://gitlab.yougov.net/sst/POC_gotoproject/-/commit/16f8a499e450c0ae99151c5f8aa9fa6cfe207f1e)

You should create a wait for it script in `./scripts/wait-for-it.sh`:

```sh
#!/bin/sh

set -e

max_attempts=10
attempts=1

until $(curl --output /dev/null --silent http://<service>:<port>) || [ "$attempts" -eq "$max_attempts" ]; do
  >&2 echo "Neo4j is not responding after attempt ${attempts} - sleeping"
  sleep 3
  attempts=$((attempts + 1))
done

if [ "$attempts" = "$max_attempts" ]; then
  >&2 echo "Max attempts reached - exiting"
  exit 1
else
  >&2 echo "Neo4j is up - executing command"
fi

exec "$@"
```

Then remove your command from the Dockerfile and place it within the docker-compose file instead after the script:

```yml
    command: ["/app/scripts/wait-for-it.sh", "uvicorn", "gotoproject.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
```

Ensure we download curl in the Dockerfile:

```Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*
```

The gitlab ci test stage will also have to be altered:

```yaml
- docker-compose -p ${CI_JOB_ID} \
  -f docker/docker-compose.yml \
  run --name test_${CI_JOB_ID} \
  <service> /app/scripts/wait-for-it.sh pytest . --cov 
```

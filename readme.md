# RoadRunner

A simple container for running a PHP application based on the RoadRunner server.

## Build Image

```
docker build -t michaelbunch/roadrunner:<version> .
```

## How it works

Inside the container is a `/app` folder for your project code. RoadRunner will look in that
folder for a `.rr.yaml` file when starting.

In your `Dockerfile` ADD/COPY the application root to `/app` in the container.


## Run the container

```
docker run --name rr_app -p "8080:8080" michaelbunch/roadrunner:latest
```

This will run the `michaelbunch/roadrunner` container under the name `rr_app` on port `8080`.

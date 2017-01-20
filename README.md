# Sparklet
> A small Spark cluster, running in standalone mode. Suitable for testing and development.

## Usage

By default, this container will run a `spark-shell`.

```bash
$ docker build -t uncharted/sparklet .
$ docker run -it uncharted/sparklet
```

If you want to pass arguments to `spark-shell`:

```bash
$ docker run -it uncharted/sparklet spark-shell --packages software.uncharted.sparkpipe:sparkpipe-core:1.0.0
```

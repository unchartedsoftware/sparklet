# Tiny Spark
> A small Spark "cluster", running in standalone mode. Suitable for testing and development.

## Usage

```bash
$ docker build -t docker.uncharted.software/tiny-spark-standalone .
$ docker run -it docker.uncharted.software/tiny-spark-standalone bash
```

Then, inside the container

```bash
$ spark-shell
```

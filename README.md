# Tiny Spark
> A small Spark cluster, running in standalone mode. Suitable for testing and development.

## Usage

```bash
$ docker build -t uncharted/sparklet .
$ docker run -it uncharted/sparklet bash
```

Then, inside the container

```bash
$ spark-shell
```

# build docker image
build:
    podman build -t dradice/sgrid .

# executes docker image of sgrid
sgrid *ARGS:
    #!/usr/bin/env bash
    export OMP_NUM_THREADS="${OMP_NUM_THREADS:-4}"
    podman run \
        --rm -it \
        --userns=keep-id \
        -e OMP_NUM_THREADS \
        -v "$PWD":/work/data:Z \
        --cpus=$OMP_NUM_THREADS \
        dradice/sgrid {{ARGS}}

# push docker image to docker hub
push:
    podman push --creds $(cat .docker.auth) dradice/sgrid

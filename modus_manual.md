# Modus Manual

### print proof tree of a given query
modus proof . 'Image_name(X)'

### build debug or release images based on Modusfile
modus build . 'my_modus_test_image(X)' --json=build.json

### json output to track sha digests
jq . build.json

### tag images with a small jq script
jq '.[] | [.digest, .predicate + ":" + (.args | join("-"))] | join(" ")' build.json | xargs -I % sh -c 'docker tag %'

### images can be seen using docker
docker images | grep ImageName
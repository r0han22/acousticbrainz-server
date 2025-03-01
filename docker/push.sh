#!/bin/bash
#
# Build images from the currently checked out version of AcousticBrainz
# and push it to the Docker Hub, with an optional tag (by default "beta").
#
# Usage:
#   $ ./push.sh [env] [tag]
#
# Examples:
#   $ ./push.sh beta beta             # will push image with tag beta and deploy environment beta
#   $ ./push.sh prod v-2018-07-14.0   # will push images with tag v-2018-07-14.0 and deploy env prod

cd "$(dirname "${BASH_SOURCE[0]}")/../"

git describe --tags --dirty --always > .git-version

ENV=${1:-beta}
TAG=${2:-beta}

echo "Building AcousticBrainz web image with env $ENV tag $TAG..."
docker build -t metabrainz/acousticbrainz:$TAG \
        --target acousticbrainz-prod \
        --build-arg GIT_COMMIT_SHA=$(git describe --tags --dirty --always) .
echo "Done!"
echo "Pushing image to docker hub metabrainz/acousticbrainz-web:$TAG..."
docker push metabrainz/acousticbrainz:$TAG
echo "Done!"

#!/bin/sh

CHART_RELEASER_VERSION=v1.3.0

# install chart-releaser
if ! [ -d "$RUNNER_TOOL_CACHE" ] ; then
    printf 'Cache directory "%s" does not exist\n' "$RUNNER_TOOL_CACHE"
    exit 1
fi

arch="$(uname -m)"
cache_dir="$RUNNER_TOOL_CACHE/ct/$CHART_RELEASER_VERSION/$arch"

if ! [ -d "$cache_dir" ] ; then
    mkdir -p "$cache_dir" || exit 1
    curl -sSLo cr.tar.gz "https://github.com/helm/chart-releaser/releases/download/$CHART_RELEASER_VERSION/chart-releaser_${CHART_RELEASER_VERSION#v}_linux_amd64.tar.gz"
    tar -xzf cr.tar.gz -C "$cache_dir"
    rm -f cr.tar.gz
fi

printf 'Adding cr bin dir to PATH\n'
export PATH="$cache_dir:$PATH"

# ensure all chart versions match current tag
exit_code=0
for chart in ./charts/* ; do
    if [ -d "$chart" ] ; then
        chart_version=$(sed -n -e "s|^version: \(.*\)|\1|gp" "$chart/Chart.yaml")
        if ! [ "$chart_version" = "$GITHUB_REF_NAME" ] ; then
            printf 'Version (%s) of the chart %s does not match the tag (%s)\n' \
                "$chart_version" \
                "$chart" \
                "$GITHUB_REF_NAME"
            exit_code=1
        fi
    fi
done
if [ "$exit_code" -ne 0 ] ; then
    exit "$exit_code"
fi

# package charts
rm -rf .cr-release-packages
mkdir -p .cr-release-packages || exit 1
rm -rf .cr-index
mkdir -p .cr-index || exit 1
for chart in ./charts/* ; do
    if [ -d "$chart" ] ; then
        printf 'Packaging chart %s\n' "$chart"
        cr package --package-path .cr-release-packages "$chart" || exit 1
    fi
done

# upload releases
cr upload \
    -o "$CHART_RELEASER_OWNER" \
    -r "$CHART_RELEASER_REPO" \
    -c "$(git rev-parse HEAD)" \
|| exit 1

# update index
cr index \
    -o "$CHART_RELEASER_OWNER" \
    -r "$CHART_RELEASER_REPO" \
    -c "https://${CHART_RELEASER_OWNER}.github.io/${CHART_RELEASER_REPO}" \
    --push \
|| exit 1

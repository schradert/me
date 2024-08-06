#!/bin/bash

get_portfolio_objects() {
  objects_names=( $(
    gsutil ls 'gs://sandbox_main_bucket/portfolio/**' \
      | grep -v '^.*\.zip$' \
      | sed -E 's/.*(portfolio.*)/\1/g' \
      | jq -nR '[inputs]'
    )
  )

  join() {
    local IFS="$1"
    shift
    echo "$*"
  }
  base64_results=$(join '' "${objects_names[@]}" | base64 --wrap=0)

  jq -c -n --arg base64_results "$base64_results" '{"base64":$base64_results}'
}

generate_imgresizer() {
  rm imgresizer.zip
  zip -r -j imgresizer.zip ../functions/dist/src ../functions/package.json ../functions/yarn.lock
}

[[ $1 == "get_portfolio_objects" || $1 == "generate_imgresizer" ]] && "$@"

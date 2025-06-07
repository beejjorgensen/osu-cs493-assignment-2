#!/bin/sh

. ./curltest.sh

require_jq    # These tests assume jq is installed

#dotenv    # load .env

PORT=${PORT:-8000}  # Use port 8000 unless PORT env var specified

default_content_type="application/json"
default_base_url="http://localhost:$PORT"

default_verbose=1

status "Testing Businesses"

request "/businesses" \
    -l "Searching for all businessess" \
    --expect-code 200 \
    --expect-response '{}'

request "/businesses" \
    -l "Posting a new business" \
    -p '{"ownerid":0,"name":"New business 1","address":"123 Sample Ave.","city":"Sample City","state":"OR","zip":"97333","phone":"541-758-9999","category":"Restaurant","subcategory":"Brewpub","website":"http://example.com/1"}' \
    --expect-code 201

id1=$(extract_field id)
info "Got ID $id1"

request "/businesses" \
    -l "Posting a new business" \
    -p '{"ownerid":1,"name":"New business 2","address":"123 Sample Ave.","city":"Sample City","state":"OR","zip":"97333","phone":"541-758-9999","category":"Restaurant","subcategory":"Brewpub","website":"http://example.com/2"}' \
    --expect-code 201

id2=$(extract_field id)
info "Got ID $id2"

request "/businesses/$id1" \
    -l "Getting business $id1" \
    --expect-code 200 \
    --expect-response '{"reviews":[],"photos":[],"ownerid":0,"name":"New business 1","address":"123 Sample Ave.","city":"Sample City","state":"OR","zip":"97333","phone":"541-758-9999","category":"Restaurant","subcategory":"Brewpub","website":"http://example.com/1","id":'$id1'}'

request "/businesses/$id2" \
    -l "Getting business $id2" \
    --expect-code 200 \
    --expect-response '{"reviews":[],"photos":[],"ownerid":1,"name":"New business 2","address":"123 Sample Ave.","city":"Sample City","state":"OR","zip":"97333","phone":"541-758-9999","category":"Restaurant","subcategory":"Brewpub","website":"http://example.com/2","id":'$id2'}'

request "/businesses/999" \
    -l "Searching for non-existent business" \
    --expect-code 404 \
    --expect-response '{"error":"Requested resource /businesses/999 does not exist"}'


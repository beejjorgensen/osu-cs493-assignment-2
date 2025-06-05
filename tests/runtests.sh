#!/bin/sh

. ./curltest.sh

test -f ../.env && . ../.env

default_content_type="application/json"

default_base_url="http://localhost:$PORT"

default_verbose=0

status "Testing Businesses"

request \
    -u "/businesses/999" \
    --expect-code 404 \
    --expect-response '{"error":"Requested resource /businesses/999 does not exist"}'

request \
    -u "/businesses" \
    -p '{"ownerid":0,"name":"New business 1","address":"123 Sample Ave.","city":"Sample City","state":"OR","zip":"97333","phone":"541-758-9999","category":"Restaurant","subcategory":"Brewpub","website":"http://example.com/1"}' \
    --expect-code 201

id=$(extract_field id)

request \
    -u "/businesses/$id" \
    --expect-code 200 \
    --expect-response '{"reviews":[],"photos":[],"ownerid":0,"name":"New business 1","address":"123 Sample Ave.","city":"Sample City","state":"OR","zip":"97333","phone":"541-758-9999","category":"Restaurant","subcategory":"Brewpub","website":"http://example.com/1","id":'$id'}'


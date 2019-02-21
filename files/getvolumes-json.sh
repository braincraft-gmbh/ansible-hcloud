#!/bin/sh

FIELDS="id,linux_device,location,name,protection,server,size"

hcloud volume list -o noheader -o columns=$FIELDS | awk '
BEGIN {
    delete arr[0]
}
{
    split($4, a, "_");
    arr[length(arr) + 1] = \
    "\"" a[1] "\": { \
        \"id\": " "\"" $1 "\"," " \
        \"linux_device\": " "\"" $2 "\"," " \
        \"location\": " "\"" $3 "\"," " \
        \"name\": " "\"" $4 "\"," " \
        \"server\": " "\"" $5 "\"," " \
        \"size\": " "\"" $6 "\"," " \
        \"mount\": \"" a[2] "\" \
    }"
}
END {
    printf "{" arr[1];
    for (i = 2; i <= length(arr); ++i)
        printf "," arr[i];
    print "}"
}'

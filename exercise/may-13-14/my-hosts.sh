#! /bin/bash

if [ $1 ] && [ $1 = "--list" ]
then
    cat <<- EOF
{
    "deb": {
        "hosts": ["172.18.0.3","172.18.0.6"]
    },
    "rpm": {
        "hosts": ["172.18.0.2","172.18.0.5"]
    }
}
EOF
elif [ $1 ] && [ $2 ]  && [ $1 = "--host" ]
then
    cat <<- EOF
{
    "sample1": "1234"
}
EOF
else
    echo "{}"
fi

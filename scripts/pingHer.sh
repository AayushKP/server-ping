#!/bin/bash

# The single URL to test
url="https://comuniq.onrender.com"

# Timeout in seconds for the request
timeout=2

echo "Testing URL: $url"

response_code=$(curl -s -o /dev/null --max-time "$timeout" -w "%{http_code}" "$url")
curl_exit_code=$?

if [ $curl_exit_code -ne 0 ]; then
    case $curl_exit_code in
        6)  error="Couldn't resolve host";;
        7)  error="Failed to connect";;
        28) error="Timeout reached";;
        *)  error="Curl error code: $curl_exit_code";;
    esac
    echo "Connection failed: $error"
else
    if [[ $response_code =~ ^2[0-9]{2}$ ]]; then
        echo "Success - HTTP $response_code"
    elif [[ $response_code =~ ^3[0-9]{2}$ ]]; then
        echo "Redirection - HTTP $response_code"
    elif [[ $response_code =~ ^4[0-9]{2}$ ]]; then
        echo "Client Error - HTTP $response_code"
    elif [[ $response_code =~ ^5[0-9]{2}$ ]]; then
        echo "Server Error - HTTP $response_code"
    else
        echo "Unexpected Response - HTTP $response_code"
    fi
fi

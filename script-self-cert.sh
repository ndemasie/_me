#!/usr/bin/env bash

openssl req -newkey rsa:4096 -x509 -sha256 -nodes \
  -keyout key.pem \
  -out cert.pem \
  -days 3650 \
  -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"

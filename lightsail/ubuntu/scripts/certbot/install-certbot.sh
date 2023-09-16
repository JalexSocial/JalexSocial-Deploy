#!/bin/bash

certbot --nginx --non-interactive --agree-tos --redirect -m mike@logic-gate.com -d dev.jalex.io


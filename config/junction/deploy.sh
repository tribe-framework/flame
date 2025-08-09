#!/usr/bin/env bash

cd applications/junction
rm .env
npm run build
php sync-dist.php
ln -sf ../../.env .env

exit 0

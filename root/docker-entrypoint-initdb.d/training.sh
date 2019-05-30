#!/bin/sh

pg_dump -C service=training | psql -h localhost -U postgres
#  psql -U postgres -qc 'ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO student'

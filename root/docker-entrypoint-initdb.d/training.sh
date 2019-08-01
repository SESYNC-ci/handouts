#!/bin/sh

pg_dump -C service=training | psql -h localhost -U postgres
#  psql -U postgres -qc 'ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO student'

# # Database
#
# check if database exists, and populate if false
# so ...

# psql -h postgres -u postgres -qc 'REVOKE ALL ON schema public FROM public'
# createdb portal
# createuser --no-login student
# psql portal -qc 'ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO student'
# psql portal -q < portal.sql

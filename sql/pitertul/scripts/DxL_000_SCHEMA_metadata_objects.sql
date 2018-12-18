set heading on
set pagesize 50000
set feedback off
set linesize 250
col OWNER format a15
col OBJECT_TYPE format a15
col OBJECT_NAME format a50
SELECT
owner,
object_type,
object_name
FROM
all_objects
WHERE (owner ='SUT')
ORDER BY
object_type,
object_name;

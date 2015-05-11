/*select
'drop table ' || rtrim(tabschema) || '.' || tabname
from
syscat.tables
where
tabschema = 'PFSMASTER' and
type = 'T'

*/
drop schema PFSMASTER RESTRICT
--Aca deberia estar vacio
update ${master.schema}.ENTIDADCONFIG set DATAVALUE = 'jdbc:oracle:thin:TEST_PFS01/admin@//arbadb02.spain.capgemini.com:1521/PFS'
where ENTIDAD_ID = 1 AND DATAKEY = 'url';
update ${master.schema}.ENTIDADCONFIG set DATAVALUE = 'jdbc:oracle:thin:TEST_PFS02/admin@//arbadb02.spain.capgemini.com:1521/PFS'
where ENTIDAD_ID = 2 AND DATAKEY = 'url';
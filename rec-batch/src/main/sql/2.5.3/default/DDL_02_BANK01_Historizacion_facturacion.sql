-- ##########################################
-- ## Author: Guillem Pascual
-- ## Finalidad: Crear una nueva tabla para historizar el Recobro Detalle Facturación
-- ## 
-- ## INSTRUCCIONES:
-- ## VERSIONES:
-- ##        1.0 Version inicial
-- ##########################################

DECLARE
    -- Vble. para validar la existencia de las Tablas.
    table_count number(3);
    -- Querys
    query_body varchar (30048);
    
    NAME_IN_USE EXCEPTION;
   pragma EXCEPTION_INIT(NAME_IN_USE, -955 );
BEGIN

 	select count(1) into table_count from all_tables WHERE table_name='H_RDF_RECOBRO_DETALLE_FACTURA';
	if table_count = 1 then
 		query_body := 'DROP TABLE BANK01.H_RDF_RECOBRO_DETALLE_FACTURA';  EXECUTE IMMEDIATE query_body;
	end if;

	query_body := ' CREATE TABLE BANK01.H_RDF_RECOBRO_DETALLE_FACTURA (
					FECHA_HIST TIMESTAMP (6) NOT NULL ENABLE,
					H_RDF_ID NUMBER(16,0) NOT NULL ENABLE, 
					RDF_ID NUMBER(16,0) NOT NULL ENABLE, 
					PFS_ID NUMBER(16,0) NOT NULL ENABLE, 
					CPA_ID NUMBER(16,0) NOT NULL ENABLE, 
					CNT_ID NUMBER(16,0) NOT NULL ENABLE, 
					EXP_ID NUMBER(16,0) NOT NULL ENABLE, 
					RDF_FECHA_COBRO TIMESTAMP (6) NOT NULL ENABLE, 
					RDF_PORCENTAJE NUMBER(16,2), 
					RDF_IMPORTE_A_PAGAR NUMBER(16,2) NOT NULL ENABLE, 
					VERSION NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
					USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL ENABLE, 
					FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
					USUARIOMODIFICAR VARCHAR2(10 CHAR), 
					FECHAMODIFICAR TIMESTAMP (6), 
					USUARIOBORRAR VARCHAR2(10 CHAR), 
					FECHABORRAR TIMESTAMP (6), 
					BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
					RCF_TCC_ID NUMBER(16,0) NOT NULL ENABLE,
          				RDF_IMP_CONCEP_FACTU	NUMBER(16,2),
					RDF_IMP_REAL_FACTU	NUMBER(16,2),
					RCF_SCA_ID	NUMBER(16,0),
					RCF_AGE_ID	NUMBER(16,0)
		)'; EXECUTE IMMEDIATE query_body;
  BEGIN
    query_body := 'CREATE SEQUENCE S_H_RDF_RECOBRO_DETALLE_FAC'; EXECUTE IMMEDIATE query_body;
  EXCEPTION WHEN NAME_IN_USE THEN
    DBMS_OUTPUT.PUT_LINE('La secuencia ya existe');
  END;
	
	COMMIT;
	
END;
/

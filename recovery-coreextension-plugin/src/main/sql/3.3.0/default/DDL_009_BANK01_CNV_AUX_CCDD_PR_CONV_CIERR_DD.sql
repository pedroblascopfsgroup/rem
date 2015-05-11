--/*
--##########################################
--## Author: Alejandro I�igo
--## Finalidad: CREATE  de tabla CNV_AUX_CCDD_PR_CONV_CIERR_DD
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##		0.1 Versión inicial
--#############################################
--*/

whenever sqlerror exit sql.sqlcode;

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
    v_seq_count number(3);
    v_table_count number(3);
    v_schema varchar(30) := 'BANK01';
    v_schema_master varchar(30) := 'BANKMASTER';
    v_constraint_count number(3);
BEGIN

    v_seq_count := 0;
    v_table_count := 0;

    --tabla CNV_AUX_CCDD_PR_CONV_CIERR_DD <-- ELIMINAR

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla CNV_AUX_CCDD_PR_CONV_CIERR_DD');

    select count(1) into v_table_count from USER_tables where table_name = 'CNV_AUX_CCDD_PR_CONV_CIERR_DD';
    if v_table_count > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| v_schema ||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| v_schema ||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| v_schema ||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD
      (
       ID_ACUERDO_CIERRE NUMBER(22)      ,
       ID_PROCEDI        NUMBER(22)      ,       
       FECHA_ALTA        DATE            ,
       ASU_ID            NUMBER(22)      ,       	   
       FECHA_ENTREGA     DATE            ,
       USUARIOCREAR      VARCHAR2(40)
       )                   
        TABLESPACE ' || v_schema || '
        PCTUSED    0
        PCTFREE    10
        INITRANS   1
        MAXTRANS   255
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   )
        LOGGING 
        NOCOMPRESS 
        NOCACHE
        NOPARALLEL
        MONITORING ';
        
	DBMS_OUTPUT.PUT_LINE('TABLE '|| v_schema ||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD... Tabla CREADA OK');
    
    --Creamos indices
	DBMS_OUTPUT.PUT_LINE('[INFO] '||v_schema||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD... Creacion de indices'); 
	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

   EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || v_schema || '.IDX_PK_CCDD_PR_CONV_ID_ACUERDO ON ' || v_schema || '.CNV_AUX_CCDD_PR_CONV_CIERR_DD
					(ID_ACUERDO_CIERRE)
				LOGGING
				TABLESPACE '|| v_schema ||'
				PCTFREE    10
				INITRANS   2
				MAXTRANS   255
				STORAGE 	(
            					INITIAL          64K
            					NEXT             1M
            					MINEXTENTS       1
            					MAXEXTENTS       UNLIMITED
            					PCTINCREASE      0
            					BUFFER_POOL      DEFAULT
           				 	)
				NOPARALLEL';		
   
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.IDX_PK_CCDD_PR_CONV_ID_ACUERDO... Indice creado');
   --
   EXECUTE IMMEDIATE 'CREATE INDEX ' || v_schema || '.IDX_CCDD_PR_CONV_ID_PROCEDI ON ' || v_schema || '.CNV_AUX_CCDD_PR_CONV_CIERR_DD
					(ID_PROCEDI)
				LOGGING
				TABLESPACE '|| v_schema ||'
				PCTFREE    10
				INITRANS   2
				MAXTRANS   255
				STORAGE 	(
            					INITIAL          64K
            					NEXT             1M
            					MINEXTENTS       1
            					MAXEXTENTS       UNLIMITED
            					PCTINCREASE      0
            					BUFFER_POOL      DEFAULT
           				 	)
				NOPARALLEL';		
   
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.IDX_CCDD_PR_CONV_ID_PROCEDI... Indice creado');
   --
   EXECUTE IMMEDIATE 'CREATE INDEX ' || v_schema || '.IDX_CCDD_PR_CONV_ASU_ID ON ' || v_schema || '.CNV_AUX_CCDD_PR_CONV_CIERR_DD
					(ASU_ID)
				LOGGING
				TABLESPACE '|| v_schema ||'
				PCTFREE    10
				INITRANS   2
				MAXTRANS   255
				STORAGE 	(
            					INITIAL          64K
            					NEXT             1M
            					MINEXTENTS       1
            					MAXEXTENTS       UNLIMITED
            					PCTINCREASE      0
            					BUFFER_POOL      DEFAULT
           				 	)
				NOPARALLEL';		
   
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.IDX_CCDD_PR_CONV_ASU_ID... Indice creado');   

-- Comprobamos si existe la secuencia

    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_CCDD_PR_CONV_CIERR_DD_PK'' 
             and sequence_owner = '''||v_schema||'''' INTO v_table_count; 

    -- Si existe secuencia la borramos
    IF v_table_count = 1 THEN
      EXECUTE IMMEDIATE 'DROP SEQUENCE '||v_schema||'.S_CCDD_PR_CONV_CIERR_DD_PK';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.S_CCDD_PR_CONV_CIERR_DD_PK... Secuencia eliminada');    
    END IF; 
    
    EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_schema || '.S_CCDD_PR_CONV_CIERR_DD_PK'; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.S_CCDD_PR_CONV_CIERR_DD_PK... Secuencia creada');
	DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');
    
EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/

exit

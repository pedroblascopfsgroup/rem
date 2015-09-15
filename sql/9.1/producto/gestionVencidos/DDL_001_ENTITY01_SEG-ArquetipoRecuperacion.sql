--/*
--##########################################
--## AUTOR=CARLOS PEREZ
--## FECHA_CREACION=20150611
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=NO-DISPONIBLE
--## INCIDENCIA_LINK=NO-DISPONIBLE
--## PRODUCTO=SI
--##
--## Finalidad: Adaptar el modelo de datos al proceso batch de arquetipación de recuperaciones
--## INSTRUCCIONES: --
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

whenever sqlerror exit sql.sqlcode;


SET SERVEROUTPUT ON; 

DECLARE
v_seq_count number(3);
v_table_count number(3);
V_ESQUEMA   VARCHAR(25) := '#ESQUEMA_ENTIDAD#';
V_ESQUEMA_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
v_table_space VARCHAR(25) := '#TABLESPACE_INDEX#';
V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
v_constraint_count number(3);
V_SQL varchar2(4000);

BEGIN



DBMS_OUTPUT.PUT_LINE('[START] Arquetipación de personas de recuperación');

 V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ARR_ARQ_RECUPERACION_PERSONA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_SQL := 'DROP TABLE '||V_ESQUEMA||'.ARR_ARQ_RECUPERACION_PERSONA CASCADE CONSTRAINTS';      
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ARR_ARQ_RECUPERACION_PERSONA... Tabla borrada');  
    END IF;
    
EXECUTE IMMEDIATE '
  CREATE TABLE ' || V_ESQUEMA || '.ARR_ARQ_RECUPERACION_PERSONA 
   (ARR_ID NUMBER(16,0), 
	PER_ID NUMBER(16,0), 
	ARQ_ID NUMBER(16,0), 
	ARQ_NAME VARCHAR2(100 CHAR), 
	ARQ_PRIO NUMBER(16,0), 
	ARQ_DATE TIMESTAMP (6), 
	VERSION NUMBER(1,0), 
	USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
	USUARIOMODIFICAR VARCHAR2(10 CHAR), 
	FECHAMODIFICAR TIMESTAMP (6), 
	USUARIOBORRAR VARCHAR2(10 CHAR), 
	FECHABORRAR TIMESTAMP (6), 
	BORRADO NUMBER(1,0) NOT NULL ENABLE)';
 
 DBMS_OUTPUT.PUT_LINE('[INFO] Creación tabla ARR_ARQ_RECUPERACION_PERSONA');


  EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '."IDX_ARR_ARQ_DATE" ON ' || V_ESQUEMA || '."ARR_ARQ_RECUPERACION_PERSONA" ("ARQ_DATE") 
  TABLESPACE '|| v_table_space;
  
 DBMS_OUTPUT.PUT_LINE('[INFO] Indice IDX_ARR_ARQ_DATE creado');

  EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '."IDX_ARR_ID_ARQ_DATE" ON ' || V_ESQUEMA || '."ARR_ARQ_RECUPERACION_PERSONA" ("PER_ID", "ARQ_DATE" DESC) 
  TABLESPACE ' || v_table_space;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Indice IDX_ARR_ID_ARQ_DATE creado');

  EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '."IDX_ARR_PER_ID" ON ' || V_ESQUEMA || '."ARR_ARQ_RECUPERACION_PERSONA" ("PER_ID") 
  TABLESPACE ' || v_table_space;
  
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Indice IDX_ARR_PER_ID creado');
  
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_ARR_ARQ_RECUPERACION_PERSONA'' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_SQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_ARR_ARQ_RECUPERACION_PERSONA';      
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_ARR_ARQ_RECUPERACION_PERSONA... Secuencia borrada');  
    END IF;
  
  
  EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || V_ESQUEMA ||'.S_ARR_ARQ_RECUPERACION_PERSONA';
  DBMS_OUTPUT.PUT_LINE('[INFO] Secuencia S_ARR_ARQ_RECUPERACION_PERSONA creada');
 
 -- CAMBIAR TAMAÑO CAMPO USUARIOCREAR 
  EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.LIA_LISTA_ARQUETIPOS MODIFY USUARIOCREAR VARCHAR2 (10 CHAR)';
  DBMS_OUTPUT.PUT_LINE('[INFO] Campo USUARIOCREAR de la tabla LIA_LISTA_ARQUETIPOS modificado');

 -- CAMBIAR TAMAÑO CAMPO MOA_NOMBRE DE MOA_MODELOS_ARQ
  EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.MOA_MODELOS_ARQ MODIFY MOA_NOMBRE VARCHAR2 (50 CHAR)';
  DBMS_OUTPUT.PUT_LINE('[INFO] Campo NOMBRE de la tabla MOA_MODELOS_ARQ modificado');


DBMS_OUTPUT.PUT_LINE('[END] Arquetipación de personas de recuperación');
 
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    --WHEN TABLE_EXISTS_EXCEPTION THEN
    --   DBMS_OUTPUT.PUT_LINE('La tabla ya existia');
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;


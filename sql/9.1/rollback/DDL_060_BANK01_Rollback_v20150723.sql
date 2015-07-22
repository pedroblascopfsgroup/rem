--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20150722
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=Rollback
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN

--DDL_045_BANK01_CREAR_DICCIONARIO_RES_VAL_CDD.sql

SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_cols  
         WHERE UPPER(table_name) = 'DD_RVC_RES_VALIDACION_CDD' and (UPPER(column_name) = 'DD_RVC_ID') 
         AND OWNER = V_ESQUEMA; 
          
     if V_NUM_TABLAS = 0 then 
     
--##COMPROBACION EXISTENCIA SECUENCIA, BORRAR PRIMERO
V_NUM_SEQ := 0;
select count(1) INTO V_NUM_SEQ from all_sequences
where sequence_owner = V_ESQUEMA
and sequence_name = 'S_DD_RVC_RES_VALIDACION_CDD';

if V_NUM_SEQ > 0 then 
--YA existe una versión de la secuencia , se elimina primero
  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la secuencia S_DD_RVC_RES_VALIDACION_CDD: se ELIMINA...');
  EXECUTE IMMEDIATE 'drop sequence '||V_ESQUEMA||'.S_DD_RVC_RES_VALIDACION_CDD';
  DBMS_OUTPUT.PUT_LINE('OK');
END IF;

	 

--##COMPROBACION EXISTENCIA TABLA, BORRAR PRIMERO
V_NUM_TABLAS := 0;
select count(1) INTO V_NUM_TABLAS from all_tables 
where table_name = 'DD_RVC_RES_VALIDACION_CDD' and OWNER = V_ESQUEMA;

if V_NUM_TABLAS > 0 then 
--YA existe una versión de la tabla , se elimina primero

  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la tabla DD_RVC_RES_VALIDACION_CDD: se ELIMINA...');
	EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.DD_RVC_RES_VALIDACION_CDD';
  DBMS_OUTPUT.PUT_LINE('OK');

END IF;

  
--DDL_046_BANK01_ALTER_TABLE_BATCH_CIERRE_DEUDA.sql

V_SQL := 'select COUNT(1) from all_tab_cols where UPPER(OWNER)='''||V_ESQUEMA||''' 
  and UPPER(table_name)=''CNV_AUX_CCDD_PR_CONV_CIERR_DD'' and UPPER(column_name)=''ORIGEN_PROPUESTA''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS;

IF V_NUM_COLS > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD...no se modifica nada.');
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD DROP COLUMN ORIGEN_PROPUESTA'; 
	
END IF;

EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD... Tabla modificada');  


V_SQL := 'select COUNT(1) from all_tab_cols where UPPER(OWNER)='''||V_ESQUEMA||''' 
  and UPPER(table_name)=''CNV_AUX_CCDD_PR_CONV_CIERR_DD'' and UPPER(column_name)=''RESULTADO_VALIDACION''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS;

IF V_NUM_COLS > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD...no se modifica nada.');
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD DROP COLUMN RESULTADO_VALIDACION'; 
	
END IF;
		
EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD... Tabla modificada');



V_SQL := 'select COUNT(1) from all_tab_cols where UPPER(OWNER)='''||V_ESQUEMA||''' 
  and UPPER(table_name)=''CNV_AUX_CCDD_PR_CONV_CIERR_DD'' and UPPER(column_name)=''DD_RVC_ID''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS; 

IF V_NUM_COLS > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD...no se modifica nada.');
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD DROP COLUMN DD_RVC_ID'; 

END IF;

EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD... Tabla modificada');  


--DDL_047_BANK01_CREAR_CONVIVENCIA_RECHAZOS.sql

--##COMPROBACION EXISTENCIA SECUENCIA, BORRAR PRIMERO
V_NUM_SEQ := 0;
select count(1) INTO V_NUM_SEQ from all_sequences
where sequence_owner = V_ESQUEMA
and sequence_name = 'S_CDD_CRN_RESULTADO_NUSE';

if V_NUM_SEQ > 0 then 
--YA existe una versión de la secuencia , se elimina primero
  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la secuencia S_CDD_CRN_RESULTADO_NUSE: se ELIMINA...');
  EXECUTE IMMEDIATE 'drop sequence '||V_ESQUEMA||'.S_CDD_CRN_RESULTADO_NUSE';
  DBMS_OUTPUT.PUT_LINE('OK');
END IF;


--##COMPROBACION EXISTENCIA TABLA, BORRAR PRIMERO
V_NUM_TABLAS := 0;
select count(1) INTO V_NUM_TABLAS from all_tables 
where table_name = 'CDD_CRN_RESULTADO_NUSE' and OWNER = V_ESQUEMA;

if V_NUM_TABLAS > 0 then 
--YA existe una versión de la tabla , se elimina primero

  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la tabla CDD_CRN_RESULTADO_NUSE: se ELIMINA...');
	EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.CDD_CRN_RESULTADO_NUSE';
  DBMS_OUTPUT.PUT_LINE('OK');

END IF;


--DDL_048_BANK01_CREAR_DICCIONARIO_RES_VAL_NUSE.sql

--##COMPROBACION EXISTENCIA SECUENCIA, BORRAR PRIMERO
V_NUM_SEQ := 0;
select count(1) INTO V_NUM_SEQ from all_sequences
where sequence_owner = V_ESQUEMA
and sequence_name = 'S_CDD_CRN_RESULTADO_NUSE';

if V_NUM_SEQ > 0 then 
--YA existe una versión de la secuencia , se elimina primero
  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la secuencia S_DD_RVN_RES_VALIDACION_NUSE: se ELIMINA...');
  EXECUTE IMMEDIATE 'drop sequence '||V_ESQUEMA||'.S_DD_RVN_RES_VALIDACION_NUSE';
  DBMS_OUTPUT.PUT_LINE('OK');
END IF;


--##COMPROBACION EXISTENCIA TABLA, BORRAR PRIMERO
V_NUM_TABLAS := 0;
select count(1) INTO V_NUM_TABLAS from all_tables 
where table_name = 'DD_RVN_RES_VALIDACION_NUSE' and OWNER = V_ESQUEMA;

if V_NUM_TABLAS > 0 then 
--YA existe una versión de la tabla , se elimina primero

  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la tabla DD_RVN_RES_VALIDACION_NUSE: se ELIMINA...');
	EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.DD_RVN_RES_VALIDACION_NUSE';
  DBMS_OUTPUT.PUT_LINE('OK');

END IF;




	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT	
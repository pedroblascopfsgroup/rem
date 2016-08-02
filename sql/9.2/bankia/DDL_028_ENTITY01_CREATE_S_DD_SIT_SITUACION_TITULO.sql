--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20160708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2251
--## PRODUCTO=SI
--##
--## Finalidad: Creamos secuencia para la tabla DD_SIT_SITUACION_TITULO 
--## INSTRUCCIONES: Definir las variables de esquema antes de ejecutarlo.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
	value_current_seq_count number(32); -- Vble. para conseguir el valor inicial de una secuencia.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count_copy number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_column_count_fk number(3); -- Vble. para validar la existencia de las Columnas deFK.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    v_constraint_name varchar2(32 char); -- Vble. para trabajar con una Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    TABLA VARCHAR2(30 CHAR) :='DD_SIT_SITUACION_TITULO';
	SECUENCIA VARCHAR2(30 CHAR) :='S_DD_SIT_SITUACION_TITULO';
	
BEGIN 
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||TABLA||' ... Comprobamos si existe la secuencia '||SECUENCIA||'.');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TRIM(UPPER(table_name)) =TRIM(UPPER('''||TABLA||'''))'; 
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE TRIM(UPPER(sequence_name)) =TRIM(UPPER('''||SECUENCIA||'''))'; 
	EXECUTE IMMEDIATE V_MSQL INTO seq_count;
	
	IF (table_count = 1) AND (seq_count = 0)  THEN
		V_MSQL := 'SELECT MAX(DD_SIT_ID) + 1 FROM '||V_ESQUEMA||'.'||TABLA;
		EXECUTE IMMEDIATE V_MSQL INTO value_current_seq_count;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... La valor maximo de identificados mas uno es ['||value_current_seq_count||'].');
		V_MSQL := 'CREATE SEQUENCE '||SECUENCIA||' INCREMENT BY 1 START WITH '||value_current_seq_count||'';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... La secuencia ['||SECUENCIA||'] se ha creado.');
	ELSE 
		IF (seq_count = 1) THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... La secuencia indicada ya existe ['||SECUENCIA||'].');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... La tabla indicada no existe ['||TABLA||'].');
		END IF;
	END IF;
	
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLA||'... Se ha creado la tabla auxiliar.');
		
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'||TABLA||'... Crear tabla auxiliar.');

EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);
		ROLLBACK;
		RAISE;	  
END;

/
 
EXIT;

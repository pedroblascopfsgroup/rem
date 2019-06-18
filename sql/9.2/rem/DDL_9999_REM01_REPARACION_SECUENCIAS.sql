--/*
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20190522
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6397
--## PRODUCTO=SI
--## Finalidad: DDL para reparar las secuencias mal posicionadas.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 - Joaquin Arnal - Versión inicial (20180522)
--##        0.2 - Joaquin Arnal - Añadimos GRANT (20180529)
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
	V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquemas  
	V_ESQUEMA_DS VARCHAR2(25 CHAR):= '#ESQUEMA_DATASTAGE#'; -- Configuracion Esquemas 
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_TABLA VARCHAR2(2400 CHAR) := ''; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

	V_ID_MAX_TABLA NUMBER(32); 
	V_ID_ACTUAL_SEQ NUMBER(32); 
	V_INCREMENTO NUMBER(32); 

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	-- 	    ESQUEMA_SEQ 	SEQUENCE  		    ESQUEMA_TABLA      TABLE   			ID_TABLE
	T_TIPO_DATA('#ESQUEMA#','S_ACT_NUM_ACTIVO_REM','#ESQUEMA#','ACT_ACTIVO','ACT_ID', 'REM01')	
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
   	DBMS_OUTPUT.PUT_LINE('[INICIO] Reparamos las secuencias.');  
  
	-- LOOP para insertar los valores.
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		V_ID_MAX_TABLA := 0; 
		V_ID_ACTUAL_SEQ := 0; 

		--Comprobar el maximo ID de la tabla.
		V_SQL := 'SELECT MAX('||V_TMP_TIPO_DATA(5)||') FROM '||V_TMP_TIPO_DATA(3)||'.'||V_TMP_TIPO_DATA(4)||'';
		DBMS_OUTPUT.PUT_LINE('[EJECUTADO]:['||V_SQL||']');
		EXECUTE IMMEDIATE V_SQL INTO V_ID_MAX_TABLA;

		V_SQL := 'SELECT '||V_TMP_TIPO_DATA(1)||'.'||V_TMP_TIPO_DATA(2)||'.NEXTVAL FROM DUAL';
		DBMS_OUTPUT.PUT_LINE('[EJECUTADO]:['||V_SQL||']');
		EXECUTE IMMEDIATE V_SQL INTO V_ID_ACTUAL_SEQ;

		DBMS_OUTPUT.PUT_LINE('[INFO]: ITERACION -> ['|| I ||'].');
		DBMS_OUTPUT.PUT_LINE('[INFO]: V_ID_MAX_TABLA -> ['|| V_ID_MAX_TABLA ||'] DE LA TABLA '||V_TMP_TIPO_DATA(3)||'.'||V_TMP_TIPO_DATA(4)||'.');
		DBMS_OUTPUT.PUT_LINE('[INFO]: V_ID_ACTUAL_SEQ -> ['|| V_ID_ACTUAL_SEQ ||'] DE LA SECUENCIA '||V_TMP_TIPO_DATA(1)||'.'||V_TMP_TIPO_DATA(2)||'.');	

		IF V_ID_MAX_TABLA > V_ID_ACTUAL_SEQ THEN				
	  		V_MSQL := 'drop sequence '||V_TMP_TIPO_DATA(1)||'.'||V_TMP_TIPO_DATA(2);
			DBMS_OUTPUT.PUT_LINE('[EJECUTADO]:['||V_MSQL||']');
			EXECUTE IMMEDIATE V_MSQL;
	  		DBMS_OUTPUT.PUT_LINE('[INFO]: SECUENCIA BORRADA '||V_TMP_TIPO_DATA(1)||'.'||V_TMP_TIPO_DATA(2));

			V_MSQL := 'create sequence '||V_TMP_TIPO_DATA(1)||'.'||V_TMP_TIPO_DATA(2)||'
				           start with ' || V_ID_MAX_TABLA
				      || ' increment by 1
				           nomaxvalue
				           nocycle
				           nocache';
			DBMS_OUTPUT.PUT_LINE('[EJECUTADO]:['||V_MSQL||']');			
			EXECUTE IMMEDIATE V_MSQL;			
	  		DBMS_OUTPUT.PUT_LINE('[INFO]: SECUENCIA CREADA '||V_TMP_TIPO_DATA(1)||'.'||V_TMP_TIPO_DATA(2));

			V_MSQL := 'grant select on '||V_TMP_TIPO_DATA(1)||'.'||V_TMP_TIPO_DATA(2)||' TO '||V_TMP_TIPO_DATA(6)||'';
			DBMS_OUTPUT.PUT_LINE('[EJECUTADO]:['||V_MSQL||']');			
			EXECUTE IMMEDIATE V_MSQL;			
	  		DBMS_OUTPUT.PUT_LINE('[INFO]: Añadido permisos al esquema '||V_TMP_TIPO_DATA(6)||' para '||V_TMP_TIPO_DATA(1)||'.'||V_TMP_TIPO_DATA(2));


		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: SECUENCIA CORRECTA');
		END IF;
	END LOOP;
	
	COMMIT;
 	DBMS_OUTPUT.PUT_LINE('[FIN].');
   
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;

--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190611
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.9.0
--## INCIDENCIA_LINK=HREOS-5932
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(5000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
	V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
	V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'PFSREM';
	V_COUNT NUMBER(16);
	V_COUNT2 NUMBER(16);
	
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--    TABLA_FINAL					TABLA_BACKUP
		T_TIPO_DATA('HIST_PTA_PATRIMONIO_ACTIVO'	,'AUX_HIST_PTA_HREOS_5932'),
		T_TIPO_DATA('ACT_PTA_PATRIMONIO_ACTIVO'		,'AUX_ACT_PTA_HREOS_5932'),
		T_TIPO_DATA('ACT_SPS_SIT_POSESORIA'			,'AUX_ACT_SPS_HREOS_5932'),
		T_TIPO_DATA('ACT_APU_ACTIVO_PUBLICACION'	,'AUX_ACT_APU_HREOS_5932'),
		T_TIPO_DATA('ACT_AHP_HIST_PUBLICACION'		,'AUX_ACT_AHP_HREOS_5932'),
		T_TIPO_DATA('GAC_GESTOR_ADD_ACTIVO'			,'AUX_GAC_GESTOR_HREOS_5932'),
		T_TIPO_DATA('GEE_GESTOR_ENTIDAD'			,'AUX_GEE_GESTOR_HREOS_5932'),
		T_TIPO_DATA('GAH_GESTOR_ACTIVO_HISTORICO'	,'AUX_GAH_GESTOR_HREOS_5932'),
		T_TIPO_DATA('GEH_GESTOR_ENTIDAD_HIST'		,'AUX_GEH_GESTOR_HREOS_5932'),
		T_TIPO_DATA('OFR_OFERTAS'					,'AUX_OFR_HREOS_5932'),
		T_TIPO_DATA('ECO_EXPEDIENTE_COMERCIAL'		,'AUX_ECO_HREOS_5932'),
		T_TIPO_DATA('ACT_TRA_TRAMITE'				,'AUX_ACT_TRA_HREOS_5932'),
		T_TIPO_DATA('TAR_TAREAS_NOTIFICACIONES'		,'AUX_TAR_TAREAS_HREOS_5932'),
		T_TIPO_DATA('TEX_TAREA_EXTERNA'				,'AUX_TEX_TAREA_HREOS_5932')
		
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de crear tablas backup...'); 
	
	-- Se insertan las tablas afectadas en un tabla.
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se informa de las tablas afectadas por la migración ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
      
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
			SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

			IF TABLE_COUNT > 0 THEN

				DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TMP_TIPO_DATA(2)||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

				EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TMP_TIPO_DATA(2)||'';
				
			END IF;
			
			V_MSQL := 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TMP_TIPO_DATA(2)||' AS (SELECT * FROM '||V_ESQUEMA_1||'.'||V_TMP_TIPO_DATA(1)||' )';
			
			EXECUTE IMMEDIATE V_MSQL;
			
			
			V_MSQL := 'UPDATE '||V_ESQUEMA_1||'.AUX_MIG_ALQUILERES_TAB_AFEC SET TABLA_BACKUP = '||V_TMP_TIPO_DATA(2)||' WHERE TABLA = '''||V_TMP_TIPO_DATA(1)||'''';
			
			EXECUTE IMMEDIATE V_MSQL;
			
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] Se ha creado la tabla '||V_ESQUEMA_1||'.'||V_TMP_TIPO_DATA(2)||' .');
			
			IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

			EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TMP_TIPO_DATA(2)||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';

			DBMS_OUTPUT.PUT_LINE('	[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TMP_TIPO_DATA(2)||' OTORGADOS A '||V_ESQUEMA_2||''); 

			END IF;

			IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

			EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TMP_TIPO_DATA(2)||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';

			DBMS_OUTPUT.PUT_LINE('	[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TMP_TIPO_DATA(2)||' OTORGADOS A '||V_ESQUEMA_3||''); 

			END IF;
			
		END LOOP;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT

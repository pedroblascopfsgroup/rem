--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7837
--## PRODUCTO=NO
--## Finalidad: vista CRUCE ALERTAS PUBLICACION Y TABLA CONFIGURACION 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 REMVIP-6440 - Versión inicial
--##	    0.2 REMVIP-7759 - Sa cambia orden y reglas de la vista
--##	    0.3 REMVIP-7837 - Cambia calculo 'APLICA'
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 
    V_TABLA VARCHAR2(30 CHAR) := 'V_CONF_ALERTAS_PUBLICACION';

    CUENTA NUMBER;

    V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
    V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
    V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
    V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
    V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_CONF_ALERTAS_PUBLICACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_CONF_ALERTAS_PUBLICACION...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_CONF_ALERTAS_PUBLICACION';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_CONF_ALERTAS_PUBLICACION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_CONF_ALERTAS_PUBLICACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_CONF_ALERTAS_PUBLICACION...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_CONF_ALERTAS_PUBLICACION';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_CONF_ALERTAS_PUBLICACION... borrada OK');
  END IF;

  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_CONF_ALERTAS_PUBLICACION...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_CONF_ALERTAS_PUBLICACION 
	AS  
	SELECT
	T1.NUM_ACTIVO,
	T1.FASE_PUBLICACION,
	CASE WHEN T1.CARTERA = ''SAREB'' AND ((T1.ALERTA_INSCRIPCION * T2.INSCRIPCION ) +
	(T1.ALERTA_CARGAS * T2.CARGAS) +
	(T1.ALERTA_POSESION * T2.POSESION) +
	(T1.ALERTA_TIPO_ALQUILER * T2.TIPO_ALQUILER) +
	(T1.ALERTA_ALQUILER * T2.ALQUILADO) +
	(T1.ALERTA_TCO_ALQUILER * T2.TCO_ALQUILER * T1.ALERTA_OKUPADO) +
	(T1.ALERTA_FECHA_DECRETO * T2.FECHA_DECRETO) +
	(T1.ALERTA_OKUPADO * T2.OCUPADO) ) > 0 THEN ''APLICA''
	WHEN ((T1.ALERTA_INSCRIPCION * T2.INSCRIPCION ) +
	(T1.ALERTA_CARGAS * T2.CARGAS) +
	(T1.ALERTA_POSESION * T2.POSESION) +
	(T1.ALERTA_TIPO_ALQUILER * T2.TIPO_ALQUILER) +
	(T1.ALERTA_ALQUILER * T2.ALQUILADO) +
	(T1.ALERTA_FECHA_DECRETO * T2.FECHA_DECRETO) +
	(T1.ALERTA_OKUPADO * T2.OCUPADO) ) > 0 THEN ''APLICA''
	ELSE ''NO APLICA'' END AS RESULTADO,
	CASE WHEN T1.CARTERA= ''SAREB'' AND T1.ALERTA_OKUPADO = 1 AND T1.ALERTA_TCO_ALQUILER = 1 THEN 1
	     WHEN (T1.ALERTA_ALQUILER * T2.ALQUILADO) = 1 OR (T1.ALERTA_TIPO_ALQUILER * T2.TIPO_ALQUILER) = 1 OR (T1.ALERTA_OKUPADO * T2.OCUPADO) = 1 THEN 1
             WHEN (T1.ALERTA_FECHA_DECRETO * T2.FECHA_DECRETO) = 1 AND (T1.ALERTA_INSCRIPCION * T2.INSCRIPCION) = 1 THEN 1
	     ELSE 0 END AS INDICADOR_1,
	CASE WHEN (T1.ALERTA_POSESION * T2.POSESION) = 1 OR (T1.ALERTA_INSCRIPCION * T2.INSCRIPCION  ) = 1 OR (T1.ALERTA_CARGAS * T2.CARGAS) = 1 OR (T1.ALERTA_FECHA_DECRETO * T2.FECHA_DECRETO) = 1 THEN 1 ELSE 0 END AS INDICADOR_2
	FROM REM01.V_ALERTAS_PUBLICACION  T1 
	INNER JOIN REM01.CONF_ALERTAS_PUBLICACION T2 
	ON (T1.CARTERA = T2.CARTERA AND T1.CARTERA <> ''CERBERUS'' AND (T1.CARTERA = ''BANKIA'' OR T1.CARTERA = ''BANKIA DACION''))
    	OR (T1.CARTERA = T2.CARTERA AND T1.CARTERA <> ''CERBERUS'' AND T1.CARTERA <> ''BANKIA'' AND T1.CARTERA <> ''BANKIA DACION'')
	OR (T1.SUBCARTERA = T2.SUBCARTERA AND T2.SUBCARTERA IS NOT NULL AND T1.CARTERA <> ''MACC'')
	OR (T1.CARTERA NOT IN (''BANKIA'',''BANKIA DACION'',''SAREB'',''CAJAMAR'',''LIBERBANK'') AND ((T1.CARTERA <> T2.CARTERA AND T1.CARTERA <> ''CERBERUS'' AND T1.CARTERA <> ''MACC'') OR (T1.CARTERA =''CERBERUS'' AND T1.SUBCARTERA  NOT IN (''APPLE - INMOBILIARIO'',''DIVARIAN INDUSTRIAL INMB'',''DIVARIAN REMAINING INMB'',''JAIPUR - FINANCIERO'',''JAIPUR - INMOBILIARIO'')))  AND T2.CARTERA = ''OTRA CARTERA'')';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_CONF_ALERTAS_PUBLICACION...Creada OK');

	IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

	END IF;

	IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

	END IF;

	IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

	END IF;
  
  EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
    -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
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

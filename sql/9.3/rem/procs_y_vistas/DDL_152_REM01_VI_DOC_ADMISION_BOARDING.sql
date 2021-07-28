  --/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20210728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-9331
--## PRODUCTO=NO
--## Finalidad: DDL
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## version 1.1 - Se corrige un join que excluía activos
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
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;

BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_DOC_ADMISION_BOARDING' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DOC_ADMISION_BOARDING...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_DOC_ADMISION_BOARDING';
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DOC_ADMISION_BOARDING... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_DOC_ADMISION_BOARDING' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DOC_ADMISION_BOARDING...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_DOC_ADMISION_BOARDING';
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DOC_ADMISION_BOARDING... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DOC_ADMISION_BOARDING...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_DOC_ADMISION_BOARDING

	AS
  SELECT DISTINCT ACT_ID, MAX(APLICA_BOLETIN_GAS) AS APLICA_BOLETIN_GAS, MAX(APLICA_BOLETIN_AGUA) AS APLICA_BOLETIN_AGUA,
                  MAX(APLICA_BOLETIN_LUZ) AS APLICA_BOLETIN_LUZ, MAX(APLICA_BOLETIN_CFO) AS APLICA_BOLETIN_CFO,
                  MAX(APLICA_BOLETIN_CEE) AS APLICA_BOLETIN_CEE, MAX(APLICA_BOLETIN_ETIQUETA) AS APLICA_BOLETIN_ETIQUETA,
                  MAX(APLICA_BOLETIN_HABITABILIDAD) AS APLICA_BOLETIN_HABITABILIDAD, MAX(FECHA_BOLETIN_GAS) AS FECHA_BOLETIN_GAS,
                  MAX(FECHA_BOLETIN_AGUA) AS FECHA_BOLETIN_AGUA, MAX(FECHA_BOLETIN_LUZ) AS FECHA_BOLETIN_LUZ,
                  MAX(FECHA_BOLETIN_CFO) AS FECHA_BOLETIN_CFO, MAX(FECHA_BOLETIN_LPO) AS FECHA_BOLETIN_LPO, MAX(FECHA_BOLETIN_ETIQUETA_CEE) AS FECHA_BOLETIN_ETIQUETA_CEE,
                  MAX(FECHA_BOLETIN_CEE) AS FECHA_BOLETIN_CEE, MAX(APLICA_BOLETIN_LPO) AS APLICA_BOLETIN_LPO, MAX(FECHA_CALIFICACION_CEE) AS FECHA_CALIFICACION_CEE,
                  MAX(LETRA_CONSUMO) AS LETRA_CONSUMO, MAX(ESTADO_DOCUMENTO_CEDULA_HABITABILIDAD) AS ESTADO_DOCUMENTO_CEDULA_HABITABILIDAD FROM(SELECT ACT_ID,
        CASE WHEN TIPO_DOCUMENTO = ''86'' THEN
        APLICA_BOLETIN ELSE 0 END AS APLICA_BOLETIN_GAS,
        CASE WHEN TIPO_DOCUMENTO = ''88'' THEN
        APLICA_BOLETIN ELSE 0 END AS APLICA_BOLETIN_AGUA,
        CASE WHEN TIPO_DOCUMENTO = ''87'' THEN
        APLICA_BOLETIN ELSE 0 END AS APLICA_BOLETIN_LUZ,
        CASE WHEN TIPO_DOCUMENTO = ''89'' THEN
        APLICA_BOLETIN ELSE 0 END AS APLICA_BOLETIN_CFO,
        CASE WHEN TIPO_DOCUMENTO = ''91'' THEN
        APLICA_BOLETIN ELSE 0 END AS APLICA_BOLETIN_LPO,
        CASE WHEN TIPO_DOCUMENTO = ''11'' THEN
        APLICA_BOLETIN ELSE 0 END AS APLICA_BOLETIN_CEE,
        CASE WHEN TIPO_DOCUMENTO = ''84'' THEN
        APLICA_BOLETIN ELSE 0 END AS APLICA_BOLETIN_ETIQUETA,
        CASE WHEN TIPO_DOCUMENTO = ''90'' THEN
        APLICA_BOLETIN ELSE 0 END AS APLICA_BOLETIN_HABITABILIDAD,
        CASE WHEN TIPO_DOCUMENTO = ''86'' THEN
        FECHA_BOLETIN ELSE NULL END AS FECHA_BOLETIN_GAS,
        CASE WHEN TIPO_DOCUMENTO = ''88'' THEN
        FECHA_BOLETIN ELSE NULL END AS FECHA_BOLETIN_AGUA,
        CASE WHEN TIPO_DOCUMENTO = ''87'' THEN
        FECHA_BOLETIN ELSE NULL END AS FECHA_BOLETIN_LUZ,
        CASE WHEN TIPO_DOCUMENTO = ''89'' THEN
        FECHA_BOLETIN ELSE NULL END AS FECHA_BOLETIN_CFO,
        CASE WHEN TIPO_DOCUMENTO = ''91'' THEN
        FECHA_BOLETIN ELSE NULL END AS FECHA_BOLETIN_LPO,
        CASE WHEN TIPO_DOCUMENTO = ''11'' THEN
        FECHA_BOLETIN ELSE NULL END AS FECHA_BOLETIN_CEE,
        CASE WHEN TIPO_DOCUMENTO = ''13'' THEN
        ESTADO_DOCUMENTO ELSE NULL END AS ESTADO_DOCUMENTO_CEDULA_HABITABILIDAD,
		CASE WHEN TIPO_DOCUMENTO = ''11'' THEN
        FECHA_CALIFICACION ELSE NULL END AS FECHA_CALIFICACION_CEE,
		CASE WHEN TIPO_DOCUMENTO = ''84'' THEN
        FECHA_BOLETIN ELSE NULL END AS FECHA_BOLETIN_ETIQUETA_CEE,
        LETRA_CONSUMO
        FROM(
        SELECT ADO.ACT_ID,
            ADO.LETRA_CONSUMO AS LETRA_CONSUMO,
            EDC.DD_EDC_CODIGO AS ESTADO_DOCUMENTO,
            ADO.ADO_APLICA AS APLICA_BOLETIN,
            ADO.ADO_FECHA_OBTENCION AS FECHA_BOLETIN,
			ADO.ADO_FECHA_CALIFICACION AS FECHA_CALIFICACION,
            TPD.DD_TPD_CODIGO AS TIPO_DOCUMENTO
            FROM REM01.ACT_ADO_ADMISION_DOCUMENTO ADO
            JOIN REM01.ACT_CFD_CONFIG_DOCUMENTO CFD ON ADO.CFD_ID = CFD.CFD_ID
            JOIN REM01.DD_TPD_TIPO_DOCUMENTO TPD ON CFD.DD_TPD_ID = TPD.DD_TPD_ID
            LEFT JOIN REM01.DD_EDC_ESTADO_DOCUMENTO EDC ON ADO.DD_EDC_ID = EDC.DD_EDC_ID))
      GROUP BY ACT_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DOC_ADMISION_BOARDING...Creada OK');

EXCEPTION
     WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('KO!');
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
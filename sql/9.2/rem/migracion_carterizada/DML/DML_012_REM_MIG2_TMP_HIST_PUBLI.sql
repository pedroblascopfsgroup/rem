--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20170627
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.6
--## INCIDENCIA_LINK=HREOS-2310
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  Rellenar el array
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
  
  TYPE T_VIC IS TABLE OF VARCHAR2(4000 CHAR);
  TYPE T_ARRAY_VIC IS TABLE OF T_VIC;
   
  V_ESQUEMA          VARCHAR2(25 CHAR):= 'REM01'; 	-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M   VARCHAR2(25 CHAR):= 'REMMASTER'; 	-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_TABLA   VARCHAR2(30 CHAR):= 'MIG2_TMP_ULT_HIST_PUBLI'; 
  TABLE_COUNT number(3); 											-- Vble. para validar la existencia de las Tablas.
  err_num NUMBER; 													-- Numero de errores
  err_msg VARCHAR2(2048); 											-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  V_EXIST NUMBER(10);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO TABLE_COUNT;

    IF TABLE_COUNT = 1 THEN
        V_MSQL := '
	        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
	          (HEP_ACT_NUMERO_ACTIVO, HEP_COD_TIPO_PUBLICACION, HEP_COD_ESTADO_PUBLI, HEP_FECHA_DESDE, HEP_FECHA_HASTA, HEP_COD_PORTAL, HEP_MOTIVO, RN)
	        SELECT HEP_ACT_NUMERO_ACTIVO, HEP_COD_TIPO_PUBLICACION, HEP_COD_ESTADO_PUBLI, HEP_FECHA_DESDE, HEP_FECHA_HASTA, HEP_COD_PORTAL, HEP_MOTIVO
            , ROW_NUMBER() OVER(PARTITION BY HEP_ACT_NUMERO_ACTIVO ORDER BY HEP_FECHA_DESDE DESC, HEP_FECHA_HASTA DESC NULLS FIRST) RN
			    FROM '||V_ESQUEMA||'.MIG2_ACT_HEP_HIST_EST_PUBLI WHERE VALIDACION = 0';
        EXECUTE IMMEDIATE V_MSQL;
    END IF;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Indicadores insertados.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;
/
EXIT

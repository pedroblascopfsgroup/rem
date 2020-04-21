--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6793
--## PRODUCTO=SI
--##
--## Finalidad: Actualiza descripciones ACT_EDI_EDIFICIO y ACT_ICO_INFO_COMERCIAL
--##            según hoja de cálculo dada
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA_1 VARCHAR2(50 CHAR) := 'ACT_EDI_EDIFICIO';
    V_TABLA_2 VARCHAR2(50 CHAR) := 'ACT_ICO_INFO_COMERCIAL';
    V_TABLA_TMP VARCHAR2(100 CHAR) := 'TMP_DESCRIPCION_COMERCIAL_DISTRIBUCION_REMVIP_6793';
    V_USUARIO VARCHAR2(25 CHAR) := 'REMVIP-6793';
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

BEGIN
	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_1||' T1
        USING ( SELECT ICO.ICO_ID, AUX.DESCRIPCION_EDIFICIO 
        FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
        INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.NUM_ACTIVO 
        INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID) T2
        ON (T1.ICO_ID = T2.ICO_ID)
    WHEN MATCHED THEN
        UPDATE SET T1.EDI_DESCRIPCION = T2.DESCRIPCION_EDIFICIO,
        USUARIOMODIFICAR = '''||V_USUARIO||''',
        FECHAMODIFICAR = SYSDATE
        ';
	EXECUTE IMMEDIATE V_MSQL;  
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_2||' T1
        USING ( SELECT ICO.ICO_ID, AUX.DESCRIPCION_COMERCIAL 
        FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
        INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.NUM_ACTIVO 
        INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID) T2
        ON (T1.ICO_ID = T2.ICO_ID)
    WHEN MATCHED THEN
        UPDATE SET T1.ICO_DESCRIPCION = T2.DESCRIPCION_COMERCIAL,
        USUARIOMODIFICAR = '''||V_USUARIO||''',
        FECHAMODIFICAR = SYSDATE
        ';
    EXECUTE IMMEDIATE V_MSQL;  
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||SQL%ROWCOUNT||' registros');
    
	COMMIT;

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

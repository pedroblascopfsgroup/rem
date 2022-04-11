--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20220511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11468
--## PRODUCTO=NO
--##
--## Finalidad: MAPEO ACT_ICO_INFO_COMERCIAL
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'ACT_ICO_INFO_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-11468'; -- Usuario modificar
    V_NUM_TABLAS NUMBER(25);

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
                USING (
                    SELECT ICO.ICO_ID,
                        ACT_NUM_ACTIVO,
                        ICO.ICO_NUM_TERRAZA_DESCUBIERTA,
                        ICO.ICO_NUM_TERRAZA_CUBIERTA,
                        CASE WHEN (ICO_NUM_TERRAZA_DESCUBIERTA > 0 OR ICO.ICO_NUM_TERRAZA_CUBIERTA > 0)
                            THEN 1                
                            ELSE 2
                        END ICO_TERRAZA
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID AND ACT.BORRADO = 0 
                    JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
                    LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO TER ON TER.DD_SIN_ID = ICO.ICO_TERRAZA AND TER.BORRADO = 0
                ) T2 
                ON (T1.ICO_ID = T2.ICO_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.ICO_TERRAZA = T2.ICO_TERRAZA,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                    T1.FECHAMODIFICAR = SYSDATE
                    WHERE T1.ICO_TERRAZA <> T2.ICO_TERRAZA';
    EXECUTE IMMEDIATE V_MSQL; 
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
                USING (
                    SELECT ICO.ICO_ID, ICO.ICO_DESCRIPCION, VIV_DISTRIBUCION_TXT
                    FROM '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV
                    JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO ON ICO.ICO_ID = VIV.ICO_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID AND DD_SCM_ID <> 5
                ) T2 
                ON (T1.ICO_ID = T2.ICO_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.ICO_DESCRIPCION = T2.ICO_DESCRIPCION || CHR(10) || T2.VIV_DISTRIBUCION_TXT,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                    T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL; 
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   			
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

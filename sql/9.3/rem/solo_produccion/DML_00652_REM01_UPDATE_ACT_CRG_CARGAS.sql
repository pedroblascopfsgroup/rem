--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210202
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8833
--## PRODUCTO=NO
--## 
--## Finalidad: ELIMINAR CARGAS
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
   V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
   V_USUARIO VARCHAR(25 CHAR) := 'REMVIP-8833';
   V_TABLA VARCHAR(25 CHAR) := 'ACT_CRG_CARGAS';
   V_TABLA_AUX VARCHAR(25 CHAR) := 'AUX_REMVIP_8833';
 
BEGIN
   DBMS_OUTPUT.put_line('[INICIO]');

   DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion en '||V_TABLA||'');

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING (
               SELECT DISTINCT CRG.CRG_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' CRG
               INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = CRG.ACT_ID
               INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
               AND CRG.BORRADO = 0 AND CRG.CRG_DESCRIPCION = AUX.CRG_DESCRIPCION
         ) T2
         ON (T1.CRG_ID = T2.CRG_ID)
         WHEN MATCHED THEN UPDATE SET
         BORRADO = 1,
         USUARIOBORRAR = '''||V_USUARIO||''',
         FECHABORRAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

   DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS '||SQL%ROWCOUNT||' REGISTROS');
               
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

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

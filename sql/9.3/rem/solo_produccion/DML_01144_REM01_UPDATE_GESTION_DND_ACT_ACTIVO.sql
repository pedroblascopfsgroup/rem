--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220302
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11284
--## PRODUCTO=NO
--## 
--## Finalidad: Marcar check gestion DND
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

  V_ESQUEMA VARCHAR2(30 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USER VARCHAR2(50 CHAR):= 'REMVIP-11284';

BEGIN

      
		      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la actualización Check Gestion DND');
		      
		      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
						USING(
                            SELECT DISTINCT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                            JOIN '||V_ESQUEMA||'.AUX_REMVIP_11284 AUX ON AUX.ACTIVO=ACT.ACT_NUM_ACTIVO
                            WHERE ACT.BORRADO = 0 AND (ACT.ACT_GESTION_DND=0 OR ACT.ACT_GESTION_DND IS NULL)
						) T2
						ON (T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN
							UPDATE SET 
							    T1.USUARIOMODIFICAR = '''||V_USER||''',
							    T1.FECHAMODIFICAR = SYSDATE,
                                T1.ACT_GESTION_DND = 1';
				    
		      EXECUTE IMMEDIATE V_SQL;
		      
		      DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS  '||SQL%ROWCOUNT||' ACTUALIZADOS');

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
EXIT;
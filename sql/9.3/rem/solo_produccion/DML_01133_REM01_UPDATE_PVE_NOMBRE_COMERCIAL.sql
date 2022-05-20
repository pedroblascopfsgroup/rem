--/*
--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10663
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar tabla config gestores
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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
  V_USU VARCHAR2(50 CHAR):= 'REMVIP-10663';

BEGIN

      
		      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la actualización PVE_NOMBRE_COMERCIAL');
		     
		      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR pve USING (
                            SELECT DISTINCT pve1.PVE_ID,
                            concat(''Unicaja - Oficina '', pve1.PVE_COD_API_PROVEEDOR) AS NOMBRE_COMERCIAL
                            FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR pve1 
                            JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR tpr ON tpr.DD_TPR_ID = pve1.DD_TPR_ID
                            WHERE tpr.DD_TPR_CODIGO = ''38''
                            ) T2
                        ON (pve.PVE_ID = T2.PVE_ID)
                        WHEN MATCHED THEN UPDATE SET
                        pve.PVE_NOMBRE_COMERCIAL = T2.NOMBRE_COMERCIAL ,
                        pve.USUARIOMODIFICAR = '''||V_USU||''',
                        pve.FECHAMODIFICAR = SYSDATE';
				    
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
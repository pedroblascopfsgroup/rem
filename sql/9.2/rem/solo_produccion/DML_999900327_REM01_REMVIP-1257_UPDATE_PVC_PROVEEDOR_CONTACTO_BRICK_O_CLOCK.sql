--/*
--##########################################
--## AUTOR=Marco Munoz 
--## FECHA_CREACION=20180918
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1257
--## PRODUCTO=NO
--##
--## Finalidad: Updatear el proveedor asociado (PVE_ID, PVE_NOMBRE) en la PVC para BRICK O'CLOCK.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    --V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR):= 'ACT_PVC_PROVEEDOR_CONTACTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1257';
	PL_OUTPUT VARCHAR2(32000 CHAR);


 BEGIN
  					
  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
					SET 
						PVC.PVE_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 10007348),
						PVC.PVC_NOMBRE =  (SELECT PVE_NOMBRE FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 10007348),
						PVC.USUARIOMODIFICAR = ''REMVIP-1257'',
						PVC.FECHAMODIFICAR = SYSDATE
					WHERE 
					EXISTS (
						SELECT 1
						FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR           PVE
						JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO  PVC2
						  ON PVC2.PVE_ID = PVE.PVE_ID
						WHERE PVE.PVE_COD_REM = 10
						  AND PVC2.PVC_ID = PVC.PVC_ID
					)
  ';
  PL_OUTPUT := PL_OUTPUT || '[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la '|| V_TABLA || ' ' || CHR(10);
  COMMIT;
  
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;


--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7289
--## PRODUCTO=NO
--##
--## Finalidad: Script para borrado logico de proveedors contacto con el usuario MIGDIV
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO LOGICO DE PROVEEDORES CONTACTO QUE TIENEN COMO USUARIO MIGDIV, OBVIANDO LOS ANTERIORES');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO T1 USING (
   		 SELECT PVC.PVC_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
   		 INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON PVC.USU_ID = USU.USU_ID
   		 INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID 
   		 WHERE USU.USU_USERNAME = ''MIGDIV'' AND PVC.BORRADO = 0
	) T2
		ON (T1.PVC_ID = T2.PVC_ID)
		WHEN MATCHED THEN UPDATE SET
		T1.BORRADO = 1,
		T1.USUARIOBORRAR = ''REMVIP-7289_2'',
		T1.FECHABORRAR = SYSDATE 
		';
	EXECUTE IMMEDIATE V_MSQL;

	 DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros con usuarioborrar REMVIP-7289_2.'); 
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACTUALIZADO CORRECTAMENTE ');
   

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

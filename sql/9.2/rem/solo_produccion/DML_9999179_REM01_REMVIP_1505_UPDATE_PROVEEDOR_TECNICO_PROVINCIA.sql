--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180808
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1505
--## PRODUCTO=no
--##
--## Finalidad: modificar proveedor para central tecnica en girona 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
   PL_OUTPUT VARCHAR2(1024 CHAR);
   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   DESCRIPCION VARCHAR2(64 CHAR);
   V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
   V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-1505';
   V_PROVINCIA VARCHAR2(65 CHAR) := 'GIRONA';
   V_PROVEEDOR VARCHAR2(65 CHAR) := '10007315';


BEGIN	
	
	 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES (
	 ID
	,TIPO_GESTOR
	,COD_CARTERA
	,COD_PROVINCIA
	,USERNAME
	,NOMBRE_USUARIO
	,VERSION
	,USUARIOCREAR
	,FECHACREAR
	,BORRADO
	) 
	SELECT 
	'||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL 
	,''PTEC'' 
	,3 
	,(SELECT DDPRV.DD_PRV_CODIGO FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV WHERE UPPER(DDPRV.DD_PRV_DESCRIPCION) = UPPER('''||V_PROVINCIA||''')) AS DD_PRV_CODIGO 
	,USU.USU_USERNAME  
	,USU.USU_NOMBRE  
	,0 
	,'''||V_USUARIO||'''  
	,SYSDATE 
	,0 
	FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC 
	INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE.BORRADO = 0 
	INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON PVC.USU_ID = USU.USU_ID AND USU.BORRADO = 0 
	WHERE PVE.PVE_COD_REM = '''||V_PROVEEDOR||''' AND PVC.BORRADO = 0 AND USU.USU_GRUPO = 1'
	;

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_GES_DIST_GESTORES');

	COMMIT;

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

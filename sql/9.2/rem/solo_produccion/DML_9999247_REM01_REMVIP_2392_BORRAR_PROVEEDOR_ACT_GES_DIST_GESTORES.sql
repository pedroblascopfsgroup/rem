--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2329
--## PRODUCTO=no
--##
--## Finalidad: modificar proveedor para central tecnica en girona, a DORSERAN
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
   V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-2329';


BEGIN	
	
	--BUSCAMOS Y BORRAMOS EL PROVEEDOR TECNICO BRICK O CLOCK

	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES GES 
					WHERE TIPO_GESTOR = ''PTEC'' 
					AND COD_PROVINCIA = 17
					AND USERNAME = ''47718980Y''
                   			AND BORRADO = 1';


	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' PROVEEDOR TECNICO BORRADO');


	 --BORRAMOS DE LA GEE Y LA GAC LAS RELACIONES QUE SE HAN CREADO ERRONEAMENTE

	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO  
			WHERE GEE_ID IN (8876291, 8877068, 8877070)';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han BORRADO '||SQL%ROWCOUNT||' REGISTROS DE LA TABLA GAC_GESTOR_ADD_ACTIVO');

	 V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD 
			WHERE GEE_ID IN (8876291, 8877068, 8877070) 
			AND USU_ID = 74722 
			AND DD_TGE_ID = 461';

	EXECUTE IMMEDIATE V_MSQL;


	DBMS_OUTPUT.PUT_LINE('[INFO] Se han BORRADO '||SQL%ROWCOUNT||' REGISTROS DE LA TABLA GEE_GESTOR_ENTIDAD');

	


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

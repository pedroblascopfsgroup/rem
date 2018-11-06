--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4717
--## PRODUCTO=no
--##
--## Finalidad: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
   PL_OUTPUT VARCHAR2(32000 CHAR);
   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   DESCRIPCION VARCHAR2(64 CHAR);


BEGIN	
	
	--BUSCAMOS Y DAMOS DE BAJA EL PROVEEDOR Y SUPERVISOR DE PUBLICACION ACTUAL DE LOS ACTIVOS

	--TABLA GEE
	V_MSQL := 'MERGE INTO REM01.GEE_GESTOR_ENTIDAD T1
			USING(
				SELECT GEE.GEE_ID 
				FROM REM01.GEE_GESTOR_ENTIDAD GEE
				JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GEE.GEE_ID = GAC.GEE_ID 
				JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.BORRADO = 0 
				WHERE GEE.BORRADO = 0 AND (TGE.DD_TGE_CODIGO = ''GPUBL'' OR TGE.DD_TGE_CODIGO = ''SPUBL'')) T2
			ON (T1.GEE_ID = T2.GEE_ID) 
			WHEN MATCHED THEN UPDATE SET
					  T1.USUARIOBORRAR = ''REASIGNA_PUBLI'',
					  T1.FECHABORRAR = SYSDATE,
					  T1.BORRADO = 1';

	EXECUTE IMMEDIATE V_MSQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se ha hecho un borrado logico con un total de '||SQL%ROWCOUNT||' registros de la tabla GEE_GESTOR_ENTIDAD');

	--TABLA GEH
	V_MSQL := 'MERGE INTO REM01.GEH_GESTOR_ENTIDAD_HIST T1
			USING(
				SELECT GEH.GEH_ID 
				FROM REM01.GEH_GESTOR_ENTIDAD_HIST GEH
				JOIN REM01.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GEH.GEH_ID = GAH.GEH_ID 
				JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEH.DD_TGE_ID AND TGE.BORRADO = 0 
				WHERE GEH.BORRADO = 0 AND GEH.GEH_FECHA_HASTA IS NULL AND (TGE.DD_TGE_CODIGO = ''GPUBL'' OR TGE.DD_TGE_CODIGO = ''SPUBL'')) T2
			ON (T1.GEH_ID = T2.GEH_ID) 
			WHEN MATCHED THEN UPDATE SET
					  T1.GEH_FECHA_HASTA = SYSDATE,
					  T1.USUARIOMODIFICAR = ''REASIGNA_PUBLI'',
					  T1.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_MSQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado un total de '||SQL%ROWCOUNT||' registros de la tabla GEH_GESTOR_ENTIDAD_HIST');


	DBMS_OUTPUT.PUT_LINE('[INFO] Se lanza el SP de reasignacion de gestores para activos inmobiliarios');

	REM01.SP_AGA_ASIGNA_GESTOR_PUBLI('SP_AGA_V4',PL_OUTPUT,NULL,NULL,'02');
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han ejecutado correctamente el SP de reasignacion de gestores para activos inmobiliarios.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Se lanza el SP de reasignacion de gestores para activos financieros');

	REM01.SP_AGA_ASIGNA_GESTOR_PUBLI('SP_AGA_V4',PL_OUTPUT,NULL,NULL,'01');
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han ejecutado correctamente el SP de reasignacion de gestores para activos financieros.');


	DBMS_OUTPUT.PUT_LINE('[FIN] Se ha ejecutado correctamente el proceso.');

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

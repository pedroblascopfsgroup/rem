--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2746
--## PRODUCTO=no
--##
--## Finalidad: actualizar act_cod_promocion_prinex de la tabla ACT_ACTIVO
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

   PL_OUTPUT VARCHAR2(1024 CHAR);
   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   DESCRIPCION VARCHAR2(64 CHAR);
   V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
   V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-2746';


BEGIN	
	
	--BUSCAMOS Y ACTUALIZAMOS LOS ACTIVOS

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
		USING (
			   SELECT AUX.ACT_NUM_ACTIVO, AUX.COD_PROMOCION
			   FROM REM_EXT.AYU_LBB_PRINEX_ACTCODPROMO AUX
		) T2
		ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
		WHEN MATCHED THEN UPDATE SET
		       T1.ACT_COD_PROMOCION_PRINEX = T2.COD_PROMOCION,
		       T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
		       T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' ACTIVOS ACTUALIZADOS CORRECTAMENTE');

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

--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2989
--## PRODUCTO=NO
--## 
--## Finalidad: borrar duplicados
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2989';

BEGIN

--BUSCA Y ACTUALIZA DD_TPN_TIPO_INMUEBLE

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso.');
		
		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
			  	WHERE GEE_ID IN (5548782,
						5645151,
						5810255,
						5562216,
						5497054,
						5775825,
						5568836,
						5587985,
						5744662,
						5737280,
						5900891,
						5791980,
						5515508,
						5921895,
						5515330,
						5491227,
						5804386,
						5473263,
						5623854,
						5636164,
						5586533,
						5742028,
						5872137,
						5948687,
						5640634,
						5906533,
						5841684,
						5481649,
						5909733,
						5964908,
						5696197)';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han BORRADO en total '||SQL%ROWCOUNT||' registros en la tabla GAC_GESTOR_ADD_ACTIVO.');

		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
			  	WHERE GEE_ID IN (5548782,
						5645151,
						5810255,
						5562216,
						5497054,
						5775825,
						5568836,
						5587985,
						5744662,
						5737280,
						5900891,
						5791980,
						5515508,
						5921895,
						5515330,
						5491227,
						5804386,
						5473263,
						5623854,
						5636164,
						5586533,
						5742028,
						5872137,
						5948687,
						5640634,
						5906533,
						5841684,
						5481649,
						5909733,
						5964908,
						5696197)';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han BORRADO en total '||SQL%ROWCOUNT||' registros en la tabla GEE_GESTOR_ENTIDAD.');


		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4825
--## PRODUCTO=NO
--##
--## Finalidad:
--##
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_ECO_ID NUMBER(16); -- Vble. para validar la existencia de una tabla.
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_MODIFICAR VARCHAR2(100 CHAR):= 'REMVIP-4825';
  V_COUNT NUMBER(16):= 0;
  V_COUNT2 NUMBER(16):= 0;
  V_COUNT3 NUMBER(16):= 0;
  V_RESULT VARCHAR(2000 CHAR);



BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GGE_GASTOS_GESTION GES USING (
						SELECT DISTINCT GPV.GPV_ID,ENV.FECHA_ENVIO
						FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
							INNER JOIN REM_EXT.LBB_TEMP_CAR_INI_FC_ENVIO ENV    ON ENV.NUM_GASTO_HAYA=GPV.GPV_NUM_GASTO_HAYA
							INNER JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE   ON GPV.GPV_ID=GGE.GPV_ID
						WHERE ENV.FECHA_ENVIO IS NOT NULL
				)TAB
				ON (TAB.GPV_ID=GES.GPV_ID)
				WHEN MATCHED THEN UPDATE SET 
					GES.GGE_FECHA_ENVIO_PRPTRIO = TRUNC(TO_DATE(TAB.FECHA_ENVIO,''DD/MM/YYYY''))
				,   GES.USUARIOMODIFICAR = ''REMVIP-4825''
				,   GES.FECHAMODIFICAR = SYSDATE '; 
						

	EXECUTE IMMEDIATE V_MSQL ;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  Se han actualizado  '||SQL%ROWCOUNT||' registros .');

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

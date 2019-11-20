--/*
--##########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20191107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5676
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar % de participación de activos en trabajos y gastos cuando solamente hay 1 y tiene valor 0
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
    V_USUARIOMODIFICAR VARCHAR2(25 CHAR):= 'REMVIP-5679'; -- Configuracion Esquema

BEGIN	        

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');


    DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar participación en trabajo' );

    V_MSQL := '	MERGE INTO '||V_ESQUEMA||'.ACT_TBJ
		USING (

			SELECT DISTINCT ACT_TBJ.TBJ_ID, ACT_TBJ.ACT_ID
			FROM '||V_ESQUEMA||'.GPV_TBJ, '||V_ESQUEMA||'.ACT_TBJ
			WHERE GPV_TBJ.TBJ_ID = ACT_TBJ.TBJ_ID
			AND ACT_TBJ.ACT_TBJ_PARTICIPACION = 0
			AND EXISTS 
				(
				SELECT 1
				FROM '||V_ESQUEMA||'.GPV_ACT ACT, '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				WHERE 1 = 1
				AND GPV_PARTICIPACION_GASTO = 0
				AND 1 = ( SELECT COUNT(1)
				          FROM '||V_ESQUEMA||'.GPV_ACT ACT2
				          WHERE ACT2.GPV_ID = ACT.GPV_ID
					)  
				AND ACT.GPV_ID = GPV.GPV_ID       
				AND GPV_TBJ.GPV_ID = GPV.GPV_ID
				)

			AND 1 = ( SELECT COUNT(1) 
			          FROM '||V_ESQUEMA||'.ACT_TBJ
          			  WHERE GPV_TBJ.TBJ_ID = ACT_TBJ.TBJ_ID
			         ) 	


			     ) AUX
			ON ( ACT_TBJ.TBJ_ID = AUX.TBJ_ID AND ACT_TBJ.ACT_ID = AUX.ACT_ID )
			WHEN MATCHED THEN UPDATE SET 
			    ACT_TBJ_PARTICIPACION = 100

		';

	EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: Modificados ' || SQL%ROWCOUNT || ' registros de ACT_TBJ ' );

--*******************************************************************************************************************************

    DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar participación en gasto' );

    V_MSQL := '	MERGE INTO '||V_ESQUEMA||'.GPV_ACT
		USING (

			SELECT DISTINCT GPV_ACT_ID
			FROM REM01.GPV_ACT ACT, REM01.GPV_GASTOS_PROVEEDOR GPV
			WHERE 1 = 1
			AND GPV_PARTICIPACION_GASTO = 0
			AND 1 = ( SELECT COUNT(1)
			          FROM REM01.GPV_ACT ACT2
			          WHERE ACT2.GPV_ID = ACT.GPV_ID
			        )  
			AND ACT.GPV_ID = GPV.GPV_ID       
			AND EXISTS ( SELECT 1 
			             FROM REM01.GPV_TBJ, REM01.ACT_TBJ
			             WHERE GPV_TBJ.TBJ_ID = ACT_TBJ.TBJ_ID
			             AND GPV_TBJ.GPV_ID = GPV.GPV_ID
			            ) 
			AND 1 = ( SELECT COUNT(1) 
			             FROM REM01.GPV_TBJ, REM01.ACT_TBJ
			             WHERE GPV_TBJ.TBJ_ID = ACT_TBJ.TBJ_ID
			             AND GPV_TBJ.GPV_ID = GPV.GPV_ID
			            ) 


			     ) AUX
			ON ( GPV_ACT.GPV_ACT_ID = AUX.GPV_ACT_ID )
			WHEN MATCHED THEN UPDATE SET 
			    GPV_PARTICIPACION_GASTO = 100

		';

	EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: Modificados ' || SQL%ROWCOUNT || ' registros de GPV_ACT ' );

--*******************************************************************************************************************************

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: PEF_PERFILES ACTUALIZADO CORRECTAMENTE ');


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

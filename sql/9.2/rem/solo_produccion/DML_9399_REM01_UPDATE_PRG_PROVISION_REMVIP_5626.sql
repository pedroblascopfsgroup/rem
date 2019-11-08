--/*
--##########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20191028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5626
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar estados de provisión según estado de los gastos
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
    V_USUARIOMODIFICAR VARCHAR2(25 CHAR):= 'REMVIP-5626'; -- Configuracion Esquema

BEGIN	        

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');


    DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizar estado de la provisión a <Pagado> si todos los gastos están pagados' );

                V_MSQL := ' 	

			MERGE INTO '||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG
			USING (
				SELECT
				DISTINCT PRG.PRG_ID
				FROM '||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG
				WHERE 1 = 1
				AND PRG.DD_EPR_ID <> (SELECT DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADOS_PROVISION_GASTO WHERE DD_EPR_CODIGO = ''07'')
				AND PRG.BORRADO = 0
				AND  ( SELECT COUNT(1) 
				       FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				       WHERE GPV.PRG_ID = PRG.PRG_ID
				       AND GPV.DD_EGA_ID = ( SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'' ) 	
				       AND GPV.BORRADO = 0	
				     ) = 
				    ( SELECT COUNT(1) 
				       FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				       WHERE GPV.PRG_ID = PRG.PRG_ID
				       AND GPV.BORRADO = 0	  
				     )
                		AND 0 < ( SELECT COUNT(1) 
				          FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				          WHERE GPV.PRG_ID = PRG.PRG_ID
				          AND GPV.BORRADO = 0	  
				         )   

			     ) AUX
			ON ( PRG.PRG_ID = AUX.PRG_ID )
			WHEN MATCHED THEN UPDATE SET 
			    PRG.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADOS_PROVISION_GASTO WHERE DD_EPR_CODIGO = ''07'')
			  , PRG.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR|| '''
			  , PRG.FECHAMODIFICAR = sysdate  

		';

	EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizados ' || SQL%ROWCOUNT || ' PRG_PROVISION_FONDOS cambiados a <Pagado> ' );

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

--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190328
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3667
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de gastos
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
           
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- Updatear los valores en GGE_GASTOS_GESTION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN GGE_GASTOS_GESTION] ');
         
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: QUITAMOS LA FECHA DE ENVIO A PROPIETARIO DE LOS GASTOS');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE
						SET GGE_FECHA_ENVIO_PRPTRIO = NULL,
						USUARIOMODIFICAR = ''REMVIP-3667'',
						FECHAMODIFICAR = SYSDATE
						WHERE EXISTS(
						SELECT 1
						FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
						INNER JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE1 ON GGE1.GPV_ID = GPV.GPV_ID
						WHERE GGE1.GGE_FECHA_ENVIO_PRPTRIO IS NOT NULL
						AND GGE.GGE_ID = GGE1.GGE_ID
						AND GPV.GPV_NUM_GASTO_HAYA IN (
										10045639,
										10045640,
										10045641,
										10045642,
										10045643,
										10045644,
										10045645,
										10045646,
										10045647,
										10045648,
										10045649,
										10045650,
										10045651,
										10045652,
										10045653,
										10045654,
										10045655

						))';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: FECHA DE ENVIO A PROPIETARIO  ELIMINADA PARA '||SQL%ROWCOUNT||' GASTOS');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR ACTUALIZADA CORRECTAMENTE');   

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



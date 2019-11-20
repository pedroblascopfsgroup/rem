--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20171023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5329
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_MRG_MOTIVO_RECHAZO_GASTO 5 criterios de rechazo
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
    
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-5329'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'DD_MRG_MOTIVO_RECHAZO_GASTO';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
BEGIN	

-----------------------------------------------------------------------------------------------	

	DBMS_OUTPUT.PUT_LINE('[INICIO]: ACTUALIZACIÓN EN '||V_TABLA||'] MOTIVO F50 - Gastos cíclicos mismo importe ');
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'

			SET QUERY_ITER =  	
			''WHERE TIPO_ENVIO = ''''01'''' AND AUX.ID_PRIMER_GASTO_SERIE IS NOT NULL AND NOT EXISTS
( SELECT 1 FROM GPV_GASTOS_PROVEEDOR GPV
  JOIN GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
  WHERE COALESCE( GPV.GPV_NUM_GASTO_GESTORIA, 0 ) = COALESCE( AUX.ID_PRIMER_GASTO_SERIE, 0 ) AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#
  AND COALESCE( AUX.PRINCIPAL, 0 ) = COALESCE( GDE.GDE_PRINCIPAL_NO_SUJETO, 0 )
  AND COALESCE( AUX.RECARGO, 0 ) = COALESCE( GDE.GDE_RECARGO, 0 )
  AND COALESCE( AUX.INT_DEMORA, 0 ) = COALESCE( GDE.GDE_INTERES_DEMORA, 0 )
  AND COALESCE( AUX.COSTAS, 0 ) = COALESCE( GDE.GDE_COSTAS, 0 )
  AND COALESCE( AUX.OTROS_INCREMENTOS, 0 ) = COALESCE( GDE.GDE_OTROS_INCREMENTOS, 0 )
  AND COALESCE( AUX.PROVISIONES_Y_SUPL, 0 ) = COALESCE( GDE.GDE_PROV_SUPLIDOS, 0 )
  AND GPV.BORRADO = 0
  AND GDE.BORRADO = 0    
)'',
			 
			USUARIOMODIFICAR = '''||V_USUARIO||''', 
			FECHAMODIFICAR = SYSDATE
			WHERE DD_MRG_CODIGO = ''F50''
';
		EXECUTE IMMEDIATE V_MSQL;



    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN INSERTADO LOS REGISTROS EN '||V_TABLA||' CORRECTAMENTE ');
   

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
EXIT;

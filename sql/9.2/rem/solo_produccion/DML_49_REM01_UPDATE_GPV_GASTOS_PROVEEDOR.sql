--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3347
--## PRODUCTO=NO
--##
--## Finalidad: Modificar el campo PVE_ID_GESTORIA de los gastos de QIPERT. 
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
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    	DBMS_OUTPUT.PUT_LINE('[INFO]: SE VA A MODIFICAR PVE_ID_GESTORIA de los gastos de QIPERT y EMAIS en DE GPV_GASTOS_PROVEEDOR ');
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV 
	SET USUARIOMODIFICAR = ''REMVIP-3347'', FECHAMODIFICAR = SYSDATE, PVE_ID_GESTORIA = (SELECT PVE_ID FROM '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 110116880)  
	WHERE GPV.DD_GRF_ID = 22 ';
	EXECUTE IMMEDIATE V_MSQL;
	      
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');

	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV 
	SET USUARIOMODIFICAR = ''REMVIP-3347'', FECHAMODIFICAR = SYSDATE, PVE_ID_GESTORIA = (SELECT PVE_ID FROM '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 110116883)  
	WHERE GPV.DD_GRF_ID = 25 ';
	EXECUTE IMMEDIATE V_MSQL;

  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA GPV_GASTOS_PROVEEDOR ACTUALIZADA CORRECTAMENTE ');
   

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

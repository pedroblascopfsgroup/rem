--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190314
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=REMVIP-3489
--## PRODUCTO=NO
--##
--## Finalidad: ACTUALIZAR ESTADO GASTOS PROVEEDOR
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

    V_MSQL := ' UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
		SET DD_EGA_ID= (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO=:1), 
		    USUARIOMODIFICAR=:2, 
		    FECHAMODIFICAR=SYSDATE 
        	WHERE 1 = 1
		AND GPV_NUM_GASTO_HAYA IN ( ''9601873'', ''10193693'', ''10193695'', ''10193696'', ''10193700'', ''10335594'', ''10333621'' )';

    EXECUTE IMMEDIATE V_MSQL USING '04', 'REMVIP-3489';
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: - REGISTROS MODIFICADOS CORRECTAMENTE '|| sql%rowcount);

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

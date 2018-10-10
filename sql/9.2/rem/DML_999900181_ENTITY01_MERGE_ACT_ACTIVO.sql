--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20181008
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4561
--## PRODUCTO=SI
--##
--## Finalidad: Script que modifica los registros de la tabla ACT_ACTIVO.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.ACT_ACTIVO... Empezando a modificar datos en la tabla');
    
    	V_MSQL := '
	MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT 
	    USING (SELECT ACT_ID 
                    FROM '||V_ESQUEMA||'.ACT_ACTIVO 
                    WHERE DD_TCO_ID = (SELECT DD_TCO_ID 
                                         FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION 
					WHERE DD_TCO_CODIGO = ''04'') )BOR
	    ON (ACT.ACT_ID = BOR.ACT_ID)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET ACT.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''03''),
		ACT.DD_TAL_ID = (SELECT DD_TAL_ID FROM '||V_ESQUEMA||'.DD_TAL_TIPO_ALQUILER WHERE DD_TAL_CODIGO = ''02''),
		  USUARIOMODIFICAR = ''HREOS-4561'',
		  FECHAMODIFICAR = SYSDATE 		
         ';
		
	EXECUTE IMMEDIATE V_MSQL;
	
	COMMIT;

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


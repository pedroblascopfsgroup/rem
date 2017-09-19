--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20170912
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2788
--## PRODUCTO=NO
--##
--## Finalidad: Script que pone a nulo el campo FECHAENVIO de DGG_DOC_GES_GASTOS para que se reenvien todos los documentos a haya
--##            con el ETL que envia el formato correcto
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
	  
    V_TABLA VARCHAR2(30 CHAR) := 'DGG_DOC_GES_GASTOS';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	-- Actualizamos los datos
	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' SET USUARIOMODIFICAR = ''HREOS-2788'', FECHAMODIFICAR = SYSDATE, USUARIOENVIOHAYA = null, FECHAENVIOHAYA = null';
	EXECUTE IMMEDIATE V_MSQL;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');
   

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

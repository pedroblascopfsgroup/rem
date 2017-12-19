--/*
--##########################################
--## AUTOR=Isidro Sotoca
--## FECHA_CREACION=20171128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3330
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra el valor 8 "varios periodos" del diccionario "periodicidad" (DD_TPE_TIPOS_PERIOCIDAD)
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
    DBMS_OUTPUT.PUT_LINE('[INFO]: SE VA A BORRAR "Varios periodos" DE DD_TPE_TIPOS_PERIOCIDAD ');
    
    --Comprobamos el dato a borrar
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD WHERE DD_TPE_CODIGO = ''08'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    --Si existe lo modificamos
    IF V_NUM_TABLAS > 0 THEN				
          
      DBMS_OUTPUT.PUT_LINE('[INFO]: BORRANDO "Varios periodos" DE DD_TPE_TIPOS_PERIOCIDAD ');
          
   	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPE_TIPOS_PERIOCIDAD 
			SET USUARIOBORRAR = ''HREOS-3330'', FECHABORRAR = SYSDATE, BORRADO = 1 WHERE DD_TPE_CODIGO = ''08'' ';
      EXECUTE IMMEDIATE V_MSQL;
          
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe no hacemos nada   
   	ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO "Varios periodos" O YA ESTA BORRADO');   
    END IF;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA DD_TPE_TIPOS_PERIOCIDAD ACTUALIZADA CORRECTAMENTE ');
   

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
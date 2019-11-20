--/*
--##########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20190920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5288
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_EQV_ASPRO_REM
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

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EQV_ASPRO_REM 
		  WHERE 1 = 1 
		  AND DD_CODIGO_ASPRO = ''0370010''
		  AND DD_NOMBRE_ASPRO = ''DD_SUBCARTERA_ASPRO''
		  AND DD_NOMBRE_REM   = ''DD_SCR_SUBCARTERA''
		  AND DD_CODIGO_REM   = ''138'' ';

        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS = 0 THEN				                

          V_MSQL := 
		' Insert into '|| V_ESQUEMA ||'.DD_EQV_ASPRO_REM 
		( DD_NOMBRE_ASPRO, 
		  DD_CODIGO_ASPRO, 			
		  DD_DESCRIPCION_ASPRO, 
		  DD_DESCRIPCION_LARGA_ASPRO,
		  DD_NOMBRE_REM,	
		  DD_CODIGO_REM,
		  DD_DESCRIPCION_REM,
		  DD_DESCRIPCION_LARGA_REM,
		  VERSION,
		  USUARIOCREAR,
		  FECHACREAR,
		  USUARIOMODIFICAR,
		  FECHAMODIFICAR,
		  USUARIOBORRAR,
		  FECHABORRAR,
		  BORRADO) 
		values 
		(''DD_SUBCARTERA_ASPRO'',
		''0370010'',
		''Apple - Inmobiliario'',
		''Apple - Inmobiliario'',
		''DD_SCR_SUBCARTERA'',
		''138'',
		''Apple - Inmobiliario'',
		''Apple - Inmobiliario'',
		0,
		''REMVIP-5288'',
		SYSDATE,
		null,
		null,
		null,
		null,
		0) ' ;

          EXECUTE IMMEDIATE V_MSQL; 
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EQV_ASPRO_REM ACTUALIZADO CORRECTAMENTE ');
   

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



   

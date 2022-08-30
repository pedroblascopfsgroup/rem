--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12194
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(30 CHAR) := 'DD_LOC_LOCALIDAD';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-12194';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_DESCRIPCION VARCHAR2(30 CHAR) := 'TORREDELCAMPO';
    V_CODIGO VARCHAR2(30 CHAR) := '23086';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'');
    
    --Comprobamos el dato a insertar
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE DD_LOC_CODIGO = '''||V_CODIGO||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN				
          
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''||V_CODIGO||'''');

    	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.'||V_TABLA||' SET 
                  DD_LOC_DESCRIPCION = '''||V_DESCRIPCION||''', DD_LOC_DESCRIPCION_LARGA = '''||V_DESCRIPCION||''',
                  USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE	WHERE DD_LOC_CODIGO = '''||V_CODIGO||'''';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
    END IF;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
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

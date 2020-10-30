--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201014
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8220
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8220';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_DESCRIPCION VARCHAR2(30 CHAR) := 'Dehesas Viejas';
    V_CODIGO VARCHAR2(30 CHAR) := '18065';
    V_PRV_DESC VARCHAR2(30 CHAR) := 'Granada'; 
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'');
    
    --Comprobamos el dato a insertar
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE DD_LOC_CODIGO = '''||V_CODIGO||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN				
          
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''||V_CODIGO||'''');

    	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.'||V_TABLA||' SET 
                  DD_LOC_DESCRIPCION = '''||V_DESCRIPCION||''', DD_LOC_DESCRIPCION_LARGA = '''||V_DESCRIPCION||''',
                  DD_PRV_ID = (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION='''||V_PRV_DESC||'''),
                  USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE	WHERE DD_LOC_CODIGO = '''||V_CODIGO||'''';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
           
    ELSE
       
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''||V_CODIGO||'''');   
    
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.'||V_TABLA||' (DD_LOC_ID, DD_PRV_ID, DD_LOC_CODIGO, DD_LOC_DESCRIPCION, DD_LOC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
                  SELECT '|| V_ESQUEMA_M ||'.S_'||V_TABLA||'.NEXTVAL,(SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION='''||V_PRV_DESC||'''),
                  '''||V_CODIGO||''','''||V_DESCRIPCION||''','''||V_DESCRIPCION||''','''||V_USUARIO||''',SYSDATE FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
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

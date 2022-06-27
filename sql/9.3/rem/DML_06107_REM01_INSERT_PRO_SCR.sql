--/*
--######################################### 
--## AUTOR=Remus Ovidiu Viorel
--## FECHA_CREACION=20220523
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11736
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar nueva configuración de lógica aplica/no aplica
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-11736'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='PRO_SCR'; --Vble. auxiliar para almacenar la tabla a insertar

    V_ID_PROPIETARIO NUMBER(16) := NULL; 
    V_ID_SUBCARTERA NUMBER(16) :=  NULL; 
    V_COUNT_PROPIETARIO NUMBER(16);
    V_COUNT_SUBCARTERA NUMBER(16);

    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    
    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		T_TIPO_DATA('V64478373','157')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
        


        --Obtenemos el id del PROPIETARIO
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(1)||''' 
					AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT_PROPIETARIO;
        
        IF V_COUNT_PROPIETARIO > 0 THEN
	        V_MSQL := 'SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(1)||''' 
						AND BORRADO = 0';
	        EXECUTE IMMEDIATE V_MSQL INTO V_ID_PROPIETARIO;
	    ELSE
	    	V_ID_PROPIETARIO := NULL;
	    
        END IF;
        
        --Obtenemos el id de la subcartera
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||''' 
					AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT_SUBCARTERA;
        
        IF V_COUNT_SUBCARTERA > 0 THEN
	        V_MSQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||''' 
						AND BORRADO = 0';
	        EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBCARTERA;
	    ELSE
	    	V_ID_SUBCARTERA := NULL;
	    END IF;

        IF V_ID_PROPIETARIO IS NOT NULL AND V_ID_SUBCARTERA IS NOT NULL THEN

        --Comprobar el dato a insertar.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' 
					WHERE PRO_ID = '||V_ID_PROPIETARIO||' 
          			AND DD_SCR_ID = '||V_ID_SUBCARTERA||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
        ELSE

	        --Insertamos el registro
	        V_MSQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (PRO_ID, DD_SCR_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
	                    VALUES (
	                    '||V_ID_PROPIETARIO||',
						'||V_ID_SUBCARTERA||',
						0,
	                    '''||V_USUARIO||''',
	                    SYSDATE,
						0)';
						
			
	                    
	        EXECUTE IMMEDIATE V_MSQL;
	
	
	        V_COUNT:=V_COUNT+1; 
	        
	    END IF;
        
	    ELSE
	    
	    DBMS_OUTPUT.PUT_LINE('[INFO]: El propietario con identificacion: '''||TRIM(V_TMP_TIPO_DATA(1))||''' o la cartera con el codigo: '''||TRIM(V_TMP_TIPO_DATA(2))||''' no existen');
	    
        END IF;

    END LOOP;

    
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN INSERTADO '''||V_COUNT||''' REGISTROS ');
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(V_MSQL); 
          ROLLBACK;
          RAISE;          

END;
/
EXIT

--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200806
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7919
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_TIT_TITULO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7919';    

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('7002341'),
		T_TIPO_DATA('6995445'),
		T_TIPO_DATA('6998881'),
		T_TIPO_DATA('5957914'),
		T_TIPO_DATA('6996524'),
		T_TIPO_DATA('6996262'),
		T_TIPO_DATA('5957613'),
		T_TIPO_DATA('6992889'),
		T_TIPO_DATA('6998318'),
		T_TIPO_DATA('6995706'),
		T_TIPO_DATA('6996824'),
		T_TIPO_DATA('6980866'),
		T_TIPO_DATA('7007629')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN '||V_TEXT_TABLA||'');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_SQL :=   'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN
        
        	V_MSQL :=   'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';        
        	EXECUTE IMMEDIATE V_MSQL INTO V_ID;        
        
	        	V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		                    SET DD_ETI_ID = (SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO WHERE DD_ETI_CODIGO = ''06'') 									
				     		 	,USUARIOMODIFICAR = '''||V_USUARIO||'''
						     	,FECHAMODIFICAR = SYSDATE
		                    WHERE ACT_ID = '||V_ID||' AND BORRADO = 0';
		                    
		          EXECUTE IMMEDIATE V_MSQL;		  
		          
		        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO 
							SET BORRADO = 1											    
				     		 ,USUARIOBORRAR = '''||V_USUARIO||'''
						     ,FECHABORRAR = SYSDATE
							WHERE TIT_ID = (SELECT TIT_ID 
																FROM '||V_ESQUEMA||'.ACT_TIT_TITULO
		        												WHERE ACT_ID = '||V_ID||'	AND BORRADO = 0)
		        			AND DD_ESP_ID = (SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO = ''03'')';                    
		                    
		          EXECUTE IMMEDIATE V_MSQL;		    
		          
		          DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizada información registral para el num_activo  '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
       	
       	END IF;
       
      END LOOP;
      
    COMMIT;    
    DBMS_OUTPUT.PUT_LINE('[FIN]: FINALIZADO CORRECTAMENTE ');

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

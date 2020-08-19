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
    	T_TIPO_DATA('7298928'),
		T_TIPO_DATA('7297170'),
		T_TIPO_DATA('7296472'),
		T_TIPO_DATA('7294800'),
		T_TIPO_DATA('7294035'),
		T_TIPO_DATA('7292770'),
		T_TIPO_DATA('7226904'),
		T_TIPO_DATA('7100012'),
		T_TIPO_DATA('7099943'),
		T_TIPO_DATA('7099484'),
		T_TIPO_DATA('7096556'),
		T_TIPO_DATA('7094560'),
		T_TIPO_DATA('7094499'),
		T_TIPO_DATA('7089283'),
		T_TIPO_DATA('7075376'),
		T_TIPO_DATA('7002373'),
		T_TIPO_DATA('7002277'),
		T_TIPO_DATA('7002256'),
		T_TIPO_DATA('7002255'),
		T_TIPO_DATA('7001584'),
		T_TIPO_DATA('7001097'),
		T_TIPO_DATA('7000885'),
		T_TIPO_DATA('7000842'),
		T_TIPO_DATA('7000457'),
		T_TIPO_DATA('6998751'),
		T_TIPO_DATA('6996106'),
		T_TIPO_DATA('6996098'),
		T_TIPO_DATA('6993087'),
		T_TIPO_DATA('6993086'),
		T_TIPO_DATA('6993085'),
		T_TIPO_DATA('6993084'),
		T_TIPO_DATA('6993083'),
		T_TIPO_DATA('6993082'),
		T_TIPO_DATA('6993081'),
		T_TIPO_DATA('6993080'),
		T_TIPO_DATA('6993064'),
		T_TIPO_DATA('6993063'),
		T_TIPO_DATA('6993062'),
		T_TIPO_DATA('6993061'),
		T_TIPO_DATA('6993060'),
		T_TIPO_DATA('6992749'),
		T_TIPO_DATA('6992518'),
		T_TIPO_DATA('6991374'),
		T_TIPO_DATA('6990411'),
		T_TIPO_DATA('6990203'),
		T_TIPO_DATA('6987824'),
		T_TIPO_DATA('6984169'),
		T_TIPO_DATA('6983792'),
		T_TIPO_DATA('6983757'),
		T_TIPO_DATA('6983269'),
		T_TIPO_DATA('6982598'),
		T_TIPO_DATA('6982597'),
		T_TIPO_DATA('6982356'),
		T_TIPO_DATA('6980915'),
		T_TIPO_DATA('6980577'),
		T_TIPO_DATA('6979321'),
		T_TIPO_DATA('6956511'),
		T_TIPO_DATA('6815845'),
		T_TIPO_DATA('6809931'),
		T_TIPO_DATA('6060003'),
		T_TIPO_DATA('6056968'),
		T_TIPO_DATA('6056958'),
		T_TIPO_DATA('6056957'),
		T_TIPO_DATA('6056956'),
		T_TIPO_DATA('6055557'),
		T_TIPO_DATA('6054961'),
		T_TIPO_DATA('6054835'),
		T_TIPO_DATA('6053906'),
		T_TIPO_DATA('6053905'),
		T_TIPO_DATA('6053363'),
		T_TIPO_DATA('6052832'),
		T_TIPO_DATA('6052831'),
		T_TIPO_DATA('6052830'),
		T_TIPO_DATA('6052829'),
		T_TIPO_DATA('6052401'),
		T_TIPO_DATA('5967790'),
		T_TIPO_DATA('5964125'),
		T_TIPO_DATA('5962958'),
		T_TIPO_DATA('5962455'),
		T_TIPO_DATA('5960015'),
		T_TIPO_DATA('5955356'),
		T_TIPO_DATA('5952588'),
		T_TIPO_DATA('5952342'),
		T_TIPO_DATA('5949606'),
		T_TIPO_DATA('5949511'),
		T_TIPO_DATA('5939446'),
		T_TIPO_DATA('5938394'),
		T_TIPO_DATA('5936168'),
		T_TIPO_DATA('5933657'),
		T_TIPO_DATA('5932152'),
		T_TIPO_DATA('5930374'),
		T_TIPO_DATA('5928982')
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
		                    SET TIT_FECHA_INSC_REG =
									(SELECT AHT_FECHA_INSCRIPCION
										FROM '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO
										WHERE TIT_ID = (SELECT TIT_ID 
		        														FROM '||V_ESQUEMA||'.ACT_TIT_TITULO
		        														WHERE ACT_ID = '||V_ID||'	AND BORRADO = 0)
		        						AND DD_ESP_ID = (SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO = ''03'')
										AND BORRADO = 0
									)		    
				     		 ,USUARIOMODIFICAR = '''||V_USUARIO||'''
						     ,FECHAMODIFICAR = SYSDATE
		                    WHERE ACT_ID = '||V_ID||'';
		                    
		          EXECUTE IMMEDIATE V_MSQL;		          
		          DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizada fecha de inscripcion para el num_activo  '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
       	
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

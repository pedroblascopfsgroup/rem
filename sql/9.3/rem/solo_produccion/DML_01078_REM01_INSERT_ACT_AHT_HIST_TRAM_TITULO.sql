--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211022
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10638
--## PRODUCTO=NO
--##
--## Finalidad: Se añaden datos a la tabla ACT_TIT_TITULO y ACT_AHT_HIST_TRAM_TITULO
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
    V_ID NUMBER(16);
    V_USUARIO VARCHAR2(150 CHAR):='REMVIP-10638';

    V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
        --ACT_NUM_ACTIVO    FECHA PRES.REGISTRO     FECHA INSCRIPCION
        T_FUNCION('7465874','05/03/2020','23/04/2020'),
        T_FUNCION('7465880','05/03/2020','23/04/2020'),
        T_FUNCION('7465881','05/03/2020','23/04/2020'),
        T_FUNCION('7465882','05/03/2020','23/04/2020'),
        T_FUNCION('7465883','05/03/2020','23/04/2020'),
        T_FUNCION('7465884','05/03/2020','23/04/2020'),
        T_FUNCION('7465885','05/03/2020','23/04/2020'),
        T_FUNCION('7465886','05/03/2020','23/04/2020'),
        T_FUNCION('7465887','05/03/2020','23/04/2020'),
        T_FUNCION('7465888','05/03/2020','23/04/2020'),
        T_FUNCION('7465899','05/03/2020','23/04/2020'),
        T_FUNCION('7465900','05/03/2020','23/04/2020'),
        T_FUNCION('7465902','05/03/2020','23/04/2020'),
        T_FUNCION('7465903','05/03/2020','23/04/2020'),
        T_FUNCION('7465904','05/03/2020','23/04/2020'),
        T_FUNCION('7465907','05/03/2020','23/04/2020'),
        T_FUNCION('7465910','05/03/2020','23/04/2020'),
        T_FUNCION('7465914','05/03/2020','23/04/2020'),
        T_FUNCION('7465917','05/03/2020','23/04/2020'),
        T_FUNCION('7465920','05/03/2020','23/04/2020'),
        T_FUNCION('7465922','05/03/2020','23/04/2020'),
        T_FUNCION('7465923','05/03/2020','23/04/2020'),
        T_FUNCION('7465927','05/03/2020','23/04/2020'),
        T_FUNCION('7465930','05/03/2020','23/04/2020'),
        T_FUNCION('7465931','05/03/2020','23/04/2020'),
        T_FUNCION('7465933','05/03/2020','23/04/2020'),
        T_FUNCION('7465936','05/03/2020','23/04/2020'),
        T_FUNCION('7465937','05/03/2020','23/04/2020'),
        T_FUNCION('7465938','05/03/2020','23/04/2020'),
        T_FUNCION('7465940','05/03/2020','23/04/2020'),
        T_FUNCION('7465941','05/03/2020','23/04/2020'),
        T_FUNCION('7465947','05/03/2020','23/04/2020'),
        T_FUNCION('7465949','05/03/2020','23/04/2020'),
        T_FUNCION('7465950','05/03/2020','23/04/2020'),
        T_FUNCION('7465951','05/03/2020','23/04/2020'),
        T_FUNCION('7465952','05/03/2020','23/04/2020'),
        T_FUNCION('7465953','05/03/2020','23/04/2020'),
        T_FUNCION('7465955','05/03/2020','23/04/2020'),
        T_FUNCION('7465956','05/03/2020','23/04/2020'),
        T_FUNCION('7465958','05/03/2020','23/04/2020'),
        T_FUNCION('7465959','05/03/2020','23/04/2020'),
        T_FUNCION('7465969','05/03/2020','23/04/2020'),
        T_FUNCION('7465970','05/03/2020','23/04/2020'),
        T_FUNCION('7465972','05/03/2020','23/04/2020'),
        T_FUNCION('7465976','05/03/2020','23/04/2020'),
        T_FUNCION('7465977','05/03/2020','23/04/2020'),
        T_FUNCION('7465978','05/03/2020','23/04/2020'),
        T_FUNCION('7465983','05/03/2020','23/04/2020'),
        T_FUNCION('7465984','05/03/2020','23/04/2020'),
        T_FUNCION('7465999','05/03/2020','23/04/2020'),
        T_FUNCION('7466001','05/03/2020','23/04/2020'),
        T_FUNCION('7466002','05/03/2020','23/04/2020'),
        T_FUNCION('7466003','05/03/2020','23/04/2020'),
        T_FUNCION('7466004','05/03/2020','23/04/2020'),
        T_FUNCION('7466005','05/03/2020','23/04/2020'),
        T_FUNCION('7466006','05/03/2020','23/04/2020'),
        T_FUNCION('7466007','05/03/2020','23/04/2020')


    );          
    V_TMP_FUNCION T_FUNCION;
                
BEGIN	        
	            
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	            
    -- LOOP para insertar los valores en MGD_MAPEO_GESTOR_DOC -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_AHT_HIST_TRAM_TITULO ');


     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

            V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT  WHERE ACT.ACT_NUM_ACTIVO = '''||(V_TMP_FUNCION(1))||''' AND ACT.BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			

			
			-- Si existe el activo
			IF V_NUM_TABLAS = 1 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Existe el activo se procede a insertar en historico');

                V_SQL := 'SELECT TIT.TIT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                        JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID=ACT.ACT_ID AND TIT.BORRADO = 0                
                        WHERE ACT.ACT_NUM_ACTIVO = '''||(V_TMP_FUNCION(1))||''' AND ACT.BORRADO = 0';
			    EXECUTE IMMEDIATE V_SQL INTO V_ID;

                    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO (
                                AHT_ID, TIT_ID, AHT_FECHA_PRES_REGISTRO, AHT_FECHA_INSCRIPCION, DD_ESP_ID, USUARIOCREAR, FECHACREAR
                                ) VALUES (
                                '||V_ESQUEMA||'.S_ACT_AHT_HIST_TRAM_TITULO.NEXTVAL,
                                '||V_ID||',
                                TO_DATE('''||(V_TMP_FUNCION(2))||''',''DD/MM/YYYY''),
                                TO_DATE('''||(V_TMP_FUNCION(3))||''',''DD/MM/YYYY''),
                                (SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO = ''03'' AND BORRADO = 0),
                                '''||V_USUARIO||''',
                                SYSDATE)';
                    EXECUTE IMMEDIATE V_MSQL;    

                    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_TIT_TITULO SET
                        TIT_FECHA_INSC_REG = TO_DATE('''||(V_TMP_FUNCION(3))||''',''DD/MM/YYYY''),
                        DD_ETI_ID = (SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO WHERE BORRADO = 0 AND DD_ETI_CODIGO=''02''),
                        USUARIOMODIFICAR = '''||V_USUARIO||''',
                        FECHAMODIFICAR = SYSDATE
                        WHERE TIT_ID = '||V_ID||'';
                    EXECUTE IMMEDIATE V_MSQL;    

                    DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO insertados correctamente. '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||''' - '''||V_TMP_FUNCION(3)||''' ');
                    V_COUNT:=V_COUNT+1;        
			ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe el activo indicado: '''||(V_TMP_FUNCION(1))||'''');
		    END IF;	
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('[FIN]: MODIFICADOS CORRECTAMENTE '||V_COUNT||' DE '||V_COUNT_TOTAL||' ');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: Historico presentaciones ACTUALIZADO CORRECTAMENTE ');

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
--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210621
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10015
--## PRODUCTO=NO
--##
--## Finalidad: Se añaden datos a la tabla ACT_DIS_DISTRIBUCION
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
    V_USUARIO VARCHAR2(150 CHAR):='REMVIP-10015';

    V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
        --ACT_NUM_ACTIVO    CANTIDAD_DORMITORIOS     CANTIDAD_BAÑOS
	    T_FUNCION('7064238','4','2'),
        T_FUNCION('7063584','4','2'),
        T_FUNCION('7063589','4','2'),
        T_FUNCION('7063592','4','2'),
        T_FUNCION('7063601','4','2'),
        T_FUNCION('7063604','4','2'),
        T_FUNCION('7063605','4','2'),
        T_FUNCION('7063609','4','2'),
        T_FUNCION('7063613','4','2'),
        T_FUNCION('7063616','4','2'),
        T_FUNCION('7063618','4','2'),
        T_FUNCION('7063621','4','2'),
        T_FUNCION('7063625','4','2'),
        T_FUNCION('7063628','4','2'),
        T_FUNCION('7063630','4','2'),
        T_FUNCION('7063633','4','2'),
        T_FUNCION('7063641','4','2'),
        T_FUNCION('7063642','4','2'),
        T_FUNCION('7063645','4','2'),
        T_FUNCION('7063649','4','2'),
        T_FUNCION('7063661','4','2'),
        T_FUNCION('7063662','4','2'),
        T_FUNCION('7063665','4','2'),
        T_FUNCION('7063666','4','2'),
        T_FUNCION('7063674','4','2'),
        T_FUNCION('7063677','4','2'),
        T_FUNCION('7063686','4','2'),
        T_FUNCION('7063698','4','2'),
        T_FUNCION('7063701','4','2'),
        T_FUNCION('7063702','4','2'),
        T_FUNCION('7063705','4','2'),
        T_FUNCION('7063710','4','2'),
        T_FUNCION('7063713','4','2'),
        T_FUNCION('7063718','4','2'),
        T_FUNCION('7063773','4','2'),
        T_FUNCION('7063784','4','2'),
        T_FUNCION('7063807','4','2'),
        T_FUNCION('7063851','4','2'),
        T_FUNCION('7063884','4','2'),
        T_FUNCION('7063896','4','2'),
        T_FUNCION('7063929','4','2'),
        T_FUNCION('7063973','4','2'),
        T_FUNCION('7064007','4','2'),
        T_FUNCION('7064051','4','2'),
        T_FUNCION('7064095','4','2'),
        T_FUNCION('7064129','4','2'),
        T_FUNCION('7064140','4','2'),
        T_FUNCION('7064228','4','2'),
        T_FUNCION('7064258','4','2'),
        T_FUNCION('7064259','4','2'),
        T_FUNCION('7063714','4','2'),
        T_FUNCION('7063631','3','2'),
        T_FUNCION('7064118','3','2'),
        T_FUNCION('7064162','3','2'),
        T_FUNCION('7063680','3','2'),
        T_FUNCION('7063688','3','2'),
        T_FUNCION('7063692','3','2'),
        T_FUNCION('7064246','4','2'),
        T_FUNCION('7063691','3','2'),
        T_FUNCION('7064251','3','2'),
        T_FUNCION('7063669','4','2'),
        T_FUNCION('7063681','4','2'),
        T_FUNCION('7063984','3','2'),
        T_FUNCION('7063689','4','2'),
        T_FUNCION('7064018','4','2'),
        T_FUNCION('7063637','4','2'),
        T_FUNCION('7063597','4','2'),
        T_FUNCION('7063895','3','2'),
        T_FUNCION('7064029','3','2'),
        T_FUNCION('7064006','3','2'),
        T_FUNCION('7063918','3','2'),
        T_FUNCION('7063664','3','2'),
        T_FUNCION('7064243','4','2'),
        T_FUNCION('7064250','3','2'),
        T_FUNCION('7063657','4','2'),
        T_FUNCION('7063654','4','2'),
        T_FUNCION('7063594','3','2'),
        T_FUNCION('7063693','4','2'),
        T_FUNCION('7064233','4','2'),
        T_FUNCION('7064173','4','2'),
        T_FUNCION('7064255','4','2'),
        T_FUNCION('7063690','4','2'),
        T_FUNCION('7064247','4','2'),
        T_FUNCION('7063679','3','2'),
        T_FUNCION('7063596','3','2'),
        T_FUNCION('7063651','3','2'),
        T_FUNCION('7063675','3','2'),
        T_FUNCION('7063656','3','2'),
        T_FUNCION('7064151','3','2'),
        T_FUNCION('7063602','3','2'),
        T_FUNCION('7063644','3','2'),
        T_FUNCION('7063687','3','2'),
        T_FUNCION('7063614','3','2'),
        T_FUNCION('7064256','3','2'),
        T_FUNCION('7063639','3','2'),
        T_FUNCION('7063678','4','2'),
        T_FUNCION('7064245','3','2'),
        T_FUNCION('7063638','3','2'),
        T_FUNCION('7064260','3','2'),
        T_FUNCION('7063715','3','2'),
        T_FUNCION('7064106','3','2'),
        T_FUNCION('7063751','3','2'),
        T_FUNCION('7063655','3','2'),
        T_FUNCION('7063907','3','2'),
        T_FUNCION('7063640','3','2'),
        T_FUNCION('7063619','3','2'),
        T_FUNCION('7063796','3','2'),
        T_FUNCION('7063632','3','2'),
        T_FUNCION('7064257','3','2'),
        T_FUNCION('7063703','3','2'),
        T_FUNCION('7063591','3','2'),
        T_FUNCION('7063676','3','2'),
        T_FUNCION('7063585','4','2'),
        T_FUNCION('7063653','4','2'),
        T_FUNCION('7064248','3','2'),
        T_FUNCION('7063711','3','2'),
        T_FUNCION('7063668','3','2'),
        T_FUNCION('7064040','3','2'),
        T_FUNCION('7063706','4','2'),
        T_FUNCION('7063615','3','2'),
        T_FUNCION('7063620','3','2'),
        T_FUNCION('7063626','3','2'),
        T_FUNCION('7063995','3','2'),
        T_FUNCION('7063667','3','2'),
        T_FUNCION('7063694','3','2'),
        T_FUNCION('7063603','3','2'),
        T_FUNCION('7063717','3','2'),
        T_FUNCION('7064232','3','2'),
        T_FUNCION('7063712','3','2'),
        T_FUNCION('7063643','3','2'),
        T_FUNCION('7063607','3','2'),
        T_FUNCION('7064249','3','2'),
        T_FUNCION('7063700','3','2'),
        T_FUNCION('7063627','3','2'),
        T_FUNCION('7063699','3','2'),
        T_FUNCION('7063652','3','2'),
        T_FUNCION('7063608','3','2'),
        T_FUNCION('7064261','3','2'),
        T_FUNCION('7063785','3','2'),
        T_FUNCION('7063862','3','2'),
        T_FUNCION('7063683','3','2'),
        T_FUNCION('7063873','3','2'),
        T_FUNCION('7064234','2','2')
    );          
    V_TMP_FUNCION T_FUNCION;
                
BEGIN	        
	            
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	            
    -- LOOP para insertar los valores en MGD_MAPEO_GESTOR_DOC -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_DIS_DISTRIBUCION] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

            V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT  WHERE ACT.ACT_NUM_ACTIVO = '''||(V_TMP_FUNCION(1))||''' AND ACT.BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			

			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Existe el activo se procede a insertar distribucion');
                
                 V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                            JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID=ACT.ACT_ID                 
                            WHERE ACT.ACT_NUM_ACTIVO = '''||(V_TMP_FUNCION(1))||''' AND ACT.BORRADO = 0 AND ICO.BORRADO = 0';
			    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS > 0 THEN

                    V_SQL := 'SELECT ICO.ICO_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                            JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID=ACT.ACT_ID                 
                            WHERE ACT.ACT_NUM_ACTIVO = '''||(V_TMP_FUNCION(1))||''' AND ACT.BORRADO = 0 AND ICO.BORRADO = 0';
			        EXECUTE IMMEDIATE V_SQL INTO V_ID;                 

                    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION (
                                DIS_ID, DIS_NUM_PLANTA, DD_TPH_ID, DIS_CANTIDAD, USUARIOCREAR, FECHACREAR, BORRADO,ICO_ID
                                ) VALUES (
                                '||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
                                1,
                                (SELECT DD_TPH_ID FROM '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''01''),
                                '''||(V_TMP_FUNCION(2))||''',
                                '''||V_USUARIO||''',
                                SYSDATE,
                                0,
                                '||V_ID||')';
                    EXECUTE IMMEDIATE V_MSQL;           

                    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION (
                                DIS_ID, DIS_NUM_PLANTA, DD_TPH_ID, DIS_CANTIDAD, USUARIOCREAR, FECHACREAR, BORRADO,ICO_ID
                                ) VALUES (
                                '||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
                                1,
                                (SELECT DD_TPH_ID FROM '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''02''),
                                '''||(V_TMP_FUNCION(3))||''',
                                '''||V_USUARIO||''',
                                SYSDATE,
                                0,
                                '||V_ID||')';
                    EXECUTE IMMEDIATE V_MSQL;            

                    DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION insertados correctamente. '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||''' ');
                    V_COUNT:=V_COUNT+1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] El activo indicado no tiene informe comercial '''||(V_TMP_FUNCION(1))||'''');
                END IF;          
			ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe el activo indicado: '''||(V_TMP_FUNCION(1))||'''');
		    END IF;	
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('[FIN]: MODIFICADOS CORRECTAMENTE '||V_COUNT||' DE '||V_COUNT_TOTAL||' ');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACT_DIS_DISTRIBUCION ACTUALIZADO CORRECTAMENTE ');

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
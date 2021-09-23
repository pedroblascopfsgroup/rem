--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210923
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10187
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
    V_USUARIO VARCHAR2(150 CHAR):='REMVIP-10187';

    V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
        --ACT_NUM_ACTIVO    CANTIDAD_DORMITORIOS     CANTIDAD_BAÑOS
T_FUNCION('7036445','0','0'),
T_FUNCION('7035598','0','0'),
T_FUNCION('7035546','0','0'),
T_FUNCION('7036316','0','0'),
T_FUNCION('7039228','0','0'),
T_FUNCION('7035249','0','0'),
T_FUNCION('7035401','0','0'),
T_FUNCION('7035317','0','0'),
T_FUNCION('7035584','0','0'),
T_FUNCION('7039093','0','0'),
T_FUNCION('7039163','0','0'),
T_FUNCION('7039383','0','0'),
T_FUNCION('7041764','0','0'),
T_FUNCION('7039498','0','0'),
T_FUNCION('7034352','0','0'),
T_FUNCION('7035202','0','0'),
T_FUNCION('7039324','0','0'),
T_FUNCION('7034326','0','0'),
T_FUNCION('7038420','0','0'),
T_FUNCION('7040275','0','0'),
T_FUNCION('7035313','0','0'),
T_FUNCION('7042834','0','0'),
T_FUNCION('7037736','0','0'),
T_FUNCION('7039220','0','0'),
T_FUNCION('7034487','0','0'),
T_FUNCION('7037513','0','0'),
T_FUNCION('7039235','0','0'),
T_FUNCION('7038049','0','0'),
T_FUNCION('7035638','0','0'),
T_FUNCION('7037620','0','0'),
T_FUNCION('7038658','0','0'),
T_FUNCION('7035601','0','0'),
T_FUNCION('7041001','0','0'),
T_FUNCION('7038164','0','0'),
T_FUNCION('7039097','0','0'),
T_FUNCION('7039806','0','0'),
T_FUNCION('7038773','0','0'),
T_FUNCION('7042236','0','0'),
T_FUNCION('7036501','0','0'),
T_FUNCION('7035721','0','0'),
T_FUNCION('7039192','0','0'),
T_FUNCION('7041364','0','0'),
T_FUNCION('7035457','0','0'),
T_FUNCION('7034915','0','0'),
T_FUNCION('7039442','0','0'),
T_FUNCION('7038855','0','0'),
T_FUNCION('7037540','0','0'),
T_FUNCION('7041599','-1','0'),
T_FUNCION('7037674','0','0'),
T_FUNCION('7035550','0','0'),
T_FUNCION('7035552','0','0'),
T_FUNCION('7036498','0','0'),
T_FUNCION('7036118','-1','0'),
T_FUNCION('7036245','-1','0'),
T_FUNCION('7038556','0','0'),
T_FUNCION('7038654','0','0'),
T_FUNCION('7037750','0','0'),
T_FUNCION('7035294','0','0'),
T_FUNCION('7038557','0','0'),
T_FUNCION('7039000','0','0'),
T_FUNCION('7035277','0','0'),
T_FUNCION('7037948','0','0'),
T_FUNCION('7034562','0','0'),
T_FUNCION('7033660','-1','0'),
T_FUNCION('7036513','0','0'),
T_FUNCION('7055415','0','0'),
T_FUNCION('7055523','0','0'),
T_FUNCION('7041475','0','0'),
T_FUNCION('7035982','0','0'),
T_FUNCION('7035303','0','0'),
T_FUNCION('7035757','0','0'),
T_FUNCION('7037666','0','0'),
T_FUNCION('7038599','0','0'),
T_FUNCION('7036633','0','0'),
T_FUNCION('7036063','0','0'),
T_FUNCION('7039134','0','0'),
T_FUNCION('7036325','0','0'),
T_FUNCION('7036064','-1','0'),
T_FUNCION('7036241','0','0'),
T_FUNCION('7061224','-1','0'),
T_FUNCION('7061225','-1','-1'),
T_FUNCION('7061226','-1','0'),
T_FUNCION('7061227','-1','0'),
T_FUNCION('7061228','0','0'),
T_FUNCION('7061229','-1','0'),
T_FUNCION('7061230','-1','0'),
T_FUNCION('7061231','-1','0'),
T_FUNCION('7061232','-1','0'),
T_FUNCION('7061233','-1','0'),
T_FUNCION('7061234','-1','0'),
T_FUNCION('7061235','-1','0'),
T_FUNCION('7061236','-1','0'),
T_FUNCION('7061237','-1','0'),
T_FUNCION('7061238','-1','0'),
T_FUNCION('7061239','-1','-1'),
T_FUNCION('7061240','-1','-1'),
T_FUNCION('7061242','-1','-1'),
T_FUNCION('7035602','0','0'),
T_FUNCION('7036221','-1','0'),
T_FUNCION('7035164','-1','-1'),
T_FUNCION('7042571','0','0'),
T_FUNCION('7037818','-1','0'),
T_FUNCION('7039373','0','0'),
T_FUNCION('7040327','0','0'),
T_FUNCION('7040324','0','0'),
T_FUNCION('7036474','0','0'),
T_FUNCION('7035762','0','0'),
T_FUNCION('7038482','0','0'),
T_FUNCION('7038166','0','0'),
T_FUNCION('7035977','-1','0'),
T_FUNCION('7039119','-1','-1'),
T_FUNCION('7036104','0','0'),
T_FUNCION('7040213','-1','0'),
T_FUNCION('7039120','0','0'),
T_FUNCION('7039121','0','0'),
T_FUNCION('7053061','-1','0'),
T_FUNCION('7037843','0','0'),
T_FUNCION('7039349','0','0'),
T_FUNCION('7033247','0','-1'),
T_FUNCION('7038970','0','0'),
T_FUNCION('7039125','0','0'),
T_FUNCION('7041004','0','0'),
T_FUNCION('7042270','0','0'),
T_FUNCION('7039333','0','0'),
T_FUNCION('7035151','-1','-1'),
T_FUNCION('7034905','0','0'),
T_FUNCION('7037560','0','0'),
T_FUNCION('7037718','-1','0'),
T_FUNCION('7035670','0','0'),
T_FUNCION('7037755','0','0'),
T_FUNCION('7038691','0','0'),
T_FUNCION('7035112','0','0'),
T_FUNCION('7040131','0','0'),
T_FUNCION('7035407','0','0'),
T_FUNCION('7040186','0','0'),
T_FUNCION('7052656','-1','0'),
T_FUNCION('7052657','-1','0'),
T_FUNCION('7033305','0','0'),
T_FUNCION('7037833','0','0'),
T_FUNCION('7035464','0','0'),
T_FUNCION('7040180','0','0'),
T_FUNCION('7036651','0','0'),
T_FUNCION('7039809','0','-1'),
T_FUNCION('7039006','0','0'),
T_FUNCION('7035089','0','0'),
T_FUNCION('7033549','0','0'),
T_FUNCION('7035803','0','0'),
T_FUNCION('7035735','0','-1'),
T_FUNCION('7036649','0','0'),
T_FUNCION('7033022','0','0'),
T_FUNCION('7033134','0','0'),
T_FUNCION('7038447','-1','-1'),
T_FUNCION('7037049','-1','0'),
T_FUNCION('7037050','-1','0'),
T_FUNCION('7037051','-1','0'),
T_FUNCION('7037052','-1','0'),
T_FUNCION('7037053','-1','0'),
T_FUNCION('7037054','-1','0'),
T_FUNCION('7037055','-1','0'),
T_FUNCION('7037056','-1','0'),
T_FUNCION('7037057','-1','0'),
T_FUNCION('7037058','-1','0'),
T_FUNCION('7037059','-1','0'),
T_FUNCION('7034587','0','0'),
T_FUNCION('7039048','0','0'),
T_FUNCION('7037809','-1','0'),
T_FUNCION('7038490','-1','-1'),
T_FUNCION('7040212','0','0'),
T_FUNCION('7052176','0','0'),
T_FUNCION('7062310','-1','-1'),
T_FUNCION('7062309','-1','-1'),
T_FUNCION('7062298','-1','-1'),
T_FUNCION('7062292','0','0'),
T_FUNCION('7062289','0','0'),
T_FUNCION('7062284','0','0'),
T_FUNCION('7062283','0','0'),
T_FUNCION('7062281','0','0'),
T_FUNCION('7062279','0','0'),
T_FUNCION('7062276','-1','-1'),
T_FUNCION('7062270','-1','-1'),
T_FUNCION('7062267','-1','-1'),
T_FUNCION('7062091','-1','-1'),
T_FUNCION('7062090','-1','-1'),
T_FUNCION('7062088','0','0'),
T_FUNCION('7062087','0','-1'),
T_FUNCION('7062086','-1','-1'),
T_FUNCION('7062085','0','0'),
T_FUNCION('7062084','0','0'),
T_FUNCION('7062080','0','0'),
T_FUNCION('7062079','0','0'),
T_FUNCION('7062077','0','0'),
T_FUNCION('7062075','-1','-1'),
T_FUNCION('7062072','0','0'),
T_FUNCION('7062071','0','0'),
T_FUNCION('7062070','0','-1'),
T_FUNCION('7062069','0','0'),
T_FUNCION('7062068','0','-1'),
T_FUNCION('7062067','0','0'),
T_FUNCION('7062066','0','-1'),
T_FUNCION('7062065','0','0'),
T_FUNCION('7062064','-1','-1'),
T_FUNCION('7062061','0','0'),
T_FUNCION('7062060','-1','0'),
T_FUNCION('7062059','0','0'),
T_FUNCION('7062058','0','0'),
T_FUNCION('7062054','0','0'),
T_FUNCION('7062053','-1','-1'),
T_FUNCION('7062052','0','0'),
T_FUNCION('7062050','0','0'),
T_FUNCION('7062046','0','0'),
T_FUNCION('7062045','0','0'),
T_FUNCION('7062044','-1','0'),
T_FUNCION('7062043','0','0'),
T_FUNCION('7062042','-1','-1'),
T_FUNCION('7062041','-1','0'),
T_FUNCION('7062040','0','0'),
T_FUNCION('7062039','0','0'),
T_FUNCION('7062038','0','0'),
T_FUNCION('7062035','-1','-1'),
T_FUNCION('7062034','-1','-1'),
T_FUNCION('7062033','-1','-1'),
T_FUNCION('7062032','-1','-1'),
T_FUNCION('7062031','-1','-1'),
T_FUNCION('7062027','-1','-1'),
T_FUNCION('7062026','-1','-1'),
T_FUNCION('7062024','-1','-1'),
T_FUNCION('7062019','-1','-1'),
T_FUNCION('7062018','-1','-1'),
T_FUNCION('7062017','-1','-1'),
T_FUNCION('7062016','-1','-1'),
T_FUNCION('7062014','0','0'),
T_FUNCION('7062013','0','0'),
T_FUNCION('7062012','0','0'),
T_FUNCION('7062011','0','0'),
T_FUNCION('7062010','0','0'),
T_FUNCION('7062009','0','0'),
T_FUNCION('7062008','-1','-1'),
T_FUNCION('7062006','0','0'),
T_FUNCION('7062005','0','0'),
T_FUNCION('7062004','0','0'),
T_FUNCION('7062003','0','0'),
T_FUNCION('7062002','0','0'),
T_FUNCION('7062001','0','0'),
T_FUNCION('7062000','0','0'),
T_FUNCION('7061999','0','0'),
T_FUNCION('7061998','0','0'),
T_FUNCION('7061997','-1','-1'),
T_FUNCION('7061996','0','0'),
T_FUNCION('7061995','0','0'),
T_FUNCION('7061994','0','0'),
T_FUNCION('7061993','0','0'),
T_FUNCION('7061992','0','0'),
T_FUNCION('7061991','0','0'),
T_FUNCION('7061990','0','0'),
T_FUNCION('7061989','0','0'),
T_FUNCION('7061988','0','0'),
T_FUNCION('7061987','-1','0'),
T_FUNCION('7061986','-1','-1'),
T_FUNCION('7061985','0','0'),
T_FUNCION('7061984','0','0'),
T_FUNCION('7061983','0','0'),
T_FUNCION('7061982','-1','-1'),
T_FUNCION('7061981','-1','-1'),
T_FUNCION('7061980','-1','-1'),
T_FUNCION('7061978','-1','-1'),
T_FUNCION('7061977','-1','-1'),
T_FUNCION('7061976','-1','-1'),
T_FUNCION('7061975','-1','-1'),
T_FUNCION('7061974','-1','-1'),
T_FUNCION('7061973','-1','-1'),
T_FUNCION('7061972','-1','-1'),
T_FUNCION('7061971','-1','-1'),
T_FUNCION('7061970','-1','-1'),
T_FUNCION('7061969','-1','-1'),
T_FUNCION('7061968','-1','-1'),
T_FUNCION('7061967','-1','-1'),
T_FUNCION('7061966','-1','-1'),
T_FUNCION('7061965','-1','-1'),
T_FUNCION('7061964','-1','-1'),
T_FUNCION('7061962','-1','-1'),
T_FUNCION('7061961','-1','-1'),
T_FUNCION('7061960','0','0'),
T_FUNCION('7061952','0','0'),
T_FUNCION('7061950','0','0'),
T_FUNCION('7061949','0','0'),
T_FUNCION('7061946','0','0'),
T_FUNCION('7061945','0','0'),
T_FUNCION('7061941','0','0'),
T_FUNCION('7061940','0','0'),
T_FUNCION('7061938','0','0'),
T_FUNCION('7061930','0','0'),
T_FUNCION('7061928','0','0'),
T_FUNCION('7061927','0','0'),
T_FUNCION('7061926','-1','-1'),
T_FUNCION('7061924','0','0'),
T_FUNCION('7061923','0','0'),
T_FUNCION('7061919','0','0'),
T_FUNCION('7061918','0','0'),
T_FUNCION('7061916','-1','-1'),
T_FUNCION('7061915','-1','-1'),
T_FUNCION('7061908','-1','-1'),
T_FUNCION('7061906','-1','-1'),
T_FUNCION('7061905','-1','-1'),
T_FUNCION('7061903','-1','0'),
T_FUNCION('7061902','-1','0'),
T_FUNCION('7061901','-1','0'),
T_FUNCION('7061900','-1','0'),
T_FUNCION('7061899','-1','0'),
T_FUNCION('7061898','0','0'),
T_FUNCION('7061897','0','0'),
T_FUNCION('7061896','0','0'),
T_FUNCION('7061895','0','0'),
T_FUNCION('7061894','0','0'),
T_FUNCION('7061893','0','0'),
T_FUNCION('7061892','0','0'),
T_FUNCION('7061891','0','0'),
T_FUNCION('7061890','0','0'),
T_FUNCION('7061889','-1','0'),
T_FUNCION('7061888','0','0'),
T_FUNCION('7061887','0','0'),
T_FUNCION('7061886','0','0'),
T_FUNCION('7061885','0','0'),
T_FUNCION('7061884','0','0'),
T_FUNCION('7061883','-1','0'),
T_FUNCION('7061882','0','0'),
T_FUNCION('7061881','0','0'),
T_FUNCION('7061880','0','0'),
T_FUNCION('7061879','0','0'),
T_FUNCION('7061878','-1','0'),
T_FUNCION('7061877','0','0'),
T_FUNCION('7061876','0','0'),
T_FUNCION('7061875','0','0'),
T_FUNCION('7061874','0','0'),
T_FUNCION('7061873','0','0'),
T_FUNCION('7061872','-1','0'),
T_FUNCION('7061871','-1','0'),
T_FUNCION('7061870','-1','0'),
T_FUNCION('7061869','-1','0'),
T_FUNCION('7061868','-1','0'),
T_FUNCION('7061867','-1','0'),
T_FUNCION('7061866','-1','0'),
T_FUNCION('7061865','-1','0'),
T_FUNCION('7061864','-1','0'),
T_FUNCION('7061863','-1','0'),
T_FUNCION('7061862','-1','0'),
T_FUNCION('7061861','-1','0'),
T_FUNCION('7061860','-1','0'),
T_FUNCION('7061859','-1','0'),
T_FUNCION('7061858','-1','0'),
T_FUNCION('7061857','-1','0'),
T_FUNCION('7061856','-1','0')

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

                    IF  V_TMP_FUNCION(2) != '0' THEN

                        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION (
                                    DIS_ID, DIS_NUM_PLANTA, DD_TPH_ID, DIS_CANTIDAD, USUARIOCREAR, FECHACREAR, BORRADO,ICO_ID
                                    ) VALUES (
                                    '||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
                                    0,
                                    (SELECT DD_TPH_ID FROM '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''12''),
                                    NULL,
                                    '''||V_USUARIO||''',
                                    SYSDATE,
                                    0,
                                    '||V_ID||')';
                        EXECUTE IMMEDIATE V_MSQL; 

                    END IF;

                    IF V_TMP_FUNCION(3) != '0' THEN

                        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION (
                                    DIS_ID, DIS_NUM_PLANTA, DD_TPH_ID, DIS_CANTIDAD, USUARIOCREAR, FECHACREAR, BORRADO,ICO_ID
                                    ) VALUES (
                                    '||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
                                    0,
                                    (SELECT DD_TPH_ID FROM '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''11''),
                                    NULL,
                                    '''||V_USUARIO||''',
                                    SYSDATE,
                                    0,
                                    '||V_ID||')';
                        EXECUTE IMMEDIATE V_MSQL;  

                    END IF;          

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
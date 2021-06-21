--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10006
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
    V_USUARIO VARCHAR2(150 CHAR):='REMVIP-10006';

    V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
        --ACT_NUM_ACTIVO    CANTIDAD_DORMITORIOS     CANTIDAD_BAÑOS
	    T_FUNCION('7466286','2','1'),
        T_FUNCION('7466287','2','1'),
        T_FUNCION('7466288','2','1'),
        T_FUNCION('7466289','2','1'),
        T_FUNCION('7466290','2','1'),
        T_FUNCION('7466291','2','1'),
        T_FUNCION('7466292','2','1'),
        T_FUNCION('7466293','2','1'),
        T_FUNCION('7466294','2','1'),
        T_FUNCION('7466295','2','1'),
        T_FUNCION('7466296','2','1'),
        T_FUNCION('7466297','2','1'),
        T_FUNCION('7466299','2','1'),
        T_FUNCION('7466312','2','1'),
        T_FUNCION('7466313','2','1'),
        T_FUNCION('7466314','2','1'),
        T_FUNCION('7466318','2','1'),
        T_FUNCION('7466320','2','1'),
        T_FUNCION('7466321','2','1'),
        T_FUNCION('7466322','2','1'),
        T_FUNCION('7466324','2','1'),
        T_FUNCION('7466325','2','1'),
        T_FUNCION('7466327','2','1'),
        T_FUNCION('7466328','2','1'),
        T_FUNCION('7466329','2','1'),
        T_FUNCION('7466330','2','1'),
        T_FUNCION('7466341','2','1'),
        T_FUNCION('7466344','2','1'),
        T_FUNCION('7466350','2','1'),
        T_FUNCION('7466353','2','1'),
        T_FUNCION('7466355','2','1'),
        T_FUNCION('7466357','2','1'),
        T_FUNCION('7466360','2','1'),
        T_FUNCION('7466361','2','1'),
        T_FUNCION('7466365','2','1'),
        T_FUNCION('7466367','2','1'),
        T_FUNCION('7466369','2','1'),
        T_FUNCION('7466370','2','1'),
        T_FUNCION('7466371','2','1'),
        T_FUNCION('7466373','2','1'),
        T_FUNCION('7466377','2','1'),
        T_FUNCION('7466380','2','1'),
        T_FUNCION('7466381','2','1'),
        T_FUNCION('7466382','2','1'),
        T_FUNCION('7466383','2','1'),
        T_FUNCION('7466384','2','1'),
        T_FUNCION('7466385','2','1'),
        T_FUNCION('7466397','2','1'),
        T_FUNCION('7466401','2','1'),
        T_FUNCION('7466402','2','1'),
        T_FUNCION('7466403','2','1'),
        T_FUNCION('7466412','2','1'),
        T_FUNCION('7466415','2','1'),
        T_FUNCION('7466418','2','1'),
        T_FUNCION('7466419','2','1'),
        T_FUNCION('7466420','2','1'),
        T_FUNCION('7466423','2','1'),
        T_FUNCION('7466425','2','1'),
        T_FUNCION('7466427','2','1'),
        T_FUNCION('7466428','2','1')
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
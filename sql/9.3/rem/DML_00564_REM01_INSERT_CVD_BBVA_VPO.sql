--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20210215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8965
--## PRODUCTO=NO
--##
--## Finalidad: Insertar config subpartidas
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
       
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(50 CHAR):= 'CVD_CONF_DOC_OCULTAR_PERFIL';
    V_MSQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-8965';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.  
    V_COUNT NUMBER(16); --Vble para comprobar si existe registro con el codigo
	
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_TIPO_DATA IS TABLE OF T_TIPO_DATA; 
	V_TIPO_DATA T_ARRAY_TIPO_DATA := T_ARRAY_TIPO_DATA(
                    -- MATRICULA   --PEF_CODIGO                            
          
          T_TIPO_DATA('AI-05-ACUE-07','CARTERA_BBVA'),
          T_TIPO_DATA('AI-05-COMU-74','CARTERA_BBVA'),
          T_TIPO_DATA('AI-05-PRPE-38','CARTERA_BBVA')

	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
 	LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' 
				WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') 
				AND DD_TDO_ID = (SELECT DD_TDO_ID FROM '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD WHERE DD_TDO_MATRICULA = '''||V_TMP_TIPO_DATA(1)||''')
				AND BORRADO = 0';        

		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        --Si no existe el codigo se inserta			
		IF V_COUNT = 0 THEN 				
                   
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (CVD_ID
																	,PEF_ID
																	,DD_TDO_ID
																	,VERSION
																	,USUARIOCREAR
																	,FECHACREAR
																	,BORRADO) 
                        VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,
								(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''), 
								(SELECT DD_TDO_ID FROM '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD WHERE DD_TDO_MATRICULA = '''||V_TMP_TIPO_DATA(1)||'''),
                        		0, '''||V_USUARIO||''', SYSDATE, 0)';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADO CORRECTAMENTE CONFIGURACION DE TIPO DOCUMENTO CON MATRICULA: '''||V_TMP_TIPO_DATA(1)||''' OCULTAR A PERFIL: '''||V_TMP_TIPO_DATA(2)||'''');
				
		ELSE
		
        	DBMS_OUTPUT.PUT_LINE('LA CONFIGURACION YA EXISTE');
		
        END IF;
    
    END LOOP;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] ');
    
    COMMIT;

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

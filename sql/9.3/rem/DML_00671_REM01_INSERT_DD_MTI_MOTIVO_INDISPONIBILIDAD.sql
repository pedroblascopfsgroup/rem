--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14860
--## PRODUCTO=NO
--##
--## Finalidad: Insertar nuevos motivos de indisponibilidad
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#REMMASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'DD_MTI_MOTIVO_INDISPONIB';
    V_MSQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-14860';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.  
    
    V_COUNT NUMBER(16); --Vble para comprobar si existe registro con el codigo
    V_MTI_DESCRIPCION VARCHAR2(256 CHAR);
    V_MTI_COD VARCHAR2(256 CHAR);
	
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_TIPO_DATA IS TABLE OF T_TIPO_DATA; 
	V_TIPO_DATA T_ARRAY_TIPO_DATA := T_ARRAY_TIPO_DATA(
	  T_TIPO_DATA('Okupado','01'),
	  T_TIPO_DATA('Otra oferta con estado aprobada','02')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
 	LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

 		V_MTI_DESCRIPCION := TRIM(V_TMP_TIPO_DATA(1));
		V_MTI_COD := TRIM(V_TMP_TIPO_DATA(2));
        
        V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MTI_CODIGO = '''||V_MTI_COD||''' ';        
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBACION CORRECTA');		

        --Si no existe el codigo se inserta			
		IF V_COUNT = 0 THEN 	

            DBMS_OUTPUT.PUT_LINE('[INFO] INICIANDO PROCESO INSERCCION');			
                   
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_MTI_ID, DD_MTI_CODIGO, DD_MTI_DESCRIPCION, DD_MTI_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
                        SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,'''||V_MTI_COD||''','''||V_MTI_DESCRIPCION||''','''||V_MTI_DESCRIPCION||''',
                        '''||V_USUARIO||''', SYSDATE FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADO CORRECTAMENTE '''||V_MTI_DESCRIPCION||''' CON CODIGO '''||V_MTI_COD||''' ');
				
		ELSE
		
        	DBMS_OUTPUT.PUT_LINE('LA ENTIDAD FINANCIERA CON CODIGO '''||V_MTI_COD||''' YA EXISTE');
		
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

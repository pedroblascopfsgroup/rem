--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2220
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR DATOS PROPIETARIO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-2220';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	--------  NUM ACTIVO ,LOCALIDAD,PROVINCIA,CODIGO UVEM,TIPO PERSONA, NOMBRE PROPIETARIO               , APELLIDO 1, APELLIDO 2, TIPO DOCUMENTO, NUM DOCUMENTO, DIRECCION, TELEFONO, EMAIL, CARTERA 
    T_TIPO_DATA('7030295','NULL'	 ,'NULL'   ,'NULL'     ,'NULL'      ,'AYT HIPOTECARIO MIXTO III , FTA' ,'NULL'     ,'NULL'     ,'NULL'         ,'V86097979'   ,'NULL'    ,'NULL'   ,'NULL','NULL')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ACT_PRO_PROPIETARIO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE DATOS PROPIETARIO');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a modificar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||''''; 
		
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN		
				
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS DATOS DEL PROPIETARIO '||TRIM(V_TMP_TIPO_DATA(1))||'');	
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO SET ';
            
			IF V_TMP_TIPO_DATA(2) != 'NULL' THEN
				V_MSQL := V_MSQL || ' DD_LOC_ID = (SELECT DD_LOC_ID FROM REMMASTER.DD_LOC_LOCALIDAD WHERE UPPER(DD_LOC_DESCRIPCION) LIKE UPPER('''||TRIM(V_TMP_TIPO_DATA(2))||''')), ';
			END IF;
			IF V_TMP_TIPO_DATA(3) != 'NULL' THEN
				V_MSQL := V_MSQL || ' DD_PRV_ID = (SELECT DD_PRV_ID FROM REMMASTER.DD_PRV_PROVINCIA WHERE UPPER(DD_PRV_DESCRIPCION) LIKE UPPER('''||TRIM(V_TMP_TIPO_DATA(3))||''')), ';
			END IF;
			IF V_TMP_TIPO_DATA(4) != 'NULL' THEN
				V_MSQL := V_MSQL || ' PRO_CODIGO_UVEM = '||TRIM(V_TMP_TIPO_DATA(4))||', ';
			END IF;
			IF V_TMP_TIPO_DATA(5) != 'NULL' THEN
				V_MSQL := V_MSQL || ' DD_TPE_ID = (SELECT DD_TPE_ID FROM REMMASTER.DD_TPE_TIPO_PERSONA WHERE UPPER(DD_TPE_DESCRIPCION) = UPPER('''||TRIM(V_TMP_TIPO_DATA(5))||''')), ';
			END IF;
			IF V_TMP_TIPO_DATA(6) != 'NULL' THEN
				V_MSQL := V_MSQL || ' PRO_NOMBRE = '''||V_TMP_TIPO_DATA(6)||''', ';
			END IF;
			IF V_TMP_TIPO_DATA(7) != 'NULL' THEN
				V_MSQL := V_MSQL || ' PRO_APELLIDO1 = '''||TRIM(V_TMP_TIPO_DATA(7))||''', ';
			END IF;
			IF V_TMP_TIPO_DATA(8) != 'NULL' THEN
				V_MSQL := V_MSQL || ' PRO_APELLIDO2 = '''||TRIM(V_TMP_TIPO_DATA(8))||''', ';
			END IF;
			IF V_TMP_TIPO_DATA(9) != 'NULL' THEN
				V_MSQL := V_MSQL || ' DD_TDI_ID = (SELECT DD_TDI_ID FROM REM01.DD_TDI_TIPO_DOCUMENTO_ID WHERE UPPER(DD_TDI_DESCRIPCION) = UPPER('''||TRIM(V_TMP_TIPO_DATA(9))||''')), ';
			END IF;
			IF V_TMP_TIPO_DATA(10) != 'NULL' THEN
				V_MSQL := V_MSQL || ' PRO_DOCIDENTIF = '''||UPPER(TRIM(V_TMP_TIPO_DATA(10)))||''', ';
			END IF;
			IF V_TMP_TIPO_DATA(11) != 'NULL' THEN
				V_MSQL := V_MSQL || ' PRO_TELF = '''||TRIM(V_TMP_TIPO_DATA(11))||''', ';
			END IF;
			IF V_TMP_TIPO_DATA(12) != 'NULL' THEN
				V_MSQL := V_MSQL || ' PRO_EMAIL = '''||TRIM(V_TMP_TIPO_DATA(12))||''', ';
			END IF;
			IF V_TMP_TIPO_DATA(13) != 'NULL' THEN
				V_MSQL := V_MSQL || ' DD_CRA_ID = (SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE UPPER(DD_CRA_DESCRIPCION) = UPPER('''||TRIM(V_TMP_TIPO_DATA(12))||''')), ';
			END IF;

			V_MSQL := V_MSQL || ' USUARIOMODIFICAR = '''||V_USUARIO||''','|| 
                                ' FECHAMODIFICAR = SYSDATE '||
							    ' WHERE PRO_ID = (SELECT PRO.PRO_ID FROM REM01.ACT_PRO_PROPIETARIO PRO '||
													'INNER JOIN REM01.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.PRO_ID = PRO.PRO_ID ' ||
													'INNER JOIN REM01.ACT_ACTIVO ACT ON PAC.ACT_ID = ACT.ACT_ID ' ||
													'WHERE ACT.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||')';	
							 
			EXECUTE IMMEDIATE V_MSQL;
			

			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO PROPIETARIO '||TRIM(V_TMP_TIPO_DATA(1))||' A '||TRIM(V_TMP_TIPO_DATA(10))||'');
			
		--El activo no existe
		ELSE
			  DBMS_OUTPUT.PUT_LINE('[INFO]: EL PROPIETARIO '''||TRIM(V_TMP_TIPO_DATA(1))||' NO HA SIDO ACTUALIZADO');
		END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACUALIZACIÓN DATOS PROPIETARIO ');

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

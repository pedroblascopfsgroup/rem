--/*
--###########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200722
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10719
--## PRODUCTO=NO
--## 
--## Finalidad: INSERT INTO BLK_TIPO_ACTIVO
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
  V_USUARIO VARCHAR2(100 CHAR) := 'HREOS-10719';
  V_TABLA VARCHAR2(100 CHAR) := 'BLK_TIPO_ACTIVO';
  V_COUNT NUMBER(16):= 0; 
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
   V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('05', '20', '14', 'COMMERCIAL'),
    T_TIPO_DATA('03', '16', '15', 'COMMERCIAL')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' 
						WHERE BLK_TIPO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';

			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		
			IF V_COUNT = 0 THEN
		
				V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
								DD_TPA_ID
								, DD_SAC_ID
								, BLK_TIPO_CODIGO
								, BLK_TIPO_DESCRIPCION
								, USUARIOCREAR
								) VALUES (
								(SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
								, (SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
								, '''||TRIM(V_TMP_TIPO_DATA(3))||'''
								, '''||TRIM(V_TMP_TIPO_DATA(4))||'''
								, '''||V_USUARIO||''')';

                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Se inserta el BLK_TIPO_CODIGO '||TRIM(V_TMP_TIPO_DATA(3))||'');
			ELSE
				 DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el BLK_TIPO_CODIGO '||TRIM(V_TMP_TIPO_DATA(3))||'');
			END IF;
		END LOOP;
		
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ');

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

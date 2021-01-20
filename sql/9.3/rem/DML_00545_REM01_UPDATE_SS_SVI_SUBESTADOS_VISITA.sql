--/*
--###########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8724
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATE DD_SVI_SUBESTADOS_VISITA
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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-8724';
  V_TABLA VARCHAR2(100 CHAR) := 'DD_SVI_SUBESTADOS_VISITA';
  V_COUNT NUMBER(16):= 0; 
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
   V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 		DD_EVI_CODIGO, DD_SVI_CODIGO, DD_SVI_DESCRIPCION
        T_TIPO_DATA('05','25','Pdte Compradores')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' 
						WHERE DD_EVI_ID = (SELECT DD_EVI_ID FROM '||V_ESQUEMA||'.DD_EVI_ESTADOS_VISITA WHERE DD_EVI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
						  AND DD_SVI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';

			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		
			IF V_COUNT = 1 THEN
		
				V_MSQL:='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
							DD_SVI_DESCRIPCION = '''||V_TMP_TIPO_DATA(3)||''',
							DD_SVI_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(3)||''',
							USUARIOMODIFICAR = '''||V_USUARIO||''',
							FECHAMODIFICAR = SYSDATE
							WHERE DD_EVI_ID = (SELECT DD_EVI_ID FROM '||V_ESQUEMA||'.DD_EVI_ESTADOS_VISITA WHERE DD_EVI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
						  	AND DD_SVI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';

                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Se modifica el DD_SVI_CODIGO '||TRIM(V_TMP_TIPO_DATA(2))||'');
				
			ELSE
				 DBMS_OUTPUT.PUT_LINE('[INFO] No existe el DD_SVI_CODIGO '||TRIM(V_TMP_TIPO_DATA(2))||'');
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

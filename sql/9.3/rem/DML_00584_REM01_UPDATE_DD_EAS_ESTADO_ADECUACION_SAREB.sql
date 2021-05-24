--/*
--###########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13388
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATE DD_EAS_ESTADO_ADECUACION_SAREB
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
  V_USUARIO VARCHAR2(100 CHAR) := 'HREOS-13388';
  V_TABLA VARCHAR2(100 CHAR) := 'DD_EAS_ESTADO_ADECUACION_SAREB';
  V_COUNT NUMBER(16):= 0; 
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
   V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('4','06','07'),
		T_TIPO_DATA('5','06','07'),
		T_TIPO_DATA('6','06','07'),
		T_TIPO_DATA('7','02',NULL),
		T_TIPO_DATA('8','02',NULL),
		T_TIPO_DATA('9','06','07'),
		T_TIPO_DATA('10','06','07'),
		T_TIPO_DATA('11','06','07'),
		T_TIPO_DATA('12','06','07'),
		T_TIPO_DATA('13','06','07'),
		T_TIPO_DATA('14','06','07'),
		T_TIPO_DATA('15','06','07'),
		T_TIPO_DATA('16','06','07'),
		T_TIPO_DATA('21','06','07'),
		T_TIPO_DATA('22','06','07'),
		T_TIPO_DATA('23','06','07'),
		T_TIPO_DATA('24','06','07'),
		T_TIPO_DATA('25','06','07'),
		T_TIPO_DATA('27','02',NULL),
		T_TIPO_DATA('17','06','07'),
		T_TIPO_DATA('28','02',NULL),
		T_TIPO_DATA('18','02',NULL),
		T_TIPO_DATA('19','10',NULL),
		T_TIPO_DATA('20','03',NULL),
		T_TIPO_DATA('26','03',NULL),
		T_TIPO_DATA('29','06',NULL),
		T_TIPO_DATA('30','06',NULL),
		T_TIPO_DATA('31','06','07')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            
			V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA||' 
						WHERE DD_EAC_ID = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') 
						  AND DD_EAS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
							AND DD_EAC_ID_VANDALIZADO = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') ';

			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		
			IF V_COUNT = 0 THEN
		
				V_MSQL:='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
							DD_EAC_ID = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
							DD_EAC_ID_VANDALIZADO = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),
							USUARIOMODIFICAR = '''||V_USUARIO||''',
							FECHAMODIFICAR = SYSDATE
							WHERE DD_EAS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';

				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Se modifica el DD_EAS_CODIGO '||TRIM(V_TMP_TIPO_DATA(1))||', DD_EAC_CODIGO '||TRIM(V_TMP_TIPO_DATA(2))||' y DD_EAC_CODIGO_VAN '||TRIM(V_TMP_TIPO_DATA(2))||'');
				
			ELSE
				 DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el DD_EAS_CODIGO '||TRIM(V_TMP_TIPO_DATA(1))||', DD_EAC_CODIGO '||TRIM(V_TMP_TIPO_DATA(2))||'  y DD_EAC_CODIGO_VAN '||TRIM(V_TMP_TIPO_DATA(3))||'');
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

--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso Canovas
--## FECHA_CREACION=20200818
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7562
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
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
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-7562'; --Vble. auxiliar para almacenar el usuario
  V_TABLA VARCHAR2(100 CHAR) :='ACT_AGA_AGRUPACION_ACTIVO'; --Vble. para almacenar la tabla
  V_AGRUPACION VARCHAR2(100 CHAR) :='1000003784'; --Vble. para almacenar numero de agrupacion
  V_COUNT NUMBER(16); -- Vble. para comprobar

  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--ID_HAYA
    		T_TIPO_DATA('185807'),
    		T_TIPO_DATA('187102'),
		T_TIPO_DATA('197084'),
		T_TIPO_DATA('197086'),
		T_TIPO_DATA('197087')
    		
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
	
  
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	      	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

			DBMS_OUTPUT.PUT_LINE('[INFO] REALIZANDO COMPROBACION ACT_AGA_AGRUPACION_ACTIVO');

			--Comprobamos la existencia del registro con el activo en esa agrupacion
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE AGR_ID=(SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM='||V_AGRUPACION||') AND ACT_ID=(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO='||V_TMP_TIPO_DATA(1)||')';
			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

			IF V_COUNT = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE EL CAMPO, COMIENZA ACTUALIZACION');

				--ACTUALIZAMOS REGISTROS EN LA ACT_AGA_AGRUPACION_ACTIVO
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET		
					USUARIOMODIFICAR = '''||V_USUARIO||''',
					FECHAMODIFICAR = SYSDATE,
					FECHABORRAR=NULL,
					BORRADO=0,
					USUARIOBORRAR=NULL					
					WHERE AGR_ID= (SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM='||V_AGRUPACION||') AND ACT_ID= (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(1)||''')';
	
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL CAMPO EN LA BASE DE DATOS');
			END IF;
				
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS EN ACT_AGA_AGRUPACION_ACTIVO  '|| SQL%ROWCOUNT ||' REGISTROS');


		END LOOP;
    COMMIT;   
   
   	DBMS_OUTPUT.PUT_LINE('[FIN] ');

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

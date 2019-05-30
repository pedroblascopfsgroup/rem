--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4249
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-4249'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TAP_ID NUMBER(16); 

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	--         CODIGO GESTOR -- DESCRIPCION -- DESCRIPCION LARGA -- CODIGO CARTERA -- ACTIVO -- EXPEDIENTE -- AGRUPACION
	T_TIPO_DATA('HAYAGBOINM','Gestor Comercial Backoffice Inmobiliario','Gestor Comercial Backoffice Inmobiliario','08',1,0,0)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TABLA DD_GCM_GESTOR_CARGA_MASIVA');
	

      FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
	  V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		  V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA 
				WHERE DD_GCM_CODIGO = ''' || TRIM(V_TMP_TIPO_DATA(1)) || '''
				AND DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')
				AND BORRADO = 0';

	  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_FILAS;

		  IF ( V_NUM_FILAS = 0 ) THEN
		  
			  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL GESTOR '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
		       	  V_MSQL := '
				      INSERT INTO '|| V_ESQUEMA ||'.DD_GCM_GESTOR_CARGA_MASIVA (
					DD_GCM_ID,
					DD_GCM_CODIGO, 
					DD_GCM_DESCRIPCION, 
					DD_GCM_DESCRIPCION_LARGA,
					DD_CRA_ID,
					DD_GCM_ACTIVO,
					DD_GCM_EXPEDIENTE,
					DD_GCM_AGRUPACION,
					USUARIOCREAR,
					FECHACREAR
					)(
					SELECT '||V_ESQUEMA||'.S_DD_GCM_GESTOR_CARGA_MASIVA.NEXTVAL AS DD_GCM_ID,
					'''||TRIM(V_TMP_TIPO_DATA(1))||''' AS DD_GCM_CODIGO,
					'''||TRIM(V_TMP_TIPO_DATA(2))||''' AS DD_GCM_DESCRIPCION,
					'''||TRIM(V_TMP_TIPO_DATA(3))||''' AS DD_GCM_DESCRIPCION_LARGA,
					(SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''') AS DD_CRA_ID,
					'||TRIM(V_TMP_TIPO_DATA(5))||' AS DD_GCM_ACTIVO,
					'||TRIM(V_TMP_TIPO_DATA(6))||' AS DD_GCM_EXPEDIENTE,
					'||TRIM(V_TMP_TIPO_DATA(7))||' AS DD_GCM_AGRUPACION,
					'''||V_USR||''' AS USUARIOCREAR,
					SYSDATE AS FECHACREAR
					FROM DUAL
				      )';

			  EXECUTE IMMEDIATE V_MSQL;
			  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS '||SQL%ROWCOUNT||' CORRECTAMENTE');

			DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO EN DD_GCM_GESTOR_CARGA_MASIVA INSERTADO');
	
		ELSE
	
			DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO EN DD_GCM_GESTOR_CARGA_MASIVA, YA EXISTE');
	
		END IF;
	    
        END LOOP;
		
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

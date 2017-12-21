--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20171219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3507
--## PRODUCTO=NO
--##
--## Finalidad: Script que ACTUALIZA en GPV_GASTOS_PROVEEDOR los GASTOS añadidos en T_ARRAY_DATA
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
	V_TEXT_TABLA VARCHAR2(50 CHAR) := 'GPV_GASTOS_PROVEEDOR';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('9424267'),
		T_TIPO_DATA('9424262'),
		T_TIPO_DATA('9424474'),
		T_TIPO_DATA('9424475'),
		T_TIPO_DATA('9424221'),
		T_TIPO_DATA('9424252'),
		T_TIPO_DATA('9424276'),
		T_TIPO_DATA('9424277'),
		T_TIPO_DATA('9424311'),
		T_TIPO_DATA('9424342'),
		T_TIPO_DATA('9424386'),
		T_TIPO_DATA('9424407'),
		T_TIPO_DATA('9424416'),
		T_TIPO_DATA('9424429'),
		T_TIPO_DATA('9424441'),
		T_TIPO_DATA('9424445'),
		T_TIPO_DATA('9424447'),
		T_TIPO_DATA('9424488'),
		T_TIPO_DATA('9424259')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para añadir las matriculas en DD_TPD_TIPO_DOCUMENTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN GPV_GASTOS_PROVEEDOR] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a updatear
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE GPV_NUM_GASTO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL GASTO NUM: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET DD_EGA_ID = (SELECT DD_EGA_ID FROM DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''06'')'|| 
					', USUARIOMODIFICAR = ''HREOS-3507'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE GPV_NUM_GASTO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO= 0';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe no hacemos nada   
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        
       END IF;
      END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ESTADO DE GASTOS ACTUALIZADOS CORRECTAMENTE ');
   

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



   
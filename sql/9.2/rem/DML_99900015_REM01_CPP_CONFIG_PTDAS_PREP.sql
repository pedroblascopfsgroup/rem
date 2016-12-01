--/*
--##########################################
--## AUTOR=Jose Villel
--## FECHA_CREACION=20161125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CPP_CONFIG_PTDAS_PREP los datos añadidos en T_ARRAY_DATA
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
    V_TABLA VARCHAR2(50 CHAR) := 'CPP_CONFIG_PTDAS_PREP';

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(	
		-- Bankia
		T_TIPO_DATA('2016','01','03','09','','','492133'),
		T_TIPO_DATA('2016','02','03','09','','','492133'),
		T_TIPO_DATA('2016','01','03','08','','','492052'),
		T_TIPO_DATA('2016','02','03','08','','','492052'),
		T_TIPO_DATA('2016','01','03','07','','','492074'),
		T_TIPO_DATA('2016','02','03','07','','','492074'),
		T_TIPO_DATA('2016','01','03','06','','','491982'),
		T_TIPO_DATA('2016','02','03','06','','','491982'),
		-- Sareb
		T_TIPO_DATA('2016','01','02','','','','G011311'),
		T_TIPO_DATA('2016','02','02','','','','G011311'),
		-- Cajamar
		T_TIPO_DATA('2016','01','01','','','','06.01.001'),
		T_TIPO_DATA('2016','02','01','','','','06.01.001')
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- Mientras sea una tabla de configuración de la que extraemos información y no haya ninguna FK apuntando a su id, 
    -- podemos borrar la tabla completa y volver a generar la configuración.
    V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.'|| V_TABLA; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TRUNCADA');
	 
    -- LOOP para insertar los valores en CPP_CONFIG_PTDAS_PREP -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPP_CONFIG_PTDAS_PREP] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '||I);   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP (' ||
                    'CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, DD_SCR_ID, PRO_ID, PVE_ID, CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                      '('|| V_ID || ',
                      (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||V_TMP_TIPO_DATA(1)||'''),
					  (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
					  (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),
					  (SELECT DD_SCR_ID FROM '||V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''),
					  (SELECT PRO_ID FROM '||V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_CODIGO_UVEM = '''||V_TMP_TIPO_DATA(5)||'''),
					  (SELECT PVE_ID FROM '||V_ESQUEMA ||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||V_TMP_TIPO_DATA(6)||'''),
                      '''||TRIM(V_TMP_TIPO_DATA(7))||''',
                       0, ''DML'',SYSDATE,0 )';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CPP_CONFIG_PTDAS_PREP ACTUALIZADA CORRECTAMENTE ');
   

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



   
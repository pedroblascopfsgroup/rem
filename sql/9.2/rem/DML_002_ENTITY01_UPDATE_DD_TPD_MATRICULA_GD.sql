--/*
--##########################################
--## AUTOR=Sonia Garcia Mochales
--## FECHA_CREACION=20190123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.4.0-rem
--## INCIDENCIA_LINK=HREOS-5211
--## PRODUCTO=NO
--##
--## Finalidad: Modificar en la tabla DD_TPD_TIPO_DOCUMENTO el campo DD_TPD_MATRICULA_GD de Obtención de documento y Precios
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
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('27', 'OP-13-LIPR-14'),
	T_TIPO_DATA('25', 'OP-13-CERT-25'),
	T_TIPO_DATA('24', 'OP-13-CERA-71'),
	T_TIPO_DATA('17', 'OP-13-CERT-11'),
	T_TIPO_DATA('16', 'OP-13-CERT-10'),
	T_TIPO_DATA('15', 'OP-13-CERT-07'),
	T_TIPO_DATA('14', 'OP-13-CERT-17'),
	T_TIPO_DATA('13', 'OP-13-LIPR-03'),
	T_TIPO_DATA('12', 'OP-13-LIPR-06'),
	T_TIPO_DATA('11', 'OP-13-CERT-05'),
	T_TIPO_DATA('10', 'OP-13-PRPE-38'),
	T_TIPO_DATA('09', 'OP-13-COMU-74'),
	T_TIPO_DATA('08', 'OP-13-ACUE-07'),
	T_TIPO_DATA('07', 'OP-13-TASA-11'),
	T_TIPO_DATA('06', 'OP-13-NOTS-01'),
	T_TIPO_DATA('05', 'OP-13-NOTS-08'),
	T_TIPO_DATA('04', 'OP-13-DOCJ-15'),
	T_TIPO_DATA('03', 'OP-13-DOCJ-70'),
	T_TIPO_DATA('02', 'OP-13-SERE-24'),
	T_TIPO_DATA('23', 'OP-13-ESIN-AO'),
	T_TIPO_DATA('22', 'OP-13-ESIN-AN'),
	T_TIPO_DATA('21', 'OP-13-ESIN-AM'),
	T_TIPO_DATA('20', 'OP-13-ESIN-BB')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para MODIFICAR los valores en DD_TPD_TIPO_DOCUMENTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPD_TIPO_DOCUMENTO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
 		
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPD_TIPO_DOCUMENTO '||
                    'SET DD_TPD_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
		'WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
            
      
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TPD_TIPO_DOCUMENTO ACTUALIZADO CORRECTAMENTE ');


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




--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-6640
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra registros no necesarios en DD_ECV_ESTADOS_CIVILES los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##	0.1 Versión inicial		
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
        T_TIPO_DATA('05','Desconocido','Desconocido'),
        T_TIPO_DATA('06','Separado legal','Separado legal'),
        T_TIPO_DATA('07','Religioso','Religioso'),
        T_TIPO_DATA('08','Nulidad Matrimonial','Nulidad Matrimonial')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO EN DD_ECV_ESTADOS_CIVILES] ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
  
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECV_ESTADOS_CIVILES WHERE DD_ECV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
     	  V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.DD_ECV_ESTADOS_CIVILES WHERE DD_ECV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO CORRECTAMENTE '||TRIM(V_TMP_TIPO_DATA(1))||''); 
     ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO '||TRIM(V_TMP_TIPO_DATA(1))||'');
     END IF;
    END LOOP;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_ECV_ESTADOS_CIVILES ACTUALIZADO CORRECTAMENTE ');
   

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



   

--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.4.0-rem
--## INCIDENCIA_LINK=REMVIP-3353
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla DD_TPD_TIPO_DOCUMENTO
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
T_TIPO_DATA('83','02'),
T_TIPO_DATA('84','02'),
T_TIPO_DATA('85','02'),
T_TIPO_DATA('86','02'),
T_TIPO_DATA('87','02'),
T_TIPO_DATA('88','02'),
T_TIPO_DATA('89','02'),
T_TIPO_DATA('90','02'),
T_TIPO_DATA('91','02'),
T_TIPO_DATA('92','02'),
T_TIPO_DATA('93','02'),
T_TIPO_DATA('94','02'),
T_TIPO_DATA('95','02'),
T_TIPO_DATA('96','02'),
T_TIPO_DATA('97','02'),
T_TIPO_DATA('98','02'),
T_TIPO_DATA('99','02'),
T_TIPO_DATA('100','02'),
T_TIPO_DATA('101','02'),
T_TIPO_DATA('102','02'),
T_TIPO_DATA('103','02'),
T_TIPO_DATA('104','02'),
T_TIPO_DATA('104','03'),
T_TIPO_DATA('105','02'),
T_TIPO_DATA('105','03'),
T_TIPO_DATA('106','02'),
T_TIPO_DATA('107','02'),
T_TIPO_DATA('107','03'),
T_TIPO_DATA('108','03'),
T_TIPO_DATA('109','03'),
T_TIPO_DATA('110','03'),
T_TIPO_DATA('111','04'),
T_TIPO_DATA('112','04'),
T_TIPO_DATA('113','04'),
T_TIPO_DATA('114','03'),
T_TIPO_DATA('115','03'),
T_TIPO_DATA('116','03'),
T_TIPO_DATA('117','03'),
T_TIPO_DATA('118','03'),
T_TIPO_DATA('119','02')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    
    
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS LOS REGISTROS ACTUALES ');
	EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_ESQUEMA ||'.tpd_ttr';
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPD_TIPO_DOCUMENTO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
 		
            	
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: Insertamos EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := '
                      INSERT INTO '|| V_ESQUEMA ||'.tpd_ttr (
                        dd_tpd_id,
                        dd_ttr_id,
                        version
                        ) VALUES (
                        ( SELECT dd_tpd_id FROM '|| V_ESQUEMA ||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_VISIBLE = 0 AND DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ),
                        ( SELECT dd_ttr_id FROM '|| V_ESQUEMA ||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' ),
                        1
                      )';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS '||SQL%ROWCOUNT||' CORRECTAMENTE');
            
      
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




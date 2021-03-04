--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210304
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.4.0-rem
--## INCIDENCIA_LINK=HREOS-13379
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
    T_TIPO_DATA('138','Licencia de Obra','Licencia de Obra'),
    T_TIPO_DATA('131','Informe técnico habitabilidad','Informe técnico habitabilidad'),
    T_TIPO_DATA('132','Certificado sustitutivo de Cedula de Habitabilidad','Certificado sustitutivo de Cedula de Habitabilidad'),
    T_TIPO_DATA('133','Licencia de actividad comercial','Licencia de actividad comercial'),
    T_TIPO_DATA('134','Boletín telecomunicaciones','Boletín telecomunicaciones'),
    T_TIPO_DATA('135','Libro edificio','Libro edificio'),
    T_TIPO_DATA('136','Escritura obra nueva','Escritura obra nueva'),
    T_TIPO_DATA('137','AFO','AFO')
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
       	  V_MSQL := '
                      INSERT INTO '|| V_ESQUEMA ||'.dd_tpd_tipo_documento (
                        dd_tpd_id,
                        dd_tpd_codigo,
                        dd_tpd_descripcion,
                        dd_tpd_descripcion_larga,
                        version,
                        usuariocrear,
                        fechacrear,
                        borrado,
                        dd_tpd_visible
                      ) VALUES (
                        '|| V_ESQUEMA ||'.S_DD_TPD_TIPO_DOCUMENTO.NEXTVAL,
                        '''||TRIM(V_TMP_TIPO_DATA(1))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                        1,
                        ''HREOS-13379'',
                        SYSDATE,
                        0,                      
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




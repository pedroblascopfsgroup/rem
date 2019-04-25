--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3992
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla DD_TDP_TIPO_DOC_PRO 
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
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

	T_TIPO_DATA('183','Factura Registro (admisión)','Factura Registro (admisión)','AI-01-FACT-13'),
	T_TIPO_DATA('184','Factura Notario (admisión)','Factura Notario (admisión)','AI-01-FACT-09'),
	T_TIPO_DATA('185','Factura mensagería-correos (admisión)','Factura mensagería-correos (admisión)','AI-15-FACT-AM')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para MODIFICAR los valores en DD_TPD_TIPO_DOCUMENTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TDP_TIPO_DOC_PRO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
 		
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	   V_MSQL := '
                      INSERT INTO '|| V_ESQUEMA ||'.DD_TDP_TIPO_DOC_PRO (
                        dd_tdp_id,
                        dd_tdp_codigo,
                        dd_tdp_descripcion,
                        dd_tdp_descripcion_larga,
                        version,
                        usuariocrear,
                        fechacrear,
                        borrado,
                        dd_tdp_matricula_gd
                      ) VALUES (
                        '|| V_ESQUEMA ||'.S_DD_TDP_TIPO_DOC_PRO.NEXTVAL,
                        '''||TRIM(V_TMP_TIPO_DATA(1))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                        0,
                        ''REMVIP-3992'',
                        SYSDATE,
                        0,
                        '''||TRIM(V_TMP_TIPO_DATA(4))||'''
                      )';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS '||SQL%ROWCOUNT||' CORRECTAMENTE');
            
      
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TDP_TIPO_DOC_PRO ACTUALIZADO CORRECTAMENTE ');


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

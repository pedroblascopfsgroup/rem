--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10864
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10864';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA( 
        T_TIPO_DATA('09','14'), 
        T_TIPO_DATA('10','15'), 
        T_TIPO_DATA('11','16'), 
        T_TIPO_DATA('12','17'), 
        T_TIPO_DATA('14','18')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION ] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ;
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
            
            DBMS_OUTPUT.PUT_LINE('[INFO]: EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' -> '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' YA EXISTE');
            
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION '||
                    '    SET USUARIOMODIFICAR = '''||V_USUARIO||'''
                            ,FECHAMODIFICAR = SYSDATE
                            ,DD_MTO_ORDEN = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' 
                        WHERE DD_MTO_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''     
                    ';
            
            EXECUTE IMMEDIATE V_MSQL; 
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO');
            
        --Si no existe   
        ELSE
        
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO NO EXISTE');
          
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA DD_MTO_MOTIVOS_OCULTACION ACTUALIZADA CORRECTAMENTE ');


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
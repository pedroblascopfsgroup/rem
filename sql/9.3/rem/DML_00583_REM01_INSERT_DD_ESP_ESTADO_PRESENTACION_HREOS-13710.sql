--/*
--##########################################
--## AUTOR=Daniel Gallego
--## FECHA_CREACION=20210413
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13710
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla DD_ESP_ESTADO_PRESENTACION  
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
    V_TABLA VARCHAR2(30 CHAR) := 'DD_ESP_ESTADO_PRESENTACION';
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-13710';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ESP_ID NUMBER(16);
    V_ID NUMBER(16);
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('04', 'Nulo', 'Nulo'),
        T_TIPO_DATA('05', 'Inmatriculados', 'Inmatriculados'),
        T_TIPO_DATA('06', 'Imposible Inscripcion', 'Imposible Inscripcion'),
        T_TIPO_DATA('07', 'Desconocido', 'Desconocido')
); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
          V_MSQL := '
                        INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
                        DD_ESP_ID,
                        DD_ESP_CODIGO,
                        DD_ESP_DESCRIPCION,
                        DD_ESP_DESCRIPCION_LARGA,
                        USUARIOCREAR, 
                        FECHACREAR	                       
                    ) VALUES (
                        '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL,
                        '''||V_TMP_TIPO_DATA(1)||''',
                        '''||V_TMP_TIPO_DATA(2)||''',
                        '''||V_TMP_TIPO_DATA(3)||''',
                        '''||V_USUARIO||''',
                        SYSDATE                   
                        )';

          EXECUTE IMMEDIATE V_MSQL;          
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        

      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');


EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

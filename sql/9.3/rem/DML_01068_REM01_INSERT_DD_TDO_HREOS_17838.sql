--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20220519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17848
--## PRODUCTO=NO
--## Finalidad: Inserción nuevos registros en la tabla DD_TDO_TIPO_DOC_ENTIDAD.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_TIPOENTIDAD VARCHAR2(25 CHAR):= 'ECO';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- MATRICULA  			      PERFIL              
        T_TIPO_DATA('0865', 'DNI', 'OP-12-DOCI-01'),
        T_TIPO_DATA('0866', 'NIE', null),
        T_TIPO_DATA('0867', 'Tarjeta de residente', null),
        T_TIPO_DATA('0868', 'Pasaporte', 'OP-12-DOCI-05'),
        T_TIPO_DATA('0869', 'DNI país extranjero', null),
        T_TIPO_DATA('0870', 'TJ identifiación diplomática', null),
        T_TIPO_DATA('0871', 'Menor', null),
        T_TIPO_DATA('0872', 'Otros persona física', null),
        T_TIPO_DATA('0873', 'Otros persona jurídica', null),
        T_TIPO_DATA('0874', 'Ident Banco de España', null),
        T_TIPO_DATA('0875', 'NIE', 'OP-12-DOCI-06'),
        T_TIPO_DATA('0876', 'NIF país origen', null),
        T_TIPO_DATA('0877', 'Otro', 'OP-12-DOCI-02')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
     
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
	
	      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	    /*	DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos Dato '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	      --Comprobamos el dato a insertar
	      V_SQL :=   'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD WHERE DD_TDO_MATRICULA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
			 AND dd_Ted_id = (select dd_Ted_id from '||V_ESQUEMA||'.DD_TED_TIP_ENTIDAD_DOC where dd_ted_codigo = '''||V_TIPOENTIDAD||''')';
	         
			 DBMS_OUTPUT.PUT_LINE(V_SQL);
	      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	      
	      
	      --Si existe lo modificamos
	      IF V_NUM_TABLAS > 0 THEN				
	      
	        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Insertado ANTERIORMENTE');
	      */
	      --Si no existe, lo insertamos   
	      --ELSE
			 DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO');
		   	 V_MSQL := '  INSERT INTO  '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD (DD_TDO_ID, DD_TED_ID, DD_TDO_CODIGO, DD_TDO_DESCRIPCION, DD_TDO_DESCRIPCION_LARGA,
		   	                USUARIOCREAR, FECHACREAR, BORRADO, DD_TDO_MATRICULA)
		                    SELECT '||V_ESQUEMA||'.S_DD_TDO_TIPO_DOC_ENTIDAD.NEXTVAL,
		                     (select dd_Ted_id from '||V_ESQUEMA||'.DD_TED_TIP_ENTIDAD_DOC where dd_ted_codigo = '''||V_TIPOENTIDAD||'''),
							'''||TRIM(V_TMP_TIPO_DATA(1))||''',
							 '''||TRIM(V_TMP_TIPO_DATA(2))||''', 
							 '''||TRIM(V_TMP_TIPO_DATA(2))||''',
		            		 ''HREOS-17848'', SYSDATE, 0, '''||TRIM(V_TMP_TIPO_DATA(3))||'''
		                    FROM DUAL';
		                    
		      DBMS_OUTPUT.PUT_LINE(V_MSQL);
	                    
		  EXECUTE IMMEDIATE V_MSQL;
		 --END IF;
	 END LOOP;
	  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS Añadidos CORRECTAMENTE');

	  COMMIT;

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

EXIT;

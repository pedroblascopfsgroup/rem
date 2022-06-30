--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20220520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17848
--## PRODUCTO=NO
--## Finalidad: Inserción nuevos registros en la tabla WLM_WHITE_LIST_MATRICULAS.
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
    V_FUN VARCHAR2(30 CHAR):= 'FUN_VER_DOCUMENTOS_IDENTIDAD';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- FUN_FUNCION	--CODIGO    --TIPO DOC              
        T_TIPO_DATA('0865', 'DNI'),          
        T_TIPO_DATA('0866', 'NIE'),
        T_TIPO_DATA('0867', 'TARJETA DE RESIDENTE'),
        T_TIPO_DATA('0868', 'PASAPORTE'),
        T_TIPO_DATA('0869', 'DNI PAIS EXTRANJERO'),
        T_TIPO_DATA('0870', 'TJ IDENTIFICACION DIPLOMATICA'),
        T_TIPO_DATA('0871', 'MENOR'),
        T_TIPO_DATA('0872', 'OTROS PERSONA FISICA'),
        T_TIPO_DATA('0873', 'OTROS PERSONA JURIDICA'),
        T_TIPO_DATA('0874', 'IDENT BANCO DE ESPAÑA'),
        T_TIPO_DATA('0875', 'NIE'),
        T_TIPO_DATA('0876', 'NIF PAIS ORIGEN'),
        T_TIPO_DATA('0877', 'OTRO')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
     
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
	
	      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	    	DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos Dato '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	      --Comprobamos el dato a insertar
	      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.WLM_WHITE_LIST_MATRICULAS 
				WHERE DD_TDO_ID = (select DD_TDO_ID from '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD where DD_TDO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0)
			 	AND FUN_ID = (select FUN_ID from '||V_ESQUEMA_M||'.FUN_FUNCIONES where FUN_DESCRIPCION = '''||V_FUN||''' AND BORRADO = 0) AND BORRADO = 0';
	         
			 DBMS_OUTPUT.PUT_LINE(V_SQL);
	      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	      
	      --Si existe lo modificamos
	      IF V_NUM_TABLAS > 0 THEN				
	      
	        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' Insertado ANTERIORMENTE');
	       
	      --Si no existe, lo insertamos   
	      ELSE
			 DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO');
		   	 V_MSQL := '  INSERT INTO  '||V_ESQUEMA||'.WLM_WHITE_LIST_MATRICULAS (WLM_ID, FUN_ID, DD_TDO_ID, USUARIOCREAR, FECHACREAR, BORRADO)
		                    SELECT '||V_ESQUEMA||'.S_WLM_WHITE_LIST_MATRICULAS.NEXTVAL,
		                    (select FUN_ID from '||V_ESQUEMA_M||'.FUN_FUNCIONES where FUN_DESCRIPCION = '''||V_FUN||'''),
							(select DD_TDO_ID from '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD where DD_TDO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
		            		 ''HREOS-17848'', SYSDATE, 0
		                    FROM DUAL';
		                    
		      DBMS_OUTPUT.PUT_LINE(V_MSQL);
	                    
		  EXECUTE IMMEDIATE V_MSQL;
		 END IF;
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

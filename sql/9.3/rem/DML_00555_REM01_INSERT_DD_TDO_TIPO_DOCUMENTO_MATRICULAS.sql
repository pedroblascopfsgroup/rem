--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20210219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13072
--## PRODUCTO=NO
--## Finalidad: Inserción nuevos registros en la tabla DD_TDO_TIPO_DOC_ENTIDAD.Este dml no actualiza y obtiene los datos tal cual.
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
    V_PERFIL VARCHAR2(25 CHAR):= 'CARTERA_BBVA';
    V_TIPOENTIDAD VARCHAR2(25 CHAR):= 'ACT';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- MATRICULA  			      PERFIL              
        T_TIPO_DATA('AI-05-FOTO-01','840', 'Fotografía estado / avería'),          
        T_TIPO_DATA('AI-05-CERJ-85','840', 'Parte de visita'),
        T_TIPO_DATA('AI-04-TASA-29' ,'841', 'Informe de ilocalización del activo'),
        T_TIPO_DATA('AI-03-ESIN-BZ' ,'842', 'Informe de Siniestros'),
        T_TIPO_DATA('AI-02-CNCV-40' ,'843', 'Posesión activo: documento privado de entrega'),
        T_TIPO_DATA('AI-02-CERJ-AR' ,'844', 'Justificante envío llaves API'),
        T_TIPO_DATA('AI-02-CERJ-AQ' ,'845', 'Justificante envío llaves central'),
        T_TIPO_DATA('AI-02-CERJ-43' ,'846', 'Recibí entrega llaves'),
        T_TIPO_DATA('AI-01-FACT-10' ,'847', 'Otro gasto'),
        T_TIPO_DATA('AI-01-ESIN-BR' ,'848', 'Informe Ocupacional')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
     
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
	
	      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	    	DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos Dato '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	      --Comprobamos el dato a insertar
	      V_SQL :=   'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD WHERE DD_TDO_MATRICULA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
			 AND dd_Ted_id = (select dd_Ted_id from '||V_ESQUEMA||'.DD_TED_TIP_ENTIDAD_DOC where dd_ted_codigo = '''||V_TIPOENTIDAD||''')';
	         
			 DBMS_OUTPUT.PUT_LINE(V_SQL);
	      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	      
	      
	      --Si existe lo modificamos
	      IF V_NUM_TABLAS > 0 THEN				
	      
	        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Insertado ANTERIORMENTE');
	        
	      --Si no existe, lo insertamos   
	      ELSE
			 DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO');
		   	 V_MSQL := '  INSERT INTO  '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD (DD_TDO_ID, DD_TED_ID, DD_TDO_CODIGO, DD_TDO_DESCRIPCION, DD_TDO_DESCRIPCION_LARGA, DD_TDO_MATRICULA, USUARIOCREAR, FECHACREAR, BORRADO)
		                    SELECT '||V_ESQUEMA||'.S_DD_TDO_TIPO_DOC_ENTIDAD.NEXTVAL,
		                     (select dd_Ted_id from '||V_ESQUEMA||'.DD_TED_TIP_ENTIDAD_DOC where dd_ted_codigo = '''||V_TIPOENTIDAD||'''), 0,
							 '''||TRIM(V_TMP_TIPO_DATA(3))||''', 
							 '''||TRIM(V_TMP_TIPO_DATA(3))||''',
		                     '''||TRIM(V_TMP_TIPO_DATA(1))||''', 
		            		 ''HREOS-13072'', SYSDATE, 0
		                    FROM DUAL';
		                    
		      DBMS_OUTPUT.PUT_LINE(V_MSQL);
	                    
		  EXECUTE IMMEDIATE V_MSQL;
		 END IF;
	 END LOOP;
	  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS Añadidos CORRECTAMENTE');
        
        
    COMMIT;
		V_MSQL := '  UPDATE  '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD DOC2
					SET DD_TDO_CODIGO = (SELECT LPAD(DD_TDO_ID ,4,0) FROM '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD DOC1 WHERE DOC1.DD_TDO_ID = DOC2.DD_TDO_ID)';
					DBMS_OUTPUT.PUT_LINE(V_MSQL);
	  EXECUTE IMMEDIATE V_MSQL;
	  
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

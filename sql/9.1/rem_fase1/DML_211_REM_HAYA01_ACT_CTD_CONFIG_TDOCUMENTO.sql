--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en PEF_PERFILES los datos añadidos en T_ARRAY_DATA
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
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
     T_FUNCION('06', 'GADM', '13'), -- Nota simple
     T_FUNCION('08', 'GADM', '15'), -- VPO Solicitud autorización
     T_FUNCION('10', 'GADM', '17'), -- VPO Solicitud Importe
     T_FUNCION('11', 'GACT', '18'), -- CEE
     T_FUNCION('12', 'GACT', '19'), -- LPO
     T_FUNCION('13', 'GADM', '20'), -- Cédula de habitabilidad
     T_FUNCION('14', 'GACT', '21'), -- CFO
     T_FUNCION('15', 'GACT', '22'), -- Boletín de agua
     T_FUNCION('16', 'GACT', '23'), -- Boletín de electricidad
     T_FUNCION('17', 'GACT', '24')  -- Boletín de gas
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ACT_CTD_CONFIG_TDOCUMENTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_CTD_CONFIG_TDOCUMENTO] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CTD_CONFIG_TDOCUMENTO WHERE DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe el documento
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ACT_CTD_CONFIG_TDOCUMENTO...no se modifica nada.');
				
			ELSE
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.ACT_CTD_CONFIG_TDOCUMENTO' ||
							' (DD_TPD_ID, DD_TGE_ID, DD_STR_ID)' || 
							' VALUES ((SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = '''||V_TMP_FUNCION(1)||'''), '||
							' (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_TMP_FUNCION(2)||'''), '||
							' (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||V_TMP_FUNCION(3)||'''))';
		    	
				EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.ZON_PEF_USU insertados correctamente.');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PEF_PERFILES ACTUALIZADO CORRECTAMENTE ');
   

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
--/*
--##########################################
--## AUTOR=ALBERTO RAMÍREZ LOSILLA
--## FECHA_CREACION=20150610
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=FASE-1376
--## PRODUCTO=SI
--## Finalidad: ACTUALIZAR LOS VALORES DEL DICCIONARIO DD_TVI_TIPO_VIA
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
    V_ID NUMBER(16);

    --Valores en DD_TVI_TIPO_VIA
    TYPE T_TIPO_TVI IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TVI IS TABLE OF T_TIPO_TVI;
    V_TIPO_TVI T_ARRAY_TVI := T_ARRAY_TVI(
      T_TIPO_TVI('AV', 'AVENIDA', 'AVENIDA'),
      T_TIPO_TVI('BD', 'BOULEVARD', 'BOULEVARD'),
      T_TIPO_TVI('CA', 'CAMINO', 'CAMINO'),
      T_TIPO_TVI('CJ', 'CALLEJON', 'CALLEJON'),
      T_TIPO_TVI('CL', 'CALLE', 'CALLE'),
      T_TIPO_TVI('CN', 'COSTANILLA', 'COSTANILLA'),
      T_TIPO_TVI('CO', 'COLONIA', 'COLONIA'),
      T_TIPO_TVI('CR', 'CARRETERA', 'CARRETERA'),
      T_TIPO_TVI('CT', 'CARRETERA', 'CARRETERA'),
      T_TIPO_TVI('CU', 'CUESTA', 'CUESTA'),
      T_TIPO_TVI('CV', 'CAMINO VIEJO', 'CAMINO VIEJO'),
      T_TIPO_TVI('ET', 'ESTACION', 'ESTACION'),
      T_TIPO_TVI('GL', 'GLORIETA', 'GLORIETA'),
      T_TIPO_TVI('LU', 'LUGAR', 'LUGAR'),
      T_TIPO_TVI('PA', 'PASEO', 'PASEO'),
      T_TIPO_TVI('PB', 'POBLADO', 'POBLADO'),
      T_TIPO_TVI('PG', 'POLIGONO', 'POLIGONO'),
      T_TIPO_TVI('PJ', 'PASAJE', 'PASAJE'),
      T_TIPO_TVI('PL', 'PLAZA', 'PLAZA'),
      T_TIPO_TVI('PR', 'PROLONGACION', 'PROLONGACION'),
      T_TIPO_TVI('RA', 'RAMBLA', 'RAMBLA'),
      T_TIPO_TVI('RO', 'RONDA', 'RONDA'),
      T_TIPO_TVI('TV', 'TRAVESIA', 'TRAVESIA'),
      T_TIPO_TVI('UB', 'URBANIZACION', 'URBANIZACION')
    ); 
    V_TMP_TIPO_TVI T_TIPO_TVI;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	-- Borramos los valores que no nos interesan en DD_TVI_TIPO_VIA
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS LOS REGISTROS EN DD_TVI_TIPO_VIA QUE NO NOS INTERESAN ');
	execute immediate 'DELETE FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA tvi 
	WHERE tvi.DD_TVI_CODIGO not in (''AV'',''BD'',''CA'',''CJ'',''CL'',''CN'',''CO'',''CR'',''CT'',''CU'',''CV'',''ET'',''GL'',''LU'',''PA'',''PB'',''PG'',''PJ'',''PL'',''PR'',''RA'',''RO'',''TV'',''UB'')';
	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS BORRADOS EN DD_TVI_TIPO_VIA ');
    
    -- LOOP para insertar/modificar los valores en DD_TVI_TIPO_VIA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION/MODIFICACION EN DD_TVI_TIPO_VIA] ');
    FOR I IN V_TIPO_TVI.FIRST .. V_TIPO_TVI.LAST
      LOOP
      
        V_TMP_TIPO_TVI := V_TIPO_TVI(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA WHERE DD_TVI_CODIGO = '''||TRIM(V_TMP_TIPO_TVI(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_TVI(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.DD_TVI_TIPO_VIA '||
                    'SET DD_TVI_DESCRIPCION = '''||TRIM(V_TMP_TIPO_TVI(2))||''''|| 
					', DD_TVI_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_TVI(3))||''''||
					', USUARIOMODIFICAR = ''FASE-1376'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TVI_CODIGO = '''||TRIM(V_TMP_TIPO_TVI(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_TVI(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_TVI_TIPO_VIA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_TVI_TIPO_VIA (' ||
                      'DD_TVI_ID, DD_TVI_CODIGO, DD_TVI_DESCRIPCION, DD_TVI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_TVI(1)||''','''||TRIM(V_TMP_TIPO_TVI(2))||''','''||TRIM(V_TMP_TIPO_TVI(3))||''', 0, ''FASE-1376'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TVI_TIPO_VIA ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
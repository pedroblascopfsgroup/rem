--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DML para rellenar los datos de los diccionarios relacionados con SUB_SUBASTA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en DD_SGB_SOLVENCIA_GARANTIA_BIEN
    TYPE T_TIPO_SGB IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_SGB IS TABLE OF T_TIPO_SGB;
    V_TIPO_SGB T_ARRAY_SGB := T_ARRAY_SGB(
      T_TIPO_SGB('SOL', 'SOLVENCIA', 'SOLVENCIA'),
      T_TIPO_SGB('GAR', 'GARANTIA', 'GARANTIA'),
      T_TIPO_SGB('SIN', 'SIN RELACION', 'SIN RELACION')
    ); 
    V_TMP_TIPO_SGB T_TIPO_SGB;

BEGIN	
    -- LOOP Insertando valores en DD_SGB_SOLVENCIA_GARANTIA_BIEN
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Empezando a insertar datos en el diccionario');
    
    FOR I IN V_TIPO_SGB.FIRST .. V_TIPO_SGB.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SGB_BIEN.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_SGB := V_TIPO_SGB(I);
			
			V_SQL := 'SELECT COUNT(1) FROM DD_SGB_SOLVENCIA_GARANTIA_BIEN WHERE DD_SGB_CODIGO = '''||TRIM(V_TMP_TIPO_SGB(1))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			-- Si existe el dato
			IF V_NUM_TABLAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Ya existe el registro '''|| TRIM(V_TMP_TIPO_SGB(2))||'''');
			ELSE			
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN (' ||
						'DD_SGB_ID, DD_SGB_CODIGO, DD_SGB_DESCRIPCION, DD_SGB_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_SGB(1)||''','''||TRIM(V_TMP_TIPO_SGB(2))||''','''||TRIM(V_TMP_TIPO_SGB(3))||''','||
						'0, ''DML'',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_SGB(1)||''','''||TRIM(V_TMP_TIPO_SGB(2))||'''');			
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Datos del diccionario insertado');

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
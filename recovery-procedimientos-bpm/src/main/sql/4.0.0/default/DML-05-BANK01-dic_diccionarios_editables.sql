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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en DD_SGB_SOLVENCIA_GARANTIA_BIEN
    TYPE T_TIPO_DIE IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DIE IS TABLE OF T_TIPO_DIE;
    V_TIPO_DIE T_ARRAY_DIE := T_ARRAY_DIE(
      T_TIPO_DIE('DD_GES_GESTORIA','Diccionario de Gestorías.','','1','1')
    ); 
    V_TMP_TIPO_DIE T_TIPO_DIE;
BEGIN	
  
  -- LOOP Insertando valores en DIC_DICCIONARIOS_EDITABLES
  DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DIC_DICCIONARIOS_EDITABLES... Empezando a insertar datos en el diccionario');
    
	FOR I IN V_TIPO_DIE.FIRST .. V_TIPO_DIE.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_dic_diccionarios_editables.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_TIPO_DIE := V_TIPO_DIE(I);
			
			V_SQL := 'SELECT COUNT(1) FROM DIC_DICCIONARIOS_EDITABLES WHERE DIC_NBTABLA = '''||TRIM(V_TMP_TIPO_DIE(1))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DIC_DICCIONARIOS_EDITABLES... Ya existe en el listado este diccionario  '''|| TRIM(V_TMP_TIPO_DIE(2))||'''');
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DIC_DICCIONARIOS_EDITABLES (' ||
						'DIC_ID, DIC_NBTABLA, DIC_CODIGO,DIC_DESCRIPCION, DIC_DESCRIPCION_LARGA, DIC_EDICION,DIC_ADD,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TIPO_DIE(1)||''',(select max(to_number(dic_codigo))+1 from dic_diccionarios_editables),'''||TRIM(V_TMP_TIPO_DIE(2))||''','''||TRIM(V_TMP_TIPO_DIE(3))||''','''||TRIM(V_TMP_TIPO_DIE(4))||''','''||TRIM(V_TMP_TIPO_DIE(5))||''','||
						'0, ''DML'',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_DIE(1)||''','''||TRIM(V_TMP_TIPO_DIE(2))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA ||'.DIC_DICCIONARIOS_EDITABLES... Insertados datos en el diccionario');

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
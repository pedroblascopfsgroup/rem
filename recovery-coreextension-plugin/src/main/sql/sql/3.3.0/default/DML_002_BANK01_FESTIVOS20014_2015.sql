--/*
--##########################################
--## Author: Carlos Perez
--## Finalidad: DML para rellenar los festivos de 2014/2015
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
    --Insertando valores en FES_FESTIVOS
    TYPE T_FESTIVOS IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FESTIVOS IS TABLE OF T_FESTIVOS;
    V_FESTIVOS T_ARRAY_FESTIVOS := T_ARRAY_FESTIVOS(
		T_FESTIVOS( 2014, 1, 1, 1),
		T_FESTIVOS( 2014, 1, 6, 6),   
		T_FESTIVOS( 2014, 4, 18, 18),
		T_FESTIVOS( 2014, 5, 1, 1),
		T_FESTIVOS( 2014, 8, 15, 15),   
		T_FESTIVOS( 2014, 10, 12, 12),
		T_FESTIVOS( 2014, 11, 1, 1),
		T_FESTIVOS( 2014, 12, 6, 6),
		T_FESTIVOS( 2014, 12, 8, 8),
		T_FESTIVOS( 2014, 12, 25, 25),
		T_FESTIVOS( 2015, 1, 1, 1),
		T_FESTIVOS( 2015, 1, 6, 6),   
		T_FESTIVOS( 2015, 4, 6, 6),
		T_FESTIVOS( 2015, 5, 1, 1),
		T_FESTIVOS( 2015, 8, 15, 15),   
		T_FESTIVOS( 2015, 10, 12, 12),
		T_FESTIVOS( 2015, 11, 1, 1),
		T_FESTIVOS( 2015, 12, 6, 6),
		T_FESTIVOS( 2015, 12, 8, 8),
		T_FESTIVOS( 2015, 12, 25, 25)
    ); 
    V_TMP_FESTIVOS T_FESTIVOS;      
    
BEGIN	
    -- LOOP Insertando valores en FES_FESTIVOS
    DBMS_OUTPUT.PUT_LINE(''||V_ESQUEMA||'.FES_FESTIVOS... Empezando a insertar datos en el diccionario');
    FOR I IN V_FESTIVOS.FIRST .. V_FESTIVOS.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_FES_FESTIVOS.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_FESTIVOS := V_FESTIVOS(I);
         -- Comprobamos si existe el dato
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FES_FESTIVOS WHERE FES_YEAR = '''||TRIM(V_TMP_FESTIVOS(1))||''''||
                  ' AND FES_MONTH = '''||TRIM(V_TMP_FESTIVOS(2))||''''||
                  ' AND FES_DAY_START = '''||TRIM(V_TMP_FESTIVOS(3))||''''||
                  ' AND FES_DAY_END = '''||TRIM(V_TMP_FESTIVOS(4))||'''';
      	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FES_FESTIVOS... Ya existe el ese dia festivo: '''|| TRIM(V_TMP_FESTIVOS(1)) ||'''/'''|| TRIM(V_TMP_FESTIVOS(2)) ||'''/'''|| TRIM(V_TMP_FESTIVOS(3)) ||'''/'''|| TRIM(V_TMP_FESTIVOS(4)) ||'''');
        ELSE 
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.FES_FESTIVOS (' ||
                    'FES_ID, FES_YEAR, FES_MONTH, FES_DAY_START, FES_DAY_END, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                    'SELECT '|| V_ENTIDAD_ID || ','||V_TMP_FESTIVOS(1)||','||V_TMP_FESTIVOS(2)||','||V_TMP_FESTIVOS(3)||','||V_TMP_FESTIVOS(4)||','||
                    '0,''DML'',SYSDATE,0 FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FESTIVOS(1)||''','''||V_TMP_FESTIVOS(2)||''','''||V_TMP_FESTIVOS(3)||''','''||V_TMP_FESTIVOS(4)||'''');			
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.FES_FESTIVOS... Datos del diccionario insertado');
    
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
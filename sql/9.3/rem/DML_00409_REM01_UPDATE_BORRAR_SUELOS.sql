--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210326
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13596
--## PRODUCTO=NO
--##
--## Finalidad: Borrado logico de registros creados en un Item concreto
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_USUARIO VARCHAR2(20 CHAR) := 'HREOS-13596';
    V_USUARIO_CREADOR VARCHAR2(20 CHAR) := 'HREOS-12486';
    V_NUM NUMBER(16); -- Vble. auxiliar
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- Nombre de la tabla
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('DD_TTR_TIPO_TRABAJO'),
        T_TIPO_DATA('DD_STR_SUBTIPO_TRABAJO'),
        T_TIPO_DATA('DD_TPR_TIPO_PROVEEDOR')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
BEGIN
	
	
FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
 LOOP

 V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	 -- Verificar si la tabla ya existe
  	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TMP_TIPO_DATA(1)||''' and owner = '''||V_ESQUEMA||'''';
  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  	IF V_NUM_TABLAS = 1 THEN
  	
  	
                DBMS_OUTPUT.PUT_LINE('Borrado logico de entradas en '||V_TMP_TIPO_DATA(1)||' creadas en '||V_USUARIO_CREADOR );
        

                
                        
                        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(1)||' 
		                 WHERE USUARIOCREAR = '''||V_USUARIO_CREADOR||'''';

    	        EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    	        IF V_NUM > 0 THEN

                        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(1)||' SET BORRADO = 1, 
					    USUARIOBORRAR =  '''||V_USUARIO||''', 
					    FECHABORRAR = SYSDATE 
				        WHERE USUARIOCREAR = '''||V_USUARIO_CREADOR||'''';
                
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('Borrados '||V_NUM||' registros en la tabla '||V_TMP_TIPO_DATA(1));


                COMMIT;

                ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] NO HAY ENTRADAS CREADAS POR '||V_USUARIO_CREADOR||' EN LA TABLA '||V_TMP_TIPO_DATA(1));

                END IF;
                
                

    	
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO][FIN] NO EXISTE LA TABLA '||V_TMP_TIPO_DATA(1));
	END IF;
	
END LOOP;
	
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
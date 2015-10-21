--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150603
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1-rc03-hy
--## INCIDENCIA_LINK=HR-596
--## PRODUCTO=NO
--##
--## Finalidad: Asignar usuarios al nuevo perfil FPFSRFUNSUPER
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION(
      	/*pef_id..................:*/ 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRFUNCSUP''',
      	/*usu_id..................:*/ 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''UNICON''',
      	/*zon_id..................:*/ 'SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'''
      )
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    -- LOOP Insertando valores en ZON_PEF_USU
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.ZON_PEF_USU... Empezando a insertar datos');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ZON_PEF_USU.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID = ('||V_TMP_FUNCION(1)|| 
					') AND USU_ID = ('||V_TMP_FUNCION(2)||') AND ZON_ID = ('||V_TMP_FUNCION(3)||')';
			DBMS_OUTPUT.PUT_LINE(V_SQL);
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ZON_PEF_USU... Ya existe el registro');
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ZON_PEF_USU (' ||
						'ZPU_ID, ZON_ID, PEF_ID, USU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, ZPU_FECHA_EXTRACCION)' ||
						'SELECT '|| V_ENTIDAD_ID || ',('||V_TMP_FUNCION(3)||'),('||V_TMP_FUNCION(1)||'),('||V_TMP_FUNCION(2)||'),'||
						'0, ''DML'',SYSDATE,0, SYSDATE FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUNCION(1)||''','''||V_TMP_FUNCION(2)||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.ZON_PEF_USU... Datos insertados');

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
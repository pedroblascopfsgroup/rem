--/*
--##########################################
--## AUTOR=Carlos Perez
--## FECHA_CREACION=20151223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=-
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en PEF_PERFILES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('Acceso a toda la operativa de configuración','Administrador','ADM_ADMINISTRADOR','0'),
      T_FUNCION('Acceso a las funcionalidades de oficina','Oficina','OFI_OFICINA','0'),
      T_FUNCION('Acceso a las funcionalidades de Gestor de riesgos','Gestor de riesgos','GES_RIESGOS','0'),
      T_FUNCION('Acceso a las funcionalidades de Director de riesgos','Director de riesgos','DIR_RIESGOS','0'),
      T_FUNCION('Acceso a las funcionalidades de Servicios centrales','Servicios centrales','SER_CENTRALES','0'),
      T_FUNCION('Acceso a las funcionalidades de supervisión de los asuntos judiciales','Supervisor','SUP_SUPERVISOR','0'),
      T_FUNCION('Acceso a las funcionalidades propias de los gestores internos judiciales','Gestor Interno','GEST_INTERNO','0'),
      T_FUNCION('Acceso a las funcionalidades propias de los gestores externos judiciales','Gestor Externo','GEST_EXTERNO','0'),
      T_FUNCION('Acceso a las funcionalidades de BI','Acceso BI','ACC_BI','0'),
      T_FUNCION('Acceso a las funcionalidades de consulta de toda la herramienta','Consulta','CON_CONSULTA','0'),
      T_FUNCION('Acceso a las funcionalidades propias del precontencioso','Precontencioso','PRECONTENCIOSO','0'),
      T_FUNCION('Acceso a las funcionalidades propias de la dirección territorial de riesgos','Director territorial riesgos','DIR_TERRITORIAL_RIESGOS','0'),
      T_FUNCION('Acceso a las funcionalidades propias de la dirección territorial','Director territorial','DIR_TERRITORIAL','0'),
      T_FUNCION('Acceso a las funcionalidades propias de recursos humanos','RRHH','RRHH','0'),
      T_FUNCION('','Perfil pendiente de definir (0)','0','0')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    -- LOOP Insertando valores en PEF_PERFILES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.PEF_PERFILES... Empezando a insertar datos en el diccionario');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_PEF_PERFILES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(3))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PEF_PERFILES... Ya existe el perfil '''|| TRIM(V_TMP_FUNCION(3))||'''');
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.PEF_PERFILES (' ||
						'PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE)' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||''','||
						'0, ''DML'',SYSDATE,0,'''||V_TMP_FUNCION(3)||''','''||TRIM(V_TMP_FUNCION(4))||''',''EXTPerfil'' FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUNCION(2)||''','''||TRIM(V_TMP_FUNCION(3))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.PEF_PERFILES... Datos del diccionario insertado');

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
  	
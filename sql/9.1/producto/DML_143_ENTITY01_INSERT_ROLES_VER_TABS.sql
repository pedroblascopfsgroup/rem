--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-671
--## PRODUCTO=SI
--## Finalidad: DML
--## 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

	-- Nuevos roles para ver pestañas de ASUNTOS, ACTUACION (PRC) Y BIENES. Se aplicaran a todos los perfiles, excepto
	-- para uno nuevo 'Procuradores' de CAJAMAR y HAYA-CAJAMAR, que solo podra ver unas pestañas concretas.

    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    TYPE ROL_ARRAY IS VARRAY(12) OF VARCHAR2(128);
    V_FUNCION_DESC_LARGA ROL_ARRAY := ROL_ARRAY(
    	'Permite ver la pestaña Títulos de un asunto', 'Permite ver la pestaña Acuerdos de un asunto',
      	'Permite ver la pestaña Adjuntos de un asunto','Permite ver la pestaña Convenios de un asunto',
      	'Permite ver la pestaña Fase común de un asunto', 'Permite ver la pestaña Adjuntos de un procedimiento',
      	'Permite ver la pestaña Decisiones de un procedimiento','Permite ver la pestaña Tareas de un procedimiento',
      	'Permite ver la pestaña Contratos de un procedimiento', 'Permite ver la pestaña Procedimientos de un bien',
      	'Permite ver la pestaña Datos entidad de un bien', 'Permite ver la pestaña Relaciones de un bien'
    );
    V_FUNCION_ROL ROL_ARRAY := ROL_ARRAY(
     	'TAB_ASUNTO_TITULOS', 'TAB_ASUNTO_ACUERDOS', 'TAB_ASUNTO_ADJUNTOS',
      	'TAB_ASUNTO_CONVENIOS','TAB_ASUNTO_FASECOMUN', 'TAB_PRC_ADJUNTO',
      	'TAB_PRC_DECISION', 'TAB_PRC_TAREAS', 'TAB_PRC_CONTRATO',
      	'TAB_BIEN_PROCEDIMIENTOS', 'TAB_BIEN_DATOSENTIDAD', 'TAB_BIEN_RELACIONES'
    );
    

BEGIN    
    -- LOOP Insertando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Empezando a insertar funciones');
    
    FOR I IN V_FUNCION_DESC_LARGA.FIRST .. V_FUNCION_DESC_LARGA.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_FUNCION_ROL(I))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe la funcion '''|| TRIM(V_FUNCION_ROL(I))||'''');
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (' ||
						'FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_FUNCION_DESC_LARGA(I)||''','''||TRIM(V_FUNCION_ROL(I))||''','||
						'0, ''PROD-671'',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_FUNCION_DESC_LARGA(I)||''','''||TRIM(V_FUNCION_ROL(I))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.FUN_FUNCIONES... nuevas funciones insertadas');

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
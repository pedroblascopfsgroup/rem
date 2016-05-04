--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20160422
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-1253
--## PRODUCTO=SI
--##
--## Finalidad: Inserta las nuevas funciones.
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
 
    --Valores en FUN_FUNCIONES
    TYPE T_FUN_FUNCIONES IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUN IS TABLE OF T_FUN_FUNCIONES;
    V_FUN_FUNCIONES T_ARRAY_FUN := T_ARRAY_FUN(
	      T_FUN_FUNCIONES('Función que muestra Boton Alta Direcciones del Asunto', 'ROLE_PUEDE_VER_ROLE_BOTON_ALTA_DIRECCIONES', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de clientes de la pestaña adjuntos del cliente', 'ROLE_PUEDE_VER_BOTONES_ADJUNTOS_PERSONAS', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de contratos de la pestaña adjuntos del contrato', 'ROLE_PUEDE_VER_BOTONES_ADJUNTOS_CONTRATOS', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra el boton añadir recurso de la pestaña recursos del procedimiento', 'ROLE_PUEDE_VER_BOTON_RECURSO_NUEVO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra el boton modificar de la pestaña analisis de contato del asunto', 'ROLE_PUEDE_VER_BOTON_MODIFICAR_ANALISIS_ASUNTO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de asuntos de la pestaña adjuntos del asunto', 'ROLE_PUEDE_VER_BOTONES_ASUNTO_ADJUNTO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de personas de la pestaña adjuntos del asunto', 'ROLE_PUEDE_VER_BOTONES_ASUNTO_ADJUNTO_PERSONAS', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de expedientes de la pestaña adjuntos del asunto', 'ROLE_PUEDE_VER_BOTONES_ASUNTO_ADJUNTO_EXPEDIENTES', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de contratos de la pestaña adjuntos del asunto', 'ROLE_PUEDE_VER_BOTONES_ASUNTO_ADJUNTO_CONTRATOS', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de asuntos de la pestaña adjuntos del asunto', 'ROLE_PUEDE_VER_BOTONES_ASUNTO_TAB_ADJUNTO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de personas de la pestaña adjuntos del asunto', 'ROLE_PUEDE_VER_BOTONES_ASUNTO_TAB_ADJUNTO_PERSONAS', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
		  T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de expedientes de la pestaña adjuntos del asunto', 'ROLE_PUEDE_VER_BOTONES_ASUNTO_TAB_ADJUNTO_EXPE', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),	      
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de contratos de la pestaña adjuntos del asunto', 'ROLE_PUEDE_VER_BOTONES_ASUNTO_TAB_ADJUNTO_CONTRATO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que comprueba si la tarea es de tipo COMUNICACION y es dueño o destinatario de la misma', 'ROLE_PUEDE_VER_TAREA_TIPO_COMUNICACION', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de procedimientos de la pestaña adjuntos del procedimiento', 'ROLE_PUEDE_VER_BOTONES_PROCEDIMIENTO_ADJUNTOS', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de personas de la pestaña adjuntos del procedimiento', 'ROLE_PUEDE_VER_BOTONES_PROCEDIMIENTO_ADJUNTOS_PER', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de expedientes de la pestaña adjuntos del procedimiento', 'ROLE_PUEDE_VER_BOTONES_PROCEDIMIENTO_ADJUNTOS_EXPE', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones del grid de adjuntos de contratos de la pestaña adjuntos del procedimiento', 'ROLE_PUEDE_VER_BOTONES_PROCEDIMIENTO_ADJUNTOS_CNT', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones de la pestaña decisiones del procedimiento', 'ROLE_PUEDE_VER_BOTONES_DECISIONES', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones de la pestaña tareas del procedimiento', 'ROLE_PUEDE_VER_BOTONES_TAREAS_PROCEDIMIENTO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra el boton guardar y revisado de la pestaña recursos', 'ROLE_PUEDE_VER_BOTONES_RECURSOS_GUARDAR_REVISADO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra el boton editar la revision de cargas de la pestaña de cargas del bien', 'ROLE_PUEDE_VER_BOTON_EDITAR_REVISION_CARGA', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra el boton editar la propuesta de cancelacion de la carga de la pestaña de cargas del bien', 'ROLE_PUEDE_VER_BOTON_EDITAR_PROPUESTA_CANCEL_CARGA', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones de la pestaña de embargos', 'ROLE_PUEDE_VER_BOTONES_EMBARGO_PROCEDIMIENTO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones de agregar y excluir bienes y lotes', 'ROLE_PUEDE_VER_BOTONES_SUBASTA_BIENES_LOTES', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra el boton acciones de la pestaña subastas', 'ROLE_PUEDE_VER_BOTONES_SUBASTA_ACCIONES', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra el boton guardar cuando se quiere añadir un convenio', 'ROLE_PUEDE_VER_AGREGAR_CONVENIO_GUARDAR', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra el boton guardar cuando se edita un convenio', 'ROLE_PUEDE_VER_EDITAR_CONVENIO_GUARDAR', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones de concurso de la pestaña convenio', 'ROLE_PUEDE_VER_BOTONES_CONCURSO_CONVENIO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones de credito de la pestaña tareas del procurador', 'ROLE_PUEDE_VER_BOTONES_CREDITO', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0),
	      T_FUN_FUNCIONES('Función que muestra los botones de la pestaña tareas del procurador', 'ROLE_PUEDE_VER_BOTONES_TAREAS_PROCURADORES', 0, 'PR-1253',SYSDATE,NULL,NULL,NULL,NULL,0)
      );   
    V_TMP_FUN_FUNCIONES T_FUN_FUNCIONES;
    
    
    PEF_ID VARCHAR2(30 CHAR);
    
    TABLES_CURSOR SYS_REFCURSOR;
    
    TYPE T_TIPO_COLUMN IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_COLUMN IS TABLE OF T_TIPO_COLUMN;
    V_TIPO_COLUMN T_ARRAY_COLUMN := T_ARRAY_COLUMN(   
      T_TIPO_COLUMN('PEF_ID')
     );
     V_TMP_TIPO_COLUMN T_TIPO_COLUMN;

BEGIN	

      -- LOOP Insertando valores en FUN_FUNCIONES ------------------------------------------------------------------------
      
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Empezando a insertar datos en FUN_FUNCIONES');
    FOR I IN V_FUN_FUNCIONES.FIRST .. V_FUN_FUNCIONES.LAST
      LOOP
        V_TMP_FUN_FUNCIONES := V_FUN_FUNCIONES(I);
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUN_FUNCIONES(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe el FUN_FUNCIONES '''|| TRIM(V_TMP_FUN_FUNCIONES(2)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (' ||
                      'FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)' ||
                      'SELECT '|| V_ENTIDAD_ID || ', '''||V_TMP_FUN_FUNCIONES(1)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(2)||''', '''||V_TMP_FUN_FUNCIONES(3)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(4)||''', '''||V_TMP_FUN_FUNCIONES(5)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(6)||''', '''||V_TMP_FUN_FUNCIONES(7)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(8)||''', '''||V_TMP_FUN_FUNCIONES(9)||''''||
					  ','''||V_TMP_FUN_FUNCIONES(10)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUN_FUNCIONES(2)||'''');
          EXECUTE IMMEDIATE V_MSQL;          
          
          FOR I IN V_TIPO_COLUMN.FIRST .. V_TIPO_COLUMN.LAST
		      LOOP
		        V_TMP_TIPO_COLUMN := V_TIPO_COLUMN(I);
				V_NUM_TABLAS := 0;
			
		        OPEN TABLES_CURSOR FOR 'SELECT DISTINCT PEF_ID FROM '||V_ESQUEMA||'.FUN_PEF MINUS SELECT DISTINCT PEF_ID FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''SOLO_CONSULTA'')';

		 		LOOP
		 			FETCH TABLES_CURSOR INTO PEF_ID;
		 			EXIT WHEN TABLES_CURSOR%NOTFOUND;
		 			
		 			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FUN_ID,PEF_ID,FP_ID,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ('|| V_ENTIDAD_ID ||', '||PEF_ID||', '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, ''PR-1253'',SYSDATE,''0'')';
					
		 			DBMS_OUTPUT.PUT_LINE('V_MSQL >>' || V_MSQL);
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
					V_NUM_TABLAS := V_NUM_TABLAS + 1;
					
				END LOOP;
				CLOSE TABLES_CURSOR;
				DBMS_OUTPUT.PUT_LINE('Modificados el tamanyo de los campos para las columnas ' ||V_TMP_TIPO_COLUMN(1)||' de '||V_NUM_TABLAS||' tablas.');
			END LOOP;
          
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.FUN_FUNCIONES... Datos de la función insertados');
    
    
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
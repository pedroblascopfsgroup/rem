--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20191210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8706
--## PRODUCTO=NO
--##
--## Finalidad: Script para Insertar los Tipos de Tareas para WS
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(30):= 'TCP_TAREA_CONFIG_PETICION';
    V_TEXT_TABLA_REL VARCHAR2(30):= 'TAP_TAREA_PROCEDIMIENTO';
    V_SQL_TAP_ID_T017 VARCHAR2(4000 CHAR);
    V_NUM_T017 NUMBER(16);
    V_NUM_T017_2 NUMBER(16);
    V_NUM_EXISTE_RESERVA NUMBER(16);
    V_NUM_EXISTE_VENTA NUMBER(16);
    V_SQL_TAP_ID_T017_CONF VARCHAR2(4000 CHAR);
    V_NUM_T017_CONF NUMBER(16);
    V_SQL_TAP_ID_T017_CONF_2 VARCHAR2(4000 CHAR);
    V_NUM_T017_CONF_2 NUMBER(16);
    
	
		
BEGIN	

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  -- Si existe la tabla seguimos con el INSERT
  IF V_NUM_TABLAS = 1 THEN 

  	V_SQL_TAP_ID_T017:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE TAP_CODIGO = ''T013_PBCReserva''';
	EXECUTE IMMEDIATE V_SQL_TAP_ID_T017 INTO V_NUM_T017;

	-- Si existe el TAP_CODIGO en la tabla hacemos el INSERT	
			IF V_NUM_T017 = 1 THEN  

				V_SQL_TAP_ID_T017_CONF:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE  TAP_CODIGO = ''T013_PBCReserva'')';
				EXECUTE IMMEDIATE V_SQL_TAP_ID_T017_CONF INTO V_NUM_T017_CONF;
				-- Si no existe el TAP_ID en la tabla hacemos el INSERT	
				IF V_NUM_T017_CONF = 0 THEN 
					EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
					       'TCP_ID, 
						TAP_ID,
						TCP_ACTIVADA, 
						USUARIOCREAR, 
						FECHACREAR,
						BORRADO,
						TCP_PERMITIDA) 
						VALUES ('||V_ESQUEMA||'.S_TCP_TAREA_CONFIG_PETICION.NEXTVAL, 
						(SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE  TAP_CODIGO = ''T013_PBCReserva''), 
						1,
						''HREOS-8706'', 
						SYSDATE,
						0,
 						1
						) '; 

					DBMS_OUTPUT.PUT_LINE('SE HA INSERTADO CORRECTAMENTE EL REGISTRO EN LA TABLA TCP_TAREA_CONFIG_PETICION');
				ELSE 
					EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET TCP_ACTIVADA = 1, USUARIOMODIFICAR = ''HREOS-8706'', FECHAMODIFICAR = SYSDATE, BORRADO = 0, TCP_PERMITIDA = 1 WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE  TAP_CODIGO = ''T013_PBCReserva'')';
				END IF;
				COMMIT;

			ELSE
				DBMS_OUTPUT.PUT_LINE('EL TAP_CODIGO T013_PBCReserva NO EXISTE EN LA TABLA TAP_TAREA_PROCEDIMIENTO ');
			END IF;

	ELSE		
	  DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA NO EXISTE. ');	
	END IF;
	
	
	      
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');

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

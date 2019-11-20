--/*
--##########################################
--## AUTOR=JOSE LUIS BARBA
--## FECHA_CREACION=20190602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6461
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
		V_SQL_TAP_ID_T004 VARCHAR2(4000 CHAR);
		V_NUM_T004 NUMBER(16);
		V_SQL_TAP_ID_T013 VARCHAR2(4000 CHAR);
		V_NUM_T013 NUMBER(16);
		V_CONST_T004 VARCHAR2(25 CHAR);
		
BEGIN	

  
	
  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  -- Si existe la tabla seguimos con el INSERT
  IF V_NUM_TABLAS = 1 THEN 
		V_SQL_TAP_ID_T004:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE TAP_CODIGO = ''T004_ResultadoNoTarificada''';
		EXECUTE IMMEDIATE V_SQL_TAP_ID_T004 INTO V_NUM_T004;
	-- Si existe el TAP_CODIGO en la tabla hacemos el INSERT	
			IF V_NUM_T004 = 1 THEN  
					EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
						'TCP_ID, 
						TAP_ID, 
						USUARIOCREAR, 
						FECHACREAR) 
						VALUES ('||V_ESQUEMA||'.S_TCP_TAREA_CONFIG_PETICION.NEXTVAL, 
						(SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE  TAP_CODIGO = ''T004_ResultadoNoTarificada''), 
						''HREOS-6461'', 
						SYSDATE 
						) '; 
			ELSE
				DBMS_OUTPUT.PUT_LINE('EL TAP_CODIGO T004_ResultadoTarificada YA EXISTE EN LA TABLA ');
			END IF;

			V_SQL_TAP_ID_T013:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE TAP_CODIGO = ''T013_PosicionamientoYFirma''';
			EXECUTE IMMEDIATE V_SQL_TAP_ID_T013 INTO V_NUM_T013;
			-- Si existe el TAP_CODIGO en la tabla hacemos el INSERT
			IF V_NUM_T013 = 1 THEN  
					EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
						'TCP_ID, 
						TAP_ID, 
						USUARIOCREAR, 
						FECHACREAR) 
						VALUES ('||V_ESQUEMA||'.S_TCP_TAREA_CONFIG_PETICION.NEXTVAL, 
						(SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE  TAP_CODIGO = ''T013_PosicionamientoYFirma''), 
						''HREOS-6461'', 
						SYSDATE 
						) '; 
				
					DBMS_OUTPUT.PUT_LINE('INSERT REALIZADO CORRECTAMENTE EN LA TABLA ');  
				ELSE
					DBMS_OUTPUT.PUT_LINE('EL TAP_CODIGO ''T013_ResolucionComite'' YA EXISTE EN LA TABLA ');
			END IF;
			
			V_SQL_TAP_ID_T013:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE TAP_CODIGO = ''T004_ResultadoTarificada''';
			EXECUTE IMMEDIATE V_SQL_TAP_ID_T013 INTO V_NUM_T013;
			-- Si existe el TAP_CODIGO en la tabla hacemos el INSERT
			IF V_NUM_T013 = 1 THEN  
					EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
						'TCP_ID, 
						TAP_ID, 
						USUARIOCREAR, 
						FECHACREAR) 
						VALUES ('||V_ESQUEMA||'.S_TCP_TAREA_CONFIG_PETICION.NEXTVAL, 
						(SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_REL||' WHERE  TAP_CODIGO = ''T004_ResultadoTarificada''), 
						''HREOS-6461'', 
						SYSDATE 
						) '; 
				
					DBMS_OUTPUT.PUT_LINE('INSERT REALIZADO CORRECTAMENTE EN LA TABLA ');  
				ELSE
					DBMS_OUTPUT.PUT_LINE('EL TAP_CODIGO ''T013_ResolucionComite'' YA EXISTE EN LA TABLA ');
			END IF;
	ELSE		
	  DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA NO EXISTE. ');	
	END IF;
	
	COMMIT;
	      
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
  	
--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=HR-1957
--## PRODUCTO=NO
--## Finalidad: DML agregar permisos usuarios
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); 	-- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); 	-- Vble. para validar la existencia de una tabla.     
   	PEF_ID NUMBER(16);			-- Vble. auxiliar para almacenar id del perfil.
    FUN_ID NUMBER(16);			-- Vble. auxiliar para almacenar id de la función.
    ZON_ID NUMBER(16);			-- Vble. auxiliar para almacenar id de la zona.
    USU_ID NUMBER(16);			-- Vble. auxiliar para almacenar id de usuario
    TYPE ARRAY_T IS TABLE OF NUMBER(16);
    A_USUARIOS ARRAY_T;			-- Vble. auxiliar para almacenar usuarios a modificar.
       
BEGIN

	-- Asignar PERFIL a USUARIOS (ZON_PEF_USU)
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' AND ZON_NUM_CENTRO = 00000850000';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS !=0 THEN
		V_SQL := 'SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' AND ZON_NUM_CENTRO = 00000850000';
		EXECUTE IMMEDIATE V_SQL INTO ZON_ID;
		
		
		-- Añadir perfil Editor de bienes.
		V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAGESTBIEN''';
		EXECUTE IMMEDIATE V_SQL INTO PEF_ID;
		
		V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME IN (''cgarciao'', ''econde'')';
		
		EXECUTE IMMEDIATE V_SQL BULK COLLECT INTO A_USUARIOS; 
		FOR I IN A_USUARIOS.FIRST .. A_USUARIOS.LAST
	      	LOOP
	      		USU_ID:= A_USUARIOS(I);
	      		
	      		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE ZON_ID='||ZON_ID||'AND PEF_ID='||PEF_ID||'AND USU_ID='||USU_ID;
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	      		
				IF V_NUM_TABLAS !=0 THEN
			    	DBMS_OUTPUT.PUT_LINE('[INFO] El perfil ya existe');
				ELSE
	        	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES (' || 
						ZON_ID || ',' ||PEF_ID || ',' || USU_ID || ',' ||V_ESQUEMA|| '.S_ZON_PEF_USU.NEXTVAL, 0,''DML'', SYSDATE, 0)';
				EXECUTE IMMEDIATE V_SQL;
				END IF;
	      	END LOOP;
	      	
		-- Añadir perfil acceso BI.    	
	    V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAACCBI''';
		EXECUTE IMMEDIATE V_SQL INTO PEF_ID;
		
		V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME IN (''isantiago'')';
		EXECUTE IMMEDIATE  V_SQL INTO USU_ID; 
		
		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE ZON_ID='||ZON_ID||'AND PEF_ID='||PEF_ID||'AND USU_ID='||USU_ID;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	      		
		IF V_NUM_TABLAS !=0 THEN
		   	DBMS_OUTPUT.PUT_LINE('[INFO] El perfil ya existe');
		ELSE
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES (' || 
						ZON_ID || ',' ||PEF_ID || ',' || USU_ID || ',' ||V_ESQUEMA|| '.S_ZON_PEF_USU.NEXTVAL, 0,''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_SQL;
		END IF;
	
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] No existe valor en ZON_ZONIFICACION, no se modifica nada.');
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');
	
EXCEPTION     
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE; 
END;
/
 
EXIT; 

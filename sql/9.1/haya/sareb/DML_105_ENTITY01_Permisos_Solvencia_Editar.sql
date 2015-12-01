--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.14-hy-rc01
--## INCIDENCIA_LINK=HR-1601
--## PRODUCTO=NO
--## Finalidad: DML para eliminar los perfiles con el permiso SOLVENCIA_EDITAR, crear un nuevo perfil y asignarle a los 
--## 			usuarios del grupo "Gestores de Admisión" ese permiso.
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
    V_MSQL VARCHAR2(4000 CHAR);
    V_SQL VARCHAR2(4000 CHAR); 	-- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); 	-- Vble. para validar la existencia de una tabla.     
   	PEF_ID NUMBER(16);			-- Vble. auxiliar para almacenar id del perfil.
    FUN_ID NUMBER(16);			-- Vble. auxiliar para almacenar id de la función.
    ZON_ID NUMBER(16);			-- Vble. auxiliar para almacenar id de la zona.
    USU_ID NUMBER(16);			-- Vble. auxiliar para almacenar id de usuario
    TYPE ARRAY_T IS TABLE OF NUMBER(16);
    A_USUARIOS ARRAY_T;			-- Vble. auxiliar para almacenar usuarios a modificar.
       
BEGIN

    -- Eliminar FUN_PEF
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF' ||
			  ' WHERE FUN_ID IN (SELECT FUN_ID FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''SOLVENCIA_EDITAR'') ';			  
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Funciones - Perfiles eliminados.');
    
    -- Crear PERFIL
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAGESTBIEN''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
	IF V_NUM_TABLAS !=0 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el valor en la tabla ' || V_ESQUEMA_M || '.PEF_PERFILES... no se modifica nada');
	ELSE		
		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.PEF_PERFILES (' ||
					'PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, PEF_CODIGO, PEF_ES_CARTERIZADO, DTYPE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
					' (S_PEF_PERFILES.NEXTVAL,''Editor de bienes'',''Editor de bienes'',''HAYAGESTBIEN'','||
					'0,''EXTPerfil'', 0, ''DML'',SYSDATE,0)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
	    EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] Perfil creado.');
	END IF;
	
    -- Añadir FUNCIÓN a PERFIL
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''SOLVENCIA_EDITAR''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAGESTBIEN''';
	EXECUTE IMMEDIATE V_SQL INTO PEF_ID;
	
	IF V_NUM_TABLAS != 1 THEN				
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe en valor en la tabla ' || V_ESQUEMA_M || '.FUN_FUNCIONES... no se modifica nada');
	ELSE
		V_SQL := 'SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''SOLVENCIA_EDITAR''';
		EXECUTE IMMEDIATE V_SQL INTO FUN_ID;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
			' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
			'  VALUES ('||FUN_ID||','||PEF_ID||','||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0)';
	    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Función - Perfil creado.');
    END IF;
    
    -- Asignar PERFIL a USUARIOS (ZON_PEF_USU)
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' AND ZON_NUM_CENTRO = 00000850000';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS !=0 THEN
		V_SQL := 'SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_COD = ''01'' AND ZON_NUM_CENTRO = 00000850000';
		EXECUTE IMMEDIATE V_SQL INTO ZON_ID;
		
		V_SQL := 'SELECT USU_ID_USUARIO FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS WHERE USU_ID_GRUPO IN(SELECT USU_ID FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS where USU_USERNAME = ''GADMIN'')';
		DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL BULK COLLECT INTO A_USUARIOS; 
		FOR I IN A_USUARIOS.FIRST .. A_USUARIOS.LAST
	      	LOOP
	      		USU_ID:= A_USUARIOS(I);
	        	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID,ZPU_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES (' || 
						ZON_ID || ',' ||PEF_ID || ',' || USU_ID || ',' ||V_ESQUEMA|| '.S_ZON_PEF_USU.NEXTVAL, 0,''DML'', SYSDATE, 0)';
				DBMS_OUTPUT.PUT_LINE(V_SQL);
				EXECUTE IMMEDIATE V_SQL;	
	      	END LOOP;
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

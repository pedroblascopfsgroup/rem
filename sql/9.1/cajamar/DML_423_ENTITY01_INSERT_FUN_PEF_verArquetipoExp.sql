--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=CMREC-2716
--## PRODUCTO=NO
--## Finalidad: DML para actualizar las instrucciones de algunas tareas
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

   
BEGIN
	 V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES  WHERE FUN_DESCRIPCION = ''ROLE_VER_ARQUETIPO_EXPEDIENTE'')';
	 EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	 
	 IF V_NUM_TABLAS > 0 THEN
	 	
	     V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR, BORRADO) SELECT '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, FUN_ID, PEF_ID, ''CMREC-2716'', SYSDATE, ''0'' FROM (SELECT FUN.FUN_ID, PEF.PEF_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN, '||V_ESQUEMA||'.PEF_PERFILES PEF WHERE FUN.FUN_DESCRIPCION = ''ROLE_VER_ARQUETIPO_EXPEDIENTE'' AND PEF.BORRADO = 0)';
	     DBMS_OUTPUT.PUT_LINE(V_MSQL);
	     EXECUTE IMMEDIATE V_MSQL;
		 DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado.');
	
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe la funcion deseada.');
	
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

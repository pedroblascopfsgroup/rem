--/*
--##########################################
--## AUTOR=Alberto b.
--## FECHA_CREACION=20151203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc17
--## INCIDENCIA_LINK= CMREC-1161
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Litigios
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.      
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GEST_INTERNO'')';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('No existe el perfil solicitado GEST_INTERNO');
	ELSE
		
		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GEST_INTERNO'') AND FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''TAB_ANALISISCONTRATOS'')';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS2;
		
		IF V_NUM_TABLAS2 > 0 THEN
		
			DBMS_OUTPUT.PUT_LINE('Ya existe el registro insertado');
		ELSE
		
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) SELECT '||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL, (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''GEST_INTERNO''),FUN_ID, ''CMREC-1161'',SYSDATE FROM (SELECT FUN.FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN WHERE FUN.FUN_DESCRIPCION IN (''TAB_ANALISISCONTRATOS''))';

        	EXECUTE IMMEDIATE V_MSQL;
        	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.FUN_PEF...  insertado');
		
		END IF;
    END IF;	
    
    
    COMMIT;
 
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
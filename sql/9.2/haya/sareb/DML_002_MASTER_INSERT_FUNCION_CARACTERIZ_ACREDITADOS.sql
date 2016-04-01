--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-858
--## PRODUCTO=NO
--## Finalidad: DML Insertar operacion nueva en DD_OPM_OPERACION_MASIVA
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
    V_MSQL VARCHAR2(4000 CHAR); -- Vble. para la realización de la sentencia.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    

    BEGIN
		DBMS_OUTPUT.PUT_LINE('******** FUN_FUNCIONES ********'); 
		
		V_MSQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION=''FUN_OM_CARAC_ACRED'' ';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS = 0 THEN
		    V_MSQL := 'INSERT INTO ' || V_ESQUEMA_M || '.FUN_FUNCIONES(FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
		    ' VALUES ('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL,''FUN_OM_CARAC_ACRED'',''Carterización de acreditados masivo'', 0, ''PRODUCTO-858'',sysdate, 0 )';
	    	EXECUTE IMMEDIATE V_MSQL;
	    ELSE
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... FUNCION: FUN_OM_CARAC_ACRED ya existe ');  	
  		END IF;
  		
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... filas actualizadas');  	
 
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
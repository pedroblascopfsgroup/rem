--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20190205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5393
--## PRODUCTO=NO
--##
--## Finalidad: Crear la restricción UNIQUE en el campo ACT_ID
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

    -- Comprobamos si existe ACT_CMG_COMUNICACION_GENCAT
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACT_CMG_COMUNICACION_GENCAT'' AND OWNER = UPPER('''||V_ESQUEMA||''')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN
	    -- Comprobamos si existe UK_CMG_ACT_ID
	    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''UK_CMG_ACT_ID'' AND OWNER = UPPER('''||V_ESQUEMA||''')';
	    DBMS_OUTPUT.PUT_LINE(V_SQL);
	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	    IF V_NUM_TABLAS = 0 THEN 
	        V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.ACT_CMG_COMUNICACION_GENCAT ADD CONSTRAINT UK_CMG_ACT_ID UNIQUE (ACT_ID)';
	        EXECUTE IMMEDIATE V_MSQL;
	        DBMS_OUTPUT.PUT_LINE('[INFO]: ' || V_ESQUEMA || '.ACT_CMG_COMUNICACION_GENCAT, CREADA UK_CMG_ACT_ID');
	        COMMIT;
	    ELSE    
	        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACT_CMG_COMUNICACION_GENCAT... UK_CMG_ACT_ID ya existe');
	    END IF;
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[ERROR] ' || V_ESQUEMA ||'.ACT_CMG_COMUNICACION_GENCAT... La tabla no existe');
	END IF;
    
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
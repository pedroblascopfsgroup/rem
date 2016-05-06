--/*
--##########################################
--## AUTOR= Kevin Fernández
--## FECHA_CREACION=20160503
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1325
--## PRODUCTO=SI
--##
--## Finalidad: Actualizacion 2 de la tabla de contabilidad cobros (CCO) para añadir
--##			dos campos nuevos. Uno para almacenar el 'TAR_ID' de la tarea asociada
--##			cuando se crea la notificacion, y otro 'CCO_CONTABILIZADO' para conocer
--##			cuando un gestor de contabilidad ha realizado su tarea.
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    L_NULLABLE  VARCHAR2(1); -- Vble. para validar si un campo puede ser nulo.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN

    -- ******** Update de la tabla CCO_CONTABILIDAD_COBROS *******
    DBMS_OUTPUT.PUT_LINE('******** Update de la tabla CCO_CONTABILIDAD_COBROS *******'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CCO_CONTABILIDAD_COBROS... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla.
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''CCO_CONTABILIDAD_COBROS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si NO existe la tabla no hacemos nada.
    IF V_NUM_TABLAS = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[ERROR] '||V_ESQUEMA||'.CCO_CONTABILIDAD_COBROS... La tabla NO existe, no se puede continuar..');    
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.CCO_CONTABILIDAD_COBROS... Comienza la actualización.');
        
        -- Comprobamos si existe la columna.
        V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''CCO_CONTABILIDAD_COBROS'' and owner = '''||V_ESQUEMA||''' and column_name = ''TAR_ID''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF(V_NUM_TABLAS < 1) THEN
          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CCO_CONTABILIDAD_COBROS ADD (TAR_ID NUMBER(16) )';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado la columna TAR_ID.');
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] La columna TAR_ID ya existe.');
        END IF;
        
        -- Comprobamos si existe la columna.
        V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''CCO_CONTABILIDAD_COBROS'' and owner = '''||V_ESQUEMA||''' and column_name = ''CCO_CONTABILIZADO''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF(V_NUM_TABLAS < 1) THEN
          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CCO_CONTABILIDAD_COBROS ADD (CCO_CONTABILIZADO NUMBER(1) DEFAULT 0 NOT NULL )';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado la columna CCO_CONTABILIZADO.');
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] La columna CCO_CONTABILIZADO ya existe.');
        END IF;

        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.CCO_CONTABILIDAD_COBROS... Actualizada.');

	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');

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

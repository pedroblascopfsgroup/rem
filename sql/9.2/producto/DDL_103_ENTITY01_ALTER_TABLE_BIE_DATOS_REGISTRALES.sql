--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20160530
--## ARTEFACTO=ONLINE
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-478
--## PRODUCTO=SI
--## Finalidad: CREACIÓN DE CAMPO BIE_DREG_CRU en las tablas BIE_DATOS_REGISTRALES y H_BIE_DATOS_REGISTRALES
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

    V_TABLA VARCHAR2(100 CHAR);   
    V_CAMPO VARCHAR2(100 CHAR);   
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

BEGIN

   	DBMS_OUTPUT.PUT_LINE('********************' );
    DBMS_OUTPUT.PUT_LINE('**CREACIÓN DE CAMPO BIE_DREG_CRU en las tablas BIE_DATOS_REGISTRALES y H_BIE_DATOS_REGISTRALES**' );
    DBMS_OUTPUT.PUT_LINE('********************' );
 
 	V_CAMPO := 'BIE_DREG_CRU';
    V_TABLA := 'BIE_DATOS_REGISTRALES';   
                
	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBAMOS SI EXISTE EL CAMPO ' || V_CAMPO || ' EN LA TABLA ' || V_TABLA);
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME=''' || V_CAMPO || ''' AND TABLE_NAME=''' || V_TABLA || ''' AND OWNER='''||V_ESQUEMA||'''';   
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN 
        DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE EL CAMPO ' || V_CAMPO || ' EN LA TABLA ' || V_TABLA);
	ELSE
        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA ||' ADD ' || V_CAMPO || ' VARCHAR2(20 CHAR)';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] CREADO EL CAMPO  ' || V_CAMPO || ' EN LA TABLA ' || V_TABLA);
    END IF;
                           
    V_TABLA := 'H_BIE_DATOS_REGISTRALES';   
                
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA|| ''' AND OWNER='''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 1 THEN
	    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME=''' || V_CAMPO || ''' AND TABLE_NAME=''' || V_TABLA || ''' AND OWNER='''||V_ESQUEMA||'''';   
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	    IF V_NUM_TABLAS = 1 THEN 
	        DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE EL CAMPO ' || V_CAMPO || ' EN LA TABLA ' || V_TABLA);
		ELSE
	        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA ||' ADD ' || V_CAMPO || ' VARCHAR2(20 CHAR)';
	        --DBMS_OUTPUT.PUT_LINE(V_SQL);
	        EXECUTE IMMEDIATE V_SQL; 
	        DBMS_OUTPUT.PUT_LINE('[INFO] CREADO EL CAMPO  ' || V_CAMPO || ' EN LA TABLA ' || V_TABLA);
	    END IF;
	END IF;

	COMMIT;   
	DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO' );


EXCEPTION
     
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
 
END;
/
EXIT



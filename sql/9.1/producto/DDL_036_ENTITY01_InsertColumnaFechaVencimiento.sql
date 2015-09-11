--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150820
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.3.13_rc01
--## INCIDENCIA_LINK=CMREC-418
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** CRE_PRC_CEX ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CRE_PRC_CEX... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME=''CRE_FECHA_VENCIMIENTO'' AND TABLE_NAME=''CRE_PRC_CEX'' AND OWNER = ''' || V_ESQUEMA || '''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.CRE_PRC_CEX...no se modifica nada.');
	ELSE

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CRE_PRC_CEX '
				|| ' ADD CRE_FECHA_VENCIMIENTO TIMESTAMP(6) ';
 
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
    	EXECUTE IMMEDIATE V_MSQL;
    END IF;
		
	COMMIT;
 
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
  
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
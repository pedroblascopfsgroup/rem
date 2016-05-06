--/*
--##########################################
--## AUTOR=Miguel Angel Sanchez
--## FECHA_CREACION=20160425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2269
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA_PFSRECOVERY VARCHAR2(25 CHAR):= 'PFSRECOVERY'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    -- Otras variables
    
 BEGIN
    
    DBMS_OUTPUT.put_line('- INICIO PROCESO -');

    V_MSQL := 'CREATE TABLE '||V_ESQUEMA_PFSRECOVERY||'hr_2269_LOS_LOTE_SUBASTA AS
		SELECT los.* FROM '||V_ESQUEMA||'.LOS_LOTE_SUBASTA los
		inner join '||V_ESQUEMA||'.LOB_LOTE_BIEN lob on los.LOS_ID = lob.LOS_ID
		where lob.bie_id=1000000000200192';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.put_line('-- CREADA TABLA hr_2269_LOS_LOTE_SUBASTA -');
    
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA_PFSRECOVERY||'hr_2269_LOS_LOTE_bien AS
		SELECT lob.* FROM '||V_ESQUEMA||'.LOS_LOTE_SUBASTA los
		inner join '||V_ESQUEMA||'.LOB_LOTE_BIEN lob on los.LOS_ID = lob.LOS_ID
		where lob.bie_id=1000000000200192';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.put_line('-- CREADA TABLA hr_2269_LOS_LOTE_bien -');

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.LOS_LOTE_SUBASTA 
		WHERE LOS_ID=1000000000009189';	
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.put_line('-- BORRADO LOTE_SUBASTA -');

    V_MSQL := 'delete from '||V_ESQUEMA||'.LOB_LOTE_BIEN 
		where LOS_ID=1000000000009189';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.put_line('-- BORRADO LOTE_BIEN -');

    DBMS_OUTPUT.put_line('- FIN PROCESO -');
    
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

EXIT;

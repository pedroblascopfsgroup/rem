--/*
--##########################################
--## AUTOR=Miguel Angel Sanchez
--## FECHA_CREACION=20160425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2349
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
    V_ESQUEMA_PFSRECOVERY VARCHAR2(25 CHAR):= '#ESQUEMA_PFSRECOVERY#'; -- Configuracion Esquema Master
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

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ASU_ASUNTOS ASU
		SET DD_EAS_ID=(SELECT DD_EAS_ID FROM '||V_ESQUEMA_M||'.DD_EAS_ESTADO_ASUNTOS WHERE DD_EAS_CODIGO = '03')
		WHERE ASU_ID=1000000000000349';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.put_line('-- aCTUALIZADO EL ESTADO DEL ASUNTO -');

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

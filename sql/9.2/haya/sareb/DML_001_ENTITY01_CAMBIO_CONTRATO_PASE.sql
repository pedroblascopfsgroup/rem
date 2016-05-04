--/*
--##########################################
--## AUTOR=Miguel Ángel Sánchez Sánchez
--## FECHA_CREACION=20160405
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HR-2430
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar el contrato de pase en para el asunto 0005308 | 050802197G MIGUEL PEREDA MAZO 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
 BEGIN

V_MSQL := 'UPDATE '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
SET CEX.CEX_PASE=0 
WHERE CEX.CNT_ID=6275025';
DBMS_OUTPUT.PUT_LINE('   [QUERY] '|| V_MSQL );
EXECUTE IMMEDIATE V_MSQL  ;

V_MSQL := 'UPDATE '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
SET CEX.CEX_PASE=1
WHERE CEX.CNT_ID=6297033';
DBMS_OUTPUT.PUT_LINE('   [QUERY] '|| V_MSQL );
EXECUTE IMMEDIATE V_MSQL  ;


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

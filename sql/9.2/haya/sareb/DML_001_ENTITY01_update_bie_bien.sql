--/*
--##########################################
--## AUTOR=Daniel Esteve
--## FECHA_CREACION=20160225
--## ARTEFACTO=[online|batch]
--## VERSION_ARTEFACTO=X.X.X_rcXX
--## INCIDENCIA_LINK=PROJECTKEY-ISSUENUMBER
--## PRODUCTO=[SI|NO]
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

    V_MSQL := 'update ' || V_ESQUEMA ||'.BIE_BIEN 
                        set DD_TBI_ID = (select DD_TBI_ID from ' || V_ESQUEMA ||'.DD_TBI_TIPO_BIEN where DD_TBI_CODIGO like ''01'') 
                        , USUARIOMODIFICAR = ''HR-2016''
                        , FECHAMODIFICAR = SYSDATE 
                        where BIE_ID in (
    1000000000125937,
    1000000000182534,
    1000000000158356,
    1000000000180346,
    1000000000156136,
    1000000000121955,
    1000000000124355,
    1000000000161502,
    1000000000195916,
    1000000000121292,
    1000000000141868,
    1000000000132664,
    1000000000135613,
    1000000000124356,
    1000000000163407,
    1000000000141869,
    1000000000185537,
    1000000000146369,
    1000000000167600,
    1000000000121294,
    1000000000138377,
    1000000000195296,
    1000000000182532,
    1000000000121291,
    1000000000193477,
    1000000000172231,
    1000000000179213)';
    
    EXECUTE IMMEDIATE V_MSQL;
    
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

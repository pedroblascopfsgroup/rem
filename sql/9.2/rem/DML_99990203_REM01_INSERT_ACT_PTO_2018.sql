--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=HREOS-3508
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN 
  
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_EJE_EJERCICIO (EJE_ID, EJE_ANYO, EJE_FECHAINI, EJE_FECHAFIN, EJE_DESCRIPCION, USUARIOCREAR
            , FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_EJE_EJERCICIO.NEXTVAL, ''2018'', TO_DATE(''01/01/2018'',''DD/MM/YYYY''), TO_DATE(''31/12/2018'',''DD/MM/YYYY'')
            , ''Ejercicio correspondiente al año 2018'', ''DML'', SYSDATE
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1
            FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO
            WHERE EJE_ANYO = ''2018'')';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' ejercicios insertados.');
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO (PTO_ID, ACT_ID, EJE_ID, PTO_IMPORTE_INICIAL
            , PTO_FECHA_ASIGNACION, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_PTO_PRESUPUESTO.NEXTVAL, ACT.ACT_ID, EJE.EJE_ID, 50000, EJE.EJE_FECHAINI, ''REM01'', SYSDATE
        FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
        JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ANYO = ''2018''
        WHERE ACT.BORRADO = 0 AND NOT EXISTS (SELECT 1
        FROM '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO PTO
        WHERE PTO.ACT_ID = ACT.ACT_ID AND PTO.EJE_ID = EJE.EJE_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' presupuestos insertados para el año 2018.');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PRESUPUESTOS INSERTADOS PARA AÑO 2018.');
   
EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        ROLLBACK;
        RAISE;          
END;
/
EXIT



   
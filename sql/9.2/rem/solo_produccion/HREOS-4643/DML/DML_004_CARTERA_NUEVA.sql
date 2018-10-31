--/*
--##########################################
--## AUTOR=Vicente Martinez
--## FECHA_CREACION=20180112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3625
--## PRODUCTO=NO
--##
--## Finalidad: Migracion Tango
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TABLA_AUXILIAR VARCHAR2(50 CHAR) := 'MIG2_USUARIOCREAR_CARTERIZADO';

    V_USUARIO VARCHAR2(50 CHAR) := 'TRASPASO_TANGO';
    V_COD_CARTERA VARCHAR2(50 CHAR) := '10';
    
BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]: Inicio del proceso');

EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||TABLA_AUXILIAR||' (USUARIOCREAR, CARTERA)
    SELECT '''||V_USUARIO||''', CRA.DD_CRA_CODIGO
    FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA
    WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||TABLA_AUXILIAR||' AUX WHERE USUARIOCREAR = '''||V_USUARIO||''')
        AND CRA.DD_CRA_CODIGO = '''||V_COD_CARTERA||''''; 
  DBMS_OUTPUT.PUT_LINE('[AUX]: '||SQL%ROWCOUNT||' registros insertados en la tabla '||TABLA_AUXILIAR||'');

DBMS_OUTPUT.PUT_LINE('[FIN]');

COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        DBMS_OUTPUT.put_line(V_MSQL);
        ROLLBACK;
        RAISE;          
END;
/
EXIT;

--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.0.14-rem
--## INCIDENCIA_LINK=HREOS-3701
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en DD_EQV_BANKIA_REM
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
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_EQV_BANKIA_REM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'INSERT INTO REM01.DD_EQV_BANKIA_REM (DD_NOMBRE_BANKIA, DD_CODIGO_BANKIA, DD_DESCRIPCION_BANKIA, DD_DESCRIPCION_LARGA_BANKIA
            , DD_NOMBRE_REM, DD_CODIGO_REM, DD_DESCRIPCION_REM, DD_DESCRIPCION_LARGA_REM, USUARIOCREAR, FECHACREAR)
        SELECT DD_NOMBRE_BANKIA, SUBSTR(EQV.DD_CODIGO_BANKIA,1,2)||''00'' DD_CODIGO_BANKIA, DD_DESCRIPCION_BANKIA, DD_DESCRIPCION_LARGA_BANKIA
            , DD_NOMBRE_REM, DD_CODIGO_REM, DD_DESCRIPCION_REM, DD_DESCRIPCION_LARGA_REM, ''HREOS-3701'' USUARIOCREAR, SYSDATE FECHACREAR
        FROM REM01.DD_EQV_BANKIA_REM EQV
        WHERE EQV.DD_CODIGO_BANKIA IN (''CO01'',''ED02'',''IN02'',''OT05'',''SU01'',''VI01'')
            AND NOT EXISTS (SELECT 1
                FROM REM01.DD_EQV_BANKIA_REM AUX
                WHERE SUBSTR(EQV.DD_CODIGO_BANKIA,1,2)||''00'' = AUX.DD_CODIGO_BANKIA)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA);
        
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    COMMIT;

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

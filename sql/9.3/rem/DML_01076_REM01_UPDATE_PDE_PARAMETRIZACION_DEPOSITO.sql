--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220713
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12067
--## PRODUCTO=NO
--##
--## Finalidad: UPDATE en PDE_PARAMETRIZACION_DEPOSITO
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-12067'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_TABLA VARCHAR2 (30 CHAR) := 'PDE_PARAMETRIZACION_DEPOSITO';
    V_COUNT NUMBER(25);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAMOS VALORES PRECIO DE 60K A 100K PARA EL PRECIO A COMPARAR');

    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                        PDE_PRECIO = 100000,
                        USUARIOMODIFICAR = '''||V_USUARIO||''',
                        FECHAMODIFICAR = SYSDATE
                        WHERE PDE_PRECIO = 60000 AND BORRADO = 0';
                            
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADA TABLA '||V_TABLA);

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

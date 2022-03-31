--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17581
--## PRODUCTO=NO
--##
--## Finalidad: Insert en CPF_CONFIG_PVE_FORMALIZACION
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
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-17581'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_TABLA VARCHAR2 (30 CHAR) := 'CPF_CONFIG_PVE_FORMALIZACION';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			 CPF_ID
            ,PVE_ID
            ,CPF_FORMALIZACION_CAJAMAR
            )
            SELECT '||V_ESQUEMA||'.S_CPF_CONFIG_PVE_FORMALIZACION.NEXTVAL CPF_ID
            ,PVE.PVE_ID
            ,1
            FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
            JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = PVE.DD_LOC_ID
            WHERE LOC.DD_LOC_CODIGO = ''04013'' 
            ';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_CONFIG_PTDAS_PREP');  



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

EXIT

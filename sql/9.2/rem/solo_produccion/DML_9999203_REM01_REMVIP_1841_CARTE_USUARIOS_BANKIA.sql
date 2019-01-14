--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20180917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1841
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en UCA_USUARIO_CARTERA
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_EXISTS NUMBER(10);


BEGIN


	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO] Realizamos insert en la UCA_USUARIO_CARTERA');
	

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.UCA_USUARIO_CARTERA (UCA_ID,USU_ID,DD_CRA_ID) 
        SELECT '||V_ESQUEMA||'.S_UCA_USUARIO_CARTERA.NEXTVAL, USU_ID, 21
        FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
        WHERE USU_USERNAME IN
        (''A174618'', 
        ''A174255'',
        ''A177191'',
        ''A177194'',
        ''A177193'',
        ''A174971'',
        ''A173935'',
        ''A171603'',
        ''A193019'',
        ''A173322'',
        ''A173433'',
        ''A194480'',
        ''A194481'',
        ''A186396'',
        ''A173309'',
        ''A174972'',
        ''A173310'',
        ''A186397'',
        ''A176800'',
        ''A184519'',
        ''A194482'',
        ''A190626'',
        ''A193017'',
        ''A180562'',
        ''A193150'',
        ''A193468'')';

    EXECUTE IMMEDIATE V_MSQL;  


    DBMS_OUTPUT.PUT_LINE('[INFO] Se insertan '||SQL%ROWCOUNT||' registros en UCA_USUARIO_CARTERA');    
    
    
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('KO no modificada');
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        ROLLBACK;
        RAISE;          
END;
/
EXIT

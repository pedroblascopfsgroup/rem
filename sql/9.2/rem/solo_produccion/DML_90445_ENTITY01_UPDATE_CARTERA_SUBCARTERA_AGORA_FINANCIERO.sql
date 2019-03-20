--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5447
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar cartera y subcartera de 8 activos a Agora-Financiero.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 CHAR);
        
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] Comienza el proceso de actualizacion de cartera y subcartera de los 8 activos.');

    V_SQL:= '	MERGE INTO REM01.ACT_ACTIVO ACT
				USING (
					SELECT ACT_ID
					FROM REM01.ACT_ACTIVO 
					WHERE ACT_NUM_ACTIVO IN (   7027063,
												7028035,
												7028037,
												7028036,
												7028623,
												7027476,
												7028350,
												7027982
					)
				) T2
				ON (ACT.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07''),
					ACT.DD_SCR_ID = (SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''135''),
					ACT.USUARIOMODIFICAR = ''HREOS-5447'',
					ACT.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se modifica la cartera y subcartera de '||SQL%ROWCOUNT||' activos a Agora-Financiero.');

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Se ha terminado el proceso.');
 
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

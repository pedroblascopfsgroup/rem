--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5747
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES: Updatear PRG_ID = NULL.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-5747';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

BEGIN

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando ACT_TBJ_TRABAJO ');    
            
            V_SQL :=    'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO
                          SET AGR_ID = NULL
                        , USUARIOMODIFICAR = '''||V_USUARIO||'''
						, FECHAMODIFICAR = SYSDATE
                          WHERE TBJ_NUM_TRABAJO = ''9000030658'' ';                          

            EXECUTE IMMEDIATE V_SQL;  
            
        DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizados ' || SQL%ROWCOUNT || ' Trabajos' );

	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso finalizado.');
	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

--/*  
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20180314
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=HREOS-3866
--## PRODUCTO=NO
--## Finalidad: DDL crear SP que registra los pasos que van haciendo los SP
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE SP_LSP_LOGS	(P_PROCESO    #ESQUEMA#.LSP_LOGS_SP.LSP_PROCESO%TYPE
											,P_PASO       #ESQUEMA#.LSP_LOGS_SP.LSP_PASO%TYPE
											,P_COMENTARIO #ESQUEMA#.LSP_LOGS_SP.LSP_COMENTARIO%TYPE
											,P_NUMFILAS   #ESQUEMA#.LSP_LOGS_SP.LSP_NUMFILAS%TYPE
											,P_ERROR	  #ESQUEMA#.LSP_LOGS_SP.LSP_ERROR%TYPE
											) AUTHID CURRENT_USER IS

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_TABLA VARCHAR2(30 CHAR):= 'LSP_LOGS_SP';
  V_TEXT_CHARS VARCHAR2(5 CHAR) := 'LSP'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' ('||V_TEXT_CHARS||'_ID, '||V_TEXT_CHARS||'_FECHA, '||V_TEXT_CHARS||'_PROCESO
													  , '||V_TEXT_CHARS||'_PASO, '||V_TEXT_CHARS||'_COMENTARIO, '||V_TEXT_CHARS||'_NUMFILAS
													  , '||V_TEXT_CHARS||'_ERROR)' ||
            '     VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, SYSDATE, '''||P_PROCESO||'''
                         , '''||P_PASO||''', '''||P_COMENTARIO||''', '''||P_NUMFILAS||'''
                         , '''||P_ERROR||''')
            ';

  EXECUTE IMMEDIATE V_MSQL;
  
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(ERR_MSG);
    ROLLBACK;
    RAISE;

END SP_LSP_LOGS;

/
EXIT;

--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-1589
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1589';

	PRO_DOCIDENTIF VARCHAR2(55 CHAR);
	PRO_NOMBRE VARCHAR2(55 CHAR);

BEGIN

	UPDATE REM01.TAP_TAREA_PROCEDIMIENTO SET
		  TAP_SCRIPT_VALIDACION_JBPM = 'valores[''T013_ResolucionComite''][''comboResolucion''] != DDResolucionComite.CODIGO_APRUEBA ? (valores[''T013_ResolucionComite''][''comboResolucion''] == DDResolucionComite.CODIGO_CONTRAOFERTA ? ((checkBankia() || checkLiberbank() || checkGiants()) ? null : existeAdjuntoUGValidacion("22","E")) : null) : resolucionComiteT013()'
		, USUARIOMODIFICAR = V_USUARIO
		, FECHAMODIFICAR = SYSDATE
	WHERE
		TAP_CODIGO = 'T013_ResolucionComite'
	;
    
	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;


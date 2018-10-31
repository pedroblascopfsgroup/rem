--/*
--#########################################
--## AUTOR=JAVIER PONS RUIZ
--## FECHA_CREACION=20181029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2214
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar la fecha de recepcion de llaves del mediador a una menor a SYSDATE
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ICO_INFO_COMERCIAL';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2214';
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_ID VARCHAR2(55 CHAR);

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de cambio de ICO_FECHA_RECEP_LLAVES en activo - publicacion - informe comercial.');
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' ICO 
		          SET 
			  ICO_FECHA_RECEP_LLAVES = ICO_FECHA_ULTIMA_VISITA
			, USUARIOMODIFICAR = '''||V_USUARIO||'''  
			, FECHAMODIFICAR = SYSDATE 
			WHERE ICO_FECHA_RECEP_LLAVES > SYSDATE';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla de '||V_TABLA||'.');
		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finaliza el proceso de actualizacion.');

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


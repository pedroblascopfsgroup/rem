--/*
--#########################################
--## AUTOR=Alfonso Rodriguez
--## FECHA_CREACION=20190826
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7399
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar perimetro activo, añadiendo columna de equipo gestion
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'DD_OPM_OPERACION_MASIVA';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-7399';
	ACT_NUM_ACTIVO_UVEM NUMBER(32);
	DD_SCR_DESCRIPCION VARCHAR2(72 CHAR);
	ACT_NUM_ACTIVO_OLD NUMBER(32);
	ACT_NUM_ACTIVO_NEW NUMBER(32);


BEGIN

	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
				  USUARIOMODIFICAR = '''||V_USUARIO||'''
				, FECHAMODIFICAR = SYSDATE
				, DD_OPM_VALIDACION_FORMATO = ''nD*,s,s,s,s,s,s,s,s,s,s,s,s,s,s''
				WHERE DD_OPM_CODIGO = ''ACPA''
				';

	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros');
		
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

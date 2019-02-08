--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20190208
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3264
--## PRODUCTO=NO
--## 
--## Finalidad: Dar de baja agrupaciones
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



	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	


BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO ');
      
 
      V_SENTENCIA := '
       UPDATE REM01.ACT_AGR_AGRUPACION AGR
		SET AGR.AGR_ELIMINADO = 1,
		AGR.AGR_FECHA_BAJA = SYSDATE,
		USUARIOMODIFICAR = ''REMVIP-3264'',
		FECHAMODIFICAR = SYSDATE
		WHERE AGR_NUM_AGRUP_REM = 1302534;';


      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CAMBIADAS  '||SQL%ROWCOUNT||' Filas.');
       
   COMMIT;
        
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;

/

EXIT;

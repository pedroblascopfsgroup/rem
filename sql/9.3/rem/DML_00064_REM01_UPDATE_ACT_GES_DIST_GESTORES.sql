--/*
--#########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200715
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6612
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

   V_ESQUEMA VARCHAR2(25 CHAR):= 'rem01'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= 'remmaster'; -- Configuracion Esquema Master
   V_SQL VARCHAR2(32000 CHAR);
   V_MSQL VARCHAR2(32000 CHAR);
   PL_OUTPUT VARCHAR2(32000 CHAR);
   SP_OUTPUT VARCHAR2(32000 CHAR);
   V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6612';


BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] ActualizadoS '||SQL%ROWCOUNT||' registros en USU_USUARIOS');

V_MSQL := '
UPDATE '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES SET USERNAME = ''acierta'',
USUARIOMODIFICAR = ''REMVIP-6612'',
FECHAMODIFICAR = SYSDATE
WHERE USERNAME = ''---------.6'' ';

      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] ActualizadoS '||SQL%ROWCOUNT||' registros en USU_USUARIOS');

COMMIT;
EXCEPTION
   WHEN OTHERS THEN
       PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecución: ' || TO_CHAR(SQLCODE) || CHR(10);
       PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
       PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
       DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
       ROLLBACK;
       RAISE;
END;
/
EXIT;
--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=202100305
--## ARTEFACTO=Batch
--## VERSION_ARTEFACTO=3.0
--## INCIDENCIA_LINK=REMVIP-9149
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar tarifas.
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9149';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
    V_MSQL VARCHAR2(4000 CHAR);

    V_TABLA_ACT VARCHAR2(30 CHAR) :='ACT_ACTIVO';
    V_TABLA_AGA VARCHAR2(30 CHAR) :='ACT_AGA_AGRUPACION_ACTIVO';
    V_TABLA_AGR VARCHAR2(30 CHAR) := 'ACT_AGR_AGRUPACION';

    V_NUM_AGRUPACION VARCHAR2(30 CHAR):='1000026727';
    V_NUM_TABLAS NUMBER(16);
    V_ID NUMBER(16);

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizacion en '||V_TABLA_ACT||'');

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AGR||' WHERE AGR_NUM_AGRUP_REM='||V_NUM_AGRUPACION||'';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ACT||' T1
        USING (SELECT ACT.ACT_ID FROM REM01.ACT_AGR_AGRUPACION AGR
                JOIN REM01.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID=AGR.AGR_ID
                JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID=AGA.ACT_ID
                WHERE AGR.BORRADO=0 AND ACT.BORRADO=0 AND AGR.AGR_NUM_AGRUP_REM='||V_NUM_AGRUPACION||'
  ) T2 
        ON (T1.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
        T1.DD_EAC_ID=(SELECT EAC.DD_EAC_ID FROM REM01.DD_EAC_ESTADO_ACTIVO EAC WHERE EAC.DD_EAC_CODIGO=03 AND BORRADO=0),        
        T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
        T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TABLA_ACT||' CAMBIADOS A ESTADO OBRA NUEVA (TERMINADA)');

    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] No existe el numero de agrupacion indicado '||V_NUM_AGRUPACION||'.');
    END IF;
                

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado la modificacion de estados de activos.');
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

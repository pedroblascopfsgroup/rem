--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200610
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7233
--## PRODUCTO=NO
--##
--## Finalidad: --
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
   V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
   V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   PL_OUTPUT VARCHAR2(32000 CHAR);

   ACT_ID NUMBER(16);
   V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates

   TYPE T_JBV IS TABLE OF VARCHAR2(32000);
   TYPE T_ARRAY_JBV IS TABLE OF T_JBV;

V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
T_JBV(263720),
T_JBV(357880),
T_JBV(357858),
T_JBV(347687),
T_JBV(429238),
T_JBV(346698),
T_JBV(429321),
T_JBV(427342),
T_JBV(412808),
T_JBV(357125),
T_JBV(357123),
T_JBV(75098),
T_JBV(49371),
T_JBV(357122),
T_JBV(357116),
T_JBV(357120),
T_JBV(357115),
T_JBV(357117),
T_JBV(357124),
T_JBV(357126),
T_JBV(859),
T_JBV(866),
T_JBV(44996),
T_JBV(45000),
T_JBV(45009),
T_JBV(45010),
T_JBV(45011),
T_JBV(1686),
T_JBV(1772),
T_JBV(346928),
T_JBV(72977),
T_JBV(72960),
T_JBV(357184),
T_JBV(346688),
T_JBV(263896),
T_JBV(263961),
T_JBV(410996),
T_JBV(356245),
T_JBV(356249),
T_JBV(267465),
T_JBV(263944),
T_JBV(263912),
T_JBV(324935),
T_JBV(346689),
T_JBV(324943),
T_JBV(356250),
T_JBV(356251),
T_JBV(324954),
T_JBV(72966),
T_JBV(263881),
T_JBV(263959),
T_JBV(263934),
T_JBV(356243),
T_JBV(356248),
T_JBV(356246),
T_JBV(53001),
T_JBV(324957),
T_JBV(324951),
T_JBV(346711),
T_JBV(263927),
T_JBV(263899),
T_JBV(263938),
T_JBV(2536),
T_JBV(434914),
T_JBV(324938),
T_JBV(2738),
T_JBV(431691),
T_JBV(2843),
T_JBV(2881),
T_JBV(346679),
T_JBV(2956),
T_JBV(38901),
T_JBV(39616),
T_JBV(3546),
T_JBV(3623),
T_JBV(5473),
T_JBV(5491),
T_JBV(5600),
T_JBV(5629),
T_JBV(6173),
T_JBV(38085),
T_JBV(38086),
T_JBV(38087),
T_JBV(38081),
T_JBV(38016),
T_JBV(38041),
T_JBV(38036),
T_JBV(38029),
T_JBV(38031),
T_JBV(38022),
T_JBV(38026),
T_JBV(38028),
T_JBV(42333),
T_JBV(42342),
T_JBV(42356),
T_JBV(42358),
T_JBV(45066),
T_JBV(45069),
T_JBV(45070),
T_JBV(45071),
T_JBV(355739),
T_JBV(355740),
T_JBV(355795),
T_JBV(355796),
T_JBV(422202)
);
V_TMP_JBV T_JBV;

BEGIN

FOR I IN V_JBV.FIRST .. V_JBV.LAST

LOOP

V_TMP_JBV := V_JBV(I);

 	ACT_ID := TRIM(V_TMP_JBV(1));

    REM01.SP_PORTALES_ACTIVO (ACT_ID, NULL, 'REMVIP-7233', PL_OUTPUT);
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

END LOOP;

COMMIT;

EXCEPTION
    WHEN OTHERS THEN
         ERR_NUM := SQLCODE;
         ERR_MSG := SQLERRM;
         DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
         DBMS_OUTPUT.put_line('-----------------------------------------------------------');
         DBMS_OUTPUT.put_line(ERR_MSG);
         ROLLBACK;
         RAISE;
END;
/
EXIT;
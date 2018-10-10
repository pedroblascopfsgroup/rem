--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181009
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2154
--## PRODUCTO=NO
--##
--## Finalidad: ACTUALIZAR ID_HAYA ERRONEO POR CORRECTO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
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
    --V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2154';

	ACT_NUM_ACTIVO_MALO NUMBER(16);
	ACT_NUM_ACTIVO_BUENO NUMBER(16);




    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV(837149,99995587)
		, T_JBV(883726,99995957)
		, T_JBV(836569,99995654)
		, T_JBV(913104,99995349)
		, T_JBV(912809,99992290)
		, T_JBV(903103,99995912)
		, T_JBV(867133,99995655)
		, T_JBV(840757,99995656)
		, T_JBV(838859,99995913)
		, T_JBV(856576,99995914)
		, T_JBV(836099,99997630)
		, T_JBV(882032,99991667)
		, T_JBV(857214,99997280)

	); 
	V_TMP_JBV T_JBV;
BEGIN


 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);

		ACT_NUM_ACTIVO_MALO  := TRIM(V_TMP_JBV(1));
		ACT_NUM_ACTIVO_BUENO  := TRIM(V_TMP_JBV(2));
			
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
					 ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO_BUENO||'
				   , USUARIOMODIFICAR = '''||V_USUARIO||'''
				   , FECHAMODIFICAR = SYSDATE
				   WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO_MALO||'
					';


		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('ACTUALIZADO ACT_NUM_ACTIVO '||ACT_NUM_ACTIVO_MALO||' A '||ACT_NUM_ACTIVO_BUENO);
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;

    END LOOP;			    
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han updateado en total '||V_COUNT_UPDATE||' registros');

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

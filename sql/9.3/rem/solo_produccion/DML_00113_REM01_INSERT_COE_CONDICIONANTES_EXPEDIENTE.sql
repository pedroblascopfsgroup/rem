--/*
--#########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200312
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.6
--## INCIDENCIA_LINK=REMVIP-6615
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-6615';

	ECO_ID NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV;

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV(196244)
		, T_JBV(194408)
		, T_JBV(195824)
		, T_JBV(195719)
		, T_JBV(195111)
		, T_JBV(195872)
		, T_JBV(195029)
		, T_JBV(194846)
		, T_JBV(196242)
		, T_JBV(195718)
		, T_JBV(195724)
		, T_JBV(195717)
		, T_JBV(194572)
		, T_JBV(195721)
	);
V_TMP_JBV T_JBV;
BEGIN


 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP

 V_TMP_JBV := V_JBV(I);
 			  ECO_ID := TRIM(V_TMP_JBV(1));


			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE
								WHERE ECO_ID = '''||ECO_ID||'''' INTO V_COUNT;

			IF V_COUNT = 0 THEN
				V_SQL := 'INSERT INTO '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE (
				  COE_ID
				, ECO_ID
				, FECHACREAR
				, USUARIOCREAR
				) VALUES (
				 '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE
				, '''||ECO_ID||'''
				, SYSDATE
				, '''||V_USUARIO||'''
				)
			';
				EXECUTE IMMEDIATE V_SQL;

			DBMS_OUTPUT.PUT_LINE('Insertado el condicionante para el expediente '''||ECO_ID||'''');

			ELSE
				DBMS_OUTPUT.PUT_LINE('El condicionante para el expediente '''||ECO_ID||''' ya existia');
			END IF;



 END LOOP;

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

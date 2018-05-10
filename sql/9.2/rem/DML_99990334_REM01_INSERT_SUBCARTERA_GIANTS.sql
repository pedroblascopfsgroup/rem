--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180509
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-680
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
    V_TABLA VARCHAR2(25 CHAR):= 'DD_SCR_SUBCARTERA';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-680';
	DD_SCR_DESCRIPCION VARCHAR2(64 CHAR);
	DD_SCR_CODIGO VARCHAR2(32 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		        T_JBV('G-Giants REO I, S.L.','33')
		      , T_JBV('G-Giants REO II, S.L.','34')
		      , T_JBV('G-Giants REO III, S.L.','35')
		      , T_JBV('G-Giants REO IV, S.L.','36')
	); 
	V_TMP_JBV T_JBV;
BEGIN

 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);

			  DD_SCR_DESCRIPCION  := TRIM(V_TMP_JBV(1));
			  DD_SCR_CODIGO  := TRIM(V_TMP_JBV(2));

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE
				DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''12'')
				AND DD_SCR_CODIGO = '''||DD_SCR_CODIGO||'''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT = 0 THEN
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
					  DD_SCR_ID
					, DD_CRA_ID
					, DD_SCR_CODIGO
					, DD_SCR_DESCRIPCION
					, DD_SCR_DESCRIPCION_LARGA
					, USUARIOCREAR
					, FECHACREAR
					) VALUES (
					  '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
					, (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''12'')
					, '''||DD_SCR_CODIGO||'''
					, '''||DD_SCR_DESCRIPCION||'''
					, '''||DD_SCR_DESCRIPCION||'''
					, '''||V_USUARIO||'''
					, SYSDATE
					)';

		EXECUTE IMMEDIATE V_SQL;
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existía la subcartera '||DD_SCR_DESCRIPCION);
	END IF;
 
	COMMIT;

 END LOOP;			    
    
	commit;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en total '||V_COUNT_UPDATE||' registros');

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

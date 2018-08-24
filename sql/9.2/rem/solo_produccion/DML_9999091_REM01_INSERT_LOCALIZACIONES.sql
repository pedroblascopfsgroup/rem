--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180509
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-525
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
    --V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-690';

	ACT_ID NUMBER(16);



    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		      T_JBV(266934)
	); 
	V_TMP_JBV T_JBV;
BEGIN


 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);

			  ACT_ID  := TRIM(V_TMP_JBV(1));			

		V_SQL := 'INSERT INTO REM01.BIE_LOCALIZACION (
					  BIE_ID
					, FECHACREAR
					, USUARIOCREAR
					, BIE_LOC_ID
					) VALUES (
					 (SELECT BIE_ID FROM REM01.ACT_ACTIVO WHERE ACT_ID = '||ACT_ID||')
					, SYSDATE
					,'''||V_USUARIO||'''
					, S_BIE_LOCALIZACION.NEXTVAL
					)
					';


DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('insertado en bie_Loc el act_id '||ACT_ID);


		V_SQL := 'INSERT INTO REM01.ACT_LOC_LOCALIZACION (
					 LOC_ID
					,ACT_ID
					,FECHACREAR
					,USUARIOCREAR
					,BIE_LOC_ID
					) VALUES (
					 S_ACT_LOC_LOCALIZACION.NEXTVAL
					,'||ACT_ID||'
					,SYSDATE
					,'''||V_USUARIO||'''
					,(SELECT BIE_LOC_ID FROM REM01.BIE_LOCALIZACION WHERE BIE_ID = (SELECT BIE_ID FROM REM01.ACT_ACTIVO WHERE ACT_ID = '||ACT_ID||'))
					)
					';

DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('insertado en bie_Loc el act_id '||ACT_ID);



				V_COUNT_UPDATE := V_COUNT_UPDATE + 1;

 END LOOP;			    
    
	commit;

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

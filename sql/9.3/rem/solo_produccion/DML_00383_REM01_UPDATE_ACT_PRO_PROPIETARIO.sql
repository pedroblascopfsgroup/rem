--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200709
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.6
--## INCIDENCIA_LINK=REMVIP-7756
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-7756';

	PRO_DOCIDENTIF VARCHAR2(55 CHAR);
	PRO_NOMBRE VARCHAR2(55 CHAR);
	
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV('V85594927')
	); 
V_TMP_JBV T_JBV;
BEGIN

 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
			  PRO_DOCIDENTIF := TRIM(V_TMP_JBV(1));
	

			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO 
								WHERE PRO_NOMBRE = '''||PRO_DOCIDENTIF||'''' INTO V_COUNT;
								
			IF V_COUNT = 0 THEN 								
				V_SQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO
		 SET PRO_DIR = ''Calle Orense 69'',
		 USUARIOMODIFICAR = '''||V_USUARIO||''',
		 FECHAMODIFICAR = SYSDATE
		 WHERE 1 = 1
		 AND PRO_DOCIDENTIF = '''||PRO_DOCIDENTIF||'''
			';
				EXECUTE IMMEDIATE V_SQL;
		
			DBMS_OUTPUT.PUT_LINE('Actualizado el propietario '''||PRO_DOCIDENTIF||'''');	

				V_SQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO
		 SET PRO_ID = ( SELECT PRO_ID FROM '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''V85594927'' AND BORRADO = 0 ),
		 USUARIOMODIFICAR = '''||V_USUARIO||''',
		 FECHAMODIFICAR = SYSDATE
		 WHERE 1 = 1
		 AND ACT_ID = (
				SELECT ACT.ACT_ID
				FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
				WHERE 1 = 1
				AND ACT_NUM_ACTIVO = ''5946673''
			      ) 
			';
				EXECUTE IMMEDIATE V_SQL;
		
			DBMS_OUTPUT.PUT_LINE('Modificado el propietario '''||PRO_NOMBRE||''' de la ACT_PAC_PROPIETARIO');			

		
			ELSE
				DBMS_OUTPUT.PUT_LINE('El propietario '''||PRO_NOMBRE||''' ya existia');
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


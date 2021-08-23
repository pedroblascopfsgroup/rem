--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210817
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.6
--## INCIDENCIA_LINK=REMVIP-10316
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-10316';

	PRO_DOCIDENTIF VARCHAR2(55 CHAR);
	PRO_NOMBRE VARCHAR2(55 CHAR);
	
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV('114916')
	); 
V_TMP_JBV T_JBV;
BEGIN

 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
			  PRO_DOCIDENTIF := TRIM(V_TMP_JBV(1));
	

			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                                JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION LOC ON LOC.BIE_ID=ACT.BIE_ID AND LOC.BORRADO = 0
								WHERE ACT.ACT_NUM_ACTIVO = '''||PRO_DOCIDENTIF||''' AND ACT.BORRADO = 0 ' INTO V_COUNT;
								
			IF V_COUNT = 1 THEN 		

            EXECUTE IMMEDIATE 'SELECT LOC.BIE_LOC_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                                JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION LOC ON LOC.BIE_ID=ACT.BIE_ID AND LOC.BORRADO = 0
								WHERE ACT.ACT_NUM_ACTIVO = '''||PRO_DOCIDENTIF||''' AND ACT.BORRADO = 0 ' INTO V_COUNT;		

				V_SQL := 'UPDATE '|| V_ESQUEMA ||'.BIE_LOCALIZACION
                    SET BIE_LOC_PUERTA = ''G3'',
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE BIE_LOC_ID = '||V_COUNT||'
			        ';
				EXECUTE IMMEDIATE V_SQL;
		
			DBMS_OUTPUT.PUT_LINE('Actualizado el ACTIVO '''||PRO_DOCIDENTIF||'''');	

		
			ELSE
				DBMS_OUTPUT.PUT_LINE('El ACTIVO '''||PRO_DOCIDENTIF||''' NO EXISTE ');
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

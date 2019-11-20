--/*
--#########################################
--## AUTOR=DAVID GARCÍA
--## FECHA_CREACION=20190625
--## ARTEFACTO=WEB 
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6680
--## PRODUCTO=NO
--## 
--## Finalidad:  INSERTAR DOS NUEVOS PROPIETARIOS EN LA TABLA ACT_PRO_PROPIETARIO
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
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-6680';
	V_DD_CARTERA_CODIGO VARCHAR2(55 CHAR);
	V_PRO_NOMBRE VARCHAR2(55 CHAR);
	
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV('Refacturación Sareb','02')
		, T_JBV('Central técnica Bankia','03')
	); 
V_TMP_JBV T_JBV;
BEGIN

 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
 			  V_PRO_NOMBRE := TRIM(V_TMP_JBV(1));
			  V_DD_CARTERA_CODIGO := TRIM(V_TMP_JBV(2));
				
	

			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO 
								WHERE PRO_NOMBRE = '''||V_PRO_NOMBRE||'''' INTO V_COUNT;
								
			IF V_COUNT = 0 THEN 								
				V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO (
				  PRO_ID
				, FECHACREAR
				, USUARIOCREAR
				, PRO_NOMBRE
				, DD_CRA_ID
				) VALUES (
				 '||V_ESQUEMA||'.S_ACT_PRO_PROPIETARIO.NEXTVAL
				, SYSDATE
				, '''||V_USUARIO||'''
				, '''||V_PRO_NOMBRE||'''
				, (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO =  '''||V_DD_CARTERA_CODIGO||''')
				)
			';
				EXECUTE IMMEDIATE V_SQL;
		
			DBMS_OUTPUT.PUT_LINE('Insertado el propietario '''||V_PRO_NOMBRE||'''');			
		
			ELSE
				DBMS_OUTPUT.PUT_LINE('El propietario '''||V_PRO_NOMBRE||''' ya existia');
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


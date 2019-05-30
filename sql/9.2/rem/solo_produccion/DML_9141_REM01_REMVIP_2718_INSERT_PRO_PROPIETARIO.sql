--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20180612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-2718
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2718';
    V_ID VARCHAR2(32 CHAR); -- Variable auxiliar

	PRO_DOCIDENTIF VARCHAR2(55 CHAR);
	PRO_NOMBRE VARCHAR2(55 CHAR);
	
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV('FONDO DE TITULIZACION DE ACTIVOS','V84925569')
	); 
V_TMP_JBV T_JBV;
BEGIN

 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
 			  PRO_NOMBRE := TRIM(V_TMP_JBV(1));
			  PRO_DOCIDENTIF := TRIM(V_TMP_JBV(2));
	

			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO 
								WHERE PRO_DOCIDENTIF = '''||PRO_DOCIDENTIF||'''' INTO V_COUNT;
								
			IF V_COUNT = 0 THEN 								
				V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO (
				  PRO_ID
				, FECHACREAR
				, USUARIOCREAR
				, PRO_DOCIDENTIF
				, PRO_NOMBRE
				) VALUES (
				 '||V_ESQUEMA||'.S_ACT_PRO_PROPIETARIO.NEXTVAL
				, SYSDATE
				, '''||V_USUARIO||'''
				, '''||PRO_DOCIDENTIF||'''
				, '''||PRO_NOMBRE||'''
				)
			';
				EXECUTE IMMEDIATE V_SQL;
		
			DBMS_OUTPUT.PUT_LINE('Insertado el propietario '''||PRO_NOMBRE||'''');			
		
			ELSE
				DBMS_OUTPUT.PUT_LINE('El propietario '''||PRO_NOMBRE||''' ya existia');
			END IF;
			
			
    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a insertar el propietario FONDO DE TITULIZACION DE ACTIVOS al activo 7004082.');

 END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO]: CREACIÓN REGISTRO EN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO' );

			V_SQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_PAC_PROPIETARIO_ACTIVO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_ID;	
          
			V_SQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO
				(PAC_ID
				,ACT_ID
				,PRO_ID
				,DD_TGP_ID
				,PAC_PORC_PROPIEDAD
				,VERSION
				,USUARIOCREAR
				,FECHACREAR
				,BORRADO
				)
				SELECT '|| V_ID ||'
				, (SELECT ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 7004082)
				, (SELECT PRO_ID FROM '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''V84925569'')
				, (SELECT DD_TGP_ID FROM '|| V_ESQUEMA ||'.DD_TGP_TIPO_GRADO_PROPIEDAD WHERE DD_TGP_DESCRIPCION = ''Pleno dominio'')
				, 100
				, 0
				, '''||V_USUARIO||'''
				, SYSDATE
				, 0 FROM DUAL
			';
			
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Insertado ' ||SQL%ROWCOUNT|| ' registro en ACT_PAC_PROPIETARIO_ACTIVO ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN DE SUBCARTERA EN EL ACTIVO 7004082' );

          V_SQL := '
			UPDATE '|| V_ESQUEMA ||'.ACT_ACTIVO
			SET DD_SCR_ID = ( SELECT SCR.DD_SCR_ID
					  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA, '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR
					  WHERE CRA.DD_CRA_ID = SCR.DD_CRA_ID
					  AND CRA.DD_CRA_CODIGO = ''03''
					  AND SCR.DD_SCR_CODIGO = ''09'' ),
			USUARIOMODIFICAR = ''' || V_USUARIO || ''',
			FECHAMODIFICAR   = SYSDATE
			WHERE ACT_NUM_ACTIVO = 7004082
		
			';



          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS ' ||SQL%ROWCOUNT|| ' ACTIVO ');			    
    
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


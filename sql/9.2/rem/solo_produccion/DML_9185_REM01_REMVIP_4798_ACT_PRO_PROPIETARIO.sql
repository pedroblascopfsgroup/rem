--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190712
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-4798
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-4798';
    V_NUM NUMBER(16); -- Variable auxiliar
    V_ID VARCHAR2( 16 CHAR );	

  CURSOR C_ACTIVOS IS 
	
		SELECT DISTINCT ACT_ID
		FROM REM01.ACT_AGA_AGRUPACION_ACTIVO AGA, REM01.ACT_AGR_AGRUPACION AGR
		WHERE 1 = 1
		AND AGA.AGR_ID = AGR.AGR_ID
		AND AGR.AGR_NUM_AGRUP_REM = '1000006500' 
		AND NOT EXISTS ( SELECT 1 
				 FROM REM01.ACT_PAC_PROPIETARIO_ACTIVO PAC
				 WHERE PAC.ACT_ID = AGA.ACT_ID
				);	

    FILA C_ACTIVOS%ROWTYPE;

	
BEGIN


    DBMS_OUTPUT.PUT_LINE('[INFO]: CREACIÓN REGISTRO EN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO' );
	V_NUM := 0;

	OPEN C_ACTIVOS;
		
	LOOP

  			FETCH C_ACTIVOS INTO FILA;
  			EXIT WHEN C_ACTIVOS%NOTFOUND;

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
				, ' || FILA.ACT_ID || '
				, (SELECT PRO_ID FROM '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''A96932629'' AND BORRADO = 0)
				, (SELECT DD_TGP_ID FROM '|| V_ESQUEMA ||'.DD_TGP_TIPO_GRADO_PROPIEDAD WHERE DD_TGP_DESCRIPCION = ''Pleno dominio'')
				, 100
				, 0
				, '''||V_USUARIO||'''
				, SYSDATE
				, 0 FROM DUAL
			';
			
			EXECUTE IMMEDIATE V_SQL;

	V_NUM := V_NUM + 1;    

	END LOOP;    

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Insertado ' || V_NUM || ' registros en ACT_PAC_PROPIETARIO_ACTIVO ');	    


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


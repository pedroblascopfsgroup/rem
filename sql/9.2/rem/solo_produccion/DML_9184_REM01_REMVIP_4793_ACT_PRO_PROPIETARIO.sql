--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190711
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-4793
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
	
BEGIN


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
				, (SELECT ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 7032118)
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


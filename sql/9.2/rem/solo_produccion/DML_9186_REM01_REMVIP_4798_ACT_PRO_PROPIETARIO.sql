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


	
BEGIN


    DBMS_OUTPUT.PUT_LINE('[INFO]: Modificar nombre en propietario A96932629 ' );



          
			V_SQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO 
				   SET PRO_NOMBRE = ''INMOCLEOP S.A.'',
				 	USUARIOMODIFICAR = ''REMVIP-4798'',
					FECHAMODIFICAR = SYSDATE	
				   WHERE PRO_DOCIDENTIF = ''A96932629'' AND BORRADO = 0 ' ;
			
			EXECUTE IMMEDIATE V_SQL;




	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Modificado propietario');	    


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


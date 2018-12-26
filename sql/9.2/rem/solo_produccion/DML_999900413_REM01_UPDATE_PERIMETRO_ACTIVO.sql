--/*
--#########################################
--## AUTOR=CARLES MOLINS
--## FECHA_CREACION=20181122
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2608
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar los nulos de los checks a 0 
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2608';

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso.');
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET 
			  PAC_CHECK_ASIGNAR_MEDIADOR = 0
			  WHERE PAC_CHECK_ASIGNAR_MEDIADOR IS NULL';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('Primer update terminado');

		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET 
			  PAC_CHECK_COMERCIALIZAR = 0
			  WHERE PAC_CHECK_COMERCIALIZAR IS NULL';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('Segundo update terminado');

		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET 
			  PAC_CHECK_FORMALIZAR = 0
			  WHERE PAC_CHECK_FORMALIZAR IS NULL';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('Tercer update terminado');

		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET 
			  PAC_CHECK_PUBLICAR = 0
			  WHERE PAC_CHECK_PUBLICAR IS NULL';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('Cuarto update terminado');

		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET 
			  PAC_CHECK_GESTIONAR = 0
			  WHERE PAC_CHECK_GESTIONAR IS NULL';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('Quinto update terminado');

		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET 
			  PAC_CHECK_TRA_ADMISION = 0
			  WHERE PAC_CHECK_TRA_ADMISION IS NULL';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('Sexto update terminado');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados nulos en los checks de la tabla ACT_PAC_PERIMETRO_ACTIVO');
		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso.');

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

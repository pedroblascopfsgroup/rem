--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso Canovas
--## FECHA_CREACION=20200818
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7974
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar fecha comunicacion
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-7974';
  V_COUNT NUMBER(16); -- Vble. para comprobar
  V_NUMERO_ACTIVO NUMBER(16) := '5939000';
  V_TABLA VARCHAR2(100 CHAR) := 'ACT_CMG_COMUNICACION_GENCAT';
	
  
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID=(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO='||V_NUMERO_ACTIVO||')';				
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 1 THEN

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
			SET CMG_FECHA_COMUNICACION = TO_DATE(''20/11/2019'', ''DD/MM/YYYY''),
			USUARIOMODIFICAR = '''||V_USUARIO||''',
			FECHAMODIFICAR = SYSDATE 
			WHERE ACT_ID=(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO='||V_NUMERO_ACTIVO||')';				
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.put_line('[INFO] Actualizado '||SQL%ROWCOUNT||' registros ');
	ELSE
		DBMS_OUTPUT.put_line('[INFO] El registro no existe ');
	END IF;
    COMMIT;
   
   	DBMS_OUTPUT.PUT_LINE('[FIN] ');

EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT

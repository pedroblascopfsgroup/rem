--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso Canovas
--## FECHA_CREACION=20200817
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7974
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar fecha comunicacion tarea
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.3 Version inicial
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
  V_NUMERO_TRAMITE NUMBER(16) := '591536';
  V_TABLA VARCHAR2(100 CHAR) := 'ACT_CMG_COMUNICACION_GENCAT';
  V_TEV_ID NUMBER(16); --Vble. Para almacenar el id del valor de la tarea externa
	
  
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

--Compruebo si existe el registro de la tarea gencat
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID=(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO='||V_NUMERO_ACTIVO||')';				
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 1 THEN
--compruebo si existe el tramite
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE WHERE TRA_ID='||V_NUMERO_TRAMITE||'';
	
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN
--Actualizo tabla ACT_CMG_COMUNICACION_GENCAT
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
				SET CMG_FECHA_COMUNICACION = TO_DATE(''20/11/2019'', ''DD/MM/YYYY''),
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE 
				WHERE ACT_ID=(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO='||V_NUMERO_ACTIVO||')';				
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.put_line('[INFO] CMG_FECHA_COMUNICACION ACTUALIZADA');
--Obtengo id del valor de la tarea externa

			V_MSQL :='SELECT tev.TEV_ID
				FROM REM01.act_tra_tramite tra
				join REM01.tac_tareas_activos tac on tra.tra_id = tac.tra_id
				join REM01.tex_tarea_externa tex on tex.tar_id = tac.tar_id
				join REM01.tev_tarea_externa_valor tev on tex.tex_id = tev.tex_id
				join REM01.tap_tarea_procedimiento tap on tap.tap_id = tex.tap_id
				where tra.tra_id = '||V_NUMERO_TRAMITE||' and tap.tap_codigo = ''T016_ComunicarGENCAT''
				and tev_nombre = ''fechaComunicacion''';

			EXECUTE IMMEDIATE V_MSQL INTO V_TEV_ID;
--Actualizo la fecha de comunicacion de la tabla valor tarea externa

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR 
				SET TEV_VALOR=''20/11/2019'',
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE
				WHERE TEV_ID='||V_TEV_ID||'';

			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.put_line('[INFO] ACTUALIZADA FECHA COMUNICACION, TAREA EXTERNA VALOR,TEV_TAREA_EXTERNA_VALOR');

			DBMS_OUTPUT.put_line('[INFO] Actualizado '||SQL%ROWCOUNT||' registros ');
		ELSE
			DBMS_OUTPUT.put_line('[INFO] NO EXISTE EL TRAMITE ');
		END IF;
	ELSE
		DBMS_OUTPUT.put_line('[INFO] LA TAREA NO EXISTE ');
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

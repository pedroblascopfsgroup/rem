--/*
--###########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180725
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1246
--## PRODUCTO=NO
--## 
--## Finalidad: Arreglar las tareas del activo 5939540
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1246';
  V_TABLA_TAR VARCHAR2(50 CHAR) := 'TAR_TAREAS_NOTIFICACIONES';
  V_TABLA_TEX VARCHAR2(50 CHAR) := 'TEX_TAREA_EXTERNA';
  V_TABLA_TAP VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';
  V_TABLA_TAC VARCHAR2(50 CHAR) := 'TAC_TAREAS_ACTIVOS';
  V_TABLA_ACT VARCHAR2(50 CHAR) := 'ACT_ACTIVO';
  V_TABLA_ETN VARCHAR2(50 CHAR) := 'ETN_EXTAREAS_NOTIFICACIONES';
  V_TABLA_USUARIOS VARCHAR2(50 CHAR) := 'USU_USUARIOS';

  V_COUNT NUMBER(16);
  V_ID NUMBER(16);
  V_ACT_ID NUMBER;
  V_USU_ID NUMBER;
  V_SUP_ID NUMBER;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
	
	V_SQL := 'SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_SQL INTO V_ID;
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAR||'(FECHACREAR,
															USUARIOCREAR,
															TAR_ID,
															DD_EIN_ID,
															DD_STA_ID,
															TAR_CODIGO,
															TAR_TAREA,
															TAR_DESCRIPCION,
															TAR_FECHA_INI,
															TAR_FECHA_VENC)
															
				VALUES(
					SYSDATE,
					'''||V_USUARIO||''',
					'||V_ID||',
					1,
					839,
					''1'',
					''Pendiente de la devolución'',
					''Pendiente de la devolución'',
					SYSDATE,
					SYSDATE +3
				)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('Insertados '||SQL%ROWCOUNT||' registros en la TAR_TAREAS_NOTIFICACIONES');
	
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TEX||' (
					TEX_ID,
					FECHACREAR,
					USUARIOCREAR,
					TAR_ID,
					TAP_ID
				)
					
					SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL,
					SYSDATE,
					'''||V_USUARIO||''',
					'||V_ID||',
					10000000004842
					FROM DUAL
					';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('Insertados '||SQL%ROWCOUNT||' registros en la TEX_TAREA_EXTERNA');
				
	V_SQL := 'SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT WHERE ACT.ACT_NUM_ACTIVO = 5939540';
	EXECUTE IMMEDIATE V_SQL INTO V_ACT_ID;
	
	V_SQL := 'SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.'||V_TABLA_USUARIOS||' USU WHERE USU.USU_USERNAME = ''afraile''';
	EXECUTE IMMEDIATE V_SQL INTO V_USU_ID;
	
	V_SQL := 'SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.'||V_TABLA_USUARIOS||' USU WHERE USU.USU_USERNAME = ''emaurizot''';
	EXECUTE IMMEDIATE V_SQL INTO V_SUP_ID;
	
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAC||' (
			TAR_ID,
			TRA_ID,
			ACT_ID,
			USU_ID,
			SUP_ID,
			USUARIOCREAR,
			FECHACREAR
			)
			VALUES(
				'||V_ID||',
				158871,
				'||V_ACT_ID||',
				'||V_USU_ID||',
				'||V_SUP_ID||',
				'''||V_USUARIO||''',
				SYSDATE
			)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('Insertados '||SQL%ROWCOUNT||' registros en la TAC_TAREAS_ACTIVOS');
    
   
   
   
   
   V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ETN||' (
			TAR_ID,
			TAR_FECHA_VENC_REAL
			)
			SELECT TAR_ID,
			TAR_FECHA_VENC
			FROM '||V_ESQUEMA||'.'||V_TABLA_TAR||' WHERE TAR_ID = '||V_ID||'
			';

   EXECUTE IMMEDIATE V_SQL;
   DBMS_OUTPUT.PUT_LINE('Insertados '||SQL%ROWCOUNT||' registros en la ETN_EXTAREAS_NOTIFICACIONES');
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
   
   
   
   COMMIT;
 

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

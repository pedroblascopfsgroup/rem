--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20160317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-565
--## PRODUCTO=SI
--##
--## Finalidad: Creación del PL/SQL de CÁLCULO DE NOTIFICACIONES POR ENTRADA DE CONTRATO DE EXPEDIENTE EN IRREGULAR
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--## 	    0.2 EJD:> Cambio sobre la query C_CONSULTA que incluye " max(mov_pos_viva_vencida) ", también retorno resultado.
--## 	    0.3 EJD:> Cambio sobre la query C_CONSULTA que incluye DD_EST_ID, que será el que se informe en la Tarea Notificación.
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE EXP_SALDO_IRREGULAR (RESULT_EXE OUT VARCHAR2 ) AUTHID CURRENT_USER IS

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_SQL_INSERT VARCHAR2(4000 CHAR)  := 'INSERT INTO #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_INI, TAR_EMISOR, USUARIOCREAR, FECHACREAR) ' ||
		' VALUES (#ESQUEMA#.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL, :1, :2, :3, :4, :5, :6, :7, SYSDATE, :8, :9, SYSDATE) ';

	CURSOR C_CONSULTA IS
		select exp.exp_id EXP_ID, exp.DD_EST_ID DD_EST_ID
		from #ESQUEMA#.exp_expedientes exp inner join
		#ESQUEMA#.cex_contratos_expediente cex on cex.exp_id = exp.exp_id inner join
		#ESQUEMA#.mov_movimientos mov on mov.cnt_id = cex.cnt_id and mov.MOV_FECHA_EXTRACCION = (select max(mov_fecha_extraccion) from #ESQUEMA#.mov_movimientos)
		where
		mov.MOV_FECHA_EXTRACCION > exp.fechacrear and 
		mov.mov_pos_viva_vencida > 0 and
		(select max(movi.mov_pos_viva_vencida) 
		from #ESQUEMA#.mov_movimientos movi 
		where movi.cnt_id = cex.cnt_id and
		movi.MOV_FECHA_EXTRACCION < mov.MOV_FECHA_EXTRACCION) = 0;
	V_CONS C_CONSULTA%ROWTYPE;

	V_DD_EST_ID NUMBER(16,0);
	V_DD_EIN_ID NUMBER(16,0);
	V_DD_STA_ID NUMBER(16,0);

	V_TAR_CODIGO VARCHAR2(100 CHAR) := '3';
	V_TAR_TAREA  VARCHAR2(100 CHAR) := 'Nuevo contrato impagado en expediente';
	V_TAR_DESCRIPCION VARCHAR2(4000 CHAR) := 'Nuevo contrato impagado en expediente';
	V_TAR_EMISOR VARCHAR2(50 CHAR) := 'AUTOMATICO';
	V_USUARIOCREAR VARCHAR2(50 CHAR) := 'PRODUCTO-565';

BEGIN 

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||' -----.... ' );
    
	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base WHERE DD_STA_CODIGO = ''1000''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    IF V_NUM_TABLAS = 0 THEN            
        V_SQL := 'insert into '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base
          (dd_sta_id, dd_tar_id, dd_sta_codigo, dd_sta_descripcion, dd_sta_descripcion_larga, fechacrear, usuariocrear, dd_sta_gestor)
        values
          ('||V_ESQUEMA_M||'.s_dd_sta_subtipo_tarea_base.nextval, 3, ''1000'', ''Notificación Nuevo contrato impagado en expediente'', ''Notificación Nuevo contrato impagado en expediente'', sysdate, ''SAG'',1)';
        EXECUTE IMMEDIATE V_SQL ; 
	RESULT_EXE := 'Insercción en dd_sta_subtipo_tarea_base Codigo 1000, realizada';
   END IF;
 
   -- V_SQL := ' SELECT DD_EST_ID FROM ' || V_ESQUEMA_M || '.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO=''CMER'' ';
   -- EXECUTE IMMEDIATE V_SQL INTO V_DD_EST_ID;
   V_SQL := ' SELECT DD_EIN_ID FROM ' || V_ESQUEMA_M || '.DD_EIN_ENTIDAD_INFORMACION WHERE DD_EIN_DESCRIPCION=''Expediente'' ';
   EXECUTE IMMEDIATE V_SQL INTO V_DD_EIN_ID;
   V_SQL := ' SELECT DD_STA_ID FROM ' || V_ESQUEMA_M || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''1000'' ';
   EXECUTE IMMEDIATE V_SQL INTO V_DD_STA_ID;

   -- Cambio de gestores que entran como sustitutos
   OPEN C_CONSULTA;
   LOOP
    	FETCH C_CONSULTA INTO V_CONS;
		EXIT WHEN C_CONSULTA%NOTFOUND;
		EXECUTE IMMEDIATE V_SQL_INSERT USING V_CONS.EXP_ID, V_CONS.DD_EST_ID, V_DD_EIN_ID, V_DD_STA_ID, V_TAR_CODIGO, V_TAR_TAREA, V_TAR_DESCRIPCION, V_TAR_EMISOR, V_USUARIOCREAR;
		DBMS_OUTPUT.PUT_LINE('CREADA NOTIFICACION PARA EXPEDIENTE: ' || V_CONS.EXP_ID||' En estado: '||V_CONS.DD_EST_ID);
    END LOOP;

    COMMIT;
    RESULT_EXE := RESULT_EXE||'| Insercción en TAR_TAREAS_NOTIFICACIONES de las notificaciones, realizadas';

    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||' -----.... ' );
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
	  RESULT_EXE := 'Error:'||TO_CHAR(ERR_NUM)||'['||ERR_MSG||']';
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

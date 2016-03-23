--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20160322
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-2747
--## PRODUCTO=NO
--##
--## Finalidad: Creación del PL/SQL de CÁLCULO DE NOTIFICACIONES POR ENTRADA DE CLIENTE EN SCORING MUY GRAVE
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE EXP_SCORING_MUY_GRAVE (RESULT_EXE OUT VARCHAR2 ) AUTHID CURRENT_USER IS

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REGS NUMBER(16);   
    V_NUM_REGS2 NUMBER(16);   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_SQL_INSERT VARCHAR2(4000 CHAR)  := 'INSERT INTO #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_INI, TAR_EMISOR, USUARIOCREAR, FECHACREAR) ' ||
		' VALUES (#ESQUEMA#.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL, :1, :2, :3, :4, :5, :6, :7, SYSDATE, :8, :9, SYSDATE) ';

	V_SQL_CONSULTA_PUNT_PREVIA VARCHAR2(4000 CHAR) := 'SELECT COUNT(*) FROM #ESQUEMA#.PTO_PUNTUACION_TOTAL WHERE PTO_PUNTUACION<=500 AND PTO_FECHA_PROCESADO<:1 AND PER_ID=:2';
	V_SQL_CONSULTA_NO_EXISTE   VARCHAR2(4000 CHAR) := 'SELECT COUNT(*) FROM #ESQUEMA#.PTO_PUNTUACION_TOTAL WHERE PTO_FECHA_PROCESADO<:1 AND PER_ID=:2';
	
	CURSOR C_CONSULTA IS
		SELECT exp.exp_id, exp.dd_est_id, pto.pto_fecha_procesado, per.per_id
			FROM #ESQUEMA#.per_personas per 
			inner join #ESQUEMA#.pex_personas_expediente pex on per.per_id= pex.per_id
			inner join #ESQUEMA#.exp_expedientes exp on exp.exp_id= pex.exp_id
			inner join #ESQUEMA#.arq_arquetipos arq on arq.arq_id=exp.arq_id
			inner join #ESQUEMA#.iti_itinerarios iti on iti.iti_id= arq.iti_id
			inner join #ESQUEMA_MASTER#.dd_tit_tipo_itinerarios tit on tit.dd_tit_id=iti.dd_tit_id
		    inner join #ESQUEMA#.pto_puntuacion_total pto on pto.per_id=per.per_id
			where tit.dd_tit_codigo='SIS' 
			and pto.pto_puntuacion>500
			and pto.pto_fecha_procesado = (SELECT NVL(MAX(pto_fecha_procesado),TO_DATE('01/01/1990')) 
				from #ESQUEMA#.pto_puntuacion_total pto2 where pto2.per_id=per.per_id)
			;
	V_CONS C_CONSULTA%ROWTYPE;

	V_DD_EST_ID NUMBER(16,0);
	V_DD_EIN_ID NUMBER(16,0);
	V_DD_STA_ID NUMBER(16,0);

	V_TAR_CODIGO VARCHAR2(100 CHAR) := '3';
	V_TAR_TAREA  VARCHAR2(100 CHAR) := 'Cliente de Pase presenta Puntuación de Alertas Muy Grave';
	V_TAR_DESCRIPCION VARCHAR2(4000 CHAR) := 'Atención: Expediente de Seguimiento Sistemático, cliente de pase presenta puntuación de Alertas Muy Grave';
	V_TAR_EMISOR VARCHAR2(50 CHAR) := 'AUTOMATICO';
	V_USUARIOCREAR VARCHAR2(50 CHAR) := 'CMREC-2747';

BEGIN 

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||' -----.... ' );
    
	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base WHERE DD_STA_CODIGO = ''999''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGS;    
    IF V_NUM_REGS = 0 THEN            
        V_SQL := 'insert into '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base
          (dd_sta_id, dd_tar_id, dd_sta_codigo, dd_sta_descripcion, dd_sta_descripcion_larga, fechacrear, usuariocrear, dd_sta_gestor)
        values
          ('||V_ESQUEMA_M||'.s_dd_sta_subtipo_tarea_base.nextval, 3, ''999'', ''Cliente de Pase presenta Puntuación de Alertas Muy Grave'', ''Atención: Expediente de Seguimiento Sistemático, cliente de pase presenta puntuación de Alertas Muy Grave'', sysdate, ''CMREC-2747'',1)';
        EXECUTE IMMEDIATE V_SQL ; 
	RESULT_EXE := 'Inserción en dd_sta_subtipo_tarea_base Codigo 999, realizada';
   END IF;
 
   V_SQL := ' SELECT DD_EIN_ID FROM ' || V_ESQUEMA_M || '.DD_EIN_ENTIDAD_INFORMACION WHERE DD_EIN_DESCRIPCION=''Expediente'' ';
   EXECUTE IMMEDIATE V_SQL INTO V_DD_EIN_ID;
   V_SQL := ' SELECT DD_STA_ID FROM ' || V_ESQUEMA_M || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''999'' ';
   EXECUTE IMMEDIATE V_SQL INTO V_DD_STA_ID;

   -- Cambio de gestores que entran como sustitutos
   OPEN C_CONSULTA;
   LOOP
    	FETCH C_CONSULTA INTO V_CONS;
		EXIT WHEN C_CONSULTA%NOTFOUND;
		EXECUTE IMMEDIATE V_SQL_CONSULTA_NO_EXISTE INTO V_NUM_REGS2 USING V_CONS.pto_fecha_procesado, V_CONS.per_id;
		EXECUTE IMMEDIATE V_SQL_CONSULTA_PUNT_PREVIA INTO V_NUM_REGS USING V_CONS.pto_fecha_procesado, V_CONS.per_id;
		IF V_NUM_REGS2 = 0 OR V_NUM_REGS > 0 THEN 
			EXECUTE IMMEDIATE V_SQL_INSERT USING V_CONS.EXP_ID, V_CONS.DD_EST_ID, V_DD_EIN_ID, V_DD_STA_ID, V_TAR_CODIGO, V_TAR_TAREA, V_TAR_DESCRIPCION, V_TAR_EMISOR, V_USUARIOCREAR;
			DBMS_OUTPUT.PUT_LINE('CREADA NOTIFICACION PARA EXPEDIENTE: ' || V_CONS.EXP_ID||' En estado: '||V_CONS.DD_EST_ID);
		END IF;
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

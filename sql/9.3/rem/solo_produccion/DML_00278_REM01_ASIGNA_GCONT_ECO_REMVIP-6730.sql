--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200427
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6730
--## PRODUCTO=NO
--## 
--## Finalidad: ASIGNAR GESTOR GCONT A LOS EXPEDIENTES ACTIVOS Y LAS TAREAS CIERRE ECONOMICO ACTIVAS
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_INCIDENCIA VARCHAR2(25 CHAR) := 'REMVIP-6730';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grucontroller''),
			USUARIOMODIFICAR = '''||V_INCIDENCIA||''', FECHAMODIFICAR = SYSDATE 
			WHERE TAR_ID IN (SELECT DISTINCT TAC.TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR 
				INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID AND TEX.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TAR_ID = TAR.TAR_ID AND TAC.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID AND TRA.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.TBJ_ID = TRA.TBJ_ID AND ECO.BORRADO = 0 
				WHERE TAR.TAR_TAREA_FINALIZADA = 0 AND TAR.BORRADO = 0 AND TAP.TAP_CODIGO IN (''T013_CierreEconomico'',''T017_CierreEconomico'')
				AND ECO.ECO_NUM_EXPEDIENTE IN (192421,
173274,
195368,
198071,
196900,
198397,
198105,
190483,
166796,
185081,
174866,
190123,
189094,
195511,
194772,
195552,
184967,
194407,
193262,
193682,
195868,
185715,
191075,
193134,
196883,
196739,
197173,
197129,
193559,
196775,
197336,
194111,
196774,
196791,
191382,
194683,
195624,
196523,
196168,
184418,
189183,
197980,
199412,
199420,
200002,
195157,
198618,
197948,
194179,
196583,
196405,
197192,
197699,
194971,
183481,
198715,
194815,
198693,
194736,
191641,
199031,
196196,
197035,
196322,
196524,
198823,
198701,
188655,
194771,
191234,
192472,
200251,
187537,
190102,
191381,
191534,
197795,
194365,
195514,
196000,
190737,
193221,
195529,
196248,
196596,
175703,
188913,
190481,
194059,
196494,
192355,
168307,
195424,
186143,
191587,
175474,
194121,
193504,
195308,
198152,
196672,
197024,
199141,
191354,
190952,
190893,
192392,
192606,
194300,
189902,
185025,
187504,
186485,
186222,
190170,
193165,
190138,
195683,
189215,
197348,
195726,
195115,
196828,
188366,
193237,
193242,
194255,
192930,
195190,
195095,
191642,
194142,
196831,
192646,
185809))';
				
	EXECUTE IMMEDIATE V_MSQL;	
	
    COMMIT;   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

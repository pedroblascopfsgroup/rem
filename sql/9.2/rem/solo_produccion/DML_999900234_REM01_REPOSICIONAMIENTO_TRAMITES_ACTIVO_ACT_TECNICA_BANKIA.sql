--/*
--#########################################
--## AUTOR=Sergio Belenguer Gadea
--## FECHA_CREACION=20180130
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.10
--## INCIDENCIA_LINK=HREOS-3731
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de borrado físico de ciertas tablas
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

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-3731';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    COUNTER NUMBER(2);
    COD_ITEM VARCHAR2(50 CHAR) := 'HREOS-3731';
    V_TABLA_REP VARCHAR2(30 CHAR) := 'OFERTAS_REPOSICIONAR';
    V_TABLA VARCHAR2(40 CHAR) := 'MIG2_TRAMITES_OFERTAS_REP'; -- Vble. Tabla pivote
    V_OFR_ID NUMBER(16) := 0; -- Vble. para almacenar el OFR_ID
    V_PVC_ID NUMBER(16) := 0; -- Vble. para almacenar el PVC_ID
    V_EXISTE_GASTO NUMBER(16);
    S_TBJ NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_ID
    S_NUM NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_NUM_TRABAJO
    S_TRA NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TRA_ID
    S_TAR NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TAR_ID
    S_TEX NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TEX_ID
    PL_OUTPUT VARCHAR2(32000 CHAR) := NULL;
    CURSOR CURSOR_OFERTAS IS
    SELECT DISTINCT TRA_ID FROM REM01.MIG2_TRAMITES_OFERTAS_REP TRA;
    V_TABLA_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';
    V_TABLA_ACT_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ';
    V_TABLA_ECO VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
    V_TABLA_TRA VARCHAR2(30 CHAR) := 'ACT_TRA_TRAMITE';
    V_TABLA_TAR VARCHAR2(30 CHAR) := 'TAR_TAREAS_NOTIFICACIONES';
    V_TABLA_ETN VARCHAR2(30 CHAR) := 'ETN_EXTAREAS_NOTIFICACIONES';
    V_TABLA_TEX VARCHAR2(30 CHAR) := 'TEX_TAREA_EXTERNA';
    V_TABLA_TAC VARCHAR2(30 CHAR) := 'TAC_TAREAS_ACTIVOS';
    V_UPDATE NUMBER(16);

    TYPE T_TRAMITE_ACT_TEC IS TABLE OF VARCHAR2(500 CHAR);
    TYPE T_ARRAY IS TABLE OF T_TRAMITE_ACT_TEC;
    V_TRAMITE_ACT_TEC T_ARRAY := T_ARRAY(
	--(act_num_activo,tra_id,pve_id,usu_id)
	T_TRAMITE_ACT_TEC(5927028,47494,25276, 44015),
	T_TRAMITE_ACT_TEC(5969785,50594,25276, 44015),
	T_TRAMITE_ACT_TEC(5937052,41475,25276, 44015),
	T_TRAMITE_ACT_TEC(5962317,41629,25276, 44015),
	T_TRAMITE_ACT_TEC(5947484,41792,25276, 44015),
	T_TRAMITE_ACT_TEC(5964975,41860,25276, 44015),
	T_TRAMITE_ACT_TEC(5948914,41913,25276, 44015),
	T_TRAMITE_ACT_TEC(5927807,42080,25276, 44015),
	T_TRAMITE_ACT_TEC(5928593,42413,25276, 44015),
	T_TRAMITE_ACT_TEC(5957509,42487,25276, 44015),
	T_TRAMITE_ACT_TEC(5939484,42758,25276, 44015),
	T_TRAMITE_ACT_TEC(5957213,42817,25276, 44015),
	T_TRAMITE_ACT_TEC(5939869,42910,25276, 44015),
	T_TRAMITE_ACT_TEC(5943873,43052,25276, 44015),
	T_TRAMITE_ACT_TEC(5953946,43079,25276, 44015),
	T_TRAMITE_ACT_TEC(5967140,43205,25276, 44015),
	T_TRAMITE_ACT_TEC(5967140,43206,25276, 44015),
	T_TRAMITE_ACT_TEC(5956677,43352,25276, 44015),
	T_TRAMITE_ACT_TEC(5938678,43399,25276, 44015),
	T_TRAMITE_ACT_TEC(5938678,43400,25276, 44015),
	T_TRAMITE_ACT_TEC(5951406,43428,25276, 44015),
	T_TRAMITE_ACT_TEC(6061034,43464,25276, 44015),
	T_TRAMITE_ACT_TEC(5925421,43553,25276, 44015),
	T_TRAMITE_ACT_TEC(5937052,43943,25276, 44015),
	T_TRAMITE_ACT_TEC(5967805,44015,25276, 44015),
	T_TRAMITE_ACT_TEC(5964203,44454,25276, 44015),
	T_TRAMITE_ACT_TEC(5940342,44473,25276, 44015),
	T_TRAMITE_ACT_TEC(5966112,44541,25276, 44015),
	T_TRAMITE_ACT_TEC(5944937,44551,25276, 44015),
	T_TRAMITE_ACT_TEC(5944937,44552,25276, 44015),
	T_TRAMITE_ACT_TEC(5965740,44569,25276, 44015),
	T_TRAMITE_ACT_TEC(5968846,44637,25276, 44015),
	T_TRAMITE_ACT_TEC(5927168,44717,25276, 44015),
	T_TRAMITE_ACT_TEC(5930379,44773,25276, 44015),
	T_TRAMITE_ACT_TEC(5935834,44855,25276, 44015),
	T_TRAMITE_ACT_TEC(5947548,44884,25276, 44015),
	T_TRAMITE_ACT_TEC(5954662,45211,25276, 44015),
	T_TRAMITE_ACT_TEC(5954662,45212,25276, 44015),
	T_TRAMITE_ACT_TEC(5953383,45422,25276, 44015),
	T_TRAMITE_ACT_TEC(5951052,45552,25276, 44015),
	T_TRAMITE_ACT_TEC(5942485,45643,25276, 44015),
	T_TRAMITE_ACT_TEC(6780508,46083,25276, 44015),
	T_TRAMITE_ACT_TEC(5937052,46406,25276, 44015),
	T_TRAMITE_ACT_TEC(5957292,46467,25276, 44015),
	T_TRAMITE_ACT_TEC(5927563,46663,25276, 44015),
	T_TRAMITE_ACT_TEC(5970457,47286,25276, 44015),
	T_TRAMITE_ACT_TEC(5942191,47716,25276, 44015),
	T_TRAMITE_ACT_TEC(5968189,47728,25276, 44015),
	T_TRAMITE_ACT_TEC(6044836,47904,25276, 44015),
	T_TRAMITE_ACT_TEC(5966504,47959,25276, 44015),
	T_TRAMITE_ACT_TEC(5940457,48098,25276, 44015),
	T_TRAMITE_ACT_TEC(5935137,48162,25276, 44015),
	T_TRAMITE_ACT_TEC(5938678,48316,25276, 44015),
	T_TRAMITE_ACT_TEC(5954231,48772,25276, 44015),
	T_TRAMITE_ACT_TEC(5938643,48821,25276, 44015),
	T_TRAMITE_ACT_TEC(5950417,48850,25276, 44015),
	T_TRAMITE_ACT_TEC(5950417,48851,25276, 44015),
	T_TRAMITE_ACT_TEC(5966712,49049,25276, 44015),
	T_TRAMITE_ACT_TEC(5929765,49305,25276, 44015),
	T_TRAMITE_ACT_TEC(5939056,49644,25276, 44015),
	T_TRAMITE_ACT_TEC(5961569,49662,25276, 44015),
	T_TRAMITE_ACT_TEC(5930379,49709,25276, 44015),
	T_TRAMITE_ACT_TEC(5928593,49812,25276, 44015),
	T_TRAMITE_ACT_TEC(5952009,49912,25276, 44015),
	T_TRAMITE_ACT_TEC(5939869,50326,25276, 44015),
	T_TRAMITE_ACT_TEC(5929103,50696,25276, 44015),
	T_TRAMITE_ACT_TEC(5930827,50713,25276, 44015),
	T_TRAMITE_ACT_TEC(5963346,50809,25276, 44015),
	T_TRAMITE_ACT_TEC(5969863,51165,25276, 44015),
	T_TRAMITE_ACT_TEC(5936338,51324,25276, 44015),
	T_TRAMITE_ACT_TEC(5950417,51390,25276, 44015),
	T_TRAMITE_ACT_TEC(5929140,51393,25276, 44015),
	T_TRAMITE_ACT_TEC(5927234,51782,25276, 44015),
	T_TRAMITE_ACT_TEC(5954538,51895,25276, 44015),
	T_TRAMITE_ACT_TEC(5939809,51907,25276, 44015),
	T_TRAMITE_ACT_TEC(5964203,51928,25276, 44015),
	T_TRAMITE_ACT_TEC(5928069,52197,25276, 44015),
	T_TRAMITE_ACT_TEC(5939311,52301,25276, 44015),
	T_TRAMITE_ACT_TEC(5966659,52637,25276, 44015),
	T_TRAMITE_ACT_TEC(5929723,52863,25276, 44015),
	T_TRAMITE_ACT_TEC(5966540,52870,25276, 44015),
	T_TRAMITE_ACT_TEC(5937008,52958,25276, 44015),
	T_TRAMITE_ACT_TEC(6706119,53522,25276, 44015),
	T_TRAMITE_ACT_TEC(5967654,53601,25276, 44015),
	T_TRAMITE_ACT_TEC(5959796,53674,25276, 44015),
	T_TRAMITE_ACT_TEC(5949550,53915,25276, 44015),
	T_TRAMITE_ACT_TEC(5954538,54358,25276, 44015),
	T_TRAMITE_ACT_TEC(5932179,54423,25276, 44015),
	T_TRAMITE_ACT_TEC(5937795,54579,25276, 44015),
	T_TRAMITE_ACT_TEC(5935239,54760,25276, 44015),
	T_TRAMITE_ACT_TEC(5946140,54890,25276, 44015),
	T_TRAMITE_ACT_TEC(5951338,54989,25276, 44015),
	T_TRAMITE_ACT_TEC(5935057,55019,25276, 44015),
	T_TRAMITE_ACT_TEC(5933051,55195,25276, 44015),
	T_TRAMITE_ACT_TEC(5953946,55470,25276, 44015),
	T_TRAMITE_ACT_TEC(5940457,55563,25276, 44015),
	T_TRAMITE_ACT_TEC(5958847,55668,25276, 44015),
	T_TRAMITE_ACT_TEC(5964418,55702,25276, 44015),
	T_TRAMITE_ACT_TEC(5945584,56457,25276, 44015),
	T_TRAMITE_ACT_TEC(6128754,56501,25276, 44015),
	T_TRAMITE_ACT_TEC(5965708,56559,25276, 44015),
	T_TRAMITE_ACT_TEC(5931066,56604,25276, 44015),
	T_TRAMITE_ACT_TEC(5969614,56807,25276, 44015),
	T_TRAMITE_ACT_TEC(5927808,56823,19529, 39204),
	T_TRAMITE_ACT_TEC(5946271,57082,2884, 29602),
	T_TRAMITE_ACT_TEC(5954170,57143,2884, 29602),
	T_TRAMITE_ACT_TEC(5962465,57150,2884, 29602),
	T_TRAMITE_ACT_TEC(5933438,57297,2884, 29602),
	T_TRAMITE_ACT_TEC(5925617,57484,2884, 29602),
	T_TRAMITE_ACT_TEC(5934463,57630,2884, 29602),
	T_TRAMITE_ACT_TEC(5944762,57853,2884, 29602),
	T_TRAMITE_ACT_TEC(5937008,57869,2884, 29602),
	T_TRAMITE_ACT_TEC(5942175,58034,2884, 29602),
	T_TRAMITE_ACT_TEC(5966890,58544,2884, 29602),
	T_TRAMITE_ACT_TEC(5964762,58717,2884, 29602),
	T_TRAMITE_ACT_TEC(5954481,59073,2884, 29602),
	T_TRAMITE_ACT_TEC(5968519,59109,2884, 29602),
	T_TRAMITE_ACT_TEC(5967656,59125,2884, 29602),
	T_TRAMITE_ACT_TEC(5964975,59164,2884, 29602),
	T_TRAMITE_ACT_TEC(5941565,59275,2884, 29602),
	T_TRAMITE_ACT_TEC(5949010,59330,2884, 29602),
	T_TRAMITE_ACT_TEC(5940342,59332,2884, 29602),
	T_TRAMITE_ACT_TEC(5935239,59693,2884, 29602),
	T_TRAMITE_ACT_TEC(5961120,59802,2884, 29602),
	T_TRAMITE_ACT_TEC(5939303,59868,2884, 29602),
	T_TRAMITE_ACT_TEC(5938300,60610,2884, 29602),
	T_TRAMITE_ACT_TEC(5940913,60781,1124, 29807),
	T_TRAMITE_ACT_TEC(6344607,60936,1124, 29807)			
    );
    V_TMP_TRAMITE_ACT_TEC T_TRAMITE_ACT_TEC; 
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de reposicionamiento de trámites de ofertas.');    
    DBMS_OUTPUT.PUT_LINE('');
    
     V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Se ha vaciado la tabla OFERTAS_REPOSICIONAR');
    
    FOR I IN V_TRAMITE_ACT_TEC.FIRST .. V_TRAMITE_ACT_TEC.LAST
    	   LOOP
		V_TMP_TRAMITE_ACT_TEC := V_TRAMITE_ACT_TEC(I);
		V_MSQL := 'select count(1) from '||V_ESQUEMA||'.act_activo act
				inner join '||V_ESQUEMA||'.ACT_TBJ atb on atb.act_id=act.act_id and act.act_num_activo = '||V_TMP_TRAMITE_ACT_TEC(1)||'
				inner join '||V_ESQUEMA||'.ACT_TRA_TRAMITE tra on tra.tbj_id=atb.tbj_id and tra_id='||V_TMP_TRAMITE_ACT_TEC(2)||'
				inner join '||V_ESQUEMA||'.ACT_TBJ_TRABAJO tbj on atb.tbj_id=tbj.tbj_ID 
				inner join '||V_ESQUEMA||'.gpv_tbj gpt on gpt.TBJ_ID=tbj.TBJ_ID
				inner join '||V_ESQUEMA||'.gpv_gastos_proveedor gpv on gpt.gpv_id=gpv.GPV_ID and gpv.GPV_FECHA_EMISION is not null';
		EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_GASTO;
		IF(V_EXISTE_GASTO = 0) THEN
        	
			V_MSQL := 'SELECT PVC_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO WHERE PVE_ID = '||V_TMP_TRAMITE_ACT_TEC(3)||' AND USU_ID = '||V_TMP_TRAMITE_ACT_TEC(4);
			EXECUTE IMMEDIATE V_MSQL INTO V_PVC_ID;
			--INSERTAMOS LOS TRAMITES QUE NO TIENEN GASTO ASOCIADO CON FLAG "SOLOTRAMITE" A 0 PARA QUE BORRE TAMBIÉN EL TRABAJO
	    		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR (OFR_ID, ACT_ID, TBJ_ID, TAR_ID, TEX_ID, TRA_ID, PVC_ID,SOLOTRAMITE,USU_ID)
			    SELECT 0, ACT.ACT_ID, ATB.TBJ_ID, TAR.TAR_ID, TEX.TEX_ID, TRA.TRA_ID,'||V_PVC_ID||',0,'||V_TMP_TRAMITE_ACT_TEC(4)||'
			    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			    JOIN '||V_ESQUEMA||'.ACT_TBJ ATB ON ATB.ACT_ID = ACT.ACT_ID
			    JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ATB.TBJ_ID
			    JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID
			    LEFT JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
			    LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
			    LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
			    LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
			    WHERE ACT.ACT_NUM_ACTIVO = '||V_TMP_TRAMITE_ACT_TEC(1)||' AND TRA.TRA_ID = '||V_TMP_TRAMITE_ACT_TEC(2)||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('El activo '||V_TMP_TRAMITE_ACT_TEC(1)||' tendrá como destinatario en el trámite a '||V_TMP_TRAMITE_ACT_TEC(4));
		ELSE
			EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_TBJ||'
						SET DD_EST_ID = (SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''06'')
						WHERE exists (select 1 from '||V_ESQUEMA||'.act_activo act
								inner join '||V_ESQUEMA||'.ACT_TBJ atb on atb.act_id=act.act_id and act.act_num_activo = '||V_TMP_TRAMITE_ACT_TEC(1)||'
								inner join '||V_ESQUEMA||'.ACT_TRA_TRAMITE tra on tra.tbj_id=atb.tbj_id and tra_id='||V_TMP_TRAMITE_ACT_TEC(2)||'
								inner join '||V_ESQUEMA||'.ACT_TBJ_TRABAJO tbj on atb.tbj_id=tbj.tbj_ID 
								inner join '||V_ESQUEMA||'.gpv_tbj gpt on gpt.TBJ_ID=tbj.TBJ_ID
								inner join '||V_ESQUEMA||'.gpv_gastos_proveedor gpv on gpt.gpv_id=gpv.GPV_ID and gpv.GPV_FECHA_EMISION is not null)';
			
			--INSERTAMOS LOS TRAMITES QUE TIENEN GASTO ASOCIADO CON FLAG "SOLOTRAMITE" A 1 PARA QUE BORRE SÓLO EL TRÁMITE
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR (OFR_ID, ACT_ID, TBJ_ID, TAR_ID, TEX_ID, TRA_ID, PVC_ID,SOLOTRAMITE,USU_ID)
			    SELECT 0, ACT.ACT_ID, ATB.TBJ_ID, TAR.TAR_ID, TEX.TEX_ID, TRA.TRA_ID,'||V_PVC_ID||',1,'||V_TMP_TRAMITE_ACT_TEC(4)||'
			    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			    JOIN '||V_ESQUEMA||'.ACT_TBJ ATB ON ATB.ACT_ID = ACT.ACT_ID
			    JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ATB.TBJ_ID
			    JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID
			    LEFT JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
			    LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
			    LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
			    LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
			    WHERE ACT.ACT_NUM_ACTIVO = '||V_TMP_TRAMITE_ACT_TEC(1)||' AND TRA.TRA_ID = '||V_TMP_TRAMITE_ACT_TEC(2)||'';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Al activo '||V_TMP_TRAMITE_ACT_TEC(1)||' se le borrará el trámite '||V_TMP_TRAMITE_ACT_TEC(2));
			
		END IF;
	   END LOOP;
       
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR where SOLOTRAMITE <> 1';
    EXECUTE IMMEDIATE V_MSQL INTO COUNTER;
    DBMS_OUTPUT.PUT_LINE(COUNTER||' trámites a reposicionar.');
    COUNTER := 0;
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR where SOLOTRAMITE = 1';
    EXECUTE IMMEDIATE V_MSQL INTO COUNTER;
    DBMS_OUTPUT.PUT_LINE(COUNTER||' trabajos en estado PAGADO con trámite borrado.');
    COUNTER := 0;
    
    
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TRA_ID = T2.TRA_ID AND T1.TAR_ID = T2.TAR_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' tareas/activos.');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TEX_ID = T2.TEX_ID)';
    EXECUTE IMMEDIATE V_MSQL;       
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' tareas externa valor.');    
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TEX_ID = T2.TEX_ID)';
    EXECUTE IMMEDIATE V_MSQL;       
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' tareas externas.');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ETN_EXTAREAS_NOTIFICACIONES T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TAR_ID = T2.TAR_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' ETNs.');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TAR_ID = T2.TAR_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' tareas.');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TRA_ID = T2.TRA_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' trámites.');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_TBJ T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TBJ_ID = T2.TBJ_ID AND SOLOTRAMITE <> 1)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' relaciones activos/trabajos.');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_REP||' T2 WHERE T1.TBJ_ID = T2.TBJ_ID AND SOLOTRAMITE <> 1)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' trabajos.');

    DBMS_OUTPUT.PUT_LINE('[INFO] APROVISIONANDO LA TABLA AUXILIAR '||V_TABLA||'...');
       V_MSQL := 'DELETE FROM  '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP';
       EXECUTE IMMEDIATE V_MSQL;
      
	V_MSQL := '
            INSERT INTO '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP (OFR_ID, ACT_ID, TPO_ID, TAP_ID, USU_ID, SUP_ID,PVC_ID,TRA_ID)
            SELECT 0, ORE.ACT_ID
                ,(SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T004'' AND BORRADO = 0)
                TPO_ID, TAP.TAP_ID, USU_ID, NULL AS SUP_ID,ORE.PVC_ID, TRA_ID
            FROM '||V_ESQUEMA||'.OFERTAS_REPOSICIONAR ORE
            JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_CODIGO = ''T004_ResultadoTarificada'' AND BORRADO = 0 AND SOLOTRAMITE <> 1';
            EXECUTE IMMEDIATE V_MSQL;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

      /*V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP T1
        USING (
            SELECT DISTINCT MIG.ACT_ID, GEE.USU_ID, TGE.DD_TGE_CODIGO
            FROM '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP MIG
            JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO = ''T004_ResultadoTarificada''
            JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = MIG.ACT_ID
            JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GACT'') T2
        ON (T1.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.USU_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;*/

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Gestor de certificación). '||V_UPDATE||' Filas.');
      
      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE MIG2_TRAMITES_OFERTAS_REP (TBJ_ID, TRA_ID, TAR_ID, TEX_ID) --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] GENERANDO TBJ_ID, TRA_ID, TAR_ID, TEX_ID...');
      
      OPEN CURSOR_OFERTAS;
      
      LOOP
            FETCH CURSOR_OFERTAS INTO V_OFR_ID;
            EXIT WHEN CURSOR_OFERTAS%NOTFOUND;
            
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_ACT_TBJ_TRABAJO.NEXTVAL FROM DUAL' INTO S_TBJ;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TBJ_NUM_TRABAJO.NEXTVAL FROM DUAL' INTO S_NUM;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_ACT_TRA_TRAMITE.NEXTVAL FROM DUAL' INTO S_TRA;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL' INTO S_TAR;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL FROM DUAL' INTO S_TEX;
                  DBMS_OUTPUT.PUT_LINE('VARIABLE V_OFR_ID '||V_OFR_ID||', la secuencia del trabajo es: '||S_TBJ);
                  
                  EXECUTE IMMEDIATE '
                        UPDATE '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP TRA
                        SET TRA.TBJ_ID = '||S_TBJ||'
                              , TRA.TBJ_NUM_TRABAJO = '||S_NUM||'
                              , TRA.TRA_ID = '||S_TRA||'
                              , TRA.TAR_ID = '||S_TAR||'
                              , TRA.TEX_ID = '||S_TEX||'
                        WHERE TRA_ID = '||V_OFR_ID
                  ;
                  
      END LOOP;
      
      CLOSE CURSOR_OFERTAS; 
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada.');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL VOLCADO A LAS TABLAS DEFINITIVAS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TRABAJOS...');

      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TBJ||' (
                  TBJ_ID
                  , ACT_ID
                  , TBJ_NUM_TRABAJO
		  , PVC_ID
		  , TBJ_CUBRE_SEGURO
		  , TBJ_TARIFICADO
		  , TBJ_FECHA_APROBACION
                  , USU_ID
                  , DD_TTR_ID
                  , DD_STR_ID
                  , DD_EST_ID
                  , TBJ_FECHA_SOLICITUD
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
            )
            SELECT DISTINCT
                  MIG2.TBJ_ID                                             AS TBJ_ID
                  , MIG2.ACT_ID                                           AS AGR_ID
                  , MIG2.TBJ_NUM_TRABAJO                         AS TBJ_NUM_TRABAJO
		  , MIG2.PVC_ID
		  , 0
		  , 1
		  , TRUNC(SYSDATE)
		  , (SELECT USU_ID
                          FROM '||V_ESQUEMA_M||'.USU_USUARIOS
                          WHERE USU_USERNAME = ''MIGRACION''
                          AND BORRADO = 0
                    )                                                          AS USU_ID 
                  , (SELECT DD_TTR_ID
                          FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO
                          WHERE DD_TTR_CODIGO = ''03''
                          AND BORRADO = 0
                    )                                                           AS DD_TTR_ID    
                  , (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''37'' AND BORRADO = 0)   
                        
                  , (SELECT DD_EST_ID
                          FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO
                          WHERE DD_EST_CODIGO = ''04''
                          AND BORRADO = 0
                    )                                                           AS DD_EST_ID 
                  , SYSDATE                                              AS TBJ_FECHA_SOLICITUD
                  , 0                                                          AS VERSION
                  , '''||V_USUARIO||'''                               AS USUARIOCREAR
                  , SYSDATE                                              AS FECHACREAR
                  , 0                                                           AS BORRADO
            FROM '||V_ESQUEMA||'.MIG2_TRAMITES_OFERTAS_REP MIG2
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TBJ||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ACT_TBJ --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO RELACION ACTIVOS-TRABAJOS...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACT_TBJ||' (
                  ACT_ID
                  ,TBJ_ID
                  ,ACT_TBJ_PARTICIPACION
                  ,VERSION
            )
            WITH PARTICIPACION AS (
                  SELECT
                        MIG2.TBJ_ID              AS TBJ_ID
                        , COUNT(1)              AS TOTAL
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  GROUP BY MIG2.TBJ_ID
            )
            SELECT DISTINCT
                  MIG2.ACT_ID                                         AS ACT_ID
                  , MIG2.TBJ_ID                                        AS TBJ_ID
                  , ROUND(100/NVL(TOTAL,1),2)             AS ACT_TBJ_PARTICIPACION
                  , 0                                                       AS VERSION
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN PARTICIPACION PAR ON PAR.TBJ_ID = MIG2.TBJ_ID  
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ACT_TBJ||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ACT_TRA_TRAMITE --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TRAMITES...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TRA||'
            (
                  TRA_ID
                  ,TBJ_ID
                  ,DD_TPO_ID
                  ,DD_EPR_ID
                  ,TRA_DECIDIDO
                  ,TRA_PROCESS_BPM
                  ,TRA_PARALIZADO
                  ,TRA_FECHA_INICIO
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
                  ,DD_TAC_ID
            )
            SELECT DISTINCT
                  MIG2.TRA_ID                                                                         AS TRA_ID
                  , MIG2.TBJ_ID                                                                        AS TBJ_ID
                  , MIG2.TPO_ID                                                                       AS DD_TPO_ID
                  , (SELECT DD_EPR_ID 
                        FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO 
                        WHERE DD_EPR_CODIGO = ''10''
                        AND BORRADO = 0
                  )                                                                                           AS DD_EPR_ID
                  , 0                                                                                        AS TRA_DECIDIDO
                  , NULL                                                                                  AS TRA_PROCESS_BPM
                  , 0                                                                                        AS TRA_PARALIZADO
                  , SYSDATE                                                                           AS TRA_FECHA_INICIO
                  , 1                                                                                        AS VERSION
                  , '''||V_USUARIO||'''                                                            AS USUARIOCREAR
                  , SYSDATE                                                                           AS FECHACREAR         
                  , 0                                                                                        AS BORRADO
                  , (SELECT DD_TAC_ID 
                          FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION  
                          WHERE DD_TAC_CODIGO = ''TR''
                          AND BORRADO = 0
                  )                                                                                           AS DD_TAC_ID
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TRA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAR_TAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS NOTIFICACIONES...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAR||'
            (
                  TAR_ID
                  , DD_EIN_ID
                  , DD_STA_ID
                  , TAR_CODIGO
                  , TAR_TAREA
                  , TAR_DESCRIPCION
                  , TAR_FECHA_INI
                  , TAR_EN_ESPERA
                  , TAR_ALERTA
                  , TAR_TAREA_FINALIZADA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TAR_FECHA_VENC
                  , DTYPE
                  , NFA_TAR_REVISADA
            )
            SELECT DISTINCT
                  MIG2.TAR_ID                                                                               AS TAR_ID
                  , (SELECT EIN.DD_EIN_ID 
                          FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN 
                          WHERE EIN.DD_EIN_CODIGO = ''61''
                          AND BORRADO = 0
                  )                                                                                                 AS DD_EIN_ID
                  , STA.DD_STA_ID                                                                         AS DD_STA_ID
                  , 1                                                                                              AS TAR_CODIGO
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_TAREA
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_DESCRIPCION
                  , SYSDATE                                                                                 AS TAR_FECHA_INI
                  , 0                                                                                             AS TAR_EN_ESPERA
                  , 0                                                                                              AS TAR_ALERTA
                  , 0                                                                                             AS TAR_TAREA_FINALIZADA
                  , 0                                                                                             AS VERSION
                  , '''||V_USUARIO||'''                                                                       AS USUARIOCREAR
                  , SYSDATE                                                                                 AS FECHACREAR
                  , 0                                                                                             AS BORRADO
                  , (SELECT SYSDATE + 3 FROM DUAL)                                          AS TAR_FECHA_VENC
                  , ''EXTTareaNotificacion''                                                               AS DTYPE
                  , 0                                                                                             AS NFA_TAR_REVISADA
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
                  INNER JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_ID = TAP.DD_STA_ID
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAR||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ETN_EXTAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS NOTIFICACIONES...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ETN||'
            (
                  TAR_ID
                  ,TAR_FECHA_VENC_REAL
            )
            SELECT DISTINCT
                  MIG2.TAR_ID
                  ,(SELECT SYSDATE + 3 FROM DUAL) AS TAR_FECHA_VENC_REAL
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ETN||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TEX_TAREA_EXTERNA --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TEX||'
            (
                  TEX_ID
                  , TAR_ID
                  , TAP_ID
                  , TEX_TOKEN_ID_BPM
                  , TEX_DETENIDA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TEX_NUM_AUTOP
                  , DTYPE
            )
            SELECT DISTINCT
                  MIG2.TEX_ID             AS TEX_ID
                  , MIG2.TAR_ID          AS TAR_ID
                  , MIG2.TAP_ID           AS TAP_ID
                  , NULL                     AS TEX_TOKEN_ID_BPM
                  , 0                           AS TEX_DETENIDA
                  , 0                           AS VERSION
                  , '''||V_USUARIO||'''     AS USUARIOCREAR
                  , SYSDATE               AS FECHACREAR
                  , 0                              AS BORRADO
                  , 0                             AS TEX_NUM_AUTOP
                  , ''EXTTareaExterna''     AS DTYPE
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TEX||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAC_TAREAS_ACTIVOS --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO RELACION TAREAS ACTIVOS...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAC||'
            (
                  TAR_ID
                  , TRA_ID
                  , ACT_ID
                  , USU_ID
                  , SUP_ID
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
            )
            WITH UNICO_ACTIVO AS (
                  SELECT DISTINCT
                        MIG2.TAR_ID          
                        , MIG2.TRA_ID       
                        , MIG2.ACT_ID       
                        , MIG2.USU_ID        
                        , MIG2.SUP_ID        
                        , ROW_NUMBER () OVER (PARTITION BY MIG2.TAR_ID ORDER BY MIG2.ACT_ID DESC) AS ORDEN
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
            )
            SELECT
                  UA.TAR_ID             AS TAR_ID
                  , UA.TRA_ID           AS TRA_ID
                  , UA.ACT_ID           AS ACT_ID
                  , UA.USU_ID           AS USU_ID
                  , UA.SUP_ID           AS SUP_ID
                  , 0                       AS VERSION
                  , '''||V_USUARIO||''' AS USUARIOCREAR
                  , SYSDATE           AS FECHACREAR
                  ,0                        AS BORRADO
            FROM UNICO_ACTIVO UA
            WHERE UA.ORDEN = 1
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAC||' cargada. '||SQL%ROWCOUNT||' Filas.');
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[FIN] Reposicionamiento de trámites de activos.');

    COMMIT;

    /*'||V_ESQUEMA||'.ALTA_BPM_INSTANCES(V_USUARIO,PL_OUTPUT);
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);*/

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;



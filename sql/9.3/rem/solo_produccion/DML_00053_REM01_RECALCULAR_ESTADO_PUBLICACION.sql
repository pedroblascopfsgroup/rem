--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5961
--## PRODUCTO=NO
--## 
--## Finalidad: RECALCULAR ESTADO PUBLICACION ACTIVOS
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
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5961';
   V_COUNT NUMBER(16):= 0;
   HORA_INI TIMESTAMP;
   HORA_FIN TIMESTAMP;
   v_n INTERVAL DAY TO SECOND ;
    
   
   CURSOR ESTADO_PUBLI_RECALCULAR IS 
       SELECT ACT_ID 
       FROM REM01.ACT_ACTIVO
       WHERE ACT_NUM_ACTIVO IN (
        89918,
	90159,
	91062,
	91127,
	91178,
	91372,
	108344,
	108791,
	112203,
	132676,
	143366,
	148535,
	155499,
	159519,
	160575,
	163814,
	164255,
	165835,
	165836,
	166061,
	167863,
	168130,
	168355,
	168356,
	175006,
	176525,
	5926549,
	5926883,
	5927108,
	5927362,
	5928612,
	5929808,
	5933271,
	5933314,
	5937456,
	5937695,
	5941998,
	5944145,
	5946549,
	5946651,
	5947630,
	5948327,
	5951635,
	5951748,
	5952434,
	5953609,
	5955054,
	5960731,
	5960999,
	5962528,
	5963370,
	5963855,
	5966068,
	5966866,
	5966914,
	5968084,
	5968085,
	5969368,
	5969566,
	6030419,
	6030420,
	6031370,
	6031751,
	6033055,
	6034807,
	6034824,
	6034918,
	6038433,
	6042355,
	6042810,
	6043315,
	6044999,
	6057826,
	6077874,
	6078803,
	6078805,
	6078806,
	6078807,
	6078808,
	6078810,
	6078811,
	6078812,
	6079238,
	6079254,
	6713558,
	6714328,
	6781238,
	6782902,
	6859160,
	6859495,
	6863477,
	6872896,
	6876293,
	6876380,
	6878445,
	6878750,
	6881753,
	6898935,
	6943714,
	6958004,
	6962132,
	6962610,
	6980734,
	6980736,
	6981956,
	6983229,
	6983488,
	6983537,
	6983616,
	6983919,
	6984061,
	6984065,
	6984068,
	6984094,
	6984242,
	6985410,
	6986349,
	6987155,
	6987354,
	6988975,
	6989752,
	6990864,
	6994282,
	6997146,
	6997252,
	6997568,
	6998191,
	6999271,
	7001850,
	7018747,
	7035807,
	7038195,
	7038196,
	7038288,
	7038571,
	7047864,
	7051452,
	7052462,
	7052468,
	7052475,
	7052477,
	7052478,
	7052479,
	7052480,
	7052482,
	7052483,
	7053174,
	7053176,
	7053426,
	7059258,
	7060691,
	7061247,
	7061248,
	7061249,
	7061250,
	7224135,
	7224512,
	7229398,
	7229403,
	7229411,
	7293154
       );

   FILA ESTADO_PUBLI_RECALCULAR%ROWTYPE;
  
BEGIN
   HORA_INI := SYSTIMESTAMP;
   DBMS_OUTPUT.put_line('[INICIO] Ejecutando actualizacion estados publicacion ...........'||HORA_INI||' ');

     
   OPEN ESTADO_PUBLI_RECALCULAR;
   
   V_COUNT := 0;
   
   LOOP
       FETCH ESTADO_PUBLI_RECALCULAR INTO FILA;
       EXIT WHEN ESTADO_PUBLI_RECALCULAR%NOTFOUND;
       
       REM01.SP_CAMBIO_ESTADO_PUBLICACION (FILA.ACT_ID, 1, ''||V_USUARIOMODIFICAR||'');
           
       V_COUNT := V_COUNT + 1;
   END LOOP;
    
   DBMS_OUTPUT.PUT_LINE(' [INFO] Se han RECALCULADO '||V_COUNT||' ESTADOS DE PUBLICACION ');
   CLOSE ESTADO_PUBLI_RECALCULAR;

   HORA_FIN := SYSTIMESTAMP;
   v_n := HORA_FIN - HORA_INI;
   DBMS_OUTPUT.PUT_LINE('[FIN] Duración la ejecución................'||EXTRACT( SECOND FROM v_n)||' segundos ');
    
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(ERR_MSG);
        ROLLBACK;
        RAISE;   
END;
/
EXIT;

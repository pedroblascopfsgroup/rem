--/*
--#########################################
--## AUTOR=vIOREL rEMUS oVIDIU
--## FECHA_CREACION=20201203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8369
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    -- Esquemas
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8369';
   
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	


       DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR/INSERTAR COMUNIDADES PROPIETARIOS');
  	
  	 V_MSQL :='MERGE INTO REM01.AIN_ACTIVO_INTEGRADO T1 USING 
			(SELECT ACT.ACT_ID, AIN.AIN_ID
			FROM REM01.ACT_ACTIVO   ACT
            		LEFT JOIN  REM01.AIN_ACTIVO_INTEGRADO AIN ON ACT.ACT_ID = AIN.ACT_ID
			WHERE ACT_NUM_ACTIVO IN (7095292,
                7095256,
                7096137,
                7096170,
                7096139,
                7096174,
                7096176,
                7096166,
                7097222,
                7097287,
                7097278,
                7098142,
                7098158,
                7098169,
                7098151,
                7098154,
                7098116,
                7098111,
                7098172,
                7098130,
                7098115,
                7098132,
                7098133,
                7099049,
                7099065,
                7099088,
                7099073,
                7099047,
                7090338,
                7090402,
                7090381,
                7090335,
                7090353,
                7090405,
                7090340,
                7090390,
                7091278,
                7091289,
                7091273,
                7091242,
                7091256,
                7091252,
                7091248,
                7091259,
                7091238,
                7091250,
                7091243,
                7091267,
                7091265,
                7091247,
                7091244,
                7091253,
                7091279,
                7091241,
                7091284,
                7091282,
                7091261,
                7091257,
                7091272,
                7091263,
                7091264,
                7091249,
                7091275,
                7092272,
                7092256,
                7092225,
                7092285,
                7092264,
                7092248,
                7092265,
                7092238,
                7092280,
                7092239,
                7092268,
                7092249,
                7093432,
                7093476,
                7093475,
                7093412,
                7093428,
                7093384,
                7093470,
                7093415,
                7093487,
                7093407,
                7094176,
                7094226,
                7094175,
                7094243,
                7094261,
                7094231,
                7094202,
                7094223,
                7094240,
                7095277,
                7095310,
                7095305,
                7095294,
                7095265,
                7095285,
                7095263,
                7095293,
                7095286,
                7095295,
                7095269,
                7095301,
                7095276,
                7096159,
                7098127,
                7098145,
                7098171,
                7099071,
                7099122,
                7099138,
                7099144,
                7099150,
                7099134,
                7099099,
                7099116,
                7099094,
                7090401,
                7090376,
                7090385,
                7090366,
                7090357,
                7090358,
                7090365,
                7090374,
                7090356,
                7091246,
                7091260,
                7091240,
                7091276,
                7091239,
                7091270,
                7091274,
                7091266,
                7091258,
                7091262,
                7091283,
                7091290,
                7091269,
                7091285,
                7091271,
                7091316,
                7091306,
                7091317,
                7091304,
                7091281,
                7091314,
                7091298,
                7091319,
                7091320,
                7091305,
                7091335,
                7092234,
                7095297,
                7095271,
                7095282,
                7095359,
                7095328,
                7096172,
                7096151,
                7096182,
                7096134,
                7096140,
                7096142,
                7096177,
                7096158,
                7096164,
                7097263,
                7097290,
                7097247,
                7097284,
                7097233,
                7097335,
                7097351,
                7097314,
                7097396,
                7097384,
                7097310,
                7097332,
                7097414,
                7097368,
                7097339,
                7097337,
                7098161,
                7098157,
                7098135,
                7098166,
                7098168,
                7098170,
                7098119,
                7098163,
                7098113,
                7099098,
                7099097,
                7099157,
                7099100,
                7099113,
                7099104,
                7099167,
                7099143,
                7099124,
                7090369,
                7090373,
                7090367,
                7090341,
                7090375,
                7090368,
                7090379,
                7090342,
                7091280,
                7091330)) T2
		ON (T1.ACT_ID = T2.ACT_ID AND T2.AIN_ID IS NULL)
        WHEN MATCHED THEN UPDATE SET 
		T1.PVE_ID = (SELECT PVE_ID FROM REM01.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = ''110190211''),
		T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
		T1.FECHAMODIFICAR = SYSDATE
		WHEN NOT MATCHED THEN 
			INSERT (AIN_ID,ACT_ID,BORRADO,FECHACREAR,USUARIOCREAR,VERSION,PVE_ID, AIN_FECHA_INCLUSION,AIN_PAGO_RETENIDO)
            		VALUES (REM01.S_AIN_ACTIVO_INTEGRADO.NEXTVAL, T2.ACT_ID, 0,SYSDATE,'''||V_USUARIO||''',0,(SELECT PVE_ID FROM REM01.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = ''110190211''), SYSDATE, 0)';

  	EXECUTE IMMEDIATE V_MSQL;

  	DBMS_OUTPUT.PUT_LINE('  [INFO] ACTUALIZADOS. '||SQL%ROWCOUNT||' REGISTROS.');
  	
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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

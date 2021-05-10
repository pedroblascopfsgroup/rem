--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210407
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9309
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-9309';
    V_SQL VARCHAR2(4000 CHAR);

    V_TABLA VARCHAR2(100 CHAR):='ACT_OFR';

    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_TOTAL NUMBER(16):=0;
    NUM_ACTIVO NUMBER(16);
    OFR_ID NUMBER(16);

    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        -- Expediente comercial -   Activo  -   Importe participacion   -   Porcentaje participacion
            T_TIPO_DATA('237233','7298346','2820.48','2.03'),
            T_TIPO_DATA('237233','7298329','2660.83','1.91'),
            T_TIPO_DATA('237233','7298319','2820.48','2.03'),
            T_TIPO_DATA('237233','7298363','2820.48','2.03'),
            T_TIPO_DATA('237233','7298427','2820.48','2.03'),
            T_TIPO_DATA('237233','7298378','2660.83','1.91'),
            T_TIPO_DATA('237233','7298388','2660.83','1.91'),
            T_TIPO_DATA('237233','7298344','2831.13','2.04'),
            T_TIPO_DATA('237233','7298400','2660.84','1.91'),
            T_TIPO_DATA('237233','7298335','2820.49','2.03'),
            T_TIPO_DATA('237233','7298417','2820.49','2.03'),
            T_TIPO_DATA('237233','7298429','2660.84','1.91'),
            T_TIPO_DATA('237233','7298393','2820.49','2.03'),
            T_TIPO_DATA('237233','7298307','3107.86','2.24'),
            T_TIPO_DATA('237233','7298425','3831.61','2.76'),
            T_TIPO_DATA('237233','7298369','2660.84','1.91'),
            T_TIPO_DATA('237233','7298322','2820.49','2.03'),
            T_TIPO_DATA('237233','7298328','2820.49','2.03'),
            T_TIPO_DATA('237233','7298316','2660.84','1.91'),
            T_TIPO_DATA('237233','7298431','2820.49','2.03'),
            T_TIPO_DATA('237233','7298408','2820.49','2.03'),
            T_TIPO_DATA('237233','7298377','2820.49','2.03'),
            T_TIPO_DATA('237233','7298383','2820.49','2.03'),
            T_TIPO_DATA('237233','7298325','2660.84','1.91'),
            T_TIPO_DATA('237233','7298342','2820.49','2.03'),
            T_TIPO_DATA('237233','7298339','2660.84','1.91'),
            T_TIPO_DATA('237233','7298420','2820.49','2.03'),
            T_TIPO_DATA('237233','7298413','2820.49','2.03'),
            T_TIPO_DATA('237233','7298368','2820.49','2.03'),
            T_TIPO_DATA('237233','7298418','2820.49','2.03'),
            T_TIPO_DATA('237233','7298394','2660.84','1.91'),
            T_TIPO_DATA('237233','7298365','2820.49','2.03'),
            T_TIPO_DATA('237233','7298428','2660.84','1.91'),
            T_TIPO_DATA('237233','7298351','3086.57','2.22'),
            T_TIPO_DATA('237233','7298338','2820.49','2.03'),
            T_TIPO_DATA('237233','7298324','2820.49','2.03'),
            T_TIPO_DATA('237233','7298375','2660.84','1.91'),
            T_TIPO_DATA('237233','7298352','2660.84','1.91'),
            T_TIPO_DATA('237233','7298386','2660.84','1.91'),
            T_TIPO_DATA('237233','7298347','2660.84','1.91'),
            T_TIPO_DATA('237233','7298337','1609.88','1.16'),
            T_TIPO_DATA('237233','7298353','689.95','0.50'),
            T_TIPO_DATA('237233','7298333','827.94','0.60'),
            T_TIPO_DATA('237233','7298390','1333.9','0.96'),
            T_TIPO_DATA('237233','7298309','1379.9','0.99'),
            T_TIPO_DATA('237233','7298412','1034.92','0.74'),
            T_TIPO_DATA('237233','7298401','942.93','0.68'),
            T_TIPO_DATA('237233','7298350','1103.92','0.79'),
            T_TIPO_DATA('237233','7298360','873.94','0.63'),
            T_TIPO_DATA('237233','7298381','804.94','0.59'),
            T_TIPO_DATA('237233','7298357','770.44','0.55'),
            T_TIPO_DATA('237233','7298312','1011.93','0.73'),
            T_TIPO_DATA('237233','7298399','1379.9','0.99'),
            T_TIPO_DATA('237233','7298403','770.44','0.55'),
            T_TIPO_DATA('237233','7298392','735.95','0.53'),
            T_TIPO_DATA('237233','7298385','827.94','0.60'),
            T_TIPO_DATA('237233','7298404','896.93','0.65'),
            T_TIPO_DATA('237233','7298396','735.95','0.53'),
            T_TIPO_DATA('237233','7298354','827.94','0.60'),
            T_TIPO_DATA('237233','7298308','781.94','0.56'),
            T_TIPO_DATA('237233','7298374','804.94','0.58'),
            T_TIPO_DATA('237233','7298318','1149.91','0.83'),
            T_TIPO_DATA('237233','7298402','735.95','0.53'),
            T_TIPO_DATA('237233','7298376','827.94','0.60'),
            T_TIPO_DATA('237233','7298379','919.93','0.66'),
            T_TIPO_DATA('237233','7298422','827.94','0.60'),
            T_TIPO_DATA('237233','7298362','1310.9','0.94'),
            T_TIPO_DATA('237233','7298349','1080.92','0.79')



    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR PRECIOS AGRUPACION');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
            
            EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' ACTOFR
                                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=ACTOFR.ACT_ID
                                JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID=ACTOFR.OFR_ID
                                WHERE ECO.ECO_NUM_EXPEDIENTE='''||V_TMP_TIPO_DATA(1)||''' AND ACT.ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(2)||'''' INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN

                V_SQL:='SELECT OFR_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO WHERE ECO.ECO_NUM_EXPEDIENTE='''||V_TMP_TIPO_DATA(1)||'''';
                EXECUTE IMMEDIATE V_SQL INTO OFR_ID;

                V_SQL:='SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(2)||'''';
                EXECUTE IMMEDIATE V_SQL INTO NUM_ACTIVO;

                V_SQL := ' UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                            ACT_OFR_IMPORTE = '''||V_TMP_TIPO_DATA(3)||''',
                            OFR_ACT_PORCEN_PARTICIPACION = '''||V_TMP_TIPO_DATA(4)||'''                      
                            WHERE OFR_ID = '||OFR_ID||' AND ACT_ID = '||NUM_ACTIVO||' ';	

                EXECUTE IMMEDIATE V_SQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO] Modificada realacion num_expediente '''||V_TMP_TIPO_DATA(1)||''' activo: '''||V_TMP_TIPO_DATA(2)||''' con importe: '''||V_TMP_TIPO_DATA(3)||''' correctamente');
                V_COUNT := V_COUNT + 1;

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] No existe la relacion en '||V_TABLA||' ');
                        
            END IF;

    END LOOP;
	
    
     DBMS_OUTPUT.PUT_LINE('[INFO]  Modificadas '||V_COUNT||' relaciones correctamente de '||V_COUNT_TOTAL||'');  

     COMMIT;

     DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
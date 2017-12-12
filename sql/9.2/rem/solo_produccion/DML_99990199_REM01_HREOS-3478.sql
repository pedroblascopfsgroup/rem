--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.10
--## INCIDENCIA_LINK=HREOS-
--## PRODUCTO=NO
--##
--## Finalidad: Cambia el estado de un gasto y lo asocia a los activos pasados en el array. 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    err_num NUMBER(25);
    err_msg VARCHAR2(1024 CHAR);
    V_MSQL VARCHAR2(1024 CHAR);
    V_EXISTS NUMBER(1);
    V_ESQUEMA VARCHAR2(30 CHAR) := '#ESQUEMA#';
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-3478';
    V_NUM_GASTO VARCHAR2(50 CHAR) := '9430440';
    V_NUM_ACTIVOS NUMBER(16);
    V_PORC_PARTICIPACION VARCHAR2(6 CHAR);
    V_PORC_RESTO VARCHAR2(6 CHAR);
    V_ACT_ID NUMBER(16);
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR(150 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA(5932871),
        T_TIPO_DATA(5931067),
        T_TIPO_DATA(5959405),
        T_TIPO_DATA(5955441),
        T_TIPO_DATA(5938855),
        T_TIPO_DATA(5936344),
        T_TIPO_DATA(5955132),
        T_TIPO_DATA(5952860),
        T_TIPO_DATA(5948981),
        T_TIPO_DATA(5958790),
        T_TIPO_DATA(5944650),
        T_TIPO_DATA(5950937),
        T_TIPO_DATA(5954393),
        T_TIPO_DATA(5953648),
        T_TIPO_DATA(5939202),
        T_TIPO_DATA(5928202),
        T_TIPO_DATA(5955326),
        T_TIPO_DATA(5931927),
        T_TIPO_DATA(5964978),
        T_TIPO_DATA(5947735),
        T_TIPO_DATA(5957228),
        T_TIPO_DATA(5954168),
        T_TIPO_DATA(5932530),
        T_TIPO_DATA(5929077),
        T_TIPO_DATA(5965380),
        T_TIPO_DATA(5945231),
        T_TIPO_DATA(5959454),
        T_TIPO_DATA(5945975),
        T_TIPO_DATA(5925244),
        T_TIPO_DATA(5938398),
        T_TIPO_DATA(5935455),
        T_TIPO_DATA(5925026),
        T_TIPO_DATA(5955321),
        T_TIPO_DATA(5963756),
        T_TIPO_DATA(5948582),
        T_TIPO_DATA(5940621),
        T_TIPO_DATA(5943016),
        T_TIPO_DATA(5966282),
        T_TIPO_DATA(5954264),
        T_TIPO_DATA(5969556),
        T_TIPO_DATA(6047768),
        T_TIPO_DATA(5957930),
        T_TIPO_DATA(5954733),
        T_TIPO_DATA(6048073),
        T_TIPO_DATA(5927775),
        T_TIPO_DATA(5955106),
        T_TIPO_DATA(5966072),
        T_TIPO_DATA(5966318),
        T_TIPO_DATA(5953290),
        T_TIPO_DATA(5925961),
        T_TIPO_DATA(6049601),
        T_TIPO_DATA(5935303),
        T_TIPO_DATA(5948677),
        T_TIPO_DATA(5969022),
        T_TIPO_DATA(5950876),
        T_TIPO_DATA(6050806),
        T_TIPO_DATA(6051178),
        T_TIPO_DATA(6051179),
        T_TIPO_DATA(5967607),
        T_TIPO_DATA(5928762),
        T_TIPO_DATA(5926120),
        T_TIPO_DATA(5961185),
        T_TIPO_DATA(5931304),
        T_TIPO_DATA(6707271),
        T_TIPO_DATA(5940133),
        T_TIPO_DATA(6057088),
        T_TIPO_DATA(6057098),
        T_TIPO_DATA(5927256),
        T_TIPO_DATA(5965403),
        T_TIPO_DATA(6057383),
        T_TIPO_DATA(5928825),
        T_TIPO_DATA(5941114),
        T_TIPO_DATA(5936543),
        T_TIPO_DATA(5956905),
        T_TIPO_DATA(5968845),
        T_TIPO_DATA(5949291),
        T_TIPO_DATA(5928675),
        T_TIPO_DATA(5925470),
        T_TIPO_DATA(5934229),
        T_TIPO_DATA(5955915),
        T_TIPO_DATA(6058869),
        T_TIPO_DATA(5970342),
        T_TIPO_DATA(5969514),
        T_TIPO_DATA(6059269),
        T_TIPO_DATA(5971504),
        T_TIPO_DATA(5944934),
        T_TIPO_DATA(5966304),
        T_TIPO_DATA(5944946),
        T_TIPO_DATA(5943419),
        T_TIPO_DATA(6344452),
        T_TIPO_DATA(5969281),
        T_TIPO_DATA(5937083),
        T_TIPO_DATA(5941291),
        T_TIPO_DATA(6060001),
        T_TIPO_DATA(5934285),
        T_TIPO_DATA(5948819),
        T_TIPO_DATA(5935605),
        T_TIPO_DATA(6044658),
        T_TIPO_DATA(5967245),
        T_TIPO_DATA(5942555),
        T_TIPO_DATA(5928522),
        T_TIPO_DATA(6060764),
        T_TIPO_DATA(6060782),
        T_TIPO_DATA(6060818),
        T_TIPO_DATA(5940476),
        T_TIPO_DATA(6060846),
        T_TIPO_DATA(6044827),
        T_TIPO_DATA(5924928),
        T_TIPO_DATA(5949162),
        T_TIPO_DATA(5944621),
        T_TIPO_DATA(6061774),
        T_TIPO_DATA(5940003),
        T_TIPO_DATA(5954806),
        T_TIPO_DATA(6044734),
        T_TIPO_DATA(6063147),
        T_TIPO_DATA(6063340),
        T_TIPO_DATA(6063553),
        T_TIPO_DATA(6063582),
        T_TIPO_DATA(5948202),
        T_TIPO_DATA(6063679),
        T_TIPO_DATA(5939745),
        T_TIPO_DATA(6710299),
        T_TIPO_DATA(6044891),
        T_TIPO_DATA(6343481),
        T_TIPO_DATA(6764605),
        T_TIPO_DATA(6129839),
        T_TIPO_DATA(6129202),
        T_TIPO_DATA(6351976),
        T_TIPO_DATA(6768261),
        T_TIPO_DATA(6703036),
        T_TIPO_DATA(6706804),
        T_TIPO_DATA(6789430),
        T_TIPO_DATA(6710298),
        T_TIPO_DATA(6759090),
        T_TIPO_DATA(6788510),
        T_TIPO_DATA(6788511));
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    --Actualizamos estado del gasto y cambiamos fecha emisión
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR 
        SET USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
            , DD_EGA_ID = (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03'') 
            , GPV_FECHA_EMISION = TO_DATE(''06/09/2017'',''DD/MM/YYYY'')
        WHERE GPV_NUM_GASTO_HAYA = '''||V_NUM_GASTO||'''';
    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('  [INFO] Gasto '||V_NUM_GASTO||' en estado Autorizado Administración y Fecha emisión cambiada a 6/9/17.');
        
        --Actualizamos estado autorización de administración y de propietario
        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GGE_GASTOS_GESTION T1
            USING '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T2
            ON (T1.GPV_ID = T2.GPV_ID)
            WHEN MATCHED THEN UPDATE SET
                T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03'')
                , T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''01'')
                , T1.GGE_FECHA_EAH = SYSDATE, T1.GGE_FECHA_EAP = NULL, T1.GGE_FECHA_ENVIO_PRPTRIO = NULL
                , T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
            WHERE T2.GPV_NUM_GASTO_HAYA = '''||V_NUM_GASTO||'''';
        EXECUTE IMMEDIATE V_MSQL;
        IF SQL%ROWCOUNT = 1 THEN
            DBMS_OUTPUT.PUT_LINE('  [INFO] Estado autorización administración autorizado y estado autorización propietario pendiente para gasto '||V_NUM_GASTO||'');
        END IF;
        
        --Eliminamos las relaciones, si las hubiere, del gasto con activos
        V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GPV_ACT WHERE GPV_ID = (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '''||V_NUM_GASTO||''')';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' relaciones con activos borradas para el gasto '||V_NUM_GASTO);
        
        --Asociamos al gasto los 136 activos del array
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
            V_ACT_ID := NULL;
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
            IF V_EXISTS = 1 THEN
                V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
                EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;
                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GPV_ACT (GPV_ACT_ID, ACT_ID, GPV_ID)
                    VALUES('||V_ESQUEMA||'.S_GPV_ACT.NEXTVAL, '||V_ACT_ID||', (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '''||V_NUM_GASTO||'''))';
                EXECUTE IMMEDIATE V_MSQL;
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] No existe el activo '||V_TMP_TIPO_DATA(1)||' a asociar.');
            END IF;
        END LOOP;
        
        --Calculamos el número de activos asociados al gasto
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_ACT GA JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GA.GPV_ID WHERE GPV.GPV_NUM_GASTO_HAYA = '''||V_NUM_GASTO||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_ACTIVOS;
        DBMS_OUTPUT.PUT_LINE('  [INFO] El gasto '||V_NUM_GASTO||' tiene '||V_NUM_ACTIVOS||' activos asociados.');
        
        --Calculamos el porcentaje de participación del gasto redondeado con dos decimales
        V_MSQL := 'SELECT ROUND(100/'||V_NUM_ACTIVOS||',2) FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_PORC_PARTICIPACION;
        DBMS_OUTPUT.PUT_LINE('  [INFO] El porcentaje de participación del gasto '||V_NUM_GASTO||' es '||V_PORC_PARTICIPACION||'.');
        
        --Calculamos el resto del porcentaje anteriormente calculado
        V_MSQL := 'SELECT TO_NUMBER('''||V_PORC_PARTICIPACION||''')+(100-TO_NUMBER('''||V_PORC_PARTICIPACION||''')*'||V_NUM_ACTIVOS||') FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_PORC_RESTO;
        DBMS_OUTPUT.PUT_LINE('  [INFO] El resto del porcentaje de participación del gasto '||V_NUM_GASTO||' es '||V_PORC_RESTO||'.');
        
        --Actualizamos todos los activos con el porcentaje de participación del gasto
        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_ACT T1
            USING (SELECT GA.GPV_ACT_ID
                FROM '||V_ESQUEMA||'.GPV_ACT GA
                JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GA.GPV_ID
                WHERE GPV.GPV_NUM_GASTO_HAYA = '''||V_NUM_GASTO||''') T2
            ON (T1.GPV_ACT_ID = T2.GPV_ACT_ID)
            WHEN MATCHED THEN UPDATE SET
                T1.GPV_PARTICIPACION_GASTO = TO_NUMBER('''||V_PORC_PARTICIPACION||''')';
        EXECUTE IMMEDIATE V_MSQL;
        
        --Actualizamos un activo con el resto del porcentaje de participación calculado
        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_ACT T1
            USING (SELECT GA.GPV_ACT_ID
                FROM '||V_ESQUEMA||'.GPV_ACT GA
                JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GA.GPV_ID
                WHERE GPV.GPV_NUM_GASTO_HAYA = '''||V_NUM_GASTO||''' AND ROWNUM = 1) T2
            ON (T1.GPV_ACT_ID = T2.GPV_ACT_ID)
            WHEN MATCHED THEN UPDATE SET
                T1.GPV_PARTICIPACION_GASTO = TO_NUMBER('''||V_PORC_RESTO||''')';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('  [INFO] Porcentajes de participación del gasto actualizados.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('  [INFO] No existe el gasto '||V_NUM_GASTO||'.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        ROLLBACK;
        RAISE;  
END;
/
EXIT
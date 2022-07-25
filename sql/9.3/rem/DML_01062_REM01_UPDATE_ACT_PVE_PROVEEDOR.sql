--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220406
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17596
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar subtipo de proveedor
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-17596'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_TABLA_PROVEEDOR VARCHAR2(50 CHAR):= 'ACT_PVE_PROVEEDOR'; 

    V_ID_MEDIADOR NUMBER(16); -- Vble. para el id del proveedor

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('79','44'),
            T_TIPO_DATA('81','44'),
            T_TIPO_DATA('83','44'),
            T_TIPO_DATA('84','44'),
            T_TIPO_DATA('85','44'),
            T_TIPO_DATA('87','44'),
            T_TIPO_DATA('90','44'),
            T_TIPO_DATA('95','44'),
            T_TIPO_DATA('95','44'),
            T_TIPO_DATA('101','44'),
            T_TIPO_DATA('102','44'),
            T_TIPO_DATA('110','44'),
            T_TIPO_DATA('112','44'),
            T_TIPO_DATA('113','44'),
            T_TIPO_DATA('114','44'),
            T_TIPO_DATA('118','44'),
            T_TIPO_DATA('130','44'),
            T_TIPO_DATA('132','44'),
            T_TIPO_DATA('133','44'),
            T_TIPO_DATA('140','44'),
            T_TIPO_DATA('145','44'),
            T_TIPO_DATA('147','44'),
            T_TIPO_DATA('148','44'),
            T_TIPO_DATA('153','44'),
            T_TIPO_DATA('155','44'),
            T_TIPO_DATA('156','44'),
            T_TIPO_DATA('657','44'),
            T_TIPO_DATA('934','44'),
            T_TIPO_DATA('936','44'),
            T_TIPO_DATA('937','44'),
            T_TIPO_DATA('938','44'),
            T_TIPO_DATA('939','44'),
            T_TIPO_DATA('940','44'),
            T_TIPO_DATA('941','44'),
            T_TIPO_DATA('942','44'),
            T_TIPO_DATA('943','44'),
            T_TIPO_DATA('949','44'),
            T_TIPO_DATA('951','44'),
            T_TIPO_DATA('958','44'),
            T_TIPO_DATA('960','44'),
            T_TIPO_DATA('962','44'),
            T_TIPO_DATA('970','44'),
            T_TIPO_DATA('972','44'),
            T_TIPO_DATA('986','44'),
            T_TIPO_DATA('1061','44'),
            T_TIPO_DATA('1062','44'),
            T_TIPO_DATA('1062','44'),
            T_TIPO_DATA('1064','44'),
            T_TIPO_DATA('1068','44'),
            T_TIPO_DATA('1069','44'),
            T_TIPO_DATA('1072','44'),
            T_TIPO_DATA('1076','44'),
            T_TIPO_DATA('1077','44'),
            T_TIPO_DATA('1079','44'),
            T_TIPO_DATA('1085','44'),
            T_TIPO_DATA('1086','44'),
            T_TIPO_DATA('1095','44'),
            T_TIPO_DATA('1097','44'),
            T_TIPO_DATA('1099','44'),
            T_TIPO_DATA('1102','44'),
            T_TIPO_DATA('1103','44'),
            T_TIPO_DATA('1109','44'),
            T_TIPO_DATA('1123','44'),
            T_TIPO_DATA('1125','44'),
            T_TIPO_DATA('1128','44'),
            T_TIPO_DATA('1129','44'),
            T_TIPO_DATA('1133','44'),
            T_TIPO_DATA('1801','44'),
            T_TIPO_DATA('2089','44'),
            T_TIPO_DATA('2093','44'),
            T_TIPO_DATA('2095','44'),
            T_TIPO_DATA('2098','44'),
            T_TIPO_DATA('2100','44'),
            T_TIPO_DATA('2102','44'),
            T_TIPO_DATA('2104','44'),
            T_TIPO_DATA('2107','44'),
            T_TIPO_DATA('2108','44'),
            T_TIPO_DATA('2109','44'),
            T_TIPO_DATA('2114','44'),
            T_TIPO_DATA('2117','44'),
            T_TIPO_DATA('2118','44'),
            T_TIPO_DATA('2122','44'),
            T_TIPO_DATA('2123','44'),
            T_TIPO_DATA('2126','44'),
            T_TIPO_DATA('2128','44'),
            T_TIPO_DATA('2131','44'),
            T_TIPO_DATA('2133','44'),
            T_TIPO_DATA('2134','44'),
            T_TIPO_DATA('2139','44'),
            T_TIPO_DATA('2148','44'),
            T_TIPO_DATA('2157','44'),
            T_TIPO_DATA('2162','44'),
            T_TIPO_DATA('2165','44'),
            T_TIPO_DATA('2252','44'),
            T_TIPO_DATA('2256','44'),
            T_TIPO_DATA('2265','44'),
            T_TIPO_DATA('2267','44'),
            T_TIPO_DATA('2268','44'),
            T_TIPO_DATA('2273','44'),
            T_TIPO_DATA('2274','44'),
            T_TIPO_DATA('2276','44'),
            T_TIPO_DATA('2279','44'),
            T_TIPO_DATA('2286','44'),
            T_TIPO_DATA('2288','44'),
            T_TIPO_DATA('2291','44'),
            T_TIPO_DATA('2300','44'),
            T_TIPO_DATA('2302','44'),
            T_TIPO_DATA('2308','44'),
            T_TIPO_DATA('2310','44'),
            T_TIPO_DATA('2311','44'),
            T_TIPO_DATA('2312','44'),
            T_TIPO_DATA('2314','44'),
            T_TIPO_DATA('2317','44'),
            T_TIPO_DATA('2318','44'),
            T_TIPO_DATA('2325','44'),
            T_TIPO_DATA('2327','44'),
            T_TIPO_DATA('2423','44'),
            T_TIPO_DATA('3203','44'),
            T_TIPO_DATA('3204','44'),
            T_TIPO_DATA('3207','44'),
            T_TIPO_DATA('3216','44'),
            T_TIPO_DATA('3217','44'),
            T_TIPO_DATA('3220','44'),
            T_TIPO_DATA('3221','44'),
            T_TIPO_DATA('3224','44'),
            T_TIPO_DATA('3227','44'),
            T_TIPO_DATA('3229','44'),
            T_TIPO_DATA('3230','44'),
            T_TIPO_DATA('3236','44'),
            T_TIPO_DATA('3237','44'),
            T_TIPO_DATA('3239','44'),
            T_TIPO_DATA('3243','44'),
            T_TIPO_DATA('3244','44'),
            T_TIPO_DATA('3250','44'),
            T_TIPO_DATA('3252','44'),
            T_TIPO_DATA('3262','44'),
            T_TIPO_DATA('3264','44'),
            T_TIPO_DATA('3266','44'),
            T_TIPO_DATA('3268','44'),
            T_TIPO_DATA('3269','44'),
            T_TIPO_DATA('3282','44'),
            T_TIPO_DATA('3331','44'),
            T_TIPO_DATA('3333','44'),
            T_TIPO_DATA('3334','44'),
            T_TIPO_DATA('3337','44'),
            T_TIPO_DATA('3352','44'),
            T_TIPO_DATA('3361','44'),
            T_TIPO_DATA('3365','44'),
            T_TIPO_DATA('3367','44'),
            T_TIPO_DATA('3370','44'),
            T_TIPO_DATA('3375','44'),
            T_TIPO_DATA('3376','44'),
            T_TIPO_DATA('3382','44'),
            T_TIPO_DATA('3384','44'),
            T_TIPO_DATA('3387','44'),
            T_TIPO_DATA('3390','44'),
            T_TIPO_DATA('3391','44'),
            T_TIPO_DATA('3395','44'),
            T_TIPO_DATA('3398','44'),
            T_TIPO_DATA('4375','44'),
            T_TIPO_DATA('4378','44'),
            T_TIPO_DATA('4378','44'),
            T_TIPO_DATA('4379','44'),
            T_TIPO_DATA('4381','44'),
            T_TIPO_DATA('4382','44'),
            T_TIPO_DATA('4391','44'),
            T_TIPO_DATA('4397','44'),
            T_TIPO_DATA('4398','44'),
            T_TIPO_DATA('4403','44'),
            T_TIPO_DATA('4404','44'),
            T_TIPO_DATA('4405','44'),
            T_TIPO_DATA('4408','44'),
            T_TIPO_DATA('4410','44'),
            T_TIPO_DATA('4412','44'),
            T_TIPO_DATA('4437','44'),
            T_TIPO_DATA('4439','44'),
            T_TIPO_DATA('4441','44'),
            T_TIPO_DATA('4442','44'),
            T_TIPO_DATA('4445','44'),
            T_TIPO_DATA('9918','44'),
            T_TIPO_DATA('10007','44'),
            T_TIPO_DATA('10029','44'),
            T_TIPO_DATA('10053','44'),
            T_TIPO_DATA('10142','44'),
            T_TIPO_DATA('10216','44'),
            T_TIPO_DATA('10224','44'),
            T_TIPO_DATA('10225','44'),
            T_TIPO_DATA('10252','44'),
            T_TIPO_DATA('10287','44'),
            T_TIPO_DATA('10388','44'),
            T_TIPO_DATA('10465','44'),
            T_TIPO_DATA('10697','44'),
            T_TIPO_DATA('10717','44'),
            T_TIPO_DATA('10819','44'),
            T_TIPO_DATA('10834','44'),
            T_TIPO_DATA('10868','44'),
            T_TIPO_DATA('10890','44'),
            T_TIPO_DATA('10975','44'),
            T_TIPO_DATA('10997','44'),
            T_TIPO_DATA('11032','44'),
            T_TIPO_DATA('11087','44'),
            T_TIPO_DATA('11104','44'),
            T_TIPO_DATA('11186','44'),
            T_TIPO_DATA('11211','44'),
            T_TIPO_DATA('11227','44'),
            T_TIPO_DATA('11263','44'),
            T_TIPO_DATA('11306','44'),
            T_TIPO_DATA('11353','44'),
            T_TIPO_DATA('11424','44'),
            T_TIPO_DATA('11742','44'),
            T_TIPO_DATA('12183','44'),
            T_TIPO_DATA('12217','44'),
            T_TIPO_DATA('12276','44'),
            T_TIPO_DATA('12349','44'),
            T_TIPO_DATA('12685','44'),
            T_TIPO_DATA('12775','44'),
            T_TIPO_DATA('12782','44'),
            T_TIPO_DATA('12816','44'),
            T_TIPO_DATA('12839','44'),
            T_TIPO_DATA('12858','44'),
            T_TIPO_DATA('12941','44'),
            T_TIPO_DATA('12955','44'),
            T_TIPO_DATA('12979','44'),
            T_TIPO_DATA('13120','44'),
            T_TIPO_DATA('23247','44'),
            T_TIPO_DATA('23249','44'),
            T_TIPO_DATA('9990175','44'),
            T_TIPO_DATA('9990177','44'),
            T_TIPO_DATA('9990178','44'),
            T_TIPO_DATA('10005331','44'),
            T_TIPO_DATA('10006149','44'),
            T_TIPO_DATA('10006324','44'),
            T_TIPO_DATA('10006379','44'),
            T_TIPO_DATA('10006653','44'),
            T_TIPO_DATA('10006653','44'),
            T_TIPO_DATA('10006746','44'),
            T_TIPO_DATA('10006832','44'),
            T_TIPO_DATA('10007255','44'),
            T_TIPO_DATA('10007303','44'),
            T_TIPO_DATA('10007305','44'),
            T_TIPO_DATA('10007311','44'),
            T_TIPO_DATA('10007856','44'),
            T_TIPO_DATA('10008095','44'),
            T_TIPO_DATA('10008445','44'),
            T_TIPO_DATA('10008698','44'),
            T_TIPO_DATA('10009337','44'),
            T_TIPO_DATA('10009407','44'),
            T_TIPO_DATA('10009466','44'),
            T_TIPO_DATA('110061006','44'),
            T_TIPO_DATA('110061010','44'),
            T_TIPO_DATA('110064914','44'),
            T_TIPO_DATA('110076951','44'),
            T_TIPO_DATA('110078221','44'),
            T_TIPO_DATA('110078222','44'),
            T_TIPO_DATA('110079038','44'),
            T_TIPO_DATA('110079039','44'),
            T_TIPO_DATA('110081720','44'),
            T_TIPO_DATA('110082258','44'),
            T_TIPO_DATA('110097740','44'),
            T_TIPO_DATA('110098230','44'),
            T_TIPO_DATA('110161725','44'),
            T_TIPO_DATA('110216081','44')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR SUBTIPO A PROVEEDORES');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos que existe el proveedor
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' WHERE PVE_COD_REM = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT = 1 THEN

            
            --Actualizamos el subtipo del proveedor
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' SET
                    DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                    USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(1)||'';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA ASIGNADO EL MEDIADOR: '''||V_TMP_TIPO_DATA(2)||''' AL PROVEEDOR: '''||V_TMP_TIPO_DATA(1)||''' ');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL PROVEEDOR CON PVE_COD_REM: '''||V_TMP_TIPO_DATA(1)||'''');
        
        END IF;

    END LOOP;

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
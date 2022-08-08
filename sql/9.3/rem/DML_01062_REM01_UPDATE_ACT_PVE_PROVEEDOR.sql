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
            T_TIPO_DATA('79','45'),
            T_TIPO_DATA('81','45'),
            T_TIPO_DATA('83','45'),
            T_TIPO_DATA('84','45'),
            T_TIPO_DATA('85','45'),
            T_TIPO_DATA('87','45'),
            T_TIPO_DATA('90','45'),
            T_TIPO_DATA('95','45'),
            T_TIPO_DATA('95','45'),
            T_TIPO_DATA('101','45'),
            T_TIPO_DATA('102','45'),
            T_TIPO_DATA('110','45'),
            T_TIPO_DATA('112','45'),
            T_TIPO_DATA('113','45'),
            T_TIPO_DATA('114','45'),
            T_TIPO_DATA('118','45'),
            T_TIPO_DATA('130','45'),
            T_TIPO_DATA('132','45'),
            T_TIPO_DATA('133','45'),
            T_TIPO_DATA('140','45'),
            T_TIPO_DATA('145','45'),
            T_TIPO_DATA('147','45'),
            T_TIPO_DATA('148','45'),
            T_TIPO_DATA('153','45'),
            T_TIPO_DATA('155','45'),
            T_TIPO_DATA('156','45'),
            T_TIPO_DATA('657','45'),
            T_TIPO_DATA('934','45'),
            T_TIPO_DATA('936','45'),
            T_TIPO_DATA('937','45'),
            T_TIPO_DATA('938','45'),
            T_TIPO_DATA('939','45'),
            T_TIPO_DATA('940','45'),
            T_TIPO_DATA('941','45'),
            T_TIPO_DATA('942','45'),
            T_TIPO_DATA('943','45'),
            T_TIPO_DATA('949','45'),
            T_TIPO_DATA('951','45'),
            T_TIPO_DATA('958','45'),
            T_TIPO_DATA('960','45'),
            T_TIPO_DATA('962','45'),
            T_TIPO_DATA('970','45'),
            T_TIPO_DATA('972','45'),
            T_TIPO_DATA('986','45'),
            T_TIPO_DATA('1061','45'),
            T_TIPO_DATA('1062','45'),
            T_TIPO_DATA('1062','45'),
            T_TIPO_DATA('1064','45'),
            T_TIPO_DATA('1068','45'),
            T_TIPO_DATA('1069','45'),
            T_TIPO_DATA('1072','45'),
            T_TIPO_DATA('1076','45'),
            T_TIPO_DATA('1077','45'),
            T_TIPO_DATA('1079','45'),
            T_TIPO_DATA('1085','45'),
            T_TIPO_DATA('1086','45'),
            T_TIPO_DATA('1095','45'),
            T_TIPO_DATA('1097','45'),
            T_TIPO_DATA('1099','45'),
            T_TIPO_DATA('1102','45'),
            T_TIPO_DATA('1103','45'),
            T_TIPO_DATA('1109','45'),
            T_TIPO_DATA('1123','45'),
            T_TIPO_DATA('1125','45'),
            T_TIPO_DATA('1128','45'),
            T_TIPO_DATA('1129','45'),
            T_TIPO_DATA('1133','45'),
            T_TIPO_DATA('1801','45'),
            T_TIPO_DATA('2089','45'),
            T_TIPO_DATA('2093','45'),
            T_TIPO_DATA('2095','45'),
            T_TIPO_DATA('2098','45'),
            T_TIPO_DATA('2100','45'),
            T_TIPO_DATA('2102','45'),
            T_TIPO_DATA('2104','45'),
            T_TIPO_DATA('2107','45'),
            T_TIPO_DATA('2108','45'),
            T_TIPO_DATA('2109','45'),
            T_TIPO_DATA('2114','45'),
            T_TIPO_DATA('2117','45'),
            T_TIPO_DATA('2118','45'),
            T_TIPO_DATA('2122','45'),
            T_TIPO_DATA('2123','45'),
            T_TIPO_DATA('2126','45'),
            T_TIPO_DATA('2128','45'),
            T_TIPO_DATA('2131','45'),
            T_TIPO_DATA('2133','45'),
            T_TIPO_DATA('2134','45'),
            T_TIPO_DATA('2139','45'),
            T_TIPO_DATA('2148','45'),
            T_TIPO_DATA('2157','45'),
            T_TIPO_DATA('2162','45'),
            T_TIPO_DATA('2165','45'),
            T_TIPO_DATA('2252','45'),
            T_TIPO_DATA('2256','45'),
            T_TIPO_DATA('2265','45'),
            T_TIPO_DATA('2267','45'),
            T_TIPO_DATA('2268','45'),
            T_TIPO_DATA('2273','45'),
            T_TIPO_DATA('2274','45'),
            T_TIPO_DATA('2276','45'),
            T_TIPO_DATA('2279','45'),
            T_TIPO_DATA('2286','45'),
            T_TIPO_DATA('2288','45'),
            T_TIPO_DATA('2291','45'),
            T_TIPO_DATA('2300','45'),
            T_TIPO_DATA('2302','45'),
            T_TIPO_DATA('2308','45'),
            T_TIPO_DATA('2310','45'),
            T_TIPO_DATA('2311','45'),
            T_TIPO_DATA('2312','45'),
            T_TIPO_DATA('2314','45'),
            T_TIPO_DATA('2317','45'),
            T_TIPO_DATA('2318','45'),
            T_TIPO_DATA('2325','45'),
            T_TIPO_DATA('2327','45'),
            T_TIPO_DATA('2423','45'),
            T_TIPO_DATA('3203','45'),
            T_TIPO_DATA('3204','45'),
            T_TIPO_DATA('3207','45'),
            T_TIPO_DATA('3216','45'),
            T_TIPO_DATA('3217','45'),
            T_TIPO_DATA('3220','45'),
            T_TIPO_DATA('3221','45'),
            T_TIPO_DATA('3224','45'),
            T_TIPO_DATA('3227','45'),
            T_TIPO_DATA('3229','45'),
            T_TIPO_DATA('3230','45'),
            T_TIPO_DATA('3236','45'),
            T_TIPO_DATA('3237','45'),
            T_TIPO_DATA('3239','45'),
            T_TIPO_DATA('3243','45'),
            T_TIPO_DATA('3245','45'),
            T_TIPO_DATA('3250','45'),
            T_TIPO_DATA('3252','45'),
            T_TIPO_DATA('3262','45'),
            T_TIPO_DATA('3264','45'),
            T_TIPO_DATA('3266','45'),
            T_TIPO_DATA('3268','45'),
            T_TIPO_DATA('3269','45'),
            T_TIPO_DATA('3282','45'),
            T_TIPO_DATA('3331','45'),
            T_TIPO_DATA('3333','45'),
            T_TIPO_DATA('3334','45'),
            T_TIPO_DATA('3337','45'),
            T_TIPO_DATA('3352','45'),
            T_TIPO_DATA('3361','45'),
            T_TIPO_DATA('3365','45'),
            T_TIPO_DATA('3367','45'),
            T_TIPO_DATA('3370','45'),
            T_TIPO_DATA('3375','45'),
            T_TIPO_DATA('3376','45'),
            T_TIPO_DATA('3382','45'),
            T_TIPO_DATA('3384','45'),
            T_TIPO_DATA('3387','45'),
            T_TIPO_DATA('3390','45'),
            T_TIPO_DATA('3391','45'),
            T_TIPO_DATA('3395','45'),
            T_TIPO_DATA('3398','45'),
            T_TIPO_DATA('4375','45'),
            T_TIPO_DATA('4378','45'),
            T_TIPO_DATA('4378','45'),
            T_TIPO_DATA('4379','45'),
            T_TIPO_DATA('4381','45'),
            T_TIPO_DATA('4382','45'),
            T_TIPO_DATA('4391','45'),
            T_TIPO_DATA('4397','45'),
            T_TIPO_DATA('4398','45'),
            T_TIPO_DATA('4503','45'),
            T_TIPO_DATA('4504','45'),
            T_TIPO_DATA('4505','45'),
            T_TIPO_DATA('4508','45'),
            T_TIPO_DATA('4510','45'),
            T_TIPO_DATA('4512','45'),
            T_TIPO_DATA('4537','45'),
            T_TIPO_DATA('4539','45'),
            T_TIPO_DATA('4541','45'),
            T_TIPO_DATA('4542','45'),
            T_TIPO_DATA('4545','45'),
            T_TIPO_DATA('9918','45'),
            T_TIPO_DATA('10007','45'),
            T_TIPO_DATA('10029','45'),
            T_TIPO_DATA('10053','45'),
            T_TIPO_DATA('10142','45'),
            T_TIPO_DATA('10216','45'),
            T_TIPO_DATA('10224','45'),
            T_TIPO_DATA('10225','45'),
            T_TIPO_DATA('10252','45'),
            T_TIPO_DATA('10287','45'),
            T_TIPO_DATA('10388','45'),
            T_TIPO_DATA('10465','45'),
            T_TIPO_DATA('10697','45'),
            T_TIPO_DATA('10717','45'),
            T_TIPO_DATA('10819','45'),
            T_TIPO_DATA('10834','45'),
            T_TIPO_DATA('10868','45'),
            T_TIPO_DATA('10890','45'),
            T_TIPO_DATA('10975','45'),
            T_TIPO_DATA('10997','45'),
            T_TIPO_DATA('11032','45'),
            T_TIPO_DATA('11087','45'),
            T_TIPO_DATA('11104','45'),
            T_TIPO_DATA('11186','45'),
            T_TIPO_DATA('11211','45'),
            T_TIPO_DATA('11227','45'),
            T_TIPO_DATA('11263','45'),
            T_TIPO_DATA('11306','45'),
            T_TIPO_DATA('11353','45'),
            T_TIPO_DATA('11424','45'),
            T_TIPO_DATA('11742','45'),
            T_TIPO_DATA('12183','45'),
            T_TIPO_DATA('12217','45'),
            T_TIPO_DATA('12276','45'),
            T_TIPO_DATA('12349','45'),
            T_TIPO_DATA('12685','45'),
            T_TIPO_DATA('12775','45'),
            T_TIPO_DATA('12782','45'),
            T_TIPO_DATA('12816','45'),
            T_TIPO_DATA('12839','45'),
            T_TIPO_DATA('12858','45'),
            T_TIPO_DATA('12941','45'),
            T_TIPO_DATA('12955','45'),
            T_TIPO_DATA('12979','45'),
            T_TIPO_DATA('13120','45'),
            T_TIPO_DATA('23247','45'),
            T_TIPO_DATA('23249','45'),
            T_TIPO_DATA('9990175','45'),
            T_TIPO_DATA('9990177','45'),
            T_TIPO_DATA('9990178','45'),
            T_TIPO_DATA('10005331','45'),
            T_TIPO_DATA('10006149','45'),
            T_TIPO_DATA('10006324','45'),
            T_TIPO_DATA('10006379','45'),
            T_TIPO_DATA('10006653','45'),
            T_TIPO_DATA('10006653','45'),
            T_TIPO_DATA('10006746','45'),
            T_TIPO_DATA('10006832','45'),
            T_TIPO_DATA('10007255','45'),
            T_TIPO_DATA('10007303','45'),
            T_TIPO_DATA('10007305','45'),
            T_TIPO_DATA('10007311','45'),
            T_TIPO_DATA('10007856','45'),
            T_TIPO_DATA('10008095','45'),
            T_TIPO_DATA('10008455','45'),
            T_TIPO_DATA('10008698','45'),
            T_TIPO_DATA('10009337','45'),
            T_TIPO_DATA('10009407','45'),
            T_TIPO_DATA('10009466','45'),
            T_TIPO_DATA('110061006','45'),
            T_TIPO_DATA('110061010','45'),
            T_TIPO_DATA('110064914','45'),
            T_TIPO_DATA('110076951','45'),
            T_TIPO_DATA('110078221','45'),
            T_TIPO_DATA('110078222','45'),
            T_TIPO_DATA('110079038','45'),
            T_TIPO_DATA('110079039','45'),
            T_TIPO_DATA('110081720','45'),
            T_TIPO_DATA('110082258','45'),
            T_TIPO_DATA('110097740','45'),
            T_TIPO_DATA('110098230','45'),
            T_TIPO_DATA('110161725','45'),
            T_TIPO_DATA('110216081','45')
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
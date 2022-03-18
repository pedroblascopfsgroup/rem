--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11352
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  update de los  proveedores en expediente comercial y ofertas
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    PVE_ANTIGUO  NUMBER(16); -- Vble. para validar la existencia de un valor en una tabla. 
    PVE_NUEVO  NUMBER(16); -- Vble. para validar la existencia de un valor en una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := ''; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11352';
    V_COUNT NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('BK7658','5536'),
        T_TIPO_DATA('BK7663','6050'),
        T_TIPO_DATA('BK7664','8955'),
        T_TIPO_DATA('BK7667','3598'),
        T_TIPO_DATA('BK7668','3634'),
        T_TIPO_DATA('BK7669','6127'),
        T_TIPO_DATA('BK7670','6319'),
        T_TIPO_DATA('BK7671','6443'),
        T_TIPO_DATA('BK7672','7283'),
        T_TIPO_DATA('BK7673','1558'),
        T_TIPO_DATA('BK7674','3641'),
        T_TIPO_DATA('BK7725','6305'),
        T_TIPO_DATA('BK7726','8777'),
        T_TIPO_DATA('BK7727','3681'),
        T_TIPO_DATA('BK7729','6275'),
        T_TIPO_DATA('BK7732','6131'),
        T_TIPO_DATA('BK7734','6905'),
        T_TIPO_DATA('BK7738','6133'),
        T_TIPO_DATA('BK7739','6135'),
        T_TIPO_DATA('BK7740','7292'),
        T_TIPO_DATA('BK7741','8028'),
        T_TIPO_DATA('BK7744','4175'),
        T_TIPO_DATA('BK7745','3638'),
        T_TIPO_DATA('BK7746','1952'),
        T_TIPO_DATA('BK7747','1277'),
        T_TIPO_DATA('BK7748','5526'),
        T_TIPO_DATA('BK7749','7986'),
        T_TIPO_DATA('BK7750','3567'),
        T_TIPO_DATA('BK7751','3592'),
        T_TIPO_DATA('BK7752','3627'),
        T_TIPO_DATA('BK7755','6138'),
        T_TIPO_DATA('BK7758','7817'),
        T_TIPO_DATA('BK7759','8958'),
        T_TIPO_DATA('BK7764','3599'),
        T_TIPO_DATA('BK7765','3595'),
        T_TIPO_DATA('BK7766','3625'),
        T_TIPO_DATA('BK7767','2812'),
        T_TIPO_DATA('BK7771','6818'),
        T_TIPO_DATA('BK7772','4770'),
        T_TIPO_DATA('BK7773','3855'),
        T_TIPO_DATA('BK7775','3772'),
        T_TIPO_DATA('BK7776','3593'),
        T_TIPO_DATA('BK7777','6140'),
        T_TIPO_DATA('BK7778','3538'),
        T_TIPO_DATA('BK7781','5591'),
        T_TIPO_DATA('BK7782','6101'),
        T_TIPO_DATA('BK7783','5132'),
        T_TIPO_DATA('BK7788','7142'),
        T_TIPO_DATA('BK7790','8849'),
        T_TIPO_DATA('BK7794','1994'),
        T_TIPO_DATA('BK7804','6482'),
        T_TIPO_DATA('BK7811','3133'),
        T_TIPO_DATA('BK7870','8201'),
        T_TIPO_DATA('BK7871','3175'),
        T_TIPO_DATA('BK7874','4394'),
        T_TIPO_DATA('BK7879','8703'),
        T_TIPO_DATA('BK7889','2907'),
        T_TIPO_DATA('BK7895','5412'),
        T_TIPO_DATA('BK7919','8085'),
        T_TIPO_DATA('BK8900','7868'),
        T_TIPO_DATA('BK8921','886'),
        T_TIPO_DATA('BK8923','7878'),
        T_TIPO_DATA('BK8929','7891'),
        T_TIPO_DATA('BK8937','276'),
        T_TIPO_DATA('BK8947','8905'),
        T_TIPO_DATA('BK8949','329'),
        T_TIPO_DATA('BK8973','8918'),
        T_TIPO_DATA('BK8978','8921'),
        T_TIPO_DATA('BK8980','8926'),
        T_TIPO_DATA('BK9001','8927'),
        T_TIPO_DATA('BK9002','8928'),
        T_TIPO_DATA('BK9003','8931'),
        T_TIPO_DATA('BK9004','8937'),
        T_TIPO_DATA('BK9005','8943'),
        T_TIPO_DATA('BK9010','1866'),
        T_TIPO_DATA('BK9011','5064'),
        T_TIPO_DATA('BK9015','2628'),
        T_TIPO_DATA('BK9019','9313'),
        T_TIPO_DATA('BK9026','1628'),
        T_TIPO_DATA('BK9034','7490'),
        T_TIPO_DATA('BK9036','7592'),
        T_TIPO_DATA('BK9039','7613'),
        T_TIPO_DATA('BK9042','7669'),
        T_TIPO_DATA('BK9043','7690'),
        T_TIPO_DATA('BK9044','7772'),
        T_TIPO_DATA('BK9053','2053'),
        T_TIPO_DATA('BK9110','2'),
        T_TIPO_DATA('BK9111','7389'),
        T_TIPO_DATA('BK9113','38'),
        T_TIPO_DATA('BK9114','5215'),
        T_TIPO_DATA('BK9117','5955'),
        T_TIPO_DATA('BK9121','7193'),
        T_TIPO_DATA('BK9128','7346'),
        T_TIPO_DATA('BK9129','7426'),
        T_TIPO_DATA('BK9145','1464'),
        T_TIPO_DATA('BK9152','1475'),
        T_TIPO_DATA('BK9201','7201'),
        T_TIPO_DATA('BK9207','1210'),
        T_TIPO_DATA('BK9212','7712'),
        T_TIPO_DATA('BK9218','2236'),
        T_TIPO_DATA('BK9221','3591'),
        T_TIPO_DATA('BK9224','7730'),
        T_TIPO_DATA('BK9225','7734'),
        T_TIPO_DATA('BK9227','7744'),
        T_TIPO_DATA('BK9229','3497'),
        T_TIPO_DATA('BK9230','1760'),
        T_TIPO_DATA('BK9231','802'),
        T_TIPO_DATA('BK9232','7867'),
        T_TIPO_DATA('BK9235','1387'),
        T_TIPO_DATA('BK9236','7894'),
        T_TIPO_DATA('BK9243','2330'),
        T_TIPO_DATA('BK9246','3488'),
        T_TIPO_DATA('BK9247','5265'),
        T_TIPO_DATA('BK9248','5376'),
        T_TIPO_DATA('BK9249','3583'),
        T_TIPO_DATA('BK9251','5673'),
        T_TIPO_DATA('BK9254','3033'),
        T_TIPO_DATA('BK9256','7127'),
        T_TIPO_DATA('BK9261','7197'),
        T_TIPO_DATA('BK9263','3857'),
        T_TIPO_DATA('BK9265','4395'),
        T_TIPO_DATA('BK9266','3453'),
        T_TIPO_DATA('BK9279','542'),
        T_TIPO_DATA('BK9283','5165'),
        T_TIPO_DATA('BK9294','5266'),
        T_TIPO_DATA('BK9296','7020'),
        T_TIPO_DATA('BK9300','2814'),
        T_TIPO_DATA('BK9301','2814'),
        T_TIPO_DATA('BK9302','5239'),
        T_TIPO_DATA('BK9304','6323'),
        T_TIPO_DATA('BK9305','1284'),
        T_TIPO_DATA('BK9306','1285'),
        T_TIPO_DATA('BK9307','7588'),
        T_TIPO_DATA('BK9308','7763'),
        T_TIPO_DATA('BK9309','8047'),
        T_TIPO_DATA('BK9310','1280'),
        T_TIPO_DATA('BK9311','4192'),
        T_TIPO_DATA('BK9313','6160'),
        T_TIPO_DATA('BK9314','1282'),
        T_TIPO_DATA('BK9315','1281'),
        T_TIPO_DATA('BK9316','7424'),
        T_TIPO_DATA('BK9317','2069'),
        T_TIPO_DATA('BK9318','1278'),
        T_TIPO_DATA('BK9321','4594'),
        T_TIPO_DATA('BK9323','7266'),
        T_TIPO_DATA('BK9400','7297'),
        T_TIPO_DATA('BK9401','7372'),
        T_TIPO_DATA('BK9407','7409'),
        T_TIPO_DATA('BK9408','7420'),
        T_TIPO_DATA('BK9409','7507'),
        T_TIPO_DATA('BK9411','4145'),
        T_TIPO_DATA('BK9413','4414'),
        T_TIPO_DATA('BK9414','6014'),
        T_TIPO_DATA('BK9417','7188'),
        T_TIPO_DATA('BK9420','7466'),
        T_TIPO_DATA('BK9428','2343'),
        T_TIPO_DATA('BK9430','2532'),
        T_TIPO_DATA('BK9432','8543'),
        T_TIPO_DATA('BK9433','1599'),
        T_TIPO_DATA('BK9436','3276'),
        T_TIPO_DATA('BK9438','1770'),
        T_TIPO_DATA('BK9441','7611'),
        T_TIPO_DATA('BK9442','2115'),
        T_TIPO_DATA('BK9443','3276'),
        T_TIPO_DATA('BK9444','2303'),
        T_TIPO_DATA('BK9445','4858'),
        T_TIPO_DATA('BK9446','3354'),
        T_TIPO_DATA('BK9447','5121'),
        T_TIPO_DATA('BK9449','1956'),
        T_TIPO_DATA('BK9453','7858'),
        T_TIPO_DATA('BK9506','7012'),
        T_TIPO_DATA('BK9600','4363'),
        T_TIPO_DATA('BK9602','2419'),
        T_TIPO_DATA('BK9603','5692'),
        T_TIPO_DATA('BK9606','6031'),
        T_TIPO_DATA('BK9607','7899'),
        T_TIPO_DATA('BK9608','3807'),
        T_TIPO_DATA('BK9611','2764'),
        T_TIPO_DATA('BK9612','1795'),
        T_TIPO_DATA('BK9615','5378'),
        T_TIPO_DATA('BK9616','2342'),
        T_TIPO_DATA('BK9618','3790'),
        T_TIPO_DATA('BK9619','5216'),
        T_TIPO_DATA('BK9620','5808'),
        T_TIPO_DATA('BK9621','6039'),
        T_TIPO_DATA('BK9622','6208'),
        T_TIPO_DATA('BK9625','6925'),
        T_TIPO_DATA('BK9631','7316'),
        T_TIPO_DATA('BK9632','7845'),
        T_TIPO_DATA('BK9633','7853'),
        T_TIPO_DATA('BK9636','8859'),
        T_TIPO_DATA('BK9638','8880'),
        T_TIPO_DATA('BK9639','4154'),
        T_TIPO_DATA('BK9642','2157'),
        T_TIPO_DATA('BK9644','2134'),
        T_TIPO_DATA('BK9653','7731'),
        T_TIPO_DATA('BK9654','2774'),
        T_TIPO_DATA('BK9665','1540'),
        T_TIPO_DATA('BK9670','6231'),
        T_TIPO_DATA('BK9673','6968'),
        T_TIPO_DATA('BK9675','2694'),
        T_TIPO_DATA('BK9676','4241'),
        T_TIPO_DATA('BK9678','4575'),
        T_TIPO_DATA('BK9679','3762'),
        T_TIPO_DATA('BK9695','6191'),
        T_TIPO_DATA('BK9699','7449'),
        T_TIPO_DATA('BK9711','7672'),
        T_TIPO_DATA('BK9717','2765'),
        T_TIPO_DATA('BK9755','7733'),
        T_TIPO_DATA('BK9758','2653'),
        T_TIPO_DATA('BK9759','4626'),
        T_TIPO_DATA('BK9763','2735'),
        T_TIPO_DATA('BK9780','7676'),
        T_TIPO_DATA('BK9788','2719'),
        T_TIPO_DATA('BK9800','7408'),
        T_TIPO_DATA('BK9801','7413'),
        T_TIPO_DATA('BK9803','2399'),
        T_TIPO_DATA('BK9804','5368'),
        T_TIPO_DATA('BK9805','7392'),
        T_TIPO_DATA('BK9806','8475'),
        T_TIPO_DATA('BK9807','7465'),
        T_TIPO_DATA('BK9808','7486'),
        T_TIPO_DATA('BK9810','2360'),
        T_TIPO_DATA('BK9814','7234'),
        T_TIPO_DATA('BK9822','7589'),
        T_TIPO_DATA('BK9832','7670'),
        T_TIPO_DATA('BK9834','7701'),
        T_TIPO_DATA('BK9835','7761'),
        T_TIPO_DATA('BK9836','7764'),
        T_TIPO_DATA('BK9837','8726'),
        T_TIPO_DATA('BK9842','4075'),
        T_TIPO_DATA('BK9844','2320'),
        T_TIPO_DATA('BK9849','7851'),
        T_TIPO_DATA('BK9850','7871'),
        T_TIPO_DATA('BK9852','8920'),
        T_TIPO_DATA('BK9857','2599'),
        T_TIPO_DATA('BK9859','2913'),
        T_TIPO_DATA('BK9861','2804'),
        T_TIPO_DATA('BK9872','7187'),
        T_TIPO_DATA('BK9873','7267'),
        T_TIPO_DATA('BK9875','7382'),
        T_TIPO_DATA('BK9876','4417'),
        T_TIPO_DATA('BK9877','2107'),
        T_TIPO_DATA('BK9878','2788'),
        T_TIPO_DATA('BK9880','2701'),
        T_TIPO_DATA('BK9881','5507'),
        T_TIPO_DATA('BK9882','7407'),
        T_TIPO_DATA('BK9884','2179'),
        T_TIPO_DATA('BK9890','5423'),
        T_TIPO_DATA('BK9891','6105'),
        T_TIPO_DATA('BK9896','7691'),
        T_TIPO_DATA('BK9897','7719'),
        T_TIPO_DATA('BK9901','7859'),
        T_TIPO_DATA('BK9903','1243'),
        T_TIPO_DATA('BK9904','4981'),
        T_TIPO_DATA('BK9905','5069'),
        T_TIPO_DATA('BK9906','7397'),
        T_TIPO_DATA('BK9909','7872'),
        T_TIPO_DATA('BK9913','2750'),
        T_TIPO_DATA('BK9914','4339'),
        T_TIPO_DATA('BK9915','4143'),
        T_TIPO_DATA('BK9918','1957'),
        T_TIPO_DATA('BK9919','3365'),
        T_TIPO_DATA('BK9920','865'),
        T_TIPO_DATA('BK9921','8878'),
        T_TIPO_DATA('BK9922','3931'),
        T_TIPO_DATA('BK9923','1095'),
        T_TIPO_DATA('BK9925','5083'),
        T_TIPO_DATA('BK9926','7487'),
        T_TIPO_DATA('BK9929','7622'),
        T_TIPO_DATA('BK9931','7793'),
        T_TIPO_DATA('BK9932','2874'),
        T_TIPO_DATA('BK9934','4301'),
        T_TIPO_DATA('BK9935','5213'),
        T_TIPO_DATA('BK9937','5268'),
        T_TIPO_DATA('BK9938','7344'),
        T_TIPO_DATA('BK9939','8929'),
        T_TIPO_DATA('BK9941','2791'),
        T_TIPO_DATA('BK9942','4971'),
        T_TIPO_DATA('BK9943','5580'),
        T_TIPO_DATA('BK9950','9723'),
        T_TIPO_DATA('BK9951','6030'),
        T_TIPO_DATA('BK9957','6809'),
        T_TIPO_DATA('BK9958','2160'),
        T_TIPO_DATA('BK9961','7773'),
        T_TIPO_DATA('BK9970','7842'),
        T_TIPO_DATA('BK9974','6'),
        T_TIPO_DATA('BK9976','4972'),
        T_TIPO_DATA('BK9980','5907'),
        T_TIPO_DATA('BK9981','7295'),
        T_TIPO_DATA('BK9982','56'),
        T_TIPO_DATA('BK9985','7852'),
        T_TIPO_DATA('BK9987','4340'),
        T_TIPO_DATA('BK9991','7405'),
        T_TIPO_DATA('BK9993','7703'),
        T_TIPO_DATA('BK6162','2702'),
        T_TIPO_DATA('BK5623','6254'),
        T_TIPO_DATA('BK8707','6019'),
        T_TIPO_DATA('BK5216','9619'),
        T_TIPO_DATA('BK5919','3014'),
        T_TIPO_DATA('BK4971','9942'),
        T_TIPO_DATA('BK8222','2354'),
        T_TIPO_DATA('BK8224','3033'),
        T_TIPO_DATA('BK6091','6520'),
        T_TIPO_DATA('BK9102','1888'),
        T_TIPO_DATA('BK4094','7061'),
        T_TIPO_DATA('BK7837','8745'),
        T_TIPO_DATA('BK6345','2918'),
        T_TIPO_DATA('BK8182','3020'),
        T_TIPO_DATA('BK1522','5836'),
        T_TIPO_DATA('BK1532','4904'),
        T_TIPO_DATA('BK1560','4904'),
        T_TIPO_DATA('BK1994','3264'),
        T_TIPO_DATA('BK2823','8652'),
        T_TIPO_DATA('BK2831','8674'),
        T_TIPO_DATA('BK4045','6433'),
        T_TIPO_DATA('BK4115','8629'),
        T_TIPO_DATA('BK4118','5426'),
        T_TIPO_DATA('BK4119','8658'),
        T_TIPO_DATA('BK4120','3383'),
        T_TIPO_DATA('BK4122','8645'),
        T_TIPO_DATA('BK4123','8663'),
        T_TIPO_DATA('BK4124','8664'),
        T_TIPO_DATA('BK4125','8684'),
        T_TIPO_DATA('BK4127','8667'),
        T_TIPO_DATA('BK4130','8682'),
        T_TIPO_DATA('BK4132','8666'),
        T_TIPO_DATA('BK4133','8640'),
        T_TIPO_DATA('BK4136','1882'),
        T_TIPO_DATA('BK4218','6544'),
        T_TIPO_DATA('BK4221','8620'),
        T_TIPO_DATA('BK4222','6593'),
        T_TIPO_DATA('BK4507','8601'),
        T_TIPO_DATA('BK4721','9148'),
        T_TIPO_DATA('BK5837','4904'),
        T_TIPO_DATA('BK5889','8617'),
        T_TIPO_DATA('BK5903','8654'),
        T_TIPO_DATA('BK5908','7758'),
        T_TIPO_DATA('BK5910','8784'),
        T_TIPO_DATA('BK5911','8678'),
        T_TIPO_DATA('BK8700','8632'),
        T_TIPO_DATA('BK8701','8610'),
        T_TIPO_DATA('BK8709','7700'),
        T_TIPO_DATA('BK8715','7784'),
        T_TIPO_DATA('BK8716','3680'),
        T_TIPO_DATA('BK8720','3445'),
        T_TIPO_DATA('BK8722','7799'),
        T_TIPO_DATA('BK8723','7807'),
        T_TIPO_DATA('BK8731','7829'),
        T_TIPO_DATA('BK8745','7837'),
        T_TIPO_DATA('BK8746','3542'),
        T_TIPO_DATA('BK9024','8602'),
        T_TIPO_DATA('BK9157','5214'),
        T_TIPO_DATA('BK9208','7706'),
        T_TIPO_DATA('BK9237','8607'),
        T_TIPO_DATA('BK9238','1173'),
        T_TIPO_DATA('BK9242','3804'),
        T_TIPO_DATA('BK9463','8656'),
        T_TIPO_DATA('BK9466','5389'),
        T_TIPO_DATA('BK9501','5963'),
        T_TIPO_DATA('BK9504','8619'),
        T_TIPO_DATA('BK9651','3805'),
        T_TIPO_DATA('BK9659','8624'),
        T_TIPO_DATA('BK9668','8621'),
        T_TIPO_DATA('BK9682','5871'),
        T_TIPO_DATA('BK9683','7345'),
        T_TIPO_DATA('BK9684','8608'),
        T_TIPO_DATA('BK9685','1476'),
        T_TIPO_DATA('BK9690','5414'),
        T_TIPO_DATA('BK9691','8615'),
        T_TIPO_DATA('BK9709','7655'),
        T_TIPO_DATA('BK9784','8860'),
        T_TIPO_DATA('BK9792','1468')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN TABLAS GEX_GASTOS_EXPEDIENTE y OFR_OFERTAS');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        PVE_ANTIGUO := 0;
        PVE_NUEVO := 0;

        --Comprobar el dato a updatear.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        DBMS_OUTPUT.PUT_LINE('[INFO]: V_MSQL ' || V_MSQL);
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        
        IF V_COUNT = 1 THEN

        V_MSQL := 'SELECT pve.PVE_ID FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO PVE_ANTIGUO;
        
        END IF;
        
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        
        IF V_COUNT = 1 THEN
        
        V_MSQL := 'SELECT pve.PVE_ID FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO PVE_NUEVO;
        
         END IF;

        -- Si existe se modifica.
        IF PVE_ANTIGUO != 0 AND PVE_NUEVO != 0 THEN		
                -- Actualiza GEX_GASTOS_EXPEDIENTE GEX_PROVEEDOR 
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  GEX_PROVEEDOR '''|| PVE_ANTIGUO ||''' A  '''|| PVE_NUEVO ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.GEX_GASTOS_EXPEDIENTE GEX
                            SET GEX.GEX_PROVEEDOR = '||PVE_NUEVO||'
                             , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                             , FECHAMODIFICAR = SYSDATE 
                            WHERE 
                                GEX.ECO_ID IN (SELECT ECO.ECO_ID FROM '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO 
                                                                    JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
                                                                    JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS_CAIXA OOC ON OOC.OFR_ID = OFR.OFR_ID
                                                                    WHERE OOC.BORRADO = 0
                                                                        AND ECO.BORRADO = 0
                                                                        AND OFR.BORRADO = 0)
                                AND GEX.GEX_PROVEEDOR  = '||PVE_ANTIGUO||'
                                AND GEX.BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO GEX_PROVEEDOR MODIFICADO CORRECTAMENTE');

          

           
                -- Actualiza OFR_OFERTAS PVE_ID_PRESCRIPTOR 
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO EN TABLA OFR_OFERTAS PVE_ID_PRESCRIPTOR '''|| PVE_ANTIGUO ||''' A  '''|| PVE_NUEVO ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.OFR_OFERTAS ofr
                            SET ofr.PVE_ID_PRESCRIPTOR = '||PVE_NUEVO||'
                             , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                             , FECHAMODIFICAR = SYSDATE 
                            WHERE 
                                ofr.OFR_ID IN (SELECT ofrcx.OFR_ID FROM '|| V_ESQUEMA ||'.OFR_OFERTAS_CAIXA ofrcx WHERE ofrcx.BORRADO = 0)
                                AND ofr.PVE_ID_PRESCRIPTOR  = '||PVE_ANTIGUO||'
                                AND ofr.BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO PVE_ID_PRESCRIPTOR MODIFICADO CORRECTAMENTE');

            
                -- Actualiza OFR_OFERTAS PVE_ID_CUSTODIO 
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO EN TABLA OFR_OFERTAS PVE_ID_CUSTODIO  '''|| PVE_ANTIGUO ||''' A  '''|| PVE_NUEVO ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.OFR_OFERTAS ofr
                            SET ofr.PVE_ID_CUSTODIO = '||PVE_NUEVO||'
                             , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                             , FECHAMODIFICAR = SYSDATE 
                            WHERE 
                                ofr.OFR_ID IN (SELECT ofrcx.OFR_ID FROM '|| V_ESQUEMA ||'.OFR_OFERTAS_CAIXA ofrcx WHERE ofrcx.BORRADO = 0)
                                AND ofr.PVE_ID_CUSTODIO  = '||PVE_ANTIGUO||'
                                AND ofr.BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO PVE_ID_CUSTODIO MODIFICADO CORRECTAMENTE');
       ELSE
       	-- Si no existe se actualiza.
          DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON PVE_COD_API_PROVEEDOR:  '||TRIM(V_TMP_TIPO_DATA(1))||' O '||TRIM(V_TMP_TIPO_DATA(2))||'');

       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACTUALIZADO CORRECTAMENTE ');

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

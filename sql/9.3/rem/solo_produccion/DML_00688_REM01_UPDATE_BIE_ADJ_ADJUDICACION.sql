--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9048
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar proveedor contacto trabajos y proveedor prefacturas
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


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9048'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_ID_PROVEEDOR NUMBER(16); -- Vble. para el id del proveedor

    V_TABLA VARCHAR2(50 CHAR):= 'BIE_ADJ_ADJUDICACION'; --Vble. Tabla a modificar proveedores

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7301965','30/11/2020'),
            T_TIPO_DATA('7300963','17/12/2020'),
            T_TIPO_DATA('7300830','30/12/2020'),
            T_TIPO_DATA('7292715','31/07/2019'),
            T_TIPO_DATA('7292494','01/09/2020'),
            T_TIPO_DATA('7292497','01/09/2020'),
            T_TIPO_DATA('7230123','02/09/2019'),
            T_TIPO_DATA('7230122','02/09/2019'),
            T_TIPO_DATA('7030773','23/10/2020'),
            T_TIPO_DATA('7029487','03/09/2018'),
            T_TIPO_DATA('7029497','03/09/2018'),
            T_TIPO_DATA('7029462','03/09/2018'),
            T_TIPO_DATA('7029435','03/09/2018'),
            T_TIPO_DATA('7029421','03/09/2018'),
            T_TIPO_DATA('7029461','03/09/2018'),
            T_TIPO_DATA('7029498','03/09/2018'),
            T_TIPO_DATA('7029429','03/09/2018'),
            T_TIPO_DATA('7029490','03/09/2018'),
            T_TIPO_DATA('7029471','03/09/2018'),
            T_TIPO_DATA('7029424','03/09/2018'),
            T_TIPO_DATA('6080972','21/11/2018'),
            T_TIPO_DATA('6080971','21/11/2018'),
            T_TIPO_DATA('6080970','21/11/2018'),
            T_TIPO_DATA('6080969','15/10/2020'),
            T_TIPO_DATA('6076258','11/03/2020'),
            T_TIPO_DATA('6083460','16/10/2020'),
            T_TIPO_DATA('7229269','31/12/2020'),
            T_TIPO_DATA('7228953','12/07/2019'),
            T_TIPO_DATA('7029486','03/09/2018'),
            T_TIPO_DATA('7029493','03/09/2018'),
            T_TIPO_DATA('7029476','03/09/2018'),
            T_TIPO_DATA('7029408','03/09/2018'),
            T_TIPO_DATA('7029489','03/09/2018'),
            T_TIPO_DATA('7029463','03/09/2018'),
            T_TIPO_DATA('7029422','03/09/2018'),
            T_TIPO_DATA('7029425','03/09/2018'),
            T_TIPO_DATA('7029492','03/09/2018'),
            T_TIPO_DATA('7029491','03/09/2018'),
            T_TIPO_DATA('7029455','03/09/2018'),
            T_TIPO_DATA('7029401','03/09/2018'),
            T_TIPO_DATA('7029473','03/09/2018'),
            T_TIPO_DATA('7029459','03/09/2018'),
            T_TIPO_DATA('7029481','03/09/2018'),
            T_TIPO_DATA('7029482','03/09/2018'),
            T_TIPO_DATA('7029428','03/09/2018'),
            T_TIPO_DATA('7029436','03/09/2018'),
            T_TIPO_DATA('7029496','03/09/2018'),
            T_TIPO_DATA('7029409','03/09/2018'),
            T_TIPO_DATA('7029437','03/09/2018'),
            T_TIPO_DATA('7029469','03/09/2018'),
            T_TIPO_DATA('7029430','03/09/2018'),
            T_TIPO_DATA('7029472','03/09/2018'),
            T_TIPO_DATA('7029433','03/09/2018'),
            T_TIPO_DATA('7029404','03/09/2018'),
            T_TIPO_DATA('7029470','03/09/2018'),
            T_TIPO_DATA('7029445','03/09/2018'),
            T_TIPO_DATA('7029434','03/09/2018'),
            T_TIPO_DATA('7029494','03/09/2018'),
            T_TIPO_DATA('7029446','03/09/2018'),
            T_TIPO_DATA('7029485','03/09/2018'),
            T_TIPO_DATA('7029444','03/09/2018'),
            T_TIPO_DATA('7029450','03/09/2018'),
            T_TIPO_DATA('7029475','03/09/2018'),
            T_TIPO_DATA('7029474','03/09/2018'),
            T_TIPO_DATA('7029460','03/09/2018'),
            T_TIPO_DATA('7029468','03/09/2018'),
            T_TIPO_DATA('7029484','03/09/2018'),
            T_TIPO_DATA('7029449','03/09/2018'),
            T_TIPO_DATA('7029457','03/09/2018'),
            T_TIPO_DATA('7029451','03/09/2018'),
            T_TIPO_DATA('7029427','03/09/2018'),
            T_TIPO_DATA('7029477','03/09/2018'),
            T_TIPO_DATA('7029452','03/09/2018'),
            T_TIPO_DATA('7029442','03/09/2018'),
            T_TIPO_DATA('7029448','03/09/2018'),
            T_TIPO_DATA('7029454','03/09/2018'),
            T_TIPO_DATA('7020143','11/12/2020'),
            T_TIPO_DATA('6940711','02/12/2019'),
            T_TIPO_DATA('6031787','18/01/2019'),
            T_TIPO_DATA('7432703','27/01/2021'),
            T_TIPO_DATA('7300139','08/01/2020'),
            T_TIPO_DATA('7299584','23/01/2020'),
            T_TIPO_DATA('7299561','24/03/2020'),
            T_TIPO_DATA('7226559','10/12/2020'),
            T_TIPO_DATA('7226538','11/06/2019'),
            T_TIPO_DATA('7226468','12/06/2019'),
            T_TIPO_DATA('7017659','18/12/2020'),
            T_TIPO_DATA('7016543','16/06/2016'),
            T_TIPO_DATA('7016565','16/06/2016'),
            T_TIPO_DATA('7016517','16/06/2016'),
            T_TIPO_DATA('7016532','16/06/2016'),
            T_TIPO_DATA('7016541','16/06/2016'),
            T_TIPO_DATA('7016560','16/06/2016'),
            T_TIPO_DATA('7016494','16/06/2016'),
            T_TIPO_DATA('7015745','23/01/2018'),
            T_TIPO_DATA('6809432','03/09/2020'),
            T_TIPO_DATA('6520256','10/11/2020'),
            T_TIPO_DATA('6520347','20/10/2020'),
            T_TIPO_DATA('6083511','20/12/2014'),
            T_TIPO_DATA('6081937','31/12/2020'),
            T_TIPO_DATA('6081557','25/01/2021'),
            T_TIPO_DATA('7298872','09/12/2020'),
            T_TIPO_DATA('7298519','17/12/2020'),
            T_TIPO_DATA('7224521','10/11/2020'),
            T_TIPO_DATA('7224377','03/07/2020'),
            T_TIPO_DATA('7224344','29/04/2019'),
            T_TIPO_DATA('6788806','20/01/2021'),
            T_TIPO_DATA('6346315','25/09/2015'),
            T_TIPO_DATA('6135594','24/11/2020'),
            T_TIPO_DATA('6078228','30/12/2020'),
            T_TIPO_DATA('6076450','06/11/2020'),
            T_TIPO_DATA('6083895','05/11/2020'),
            T_TIPO_DATA('7423263','04/11/2020'),
            T_TIPO_DATA('7403412','27/01/2021'),
            T_TIPO_DATA('7298527','16/10/2020'),
            T_TIPO_DATA('7224366','29/04/2019'),
            T_TIPO_DATA('7224342','29/04/2019'),
            T_TIPO_DATA('7224352','29/04/2019'),
            T_TIPO_DATA('7224356','29/04/2019'),
            T_TIPO_DATA('7224362','29/04/2019'),
            T_TIPO_DATA('7224353','29/04/2019'),
            T_TIPO_DATA('7224360','29/04/2019'),
            T_TIPO_DATA('7224347','29/04/2019'),
            T_TIPO_DATA('7224367','29/04/2019'),
            T_TIPO_DATA('7224357','29/04/2019'),
            T_TIPO_DATA('7224346','29/04/2019'),
            T_TIPO_DATA('7224359','29/04/2019'),
            T_TIPO_DATA('7224358','19/04/2019'),
            T_TIPO_DATA('7016513','16/06/2016'),
            T_TIPO_DATA('6786818','15/01/2021'),
            T_TIPO_DATA('6786833','15/01/2021'),
            T_TIPO_DATA('6786847','15/01/2021'),
            T_TIPO_DATA('6786862','15/01/2021'),
            T_TIPO_DATA('6786866','15/01/2021'),
            T_TIPO_DATA('6785306','17/12/2020'),
            T_TIPO_DATA('6081199','07/11/2013'),
            T_TIPO_DATA('7298043','23/10/2020'),
            T_TIPO_DATA('7298053','09/11/2020'),
            T_TIPO_DATA('7297857','05/08/2020'),
            T_TIPO_DATA('7224045','27/07/2020'),
            T_TIPO_DATA('7102045','01/08/2019'),
            T_TIPO_DATA('7101956','16/11/2020'),
            T_TIPO_DATA('7007503','19/09/2018'),
            T_TIPO_DATA('6885687','01/07/2020'),
            T_TIPO_DATA('6134065','10/02/2016'),
            T_TIPO_DATA('6133858','10/02/2016'),
            T_TIPO_DATA('6133825','19/11/2015'),
            T_TIPO_DATA('6134887','13/11/2018'),
            T_TIPO_DATA('7386280','10/12/2020'),
            T_TIPO_DATA('7386289','10/12/2020'),
            T_TIPO_DATA('7386290','10/12/2020'),
            T_TIPO_DATA('7386288','10/12/2020'),
            T_TIPO_DATA('7385870','29/09/2020'),
            T_TIPO_DATA('7385865','29/09/2020'),
            T_TIPO_DATA('7385857','30/12/2020'),
            T_TIPO_DATA('7297809','05/11/2020'),
            T_TIPO_DATA('7297779','07/07/2020'),
            T_TIPO_DATA('7297662','27/11/2020'),
            T_TIPO_DATA('7297456','30/11/2020'),
            T_TIPO_DATA('7297494','23/09/2020'),
            T_TIPO_DATA('7101169','08/04/2019'),
            T_TIPO_DATA('7101066','12/04/2019'),
            T_TIPO_DATA('7101033','10/11/2020'),
            T_TIPO_DATA('6978807','08/03/2018'),
            T_TIPO_DATA('7385555','20/11/2020'),
            T_TIPO_DATA('7330116','08/10/2020'),
            T_TIPO_DATA('7297119','14/09/2020'),
            T_TIPO_DATA('7295344','18/12/2020'),
            T_TIPO_DATA('7295235','18/12/2020'),
            T_TIPO_DATA('7295355','18/12/2020'),
            T_TIPO_DATA('7295269','18/12/2020'),
            T_TIPO_DATA('7100086','15/10/2020'),
            T_TIPO_DATA('7076224','01/11/2019'),
            T_TIPO_DATA('6972886','20/10/2020'),
            T_TIPO_DATA('6837504','31/03/2017'),
            T_TIPO_DATA('6837474','31/03/2017'),
            T_TIPO_DATA('6837494','31/03/2017'),
            T_TIPO_DATA('6837561','31/03/2017'),
            T_TIPO_DATA('6084284','02/10/2020'),
            T_TIPO_DATA('7303226','15/09/2020'),
            T_TIPO_DATA('7076171','15/02/2021'),
            T_TIPO_DATA('7075712','04/02/2021'),
            T_TIPO_DATA('7075715','04/02/2021'),
            T_TIPO_DATA('7075616','15/09/2020'),
            T_TIPO_DATA('7075084','04/02/2019'),
            T_TIPO_DATA('7075085','04/02/2019'),
            T_TIPO_DATA('6079038','01/12/2020'),
            T_TIPO_DATA('6081912','29/09/2011'),
            T_TIPO_DATA('7295220','17/09/2020'),
            T_TIPO_DATA('7294903','05/08/2020'),
            T_TIPO_DATA('7294779','13/03/2020'),
            T_TIPO_DATA('7294499','11/12/2020'),
            T_TIPO_DATA('7294475','17/12/2020'),
            T_TIPO_DATA('7294466','01/10/2019'),
            T_TIPO_DATA('7074933','30/12/2020'),
            T_TIPO_DATA('7074266','02/07/2020'),
            T_TIPO_DATA('6833022','10/01/2017'),
            T_TIPO_DATA('6831170','30/09/2020'),
            T_TIPO_DATA('6756408','23/10/2018'),
            T_TIPO_DATA('6077776','26/10/2020'),
            T_TIPO_DATA('7293983','28/11/2020'),
            T_TIPO_DATA('7071393','21/11/2018'),
            T_TIPO_DATA('6961654','14/05/2020'),
            T_TIPO_DATA('6950452','02/04/2018'),
            T_TIPO_DATA('6823258','21/01/2021'),
            T_TIPO_DATA('6745094','10/12/2020'),
            T_TIPO_DATA('6082955','18/06/2020'),
            T_TIPO_DATA('6076900','26/11/2015'),
            T_TIPO_DATA('7293732','19/09/2019'),
            T_TIPO_DATA('7293686','19/09/2019'),
            T_TIPO_DATA('7293668','19/09/2019'),
            T_TIPO_DATA('7293707','19/09/2019'),
            T_TIPO_DATA('7293671','19/09/2019'),
            T_TIPO_DATA('7293649','19/09/2019'),
            T_TIPO_DATA('7293663','19/09/2019'),
            T_TIPO_DATA('7293710','19/09/2019'),
            T_TIPO_DATA('7293690','19/09/2019'),
            T_TIPO_DATA('7293221','13/10/2020'),
            T_TIPO_DATA('7293212','13/10/2020'),
            T_TIPO_DATA('7068192','24/03/2020'),
            T_TIPO_DATA('7068203','24/03/2020'),
            T_TIPO_DATA('7068208','30/09/2020'),
            T_TIPO_DATA('7032294','11/09/2019'),
            T_TIPO_DATA('7032073','25/01/2021'),
            T_TIPO_DATA('6711407','21/06/2016')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: AÑADIMOS FECHA REALIZACION POSESION');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID=ACT.ACT_ID
                JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ ON ADJ.BIE_ADJ_ID=AJD.BIE_ADJ_ID
                WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO=0 AND AJD.BORRADO=0 AND ADJ.BORRADO=0';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT = 1 THEN

            V_MSQL := 'SELECT ADJ.BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID=ACT.ACT_ID
                JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ ON ADJ.BIE_ADJ_ID=AJD.BIE_ADJ_ID
                WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO=0 AND AJD.BORRADO=0 AND ADJ.BORRADO=0';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

            --Actualizamos LA FECHA DE REALIZACION POSESION
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
            BIE_ADJ_F_REA_POSESION= TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''DD/MM/YYYY''),
            USUARIOMODIFICAR = '''|| V_USUARIO ||''',
            FECHAMODIFICAR = SYSDATE
            WHERE BIE_ID = '||V_ID||'';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO CORRECTAMENTE');
            
        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO NO TIENE REGISTRO EN BIE_ADJ_ADJUDICACION NUM_ACTIVO:'''||V_TMP_TIPO_DATA(1)||'''');
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
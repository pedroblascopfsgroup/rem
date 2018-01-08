--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=HREOS-3591
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de activos traspasados (TANGO).   
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_MSQL VARCHAR2(2048 CHAR);
    V_TABLA VARCHAR2(30 CHAR) := 'AUX_ACTIVOS_TRASP_PRINEX';
    V_ESQUEMA VARCHAR2(15 CHAR) := 'REM01';
    V_EXISTS NUMBER(1);
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('68516'),
        T_TIPO_DATA('58316'),
        T_TIPO_DATA('7031'),
        T_TIPO_DATA('62674'),
        T_TIPO_DATA('65131'),
        T_TIPO_DATA('43048'),
        T_TIPO_DATA('10356'),
        T_TIPO_DATA('70330'),
        T_TIPO_DATA('49549'),
        T_TIPO_DATA('41581'),
        T_TIPO_DATA('73858'),
        T_TIPO_DATA('71758'),
        T_TIPO_DATA('67406'),
        T_TIPO_DATA('67407'),
        T_TIPO_DATA('67408'),
        T_TIPO_DATA('67409'),
        T_TIPO_DATA('49550'),
        T_TIPO_DATA('46231'),
        T_TIPO_DATA('39028'),
        T_TIPO_DATA('55787'),
        T_TIPO_DATA('47670'),
        T_TIPO_DATA('41952'),
        T_TIPO_DATA('41964'),
        T_TIPO_DATA('39109'),
        T_TIPO_DATA('14422'),
        T_TIPO_DATA('70984'),
        T_TIPO_DATA('22062'),
        T_TIPO_DATA('30696'),
        T_TIPO_DATA('72305'),
        T_TIPO_DATA('72306'),
        T_TIPO_DATA('71442'),
        T_TIPO_DATA('54734'),
        T_TIPO_DATA('38944'),
        T_TIPO_DATA('38984'),
        T_TIPO_DATA('38988'),
        T_TIPO_DATA('38985'),
        T_TIPO_DATA('38986'),
        T_TIPO_DATA('38987'),
        T_TIPO_DATA('12421'),
        T_TIPO_DATA('42807'),
        T_TIPO_DATA('53975'),
        T_TIPO_DATA('41977'),
        T_TIPO_DATA('43797'),
        T_TIPO_DATA('30361'),
        T_TIPO_DATA('56814'),
        T_TIPO_DATA('25081'),
        T_TIPO_DATA('31216'),
        T_TIPO_DATA('22000'),
        T_TIPO_DATA('22047'),
        T_TIPO_DATA('65116'),
        T_TIPO_DATA('55516'),
        T_TIPO_DATA('55517'),
        T_TIPO_DATA('55518'),
        T_TIPO_DATA('13705'),
        T_TIPO_DATA('10084'),
        T_TIPO_DATA('38497'),
        T_TIPO_DATA('30499'),
        T_TIPO_DATA('51913'),
        T_TIPO_DATA('25087'),
        T_TIPO_DATA('42981'),
        T_TIPO_DATA('45426'),
        T_TIPO_DATA('58401'),
        T_TIPO_DATA('43703'),
        T_TIPO_DATA('42023'),
        T_TIPO_DATA('40976'),
        T_TIPO_DATA('72310'),
        T_TIPO_DATA('46251'),
        T_TIPO_DATA('45296'),
        T_TIPO_DATA('40946'),
        T_TIPO_DATA('45372'),
        T_TIPO_DATA('42065'),
        T_TIPO_DATA('33678'),
        T_TIPO_DATA('61075'),
        T_TIPO_DATA('61402'),
        T_TIPO_DATA('66364'),
        T_TIPO_DATA('66366'),
        T_TIPO_DATA('58230'),
        T_TIPO_DATA('62487'),
        T_TIPO_DATA('35867'),
        T_TIPO_DATA('35870'),
        T_TIPO_DATA('35874'),
        T_TIPO_DATA('35875'),
        T_TIPO_DATA('35878'),
        T_TIPO_DATA('35880'),
        T_TIPO_DATA('35882'),
        T_TIPO_DATA('35883'),
        T_TIPO_DATA('35885'),
        T_TIPO_DATA('57903'),
        T_TIPO_DATA('31199'),
        T_TIPO_DATA('52852'),
        T_TIPO_DATA('32658'),
        T_TIPO_DATA('55670'),
        T_TIPO_DATA('58349'),
        T_TIPO_DATA('58348'),
        T_TIPO_DATA('37077'),
        T_TIPO_DATA('37078'),
        T_TIPO_DATA('37083'),
        T_TIPO_DATA('37178'),
        T_TIPO_DATA('37079'),
        T_TIPO_DATA('37087'),
        T_TIPO_DATA('37088'),
        T_TIPO_DATA('37089'),
        T_TIPO_DATA('37090'),
        T_TIPO_DATA('37111'),
        T_TIPO_DATA('13979'),
        T_TIPO_DATA('57440'),
        T_TIPO_DATA('57441'),
        T_TIPO_DATA('57442'),
        T_TIPO_DATA('57445'),
        T_TIPO_DATA('58506'),
        T_TIPO_DATA('61841'),
        T_TIPO_DATA('58066'),
        T_TIPO_DATA('41198'),
        T_TIPO_DATA('35344'),
        T_TIPO_DATA('35347'),
        T_TIPO_DATA('62896'),
        T_TIPO_DATA('51150'),
        T_TIPO_DATA('39107'),
        T_TIPO_DATA('32856'),
        T_TIPO_DATA('32442'),
        T_TIPO_DATA('61423'),
        T_TIPO_DATA('55040'),
        T_TIPO_DATA('29862'),
        T_TIPO_DATA('56297'),
        T_TIPO_DATA('30497'),
        T_TIPO_DATA('22237'),
        T_TIPO_DATA('61187'),
        T_TIPO_DATA('42254'),
        T_TIPO_DATA('62699'),
        T_TIPO_DATA('68081'),
        T_TIPO_DATA('68479'),
        T_TIPO_DATA('51521'),
        T_TIPO_DATA('7080'),
        T_TIPO_DATA('21861'),
        T_TIPO_DATA('20251'),
        T_TIPO_DATA('38705'),
        T_TIPO_DATA('38447'),
        T_TIPO_DATA('73594'),
        T_TIPO_DATA('72119'),
        T_TIPO_DATA('45077'),
        T_TIPO_DATA('15953'),
        T_TIPO_DATA('32910'),
        T_TIPO_DATA('32911'),
        T_TIPO_DATA('71918'),
        T_TIPO_DATA('70709'),
        T_TIPO_DATA('20735'),
        T_TIPO_DATA('52975'),
        T_TIPO_DATA('50859'),
        T_TIPO_DATA('50860'),
        T_TIPO_DATA('50861'),
        T_TIPO_DATA('48455'),
        T_TIPO_DATA('40365'),
        T_TIPO_DATA('34166'),
        T_TIPO_DATA('51924'),
        T_TIPO_DATA('31247'),
        T_TIPO_DATA('52236'),
        T_TIPO_DATA('54843'),
        T_TIPO_DATA('58225'),
        T_TIPO_DATA('71341'),
        T_TIPO_DATA('68636'),
        T_TIPO_DATA('9951'),
        T_TIPO_DATA('39064'),
        T_TIPO_DATA('39065'),
        T_TIPO_DATA('59915'),
        T_TIPO_DATA('22246'),
        T_TIPO_DATA('22251'),
        T_TIPO_DATA('59932'),
        T_TIPO_DATA('39066'),
        T_TIPO_DATA('70873'),
        T_TIPO_DATA('64106'),
        T_TIPO_DATA('61455'),
        T_TIPO_DATA('57542'),
        T_TIPO_DATA('25099'),
        T_TIPO_DATA('13725'),
        T_TIPO_DATA('6817'),
        T_TIPO_DATA('65176'),
        T_TIPO_DATA('65179'),
        T_TIPO_DATA('65185'),
        T_TIPO_DATA('65211'),
        T_TIPO_DATA('65213'),
        T_TIPO_DATA('65214'),
        T_TIPO_DATA('65216'),
        T_TIPO_DATA('65217'),
        T_TIPO_DATA('65218'),
        T_TIPO_DATA('65220'),
        T_TIPO_DATA('65192'),
        T_TIPO_DATA('65200'),
        T_TIPO_DATA('65207'),
        T_TIPO_DATA('65208'),
        T_TIPO_DATA('65209'),
        T_TIPO_DATA('65210'),
        T_TIPO_DATA('65231'),
        T_TIPO_DATA('65232'),
        T_TIPO_DATA('65233'),
        T_TIPO_DATA('65236'),
        T_TIPO_DATA('65237'),
        T_TIPO_DATA('65239'),
        T_TIPO_DATA('65240'),
        T_TIPO_DATA('65241'),
        T_TIPO_DATA('65245'),
        T_TIPO_DATA('65246'),
        T_TIPO_DATA('65247'),
        T_TIPO_DATA('65248'),
        T_TIPO_DATA('65249'),
        T_TIPO_DATA('65250'),
        T_TIPO_DATA('68584'),
        T_TIPO_DATA('56818'),
        T_TIPO_DATA('13604'),
        T_TIPO_DATA('13605'),
        T_TIPO_DATA('46236'),
        T_TIPO_DATA('46238'),
        T_TIPO_DATA('44437'),
        T_TIPO_DATA('63780'),
        T_TIPO_DATA('22252'),
        T_TIPO_DATA('37073'),
        T_TIPO_DATA('37074'),
        T_TIPO_DATA('37075'),
        T_TIPO_DATA('37076'),
        T_TIPO_DATA('37061'),
        T_TIPO_DATA('37062'),
        T_TIPO_DATA('37063'),
        T_TIPO_DATA('37064'),
        T_TIPO_DATA('2093'),
        T_TIPO_DATA('31142'),
        T_TIPO_DATA('62802'),
        T_TIPO_DATA('62801'),
        T_TIPO_DATA('39025'),
        T_TIPO_DATA('39032'),
        T_TIPO_DATA('39033'),
        T_TIPO_DATA('13962'),
        T_TIPO_DATA('40958'),
        T_TIPO_DATA('68527'),
        T_TIPO_DATA('47545'),
        T_TIPO_DATA('31246'),
        T_TIPO_DATA('72994'),
        T_TIPO_DATA('72995'),
        T_TIPO_DATA('13349'),
        T_TIPO_DATA('13486'),
        T_TIPO_DATA('51258'),
        T_TIPO_DATA('70710'),
        T_TIPO_DATA('55577'),
        T_TIPO_DATA('40504'),
        T_TIPO_DATA('61978'),
        T_TIPO_DATA('41017'),
        T_TIPO_DATA('41650'),
        T_TIPO_DATA('55652')); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  [INFO] NO EXISTE LA TABLA');
    ELSE
        V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
        EXECUTE IMMEDIATE V_MSQL;
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP
                V_TMP_TIPO_DATA := V_TIPO_DATA(I);
                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (ACT_NUM_ACTIVO_PRINEX)
                    VALUES ('''||V_TMP_TIPO_DATA(1)||''')';
                EXECUTE IMMEDIATE V_MSQL;
            END LOOP;
        DBMS_OUTPUT.PUT_LINE('  [INFO] TABLA RELLENA');
    END IF;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        ROLLBACK;
        RAISE;          
END;
/
EXIT;
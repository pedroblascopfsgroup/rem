--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12036
--## PRODUCTO=NO
--##
--## Finalidad: Insert en CPF_CONFIG_PVE_FORMALIZACION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-12036'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_TABLA VARCHAR2 (30 CHAR) := 'CPF_CONFIG_PVE_FORMALIZACION';
    V_COUNT NUMBER(25);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('0000'),
        T_TIPO_DATA('0001'),
        T_TIPO_DATA('0002'),
        T_TIPO_DATA('0003'),
        T_TIPO_DATA('0005'),
        T_TIPO_DATA('0006'),
        T_TIPO_DATA('0007'),
        T_TIPO_DATA('0008'),
        T_TIPO_DATA('0009'),
        T_TIPO_DATA('0010'),
        T_TIPO_DATA('0011'),
        T_TIPO_DATA('0012'),
        T_TIPO_DATA('0013'),
        T_TIPO_DATA('0014'),
        T_TIPO_DATA('0015'),
        T_TIPO_DATA('0016'),
        T_TIPO_DATA('0017'),
        T_TIPO_DATA('0018'),
        T_TIPO_DATA('0021'),
        T_TIPO_DATA('0023'),
        T_TIPO_DATA('0024'),
        T_TIPO_DATA('0025'),
        T_TIPO_DATA('0029'),
        T_TIPO_DATA('0032'),
        T_TIPO_DATA('0034'),
        T_TIPO_DATA('0035'),
        T_TIPO_DATA('0036'),
        T_TIPO_DATA('0038'),
        T_TIPO_DATA('0039'),
        T_TIPO_DATA('0040'),
        T_TIPO_DATA('0041'),
        T_TIPO_DATA('0044'),
        T_TIPO_DATA('0046'),
        T_TIPO_DATA('0047'),
        T_TIPO_DATA('0048'),
        T_TIPO_DATA('0050'),
        T_TIPO_DATA('0052'),
        T_TIPO_DATA('0054'),
        T_TIPO_DATA('0056'),
        T_TIPO_DATA('0057'),
        T_TIPO_DATA('0060'),
        T_TIPO_DATA('0061'),
        T_TIPO_DATA('0062'),
        T_TIPO_DATA('0064'),
        T_TIPO_DATA('0065'),
        T_TIPO_DATA('0066'),
        T_TIPO_DATA('0067'),
        T_TIPO_DATA('0071'),
        T_TIPO_DATA('0073'),
        T_TIPO_DATA('0075'),
        T_TIPO_DATA('0076'),
        T_TIPO_DATA('0077'),
        T_TIPO_DATA('0079'),
        T_TIPO_DATA('0082'),
        T_TIPO_DATA('0083'),
        T_TIPO_DATA('0085'),
        T_TIPO_DATA('0086'),
        T_TIPO_DATA('0087'),
        T_TIPO_DATA('0088'),
        T_TIPO_DATA('0089'),
        T_TIPO_DATA('0091'),
        T_TIPO_DATA('0092'),
        T_TIPO_DATA('0094'),
        T_TIPO_DATA('0096'),
        T_TIPO_DATA('0097'),
        T_TIPO_DATA('0098'),
        T_TIPO_DATA('0100'),
        T_TIPO_DATA('0103'),
        T_TIPO_DATA('0107'),
        T_TIPO_DATA('0112'),
        T_TIPO_DATA('0113'),
        T_TIPO_DATA('0116'),
        T_TIPO_DATA('0117'),
        T_TIPO_DATA('0121'),
        T_TIPO_DATA('0123'),
        T_TIPO_DATA('0126'),
        T_TIPO_DATA('0127'),
        T_TIPO_DATA('0129'),
        T_TIPO_DATA('0130'),
        T_TIPO_DATA('0132'),
        T_TIPO_DATA('0133'),
        T_TIPO_DATA('0145'),
        T_TIPO_DATA('0147'),
        T_TIPO_DATA('0148'),
        T_TIPO_DATA('0152'),
        T_TIPO_DATA('0155'),
        T_TIPO_DATA('0157'),
        T_TIPO_DATA('0158'),
        T_TIPO_DATA('0159'),
        T_TIPO_DATA('0163'),
        T_TIPO_DATA('0175'),
        T_TIPO_DATA('0182'),
        T_TIPO_DATA('0185'),
        T_TIPO_DATA('0186'),
        T_TIPO_DATA('0187'),
        T_TIPO_DATA('0191'),
        T_TIPO_DATA('0194'),
        T_TIPO_DATA('0701'),
        T_TIPO_DATA('0703'),
        T_TIPO_DATA('0706'),
        T_TIPO_DATA('0708'),
        T_TIPO_DATA('0709'),
        T_TIPO_DATA('0710'),
        T_TIPO_DATA('0712'),
        T_TIPO_DATA('0713'),
        T_TIPO_DATA('0714'),
        T_TIPO_DATA('0717'),
        T_TIPO_DATA('0718'),
        T_TIPO_DATA('0719'),
        T_TIPO_DATA('0721'),
        T_TIPO_DATA('0727'),
        T_TIPO_DATA('0728'),
        T_TIPO_DATA('0729'),
        T_TIPO_DATA('0730'),
        T_TIPO_DATA('0731'),
        T_TIPO_DATA('0734'),
        T_TIPO_DATA('0736'),
        T_TIPO_DATA('0737'),
        T_TIPO_DATA('0739'),
        T_TIPO_DATA('0740'),
        T_TIPO_DATA('0741'),
        T_TIPO_DATA('0743'),
        T_TIPO_DATA('0746'),
        T_TIPO_DATA('0751'),
        T_TIPO_DATA('0752'),
        T_TIPO_DATA('0757'),
        T_TIPO_DATA('0759'),
        T_TIPO_DATA('0760'),
        T_TIPO_DATA('0761'),
        T_TIPO_DATA('0762'),
        T_TIPO_DATA('0763'),
        T_TIPO_DATA('0764'),
        T_TIPO_DATA('0765'),
        T_TIPO_DATA('0768'),
        T_TIPO_DATA('0769'),
        T_TIPO_DATA('0775'),
        T_TIPO_DATA('0776'),
        T_TIPO_DATA('0777'),
        T_TIPO_DATA('0778'),
        T_TIPO_DATA('0780'),
        T_TIPO_DATA('0781'),
        T_TIPO_DATA('0782'),
        T_TIPO_DATA('0785'),
        T_TIPO_DATA('0787'),
        T_TIPO_DATA('0788'),
        T_TIPO_DATA('0789'),
        T_TIPO_DATA('0792'),
        T_TIPO_DATA('0793'),
        T_TIPO_DATA('0794'),
        T_TIPO_DATA('0797'),
        T_TIPO_DATA('0799'),
        T_TIPO_DATA('0810'),
        T_TIPO_DATA('0811'),
        T_TIPO_DATA('0812'),
        T_TIPO_DATA('0814'),
        T_TIPO_DATA('0820'),
        T_TIPO_DATA('0823'),
        T_TIPO_DATA('0824'),
        T_TIPO_DATA('0825'),
        T_TIPO_DATA('0832'),
        T_TIPO_DATA('0834'),
        T_TIPO_DATA('0835'),
        T_TIPO_DATA('0844'),
        T_TIPO_DATA('0847'),
        T_TIPO_DATA('0851'),
        T_TIPO_DATA('0853'),
        T_TIPO_DATA('0854'),
        T_TIPO_DATA('0856'),
        T_TIPO_DATA('0860'),
        T_TIPO_DATA('0868'),
        T_TIPO_DATA('0872'),
        T_TIPO_DATA('0878'),
        T_TIPO_DATA('0879'),
        T_TIPO_DATA('0883'),
        T_TIPO_DATA('0884'),
        T_TIPO_DATA('1005'),
        T_TIPO_DATA('1801'),
        T_TIPO_DATA('1802'),
        T_TIPO_DATA('1804'),
        T_TIPO_DATA('1805'),
        T_TIPO_DATA('1807'),
        T_TIPO_DATA('3001'),
        T_TIPO_DATA('3002'),
        T_TIPO_DATA('3003'),
        T_TIPO_DATA('3006'),
        T_TIPO_DATA('3007'),
        T_TIPO_DATA('3009'),
        T_TIPO_DATA('3010'),
        T_TIPO_DATA('3011'),
        T_TIPO_DATA('3012'),
        T_TIPO_DATA('3014'),
        T_TIPO_DATA('3015'),
        T_TIPO_DATA('3016'),
        T_TIPO_DATA('3017'),
        T_TIPO_DATA('3018'),
        T_TIPO_DATA('3021'),
        T_TIPO_DATA('3022'),
        T_TIPO_DATA('3023'),
        T_TIPO_DATA('3027'),
        T_TIPO_DATA('3028'),
        T_TIPO_DATA('3201'),
        T_TIPO_DATA('3202'),
        T_TIPO_DATA('3203'),
        T_TIPO_DATA('3204'),
        T_TIPO_DATA('3205'),
        T_TIPO_DATA('3206'),
        T_TIPO_DATA('3207'),
        T_TIPO_DATA('3401'),
        T_TIPO_DATA('3402'),
        T_TIPO_DATA('3404'),
        T_TIPO_DATA('3406'),
        T_TIPO_DATA('3407'),
        T_TIPO_DATA('3408'),
        T_TIPO_DATA('3409'),
        T_TIPO_DATA('3410'),
        T_TIPO_DATA('3501'),
        T_TIPO_DATA('3502'),
        T_TIPO_DATA('3505'),
        T_TIPO_DATA('3506'),
        T_TIPO_DATA('3507'),
        T_TIPO_DATA('3508'),
        T_TIPO_DATA('3509'),
        T_TIPO_DATA('3510'),
        T_TIPO_DATA('3511'),
        T_TIPO_DATA('3512'),
        T_TIPO_DATA('4600'),
        T_TIPO_DATA('4601'),
        T_TIPO_DATA('4603'),
        T_TIPO_DATA('4604'),
        T_TIPO_DATA('4605'),
        T_TIPO_DATA('6701'),
        T_TIPO_DATA('6702'),
        T_TIPO_DATA('6703')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    /*EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
                (CPF_ID,PVE_ID,CPF_FORMALIZACION_CAJAMAR,USUARIOCREAR,FECHACREAR)

            SELECT '||V_ESQUEMA||'.S_CPF_CONFIG_PVE_FORMALIZACION.NEXTVAL,
            PVE.PVE_ID,1,'''||V_USUARIO||''',SYSDATE
            FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
            JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = PVE.DD_PRV_ID AND PRV.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID AND TPR.BORRADO = 0
            WHERE PVE.BORRADO = 0 AND TPR.DD_TPR_CODIGO = ''29''
            AND PRV.DD_PRV_CODIGO IN (''4'',''6'',''10'',''11'',''14'',''18'',''21'',''23'',''29'',''41'')
            AND NOT EXISTS (SELECT 1 FROM REM01.CPF_CONFIG_PVE_FORMALIZACION CPF WHERE CPF.PVE_ID = PVE.PVE_ID)';

    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN CPF_CONFIG_PVE_FORMALIZACION');  */

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        EXECUTE IMMEDIATE 'SELECT COUNT(*)
            FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
            JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = PVE.DD_PRV_ID AND PRV.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID AND TPR.BORRADO = 0
            WHERE PVE.BORRADO = 0 AND TPR.DD_TPR_CODIGO = ''29''
            AND PVE.PVE_NOMBRE = ''Oficina Cajamar '||V_TMP_TIPO_DATA(1)||'''
            AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.CPF_CONFIG_PVE_FORMALIZACION CPF WHERE CPF.PVE_ID = PVE.PVE_ID AND CPF.BORRADO = 0)' 
        INTO V_COUNT;
            
        IF V_COUNT != 0 THEN
        
            EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
            (CPF_ID,PVE_ID,CPF_FORMALIZACION_CAJAMAR,USUARIOCREAR,FECHACREAR)
            
            SELECT '||V_ESQUEMA||'.S_CPF_CONFIG_PVE_FORMALIZACION.NEXTVAL,
            PVE.PVE_ID,1,'''||V_USUARIO||''',SYSDATE
            FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
            JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = PVE.DD_PRV_ID AND PRV.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID AND TPR.BORRADO = 0
            WHERE PVE.BORRADO = 0 AND TPR.DD_TPR_CODIGO = ''29''
            AND PVE.PVE_NOMBRE = ''Oficina Cajamar '||V_TMP_TIPO_DATA(1)||'''
            AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.CPF_CONFIG_PVE_FORMALIZACION CPF WHERE CPF.PVE_ID = PVE.PVE_ID AND CPF.BORRADO = 0)';
                            
            DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADA OFICINA CAJAMAR '||V_TMP_TIPO_DATA(1)||'');
            
        ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE EN LA TABLA O NO SE ENCUENTRA OFICINA CAJAMAR '||V_TMP_TIPO_DATA(1)||'');
        
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN] TABLA CPF_CONFIG_PVE_FORMALIZACION CARGADA CORRECTAMENTE');

    COMMIT;

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

EXIT

--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210315
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9204
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
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-9204';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_TOTAL NUMBER(16):=0;
    V_PROVEEDOR NUMBER(16):=110113457;
    V_PREFACTURA NUMBER(16):=451;

    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- TBJ_NUM_TRABAJO
                T_TIPO_DATA('916950103125'),
                T_TIPO_DATA('916950106525'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964307892'),
                T_TIPO_DATA('916964362399'),
                T_TIPO_DATA('916964362384'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964318352'),
                T_TIPO_DATA('916964307573'),
                T_TIPO_DATA('916964365532'),
                T_TIPO_DATA('916964360545'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964343213'),
                T_TIPO_DATA('916964365585'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964366645'),
                T_TIPO_DATA('916964365303'),
                T_TIPO_DATA('916964362393'),
                T_TIPO_DATA('916964376967'),
                T_TIPO_DATA('916964310593'),
                T_TIPO_DATA('916964368459'),
                T_TIPO_DATA('916964365541'),
                T_TIPO_DATA('916964361250'),
                T_TIPO_DATA('916964311578'),
                T_TIPO_DATA('916964376960'),
                T_TIPO_DATA('916964365550'),
                T_TIPO_DATA('916964365419'),
                T_TIPO_DATA('916964360538'),
                T_TIPO_DATA('916964362693'),
                T_TIPO_DATA('916964365331'),
                T_TIPO_DATA('916964361317'),
                T_TIPO_DATA('916964314285'),
                T_TIPO_DATA('916964365372'),
                T_TIPO_DATA('916964362623'),
                T_TIPO_DATA('916964365502'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964362603'),
                T_TIPO_DATA('916964365294'),
                T_TIPO_DATA('916964362420'),
                T_TIPO_DATA('916964362658'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964376966'),
                T_TIPO_DATA('916964361172'),
                T_TIPO_DATA('916964316131'),
                T_TIPO_DATA('916964362440'),
                T_TIPO_DATA('916964362413'),
                T_TIPO_DATA('916964365316'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964368427'),
                T_TIPO_DATA('916964356565'),
                T_TIPO_DATA('916964362403'),
                T_TIPO_DATA('916964333652'),
                T_TIPO_DATA('916964308466'),
                T_TIPO_DATA('916964362595'),
                T_TIPO_DATA('916964365468'),
                T_TIPO_DATA('916964365438'),
                T_TIPO_DATA('916964365435'),
                T_TIPO_DATA('916964365433'),
                T_TIPO_DATA('916964365430'),
                T_TIPO_DATA('916964365425'),
                T_TIPO_DATA('916964314647'),
                T_TIPO_DATA('916964365397'),
                T_TIPO_DATA('916964362598'),
                T_TIPO_DATA('916964365422'),
                T_TIPO_DATA('916964365408'),
                T_TIPO_DATA('916964366619'),
                T_TIPO_DATA('916964366614'),
                T_TIPO_DATA('916964365403'),
                T_TIPO_DATA('916964365322'),
                T_TIPO_DATA('916964375837'),
                T_TIPO_DATA('916964360874'),
                T_TIPO_DATA('916964362710'),
                T_TIPO_DATA('916964362685'),
                T_TIPO_DATA('916964362679'),
                T_TIPO_DATA('916964362700'),
                T_TIPO_DATA('916964365402'),
                T_TIPO_DATA('916964365311'),
                T_TIPO_DATA('916964361308'),
                T_TIPO_DATA('916964361305'),
                T_TIPO_DATA('916964361300'),
                T_TIPO_DATA('916964362571'),
                T_TIPO_DATA('916964365407'),
                T_TIPO_DATA('916964377915'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964362673'),
                T_TIPO_DATA('916964372783'),
                T_TIPO_DATA('916964365583'),
                T_TIPO_DATA('916964365490'),
                T_TIPO_DATA('916964362419'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964376959'),
                T_TIPO_DATA('916964365473'),
                T_TIPO_DATA('916964362426'),
                T_TIPO_DATA('916964362477'),
                T_TIPO_DATA('916964366667'),
                T_TIPO_DATA('916964362587'),
                T_TIPO_DATA('916964362436'),
                T_TIPO_DATA('916964365414'),
                T_TIPO_DATA('916964365400'),
                T_TIPO_DATA('916964365543'),
                T_TIPO_DATA('916964365493'),
                T_TIPO_DATA('916964308108'),
                T_TIPO_DATA('916964365546'),
                T_TIPO_DATA('916964362707'),
                T_TIPO_DATA('916964365513'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964362699'),
                T_TIPO_DATA('916964362637'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964362435'),
                T_TIPO_DATA('916964361578'),
                T_TIPO_DATA('916964366671'),
                T_TIPO_DATA('916964362375'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964362574'),
                T_TIPO_DATA('916964362615'),
                T_TIPO_DATA('916964362497'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964361608'),
                T_TIPO_DATA('916964362668'),
                T_TIPO_DATA('916964362629'),
                T_TIPO_DATA('916964379176'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964362618'),
                T_TIPO_DATA('916964365562'),
                T_TIPO_DATA('916964362698'),
                T_TIPO_DATA('916964361651'),
                T_TIPO_DATA('916964361104'),
                T_TIPO_DATA('916964365587'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964377808'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964362664'),
                T_TIPO_DATA('916964331944'),
                T_TIPO_DATA('916964365337'),
                T_TIPO_DATA('916964362616'),
                T_TIPO_DATA('916964358514'),
                T_TIPO_DATA('916964358516'),
                T_TIPO_DATA('916964368418'),
                T_TIPO_DATA('916964365347'),
                T_TIPO_DATA('916964319996'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964343226'),
                T_TIPO_DATA('916964360369'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964328056'),
                T_TIPO_DATA('916964362609'),
                T_TIPO_DATA('916964362569'),
                T_TIPO_DATA('916964362580'),
                T_TIPO_DATA('916964362382'),
                T_TIPO_DATA('916964318100'),
                T_TIPO_DATA('916964362453'),
                T_TIPO_DATA('916964361590'),
                T_TIPO_DATA('916964362703'),
                T_TIPO_DATA('916964368452'),
                T_TIPO_DATA('916964362422'),
                T_TIPO_DATA('916964362706'),
                T_TIPO_DATA('916964362593'),
                T_TIPO_DATA('916964362564'),
                T_TIPO_DATA('916964360415'),
                T_TIPO_DATA('916964362428'),
                T_TIPO_DATA('916964368462'),
                T_TIPO_DATA('916964362417'),
                T_TIPO_DATA('916964365539'),
                T_TIPO_DATA('916964365517'),
                T_TIPO_DATA('916964366672'),
                T_TIPO_DATA('916964362460'),
                T_TIPO_DATA('916964360726'),
                T_TIPO_DATA('916964365529'),
                T_TIPO_DATA('916964366662'),
                T_TIPO_DATA('916964365478'),
                T_TIPO_DATA('916964366640'),
                T_TIPO_DATA('916964365559'),
                T_TIPO_DATA('916964365552'),
                T_TIPO_DATA('916964361265'),
                T_TIPO_DATA('916964360669'),
                T_TIPO_DATA('916964366648'),
                T_TIPO_DATA('916964362624'),
                T_TIPO_DATA('916964318160'),
                T_TIPO_DATA('916964340576'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964343231'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964379288'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964365593'),
                T_TIPO_DATA('916964366630'),
                T_TIPO_DATA('916964365484'),
                T_TIPO_DATA('916964308219'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964366685'),
                T_TIPO_DATA('916964366681'),
                T_TIPO_DATA('916964365580'),
                T_TIPO_DATA('916964366679'),
                T_TIPO_DATA('916964366677'),
                T_TIPO_DATA('916964359334'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964362448'),
                T_TIPO_DATA('916964366664'),
                T_TIPO_DATA('916964318209'),
                T_TIPO_DATA('916964361177'),
                T_TIPO_DATA('916964365301'),
                T_TIPO_DATA('916964365508'),
                T_TIPO_DATA('916964378640'),
                T_TIPO_DATA('916964366635'),
                T_TIPO_DATA('916964365293'),
                T_TIPO_DATA('916964343171'),
                T_TIPO_DATA('916964362443'),
                T_TIPO_DATA('916964365525'),
                T_TIPO_DATA('916964366655'),
                T_TIPO_DATA('916964356417'),
                T_TIPO_DATA('916964376954'),
                T_TIPO_DATA('916964366652'),
                T_TIPO_DATA('916964362708'),
                T_TIPO_DATA('916964365417'),
                T_TIPO_DATA('916964376958'),
                T_TIPO_DATA('916964361345'),
                T_TIPO_DATA('916964379140'),
                T_TIPO_DATA('916964379143'),
                T_TIPO_DATA('916964362505'),
                T_TIPO_DATA('916964379131'),
                T_TIPO_DATA('916964379147'),
                T_TIPO_DATA('916964379156'),
                T_TIPO_DATA('916964362389'),
                T_TIPO_DATA('916964379160'),
                T_TIPO_DATA('924567804376'),
                T_TIPO_DATA('916964376962'),
                T_TIPO_DATA('916964376955'),
                T_TIPO_DATA('916964389512'),
                T_TIPO_DATA('916964362480'),
                T_TIPO_DATA('916964376973'),
                T_TIPO_DATA('916964372785'),
                T_TIPO_DATA('916964371133'),
                T_TIPO_DATA('916964358522'),
                T_TIPO_DATA('916964384129')



    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR PROVEEDOR TRABAJO');

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
            JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVE.PVE_ID=PVC.PVE_ID
            WHERE PVE.PVE_COD_REM='||V_PROVEEDOR||' AND PVE.BORRADO=0 AND PVC.BORRADO=0 AND PVC.PVC_PRINCIPAL=1';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN
         FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
            EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '''||V_TMP_TIPO_DATA(1)||'''' INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN

            V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET 
                        USUARIOMODIFICAR = ''' || V_USUARIO || ''',
                        FECHAMODIFICAR   = SYSDATE, 
                        PVC_ID = (SELECT PVC.PVC_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
                                    JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVE.PVE_ID=PVC.PVE_ID
                                    WHERE PVE.PVE_COD_REM='||V_PROVEEDOR||' AND PVE.BORRADO=0 AND PVC.BORRADO=0 AND PVC.PVC_PRINCIPAL=1)
                        WHERE TBJ_NUM_TRABAJO = '''||V_TMP_TIPO_DATA(1)||''' ';	

            EXECUTE IMMEDIATE V_SQL;
             DBMS_OUTPUT.PUT_LINE('[INFO] Modificado trabajo: '''||V_TMP_TIPO_DATA(1)||''' correctamente');
            V_COUNT := V_COUNT + 1;

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] El trabajo no existe!');
                        
            END IF;

        END LOOP;


        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PFA_PREFACTURA PFA WHERE PFA_NUM_PREFACTURA = '||V_PREFACTURA||'' INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN

            V_SQL := ' UPDATE '||V_ESQUEMA||'.PFA_PREFACTURA SET 
                        USUARIOMODIFICAR = ''' || V_USUARIO || ''',
                        FECHAMODIFICAR   = SYSDATE, 
                        PVE_ID = (SELECT PVE.PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
                                    WHERE PVE.PVE_COD_REM='||V_PROVEEDOR||' AND PVE.BORRADO=0)
                        WHERE PFA_NUM_PREFACTURA = '||V_PREFACTURA||' ';	

            EXECUTE IMMEDIATE V_SQL;            
            DBMS_OUTPUT.PUT_LINE('[INFO] Modificada prefactura: '||V_PREFACTURA||'');
            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] La prefactura no existe!');
                        
            END IF;


    ELSE
         DBMS_OUTPUT.PUT_LINE('[INFO]: No existe proveedor contacto con el cod proveedor rem indicado '||V_PROVEEDOR||'');

    END IF;

	
    
     DBMS_OUTPUT.PUT_LINE('[INFO]  Modificados '||V_COUNT||' trabajos correctamente de '||V_COUNT_TOTAL||'');  

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
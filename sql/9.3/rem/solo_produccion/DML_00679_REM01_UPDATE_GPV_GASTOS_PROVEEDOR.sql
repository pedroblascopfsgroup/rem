--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9019
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9019'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_ID_PROVEEDOR NUMBER(16); -- Vble. para el id del proveedor

    V_TABLA VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR'; --Vble. Tabla a modificar proveedores
    V_TABLA_PREFACTURA VARCHAR2(100 CHAR):='PFA_PREFACTURA'; --Vble. Tabla a modificar prefacturas

	V_COUNT NUMBER(16); -- Vble. para comprobar
    V_PROVEEDOR_REM VARCHAR2(100 CHAR):='110187531'; --Vble. codigo proveedor rem
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('12616400'),
            T_TIPO_DATA('12634051'),
            T_TIPO_DATA('12634052'),
            T_TIPO_DATA('12634053'),
            T_TIPO_DATA('12634054'),
            T_TIPO_DATA('12634055'),
            T_TIPO_DATA('12634056'),
            T_TIPO_DATA('12634057'),
            T_TIPO_DATA('12634058'),
            T_TIPO_DATA('12634059'),
            T_TIPO_DATA('12634060'),
            T_TIPO_DATA('12634061'),
            T_TIPO_DATA('12634062'),
            T_TIPO_DATA('12634063'),
            T_TIPO_DATA('12634064'),
            T_TIPO_DATA('12634065'),
            T_TIPO_DATA('12634068'),
            T_TIPO_DATA('12634069'),
            T_TIPO_DATA('12634070'),
            T_TIPO_DATA('12634071'),
            T_TIPO_DATA('12634072'),
            T_TIPO_DATA('12634073'),
            T_TIPO_DATA('12634074'),
            T_TIPO_DATA('12634075'),
            T_TIPO_DATA('12634076'),
            T_TIPO_DATA('12634077'),
            T_TIPO_DATA('12634078'),
            T_TIPO_DATA('12634079'),
            T_TIPO_DATA('12634080'),
            T_TIPO_DATA('12634081'),
            T_TIPO_DATA('12634082'),
            T_TIPO_DATA('12634083'),
            T_TIPO_DATA('12634084'),
            T_TIPO_DATA('12634085'),
            T_TIPO_DATA('12634086'),
            T_TIPO_DATA('12634087'),
            T_TIPO_DATA('12634088'),
            T_TIPO_DATA('12634089'),
            T_TIPO_DATA('12634090'),
            T_TIPO_DATA('12634091'),
            T_TIPO_DATA('12634094'),
            T_TIPO_DATA('12634097'),
            T_TIPO_DATA('12634098'),
            T_TIPO_DATA('12634099'),
            T_TIPO_DATA('12634100'),
            T_TIPO_DATA('12634114'),
            T_TIPO_DATA('12634115'),
            T_TIPO_DATA('12634120'),
            T_TIPO_DATA('12634121'),
            T_TIPO_DATA('12634122'),
            T_TIPO_DATA('12634123'),
            T_TIPO_DATA('12634124'),
            T_TIPO_DATA('12634128'),
            T_TIPO_DATA('12634129'),
            T_TIPO_DATA('12634130'),
            T_TIPO_DATA('12634132'),
            T_TIPO_DATA('12634133'),
            T_TIPO_DATA('12634134'),
            T_TIPO_DATA('12634135'),
            T_TIPO_DATA('12634163'),
            T_TIPO_DATA('12634164'),
            T_TIPO_DATA('12634165'),
            T_TIPO_DATA('12634166'),
            T_TIPO_DATA('12634167'),
            T_TIPO_DATA('12634168'),
            T_TIPO_DATA('12634169'),
            T_TIPO_DATA('12634170'),
            T_TIPO_DATA('12634171'),
            T_TIPO_DATA('12634172'),
            T_TIPO_DATA('12634173'),
            T_TIPO_DATA('12634174'),
            T_TIPO_DATA('12634175'),
            T_TIPO_DATA('12634176'),
            T_TIPO_DATA('12634177'),
            T_TIPO_DATA('12634179'),
            T_TIPO_DATA('12634180'),
            T_TIPO_DATA('12634181'),
            T_TIPO_DATA('12634182'),
            T_TIPO_DATA('12634183'),
            T_TIPO_DATA('12634184'),
            T_TIPO_DATA('12634185'),
            T_TIPO_DATA('12634186'),
            T_TIPO_DATA('12634187'),
            T_TIPO_DATA('12634188'),
            T_TIPO_DATA('12634214'),
            T_TIPO_DATA('12634225'),
            T_TIPO_DATA('12634240'),
            T_TIPO_DATA('12634245'),
            T_TIPO_DATA('12634246'),
            T_TIPO_DATA('12634247'),
            T_TIPO_DATA('12634249'),
            T_TIPO_DATA('12634251'),
            T_TIPO_DATA('12634252'),
            T_TIPO_DATA('12634253'),
            T_TIPO_DATA('12634292'),
            T_TIPO_DATA('12634303'),
            T_TIPO_DATA('12634310'),
            T_TIPO_DATA('12634311'),
            T_TIPO_DATA('12634312'),
            T_TIPO_DATA('12634313'),
            T_TIPO_DATA('12634314'),
            T_TIPO_DATA('12634315'),
            T_TIPO_DATA('12634324'),
            T_TIPO_DATA('12634325'),
            T_TIPO_DATA('12634327'),
            T_TIPO_DATA('12634328'),
            T_TIPO_DATA('12634329'),
            T_TIPO_DATA('12634330'),
            T_TIPO_DATA('12634331'),
            T_TIPO_DATA('12634333'),
            T_TIPO_DATA('12634334'),
            T_TIPO_DATA('12634335'),
            T_TIPO_DATA('12634336'),
            T_TIPO_DATA('12634373'),
            T_TIPO_DATA('12634374'),
            T_TIPO_DATA('12634375'),
            T_TIPO_DATA('12634376'),
            T_TIPO_DATA('12634377'),
            T_TIPO_DATA('12634378'),
            T_TIPO_DATA('12634379'),
            T_TIPO_DATA('12634380'),
            T_TIPO_DATA('12634381'),
            T_TIPO_DATA('12634382'),
            T_TIPO_DATA('12634383'),
            T_TIPO_DATA('12634384'),
            T_TIPO_DATA('12634385'),
            T_TIPO_DATA('12634386'),
            T_TIPO_DATA('12634387'),
            T_TIPO_DATA('12634388'),
            T_TIPO_DATA('12634389'),
            T_TIPO_DATA('12634390'),
            T_TIPO_DATA('12634391'),
            T_TIPO_DATA('12634392'),
            T_TIPO_DATA('12634393'),
            T_TIPO_DATA('12634394'),
            T_TIPO_DATA('12634395'),
            T_TIPO_DATA('12634396'),
            T_TIPO_DATA('12634397'),
            T_TIPO_DATA('12634398'),
            T_TIPO_DATA('12634399'),
            T_TIPO_DATA('12634400'),
            T_TIPO_DATA('12634401'),
            T_TIPO_DATA('12634402'),
            T_TIPO_DATA('12634403'),
            T_TIPO_DATA('12634404'),
            T_TIPO_DATA('12634405'),
            T_TIPO_DATA('12634406'),
            T_TIPO_DATA('12634407'),
            T_TIPO_DATA('12634408'),
            T_TIPO_DATA('12658975'),
            T_TIPO_DATA('12658976'),
            T_TIPO_DATA('12658977'),
            T_TIPO_DATA('12658978'),
            T_TIPO_DATA('12658979'),
            T_TIPO_DATA('12658980'),
            T_TIPO_DATA('12658981'),
            T_TIPO_DATA('12658982'),
            T_TIPO_DATA('12658983'),
            T_TIPO_DATA('12658984'),
            T_TIPO_DATA('12658985'),
            T_TIPO_DATA('12658986'),
            T_TIPO_DATA('12658987'),
            T_TIPO_DATA('12658988'),
            T_TIPO_DATA('12658989'),
            T_TIPO_DATA('12658990'),
            T_TIPO_DATA('12658991'),
            T_TIPO_DATA('12658992'),
            T_TIPO_DATA('12658993'),
            T_TIPO_DATA('12658994'),
            T_TIPO_DATA('12658995'),
            T_TIPO_DATA('12658996'),
            T_TIPO_DATA('12658997'),
            T_TIPO_DATA('12658998'),
            T_TIPO_DATA('12658999'),
            T_TIPO_DATA('12659000'),
            T_TIPO_DATA('12659001'),
            T_TIPO_DATA('12659002'),
            T_TIPO_DATA('12659003'),
            T_TIPO_DATA('12659004'),
            T_TIPO_DATA('12659005'),
            T_TIPO_DATA('12659006'),
            T_TIPO_DATA('12659007'),
            T_TIPO_DATA('12659008'),
            T_TIPO_DATA('12659009'),
            T_TIPO_DATA('12659010'),
            T_TIPO_DATA('12659011'),
            T_TIPO_DATA('12659012'),
            T_TIPO_DATA('12659013'),
            T_TIPO_DATA('12659014'),
            T_TIPO_DATA('12659015'),
            T_TIPO_DATA('12659016'),
            T_TIPO_DATA('12659017'),
            T_TIPO_DATA('12659018'),
            T_TIPO_DATA('12659019'),
            T_TIPO_DATA('12659020'),
            T_TIPO_DATA('12659021'),
            T_TIPO_DATA('12659022'),
            T_TIPO_DATA('12659023'),
            T_TIPO_DATA('12659024'),
            T_TIPO_DATA('12659025'),
            T_TIPO_DATA('12659026'),
            T_TIPO_DATA('12659027'),
            T_TIPO_DATA('12659028'),
            T_TIPO_DATA('12659029'),
            T_TIPO_DATA('12659030'),
            T_TIPO_DATA('12659031'),
            T_TIPO_DATA('12659032'),
            T_TIPO_DATA('12659033'),
            T_TIPO_DATA('12659034'),
            T_TIPO_DATA('12659035'),
            T_TIPO_DATA('12659036'),
            T_TIPO_DATA('12659037'),
            T_TIPO_DATA('12659038'),
            T_TIPO_DATA('12659039'),
            T_TIPO_DATA('12659040'),
            T_TIPO_DATA('12659041'),
            T_TIPO_DATA('12659042'),
            T_TIPO_DATA('12659043'),
            T_TIPO_DATA('12659044'),
            T_TIPO_DATA('12659045'),
            T_TIPO_DATA('12659046'),
            T_TIPO_DATA('12659047'),
            T_TIPO_DATA('12659048'),
            T_TIPO_DATA('12659049'),
            T_TIPO_DATA('12659050'),
            T_TIPO_DATA('12659051'),
            T_TIPO_DATA('12659052'),
            T_TIPO_DATA('12659053'),
            T_TIPO_DATA('12659054'),
            T_TIPO_DATA('12659055'),
            T_TIPO_DATA('12659056'),
            T_TIPO_DATA('12659057'),
            T_TIPO_DATA('12659058'),
            T_TIPO_DATA('12659059'),
            T_TIPO_DATA('12659060'),
            T_TIPO_DATA('12659061'),
            T_TIPO_DATA('12659062'),
            T_TIPO_DATA('12659063'),
            T_TIPO_DATA('12659064'),
            T_TIPO_DATA('12659065'),
            T_TIPO_DATA('12659066'),
            T_TIPO_DATA('12659067'),
            T_TIPO_DATA('12659068'),
            T_TIPO_DATA('12659069'),
            T_TIPO_DATA('12659070'),
            T_TIPO_DATA('12659071'),
            T_TIPO_DATA('12659072'),
            T_TIPO_DATA('12659073'),
            T_TIPO_DATA('12659074'),
            T_TIPO_DATA('12659075'),
            T_TIPO_DATA('12659076'),
            T_TIPO_DATA('12659077'),
            T_TIPO_DATA('12659078'),
            T_TIPO_DATA('12659079'),
            T_TIPO_DATA('12659080'),
            T_TIPO_DATA('12659081'),
            T_TIPO_DATA('12659082'),
            T_TIPO_DATA('12659083'),
            T_TIPO_DATA('12659084'),
            T_TIPO_DATA('12659085'),
            T_TIPO_DATA('12659086'),
            T_TIPO_DATA('12659087'),
            T_TIPO_DATA('12659088'),
            T_TIPO_DATA('12659089'),
            T_TIPO_DATA('12659090'),
            T_TIPO_DATA('12659091'),
            T_TIPO_DATA('12659092'),
            T_TIPO_DATA('12659093'),
            T_TIPO_DATA('12659094'),
            T_TIPO_DATA('12659095'),
            T_TIPO_DATA('12659096'),
            T_TIPO_DATA('12659097'),
            T_TIPO_DATA('12659098'),
            T_TIPO_DATA('12659099'),
            T_TIPO_DATA('12659100'),
            T_TIPO_DATA('12659101'),
            T_TIPO_DATA('12659102'),
            T_TIPO_DATA('12659103'),
            T_TIPO_DATA('12659104'),
            T_TIPO_DATA('12659105'),
            T_TIPO_DATA('12659106'),
            T_TIPO_DATA('12659107'),
            T_TIPO_DATA('12659108'),
            T_TIPO_DATA('12659109'),
            T_TIPO_DATA('12659110'),
            T_TIPO_DATA('12659111'),
            T_TIPO_DATA('12659112'),
            T_TIPO_DATA('12659113'),
            T_TIPO_DATA('12659114'),
            T_TIPO_DATA('12659115'),
            T_TIPO_DATA('12659116'),
            T_TIPO_DATA('12659117'),
            T_TIPO_DATA('12659118'),
            T_TIPO_DATA('12659119'),
            T_TIPO_DATA('12659120'),
            T_TIPO_DATA('12659121'),
            T_TIPO_DATA('12659122'),
            T_TIPO_DATA('12659123'),
            T_TIPO_DATA('12659124'),
            T_TIPO_DATA('12659125'),
            T_TIPO_DATA('12659126'),
            T_TIPO_DATA('12659127'),
            T_TIPO_DATA('12659128'),
            T_TIPO_DATA('12659129'),
            T_TIPO_DATA('12659130'),
            T_TIPO_DATA('12659131'),
            T_TIPO_DATA('12659132'),
            T_TIPO_DATA('12659133'),
            T_TIPO_DATA('12659134'),
            T_TIPO_DATA('12659135'),
            T_TIPO_DATA('12659136'),
            T_TIPO_DATA('12659137'),
            T_TIPO_DATA('12659138'),
            T_TIPO_DATA('12659139'),
            T_TIPO_DATA('12659140'),
            T_TIPO_DATA('12659141'),
            T_TIPO_DATA('12659142'),
            T_TIPO_DATA('12659143'),
            T_TIPO_DATA('12659144'),
            T_TIPO_DATA('12659145'),
            T_TIPO_DATA('12659146'),
            T_TIPO_DATA('12659147'),
            T_TIPO_DATA('12659148'),
            T_TIPO_DATA('12659149'),
            T_TIPO_DATA('12659150'),
            T_TIPO_DATA('12659151'),
            T_TIPO_DATA('12659152')


    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;



BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: REALIZAMOS COMPROBACIONES');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM ='||V_PROVEEDOR_REM||' AND BORRADO=0 ';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS PROVEEDOR GASTOS');

        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            --Comprobamos la existencia del gasto
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

            IF V_COUNT = 1 THEN               

                --Obtenemos el ID del activo
                V_MSQL := 'SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE GPV_NUM_GASTO_HAYA = '''||V_TMP_TIPO_DATA(1)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;

                --Obtenemos el id del proveedor
                V_MSQL := 'SELECT PVE.PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE                            
                            WHERE PVE.PVE_COD_REM='||V_PROVEEDOR_REM||' AND BORRADO=0';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID_PROVEEDOR;

                --Actualizamos el pve_id_gestoria del gasto
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                PVE_ID_GESTORIA='||V_ID_PROVEEDOR||',
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE
                WHERE GPV_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO '''||V_TMP_TIPO_DATA(1)||''' MODIFICADO');                
            ELSE 
                DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL GASTO '''||V_TMP_TIPO_DATA(1)||'''');
            END IF;

        END LOOP;

    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL PROVEEDOR CON EL PVE_COD_REM: '||V_PROVEEDOR_REM||'');
    END IF;
     

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
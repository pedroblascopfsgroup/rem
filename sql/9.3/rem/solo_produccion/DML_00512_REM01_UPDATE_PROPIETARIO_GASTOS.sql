--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201103
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8295
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  ACTUALIZAR PROPIETARIOS GASTOS
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8295'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='GPV_GASTOS_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla a insertar    
    V_TABLA_PROPIETARIOS VARCHAR2(100 CHAR) :='ACT_PRO_PROPIETARIO';
    
    V_DOCIDENTIF VARCHAR2(100 CHAR) :='B84921758'; --DOCIDENTIF del propietario a actualizar
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion


 TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('11990252'),
        T_TIPO_DATA('12073974'),
        T_TIPO_DATA('12073982'),
        T_TIPO_DATA('12074120'),
        T_TIPO_DATA('12074121'),
        T_TIPO_DATA('12074139'),
        T_TIPO_DATA('12074452'),
        T_TIPO_DATA('12074485'),
        T_TIPO_DATA('12074614'),
        T_TIPO_DATA('12074628'),
        T_TIPO_DATA('12074808'),
        T_TIPO_DATA('12082593'),
        T_TIPO_DATA('12155969'),
        T_TIPO_DATA('12155970'),
        T_TIPO_DATA('12155971'),
        T_TIPO_DATA('12155999'),
        T_TIPO_DATA('12156000'),
        T_TIPO_DATA('12156188'),
        T_TIPO_DATA('12156189'),
        T_TIPO_DATA('12156190'),
        T_TIPO_DATA('12156301'),
        T_TIPO_DATA('12156302'),
        T_TIPO_DATA('12156352'),
        T_TIPO_DATA('12156353'),
        T_TIPO_DATA('12156354'),
        T_TIPO_DATA('12156355'),
        T_TIPO_DATA('12156376'),
        T_TIPO_DATA('12156377'),
        T_TIPO_DATA('12156378'),
        T_TIPO_DATA('12156608'),
        T_TIPO_DATA('12156609'),
        T_TIPO_DATA('12156610'),
        T_TIPO_DATA('12156653'),
        T_TIPO_DATA('12156654'),
        T_TIPO_DATA('12156655'),
        T_TIPO_DATA('12158479'),
        T_TIPO_DATA('12158480'),
        T_TIPO_DATA('12158481'),
        T_TIPO_DATA('12158482'),
        T_TIPO_DATA('12158483'),
        T_TIPO_DATA('12158484'),
        T_TIPO_DATA('12158679'),
        T_TIPO_DATA('12158680'),
        T_TIPO_DATA('12187449'),
        T_TIPO_DATA('12191027'),
        T_TIPO_DATA('12191033'),
        T_TIPO_DATA('12191035'),
        T_TIPO_DATA('12191037'),
        T_TIPO_DATA('12191039'),
        T_TIPO_DATA('12191041'),
        T_TIPO_DATA('12191043'),
        T_TIPO_DATA('12275514'),
        T_TIPO_DATA('12275972'),
        T_TIPO_DATA('12304761'),
        T_TIPO_DATA('12311706'),
        T_TIPO_DATA('12311707'),
        T_TIPO_DATA('12311708'),
        T_TIPO_DATA('12311709'),
        T_TIPO_DATA('12311710'),
        T_TIPO_DATA('12311711'),
        T_TIPO_DATA('12311712'),
        T_TIPO_DATA('12311713'),
        T_TIPO_DATA('12311714'),
        T_TIPO_DATA('12311715'),
        T_TIPO_DATA('12318633'),
        T_TIPO_DATA('12319545'),
        T_TIPO_DATA('12319547'),
        T_TIPO_DATA('12319550'),
        T_TIPO_DATA('12319551'),
        T_TIPO_DATA('12328162'),
        T_TIPO_DATA('12328163'),
        T_TIPO_DATA('12328171'),
        T_TIPO_DATA('12328173'),
        T_TIPO_DATA('12328177'),
        T_TIPO_DATA('12328178'),
        T_TIPO_DATA('12328188'),
        T_TIPO_DATA('12328189'),
        T_TIPO_DATA('12328190'),
        T_TIPO_DATA('12328199'),
        T_TIPO_DATA('12328202'),
        T_TIPO_DATA('12328206'),
        T_TIPO_DATA('12328208'),
        T_TIPO_DATA('12328213'),
        T_TIPO_DATA('12328214'),
        T_TIPO_DATA('12328215'),
        T_TIPO_DATA('12328217'),
        T_TIPO_DATA('12328222'),
        T_TIPO_DATA('12328224'),
        T_TIPO_DATA('12328229'),
        T_TIPO_DATA('12328233'),
        T_TIPO_DATA('12328242'),
        T_TIPO_DATA('12328245'),
        T_TIPO_DATA('12328254'),
        T_TIPO_DATA('12328255'),
        T_TIPO_DATA('12328256'),
        T_TIPO_DATA('12328262'),
        T_TIPO_DATA('12328334'),
        T_TIPO_DATA('12328346'),
        T_TIPO_DATA('12328367'),
        T_TIPO_DATA('12328368'),
        T_TIPO_DATA('12328378'),
        T_TIPO_DATA('12328389'),
        T_TIPO_DATA('12328402'),
        T_TIPO_DATA('12328410'),
        T_TIPO_DATA('12328411'),
        T_TIPO_DATA('12328414'),
        T_TIPO_DATA('12328418'),
        T_TIPO_DATA('12328419'),
        T_TIPO_DATA('12328425'),
        T_TIPO_DATA('12328430'),
        T_TIPO_DATA('12328437'),
        T_TIPO_DATA('12328438'),
        T_TIPO_DATA('12328441'),
        T_TIPO_DATA('12328442'),
        T_TIPO_DATA('12328446'),
        T_TIPO_DATA('12329632'),
        T_TIPO_DATA('12329633'),
        T_TIPO_DATA('12329634'),
        T_TIPO_DATA('12329635'),
        T_TIPO_DATA('12329636'),
        T_TIPO_DATA('12329637'),
        T_TIPO_DATA('12329638'),
        T_TIPO_DATA('12329639'),
        T_TIPO_DATA('12329642'),
        T_TIPO_DATA('12329643'),
        T_TIPO_DATA('12329644'),
        T_TIPO_DATA('12329751'),
        T_TIPO_DATA('12329752'),
        T_TIPO_DATA('12329753'),
        T_TIPO_DATA('12329760'),
        T_TIPO_DATA('12329761'),
        T_TIPO_DATA('12329762'),
        T_TIPO_DATA('12329763'),
        T_TIPO_DATA('12329764'),
        T_TIPO_DATA('12329765'),
        T_TIPO_DATA('12329766'),
        T_TIPO_DATA('12329767'),
        T_TIPO_DATA('12329768'),
        T_TIPO_DATA('12329769'),
        T_TIPO_DATA('12329770'),
        T_TIPO_DATA('12329771'),
        T_TIPO_DATA('12329772'),
        T_TIPO_DATA('12329773'),
        T_TIPO_DATA('12329774'),
        T_TIPO_DATA('12329775'),
        T_TIPO_DATA('12329776'),
        T_TIPO_DATA('12329777'),
        T_TIPO_DATA('12329778'),
        T_TIPO_DATA('12329779'),
        T_TIPO_DATA('12329780'),
        T_TIPO_DATA('12329781'),
        T_TIPO_DATA('12329782'),
        T_TIPO_DATA('12329783'),
        T_TIPO_DATA('12329784'),
        T_TIPO_DATA('12329785'),
        T_TIPO_DATA('12329786'),
        T_TIPO_DATA('12329787'),
        T_TIPO_DATA('12329796'),
        T_TIPO_DATA('12329797'),
        T_TIPO_DATA('12329798'),
        T_TIPO_DATA('12329799'),
        T_TIPO_DATA('12329800'),
        T_TIPO_DATA('12329801'),
        T_TIPO_DATA('12329802'),
        T_TIPO_DATA('12329803'),
        T_TIPO_DATA('12329804'),
        T_TIPO_DATA('12329805'),
        T_TIPO_DATA('12329806'),
        T_TIPO_DATA('12329809'),
        T_TIPO_DATA('12329810'),
        T_TIPO_DATA('12329811'),
        T_TIPO_DATA('12329812'),
        T_TIPO_DATA('12329813'),
        T_TIPO_DATA('12329814'),
        T_TIPO_DATA('12329818'),
        T_TIPO_DATA('12329819'),
        T_TIPO_DATA('12329820'),
        T_TIPO_DATA('12329821'),
        T_TIPO_DATA('12329822'),
        T_TIPO_DATA('12329823'),
        T_TIPO_DATA('12329824'),
        T_TIPO_DATA('12329825'),
        T_TIPO_DATA('12329826'),
        T_TIPO_DATA('12329827'),
        T_TIPO_DATA('12329828'),
        T_TIPO_DATA('12329832'),
        T_TIPO_DATA('12329833'),
        T_TIPO_DATA('12329834'),
        T_TIPO_DATA('12329835'),
        T_TIPO_DATA('12329836'),
        T_TIPO_DATA('12329837'),
        T_TIPO_DATA('12329838'),
        T_TIPO_DATA('12329839'),
        T_TIPO_DATA('12329840'),
        T_TIPO_DATA('12329841'),
        T_TIPO_DATA('12329842'),
        T_TIPO_DATA('12329843'),
        T_TIPO_DATA('12329844'),
        T_TIPO_DATA('12329845'),
        T_TIPO_DATA('12329846'),
        T_TIPO_DATA('12329847'),
        T_TIPO_DATA('12329848'),
        T_TIPO_DATA('12329849'),
        T_TIPO_DATA('12329850'),
        T_TIPO_DATA('12329851'),
        T_TIPO_DATA('12329852'),
        T_TIPO_DATA('12329853'),
        T_TIPO_DATA('12329854'),
        T_TIPO_DATA('12329855'),
        T_TIPO_DATA('12329856'),
        T_TIPO_DATA('12329857'),
        T_TIPO_DATA('12329858'),
        T_TIPO_DATA('12329859'),
        T_TIPO_DATA('12329860'),
        T_TIPO_DATA('12329861'),
        T_TIPO_DATA('12329862'),
        T_TIPO_DATA('12329863'),
        T_TIPO_DATA('12329864'),
        T_TIPO_DATA('12329865'),
        T_TIPO_DATA('12329866'),
        T_TIPO_DATA('12329867'),
        T_TIPO_DATA('12329868'),
        T_TIPO_DATA('12329869'),
        T_TIPO_DATA('12329870'),
        T_TIPO_DATA('12329871'),
        T_TIPO_DATA('12329872'),
        T_TIPO_DATA('12329873'),
        T_TIPO_DATA('12329874'),
        T_TIPO_DATA('12329875'),
        T_TIPO_DATA('12329876'),
        T_TIPO_DATA('12329877'),
        T_TIPO_DATA('12329880'),
        T_TIPO_DATA('12329881'),
        T_TIPO_DATA('12329882'),
        T_TIPO_DATA('12329883'),
        T_TIPO_DATA('12329884'),
        T_TIPO_DATA('12329885'),
        T_TIPO_DATA('12329886'),
        T_TIPO_DATA('12329887'),
        T_TIPO_DATA('12329888'),
        T_TIPO_DATA('12329889'),
        T_TIPO_DATA('12329890'),
        T_TIPO_DATA('12329934'),
        T_TIPO_DATA('12329935'),
        T_TIPO_DATA('12329936'),
        T_TIPO_DATA('12329937'),
        T_TIPO_DATA('12329938'),
        T_TIPO_DATA('12329939'),
        T_TIPO_DATA('12329940'),
        T_TIPO_DATA('12329941'),
        T_TIPO_DATA('12329942'),
        T_TIPO_DATA('12329943'),
        T_TIPO_DATA('12329944'),
        T_TIPO_DATA('12330648'),
        T_TIPO_DATA('12330655'),
        T_TIPO_DATA('12330662'),
        T_TIPO_DATA('12330669'),
        T_TIPO_DATA('12330670'),
        T_TIPO_DATA('12330671'),
        T_TIPO_DATA('12330983'),
        T_TIPO_DATA('12330984'),
        T_TIPO_DATA('12330992'),
        T_TIPO_DATA('12330993'),
        T_TIPO_DATA('12330994'),
        T_TIPO_DATA('12330999'),
        T_TIPO_DATA('12331000'),
        T_TIPO_DATA('12331008'),
        T_TIPO_DATA('12331009'),
        T_TIPO_DATA('12331010'),
        T_TIPO_DATA('12331011'),
        T_TIPO_DATA('12335153'),
        T_TIPO_DATA('12335154'),
        T_TIPO_DATA('12335155')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA||' ');            


    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIOS||' WHERE PRO_DOCIDENTIF='''||V_DOCIDENTIF||''' ';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN              

        V_SQL:='SELECT PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PROPIETARIOS||' WHERE PRO_DOCIDENTIF='''||V_DOCIDENTIF||''' AND BORRADO=0';
         EXECUTE IMMEDIATE V_SQL INTO V_ID;

        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            
            V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
            --Comprobar si el gasto ya existe
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
            
            IF V_NUM_TABLAS > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS PROPIETARIO DEL GASTO GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||''' ');
                    
                
                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                        PRO_ID = '||V_ID||' ,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE 
                        WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';

                EXECUTE IMMEDIATE V_MSQL;


                IF sql%rowcount > 0 THEN 
                    DBMS_OUTPUT.PUT_LINE('[INFO]: Modificado el GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||'''  Con propietario: MOSACATA ');
                    DBMS_OUTPUT.PUT_LINE('[INFO]:                                                                                           ');
                    V_COUNT:=V_COUNT+1;
                END IF;

            ELSE                
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL GASTO CON GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||''' ');

            END IF;

        END LOOP;

    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE PROPIETARIO CON EL DOCIDENTIF INDICADO:  '''||V_DOCIDENTIF||''' ');
    END IF;

         DBMS_OUTPUT.PUT_LINE('[FIN]: ACTUALIZADOS CORRECTAMENTE '''||V_COUNT||''' DE '''||V_COUNT_TOTAL||''' ');

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
EXIT
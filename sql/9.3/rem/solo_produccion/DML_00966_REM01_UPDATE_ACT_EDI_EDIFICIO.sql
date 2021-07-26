--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210723
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10200
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10200'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_EDI_ID NUMBER(16);
    V_TEXTO VARCHAR2(3000 CHAR) := 'Se hace constar que todos los gastos generales, comunes y de servicios imputables al inmueble, que no sean susceptibles de individualización, serán de cuenta y cargo de la ARRENDATARIA. Estos gastos incluirán, en su caso, los gastos generales para el adecuado sostenimiento del inmueble y sus servicios (esto es, Gastos de Comunidad de Propietarios o entidad asimilada si la hubiera), tributos (incluyendo específicamente, pero sin carácter limitativo, el Impuesto sobre Bienes Inmuebles), la tasa de residuos urbanos de actividades (o de basuras) u otras, así como las cargas y responsabilidades que correspondan al inmueble';

    --Estos son los ACT_NUM_ACTIVO de la agrupación 1000029143
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('5928805'),
                T_TIPO_DATA('5928887'),
                T_TIPO_DATA('5928890'),
                T_TIPO_DATA('5931580'),
                T_TIPO_DATA('5938383'),
                T_TIPO_DATA('5939237'),
                T_TIPO_DATA('5944848'),
                T_TIPO_DATA('5946310'),
                T_TIPO_DATA('5953432'),
                T_TIPO_DATA('5955010'),
                T_TIPO_DATA('5955048'),
                T_TIPO_DATA('5956654'),
                T_TIPO_DATA('5957256'),
                T_TIPO_DATA('5962375'),
                T_TIPO_DATA('5963305'),
                T_TIPO_DATA('5963971'),
                T_TIPO_DATA('5964247'),
                T_TIPO_DATA('5964521'),
                T_TIPO_DATA('5966119'),
                T_TIPO_DATA('5966840'),
                T_TIPO_DATA('5967479'),
                T_TIPO_DATA('5971478'),
                T_TIPO_DATA('6044864'),
                T_TIPO_DATA('6052654'),
                T_TIPO_DATA('6052655'),
                T_TIPO_DATA('6052695'),
                T_TIPO_DATA('6052726'),
                T_TIPO_DATA('6053617'),
                T_TIPO_DATA('6053618'),
                T_TIPO_DATA('6057341'),
                T_TIPO_DATA('6059306'),
                T_TIPO_DATA('6061020'),
                T_TIPO_DATA('6061320'),
                T_TIPO_DATA('6061477'),
                T_TIPO_DATA('6064467'),
                T_TIPO_DATA('6064468'),
                T_TIPO_DATA('6355145'),
                T_TIPO_DATA('6780522'),
                T_TIPO_DATA('6780536'),
                T_TIPO_DATA('6803445'),
                T_TIPO_DATA('6803448'),
                T_TIPO_DATA('6830912'),
                T_TIPO_DATA('6836953'),
                T_TIPO_DATA('6945115'),
                T_TIPO_DATA('6945127'),
                T_TIPO_DATA('6947569'),
                T_TIPO_DATA('6947587'),
                T_TIPO_DATA('6959966'),
                T_TIPO_DATA('6963786'),
                T_TIPO_DATA('6965228'),
                T_TIPO_DATA('6965692'),
                T_TIPO_DATA('6965713'),
                T_TIPO_DATA('6965732'),
            --    T_TIPO_DATA('6965751'),
                T_TIPO_DATA('6965758'),
                T_TIPO_DATA('6965760'),
                T_TIPO_DATA('6965771'),
                T_TIPO_DATA('6965787'),
                T_TIPO_DATA('6965791'),
                T_TIPO_DATA('6965836'),
                T_TIPO_DATA('6965886'),
                T_TIPO_DATA('6965931'),
                T_TIPO_DATA('6966205'),
                T_TIPO_DATA('6966850'),
                T_TIPO_DATA('6966866'),
                T_TIPO_DATA('6966900'),
                T_TIPO_DATA('6966999'),
                T_TIPO_DATA('6969528'),
                T_TIPO_DATA('6972076'),
                T_TIPO_DATA('6972095'),
                T_TIPO_DATA('6979753'),
                T_TIPO_DATA('6979879'),
                T_TIPO_DATA('6980135'),
                T_TIPO_DATA('6981236'),
                T_TIPO_DATA('6983119'),
                T_TIPO_DATA('6983124'),
                T_TIPO_DATA('6984272'),
                T_TIPO_DATA('6984549'),
                T_TIPO_DATA('6987011'),
                T_TIPO_DATA('6989009'),
                T_TIPO_DATA('6989208'),
                T_TIPO_DATA('6989588'),
                T_TIPO_DATA('6990428'),
                T_TIPO_DATA('6990572'),
                T_TIPO_DATA('6991350'),
                T_TIPO_DATA('6991823'),
                T_TIPO_DATA('6991989'),
                T_TIPO_DATA('6992834'),
                T_TIPO_DATA('6992908'),
                T_TIPO_DATA('6992943'),
                T_TIPO_DATA('6993671'),
                T_TIPO_DATA('6994074'),
                T_TIPO_DATA('6994952'),
                T_TIPO_DATA('6996326'),
                T_TIPO_DATA('6996854'),
                T_TIPO_DATA('6997466'),
                T_TIPO_DATA('6998198'),
                T_TIPO_DATA('6998650'),
                T_TIPO_DATA('6999200'),
                T_TIPO_DATA('6999251'),
                T_TIPO_DATA('6999266'),
                T_TIPO_DATA('6999348'),
                T_TIPO_DATA('7001763'),
                T_TIPO_DATA('7002222'),
                T_TIPO_DATA('7074419'),
                T_TIPO_DATA('7075111'),
                T_TIPO_DATA('7076247'),
                T_TIPO_DATA('7089074'),
                T_TIPO_DATA('7094568'),
                T_TIPO_DATA('7099544'),
                T_TIPO_DATA('7099855'),
                T_TIPO_DATA('7099992'),
                T_TIPO_DATA('7101480'),
                T_TIPO_DATA('7225492'),
                T_TIPO_DATA('7226031'),
                T_TIPO_DATA('7226038'),
                T_TIPO_DATA('7293182'),
                T_TIPO_DATA('7294162'),
                T_TIPO_DATA('7296646'),
                T_TIPO_DATA('7296648'),
                T_TIPO_DATA('7296796'),
                T_TIPO_DATA('7302704'),
                T_TIPO_DATA('7386560'),
                T_TIPO_DATA('7386567'),
                T_TIPO_DATA('7386573'),
                T_TIPO_DATA('7403031'),
                T_TIPO_DATA('7432163'),
                T_TIPO_DATA('7432775')





    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            V_COUNT := 0;

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT aedi.EDI_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO act
            JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ico ON ico.ACT_ID = act.ACT_ID
            JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO aedi ON aedi.ICO_ID = ico.ICO_ID
            WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_EDI_ID;



            --Actualizamos el dato
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_EDI_EDIFICIO SET           
            EDI_DESCRIPCION =(CONCAT(EDI_DESCRIPCION, CONCAT( CHR(10), '''||V_TEXTO||'''))),
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE               
            WHERE EDI_ID = '||V_EDI_ID||'';
            EXECUTE IMMEDIATE V_MSQL;


            DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

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

EXIT
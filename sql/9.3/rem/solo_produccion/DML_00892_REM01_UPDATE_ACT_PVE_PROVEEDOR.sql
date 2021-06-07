--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210603
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9868
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-9868'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ID NUMBER(16);
    V_ID_MEDIADOR NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('7451','3355'),
                T_TIPO_DATA('7833','3355'),
                T_TIPO_DATA('7791','3355'),
                T_TIPO_DATA('7448','3355'),
                T_TIPO_DATA('7450','3355'),
                T_TIPO_DATA('7455','3355'),
                T_TIPO_DATA('7460','3355'),
                T_TIPO_DATA('7464','3355'),
                T_TIPO_DATA('7466','3355'),
                T_TIPO_DATA('7469','3355'),
                T_TIPO_DATA('7471','3355'),
                T_TIPO_DATA('7749','4384'),
                T_TIPO_DATA('7752','4384'),
                T_TIPO_DATA('7768','4384'),
                T_TIPO_DATA('7841','4384'),
                T_TIPO_DATA('7845','4384'),
                T_TIPO_DATA('7849','4384'),
                T_TIPO_DATA('7852','4384'),
                T_TIPO_DATA('7855','4384'),
                T_TIPO_DATA('7856','4384'),
                T_TIPO_DATA('7858','4384'),
                T_TIPO_DATA('7859','4384'),
                T_TIPO_DATA('7860','4384'),
                T_TIPO_DATA('7862','4384'),
                T_TIPO_DATA('7865','4384'),
                T_TIPO_DATA('7866','4384'),
                T_TIPO_DATA('7742','4384'),
                T_TIPO_DATA('7743','4384'),
                T_TIPO_DATA('7745','4384'),
                T_TIPO_DATA('7746','4384'),
                T_TIPO_DATA('7748','4384'),
                T_TIPO_DATA('7750','4384'),
                T_TIPO_DATA('7751','4384'),
                T_TIPO_DATA('7755','4384'),
                T_TIPO_DATA('7757','4384'),
                T_TIPO_DATA('7758','4384'),
                T_TIPO_DATA('7760','4384'),
                T_TIPO_DATA('7767','4384'),
                T_TIPO_DATA('7774','4384'),
                T_TIPO_DATA('7777','4384'),
                T_TIPO_DATA('7843','4384'),
                T_TIPO_DATA('7773','4384'),
                T_TIPO_DATA('7775','4384'),
                T_TIPO_DATA('7776','4384'),
                T_TIPO_DATA('7422','4413'),
                T_TIPO_DATA('7423','4413'),
                T_TIPO_DATA('7424','4413'),
                T_TIPO_DATA('7426','4413'),
                T_TIPO_DATA('7427','4413'),
                T_TIPO_DATA('7428','4413'),
                T_TIPO_DATA('7429','4413'),
                T_TIPO_DATA('7430','4413'),
                T_TIPO_DATA('7431','4413'),
                T_TIPO_DATA('7432','4413'),
                T_TIPO_DATA('7433','4413'),
                T_TIPO_DATA('7435','4413'),
                T_TIPO_DATA('7436','4413'),
                T_TIPO_DATA('7437','4413'),
                T_TIPO_DATA('7438','4413'),
                T_TIPO_DATA('7439','4413'),
                T_TIPO_DATA('7440','4413'),
                T_TIPO_DATA('7441','4413'),
                T_TIPO_DATA('7442','4413'),
                T_TIPO_DATA('7452','115'),
                T_TIPO_DATA('7770','115'),
                T_TIPO_DATA('7445','115'),
                T_TIPO_DATA('7446','115'),
                T_TIPO_DATA('7459','115'),
                T_TIPO_DATA('7462','115'),
                T_TIPO_DATA('7467','115'),
                T_TIPO_DATA('7468','115'),
                T_TIPO_DATA('7470','115'),
                T_TIPO_DATA('7472','115'),
                T_TIPO_DATA('7474','115'),
                T_TIPO_DATA('7443','115'),
                T_TIPO_DATA('7444','115'),
                T_TIPO_DATA('8106','1096'),
                T_TIPO_DATA('7835','1096'),
                T_TIPO_DATA('7840','1096'),
                T_TIPO_DATA('7857','1096'),
                T_TIPO_DATA('7867','1096'),
                T_TIPO_DATA('7740','1096'),
                T_TIPO_DATA('7741','1096'),
                T_TIPO_DATA('7744','1096'),
                T_TIPO_DATA('7747','1096'),
                T_TIPO_DATA('7753','1096'),
                T_TIPO_DATA('7763','1096'),
                T_TIPO_DATA('7771','1096'),
                T_TIPO_DATA('7772','1096'),
                T_TIPO_DATA('7783','1096'),
                T_TIPO_DATA('7787','1096'),
                T_TIPO_DATA('7790','1096'),
                T_TIPO_DATA('7797','1096'),
                T_TIPO_DATA('7681','1096'),
                T_TIPO_DATA('7682','1096'),
                T_TIPO_DATA('7699','1096'),
                T_TIPO_DATA('7700','1096'),
                T_TIPO_DATA('7701','1096'),
                T_TIPO_DATA('7702','1096'),
                T_TIPO_DATA('7705','1096'),
                T_TIPO_DATA('7709','1096'),
                T_TIPO_DATA('7225','1096'),
                T_TIPO_DATA('8951','2161'),
                T_TIPO_DATA('8952','2161'),
                T_TIPO_DATA('8953','2161'),
                T_TIPO_DATA('8954','2161'),
                T_TIPO_DATA('8955','2161'),
                T_TIPO_DATA('8828','2161'),
                T_TIPO_DATA('8830','2161'),
                T_TIPO_DATA('8831','2161'),
                T_TIPO_DATA('8832','2161'),
                T_TIPO_DATA('8833','2161'),
                T_TIPO_DATA('8840','2161'),
                T_TIPO_DATA('8773','2161'),
                T_TIPO_DATA('7995','2161'),
                T_TIPO_DATA('7873','2161'),
                T_TIPO_DATA('9604','954'),
                T_TIPO_DATA('7829','954'),
                T_TIPO_DATA('9723','954'),
                T_TIPO_DATA('7809','954'),
                T_TIPO_DATA('7813','954'),
                T_TIPO_DATA('7819','954'),
                T_TIPO_DATA('8842','954'),
                T_TIPO_DATA('7812','954'),
                T_TIPO_DATA('7822','954'),
                T_TIPO_DATA('7874','954'),
                T_TIPO_DATA('7880','954'),
                T_TIPO_DATA('7885','954'),
                T_TIPO_DATA('7893','954'),
                T_TIPO_DATA('7896','954'),
                T_TIPO_DATA('7907','954'),
                T_TIPO_DATA('7910','954'),
                T_TIPO_DATA('7911','954'),
                T_TIPO_DATA('7914','954'),
                T_TIPO_DATA('7917','954'),
                T_TIPO_DATA('7920','954'),
                T_TIPO_DATA('7930','954'),
                T_TIPO_DATA('7808','954'),
                T_TIPO_DATA('7821','954'),
                T_TIPO_DATA('7825','954'),
                T_TIPO_DATA('8844','954'),
                T_TIPO_DATA('7876','954'),
                T_TIPO_DATA('7881','954'),
                T_TIPO_DATA('7882','954'),
                T_TIPO_DATA('7891','954'),
                T_TIPO_DATA('7895','954'),
                T_TIPO_DATA('7899','954'),
                T_TIPO_DATA('7900','954'),
                T_TIPO_DATA('7901','954'),
                T_TIPO_DATA('7903','954'),
                T_TIPO_DATA('7908','954'),
                T_TIPO_DATA('7912','954'),
                T_TIPO_DATA('7913','954'),
                T_TIPO_DATA('7923','954'),
                T_TIPO_DATA('7924','954'),
                T_TIPO_DATA('8894','3258'),
                T_TIPO_DATA('8895','3258'),
                T_TIPO_DATA('8896','3258'),
                T_TIPO_DATA('8898','3258'),
                T_TIPO_DATA('8899','3258'),
                T_TIPO_DATA('8900','3258'),
                T_TIPO_DATA('8901','3258'),
                T_TIPO_DATA('8904','3258'),
                T_TIPO_DATA('8906','3258'),
                T_TIPO_DATA('8908','3258'),
                T_TIPO_DATA('8909','3258'),
                T_TIPO_DATA('8910','3258'),
                T_TIPO_DATA('8914','3258'),
                T_TIPO_DATA('8916','3258'),
                T_TIPO_DATA('8918','3258'),
                T_TIPO_DATA('7715','3258'),
                T_TIPO_DATA('7720','3258'),
                T_TIPO_DATA('8927','3378'),
                T_TIPO_DATA('8928','3378'),
                T_TIPO_DATA('8929','3378'),
                T_TIPO_DATA('8930','3378'),
                T_TIPO_DATA('8931','3378'),
                T_TIPO_DATA('8932','3378'),
                T_TIPO_DATA('8933','3378'),
                T_TIPO_DATA('8934','3378'),
                T_TIPO_DATA('7834','3378'),
                T_TIPO_DATA('7796','13106'),
                T_TIPO_DATA('7801','13106'),
                T_TIPO_DATA('7680','13106'),
                T_TIPO_DATA('7692','13106'),
                T_TIPO_DATA('7784','13106'),
                T_TIPO_DATA('7785','13106'),
                T_TIPO_DATA('7795','13106'),
                T_TIPO_DATA('7798','13106'),
                T_TIPO_DATA('7802','13106'),
                T_TIPO_DATA('7803','13106'),
                T_TIPO_DATA('7676','13106'),
                T_TIPO_DATA('7677','13106'),
                T_TIPO_DATA('7678','13106'),
                T_TIPO_DATA('7679','13106'),
                T_TIPO_DATA('7685','13106'),
                T_TIPO_DATA('7686','13106'),
                T_TIPO_DATA('7690','13106'),
                T_TIPO_DATA('7691','13106'),
                T_TIPO_DATA('7693','13106'),
                T_TIPO_DATA('7695','13106'),
                T_TIPO_DATA('7696','13106'),
                T_TIPO_DATA('7703','13106'),
                T_TIPO_DATA('7704','13106'),
                T_TIPO_DATA('7710','13106'),
                T_TIPO_DATA('7712','13106'),
                T_TIPO_DATA('7224','13106'),
                T_TIPO_DATA('7839','2105'),
                T_TIPO_DATA('7447','2105'),
                T_TIPO_DATA('7456','2105'),
                T_TIPO_DATA('7458','2105'),
                T_TIPO_DATA('7465','2105'),
                T_TIPO_DATA('8871','110166277'),
                T_TIPO_DATA('8874','110166277'),
                T_TIPO_DATA('8721','4448'),
                T_TIPO_DATA('7992','4448'),
                T_TIPO_DATA('7871','4448'),
                T_TIPO_DATA('7872','4448'),
                T_TIPO_DATA('7298','4448'),
                T_TIPO_DATA('7288','4448'),
                T_TIPO_DATA('7289','4448'),
                T_TIPO_DATA('7203','110166541'),
                T_TIPO_DATA('7204','110156954')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del proveedor
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Comprobamos la existencia del mediador
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(2)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

            IF V_COUNT = 1 THEN

                --Obtenemos el ID del PROVEEDOR
                V_MSQL := 'SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(1)||'';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;

                --Obtenemos el ID del MEDIADOR
                V_MSQL := 'SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(2)||'';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID_MEDIADOR;

                --Actualizamos el dato
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR SET
                PVE_ID_MEDIADOR_REL = '||V_ID_MEDIADOR||',  
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE               
                WHERE PVE_ID = '||V_ID||'';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: PROVEEDOR '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL MEDIADOR '''||V_TMP_TIPO_DATA(2)||'''');

            END IF;
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL PROVEEDOR '''||V_TMP_TIPO_DATA(1)||'''');

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
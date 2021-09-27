--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10464
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10464'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ID NUMBER(16);
    V_ID_MEDIADOR NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7629','10005070'),
            T_TIPO_DATA('7638','3344'),
            T_TIPO_DATA('7633','3240'),
            T_TIPO_DATA('7628','10005070'),
            T_TIPO_DATA('7636','2137'),
            T_TIPO_DATA('7482','2127'),
            T_TIPO_DATA('7631','662'),
            T_TIPO_DATA('7632','439'),
            T_TIPO_DATA('7626','10005070'),
            T_TIPO_DATA('7627','10005070'),
            T_TIPO_DATA('7481','436'),
            T_TIPO_DATA('7634','435'),
            T_TIPO_DATA('7639','435'),
            T_TIPO_DATA('96204','2143'),
            T_TIPO_DATA('96603','10005070'),
            T_TIPO_DATA('95801','3344'),
            T_TIPO_DATA('95807','20587'),
            T_TIPO_DATA('96252','10005070'),
            T_TIPO_DATA('96259','10005070'),
            T_TIPO_DATA('96716','10005070'),
            T_TIPO_DATA('96722','10005070'),
            T_TIPO_DATA('96289','10005070'),
            T_TIPO_DATA('96298','10005070'),
            T_TIPO_DATA('96301','10005070'),
            T_TIPO_DATA('96682','10005070'),
            T_TIPO_DATA('96003','3344'),
            T_TIPO_DATA('96004','3344'),
            T_TIPO_DATA('96443','10005070'),
            T_TIPO_DATA('96459','10005070'),
            T_TIPO_DATA('95634','3344'),
            T_TIPO_DATA('97030','10005070'),
            T_TIPO_DATA('96735','10005070'),
            T_TIPO_DATA('96783','3344'),
            T_TIPO_DATA('96862','10005070'),
            T_TIPO_DATA('96874','10005070'),
            T_TIPO_DATA('96878','10005070'),
            T_TIPO_DATA('96888','3344'),
            T_TIPO_DATA('96902','10005070'),
            T_TIPO_DATA('95432','3344'),
            T_TIPO_DATA('94813','3240'),
            T_TIPO_DATA('95248','10005070'),
            T_TIPO_DATA('95283','3344'),
            T_TIPO_DATA('95285','963'),
            T_TIPO_DATA('94457','3344'),
            T_TIPO_DATA('110075385','436'),
            T_TIPO_DATA('110075293','126'),
            T_TIPO_DATA('110075691','3232'),
            T_TIPO_DATA('110189108','4767'),
            T_TIPO_DATA('8184','3344'),
            T_TIPO_DATA('7630','3344'),
            T_TIPO_DATA('8186','662'),
            T_TIPO_DATA('9463','10005070'),
            T_TIPO_DATA('8174','2263'),
            T_TIPO_DATA('8173','2137'),
            T_TIPO_DATA('8182','10005070'),
            T_TIPO_DATA('7624','10005070'),
            T_TIPO_DATA('9855','963'),
            T_TIPO_DATA('7640','10005070'),
            T_TIPO_DATA('8179','10005070'),
            T_TIPO_DATA('9856','126'),
            T_TIPO_DATA('8060','662'),
            T_TIPO_DATA('8176','2137'),
            T_TIPO_DATA('8063','4767'),
            T_TIPO_DATA('8183','3344'),
            T_TIPO_DATA('8175','2137'),
            T_TIPO_DATA('9854','12608'),
            T_TIPO_DATA('7641','2143'),
            T_TIPO_DATA('8062','439'),
            T_TIPO_DATA('8181','10005070'),
            T_TIPO_DATA('9859','3240'),
            T_TIPO_DATA('9861','2127'),
            T_TIPO_DATA('9858','3232'),
            T_TIPO_DATA('7635','10005070'),
            T_TIPO_DATA('8180','10005070'),
            T_TIPO_DATA('7623','10005070'),
            T_TIPO_DATA('8185','663'),
            T_TIPO_DATA('8177','2137'),
            T_TIPO_DATA('8178','436'),
            T_TIPO_DATA('110075085','10005070'),
            T_TIPO_DATA('110075084','10005070'),
            T_TIPO_DATA('110189110','2137'),
            T_TIPO_DATA('110189109','10005070'),
            T_TIPO_DATA('110190255','10005070'),
            T_TIPO_DATA('110190256','963'),
            T_TIPO_DATA('110190257','2137'),
            T_TIPO_DATA('110190260','435'),
            T_TIPO_DATA('110190258','3344'),
            T_TIPO_DATA('110190259','435'),
            T_TIPO_DATA('110190261','2339')

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
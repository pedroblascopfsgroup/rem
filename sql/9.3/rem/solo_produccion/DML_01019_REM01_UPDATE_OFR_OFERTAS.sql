--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210825
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10358
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10358'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);

    -- DD_ORC_ID             OFR_ID_PRES_ORI_LEAD
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('90291241','138'),
            T_TIPO_DATA('90280486','110159516'),
            T_TIPO_DATA('90319709','96'),
            T_TIPO_DATA('90324658','110155397'),
            T_TIPO_DATA('90315848','150'),
            T_TIPO_DATA('90293126','110113460'),
            T_TIPO_DATA('90317715','10553'),
            T_TIPO_DATA('90308780','110161109'),
            T_TIPO_DATA('90325918','963'),
            T_TIPO_DATA('90331869','110166526'),
            T_TIPO_DATA('90328026','2012'),
            T_TIPO_DATA('90332730','4430'),
            T_TIPO_DATA('90317925','4564'),
            T_TIPO_DATA('90320657','11308'),
            T_TIPO_DATA('90315303','110162712'),
            T_TIPO_DATA('90324669','2271'),
            T_TIPO_DATA('90316764','126'),
            T_TIPO_DATA('90320503','4430'),
            T_TIPO_DATA('90329459','110080848'),
            T_TIPO_DATA('90312836','4767'),
            T_TIPO_DATA('90331762','2091'),
            T_TIPO_DATA('90329882','4434'),
            T_TIPO_DATA('90317735','672'),
            T_TIPO_DATA('90329590','110159520'),
            T_TIPO_DATA('90329602','110159520'),
            T_TIPO_DATA('90328554','110191669'),
            T_TIPO_DATA('90304934','10699'),
            T_TIPO_DATA('90316152','110159516'),
            T_TIPO_DATA('90322545','9990009'),
            T_TIPO_DATA('90299418','110117963'),
            T_TIPO_DATA('90311096','9990119'),
            T_TIPO_DATA('90327569','13071'),
            T_TIPO_DATA('90316231','5823'),
            T_TIPO_DATA('90330677','3403'),
            T_TIPO_DATA('90322101','10859'),
            T_TIPO_DATA('90329448','115'),
            T_TIPO_DATA('90326553','2271'),
            T_TIPO_DATA('90325861','10858'),
            T_TIPO_DATA('90326943','2271'),
            T_TIPO_DATA('90315491','662'),
            T_TIPO_DATA('90331107','4456'),
            T_TIPO_DATA('90332657','4413'),
            T_TIPO_DATA('90312492','110166277'),
            T_TIPO_DATA('90304070','963'),
            T_TIPO_DATA('90326785','150'),
            T_TIPO_DATA('90327264','110187725'),
            T_TIPO_DATA('90330605','96'),
            T_TIPO_DATA('90337642','2127'),
            T_TIPO_DATA('90333956','13150'),
            T_TIPO_DATA('90329464','3134'),
            T_TIPO_DATA('90327227','10586'),
            T_TIPO_DATA('90327464','1798'),
            T_TIPO_DATA('90328833','116'),
            T_TIPO_DATA('90329475','110128071'),
            T_TIPO_DATA('90329677','110128071'),
            T_TIPO_DATA('90330023','4434'),
            T_TIPO_DATA('90324482','3351'),
            T_TIPO_DATA('90320231','110162785'),
            T_TIPO_DATA('90328190','6535'),
            T_TIPO_DATA('90324025','110159523'),
            T_TIPO_DATA('90321486','110161299'),
            T_TIPO_DATA('90281508','110161766'),
            T_TIPO_DATA('90332225','110082778'),
            T_TIPO_DATA('90321606','110159513'),
            T_TIPO_DATA('90329166','110161226'),
            T_TIPO_DATA('90318152','110165544'),
            T_TIPO_DATA('90317030','110166023'),
            T_TIPO_DATA('90314023','110155397'),
            T_TIPO_DATA('90316228','12154'),
            T_TIPO_DATA('90319158','110167977'),
            T_TIPO_DATA('90317067','662'),
            T_TIPO_DATA('90330954','110168296'),
            T_TIPO_DATA('90327542','110162714'),
            T_TIPO_DATA('90305717','5456'),
            T_TIPO_DATA('90333429','2112'),
            T_TIPO_DATA('90327810','2577'),
            T_TIPO_DATA('90316981','4067'),
            T_TIPO_DATA('90317812','12154'),
            T_TIPO_DATA('90329732','110159516'),
            T_TIPO_DATA('90325304','5745'),
            T_TIPO_DATA('90328037','2264'),
            T_TIPO_DATA('7013155','2321'),
            T_TIPO_DATA('7013163','2321'),
            T_TIPO_DATA('7012233','2321'),
            T_TIPO_DATA('7011865','2321')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia de la oferta
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            V_COUNT := 0;

            --Actualizamos el dato
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET           
            OFR_ID_PRES_ORI_LEAD = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(2)||'),
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE               
            WHERE OFR_NUM_OFERTA = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] OFERTA '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADA');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA OFERTA '''||V_TMP_TIPO_DATA(1)||'''');

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
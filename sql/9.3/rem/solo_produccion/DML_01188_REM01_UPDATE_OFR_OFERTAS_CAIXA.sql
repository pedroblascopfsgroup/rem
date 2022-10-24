--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220923
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12467
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-12467'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    V_OFR_CAIXA_ID NUMBER(16);
    V_DEP_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA(90414715,'10','DEV'),
                T_TIPO_DATA(90414925,'10','DEV'),
                T_TIPO_DATA(90415413,'10','DEV'),
                T_TIPO_DATA(90415880,'10','DEV'),
                T_TIPO_DATA(90415982,'10','DEV'),
                T_TIPO_DATA(90416974,'10','DEV'),
                T_TIPO_DATA(90417063,'10','DEV'),
                T_TIPO_DATA(90409365,'11','PDC'),
                T_TIPO_DATA(90409879,'11','PDC'),
                T_TIPO_DATA(90409970,'11','PDC'),
                T_TIPO_DATA(90410170,'11','PDC'),
                T_TIPO_DATA(90411125,'11','PDC'),
                T_TIPO_DATA(90411367,'11','PDC'),
                T_TIPO_DATA(90411407,'11','PDC'),
                T_TIPO_DATA(90413095,'11','PDC'),
                T_TIPO_DATA(90413756,'10','DEV'),
                T_TIPO_DATA(90414518,'11','PDC'),
                T_TIPO_DATA(90414543,'11','PDC'),
                T_TIPO_DATA(90414748,'10','DEV'),
                T_TIPO_DATA(90415950,'11','PDC'),
                T_TIPO_DATA(90415970,'10','DEV'),
                T_TIPO_DATA(90416419,'10','DEV'),
                T_TIPO_DATA(90416447,'11','PDC'),
                T_TIPO_DATA(90416473,'11','PDC'),
                T_TIPO_DATA(90416602,'11','PDC'),
                T_TIPO_DATA(90416605,'11','PDC'),
                T_TIPO_DATA(90416627,'11','PDC'),
                T_TIPO_DATA(90416782,'11','PDC'),
                T_TIPO_DATA(90417092,'11','PDC'),
                T_TIPO_DATA(90417207,'10','DEV'),
                T_TIPO_DATA(90417320,'11','PDC'),
                T_TIPO_DATA(90417418,'11','PDC'),
                T_TIPO_DATA(90417576,'10','DEV'),
                T_TIPO_DATA(90417589,'10','DEV'),
                T_TIPO_DATA(90417671,'11','PDC'),
                T_TIPO_DATA(90418569,'10','DEV'),
                T_TIPO_DATA(90418690,'10','DEV'),
                T_TIPO_DATA(90418717,'11','PDC')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = :1 AND BORRADO = 0' 
        INTO V_COUNT USING V_TMP_TIPO_DATA(1);	

        IF V_COUNT = 1 THEN

            V_OFR_CAIXA_ID := 0;
            V_DEP_ID := 0;

            EXECUTE IMMEDIATE 'SELECT OFR_CAIXA_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                        JOIN '||V_ESQUEMA||'.OFR_OFERTAS_CAIXA CBX ON CBX.OFR_ID = OFR.OFR_ID AND CBX.BORRADO = 0
                        WHERE OFR_NUM_OFERTA = :1 AND OFR.BORRADO = 0' 
            INTO V_OFR_CAIXA_ID USING V_TMP_TIPO_DATA(1);

            EXECUTE IMMEDIATE 'SELECT DEP_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                        JOIN '||V_ESQUEMA||'.DEP_DEPOSITO DEP ON DEP.OFR_ID = OFR.OFR_ID AND DEP.BORRADO = 0
                        WHERE OFR_NUM_OFERTA = :1 AND OFR.BORRADO = 0' 
            INTO V_DEP_ID USING V_TMP_TIPO_DATA(1);

            IF V_OFR_CAIXA_ID != 0 THEN

                EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS_CAIXA SET           
                DD_EOB_ID = (SELECT DD_EOB_ID FROM '||V_ESQUEMA||'.DD_EOB_ESTADO_OFERTA_BC WHERE DD_EOB_CODIGO = :1),   
                OFR_FECHA_MOD_EOB = TRUNC(SYSDATE),            
                USUARIOMODIFICAR = :2,
                FECHAMODIFICAR = SYSDATE               
                WHERE OFR_CAIXA_ID = :3'
                USING V_TMP_TIPO_DATA(2), V_USUARIO, V_OFR_CAIXA_ID;

                DBMS_OUTPUT.PUT_LINE('[INFO] OFERTA CAIXA '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADA');

            ELSE 

                DBMS_OUTPUT.PUT_LINE('[INFO] LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' NO TIENE OFERTA CAIXA');

            END IF;

            IF V_DEP_ID != 0 THEN

                EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DEP_DEPOSITO SET           
                DD_EDP_ID = (SELECT DD_EDP_ID FROM '||V_ESQUEMA||'.DD_EDP_EST_DEPOSITO WHERE DD_EDP_CODIGO = :1),   
                USUARIOMODIFICAR = :2,
                FECHAMODIFICAR = SYSDATE               
                WHERE DEP_ID = :3'
                USING V_TMP_TIPO_DATA(3), V_USUARIO, V_DEP_ID;

                DBMS_OUTPUT.PUT_LINE('[INFO] DEPOSITO OFERTA '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');

            ELSE 

                DBMS_OUTPUT.PUT_LINE('[INFO] LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' NO TIENE DEPOSITO');

            END IF;
            
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
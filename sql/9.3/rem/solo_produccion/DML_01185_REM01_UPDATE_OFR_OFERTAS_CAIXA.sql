--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220912
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12398
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-12398'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    V_OFR_CAIXA_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA(90408982,'10'),
                T_TIPO_DATA(90413800,'10'),
                T_TIPO_DATA(90412390,'10'),
                T_TIPO_DATA(90412533,'10'),
                T_TIPO_DATA(90410887,'10'),
                T_TIPO_DATA(90414644,'10'),
                T_TIPO_DATA(90411814,'10'),
                T_TIPO_DATA(90411174,'10'),
                T_TIPO_DATA(90413678,'10'),
                T_TIPO_DATA(90400364,'10'),
                T_TIPO_DATA(90412785,'10'),
                T_TIPO_DATA(90407935,'10'),
                T_TIPO_DATA(90412586,'11'),
                T_TIPO_DATA(90410478,'10'),
                T_TIPO_DATA(90412151,'11'),
                T_TIPO_DATA(90412646,'11'),
                T_TIPO_DATA(90412048,'11'),
                T_TIPO_DATA(90408129,'10'),
                T_TIPO_DATA(90395390,'10'),
                T_TIPO_DATA(90408683,'10'),
                T_TIPO_DATA(90388495,'10'),
                T_TIPO_DATA(90401778,'10'),
                T_TIPO_DATA(90406308,'10'),
                T_TIPO_DATA(90412866,'10'),
                T_TIPO_DATA(90403325,'10'),
                T_TIPO_DATA(90412793,'10'),
                T_TIPO_DATA(90398443,'10'),
                T_TIPO_DATA(90400921,'10'),
                T_TIPO_DATA(90413073,'10'),
                T_TIPO_DATA(90407785,'10'),
                T_TIPO_DATA(90411920,'10'),
                T_TIPO_DATA(90413030,'10'),
                T_TIPO_DATA(90399760,'10'),
                T_TIPO_DATA(90412990,'10'),
                T_TIPO_DATA(90412588,'10'),
                T_TIPO_DATA(90412330,'11'),
                T_TIPO_DATA(90405132,'10'),
                T_TIPO_DATA(90401275,'10'),
                T_TIPO_DATA(90412970,'11'),
                T_TIPO_DATA(90412418,'10'),
                T_TIPO_DATA(90398439,'10'),
                T_TIPO_DATA(90404549,'10'),
                T_TIPO_DATA(90404358,'10'),
                T_TIPO_DATA(90413756,'10'),
                T_TIPO_DATA(90411635,'11'),
                T_TIPO_DATA(90399142,'10'),
                T_TIPO_DATA(90399020,'10'),
                T_TIPO_DATA(90406466,'10'),
                T_TIPO_DATA(90408626,'10'),
                T_TIPO_DATA(90407016,'10'),
                T_TIPO_DATA(90412386,'11'),
                T_TIPO_DATA(90408849,'10'),
                T_TIPO_DATA(90412220,'10'),
                T_TIPO_DATA(90400019,'10'),
                T_TIPO_DATA(90402360,'10'),
                T_TIPO_DATA(90413226,'11'),
                T_TIPO_DATA(90412627,'10'),
                T_TIPO_DATA(90399810,'10'),
                T_TIPO_DATA(90372811,'10'),
                T_TIPO_DATA(90402110,'10'),
                T_TIPO_DATA(90404367,'10'),
                T_TIPO_DATA(90402472,'10'),
                T_TIPO_DATA(90403909,'10'),
                T_TIPO_DATA(90413024,'11'),
                T_TIPO_DATA(90406309,'10'),
                T_TIPO_DATA(90404119,'10'),
                T_TIPO_DATA(90407651,'10'),
                T_TIPO_DATA(90405367,'10'),
                T_TIPO_DATA(90411627,'10'),
                T_TIPO_DATA(90403821,'10'),
                T_TIPO_DATA(90401519,'10'),
                T_TIPO_DATA(90395488,'10'),
                T_TIPO_DATA(90404916,'10'),
                T_TIPO_DATA(90408136,'10'),
                T_TIPO_DATA(90411844,'11'),
                T_TIPO_DATA(90411665,'11'),
                T_TIPO_DATA(90404294,'10'),
                T_TIPO_DATA(90411885,'11'),
                T_TIPO_DATA(90416070,'11'),
                T_TIPO_DATA(90396259,'10'),
                T_TIPO_DATA(90408415,'10'),
                T_TIPO_DATA(90412600,'10'),
                T_TIPO_DATA(90412248,'10'),
                T_TIPO_DATA(90406468,'10'),
                T_TIPO_DATA(90392992,'10'),
                T_TIPO_DATA(90414022,'10'),
                T_TIPO_DATA(90412750,'11'),
                T_TIPO_DATA(90398269,'10'),
                T_TIPO_DATA(90412494,'10'),
                T_TIPO_DATA(90408112,'10'),
                T_TIPO_DATA(90406835,'10'),
                T_TIPO_DATA(90394747,'10'),
                T_TIPO_DATA(90395274,'10'),
                T_TIPO_DATA(90413198,'10'),
                T_TIPO_DATA(90412506,'10'),
                T_TIPO_DATA(90411918,'10'),
                T_TIPO_DATA(90415279,'11'),
                T_TIPO_DATA(90409079,'10'),
                T_TIPO_DATA(90402743,'10'),
                T_TIPO_DATA(90405234,'10'),
                T_TIPO_DATA(90401209,'10'),
                T_TIPO_DATA(90386180,'10'),
                T_TIPO_DATA(90411876,'10'),
                T_TIPO_DATA(90388854,'10'),
                T_TIPO_DATA(90407149,'10'),
                T_TIPO_DATA(90407550,'10'),
                T_TIPO_DATA(90411716,'11'),
                T_TIPO_DATA(90412182,'10'),
                T_TIPO_DATA(90395466,'10'),
                T_TIPO_DATA(90412803,'10'),
                T_TIPO_DATA(90412567,'10'),
                T_TIPO_DATA(90411895,'10'),
                T_TIPO_DATA(90413068,'10'),
                T_TIPO_DATA(90412052,'10'),
                T_TIPO_DATA(90404281,'10'),
                T_TIPO_DATA(90401844,'10'),
                T_TIPO_DATA(90412209,'11'),
                T_TIPO_DATA(90406647,'10'),
                T_TIPO_DATA(90394059,'10'),
                T_TIPO_DATA(90413004,'10'),
                T_TIPO_DATA(90411854,'10'),
                T_TIPO_DATA(90407309,'10'),
                T_TIPO_DATA(90412911,'11'),
                T_TIPO_DATA(90408032,'10'),
                T_TIPO_DATA(90412302,'10'),
                T_TIPO_DATA(90401236,'10'),
                T_TIPO_DATA(90399739,'10'),
                T_TIPO_DATA(90411012,'10'),
                T_TIPO_DATA(90413737,'10'),
                T_TIPO_DATA(90412709,'10'),
                T_TIPO_DATA(90407565,'10'),
                T_TIPO_DATA(90412067,'10'),
                T_TIPO_DATA(90412281,'11'),
                T_TIPO_DATA(90408349,'10'),
                T_TIPO_DATA(90399592,'10'),
                T_TIPO_DATA(90411668,'10'),
                T_TIPO_DATA(90416602,'11'),
                T_TIPO_DATA(90407238,'10'),
                T_TIPO_DATA(90412991,'10'),
                T_TIPO_DATA(90404070,'10'),
                T_TIPO_DATA(90412089,'10'),
                T_TIPO_DATA(90399198,'10'),
                T_TIPO_DATA(90406848,'10'),
                T_TIPO_DATA(90404800,'10'),
                T_TIPO_DATA(90412087,'11'),
                T_TIPO_DATA(90409956,'10'),
                T_TIPO_DATA(90405626,'10'),
                T_TIPO_DATA(90416627,'11'),
                T_TIPO_DATA(90412047,'10'),
                T_TIPO_DATA(90404596,'10'),
                T_TIPO_DATA(90401008,'10'),
                T_TIPO_DATA(90406878,'10'),
                T_TIPO_DATA(90404048,'10'),
                T_TIPO_DATA(90411878,'10'),
                T_TIPO_DATA(90406591,'10'),
                T_TIPO_DATA(90399654,'10'),
                T_TIPO_DATA(90405543,'10'),
                T_TIPO_DATA(90401837,'10'),
                T_TIPO_DATA(90401056,'10'),
                T_TIPO_DATA(90407549,'10'),
                T_TIPO_DATA(90406177,'10'),
                T_TIPO_DATA(90401645,'10'),
                T_TIPO_DATA(90415446,'10'),
                T_TIPO_DATA(90416447,'11'),
                T_TIPO_DATA(90413072,'10'),
                T_TIPO_DATA(90406256,'10'),
                T_TIPO_DATA(90408897,'10'),
                T_TIPO_DATA(90407203,'10'),
                T_TIPO_DATA(90412842,'11'),
                T_TIPO_DATA(90401405,'10'),
                T_TIPO_DATA(90406437,'10'),
                T_TIPO_DATA(90408314,'10'),
                T_TIPO_DATA(90405443,'10'),
                T_TIPO_DATA(90408450,'10'),
                T_TIPO_DATA(90411606,'11'),
                T_TIPO_DATA(90411420,'10'),
                T_TIPO_DATA(90397319,'10'),
                T_TIPO_DATA(90409706,'10'),
                T_TIPO_DATA(90411779,'10'),
                T_TIPO_DATA(90403676,'10'),
                T_TIPO_DATA(90376922,'10'),
                T_TIPO_DATA(90412565,'11'),
                T_TIPO_DATA(90415742,'10'),
                T_TIPO_DATA(90396620,'10'),
                T_TIPO_DATA(90406823,'10'),
                T_TIPO_DATA(90412032,'10'),
                T_TIPO_DATA(90411998,'10'),
                T_TIPO_DATA(90411719,'11'),
                T_TIPO_DATA(90408628,'10'),
                T_TIPO_DATA(90397633,'10'),
                T_TIPO_DATA(90400616,'10'),
                T_TIPO_DATA(90415950,'11'),
                T_TIPO_DATA(90406793,'10'),
                T_TIPO_DATA(90406050,'10'),
                T_TIPO_DATA(90412654,'10'),
                T_TIPO_DATA(90412576,'10'),
                T_TIPO_DATA(90399204,'10'),
                T_TIPO_DATA(90403249,'10'),
                T_TIPO_DATA(90405945,'10'),
                T_TIPO_DATA(90401042,'10'),
                T_TIPO_DATA(90407123,'10'),
                T_TIPO_DATA(90409364,'11'),
                T_TIPO_DATA(90404884,'10'),
                T_TIPO_DATA(90407730,'10'),
                T_TIPO_DATA(90406155,'10'),
                T_TIPO_DATA(90401983,'10'),
                T_TIPO_DATA(90405956,'10'),
                T_TIPO_DATA(90416473,'11'),
                T_TIPO_DATA(90405015,'10'),
                T_TIPO_DATA(90412444,'11'),
                T_TIPO_DATA(90399323,'10'),
                T_TIPO_DATA(90414203,'10'),
                T_TIPO_DATA(90398786,'10'),
                T_TIPO_DATA(90408133,'10'),
                T_TIPO_DATA(90414543,'11'),
                T_TIPO_DATA(90412365,'10'),
                T_TIPO_DATA(90412424,'10'),
                T_TIPO_DATA(90405936,'10'),
                T_TIPO_DATA(90412250,'11'),
                T_TIPO_DATA(90412156,'10'),
                T_TIPO_DATA(90411691,'10'),
                T_TIPO_DATA(90405350,'10'),
                T_TIPO_DATA(90407580,'10'),
                T_TIPO_DATA(90402258,'10'),
                T_TIPO_DATA(90408581,'10'),
                T_TIPO_DATA(90407635,'10'),
                T_TIPO_DATA(90412180,'10'),
                T_TIPO_DATA(90403827,'10'),
                T_TIPO_DATA(90412046,'10'),
                T_TIPO_DATA(90405908,'10'),
                T_TIPO_DATA(90389921,'10'),
                T_TIPO_DATA(90412894,'10'),
                T_TIPO_DATA(90400648,'10'),
                T_TIPO_DATA(90399863,'10'),
                T_TIPO_DATA(90383979,'10'),
                T_TIPO_DATA(90398190,'10'),
                T_TIPO_DATA(90408400,'10'),
                T_TIPO_DATA(90401386,'10'),
                T_TIPO_DATA(90407017,'10'),
                T_TIPO_DATA(90407402,'10'),
                T_TIPO_DATA(90378415,'10'),
                T_TIPO_DATA(90411000,'10'),
                T_TIPO_DATA(90396764,'10'),
                T_TIPO_DATA(90411602,'10'),
                T_TIPO_DATA(90407168,'10'),
                T_TIPO_DATA(90413059,'10'),
                T_TIPO_DATA(90409296,'10'),
                T_TIPO_DATA(90398449,'10'),
                T_TIPO_DATA(90413835,'10'),
                T_TIPO_DATA(90407742,'10'),
                T_TIPO_DATA(90375500,'10'),
                T_TIPO_DATA(90412189,'10'),
                T_TIPO_DATA(90413052,'10'),
                T_TIPO_DATA(90412892,'10'),
                T_TIPO_DATA(90402787,'10'),
                T_TIPO_DATA(90408251,'10'),
                T_TIPO_DATA(90411694,'10'),
                T_TIPO_DATA(90408741,'10'),
                T_TIPO_DATA(90411750,'10'),
                T_TIPO_DATA(90408906,'10'),
                T_TIPO_DATA(90401672,'10'),
                T_TIPO_DATA(90411823,'11'),
                T_TIPO_DATA(90411914,'11'),
                T_TIPO_DATA(90412708,'10'),
                T_TIPO_DATA(90411951,'10'),
                T_TIPO_DATA(90406831,'10'),
                T_TIPO_DATA(90411474,'10'),
                T_TIPO_DATA(90409824,'10'),
                T_TIPO_DATA(90412387,'10'),
                T_TIPO_DATA(90406036,'10'),
                T_TIPO_DATA(90408079,'10'),
                T_TIPO_DATA(90406869,'10')
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

            EXECUTE IMMEDIATE 'SELECT OFR_CAIXA_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                        JOIN '||V_ESQUEMA||'.OFR_OFERTAS_CAIXA CBX ON CBX.OFR_ID = OFR.OFR_ID AND CBX.BORRADO = 0
                        WHERE OFR_NUM_OFERTA = :1 AND OFR.BORRADO = 0' 
            INTO V_OFR_CAIXA_ID USING V_TMP_TIPO_DATA(1);

            IF V_OFR_CAIXA_ID != 0 THEN

                EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS_CAIXA SET           
                DD_EOB_ID = (SELECT DD_EOB_ID FROM '||V_ESQUEMA||'.DD_EOB_ESTADO_OFERTA_BC WHERE DD_EOB_CODIGO = :1),   
                OFR_FECHA_MOD_EOB = TRUNC(SYSDATE),            
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE               
                WHERE OFR_CAIXA_ID = :2'
                USING V_TMP_TIPO_DATA(2), V_OFR_CAIXA_ID;

                DBMS_OUTPUT.PUT_LINE('[INFO] OFERTA CAIXA '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADA');

            ELSE 

                DBMS_OUTPUT.PUT_LINE('[INFO] LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' NO TIENE OFERTA CAIXA');

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
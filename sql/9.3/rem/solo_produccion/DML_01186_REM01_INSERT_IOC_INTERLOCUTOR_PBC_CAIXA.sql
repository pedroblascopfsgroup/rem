--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220912
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12119
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-12119'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'IOC_INTERLOCUTOR_PBC_CAIXA';
	V_COUNT NUMBER(16);
    V_IAP_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('MARIO GERMAN','CALDAS ELEJALDE','12','X9868580Q','625505135','trukini2006@gmail.com','CL COSTA Y BORRAS Nº1 1º-2','46017','46','46250','','2371216','2371220'),
            T_TIPO_DATA('MYCOLA','KITSNAK','04','2716708735','','nikouk2---@gmail.com;emoreno8a@gmail.com','CL QUEJIGO DEL HORNILLO - RESIDENCIAL QUINTASOL Nº1 ESC 2 BJ 8','29649','29','29070','01','2021544','2016577'),
            T_TIPO_DATA('MIGUEL','ALVAREZ FLORES','15','01843265E','','vivaalu03@gmail.com','CL CAMINO DE ARCAS','19171','19','19058','01','2175838','2175836'),
            T_TIPO_DATA('SAVETA','GHERHEF','14','SB624610','','','CL GRAN VIA DE LES CORTS CATALANES Nº 323 3-2','08014','8','08019','01','2025215','2015419'),
            T_TIPO_DATA('VASILE','SAVA','04','XT207787','','','CL PAIS VALENCIA Nº 10 B 2º-2','43580','43','43901','','2026608','2017307'),
            T_TIPO_DATA('LUCKY','EDUWU','15','46185222A','632929287','luckfos@yahoo.com','CL ISAAC PERAL Nº20 4º-12','46024','46','46250','01','2176867','2176869'),
            T_TIPO_DATA('BYRON MARTIN','ROSADO MARQUEZ','15','49492828W','604165363','','CL TRANSVERSAL Nº26 1º-1','08902','8','08101','','2371217','2371226'),
            T_TIPO_DATA('UESA','MENDES','15','55442584A','','uesmendes@gmail.com','CL PRADO Nº3 3º-K','28820','28','28049','01','2140166','2140161'),
            T_TIPO_DATA('EMETERIO','OLIVERA MEJIA','15','55596766Q','605015263','weteolivera2@hotmail.com','CL PEDRO ALVARADO Nº4 4º-A','28917','28','28074','01','2371218','2371228'),
            T_TIPO_DATA('JULA','CAMARA','12','X2285909P','634086500','julacamara225@gmail.com','RD CERDANYA Nº12 5º-1','08303','8','08121','01','2140167','2140162'),
            T_TIPO_DATA('CARLITOS','CHICO NANCASSA','12','X6523887Y','626598592','','PZ CHONA MADERA Nº10 1º-D','35011','35','35016','','2371219','2371229'),
            T_TIPO_DATA('VALENTIN','MARRERO','12','X7803998M','','','CL MIMOSA Nº8 ESC.1 2º-3','07008','7','07040','','2026506','2020162')
        ); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_IAP_ID := 0;

        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE IOC_DOC_IDENTIFICATIVO = :1 AND BORRADO = 0' 
        INTO V_COUNT USING V_TMP_TIPO_DATA(4);	

        IF V_COUNT = 1 THEN

            EXECUTE IMMEDIATE 'SELECT NVL(IAP_ID,0) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE IOC_DOC_IDENTIFICATIVO = :1 AND BORRADO = 0' 
            INTO V_IAP_ID USING V_TMP_TIPO_DATA(4);

            DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE DOCUMENTO '''||V_TMP_TIPO_DATA(4)||''' . ACTUALIZAMOS');

            EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
                        IOC_ID_PERSONA_HAYA_CAIXA = :1,
                        DD_TDI_ID = (SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = :2 AND BORRADO = 0),
                        IOC_NOMBRE = :3,
                        IOC_APELLIDOS = :4,
                        IOC_PERSONA_FISICA = 1,
                        IOC_DIRECCION = :5,
                        IOC_CODIGO_POSTAL = :6,
                        DD_LOC_ID = (SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = :7 AND BORRADO = 0),
                        DD_PRV_ID = (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = :8 AND BORRADO = 0),
                        IOC_TELEFONO1 = :9,
                        IOC_EMAIL = :10,
                        DD_ECV_ID = :11,
                        USUARIOMODIFICAR = :12,
                        FECHAMODIFICAR = SYSDATE
                        WHERE IOC_DOC_IDENTIFICATIVO = :13 AND BORRADO = 0' 
            USING V_TMP_TIPO_DATA(12),V_TMP_TIPO_DATA(3),V_TMP_TIPO_DATA(1),V_TMP_TIPO_DATA(2),
                    V_TMP_TIPO_DATA(7),V_TMP_TIPO_DATA(8),V_TMP_TIPO_DATA(10),V_TMP_TIPO_DATA(9),
                    V_TMP_TIPO_DATA(5),V_TMP_TIPO_DATA(6),V_TMP_TIPO_DATA(11),V_USUARIO,V_TMP_TIPO_DATA(4);

            IF V_IAP_ID != 0 THEN

                EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.IAP_INFO_ADC_PERSONA SET                     
                        ID_PERSONA_HAYA = :1,
                        DD_ECC_ID = 1,
                        IAP_ID_PERSONA_HAYA_CAIXA = :3,   
                        USUARIOMODIFICAR = :4,
                        FECHAMODIFICAR = SYSDATE          
                        WHERE IAP_ID = :2 AND BORRADO = 0'
                USING V_TMP_TIPO_DATA(13),V_TMP_TIPO_DATA(12),V_USUARIO,V_IAP_ID;

                DBMS_OUTPUT.PUT_LINE('[INFO] DOCUMENTO '''||V_TMP_TIPO_DATA(4)||''' ACTUALIZADO');

            ELSE 

                EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_IAP_INFO_ADC_PERSONA.NEXTVAL FROM DUAL' 
                INTO V_IAP_ID;

                DBMS_OUTPUT.PUT_LINE('[INFO] DOCUMENTO '''||V_TMP_TIPO_DATA(4)||''' NO TIENE IAP. GENERAMOS');

                EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.IAP_INFO_ADC_PERSONA 
                        (IAP_ID,ID_PERSONA_HAYA,DD_ECC_ID,USUARIOCREAR,FECHACREAR,IAP_ID_PERSONA_HAYA_CAIXA)    
                        VALUES 
                        (:1,:2,1,:3,SYSDATE,:4)'
                USING V_IAP_ID,V_TMP_TIPO_DATA(13),V_USUARIO,V_TMP_TIPO_DATA(12);

                EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
                        IAP_ID = :1 WHERE IOC_DOC_IDENTIFICATIVO = :2 AND BORRADO = 0' 
                USING V_IAP_ID,V_TMP_TIPO_DATA(4);

            END IF;
            
        ELSE 

            EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_IAP_INFO_ADC_PERSONA.NEXTVAL FROM DUAL' 
            INTO V_IAP_ID;

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE DOCUMENTO '''||V_TMP_TIPO_DATA(4)||''' . INSERTAMOS');
            DBMS_OUTPUT.PUT_LINE('[INFO] GENERAMOS IAP');

            EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.IAP_INFO_ADC_PERSONA 
                    (IAP_ID,ID_PERSONA_HAYA,DD_TRI_ID,DD_ECC_ID,USUARIOCREAR,FECHACREAR,IAP_ID_PERSONA_HAYA_CAIXA)    
                    VALUES 
                    (:1,:2,1,1,:3,SYSDATE,:4)'
            USING V_IAP_ID,V_TMP_TIPO_DATA(13),V_USUARIO,V_TMP_TIPO_DATA(12);

            EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                        (IOC_ID,IOC_ID_PERSONA_HAYA_CAIXA,IAP_ID,DD_TDI_ID,IOC_NOMBRE,IOC_APELLIDOS,IOC_PERSONA_FISICA,
                        DD_ECV_ID,IOC_DIRECCION,IOC_CODIGO_POSTAL,DD_LOC_ID,DD_PRV_ID,IOC_TELEFONO1,IOC_EMAIL,USUARIOCREAR,
                        FECHACREAR,IOC_DOC_IDENTIFICATIVO)
                        VALUES
                        (
                            '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                            :1,:2,(SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = :3 AND BORRADO = 0),
                            :4,:5,1,:6,:7,:8,(SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = :9 AND BORRADO = 0),
                            (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = :10 AND BORRADO = 0),
                            :11,:12,:13,SYSDATE,:15
                        )' 
            USING V_TMP_TIPO_DATA(12),V_IAP_ID,V_TMP_TIPO_DATA(3),V_TMP_TIPO_DATA(1),V_TMP_TIPO_DATA(2),
                    V_TMP_TIPO_DATA(11),V_TMP_TIPO_DATA(7),V_TMP_TIPO_DATA(8),V_TMP_TIPO_DATA(10),V_TMP_TIPO_DATA(9),
                    V_TMP_TIPO_DATA(5),V_TMP_TIPO_DATA(6),V_USUARIO,V_TMP_TIPO_DATA(4);

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
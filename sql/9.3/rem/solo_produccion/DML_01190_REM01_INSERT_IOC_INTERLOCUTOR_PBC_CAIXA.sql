--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20221011
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12507
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-12507'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'IOC_INTERLOCUTOR_PBC_CAIXA';
	V_COUNT NUMBER(16);
    V_IAP_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('DOLORES','JIMENO RISUEÑO','15','48297361Y','633327876','lolijimenorisueno@gmail.com','CL ANTON Y MANUEL MARTINEZ Nº 2 2-B','30012','30','30030','01','2389654',1,'','','',''),
            T_TIPO_DATA('ERICA','ALCAIDE BEN-HAMIDI','15','47112151D','622150625','erica19882@msn.com','PZ DE CATALUÑA Nº 1 PB','08830','8','08200','01','2341088',1,'','','',''),
            T_TIPO_DATA('RUBEN','GOMEZ RAMIREZ','15','47608233G','660167829','Rubengomezramirez1984@gmail.com','PZ DE CATALUÑA Nº 1 PB','08830','8','08200','01','2389655',1,'','','',''),
            T_TIPO_DATA('MOHAMED','MASOUDI HANAFI','15','55158066H','620569804','mohamedmasoudihanafi@gmail.com','CL FONT Nº 55 ESC. 1 BJ-1','08905','8','08101','01','2339829',1,'','','',''),
            T_TIPO_DATA('MIGUEL','RECATALA MULET','15','52941560E','618052653','administracion@tecmavi.com','CR CV-20 POLIGONO 3 Nº 3 PTA.51','','12','12135','01','2198739',1,'','','',''),
            T_TIPO_DATA('GIATSA','GESTIO INTEGRAL D''''ASSESSORAMENT I TRAMITACIO DE SERVEIS SA','02','A60805660','','','CL RAMBLA NUESTRA SEÑORA 2-4 Nº 4 1-1','08720','8','08305','','2389656',0,'','','',''),
            T_TIPO_DATA('ANA','RODRIGUEZ BELSUE','15','46822977Z','693712819','anitabelsue@gmail.com','CL CACERES Nº16 1-1','08191','8','08184','01','2389657',1,'','','',''),
            T_TIPO_DATA('VICTOR FRANCISCO','MARCOS PEREZ','15','43766776F','','','CL PEDRO INFINITO Nº19','35012','35','35016','01','2062933',1,'','','',''),
            T_TIPO_DATA('EPIFANIO','MOLINA HERNANDEZ','15','36541454C','649816663','karinagera031176@gmail.com','CL POMPEU FABRA Nº 7','08348','8','08030','01','2062576',1,'','','',''),
            T_TIPO_DATA('KARINA','GERASIMOVA','12','X4056716E','649816663','','CL POMPEU FABRA Nº 7','08348','8','08030','01','2064437',1,'','','',''),
            T_TIPO_DATA('LAURA','REY SALAS','15','45787388T','645355759','laurarey84@gmail.com','CL IGUALADA Nº48 BJ-1','08720','8','08305','01','2389658',1,'','','',''),
            T_TIPO_DATA('ESTHER MARIA','LOPEZ PUJOL','15','27433188F','602317124','','TIRSO DE MOLINA Nº17 ESC. E 2-G','30500','30','30027','01','2021563',1,'','','',''),
            T_TIPO_DATA('DSOKO','NEPTUNO, S.L.','02','B19704055','','dsokogranada.admon@gmail.com','CL NEPTUNO Nº10','18005','18','18087','','2389659',0,'','','',''),
            T_TIPO_DATA('SERGIO','GUTIERREZ DE LA FUENTE','12','28835210H','601306829','','CL CARMEN DIAZ Nº4 ESC.15 3-D','41009','41','41091','01','2297243',1,'','','','')
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
                        IOC_PERSONA_FISICA = :5,
                        IOC_DIRECCION = :6,
                        IOC_CODIGO_POSTAL = :7,
                        DD_LOC_ID = (SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = :8 AND BORRADO = 0),
                        DD_PRV_ID = (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = :9 AND BORRADO = 0),
                        IOC_TELEFONO1 = :10,
                        IOC_EMAIL = :11,
                        DD_ECV_ID = :12,
                        DD_PAI_ID = 28,
                        DD_PAI_NAC_ID = :13,
                        DD_LOC_NAC_ID = :14,
                        IAP_FECHA_NACIMIENTO = :15,
                        DD_PRV_NAC_ID = :16,
                        USUARIOMODIFICAR = :17,
                        FECHAMODIFICAR = SYSDATE
                        WHERE IOC_DOC_IDENTIFICATIVO = :18 AND BORRADO = 0' 
            USING V_TMP_TIPO_DATA(12),V_TMP_TIPO_DATA(3),V_TMP_TIPO_DATA(1),V_TMP_TIPO_DATA(2),V_TMP_TIPO_DATA(13),
                    V_TMP_TIPO_DATA(7),V_TMP_TIPO_DATA(8),V_TMP_TIPO_DATA(10),V_TMP_TIPO_DATA(9),
                    V_TMP_TIPO_DATA(5),V_TMP_TIPO_DATA(6),V_TMP_TIPO_DATA(11),V_TMP_TIPO_DATA(14),V_TMP_TIPO_DATA(15),
                    V_TMP_TIPO_DATA(16),V_TMP_TIPO_DATA(17),V_USUARIO,V_TMP_TIPO_DATA(4);

            IF V_IAP_ID != 0 THEN

                EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.IAP_INFO_ADC_PERSONA SET                     
                        DD_ECC_ID = 1,
                        IAP_ID_PERSONA_HAYA_CAIXA = :1,   
                        USUARIOMODIFICAR = :2,
                        FECHAMODIFICAR = SYSDATE          
                        WHERE IAP_ID = :3 AND BORRADO = 0'
                USING V_TMP_TIPO_DATA(12),V_USUARIO,V_IAP_ID;

                DBMS_OUTPUT.PUT_LINE('[INFO] DOCUMENTO '''||V_TMP_TIPO_DATA(4)||''' ACTUALIZADO');

            ELSE 

                EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_IAP_INFO_ADC_PERSONA.NEXTVAL FROM DUAL' 
                INTO V_IAP_ID;

                DBMS_OUTPUT.PUT_LINE('[INFO] DOCUMENTO '''||V_TMP_TIPO_DATA(4)||''' NO TIENE IAP. GENERAMOS');

                EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.IAP_INFO_ADC_PERSONA 
                        (IAP_ID,DD_ECC_ID,USUARIOCREAR,FECHACREAR,IAP_ID_PERSONA_HAYA_CAIXA)    
                        VALUES 
                        (:1,1,:2,SYSDATE,:3)'
                USING V_IAP_ID,V_USUARIO,V_TMP_TIPO_DATA(12);

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
                    (IAP_ID,DD_TRI_ID,DD_ECC_ID,USUARIOCREAR,FECHACREAR,IAP_ID_PERSONA_HAYA_CAIXA)    
                    VALUES 
                    (:1,1,1,:2,SYSDATE,:3)'
            USING V_IAP_ID,V_USUARIO,V_TMP_TIPO_DATA(12);

            EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                        (IOC_ID,IOC_ID_PERSONA_HAYA_CAIXA,IAP_ID,DD_TDI_ID,IOC_NOMBRE,IOC_APELLIDOS,IOC_PERSONA_FISICA,
                        DD_ECV_ID,IOC_DIRECCION,IOC_CODIGO_POSTAL,DD_LOC_ID,DD_PRV_ID,IOC_TELEFONO1,IOC_EMAIL,USUARIOCREAR,
                        FECHACREAR,IOC_DOC_IDENTIFICATIVO,DD_PAI_ID,DD_PAI_NAC_ID,DD_LOC_NAC_ID,IAP_FECHA_NACIMIENTO,DD_PRV_NAC_ID)
                        VALUES
                        (
                            '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                            :1,:2,(SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = :3 AND BORRADO = 0),
                            :4,:5,:6,:7,:8,:9,(SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = :10 AND BORRADO = 0),
                            (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = :11 AND BORRADO = 0),
                            :12,:13,:14,SYSDATE,:15,28,:16,:17,:18,:19
                        )' 
            USING V_TMP_TIPO_DATA(12),V_IAP_ID,V_TMP_TIPO_DATA(3),V_TMP_TIPO_DATA(1),V_TMP_TIPO_DATA(2),V_TMP_TIPO_DATA(13),
                    V_TMP_TIPO_DATA(11),V_TMP_TIPO_DATA(7),V_TMP_TIPO_DATA(8),V_TMP_TIPO_DATA(10),V_TMP_TIPO_DATA(9),
                    V_TMP_TIPO_DATA(5),V_TMP_TIPO_DATA(6),V_USUARIO,V_TMP_TIPO_DATA(4),V_TMP_TIPO_DATA(14),V_TMP_TIPO_DATA(15),
                    V_TMP_TIPO_DATA(16),V_TMP_TIPO_DATA(17);

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
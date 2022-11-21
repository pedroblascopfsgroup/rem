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
    	                --1.NOMBRE	2.APELLIDOS	3.TIPO DOC	4.DOCUMENTO	5.TELEFONO	6.EMAIL	7.DIRECCION	8.COD POSTAL	9.PRV	10.LOC	11.ECV 12.IOC_ID_PERSONA_HAYA_CAIXA 13.FISICA
            T_TIPO_DATA('BOUBACAR DJIGUE','BARRY BARRY','15','03480977L','','oury2008@gmail.com','Calle Alfaro Nº 23 Piso 2 Puerta B','28025','28','28079','01','2020535',1),
            T_TIPO_DATA('KADIATOU SAIKOU','DIALLO','15','Y0671205X','','','Calle Alfaro Nº 23 Piso 2 Puerta B','28025','28','28079','01','2026637',1),
            T_TIPO_DATA('PALWINDER','SINGH','15','03529640Z','692686143','palwindermahal@hotmail.com','Calle José Belda Nº 5 Piso 3 Puerta 8','46950','46','46110','01','2422169',1),
            T_TIPO_DATA('MARIA','TORIELLO','15','X3038379X','','mariatoriello69@outlook.com','Calle Maestro Falla Nº 7 Piso 2 Puerta 4','12170','12','12040','01','2422170',1),
            T_TIPO_DATA('MARIA','FLORES JEREZ','15','22961524A','609625770','JESUSN.GALINDO@HOTMAIL.COM ','AV DE LA LIBERTAD 51','30710','30','30902','01','2413116',1),
            T_TIPO_DATA('LEI','ZENG','15','X4413389B','','','Calle ROSA RIBAS I PARELLADA Nº 60 Planta Baja Puerta 1','08820','8','08169','01','2374113',1),
            T_TIPO_DATA('YUAN','ZHANG','15','X6935648Y','','','Calle ROSA RIBAS I PARELLADA Nº 60 Planta Baja Puerta 1','08820','8','08169','01','2422172',1),
            T_TIPO_DATA('GRZEGORZ','JOZEF TOMASZEWSKI','15','X3891098G','','olgatom12@gmail.com','Calle Saxofon Nº 2 Escalera 1 Piso 1 Puerta A3','29014','29','29067','01','2422173',1)
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
                        USUARIOMODIFICAR = :13,
                        FECHAMODIFICAR = SYSDATE
                        WHERE IOC_DOC_IDENTIFICATIVO = :14 AND BORRADO = 0'
            USING V_TMP_TIPO_DATA(12),V_TMP_TIPO_DATA(3),V_TMP_TIPO_DATA(1),V_TMP_TIPO_DATA(2),V_TMP_TIPO_DATA(13),
                    V_TMP_TIPO_DATA(7),V_TMP_TIPO_DATA(8),V_TMP_TIPO_DATA(10),V_TMP_TIPO_DATA(9),
                    V_TMP_TIPO_DATA(5),V_TMP_TIPO_DATA(6),V_TMP_TIPO_DATA(11),V_USUARIO,V_TMP_TIPO_DATA(4);

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
                        FECHACREAR,IOC_DOC_IDENTIFICATIVO,DD_PAI_ID)
                        VALUES
                        (
                            '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
                            :1,:2,(SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = :3 AND BORRADO = 0),
                            :4,:5,:6,:7,:8,:9,(SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = :10 AND BORRADO = 0),
                            (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = :11 AND BORRADO = 0),
                            :12,:13,:14,SYSDATE,:15,28
                        )' 
            USING V_TMP_TIPO_DATA(12),V_IAP_ID,V_TMP_TIPO_DATA(3),V_TMP_TIPO_DATA(1),V_TMP_TIPO_DATA(2),V_TMP_TIPO_DATA(13),
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
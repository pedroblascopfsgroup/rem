--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20210608
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9921
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-9921'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
              T_TIPO_DATA('62845','1','4','1'),
 T_TIPO_DATA('63314','1','4','5'),
 T_TIPO_DATA('64033','1','4','1'),
 T_TIPO_DATA('64158','1','2','1'),
 T_TIPO_DATA('65168','1','1','42'),
 T_TIPO_DATA('65311','1','4','NULL'),
 T_TIPO_DATA('65397','1','1','42'),
 T_TIPO_DATA('65466','1','4','1'),
 T_TIPO_DATA('65586','1','1','42'),
 T_TIPO_DATA('65678','1','3','1'),
 T_TIPO_DATA('65744','1','4','NULL'),
 T_TIPO_DATA('65852','1','1','1'),
 T_TIPO_DATA('65859','1','3','1'),
 T_TIPO_DATA('65923','1','3','41'),
 T_TIPO_DATA('65934','1','1','42'),
 T_TIPO_DATA('65935','1','1','42'),
 T_TIPO_DATA('65940','1','3','1'),
 T_TIPO_DATA('66078','1','1','42'),
 T_TIPO_DATA('66129','1','3','1'),
 T_TIPO_DATA('66699','1','3','1'),
 T_TIPO_DATA('67072','1','3','1'),
 T_TIPO_DATA('67078','2','5','1'),
 T_TIPO_DATA('67349','1','3','1'),
 T_TIPO_DATA('67805','1','1','42'),
 T_TIPO_DATA('68878','1','1','42'),
 T_TIPO_DATA('69015','1','3','1'),
 T_TIPO_DATA('69016','1','3','1'),
 T_TIPO_DATA('69118','1','1','42'),
 T_TIPO_DATA('69127','1','3','1'),
 T_TIPO_DATA('69183','1','3','1'),
 T_TIPO_DATA('69819','1','3','1'),
 T_TIPO_DATA('70171','1','4','1'),
 T_TIPO_DATA('70317','1','3','5'),
 T_TIPO_DATA('70344','1','3','1'),
 T_TIPO_DATA('70455','1','3','1'),
 T_TIPO_DATA('70681','1','3','1'),
 T_TIPO_DATA('70715','2','5','1'),
 T_TIPO_DATA('71112','1','1','42'),
 T_TIPO_DATA('71343','1','3','1'),
 T_TIPO_DATA('71392','1','3','5'),
 T_TIPO_DATA('71572','1','4','1'),
 T_TIPO_DATA('71618','1','1','42'),
 T_TIPO_DATA('71619','1','1','42'),
 T_TIPO_DATA('71623','1','3','1'),
 T_TIPO_DATA('71711','1','4','NULL'),
 T_TIPO_DATA('72930','1','1','42'),
 T_TIPO_DATA('72960','1','1','42'),
 T_TIPO_DATA('73056','1','1','42'),
 T_TIPO_DATA('73112','1','1','42'),
 T_TIPO_DATA('73119','1','3','1'),
 T_TIPO_DATA('73202','1','1','42'),
 T_TIPO_DATA('73203','1','1','42'),
 T_TIPO_DATA('73297','1','1','42'),
 T_TIPO_DATA('73301','1','3','1'),
 T_TIPO_DATA('73436','1','4','NULL'),
 T_TIPO_DATA('73490','1','1','42'),
 T_TIPO_DATA('73491','1','1','1'),
 T_TIPO_DATA('74531','1','4','NULL'),
 T_TIPO_DATA('74856','1','1','42'),
 T_TIPO_DATA('75227','1','1','42'),
 T_TIPO_DATA('75657','1','3','1'),
 T_TIPO_DATA('77530','1','1','42'),
 T_TIPO_DATA('105470','1','4','NULL'),
 T_TIPO_DATA('131919','1','1','42'),
 T_TIPO_DATA('131920','1','3','1'),
 T_TIPO_DATA('134148','1','3','1'),
 T_TIPO_DATA('134149','1','3','1'),
 T_TIPO_DATA('134152','1','3','5'),
 T_TIPO_DATA('134379','1','3','1'),
 T_TIPO_DATA('134380','1','3','5'),
 T_TIPO_DATA('134808','1','3','1'),
 T_TIPO_DATA('134809','1','3','1'),
 T_TIPO_DATA('134810','1','3','5'),
 T_TIPO_DATA('135561','2','8','NULL'),
 T_TIPO_DATA('135770','1','3','1'),
 T_TIPO_DATA('136091','1','1','NULL'),
 T_TIPO_DATA('137609','1','3','NULL'),
 T_TIPO_DATA('139077','1','4','1'),
 T_TIPO_DATA('139523','1','3','3'),
 T_TIPO_DATA('140642','1','3','1'),
 T_TIPO_DATA('141010','1','3','1'),
 T_TIPO_DATA('141054','1','3','1'),
 T_TIPO_DATA('141399','1','3','1'),
 T_TIPO_DATA('141536','1','4','1'),
 T_TIPO_DATA('141642','1','1','42'),
 T_TIPO_DATA('141719','1','2','NULL'),
 T_TIPO_DATA('142772','1','3','1'),
 T_TIPO_DATA('143204','1','4','NULL'),
 T_TIPO_DATA('143314','1','3','1'),
 T_TIPO_DATA('143492','1','3','3'),
 T_TIPO_DATA('145955','1','3','3'),
 T_TIPO_DATA('146318','1','3','1'),
 T_TIPO_DATA('146319','1','3','5'),
 T_TIPO_DATA('146629','1','3','1'),
 T_TIPO_DATA('146634','1','4','1'),
 T_TIPO_DATA('146637','1','4','NULL'),
 T_TIPO_DATA('147445','6','23','1'),
 T_TIPO_DATA('148021','1','4','NULL'),
 T_TIPO_DATA('148064','1','4','1'),
 T_TIPO_DATA('148177','1','1','NULL'),
 T_TIPO_DATA('148537','1','3','1'),
 T_TIPO_DATA('148756','1','1','42'),
 T_TIPO_DATA('148958','1','3','1'),
 T_TIPO_DATA('149454','1','3','1'),
 T_TIPO_DATA('149548','1','3','1'),
 T_TIPO_DATA('149632','1','2','42'),
 T_TIPO_DATA('149639','1','3','1'),
 T_TIPO_DATA('149640','1','3','1'),
 T_TIPO_DATA('149715','1','3','3'),
 T_TIPO_DATA('149852','1','4','NULL'),
 T_TIPO_DATA('150055','1','3','5'),
 T_TIPO_DATA('150211','1','1','NULL'),
 T_TIPO_DATA('151136','1','1','NULL'),
 T_TIPO_DATA('151328','1','3','1'),
 T_TIPO_DATA('151349','1','1','42'),
 T_TIPO_DATA('151523','1','3','1'),
 T_TIPO_DATA('151876','1','4','1'),
 T_TIPO_DATA('153455','1','3','3'),
 T_TIPO_DATA('154017','1','3','1'),
 T_TIPO_DATA('154319','1','4','NULL'),
 T_TIPO_DATA('154782','1','3','1'),
 T_TIPO_DATA('155183','1','3','1'),
 T_TIPO_DATA('155276','1','3','3'),
 T_TIPO_DATA('156666','1','4','1'),
 T_TIPO_DATA('158312','1','3','1'),
 T_TIPO_DATA('158313','1','3','1'),
 T_TIPO_DATA('158480','1','3','1'),
 T_TIPO_DATA('158481','1','4','1'),
 T_TIPO_DATA('158509','1','3','1'),
 T_TIPO_DATA('158667','1','3','3'),
 T_TIPO_DATA('158922','1','3','1'),
 T_TIPO_DATA('158924','1','3','1'),
 T_TIPO_DATA('159377','1','4','1'),
 T_TIPO_DATA('161001','1','3','3'),
 T_TIPO_DATA('161098','1','2','1'),
 T_TIPO_DATA('161110','1','4','1'),
 T_TIPO_DATA('162040','1','1','42'),
 T_TIPO_DATA('162311','1','3','1'),
 T_TIPO_DATA('162480','1','3','3'),
 T_TIPO_DATA('163212','1','3','3'),
 T_TIPO_DATA('163396','1','4','1'),
 T_TIPO_DATA('163449','1','1','42'),
 T_TIPO_DATA('163876','1','1','42'),
 T_TIPO_DATA('163885','1','1','42'),
 T_TIPO_DATA('164167','1','1','1'),
 T_TIPO_DATA('165246','1','4','1'),
 T_TIPO_DATA('165487','1','1','42'),
 T_TIPO_DATA('166278','1','3','1'),
 T_TIPO_DATA('166284','1','1','42'),
 T_TIPO_DATA('166418','1','4','1'),
 T_TIPO_DATA('167014','1','3','1'),
 T_TIPO_DATA('167364','1','3','1'),
 T_TIPO_DATA('167567','1','3','1'),
 T_TIPO_DATA('168087','1','4','NULL'),
 T_TIPO_DATA('168095','1','1','NULL'),
 T_TIPO_DATA('168192','1','3','NULL'),
 T_TIPO_DATA('168219','1','1','NULL'),
 T_TIPO_DATA('168244','1','1','1'),
 T_TIPO_DATA('168320','1','4','NULL'),
 T_TIPO_DATA('168430','1','3','3'),
 T_TIPO_DATA('168561','1','3','1'),
 T_TIPO_DATA('168642','1','1','NULL'),
 T_TIPO_DATA('169042','1','4','1'),
 T_TIPO_DATA('169163','1','1','42'),
 T_TIPO_DATA('169449','1','3','1'),
 T_TIPO_DATA('169488','2','8','NULL'),
 T_TIPO_DATA('169698','1','3','5'),
 T_TIPO_DATA('169699','1','3','5'),
 T_TIPO_DATA('169760','1','1','42'),
 T_TIPO_DATA('170023','1','3','5'),
 T_TIPO_DATA('170151','1','4','NULL'),
 T_TIPO_DATA('170188','1','1','42'),
 T_TIPO_DATA('170202','1','3','1'),
 T_TIPO_DATA('170278','1','3','1'),
 T_TIPO_DATA('170382','1','3','1'),
 T_TIPO_DATA('170597','1','4','1'),
 T_TIPO_DATA('171007','1','3','1'),
 T_TIPO_DATA('171853','1','4','1'),
 T_TIPO_DATA('171933','1','3','1'),
 T_TIPO_DATA('173709','1','4','NULL'),
 T_TIPO_DATA('173718','1','3','1'),
 T_TIPO_DATA('173759','1','3','1'),
 T_TIPO_DATA('173912','1','3','1'),
 T_TIPO_DATA('174370','1','3','1'),
 T_TIPO_DATA('174429','1','4','NULL'),
 T_TIPO_DATA('174459','1','1','42'),
 T_TIPO_DATA('175228','1','1','42'),
 T_TIPO_DATA('175590','1','3','3'),
 T_TIPO_DATA('175655','1','1','NULL'),
 T_TIPO_DATA('175794','1','4','NULL'),
 T_TIPO_DATA('175847','1','4','1'),
 T_TIPO_DATA('175879','1','3','1'),
 T_TIPO_DATA('175934','1','4','NULL'),
 T_TIPO_DATA('175979','1','4','1'),
 T_TIPO_DATA('176210','1','1','NULL'),
 T_TIPO_DATA('176476','1','3','1'),
 T_TIPO_DATA('176700','1','3','1'),
 T_TIPO_DATA('177254','1','3','5'),
 T_TIPO_DATA('177257','1','3','1'),
 T_TIPO_DATA('177267','1','3','1'),
 T_TIPO_DATA('177558','1','3','1'),
 T_TIPO_DATA('177702','1','4','1'),
 T_TIPO_DATA('178881','1','1','42'),
 T_TIPO_DATA('179586','1','1','42'),
 T_TIPO_DATA('182251','1','3','1'),
 T_TIPO_DATA('184123','1','4','1'),
 T_TIPO_DATA('184448','1','1','42'),
 T_TIPO_DATA('189178','1','4','1'),
 T_TIPO_DATA('190913','2','7','1'),
 T_TIPO_DATA('194614','1','4','1'),
 T_TIPO_DATA('194867','1','4','1'),
 T_TIPO_DATA('194868','1','4','1'),
 T_TIPO_DATA('195925','1','4','1'),
 T_TIPO_DATA('197041','2','8','1'),
 T_TIPO_DATA('198331','1','3','1'),
 T_TIPO_DATA('198504','1','3','1'),
 T_TIPO_DATA('198505','1','3','1'),
 T_TIPO_DATA('198719','1','4','1'),
 T_TIPO_DATA('198720','1','4','1'),
 T_TIPO_DATA('199114','1','3','1'),
 T_TIPO_DATA('199604','1','1','42'),
 T_TIPO_DATA('199605','1','1','42'),
 T_TIPO_DATA('199855','1','4','NULL'),
 T_TIPO_DATA('199887','1','1','42'),
 T_TIPO_DATA('200211','1','3','1'),
 T_TIPO_DATA('200454','1','4','1'),
 T_TIPO_DATA('200467','1','3','5'),
 T_TIPO_DATA('200509','1','1','42'),
 T_TIPO_DATA('200513','1','3','1'),
 T_TIPO_DATA('200525','1','3','1'),
 T_TIPO_DATA('200549','1','3','5'),
 T_TIPO_DATA('200816','1','3','1'),
 T_TIPO_DATA('200861','1','4','1'),
 T_TIPO_DATA('200899','1','3','41'),
 T_TIPO_DATA('200979','1','3','5'),
 T_TIPO_DATA('200980','1','3','5'),
 T_TIPO_DATA('201084','1','3','5'),
 T_TIPO_DATA('201301','1','4','1'),
 T_TIPO_DATA('201463','1','3','1'),
 T_TIPO_DATA('201478','1','1','42'),
 T_TIPO_DATA('201640','1','1','42'),
 T_TIPO_DATA('203074','1','3','1'),
 T_TIPO_DATA('203132','1','3','1'),
 T_TIPO_DATA('203250','1','3','1'),
 T_TIPO_DATA('203251','1','3','1'),
 T_TIPO_DATA('203252','1','3','1'),
 T_TIPO_DATA('203533','1','3','1'),
 T_TIPO_DATA('203534','1','3','1'),
 T_TIPO_DATA('203766','1','3','1'),
 T_TIPO_DATA('203954','1','3','1'),
 T_TIPO_DATA('203957','1','3','1'),
 T_TIPO_DATA('203958','1','3','1'),
 T_TIPO_DATA('203959','1','3','1'),
 T_TIPO_DATA('203960','1','3','1'),
 T_TIPO_DATA('203962','1','3','1'),
 T_TIPO_DATA('204537','1','4','1'),
 T_TIPO_DATA('939417','1','1','42'),
 T_TIPO_DATA('943416','1','3','1'),
 T_TIPO_DATA('945367','1','1','42'),
 T_TIPO_DATA('5924912','1','4','NULL'),
 T_TIPO_DATA('6132211','1','4','1'),
 T_TIPO_DATA('6344362','2','5','NULL'),
 T_TIPO_DATA('6351585','1','1','42'),
 T_TIPO_DATA('6351586','1','1','42'),
 T_TIPO_DATA('6351587','1','1','42'),
 T_TIPO_DATA('6351590','1','1','42'),
 T_TIPO_DATA('6351591','1','1','42'),
 T_TIPO_DATA('6351594','1','1','42'),
 T_TIPO_DATA('6351595','1','1','42'),
 T_TIPO_DATA('6351596','1','1','42'),
 T_TIPO_DATA('6351597','1','1','42'),
 T_TIPO_DATA('6351598','1','1','42'),
 T_TIPO_DATA('6351599','1','1','42'),
 T_TIPO_DATA('6351600','1','1','42'),
 T_TIPO_DATA('6351602','1','1','42'),
 T_TIPO_DATA('6710197','1','1','42'),
 T_TIPO_DATA('6710198','1','1','42'),
 T_TIPO_DATA('6710199','1','1','42'),
 T_TIPO_DATA('6710200','1','1','42'),
 T_TIPO_DATA('6710201','1','1','42'),
 T_TIPO_DATA('6710202','1','1','1'),
 T_TIPO_DATA('6710203','1','1','42'),
 T_TIPO_DATA('6710204','1','1','1'),
 T_TIPO_DATA('6710205','1','1','42'),
 T_TIPO_DATA('6710206','1','1','42'),
 T_TIPO_DATA('6710207','1','1','42'),
 T_TIPO_DATA('6710208','1','1','1'),
 T_TIPO_DATA('6839937','1','1','42'),
 T_TIPO_DATA('6839938','1','1','42'),
 T_TIPO_DATA('6839939','1','1','42'),
 T_TIPO_DATA('6839940','1','1','42'),
 T_TIPO_DATA('6839942','1','1','42'),
 T_TIPO_DATA('6839943','1','1','42'),
 T_TIPO_DATA('6839944','1','1','42'),
 T_TIPO_DATA('6839946','1','1','42'),
 T_TIPO_DATA('6839947','1','1','42'),
 T_TIPO_DATA('6839948','1','1','42'),
 T_TIPO_DATA('6839949','1','1','42'),
 T_TIPO_DATA('6839950','1','1','42'),
 T_TIPO_DATA('6839951','1','1','42'),
 T_TIPO_DATA('6839952','1','1','42'),
 T_TIPO_DATA('6839953','1','1','42'),
 T_TIPO_DATA('6839954','1','1','42'),
 T_TIPO_DATA('6839955','1','1','42'),
 T_TIPO_DATA('6839956','1','1','42'),
 T_TIPO_DATA('6839957','1','1','42'),
 T_TIPO_DATA('6839958','1','1','42'),
 T_TIPO_DATA('6839959','1','1','42'),
 T_TIPO_DATA('6839960','1','1','42'),
 T_TIPO_DATA('6839961','1','1','42'),
 T_TIPO_DATA('6839962','1','1','42'),
 T_TIPO_DATA('6839963','1','1','42'),
 T_TIPO_DATA('6839965','1','1','42'),
 T_TIPO_DATA('6839966','1','1','42'),
 T_TIPO_DATA('6839967','1','1','42'),
 T_TIPO_DATA('6839968','1','1','42'),
 T_TIPO_DATA('6839969','1','1','42'),
 T_TIPO_DATA('6839970','1','1','42'),
 T_TIPO_DATA('6839971','1','1','42'),
 T_TIPO_DATA('6839972','1','1','42'),
 T_TIPO_DATA('6839974','1','1','42'),
 T_TIPO_DATA('6839975','1','1','42'),
 T_TIPO_DATA('6839976','1','1','42'),
 T_TIPO_DATA('6839977','1','1','42'),
 T_TIPO_DATA('6839978','1','1','42'),
 T_TIPO_DATA('6839979','1','1','42'),
 T_TIPO_DATA('6839980','1','1','42'),
 T_TIPO_DATA('6839981','1','1','42'),
 T_TIPO_DATA('6839982','1','1','42'),
 T_TIPO_DATA('6839983','1','1','42'),
 T_TIPO_DATA('6839984','1','1','42'),
 T_TIPO_DATA('6839985','1','1','42'),
 T_TIPO_DATA('6839986','1','1','42'),
 T_TIPO_DATA('6839987','1','1','42'),
 T_TIPO_DATA('6839988','1','1','42'),
 T_TIPO_DATA('6839989','1','1','42'),
 T_TIPO_DATA('6839990','1','1','42'),
 T_TIPO_DATA('6839991','1','1','42'),
 T_TIPO_DATA('6965605','1','1','42'),
 T_TIPO_DATA('6965606','1','1','42'),
 T_TIPO_DATA('6965607','1','1','42'),
 T_TIPO_DATA('6965608','1','1','42'),
 T_TIPO_DATA('6965609','1','1','42'),
 T_TIPO_DATA('6965610','1','1','42'),
 T_TIPO_DATA('6965611','1','1','42'),
 T_TIPO_DATA('6965612','1','1','42'),
 T_TIPO_DATA('6965613','1','1','42'),
 T_TIPO_DATA('6967528','2','5','NULL'),
 T_TIPO_DATA('6967529','2','5','42'),
 T_TIPO_DATA('7004274','1','1','42'),
 T_TIPO_DATA('7004275','1','1','42'),
 T_TIPO_DATA('7004276','1','1','42'),
 T_TIPO_DATA('7071657','1','4','1'),
 T_TIPO_DATA('7074961','1','3','1'),
 T_TIPO_DATA('7074962','1','3','1'),
 T_TIPO_DATA('7100648','1','3','5'),
 T_TIPO_DATA('7298538','1','4','NULL')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del trabajo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Actualizamos el dato
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET
               DD_TPA_ID = '||V_TMP_TIPO_DATA(2)||',
               DD_SAC_ID = '||V_TMP_TIPO_DATA(3)||',  
               DD_TUD_ID = '||V_TMP_TIPO_DATA(4)||',      
               USUARIOMODIFICAR = '''||V_USUARIO||''',
               FECHAMODIFICAR = SYSDATE               
               WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');
            
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

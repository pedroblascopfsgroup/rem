--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200429
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7164
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-7164';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates

  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA(98445,'jsanchezna'),
		T_TIPO_DATA(98029,'aaltarriba'),
		T_TIPO_DATA(98371,'mluna'),
		T_TIPO_DATA(98704,'mpelegay'),
		T_TIPO_DATA(99075,'mpelegay'),
		T_TIPO_DATA(98208,'asantosh'),
		T_TIPO_DATA(98634,'bjulian'),
		T_TIPO_DATA(96841,'bjulian'),
		T_TIPO_DATA(99190,'jroca'),
		T_TIPO_DATA(98611,'jcarrillo'),
		T_TIPO_DATA(97696,'jlinares'),
		T_TIPO_DATA(98602,'jcarrillo'),
		T_TIPO_DATA(98238,'jlinares'),
		T_TIPO_DATA(98336,'jfuentes'),
		T_TIPO_DATA(97751,'jlinares'),
		T_TIPO_DATA(98379,'asantosh'),
		T_TIPO_DATA(98430,'jcarrillo'),
		T_TIPO_DATA(98951,'aaltarriba'),
		T_TIPO_DATA(97586,'jlinares'),
		T_TIPO_DATA(98968,'jcanelles'),
		T_TIPO_DATA(98170,'jgonzalezmo'),
		T_TIPO_DATA(98750,'jcarrillo'),
		T_TIPO_DATA(99201,'arubioq'),
		T_TIPO_DATA(98189,'jroca'),
		T_TIPO_DATA(96603,'jlinares'),
		T_TIPO_DATA(98505,'jordonez'),
		T_TIPO_DATA(97388,'aaltarriba'),
		T_TIPO_DATA(98558,'jordonez'),
		T_TIPO_DATA(98180,'mluna'),
		T_TIPO_DATA(98263,'arubioq'),
		T_TIPO_DATA(98510,'aaltarriba'),
		T_TIPO_DATA(99089,'jroca'),
		T_TIPO_DATA(99208,'arubioq'),
		T_TIPO_DATA(98061,'jroca'),
		T_TIPO_DATA(98211,'asantosh'),
		T_TIPO_DATA(98564,'ljardiel'),
		T_TIPO_DATA(98414,'jroca'),
		T_TIPO_DATA(98123,'jlinares'),
		T_TIPO_DATA(97963,'jlinares'),
		T_TIPO_DATA(97531,'mgorrochategui'),
		T_TIPO_DATA(98494,'aferrandiz'),
		T_TIPO_DATA(97569,'jsimon'),
		T_TIPO_DATA(98695,'arubioq'),
		T_TIPO_DATA(96994,'mcastaneda'),
		T_TIPO_DATA(97360,'mbenitez'),
		T_TIPO_DATA(97964,'jlinares'),
		T_TIPO_DATA(98026,'aaltarriba'),
		T_TIPO_DATA(98007,'jfuentes'),
		T_TIPO_DATA(97243,'aaltarriba'),
		T_TIPO_DATA(96757,'ncampo'),
		T_TIPO_DATA(97719,'jlinares'),
		T_TIPO_DATA(98132,'arubioq'),
		T_TIPO_DATA(97701,'eblasco'),
		T_TIPO_DATA(99109,'arubioq'),
		T_TIPO_DATA(97559,'ggandoy'),
		T_TIPO_DATA(97170,'mjmagana'),
		T_TIPO_DATA(98306,'mgomezh'),
		T_TIPO_DATA(96557,'asanchezpo'),
		T_TIPO_DATA(98714,'jordonez'),
		T_TIPO_DATA(96673,'aaltarriba'),
		T_TIPO_DATA(98348,'aaltarriba'),
		T_TIPO_DATA(98314,'mluna'),
		T_TIPO_DATA(98867,'jroca'),
		T_TIPO_DATA(98837,'jsimon'),
		T_TIPO_DATA(98600,'dsalvador'),
		T_TIPO_DATA(98090,'jroca'),
		T_TIPO_DATA(98411,'jroca'),
		T_TIPO_DATA(98185,'jordonez'),
		T_TIPO_DATA(97515,'mluna'),
		T_TIPO_DATA(97469,'asegarra'),
		T_TIPO_DATA(97583,'jlinares'),
		T_TIPO_DATA(97584,'jlinares'),
		T_TIPO_DATA(99204,'dsalvador'),
		T_TIPO_DATA(98209,'asantosh'),
		T_TIPO_DATA(96890,'jsevilla'),
		T_TIPO_DATA(98543,'jroca'),
		T_TIPO_DATA(97954,'jsevilla'),
		T_TIPO_DATA(97587,'jlinares'),
		T_TIPO_DATA(97036,'sguillen'),
		T_TIPO_DATA(98333,'jcarrillo'),
		T_TIPO_DATA(98468,'jsimon'),
		T_TIPO_DATA(98864,'arubioq'),
		T_TIPO_DATA(98133,'ggandoy'),
		T_TIPO_DATA(98322,'lpasano'),
		T_TIPO_DATA(96744,'mbenitez'),
		T_TIPO_DATA(98431,'prico'),
		T_TIPO_DATA(97969,'jsevilla'),
		T_TIPO_DATA(98562,'jgaruz'),
		T_TIPO_DATA(97664,'jsevilla'),
		T_TIPO_DATA(97746,'eblasco'),
		T_TIPO_DATA(98599,'easins'),
		T_TIPO_DATA(97661,'jsevilla'),
		T_TIPO_DATA(98128,'arubioq'),
		T_TIPO_DATA(98275,'arubioq'),
		T_TIPO_DATA(97255,'mpuigmarti'),
		T_TIPO_DATA(97199,'bjulian'),
		T_TIPO_DATA(99018,'mluna'),
		T_TIPO_DATA(98402,'bgalan'),
		T_TIPO_DATA(98822,'jcanelles'),
		T_TIPO_DATA(98948,'fpineiro'),
		T_TIPO_DATA(98518,'jgutierrezp'),
		T_TIPO_DATA(99015,'bgalan'),
		T_TIPO_DATA(97980,'fperello'),
		T_TIPO_DATA(99023,'mpuigmarti'),
		T_TIPO_DATA(98198,'mluna'),
		T_TIPO_DATA(99166,'jroca'),
		T_TIPO_DATA(98116,'jcarrillo'),
		T_TIPO_DATA(97037,'sguillen'),
		T_TIPO_DATA(97049,'mluna'),
		T_TIPO_DATA(98467,'jgonzalezmo'),
		T_TIPO_DATA(97541,'asantosh'),
		T_TIPO_DATA(97435,'lpasano'),
		T_TIPO_DATA(98808,'arubioq'),
		T_TIPO_DATA(99012,'aaltarriba'),
		T_TIPO_DATA(98365,'erosillo'),
		T_TIPO_DATA(98722,'mbenitez'),
		T_TIPO_DATA(98642,'mluna'),
		T_TIPO_DATA(98367,'arubioq'),
		T_TIPO_DATA(97548,'erosillo'),
		T_TIPO_DATA(96511,'jduque'),
		T_TIPO_DATA(98453,'jcarrillo'),
		T_TIPO_DATA(99161,'fpineiro'),
		T_TIPO_DATA(98255,'jordonez'),
		T_TIPO_DATA(98733,'arubioq'),
		T_TIPO_DATA(99192,'jroca'),
		T_TIPO_DATA(99133,'arubioq'),
		T_TIPO_DATA(98259,'arubioq'),
		T_TIPO_DATA(98403,'arubioq'),
		T_TIPO_DATA(98628,'tmaldonado'),
		T_TIPO_DATA(96879,'jduque'),
		T_TIPO_DATA(98272,'bgalan'),
		T_TIPO_DATA(98927,'easins'),
		T_TIPO_DATA(98806,'aaltarriba'),
		T_TIPO_DATA(98190,'aaltarriba'),
		T_TIPO_DATA(97109,'easins'),
		T_TIPO_DATA(98971,'mluna'),
		T_TIPO_DATA(98969,'aaltarriba'),
		T_TIPO_DATA(98028,'aaltarriba'),
		T_TIPO_DATA(97711,'arubioq'),
		T_TIPO_DATA(98861,'jgutierrezp'),
		T_TIPO_DATA(99138,'mluna'),
		T_TIPO_DATA(97173,'jgutierrezp'),
		T_TIPO_DATA(98583,'fperello'),
		T_TIPO_DATA(97323,'jlinares'),
		T_TIPO_DATA(98570,'jroca'),
		T_TIPO_DATA(98684,'asantosh'),
		T_TIPO_DATA(97291,'easins'),
		T_TIPO_DATA(98665,'jcanelles'),
		T_TIPO_DATA(99034,'arubioq'),
		T_TIPO_DATA(99049,'arubioq'),
		T_TIPO_DATA(98539,'mluna'),
		T_TIPO_DATA(97581,'jlinares'),
		T_TIPO_DATA(98269,'sguillen'),
		T_TIPO_DATA(99005,'jordonez'),
		T_TIPO_DATA(98179,'pcorrederas'),
		T_TIPO_DATA(98580,'dsalvador'),
		T_TIPO_DATA(97585,'jlinares'),
		T_TIPO_DATA(96488,'agarciares'),
		T_TIPO_DATA(97138,'jgutierrezp'),
		T_TIPO_DATA(98166,'ljardiel'),
		T_TIPO_DATA(98970,'aaltarriba'),
		T_TIPO_DATA(97394,'mluna'),
		T_TIPO_DATA(97119,'ggandoy'),
		T_TIPO_DATA(96983,'jroca'),
		T_TIPO_DATA(98283,'arubioq'),
		T_TIPO_DATA(98135,'mcastaneda'),
		T_TIPO_DATA(96509,'asegarra'),
		T_TIPO_DATA(96494,'fmena'),
		T_TIPO_DATA(97535,'jsimon'),
		T_TIPO_DATA(98271,'jroca'),
		T_TIPO_DATA(97647,'lpasano'),
		T_TIPO_DATA(98162,'arubioq'),
		T_TIPO_DATA(97759,'jgutierrezp'),
		T_TIPO_DATA(98172,'fpineiro'),
		T_TIPO_DATA(98719,'jordonez'),
		T_TIPO_DATA(98818,'mluna'),
		T_TIPO_DATA(97066,'fperello'),
		T_TIPO_DATA(97588,'jlinares'),
		T_TIPO_DATA(99030,'dsalvador'),
		T_TIPO_DATA(96912,'fmena'),
		T_TIPO_DATA(97589,'jlinares'),
		T_TIPO_DATA(98405,'aaltarriba'),
		T_TIPO_DATA(98732,'dsalvador'),
		T_TIPO_DATA(99158,'jgonzalezmo'),
		T_TIPO_DATA(97956,'jcarrillo'),
		T_TIPO_DATA(98865,'arubioq'),
		T_TIPO_DATA(98629,'arubioq'),
		T_TIPO_DATA(98565,'arubioq'),
		T_TIPO_DATA(98671,'jcanelles'),
		T_TIPO_DATA(99188,'asantosh'),
		T_TIPO_DATA(97983,'mcastaneda'),
		T_TIPO_DATA(97582,'jlinares'),
		T_TIPO_DATA(99064,'jcarrillo'),
		T_TIPO_DATA(97265,'asantosh'),
		T_TIPO_DATA(99062,'jfuentes'),
		T_TIPO_DATA(98149,'easins'),
		T_TIPO_DATA(98261,'arubioq'),
		T_TIPO_DATA(98370,'jcanelles'),
		T_TIPO_DATA(98139,'jcanelles'),
		T_TIPO_DATA(98421,'dsalvador'),
		T_TIPO_DATA(98654,'ljardiel'),
		T_TIPO_DATA(98260,'arubioq'),
		T_TIPO_DATA(98191,'jcanelles'),
		T_TIPO_DATA(99202,'arubioq'),
		T_TIPO_DATA(98097,'arubioq'),
		T_TIPO_DATA(98372,'bgarcia'),
		T_TIPO_DATA(96499,'fperello'),
		T_TIPO_DATA(99178,'jordonez'),
		T_TIPO_DATA(98729,'mpuigmarti'),
		T_TIPO_DATA(98964,'aaltarriba'),
		T_TIPO_DATA(98720,'arubioq'),
		T_TIPO_DATA(98412,'jroca'),
		T_TIPO_DATA(98700,'jgaruz'),
		T_TIPO_DATA(97572,'ljardiel'),
		T_TIPO_DATA(97966,'jlinares'),
		T_TIPO_DATA(96961,'aaltarriba'),
		T_TIPO_DATA(98568,'jroca'),
		T_TIPO_DATA(98768,'lpasano'),
		T_TIPO_DATA(98247,'mgomezh'),
		T_TIPO_DATA(99168,'jgaruz'),
		T_TIPO_DATA(98578,'dsalvador'),
		T_TIPO_DATA(97533,'jsanchezna'),
		T_TIPO_DATA(96676,'ljardiel'),
		T_TIPO_DATA(97991,'bjulian'),
		T_TIPO_DATA(98579,'dsalvador'),
		T_TIPO_DATA(97376,'rbarquero'),
		T_TIPO_DATA(96468,'easins'),
		T_TIPO_DATA(96702,'asanchezpo'),
		T_TIPO_DATA(98131,'jfuentes'),
		T_TIPO_DATA(97997,'ljardiel'),
		T_TIPO_DATA(98262,'arubioq'),
		T_TIPO_DATA(98597,'ggandoy'),
		T_TIPO_DATA(98885,'erosillo'),
		T_TIPO_DATA(96568,'sguillen'),
		T_TIPO_DATA(98670,'jcanelles'),
		T_TIPO_DATA(99026,'arubioq'),
		T_TIPO_DATA(98959,'jordonez'),
		T_TIPO_DATA(98514,'mluna'),
		T_TIPO_DATA(98022,'mpuigmarti'),
		T_TIPO_DATA(97566,'jfuentes'),
		T_TIPO_DATA(97489,'arubioq'),
		T_TIPO_DATA(97590,'jlinares'),
		T_TIPO_DATA(96646,'asegarra'),
		T_TIPO_DATA(98988,'arubioq'),
		T_TIPO_DATA(96763,'fperello'),
		T_TIPO_DATA(98967,'jcanelles'),
		T_TIPO_DATA(98327,'ppeinado'),
		T_TIPO_DATA(97372,'rbarquero'),
		T_TIPO_DATA(99152,'asantosh'),
		T_TIPO_DATA(98889,'jordonez'),
		T_TIPO_DATA(99189,'jroca'),
		T_TIPO_DATA(97395,'mgomezh'),
		T_TIPO_DATA(99058,'jlinares'),
		T_TIPO_DATA(98868,'jroca'),
		T_TIPO_DATA(98442,'jcarrillo'),
		T_TIPO_DATA(99033,'aaltarriba'),
		T_TIPO_DATA(97430,'jgaruz'),
		T_TIPO_DATA(98744,'jcarrillo'),
		T_TIPO_DATA(98876,'jsimon'),
		T_TIPO_DATA(98586,'arubioq'),
		T_TIPO_DATA(98931,'mluna'),
		T_TIPO_DATA(98296,'jsimon'),
		T_TIPO_DATA(99083,'ljardiel'),
		T_TIPO_DATA(98854,'jordonez'),
		T_TIPO_DATA(99183,'arubioq'),
		T_TIPO_DATA(98513,'jcanelles'),
		T_TIPO_DATA(98002,'jsevilla'),
		T_TIPO_DATA(97753,'jgutierrezp'),
		T_TIPO_DATA(96877,'pmiguell'),
		T_TIPO_DATA(98183,'jordonez'),
		T_TIPO_DATA(98308,'jcanelles'),
		T_TIPO_DATA(99025,'arubioq'),
		T_TIPO_DATA(98339,'jfuentes'),
		T_TIPO_DATA(98816,'mpuigmarti'),
		T_TIPO_DATA(97429,'dortega'),
		T_TIPO_DATA(98648,'jcanelles')						
	
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR GESTORES COMERCIALES DE LAS AGRUPACIONES');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_NUM_AGRUP_REM = '||V_TMP_TIPO_DATA(1)||'' INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN

		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_LCO_LOTE_COMERCIAL LCO SET
			  LCO.LCO_GESTOR_COMERCIAL = (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
			  WHERE LCO.AGR_ID = (SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_NUM_AGRUP_REM = '||V_TMP_TIPO_DATA(1)||')';	

		EXECUTE IMMEDIATE V_SQL;

        	V_COUNT := V_COUNT + 1;

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] La agrupracion no existe!');
				
	END IF;
			    
		
     END LOOP;
    
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_COUNT||' REGISTROS ACTUALIZADOS.');  

     COMMIT;

     DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT

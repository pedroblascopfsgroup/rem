--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200427
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7148
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-7148';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates

  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA(98445,'pluque'),
		T_TIPO_DATA(98029,'jguarch'),
		T_TIPO_DATA(98371,'jguarch'),
		T_TIPO_DATA(98704,'gortiz'),
		T_TIPO_DATA(99075,'jguarch'),
		T_TIPO_DATA(98208,'pluque'),
		T_TIPO_DATA(98634,'cpalau'),
		T_TIPO_DATA(96841,'cpalau'),
		T_TIPO_DATA(99190,'cpalau'),
		T_TIPO_DATA(98611,'cpalau'),
		T_TIPO_DATA(97696,'pgarciafraile'),
		T_TIPO_DATA(98602,'cpalau'),
		T_TIPO_DATA(98238,'gortiz'),
		T_TIPO_DATA(98336,'pluque'),
		T_TIPO_DATA(97751,'gortiz'),
		T_TIPO_DATA(98379,'pluque'),
		T_TIPO_DATA(98430,'cpalau'),
		T_TIPO_DATA(98951,'jguarch'),
		T_TIPO_DATA(97586,'gortiz'),
		T_TIPO_DATA(98968,'jguarch'),
		T_TIPO_DATA(98170,'pluque'),
		T_TIPO_DATA(98750,'cpalau'),
		T_TIPO_DATA(99201,'jguarch'),
		T_TIPO_DATA(98189,'cpalau'),
		T_TIPO_DATA(96603,'gortiz'),
		T_TIPO_DATA(98505,'cpalau'),
		T_TIPO_DATA(97388,'jguarch'),
		T_TIPO_DATA(98558,'cpalau'),
		T_TIPO_DATA(98180,'jguarch'),
		T_TIPO_DATA(98263,'jguarch'),
		T_TIPO_DATA(98510,'jguarch'),
		T_TIPO_DATA(99089,'cpalau'),
		T_TIPO_DATA(99208,'jguarch'),
		T_TIPO_DATA(98061,'cpalau'),
		T_TIPO_DATA(98211,'pluque'),
		T_TIPO_DATA(98564,'cpalau'),
		T_TIPO_DATA(98414,'cpalau'),
		T_TIPO_DATA(98123,'gortiz'),
		T_TIPO_DATA(97963,'gortiz'),
		T_TIPO_DATA(97531,'mcamano'),
		T_TIPO_DATA(98494,'pgarciafraile'),
		T_TIPO_DATA(97569,'pmarcial'),
		T_TIPO_DATA(98695,'jguarch'),
		T_TIPO_DATA(96994,'pluque'),
		T_TIPO_DATA(97360,'pluque'),
		T_TIPO_DATA(97964,'gortiz'),
		T_TIPO_DATA(98026,'jguarch'),
		T_TIPO_DATA(98007,'pluque'),
		T_TIPO_DATA(97243,'jguarch'),
		T_TIPO_DATA(96757,'gortiz'),
		T_TIPO_DATA(97719,'omora'),
		T_TIPO_DATA(98132,'jguarch'),
		T_TIPO_DATA(97701,'cpalau'),
		T_TIPO_DATA(99109,'jguarch'),
		T_TIPO_DATA(97559,'malonsoar'),
		T_TIPO_DATA(97170,'pgarciafraile'),
		T_TIPO_DATA(98306,'pluque'),
		T_TIPO_DATA(96557,'pluque'),
		T_TIPO_DATA(98714,'cpalau'),
		T_TIPO_DATA(96673,'jguarch'),
		T_TIPO_DATA(98348,'jguarch'),
		T_TIPO_DATA(98314,'jguarch'),
		T_TIPO_DATA(98867,'cpalau'),
		T_TIPO_DATA(98837,'pmarcial'),
		T_TIPO_DATA(98600,'pmarcial'),
		T_TIPO_DATA(98090,'cpalau'),
		T_TIPO_DATA(98411,'cpalau'),
		T_TIPO_DATA(98185,'cpalau'),
		T_TIPO_DATA(97515,'jguarch'),
		T_TIPO_DATA(97469,'mcamano'),
		T_TIPO_DATA(97583,'gortiz'),
		T_TIPO_DATA(97584,'gortiz'),
		T_TIPO_DATA(99204,'pmarcial'),
		T_TIPO_DATA(98209,'pluque'),
		T_TIPO_DATA(96890,'rdelolmo'),
		T_TIPO_DATA(98543,'cpalau'),
		T_TIPO_DATA(97954,'rdelolmo'),
		T_TIPO_DATA(97587,'gortiz'),
		T_TIPO_DATA(97036,'pmarcial'),
		T_TIPO_DATA(98333,'cpalau'),
		T_TIPO_DATA(98468,'pmarcial'),
		T_TIPO_DATA(98864,'jguarch'),
		T_TIPO_DATA(98133,'malonsoar'),
		T_TIPO_DATA(98322,'cpalau'),
		T_TIPO_DATA(96744,'pluque'),
		T_TIPO_DATA(98431,'mcamano'),
		T_TIPO_DATA(97969,'rdelolmo'),
		T_TIPO_DATA(98562,'malonsoar'),
		T_TIPO_DATA(97664,'rdelolmo'),
		T_TIPO_DATA(97746,'cpalau'),
		T_TIPO_DATA(98599,'pgarciafraile'),
		T_TIPO_DATA(97661,'rdelolmo'),
		T_TIPO_DATA(98128,'jguarch'),
		T_TIPO_DATA(98275,'jguarch'),
		T_TIPO_DATA(97255,'pmarcial'),
		T_TIPO_DATA(97199,'cpalau'),
		T_TIPO_DATA(99018,'jguarch'),
		T_TIPO_DATA(98402,'pluque'),
		T_TIPO_DATA(98822,'jguarch'),
		T_TIPO_DATA(98948,'mcamano'),
		T_TIPO_DATA(98518,'gortiz'),
		T_TIPO_DATA(99015,'pluque'),
		T_TIPO_DATA(97980,'pgarciafraile'),
		T_TIPO_DATA(99023,'pmarcial'),
		T_TIPO_DATA(98198,'jguarch'),
		T_TIPO_DATA(99166,'cpalau'),
		T_TIPO_DATA(98116,'cpalau'),
		T_TIPO_DATA(97037,'pmarcial'),
		T_TIPO_DATA(97049,'jguarch'),
		T_TIPO_DATA(98467,'pluque'),
		T_TIPO_DATA(97541,'pluque'),
		T_TIPO_DATA(97435,'cpalau'),
		T_TIPO_DATA(98808,'jguarch'),
		T_TIPO_DATA(99012,'jguarch'),
		T_TIPO_DATA(98365,'pmarcial'),
		T_TIPO_DATA(98722,'pluque'),
		T_TIPO_DATA(98642,'jguarch'),
		T_TIPO_DATA(98367,'jguarch'),
		T_TIPO_DATA(97548,'pmarcial'),
		T_TIPO_DATA(96511,'gortiz'),
		T_TIPO_DATA(98453,'cpalau'),
		T_TIPO_DATA(99161,'mcamano'),
		T_TIPO_DATA(98255,'cpalau'),
		T_TIPO_DATA(98733,'jguarch'),
		T_TIPO_DATA(99192,'cpalau'),
		T_TIPO_DATA(99133,'jguarch'),
		T_TIPO_DATA(98259,'jguarch'),
		T_TIPO_DATA(98403,'jguarch'),
		T_TIPO_DATA(97665,'rdelolmo'),
		T_TIPO_DATA(98628,'pmarcial'),
		T_TIPO_DATA(96879,'gortiz'),
		T_TIPO_DATA(98272,'pluque'),
		T_TIPO_DATA(98927,'pgarciafraile'),
		T_TIPO_DATA(98806,'jguarch'),
		T_TIPO_DATA(98190,'jguarch'),
		T_TIPO_DATA(97109,'pgarciafraile'),
		T_TIPO_DATA(98971,'jguarch'),
		T_TIPO_DATA(98969,'jguarch'),
		T_TIPO_DATA(98028,'jguarch'),
		T_TIPO_DATA(97711,'jguarch'),
		T_TIPO_DATA(98861,'gortiz'),
		T_TIPO_DATA(99138,'jguarch'),
		T_TIPO_DATA(97173,'gortiz'),
		T_TIPO_DATA(98583,'pgarciafraile'),
		T_TIPO_DATA(97323,'gortiz'),
		T_TIPO_DATA(98570,'cpalau'),
		T_TIPO_DATA(98684,'pluque'),
		T_TIPO_DATA(97291,'pgarciafraile'),
		T_TIPO_DATA(98665,'jguarch'),
		T_TIPO_DATA(99034,'jguarch'),
		T_TIPO_DATA(99049,'jguarch'),
		T_TIPO_DATA(98539,'jguarch'),
		T_TIPO_DATA(97581,'gortiz'),
		T_TIPO_DATA(98269,'pmarcial'),
		T_TIPO_DATA(99005,'cpalau'),
		T_TIPO_DATA(98179,'omora'),
		T_TIPO_DATA(98580,'pmarcial'),
		T_TIPO_DATA(97585,'gortiz'),
		T_TIPO_DATA(96488,'gortiz'),
		T_TIPO_DATA(97138,'gortiz'),
		T_TIPO_DATA(98166,'cpalau'),
		T_TIPO_DATA(98970,'jguarch'),
		T_TIPO_DATA(97394,'jguarch'),
		T_TIPO_DATA(97119,'malonsoar'),
		T_TIPO_DATA(96983,'cpalau'),
		T_TIPO_DATA(98283,'jguarch'),
		T_TIPO_DATA(98135,'pluque'),
		T_TIPO_DATA(96509,'mcamano'),
		T_TIPO_DATA(96494,'malonsoar'),
		T_TIPO_DATA(97535,'pmarcial'),
		T_TIPO_DATA(98271,'cpalau'),
		T_TIPO_DATA(97647,'cpalau'),
		T_TIPO_DATA(98162,'jguarch'),
		T_TIPO_DATA(97759,'gortiz'),
		T_TIPO_DATA(98172,'mcamano'),
		T_TIPO_DATA(98719,'cpalau'),
		T_TIPO_DATA(98818,'jguarch'),
		T_TIPO_DATA(97066,'pgarciafraile'),
		T_TIPO_DATA(97588,'gortiz'),
		T_TIPO_DATA(99030,'pmarcial'),
		T_TIPO_DATA(96912,'malonsoar'),
		T_TIPO_DATA(97589,'gortiz'),
		T_TIPO_DATA(98405,'jguarch'),
		T_TIPO_DATA(98732,'pmarcial'),
		T_TIPO_DATA(99158,'pluque'),
		T_TIPO_DATA(97956,'cpalau'),
		T_TIPO_DATA(98865,'jguarch'),
		T_TIPO_DATA(98629,'jguarch'),
		T_TIPO_DATA(98565,'jguarch'),
		T_TIPO_DATA(98671,'jguarch'),
		T_TIPO_DATA(99188,'pluque'),
		T_TIPO_DATA(97983,'pluque'),
		T_TIPO_DATA(97582,'gortiz'),
		T_TIPO_DATA(99064,'cpalau'),
		T_TIPO_DATA(97265,'pluque'),
		T_TIPO_DATA(99062,'pluque'),
		T_TIPO_DATA(98149,'pgarciafraile'),
		T_TIPO_DATA(98261,'jguarch'),
		T_TIPO_DATA(98370,'jguarch'),
		T_TIPO_DATA(98139,'jguarch'),
		T_TIPO_DATA(98421,'pmarcial'),
		T_TIPO_DATA(98654,'cpalau'),
		T_TIPO_DATA(98260,'jguarch'),
		T_TIPO_DATA(98191,'jguarch'),
		T_TIPO_DATA(99202,'jguarch'),
		T_TIPO_DATA(98097,'jguarch'),
		T_TIPO_DATA(98372,'rdelolmo'),
		T_TIPO_DATA(96499,'pgarciafraile'),
		T_TIPO_DATA(99178,'cpalau'),
		T_TIPO_DATA(98729,'pmarcial'),
		T_TIPO_DATA(98964,'jguarch'),
		T_TIPO_DATA(98720,'jguarch'),
		T_TIPO_DATA(98412,'cpalau'),
		T_TIPO_DATA(98700,'malonsoar'),
		T_TIPO_DATA(97572,'cpalau'),
		T_TIPO_DATA(97966,'gortiz'),
		T_TIPO_DATA(96961,'jguarch'),
		T_TIPO_DATA(98568,'cpalau'),
		T_TIPO_DATA(98768,'cpalau'),
		T_TIPO_DATA(98247,'pluque'),
		T_TIPO_DATA(99168,'malonsoar'),
		T_TIPO_DATA(98578,'pmarcial'),
		T_TIPO_DATA(97533,'pluque'),
		T_TIPO_DATA(96676,'cpalau'),
		T_TIPO_DATA(97991,'omora'),
		T_TIPO_DATA(98579,'pmarcial'),
		T_TIPO_DATA(97376,'omora'),
		T_TIPO_DATA(96468,'pgarciafraile'),
		T_TIPO_DATA(96702,'pluque'),
		T_TIPO_DATA(98131,'pluque'),
		T_TIPO_DATA(97997,'cpalau'),
		T_TIPO_DATA(98262,'jguarch'),
		T_TIPO_DATA(98597,'malonsoar'),
		T_TIPO_DATA(98885,'pmarcial'),
		T_TIPO_DATA(96568,'pmarcial'),
		T_TIPO_DATA(98670,'jguarch'),
		T_TIPO_DATA(99026,'jguarch'),
		T_TIPO_DATA(98959,'cpalau'),
		T_TIPO_DATA(98514,'jguarch'),
		T_TIPO_DATA(98022,'pmarcial'),
		T_TIPO_DATA(97566,'pluque'),
		T_TIPO_DATA(97489,'jguarch'),
		T_TIPO_DATA(97590,'gortiz'),
		T_TIPO_DATA(96646,'mcamano'),
		T_TIPO_DATA(98988,'jguarch'),
		T_TIPO_DATA(96763,'pgarciafraile'),
		T_TIPO_DATA(98967,'jguarch'),
		T_TIPO_DATA(98327,'pgarciafraile'),
		T_TIPO_DATA(97372,'pluque'),
		T_TIPO_DATA(99152,'pluque'),
		T_TIPO_DATA(98889,'cpalau'),
		T_TIPO_DATA(99189,'cpalau'),
		T_TIPO_DATA(97395,'pluque'),
		T_TIPO_DATA(99058,'gortiz'),
		T_TIPO_DATA(98868,'cpalau'),
		T_TIPO_DATA(98442,'cpalau'),
		T_TIPO_DATA(99033,'jguarch'),
		T_TIPO_DATA(97430,'malonsoar'),
		T_TIPO_DATA(98744,'cpalau'),
		T_TIPO_DATA(98876,'pmarcial'),
		T_TIPO_DATA(98586,'jguarch'),
		T_TIPO_DATA(98931,'jguarch'),
		T_TIPO_DATA(98296,'pmarcial'),
		T_TIPO_DATA(99083,'cpalau'),
		T_TIPO_DATA(98854,'cpalau'),
		T_TIPO_DATA(99183,'jguarch'),
		T_TIPO_DATA(98513,'jguarch'),
		T_TIPO_DATA(98002,'rdelolmo'),
		T_TIPO_DATA(97753,'gortiz'),
		T_TIPO_DATA(96877,'rdelolmo'),
		T_TIPO_DATA(98183,'cpalau'),
		T_TIPO_DATA(98308,'jguarch'),
		T_TIPO_DATA(99025,'jguarch'),
		T_TIPO_DATA(98339,'pluque'),
		T_TIPO_DATA(98816,'pmarcial'),
		T_TIPO_DATA(97429,'gortiz'),
		T_TIPO_DATA(98648,'jguarch')
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

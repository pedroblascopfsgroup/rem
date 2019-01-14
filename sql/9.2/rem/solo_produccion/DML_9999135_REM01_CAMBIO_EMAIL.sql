--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180416
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-505
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

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'USU_USUARIOS';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1167';

	USU_USERNAME VARCHAR2(55 CHAR);
	USU_MAIL_OLD VARCHAR2(55 CHAR);
	USU_MAIL_NEW VARCHAR2(55 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV('39760912F','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('17817353N','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('05906082G','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A80871031','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B81678005','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B11064771','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('08756974T','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('12349668W','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('P0800500A','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B13282553','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A78099025','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('05904906R','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('21385519G','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('74489856D','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('E82373366','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('00816389G','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A28233922','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B50509595','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B96913116','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('37756523E','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B13314539','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B80285547','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('piquer01','jpoyatos@haya.es','ventas@inmobiliariapiquer.com')
		, T_JBV('piquer01','jpoyatos@haya.es','ventas@inmobiliariapiquer.com')
		, T_JBV('piquer02','jpoyatos@haya.es','ventas@inmobiliariapiquer.com')
		, T_JBV('piquer02','jpoyatos@haya.es','ventas@inmobiliariapiquer.com')
		, T_JBV('00672331H','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('40259171V','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('06188720H','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A28535888','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('00649274F','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('50295627D','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('03423304F','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('51441665A','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A28007268','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('06228012A','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('19311555L','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('02504696L','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('39637207L','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('W0049001A','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('70576190T','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A08175994','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A78377405','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('02901830N','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B79360442','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('05136449C','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A78954591','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B46646253','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A28517308','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('garsa01','jpoyatos@haya.es','bh.ventas@garsa.com')
		, T_JBV('garsa01','jpoyatos@haya.es','bh.ventas@garsa.com')
		, T_JBV('garsa02','jpoyatos@haya.es','bh.ventas@garsa.com')
		, T_JBV('garsa02','jpoyatos@haya.es','bh.ventas@garsa.com')
		, T_JBV('garsa03','jpoyatos@haya.es','bh.ventas@garsa.com')
		, T_JBV('garsa03','jpoyatos@haya.es','bh.ventas@garsa.com')
		, T_JBV('A78907631','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('76227056L','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('05603460Q','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A48037642','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('09357842Q','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('09357842Q','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B80103732','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('35101069X','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A80146806','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('09254158Q','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('42177870X','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A83629428','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B97029045','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B43376987','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A15069230','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B83190538','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B43538354','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('X3420866F','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B13100748','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B03917788','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('25143109S','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B83840702','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B51010049','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('52365556F','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B61426300','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('06935774D','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('24862613G','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B10150100','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('G32014987','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('15147900P','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('30488377Z','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B33884438','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('X0236874C','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B78548831','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('Q9650037F','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('38065433L','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('23228738A','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('73782598R','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('08765817B','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B35046093','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('25086179X','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('V19222546','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('05614141W','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('E13278056','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B06294367','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('X6167867A','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('05918454W','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('V73612541','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('78466936K','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('40864435J','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('33425461K','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B57373102','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B35861939','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B64035256','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B96594676','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B39705421','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B98106693','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('78862520M','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B80978943','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B17985722','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B50967215','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('X6167867A','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B23437775','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B85455640','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('J54201272','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('X8077980N','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('05314047N','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A08446361','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B97842553','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B80029531','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B84546407','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B23464878','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('23790221X','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B81934853','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B81713505','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B28841393','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B06456313','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('45437329R','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B84344308','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B12225306','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('gesnova01','jpoyatos@haya.es','bo.tecnico@hayapm.es')
		, T_JBV('gesnova01','jpoyatos@haya.es','gestion.alquileres@gesnovagestion.com')
		, T_JBV('gesnova02','jpoyatos@haya.es','bo.tecnico@hayapm.es')
		, T_JBV('gesnova02','jpoyatos@haya.es','gestion.alquileres@gesnovagestion.com')
		, T_JBV('gesnova03','jpoyatos@haya.es','bo.tecnico@hayapm.es')
		, T_JBV('gesnova03','jpoyatos@haya.es','gestion.alquileres@gesnovagestion.com')
		, T_JBV('B46599155','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('21458536L','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('37691782A','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B63606255','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B61048252','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B08781049','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B12780847','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('52754959C','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B25589409','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B24457046','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('35064502J','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('piquer03','jpoyatos@haya.es','ventas@inmobiliariapiquer.com')
		, T_JBV('piquer03','jpoyatos@haya.es','ventas@inmobiliariapiquer.com')
		, T_JBV('33805358G','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B38592440','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('40301910E','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B23374804','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B23400104','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B36770238','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A34041442','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B47310891','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A53296380','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('52824056W','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('25953956C','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('G78581386','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B11432622','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('21451700Z','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('05198137E','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B10164705','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A08171605','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A36006666','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('V92521293','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B86601473','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B86650488','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B86657640','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('28658399P','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B04689055','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('76712813Q','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A95758389','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B98086796','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B97442826','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B66432923','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A04100954','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B36308898','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B86185881','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B05192521','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('A30014831','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('20794887N','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B28492841','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('ugehi01','jpoyatos@haya.es','ventas.bankia@grupough.com')
		, T_JBV('ugehi02','jpoyatos@haya.es','ventas.bankia@grupough.com')
		, T_JBV('ugehi03','jpoyatos@haya.es','ventas.bankia@grupough.com')
		, T_JBV('53163503S','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B65633448','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B35875111','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B87222006','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B86277977','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('B57790560','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('48376855N','jpoyatos@haya.es','sin_email@haya.es')
		, T_JBV('E82373366','jpoyatos@haya.es','sin_email@haya.es')		
	); 
V_TMP_JBV T_JBV;
BEGIN


 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
 			  USU_USERNAME := TRIM(V_TMP_JBV(1));
 			  USU_MAIL_OLD := TRIM(V_TMP_JBV(2));
 			  USU_MAIL_NEW := TRIM(V_TMP_JBV(3));
			
	

		V_SQL := 'UPDATE '||V_ESQUEMA_M||'.'||V_TABLA||' SET
					 USU_MAIL = '''||USU_MAIL_NEW||'''
				   , USUARIOMODIFICAR = '''||V_USUARIO||'''
				   , FECHAMODIFICAR = SYSDATE
				   WHERE USU_USERNAME = '''||USU_USERNAME||'''
				   AND USU_MAIL = '''||USU_MAIL_OLD||'''
					';
           

				EXECUTE IMMEDIATE V_SQL;
				
				IF SQL%ROWCOUNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('Puesto el USU_MAIL del usuario '||USU_USERNAME||' a '||USU_MAIL_NEW);
					V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
				END IF;
 END LOOP;			    
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado en total '||V_COUNT_UPDATE||' números de SAREB');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

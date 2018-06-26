--/*
--##########################################
--## AUTOR=Juanjo Arbona
--## FECHA_CREACION=20180626
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1166
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica los emails de los usuarios
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'USU_USUARIOS';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID_USUARIO NUMBER(16);
	V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-1166';
	V_MAIL VARCHAR2(100 CHAR) := 'jpoyatos@haya.es';
    V_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('39760912F','sin_email@haya.es'),
		T_TIPO_DATA('17817353N','sin_mail@haya.es'),
		T_TIPO_DATA('05906082G','sin_mail@haya.es'),
		T_TIPO_DATA('A80871031','sin_mail@haya.es'),
		T_TIPO_DATA('B81678005','sin_mail@haya.es'),
		T_TIPO_DATA('B11064771','sin_mail@haya.es'),
		T_TIPO_DATA('08756974T','sin_mail@haya.es'),
		T_TIPO_DATA('12349668W','sin_mail@haya.es'),
		T_TIPO_DATA('P0800500A','sin_mail@haya.es'),
		T_TIPO_DATA('B13282553','sin_mail@haya.es'),
		T_TIPO_DATA('A78099025','sin_mail@haya.es'),
		T_TIPO_DATA('05904906R','sin_mail@haya.es'),
		T_TIPO_DATA('21385519G','sin_mail@haya.es'),
		T_TIPO_DATA('74489856D','sin_mail@haya.es'),
		T_TIPO_DATA('E82373366','sin_mail@haya.es'),
		T_TIPO_DATA('00816389G','sin_mail@haya.es'),
		T_TIPO_DATA('A28233922','sin_mail@haya.es'),
		T_TIPO_DATA('B50509595','sin_mail@haya.es'),
		T_TIPO_DATA('B96913116','sin_mail@haya.es'),
		T_TIPO_DATA('37756523E','sin_mail@haya.es'),
		T_TIPO_DATA('B13314539','sin_mail@haya.es'),
		T_TIPO_DATA('B80285547','sin_mail@haya.es'),
		T_TIPO_DATA('piquer01','ventas@inmobiliariapiquer.com'),
		T_TIPO_DATA('piquer02','ventas@inmobiliariapiquer.com'),
		T_TIPO_DATA('00672331H','sin_mail@haya.es'),
		T_TIPO_DATA('40259171V','sin_mail@haya.es'),
		T_TIPO_DATA('06188720H','sin_mail@haya.es'),
		T_TIPO_DATA('A28535888','sin_mail@haya.es'),
		T_TIPO_DATA('00649274F','sin_mail@haya.es'),
		T_TIPO_DATA('50295627D','sin_mail@haya.es'),
		T_TIPO_DATA('03423304F','sin_mail@haya.es'),
		T_TIPO_DATA('51441665A','sin_mail@haya.es'),
		T_TIPO_DATA('A28007268','sin_mail@haya.es'),
		T_TIPO_DATA('06228012A','sin_mail@haya.es'),
		T_TIPO_DATA('19311555L','sin_mail@haya.es'),
		T_TIPO_DATA('02504696L','sin_mail@haya.es'),
		T_TIPO_DATA('39637207L','sin_mail@haya.es'),
		T_TIPO_DATA('W0049001A','sin_mail@haya.es'),
		T_TIPO_DATA('70576190T','sin_mail@haya.es'),
		T_TIPO_DATA('A08175994','sin_mail@haya.es'),
		T_TIPO_DATA('A78377405','sin_mail@haya.es'),
		T_TIPO_DATA('02901830N','sin_mail@haya.es'),
		T_TIPO_DATA('B79360442','sin_mail@haya.es'),
		T_TIPO_DATA('05136449C','sin_mail@haya.es'),
		T_TIPO_DATA('A78954591','sin_mail@haya.es'),
		T_TIPO_DATA('B46646253','sin_mail@haya.es'),
		T_TIPO_DATA('A28517308','sin_mail@haya.es'),
		T_TIPO_DATA('garsa01','bh.ventas@garsa.com'),
		T_TIPO_DATA('garsa02','bh.ventas@garsa.com'),
		T_TIPO_DATA('garsa03','bh.ventas@garsa.com'),
		T_TIPO_DATA('A78907631','sin_mail@haya.es'),
		T_TIPO_DATA('76227056L','sin_mail@haya.es'),
		T_TIPO_DATA('05603460Q','sin_mail@haya.es'),
		T_TIPO_DATA('A48037642','sin_mail@haya.es'),
		T_TIPO_DATA('09357842Q','sin_mail@haya.es'),
		T_TIPO_DATA('B80103732','sin_mail@haya.es'),
		T_TIPO_DATA('35101069X','sin_mail@haya.es'),
		T_TIPO_DATA('A80146806','sin_mail@haya.es'),
		T_TIPO_DATA('09254158Q','sin_mail@haya.es'),
		T_TIPO_DATA('42177870X','sin_mail@haya.es'),
		T_TIPO_DATA('A83629428','sin_mail@haya.es'),
		T_TIPO_DATA('B97029045','sin_mail@haya.es'),
		T_TIPO_DATA('B43376987','sin_mail@haya.es'),
		T_TIPO_DATA('A15069230','sin_mail@haya.es'),
		T_TIPO_DATA('B83190538','sin_mail@haya.es'),
		T_TIPO_DATA('B43538354','sin_mail@haya.es'),
		T_TIPO_DATA('X3420866F','sin_mail@haya.es'),
		T_TIPO_DATA('B13100748','sin_mail@haya.es'),
		T_TIPO_DATA('B03917788','sin_mail@haya.es'),
		T_TIPO_DATA('25143109S','sin_mail@haya.es'),
		T_TIPO_DATA('B83840702','sin_mail@haya.es'),
		T_TIPO_DATA('B51010049','sin_mail@haya.es'),
		T_TIPO_DATA('52365556F','sin_mail@haya.es'),
		T_TIPO_DATA('B61426300','sin_mail@haya.es'),
		T_TIPO_DATA('06935774D','sin_mail@haya.es'),
		T_TIPO_DATA('24862613G','sin_mail@haya.es'),
		T_TIPO_DATA('B10150100','sin_mail@haya.es'),
		T_TIPO_DATA('G32014987','sin_mail@haya.es'),
		T_TIPO_DATA('15147900P','sin_mail@haya.es'),
		T_TIPO_DATA('30488377Z','sin_mail@haya.es'),
		T_TIPO_DATA('B33884438','sin_mail@haya.es'),
		T_TIPO_DATA('X0236874C','sin_mail@haya.es'),
		T_TIPO_DATA('B78548831','sin_mail@haya.es'),
		T_TIPO_DATA('Q9650037F','sin_mail@haya.es'),
		T_TIPO_DATA('38065433L','sin_mail@haya.es'),
		T_TIPO_DATA('23228738A','sin_mail@haya.es'),
		T_TIPO_DATA('73782598R','sin_mail@haya.es'),
		T_TIPO_DATA('08765817B','sin_mail@haya.es'),
		T_TIPO_DATA('B35046093','sin_mail@haya.es'),
		T_TIPO_DATA('25086179X','sin_mail@haya.es'),
		T_TIPO_DATA('V19222546','sin_mail@haya.es'),
		T_TIPO_DATA('05614141W','sin_mail@haya.es'),
		T_TIPO_DATA('E13278056','sin_mail@haya.es'),
		T_TIPO_DATA('B06294367','sin_mail@haya.es'),
		T_TIPO_DATA('X6167867A','sin_mail@haya.es'),
		T_TIPO_DATA('05918454W','sin_mail@haya.es'),
		T_TIPO_DATA('V73612541','sin_mail@haya.es'),
		T_TIPO_DATA('78466936K','sin_mail@haya.es'),
		T_TIPO_DATA('40864435J','sin_mail@haya.es'),
		T_TIPO_DATA('33425461K','sin_mail@haya.es'),
		T_TIPO_DATA('B57373102','sin_mail@haya.es'),
		T_TIPO_DATA('B35861939','sin_mail@haya.es'),
		T_TIPO_DATA('B64035256','sin_mail@haya.es'),
		T_TIPO_DATA('B96594676','sin_mail@haya.es'),
		T_TIPO_DATA('B39705421','sin_mail@haya.es'),
		T_TIPO_DATA('B98106693','sin_mail@haya.es'),
		T_TIPO_DATA('78862520M','sin_mail@haya.es'),
		T_TIPO_DATA('B80978943','sin_mail@haya.es'),
		T_TIPO_DATA('B17985722','sin_mail@haya.es'),
		T_TIPO_DATA('B50967215','sin_mail@haya.es'),
		T_TIPO_DATA('X6167867A','sin_mail@haya.es'),
		T_TIPO_DATA('B23437775','sin_mail@haya.es'),
		T_TIPO_DATA('B85455640','sin_mail@haya.es'),
		T_TIPO_DATA('J54201272','sin_mail@haya.es'),
		T_TIPO_DATA('X8077980N','sin_mail@haya.es'),
		T_TIPO_DATA('05314047N','sin_mail@haya.es'),
		T_TIPO_DATA('A08446361','sin_mail@haya.es'),
		T_TIPO_DATA('B97842553','sin_mail@haya.es'),
		T_TIPO_DATA('B80029531','sin_mail@haya.es'),
		T_TIPO_DATA('B84546407','sin_mail@haya.es'),
		T_TIPO_DATA('B23464878','sin_mail@haya.es'),
		T_TIPO_DATA('23790221X','sin_mail@haya.es'),
		T_TIPO_DATA('B81934853','sin_mail@haya.es'),
		T_TIPO_DATA('B81713505','sin_mail@haya.es'),
		T_TIPO_DATA('B28841393','sin_mail@haya.es'),
		T_TIPO_DATA('B06456313','sin_mail@haya.es'),
		T_TIPO_DATA('45437329R','sin_mail@haya.es'),
		T_TIPO_DATA('B84344308','sin_mail@haya.es'),
		T_TIPO_DATA('B12225306','sin_mail@haya.es'),
		T_TIPO_DATA('gesnova01','bo.tecnico@hayapm.es'),
		T_TIPO_DATA('gesnova02','bo.tecnico@hayapm.es'),
		T_TIPO_DATA('gesnova03','bo.tecnico@hayapm.es'),
		T_TIPO_DATA('B46599155','sin_mail@haya.es'),
		T_TIPO_DATA('21458536L','sin_mail@haya.es'),
		T_TIPO_DATA('37691782A','sin_mail@haya.es'),
		T_TIPO_DATA('B63606255','sin_mail@haya.es'),
		T_TIPO_DATA('B61048252','sin_mail@haya.es'),
		T_TIPO_DATA('B08781049','sin_mail@haya.es'),
		T_TIPO_DATA('B12780847','sin_mail@haya.es'),
		T_TIPO_DATA('52754959C','sin_mail@haya.es'),
		T_TIPO_DATA('B25589409','sin_mail@haya.es'),
		T_TIPO_DATA('B24457046','sin_mail@haya.es'),
		T_TIPO_DATA('35064502J','sin_mail@haya.es'),
		T_TIPO_DATA('piquer03','ventas@inmobiliariapiquer.com'),
		T_TIPO_DATA('33805358G','sin_mail@haya.es'),
		T_TIPO_DATA('B38592440','sin_mail@haya.es'),
		T_TIPO_DATA('40301910E','sin_mail@haya.es'),
		T_TIPO_DATA('B23374804','sin_mail@haya.es'),
		T_TIPO_DATA('B23400104','sin_mail@haya.es'),
		T_TIPO_DATA('B36770238','sin_mail@haya.es'),
		T_TIPO_DATA('A34041442','sin_mail@haya.es'),
		T_TIPO_DATA('B47310891','sin_mail@haya.es'),
		T_TIPO_DATA('A53296380','sin_mail@haya.es'),
		T_TIPO_DATA('52824056W','sin_mail@haya.es'),
		T_TIPO_DATA('25953956C','sin_mail@haya.es'),
		T_TIPO_DATA('G78581386','sin_mail@haya.es'),
		T_TIPO_DATA('B11432622','sin_mail@haya.es'),
		T_TIPO_DATA('21451700Z','sin_mail@haya.es'),
		T_TIPO_DATA('05198137E','sin_mail@haya.es'),
		T_TIPO_DATA('B10164705','sin_mail@haya.es'),
		T_TIPO_DATA('A08171605','sin_mail@haya.es'),
		T_TIPO_DATA('A36006666','sin_mail@haya.es'),
		T_TIPO_DATA('V92521293','sin_mail@haya.es'),
		T_TIPO_DATA('B86601473','sin_mail@haya.es'),
		T_TIPO_DATA('B86650488','sin_mail@haya.es'),
		T_TIPO_DATA('B86657640','sin_mail@haya.es'),
		T_TIPO_DATA('28658399P','sin_mail@haya.es'),
		T_TIPO_DATA('B04689055','sin_mail@haya.es'),
		T_TIPO_DATA('76712813Q','sin_mail@haya.es'),
		T_TIPO_DATA('A95758389','sin_mail@haya.es'),
		T_TIPO_DATA('B98086796','sin_mail@haya.es'),
		T_TIPO_DATA('B97442826','sin_mail@haya.es'),
		T_TIPO_DATA('B66432923','sin_mail@haya.es'),
		T_TIPO_DATA('A04100954','sin_mail@haya.es'),
		T_TIPO_DATA('B36308898','sin_mail@haya.es'),
		T_TIPO_DATA('B86185881','sin_mail@haya.es'),
		T_TIPO_DATA('B05192521','sin_mail@haya.es'),
		T_TIPO_DATA('A30014831','sin_mail@haya.es'),
		T_TIPO_DATA('20794887N','sin_mail@haya.es'),
		T_TIPO_DATA('B28492841','sin_mail@haya.es'),
		T_TIPO_DATA('ugehi01','ventas.bankia@grupough.com'),
		T_TIPO_DATA('ugehi02','ventas.bankia@grupough.com'),
		T_TIPO_DATA('ugehi03','ventas.bankia@grupough.com'),
		T_TIPO_DATA('53163503S','sin_mail@haya.es'),
		T_TIPO_DATA('B65633448','sin_mail@haya.es'),
		T_TIPO_DATA('B35875111','sin_mail@haya.es'),
		T_TIPO_DATA('B87222006','sin_mail@haya.es'),
		T_TIPO_DATA('B86277977','sin_mail@haya.es'),
		T_TIPO_DATA('B57790560','sin_mail@haya.es'),
		T_TIPO_DATA('48376855N','sin_mail@haya.es'),
		T_TIPO_DATA('E82373366','sin_mail@haya.es')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS WHERE USU_USERNAME  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''' INTO V_ID_USUARIO;
        
        IF V_ID_USUARIO < 1 THEN
        
        	DBMS_OUTPUT.PUT_LINE('[WARNING] NO EXISTE EL USUARIO '''||TRIM(V_TMP_TIPO_DATA(1))||''' NO SE HACE NADA!');
        	
        ELSE				
	          
	          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO ');
	       	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.'||V_TEXT_TABLA||' '||
	                    'SET USU_MAIL = '''||TRIM(V_TMP_TIPO_DATA(2))||''' , USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND USU_MAIL = '''||V_MAIL||'''';
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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

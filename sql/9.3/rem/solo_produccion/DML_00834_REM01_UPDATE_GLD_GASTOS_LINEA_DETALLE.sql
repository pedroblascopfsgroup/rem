--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210504
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9629
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  ACTUALIZAR PARTIDAS CONTABLES
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-9629'; --Vble. auxiliar para almacenar el usuario
    	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion


 TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('271',null,'6312000'),
        T_TIPO_DATA('5163273','PP077','6312000'),
        T_TIPO_DATA('5163274','PP077','6312000'),
        T_TIPO_DATA('5163275','PP077','6312000'),
        T_TIPO_DATA('5163276','PP077','6312000'),
        T_TIPO_DATA('5163277','PP077','6312000'),
        T_TIPO_DATA('5163278','PP077','6312000'),
        T_TIPO_DATA('5163279','PP077','6312000'),
        T_TIPO_DATA('5163280','PP077','6312000'),
        T_TIPO_DATA('5163281','PP077','6312000'),
        T_TIPO_DATA('5163282','PP077','6312000'),
        T_TIPO_DATA('5163283','PP077','6312000'),
        T_TIPO_DATA('5172905','PP077','6312000'),
        T_TIPO_DATA('5172908','PP077','6312000'),
        T_TIPO_DATA('5172912','PP077','6312000'),
        T_TIPO_DATA('5172913','PP077','6312000'),
        T_TIPO_DATA('5172914','PP077','6312000'),
        T_TIPO_DATA('5173074','PP077','6312000'),
        T_TIPO_DATA('5175860','PP075','6312000'),
        T_TIPO_DATA('5175861','PP075','6312000'),
        T_TIPO_DATA('5175862','PP075','6312000'),
        T_TIPO_DATA('5175973','PP076','6312000'),
        T_TIPO_DATA('5178721','PP077','6312000'),
        T_TIPO_DATA('5181388','PP077','6312010'),
        T_TIPO_DATA('5181389',null,'6312010'),
        T_TIPO_DATA('5181396',null,'6312010'),
        T_TIPO_DATA('5181400',null,'6312010'),
        T_TIPO_DATA('5181401',null,'6312010'),
        T_TIPO_DATA('5181402',null,'6312010'),
        T_TIPO_DATA('5181403',null,'6312010'),
        T_TIPO_DATA('5181538','PP081','6312015'),
        T_TIPO_DATA('5181539',null,'6312008'),
        T_TIPO_DATA('5181540',null,'6312008'),
        T_TIPO_DATA('5181541',null,'6312008'),
        T_TIPO_DATA('5181861',null,'6312010'),
        T_TIPO_DATA('5181862',null,'6312010'),
        T_TIPO_DATA('5181863',null,'6312010'),
        T_TIPO_DATA('5181864',null,'6312010'),
        T_TIPO_DATA('5181865',null,'6312010'),
        T_TIPO_DATA('5181866',null,'6312010'),
        T_TIPO_DATA('5181873',null,'6312010'),
        T_TIPO_DATA('5184107',null,'6312010'),
        T_TIPO_DATA('5184108',null,'6312010'),
        T_TIPO_DATA('5184109',null,'6312010'),
        T_TIPO_DATA('5184110',null,'6312010'),
        T_TIPO_DATA('5184111',null,'6312010'),
        T_TIPO_DATA('5184112',null,'6312010'),
        T_TIPO_DATA('5184113',null,'6312010'),
        T_TIPO_DATA('5184114',null,'6312008'),
        T_TIPO_DATA('5184115',null,'6312008'),
        T_TIPO_DATA('5184116',null,'6312008'),
        T_TIPO_DATA('5184246',null,'6312010'),
        T_TIPO_DATA('5184247',null,'6312009'),
        T_TIPO_DATA('5184248',null,'6312010'),
        T_TIPO_DATA('5184249',null,'6312010'),
        T_TIPO_DATA('5184250',null,'6312010'),
        T_TIPO_DATA('5184251',null,'6312009'),
        T_TIPO_DATA('5184252',null,'6312010'),
        T_TIPO_DATA('5184253',null,'6312010'),
        T_TIPO_DATA('5184255',null,'6312010'),
        T_TIPO_DATA('5184256',null,'6312010'),
        T_TIPO_DATA('5184257',null,'6312010'),
        T_TIPO_DATA('5184258',null,'6312010'),
        T_TIPO_DATA('5184259',null,'6312010'),
        T_TIPO_DATA('5184260',null,'6312009'),
        T_TIPO_DATA('5184261',null,'6312010'),
        T_TIPO_DATA('5169618','PP075','6312000'),
        T_TIPO_DATA('5169619','PP075','6312000'),
        T_TIPO_DATA('5169622','PP054','6312000'),
        T_TIPO_DATA('5169624','PP082','6312000'),
        T_TIPO_DATA('5171427','PP077','6312000'),
        T_TIPO_DATA('5171428','PP077','6312000'),
        T_TIPO_DATA('5171429','PP076','6312000'),
        T_TIPO_DATA('5171430','PP075','6312000'),
        T_TIPO_DATA('5171431','PP075','6312000'),
        T_TIPO_DATA('5171432','PP075','6312000'),
        T_TIPO_DATA('5171435','PP084','6312000'),
        T_TIPO_DATA('5171437','PP077','6312000'),
        T_TIPO_DATA('5171438','PP077','6312000'),
        T_TIPO_DATA('5171442','PP075','6312000'),
        T_TIPO_DATA('5171443','PP075','6312000'),
        T_TIPO_DATA('5171444','PP075','6312000'),
        T_TIPO_DATA('5171447','PP077','6312000'),
        T_TIPO_DATA('5171456','PP084','6312000'),
        T_TIPO_DATA('5171458','PP075','6312000'),
        T_TIPO_DATA('5171459','PP075','6312000'),
        T_TIPO_DATA('5171461','PP077','6312000'),
        T_TIPO_DATA('5171474','PP077','6312000'),
        T_TIPO_DATA('5171475','PP077','6312000'),
        T_TIPO_DATA('5171476','PP077','6312000'),
        T_TIPO_DATA('5171478','PP077','6312000'),
        T_TIPO_DATA('5171479','PP077','6312000'),
        T_TIPO_DATA('5171480','PP075','6312000'),
        T_TIPO_DATA('5171481','PP075','6312000'),
        T_TIPO_DATA('5171482','PP075','6312000'),
        T_TIPO_DATA('5171483','PP075','6312000'),
        T_TIPO_DATA('5171506','PP077','6312000'),
        T_TIPO_DATA('5171507','PP077','6312000'),
        T_TIPO_DATA('5171508','PP084','6312000'),
        T_TIPO_DATA('5171509','PP077','6312000'),
        T_TIPO_DATA('5171653','PP077','6312000'),
        T_TIPO_DATA('5171655','PP075','6312000'),
        T_TIPO_DATA('5171656','PP075','6312000'),
        T_TIPO_DATA('5171657','PP075','6312000'),
        T_TIPO_DATA('5171658','PP075','6312000'),
        T_TIPO_DATA('5171660','PP077','6312000'),
        T_TIPO_DATA('5171661','PP075','6312000'),
        T_TIPO_DATA('5171665','PP077','6312000'),
        T_TIPO_DATA('5171668','PP075','6312000'),
        T_TIPO_DATA('5171670','PP075','6312000'),
        T_TIPO_DATA('5171673','PP077','6312000'),
        T_TIPO_DATA('5171675','PP077','6312000'),
        T_TIPO_DATA('5171676','PP077','6312000'),
        T_TIPO_DATA('5171678','PP075','6312000'),
        T_TIPO_DATA('5171679','PP075','6312000'),
        T_TIPO_DATA('5171680','PP075','6312000'),
        T_TIPO_DATA('5171681','PP077','6312000'),
        T_TIPO_DATA('5171682','PP077','6312000'),
        T_TIPO_DATA('5171684','PP077','6312000'),
        T_TIPO_DATA('5171685','PP084','6312000'),
        T_TIPO_DATA('5171686','PP077','6312000'),
        T_TIPO_DATA('5171688','PP075','6312000'),
        T_TIPO_DATA('5171690','PP075','6312000'),
        T_TIPO_DATA('5171691','PP075','6312000'),
        T_TIPO_DATA('5175442','PP084','6312000'),
        T_TIPO_DATA('5175402','PP077','6312000'),
        T_TIPO_DATA('5175403','PP077','6312000'),
        T_TIPO_DATA('5175445','PP084','6312000'),
        T_TIPO_DATA('5175405','PP077','6312000'),
        T_TIPO_DATA('5175446','PP084','6312000'),
        T_TIPO_DATA('5175447','PP084','6312000'),
        T_TIPO_DATA('5175407','PP077','6312000'),
        T_TIPO_DATA('5175448','PP084','6312000'),
        T_TIPO_DATA('5175450','PP084','6312000'),
        T_TIPO_DATA('5175409','PP077','6312000'),
        T_TIPO_DATA('5175410','PP077','6312000'),
        T_TIPO_DATA('5175451','PP084','6312000'),
        T_TIPO_DATA('5175452','PP084','6312000'),
        T_TIPO_DATA('5175453','PP084','6312000'),
        T_TIPO_DATA('5175412','PP077','6312000'),
        T_TIPO_DATA('5175413','PP077','6312000'),
        T_TIPO_DATA('5175454','PP084','6312000'),
        T_TIPO_DATA('5175414','PP077','6312000'),
        T_TIPO_DATA('5175455','PP084','6312000'),
        T_TIPO_DATA('5175456','PP084','6312000'),
        T_TIPO_DATA('5175415','PP077','6312000'),
        T_TIPO_DATA('5175416','PP077','6312000'),
        T_TIPO_DATA('5175457','PP084','6312000'),
        T_TIPO_DATA('5175458','PP084','6312000'),
        T_TIPO_DATA('5175418','PP077','6312000'),
        T_TIPO_DATA('5175419','PP077','6312000'),
        T_TIPO_DATA('5175420','PP077','6312000'),
        T_TIPO_DATA('5175422','PP077','6312000'),
        T_TIPO_DATA('5175459','PP084','6312000'),
        T_TIPO_DATA('5175424','PP077','6312000'),
        T_TIPO_DATA('5175425','PP077','6312000'),
        T_TIPO_DATA('5175440','PP075','6312000'),
        T_TIPO_DATA('5175461','PP084','6312000'),
        T_TIPO_DATA('5175426','PP077','6312000'),
        T_TIPO_DATA('5175427','PP077','6312000'),
        T_TIPO_DATA('5175428','PP077','6312000'),
        T_TIPO_DATA('5175462','PP084','6312000'),
        T_TIPO_DATA('5175463','PP084','6312000'),
        T_TIPO_DATA('5175429','PP077','6312000'),
        T_TIPO_DATA('5175464','PP084','6312000'),
        T_TIPO_DATA('5175430','PP077','6312010'),
        T_TIPO_DATA('5175431','PP077','6312000'),
        T_TIPO_DATA('5175432','PP077','6312000'),
        T_TIPO_DATA('5175465','PP084','6312000'),
        T_TIPO_DATA('5175467','PP084','6312000'),
        T_TIPO_DATA('5175433','PP077','6312000'),
        T_TIPO_DATA('5175434','PP077','6312000'),
        T_TIPO_DATA('5175435','PP077','6312000'),
        T_TIPO_DATA('5175436','PP077','6312010'),
        T_TIPO_DATA('5175468','PP084','6312000'),
        T_TIPO_DATA('5175469','PP084','6312000'),
        T_TIPO_DATA('5175437','PP077','6312000'),
        T_TIPO_DATA('5175470','PP084','6312000'),
        T_TIPO_DATA('5175438','PP077','6312000'),
        T_TIPO_DATA('5177513','PP077','6312000'),
        T_TIPO_DATA('5177515','PP077','6312000'),
        T_TIPO_DATA('5177516','PP077','6312000'),
        T_TIPO_DATA('5177527','PP077','6312000'),
        T_TIPO_DATA('5177528','PP077','6312000'),
        T_TIPO_DATA('5177622','PP077','6312000'),
        T_TIPO_DATA('5177624','PP077','6312000'),
        T_TIPO_DATA('5177645','PP077','6312000'),
        T_TIPO_DATA('5177646','PP077','6312000'),
        T_TIPO_DATA('5177650','PP077','6312000'),
        T_TIPO_DATA('5177654','PP077','6312000'),
        T_TIPO_DATA('5177656','PP077','6312000'),
        T_TIPO_DATA('5177657','PP077','6312000'),
        T_TIPO_DATA('5177659','PP077','6312000'),
        T_TIPO_DATA('5177661','PP077','6312000'),
        T_TIPO_DATA('5177662','PP077','6312000'),
        T_TIPO_DATA('5177682','PP077','6312000'),
        T_TIPO_DATA('5177684','PP077','6312000'),
        T_TIPO_DATA('5177688','PP077','6312000'),
        T_TIPO_DATA('5177689','PP077','6312000'),
        T_TIPO_DATA('5177690','PP077','6312000'),
        T_TIPO_DATA('5177699','PP077','6312000'),
        T_TIPO_DATA('5177712','PP077','6312000'),
        T_TIPO_DATA('5177713','PP077','6312000'),
        T_TIPO_DATA('5177715','PP077','6312000'),
        T_TIPO_DATA('5177716','PP077','6312000'),
        T_TIPO_DATA('5177721','PP077','6312000'),
        T_TIPO_DATA('5177724','PP077','6312000'),
        T_TIPO_DATA('5177725','PP077','6312000'),
        T_TIPO_DATA('5177728','PP077','6312000'),
        T_TIPO_DATA('5177729','PP077','6312000'),
        T_TIPO_DATA('5177730','PP077','6312000'),
        T_TIPO_DATA('5177731','PP077','6312000'),
        T_TIPO_DATA('5177732','PP077','6312000'),
        T_TIPO_DATA('5177748','PP077','6312000'),
        T_TIPO_DATA('5177751','PP077','6312000'),
        T_TIPO_DATA('5177752','PP077','6312000'),
        T_TIPO_DATA('5177336','PP077','6312000'),
        T_TIPO_DATA('5177363','PP077','6312000'),
        T_TIPO_DATA('5177366','PP077','6312000'),
        T_TIPO_DATA('5177380','PP077','6312000'),
        T_TIPO_DATA('5177383','PP077','6312000'),
        T_TIPO_DATA('5177384','PP077','6312000'),
        T_TIPO_DATA('5177385','PP077','6312000'),
        T_TIPO_DATA('5177386','PP077','6312000'),
        T_TIPO_DATA('5177387','PP077','6312000'),
        T_TIPO_DATA('5177388','PP077','6312000'),
        T_TIPO_DATA('5177390','PP077','6312000'),
        T_TIPO_DATA('5180348',null,'6312010'),
        T_TIPO_DATA('5180349',null,'6312018'),
        T_TIPO_DATA('5180350',null,'6312009'),
        T_TIPO_DATA('5180353',null,'6312010'),
        T_TIPO_DATA('5180355',null,'6312010'),
        T_TIPO_DATA('5180356',null,'6312010'),
        T_TIPO_DATA('5180357',null,'6312009'),
        T_TIPO_DATA('5180358',null,'6312010'),
        T_TIPO_DATA('5180359',null,'6312010'),
        T_TIPO_DATA('5180360',null,'6312018'),
        T_TIPO_DATA('5180361',null,'6312018'),
        T_TIPO_DATA('5180363',null,'6312016'),
        T_TIPO_DATA('5180364','PP075','6312008'),
        T_TIPO_DATA('5180365',null,'6312016'),
        T_TIPO_DATA('5180366',null,'6312009'),
        T_TIPO_DATA('5180367',null,'6312018'),
        T_TIPO_DATA('5180368',null,'6312010'),
        T_TIPO_DATA('5180369',null,'6312010'),
        T_TIPO_DATA('5180370',null,'6312018'),
        T_TIPO_DATA('5180371',null,'6312009'),
        T_TIPO_DATA('5180373',null,'6312008'),
        T_TIPO_DATA('5180374',null,'6312008'),
        T_TIPO_DATA('5180424',null,'6312018'),
        T_TIPO_DATA('5180425',null,'6312018'),
        T_TIPO_DATA('5180426',null,'6312018'),
        T_TIPO_DATA('5180427',null,'6312010'),
        T_TIPO_DATA('5180435',null,'6312010'),
        T_TIPO_DATA('5180436',null,'6312018'),
        T_TIPO_DATA('5180437',null,'6312010'),
        T_TIPO_DATA('5180438',null,'6312018'),
        T_TIPO_DATA('5180439',null,'6312018'),
        T_TIPO_DATA('5180440',null,'6312018'),
        T_TIPO_DATA('5180441',null,'6312010'),
        T_TIPO_DATA('5180442',null,'6312010'),
        T_TIPO_DATA('5180443',null,'6312018'),
        T_TIPO_DATA('5180444',null,'6312018'),
        T_TIPO_DATA('5180445',null,'6312010'),
        T_TIPO_DATA('5180447',null,'6312009'),
        T_TIPO_DATA('5180448',null,'6312018'),
        T_TIPO_DATA('5180449',null,'6312009'),
        T_TIPO_DATA('5180450',null,'6312010'),
        T_TIPO_DATA('5180451',null,'6312010'),
        T_TIPO_DATA('5180452',null,'6312018'),
        T_TIPO_DATA('5180453',null,'6312010'),
        T_TIPO_DATA('5180739',null,'6312010'),
        T_TIPO_DATA('5180740',null,'6312018'),
        T_TIPO_DATA('5180741',null,'6312018'),
        T_TIPO_DATA('5180742',null,'6312010'),
        T_TIPO_DATA('5180743',null,'6312010'),
        T_TIPO_DATA('5180744',null,'6312018'),
        T_TIPO_DATA('5180745',null,'6312018'),
        T_TIPO_DATA('5180746',null,'6312016'),
        T_TIPO_DATA('5180747',null,'6312008'),
        T_TIPO_DATA('5180748',null,'6312018'),
        T_TIPO_DATA('5180749',null,'6312009'),
        T_TIPO_DATA('5180750',null,'6312018'),
        T_TIPO_DATA('5180751',null,'6312010'),
        T_TIPO_DATA('5180752',null,'6312010'),
        T_TIPO_DATA('5180753',null,'6312018'),
        T_TIPO_DATA('5180754',null,'6312009'),
        T_TIPO_DATA('5180806',null,'6312009'),
        T_TIPO_DATA('5180807',null,'6312018'),
        T_TIPO_DATA('5180808',null,'6312010'),
        T_TIPO_DATA('5180809',null,'6312009'),
        T_TIPO_DATA('5180810',null,'6312010'),
        T_TIPO_DATA('5183210',null,'6312010'),
        T_TIPO_DATA('5183211',null,'6312010'),
        T_TIPO_DATA('5183212',null,'6312010'),
        T_TIPO_DATA('5183213',null,'6312010'),
        T_TIPO_DATA('5183214',null,'6312010'),
        T_TIPO_DATA('5183215',null,'6312010'),
        T_TIPO_DATA('5183216',null,'6312010'),
        T_TIPO_DATA('5183217',null,'6312010'),
        T_TIPO_DATA('5183218',null,'6312010'),
        T_TIPO_DATA('5183219',null,'6312010'),
        T_TIPO_DATA('5183220',null,'6312010'),
        T_TIPO_DATA('5183221',null,'6312010'),
        T_TIPO_DATA('5183222',null,'6312010'),
        T_TIPO_DATA('5183223',null,'6312010'),
        T_TIPO_DATA('5183224',null,'6312010'),
        T_TIPO_DATA('5183225',null,'6312010'),
        T_TIPO_DATA('5183226',null,'6312010'),
        T_TIPO_DATA('5183227',null,'6312010'),
        T_TIPO_DATA('5183228',null,'6312010'),
        T_TIPO_DATA('5183229',null,'6312010'),
        T_TIPO_DATA('5183230',null,'6312010'),
        T_TIPO_DATA('5183231',null,'6312010'),
        T_TIPO_DATA('5183232',null,'6312010'),
        T_TIPO_DATA('5183233',null,'6312010'),
        T_TIPO_DATA('5183234',null,'6312010'),
        T_TIPO_DATA('5183235',null,'6312010'),
        T_TIPO_DATA('5183236',null,'6312010'),
        T_TIPO_DATA('5183237',null,'6312010'),
        T_TIPO_DATA('5183238',null,'6312010'),
        T_TIPO_DATA('5183239',null,'6312010'),
        T_TIPO_DATA('5183263',null,'6312018'),
        T_TIPO_DATA('5183240',null,'6312010'),
        T_TIPO_DATA('5183241',null,'6312010'),
        T_TIPO_DATA('5183242',null,'6312010'),
        T_TIPO_DATA('5183243',null,'6312010'),
        T_TIPO_DATA('5183244',null,'6312010'),
        T_TIPO_DATA('5183245',null,'6312010'),
        T_TIPO_DATA('5183246',null,'6312010'),
        T_TIPO_DATA('5183247',null,'6312010'),
        T_TIPO_DATA('5183248',null,'6312010'),
        T_TIPO_DATA('5183249',null,'6312010'),
        T_TIPO_DATA('5183250',null,'6312010'),
        T_TIPO_DATA('5183251',null,'6312010'),
        T_TIPO_DATA('5183252',null,'6312010'),
        T_TIPO_DATA('5174545','PP075','6312000'),
        T_TIPO_DATA('5174546','PP075','6312000'),
        T_TIPO_DATA('5174559','PP054','6312000'),
        T_TIPO_DATA('5174721','PP077','6312000'),
        T_TIPO_DATA('5174722','PP054','6312000'),
        T_TIPO_DATA('5174723','PP054','6312000'),
        T_TIPO_DATA('5174724','PP054','6312000'),
        T_TIPO_DATA('5174725','PP077','6312000'),
        T_TIPO_DATA('5174726','PP077','6312000'),
        T_TIPO_DATA('5174727','PP077','6312000'),
        T_TIPO_DATA('5174768','PP077','6312000'),
        T_TIPO_DATA('5174769','PP077','6312000'),
        T_TIPO_DATA('5174770','PP077','6312000'),
        T_TIPO_DATA('5174771','PP077','6312000'),
        T_TIPO_DATA('5174772','PP077','6312000'),
        T_TIPO_DATA('5174779','PP077','6312000'),
        T_TIPO_DATA('5174780','PP077','6312000'),
        T_TIPO_DATA('5174782','PP077','6312000'),
        T_TIPO_DATA('5174783','PP077','6312000'),
        T_TIPO_DATA('5174784','PP077','6312000'),
        T_TIPO_DATA('5174786','PP054','6312000'),
        T_TIPO_DATA('5174787','PP054','6312000'),
        T_TIPO_DATA('5174788','PP054','6312000'),
        T_TIPO_DATA('5174789','PP054','6312000'),
        T_TIPO_DATA('5174790','PP054','6312000'),
        T_TIPO_DATA('5174791','PP075','6312000'),
        T_TIPO_DATA('5174792','PP075','6312000'),
        T_TIPO_DATA('5174876','PP075','6312000'),
        T_TIPO_DATA('5173631','PP075','6312000'),
        T_TIPO_DATA('5173632','PP075','6312000'),
        T_TIPO_DATA('5173633','PP077','6312000'),
        T_TIPO_DATA('5173634','PP077','6312000'),
        T_TIPO_DATA('5173635','PP077','6312000'),
        T_TIPO_DATA('5173636','PP077','6312000'),
        T_TIPO_DATA('5173637','PP077','6312000'),
        T_TIPO_DATA('5173740','PP077','6312000'),
        T_TIPO_DATA('5173741','PP075','6312000'),
        T_TIPO_DATA('5173742','PP077','6312000'),
        T_TIPO_DATA('5173870','PP054','6312000'),
        T_TIPO_DATA('5173871','PP054','6312000'),
        T_TIPO_DATA('5173872','PP077','6312000'),
        T_TIPO_DATA('5173873','PP077','6312000'),
        T_TIPO_DATA('5173874','PP077','6312000'),
        T_TIPO_DATA('5173875','PP077','6312000'),
        T_TIPO_DATA('5173876','PP075','6312000'),
        T_TIPO_DATA('5174180','PP075','6312000'),
        T_TIPO_DATA('5174580','PP084','6312000'),
        T_TIPO_DATA('5179700','PP077','6312000'),
        T_TIPO_DATA('5179710','PP077','6312000'),
        T_TIPO_DATA('5179711','PP077','6312000'),
        T_TIPO_DATA('5179752','PP077','6312000'),
        T_TIPO_DATA('5179899','PP054','6312000'),
        T_TIPO_DATA('5179309','PP054','6312000'),
        T_TIPO_DATA('5179310','PP077','6312000'),
        T_TIPO_DATA('5179311','PP054','6312000'),
        T_TIPO_DATA('5179312','PP054','6312000'),
        T_TIPO_DATA('5179313','PP077','6312000'),
        T_TIPO_DATA('5179314','PP077','6312000'),
        T_TIPO_DATA('5185189',null,'6312010'),
        T_TIPO_DATA('5185190','PP077','6312010'),
        T_TIPO_DATA('5185191','PP077','6312010'),
        T_TIPO_DATA('5185192','PP077','6312010'),
        T_TIPO_DATA('5185193',null,'6312010'),
        T_TIPO_DATA('5185194',null,'6312010'),
        T_TIPO_DATA('5185196','PP077','6312010'),
        T_TIPO_DATA('5185197','PP077','6312010'),
        T_TIPO_DATA('5185198','PP077','6312010'),
        T_TIPO_DATA('5185199','PP077','6312010'),
        T_TIPO_DATA('5185200',null,'6312018'),
        T_TIPO_DATA('5185204',null,'6312008'),
        T_TIPO_DATA('5185205',null,'6312008'),
        T_TIPO_DATA('5185207',null,'6312018'),
        T_TIPO_DATA('5185212',null,'6312016'),
        T_TIPO_DATA('5185213',null,'6312016'),
        T_TIPO_DATA('5185214',null,'6312016'),
        T_TIPO_DATA('5185215',null,'6312016'),
        T_TIPO_DATA('5185220',null,'6312010'),
        T_TIPO_DATA('5185222',null,'6312010'),
        T_TIPO_DATA('5185226',null,'6312010'),
        T_TIPO_DATA('5185227',null,'6312010'),
        T_TIPO_DATA('5185228',null,'6312010'),
        T_TIPO_DATA('5185229',null,'6312018'),
        T_TIPO_DATA('5185230',null,'6312018'),
        T_TIPO_DATA('5185231',null,'6312018'),
        T_TIPO_DATA('5185232',null,'6312018'),
        T_TIPO_DATA('5185233',null,'6312018'),
        T_TIPO_DATA('5185234',null,'6312018'),
        T_TIPO_DATA('5185235',null,'6312018'),
        T_TIPO_DATA('5185236',null,'6312018'),
        T_TIPO_DATA('5185237',null,'6312018'),
        T_TIPO_DATA('5185238',null,'6312018'),
        T_TIPO_DATA('5185239',null,'6312018'),
        T_TIPO_DATA('5185240',null,'6312018'),
        T_TIPO_DATA('5185241',null,'6312018'),
        T_TIPO_DATA('5185325','PP077','6312010'),
        T_TIPO_DATA('5185326','PP077','6312010'),
        T_TIPO_DATA('5185327','PP077','6312010'),
        T_TIPO_DATA('5185386',null,'6312016'),
        T_TIPO_DATA('5185416',null,'6312010'),
        T_TIPO_DATA('5185417',null,'6312018'),
        T_TIPO_DATA('5185418',null,'6312018'),
        T_TIPO_DATA('5185419',null,'6312018'),
        T_TIPO_DATA('5185420',null,'6312018'),
        T_TIPO_DATA('5185421',null,'6312018'),
        T_TIPO_DATA('5185422',null,'6312018'),
        T_TIPO_DATA('5185423',null,'6312018'),
        T_TIPO_DATA('5185424',null,'6312018'),
        T_TIPO_DATA('5185425',null,'6312018'),
        T_TIPO_DATA('5185426',null,'6312018')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE WHERE GLD_ID ='''||V_TMP_TIPO_DATA(1)||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
        
        IF V_NUM_TABLAS > 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO]: LINEA DE DETALLE '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADA');
            
            V_MSQL :='UPDATE '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE SET 
                    GLD_CPP_BASE = '''||V_TMP_TIPO_DATA(2)||''',
                    GLD_CCC_BASE = '''||V_TMP_TIPO_DATA(3)||''',
                    USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    FECHAMODIFICAR = SYSDATE 
                    WHERE GLD_ID = '''||V_TMP_TIPO_DATA(1)||''' ';

            EXECUTE IMMEDIATE V_MSQL;

        ELSE          

            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA LINEA DE DETALLE: '''||V_TMP_TIPO_DATA(1)||''' ');

        END IF;

    END LOOP;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/
EXIT
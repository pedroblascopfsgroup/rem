--/*
--##########################################
--## AUTOR=Matias Garcia-Argudo
--## FECHA_CREACION=20181219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4940
--## PRODUCTO=NO
--## Finalidad: Inserta y elimina registros en la tabla CMU_CONFIG_MUNICIPIOS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
set linesize 2000
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_SQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar.
   V_MSQL VARCHAR2(32000 CHAR); -- Contador de apariciones en una tabla.    
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

   V_DDNAME VARCHAR2(50 CHAR):= 'DD_LOC_LOCALIDAD';
   V_TABLE VARCHAR2(50 CHAR):= 'CMU_CONFIG_MUNICIPIOS'; -- Nombre de la tabla
   COUNTER NUMBER(10):=0;  -- Vble. para validar la existencia de una tabla.
    --Valores a insertar
    TYPE T_TIPO IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
      T_TIPO('8001'), T_TIPO('8003'), T_TIPO('8006'), T_TIPO('8007'), T_TIPO('8009'), T_TIPO('8011'), T_TIPO('8015'), T_TIPO('8019'), T_TIPO('8020'), T_TIPO('8022'), T_TIPO('8029'), T_TIPO('8030'), T_TIPO('8031'), T_TIPO('8032'), T_TIPO('8033'),
      T_TIPO('8035'), T_TIPO('8037'), T_TIPO('8040'), T_TIPO('8041'), T_TIPO('8041'), T_TIPO('8046'), T_TIPO('8047'), T_TIPO('8051'), T_TIPO('8054'), T_TIPO('8056'), T_TIPO('8067'), T_TIPO('8068'), T_TIPO('8072'), T_TIPO('8073'), T_TIPO('8074'), T_TIPO('8076'),
      T_TIPO('8077'), T_TIPO('8086'), T_TIPO('8088'), T_TIPO('8089'), T_TIPO('8091'), T_TIPO('8092'), T_TIPO('8096'), T_TIPO('8098'), T_TIPO('8100'), T_TIPO('8101'), T_TIPO('8102'), T_TIPO('8105'), T_TIPO('8106'), T_TIPO('8107'), T_TIPO('8108'), T_TIPO('8110'), T_TIPO('8112'), T_TIPO('8112'), T_TIPO('8113'), T_TIPO('8114'), T_TIPO('8115'), T_TIPO('8117'),
      T_TIPO('8118'), T_TIPO('8120'), T_TIPO('8121'), T_TIPO('8123'), T_TIPO('8124'), T_TIPO('8125'), T_TIPO('8126'), T_TIPO('8135'), T_TIPO('8136'), T_TIPO('8141'), T_TIPO('8143'), T_TIPO('8147'), T_TIPO('8155'), T_TIPO('8156'), T_TIPO('8157'), T_TIPO('8158'), T_TIPO('8159'), T_TIPO('8161'), T_TIPO('8163'), T_TIPO('8167'), T_TIPO('8169'), T_TIPO('8172'),
      T_TIPO('8180'), T_TIPO('8181'), T_TIPO('8184'), T_TIPO('8187'), T_TIPO('8191'), T_TIPO('8194'), T_TIPO('8196'), T_TIPO('8197'), T_TIPO('8200'), T_TIPO('8202'), T_TIPO('8204'), T_TIPO('8205'), T_TIPO('8208'), T_TIPO('8209'), T_TIPO('8211'),
      T_TIPO('8211'), T_TIPO('8213'), T_TIPO('8214'), T_TIPO('8217'), T_TIPO('8218'), T_TIPO('8219'), T_TIPO('8221'), T_TIPO('8230'), T_TIPO('8231'), T_TIPO('8235'), T_TIPO('8238'), T_TIPO('8240'), T_TIPO('8244'), T_TIPO('8245'), T_TIPO('8246'), T_TIPO('8250'), T_TIPO('8251'), T_TIPO('8252'), T_TIPO('8260'),
      T_TIPO('8261'), T_TIPO('8262'), T_TIPO('8263'), T_TIPO('8264'), T_TIPO('8266'), T_TIPO('8267'), T_TIPO('8270'), T_TIPO('8270'), T_TIPO('8274'), T_TIPO('8279'), T_TIPO('8281'), T_TIPO('8282'), T_TIPO('8283'), T_TIPO('8284'), T_TIPO('8285'), T_TIPO('8289'), T_TIPO('8295'), T_TIPO('8298'), T_TIPO('8300'), T_TIPO('8301'), T_TIPO('8302'), T_TIPO('8305'),
      T_TIPO('8307'), T_TIPO('8904'), T_TIPO('8905'), T_TIPO('17015'), T_TIPO('17015'), T_TIPO('17019'), T_TIPO('17022'), T_TIPO('17023'), T_TIPO('17034'), T_TIPO('17047'), T_TIPO('17048'), T_TIPO('17056'), T_TIPO('17062'), T_TIPO('17066'), T_TIPO('17073'), T_TIPO('17079'), T_TIPO('17089'), T_TIPO('17092'), T_TIPO('17095'), T_TIPO('17110'), T_TIPO('17114'), T_TIPO('17117'), T_TIPO('17118'), T_TIPO('17137'),
      T_TIPO('17141'), T_TIPO('17147'), T_TIPO('17152'), T_TIPO('17155'), T_TIPO('17160'), T_TIPO('17163'), T_TIPO('17167'), T_TIPO('17169'), T_TIPO('17180'), T_TIPO('17181'), T_TIPO('17182'), T_TIPO('17185'), T_TIPO('17186'), T_TIPO('17199'), T_TIPO('17202'), T_TIPO('17215'), T_TIPO('17221'), T_TIPO('17226'), T_TIPO('25003'), T_TIPO('25011'), T_TIPO('25012'), T_TIPO('25016'),
      T_TIPO('25019'), T_TIPO('25021'), T_TIPO('25027'), T_TIPO('25034'), T_TIPO('25040'), T_TIPO('25050'), T_TIPO('25051'), T_TIPO('25058'), T_TIPO('25072'), T_TIPO('25093'), T_TIPO('25099'), T_TIPO('25110'), T_TIPO('25120'), T_TIPO('25135'), T_TIPO('25137'), T_TIPO('25158'), T_TIPO('25171'), T_TIPO('25172'), T_TIPO('25173'), T_TIPO('25203'), T_TIPO('25207'), T_TIPO('25209'), T_TIPO('25217'), T_TIPO('25234'), T_TIPO('25243'), T_TIPO('25244'), T_TIPO('43004'), T_TIPO('43011'), T_TIPO('43012'),
      T_TIPO('43014'), T_TIPO('43016'), T_TIPO('43037'), T_TIPO('43038'), T_TIPO('43042'), T_TIPO('43044'), T_TIPO('43047'), T_TIPO('43051'), T_TIPO('43055'), T_TIPO('43060'), T_TIPO('43064'), T_TIPO('43086'), T_TIPO('43092'), T_TIPO('43093'), T_TIPO('43094'), T_TIPO('43100'), T_TIPO('43104'), T_TIPO('43123'), T_TIPO('43131'), T_TIPO('43133'), T_TIPO('43136'), T_TIPO('43136'), T_TIPO('43138'), T_TIPO('43139'), T_TIPO('43145'), T_TIPO('43148'), T_TIPO('43153'), T_TIPO('43155'), T_TIPO('43156'), T_TIPO('43161'), T_TIPO('43163'),
      T_TIPO('43163'), T_TIPO('43171'), T_TIPO('43171'), T_TIPO('43904'), T_TIPO('43905'), T_TIPO('43905'), T_TIPO('43907')); 
    V_TMP_TIPO T_TIPO;
  
BEGIN

  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLE||''' AND OWNER = '''||V_ESQUEMA||''' ';
  execute immediate V_SQL into COUNTER;

  IF COUNTER > 0 THEN

  V_SQL  := 'UPDATE '||V_ESQUEMA||'.'|| V_TABLE ||' SET BORRADO = 1 WHERE DD_LOC_ID NOT IN (SELECT LOC.DD_LOC_ID FROM '||V_ESQUEMA_M||'.'||V_DDNAME||' LOC WHERE LOC.DD_LOC_CODIGO IN (''08001'',''08003'',''08006'',''08007'',''08009'',''08011'',''08015'',''08019'',''08020'',
''08022'',''08029'',''08030'',''08031'',''08032'',''08033'',''08035'',''08037'',''08040'',''08041'',''08041'',''08046'',''08047'',''08051'',''08054'',
''08056'',''08067'',''08068'',''08072'',''08073'',''08074'',''08076'',''08077'',''08086'',''08088'',''08089'',''08091'',''08092'',''08096'',''08098'',''08100'',''08101'',''08102'',''08105'',''08106'',''08107'',''08108'',''08110'',''08112'',''08112'',''08113'',
''08114'',''08115'',''08117'',''08118'',''08120'',''08121'',''08123'',''08124'',''08125'',''08126'',''08135'',''08136'',''08141'',''08143'',''08147'',''08155'',''08156'',''08157'',''08158'',''08159'',''08161'',''08163'',''08167'',''08169'',''08172'',''08180'',
''08181'',''08184'',''08187'',''08191'',''08194'',''08196'',''08197'',''08200'',''08202'',''08204'',''08205'',''08208'',''08209'',''08211'',''08211'',''08213'',''08214'',''08217'',''08218'',''08219'',''08221'',''08230'',''08231'',''08235'',''08238'',''08240'',
''08244'',''08245'',''08246'',''08250'',''08251'',''08252'',''08260'',''08261'',''08262'',''08263'',''08264'',''08266'',''08267'',''08270'',''08270'',''08274'',''08279'',''08281'',''08282'',''08283'',''08284'',''08285'',''08289'',''08295'',''08298'',''08300'',
''08301'',''08302'',''08305'',''08307'',''08904'',''08905'',''107015'',''107015'',''107019'',''107022'',''107023'',''107034'',''107047'',''107048'',''107056'',''107062'',''107066'',''107073'',''107079'',''107089'',''107092'',''107095'',''107110'',''107114'',
''107117'',''107118'',''107137'',''107141'',''107147'',''107152'',''107155'',''107160'',''107163'',''107167'',''107169'',''107180'',''107181'',''107182'',''107185'',''107186'',''107199'',''107202'',''107215'',''107221'',''107226'',''205003'',''205011'',
''205012'',''205016'',''205019'',''205021'',''205027'',''205034'',''205040'',''205050'',''205051'',''205058'',''205072'',''205093'',''205099'',''205110'',''205120'',''205135'',''205137'',''205158'',''205171'',''205172'',''205173'',''205203'',''205207'',
''205209'',''205217'',''205234'',''205243'',''205244'',''403004'',''403011'',''403012'',''403014'',''403016'',''403037'',''403038'',''403042'',''403044'',''403047'',''403051'',''403055'',''403060'',''403064'',''403086'',''403092'',''403093'',''403094'',
''403100'',''403104'',''403123'',''403131'',''403133'',''403136'',''403136'',''403138'',''403139'',''403145'',''403148'',''403153'',''403155'',''403156'',''403161'',''403163'',''403163'',''403171'',''403171'',''403904'',''403905'',''403905'',''403907''))';

  execute immediate V_SQL;
  -- LOOP Insertando valores en la tabla del diccionario
  DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'|| V_TABLE ||'... Empezando a insertar datos en la tabla');
  FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
  LOOP
    V_TMP_TIPO := V_TIPO(I);
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLE||' WHERE DD_LOC_ID = (SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.'||V_DDNAME||' WHERE DD_LOC_CODIGO = '||V_TMP_TIPO(1)||')';

    execute immediate V_SQL into V_MSQL;

    IF V_MSQL < 1 THEN
      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE||' (CMU_ID, DD_LOC_ID, USUARIOCREAR, FECHACREAR)
      SELECT '||V_ESQUEMA||'.S_CMU_CONFIG_MUNICIPIOS.NEXTVAL, DD_LOC_ID, ''HREOS-4940'', SYSDATE FROM '||V_ESQUEMA_M||'.'||V_DDNAME||' WHERE DD_LOC_CODIGO = '||V_TMP_TIPO(1)||' ';

      execute immediate V_SQL;
    END IF;
  END LOOP;

  END IF;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_DDNAME ||'... Datos del diccionario insertado');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
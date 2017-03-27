--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170323
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1683
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_GES_DIST_GESTORES los datos añadidos en T_ARRAY_DATA
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- TGE		 CRA	EAC	  TCR	PRV	 LOC POSTAL	USERNAME
-- BANKIA - GESTOR COMERCIAL - RETAIL
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '1'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '2'  ,''  ,''  ,'mperezd'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '3'  ,''  ,''  ,'egomezm'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '4'  ,''  ,''  ,'jbarbero'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '5'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '6'  ,''  ,''  ,'polid'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '7'  ,''  ,''  ,'ccapdevila'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '8'  ,''  ,''  ,'afraile'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '9'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '10'  ,''  ,''  ,'polid'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '11'  ,''  ,''  ,'polid'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '12'  ,''  ,''  ,'ccapdevila'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '13'  ,''  ,''  ,'psm'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '14'  ,''  ,''  ,'jbarbero'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '15'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '16'  ,''  ,''  ,'mperezd'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '17'  ,''  ,''  ,'dvicente'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '18'  ,''  ,''  ,'jbarbero'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '19'  ,''  ,''  ,'mperezd'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '20'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '21'  ,''  ,''  ,'polid'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '22'  ,''  ,''  ,'ksteiert'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '23'  ,''  ,''  ,'jbarbero'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '24'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '25'  ,''  ,''  ,'dvicente'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '26'  ,''  ,''  ,'ksteiert'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '27'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '28'  ,''  ,''  ,'ksteiert'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '29'  ,''  ,''  ,'jbarbero'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '30'  ,''  ,''  ,'slopeza'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '31'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '32'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '33'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '34'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,''  ,''  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '36'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '37'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '38'  ,''  ,''  ,'mgarciap'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '39'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '40'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '41'  ,''  ,''  ,'polid'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '42'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '43'  ,''  ,''  ,'jsoler'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '44'  ,''  ,''  ,'ksteiert'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '45'  ,''  ,''  ,'mperezd'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,''  ,''  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '47'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '48'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '49'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '50'  ,''  ,''  ,'ksteiert'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '51'  ,''  ,''  ,'polid'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '52'  ,''  ,''  ,'jbarbero'),
-- SAREB - GESTOR COMERCIAL - RETAIL
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '1'  ,''  ,''  ,'jgarciamoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '2'  ,''  ,''  ,'lopezgasco'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '3'  ,''  ,''  ,'droncero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '4'  ,''  ,''  ,'tpg'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '5'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '6'  ,''  ,''  ,'ataboadaa'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '7'  ,''  ,''  ,'mruiz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '8'  ,''  ,''  ,'mpoblet'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '9'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '10'  ,''  ,''  ,'ataboadaa'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '11'  ,''  ,''  ,'ataboadaa'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '12'  ,''  ,''  ,'mruiz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '13'  ,''  ,''  ,'montanon'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '14'  ,''  ,''  ,'ataboadaa'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '15'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '16'  ,''  ,''  ,'lopezgasco'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '17'  ,''  ,''  ,'mpoblet'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '18'  ,''  ,''  ,'tpg'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '19'  ,''  ,''  ,'montanon'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '20'  ,''  ,''  ,'jgarciamoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '21'  ,''  ,''  ,'ataboadaa'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '22'  ,''  ,''  ,'jgarciamoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '23'  ,''  ,''  ,'tpg'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '24'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '25'  ,''  ,''  ,'mpoblet'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '26'  ,''  ,''  ,'jgarciamoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '27'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '28'  ,''  ,''  ,'montanon'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '29'  ,''  ,''  ,'tpg'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '30'  ,''  ,''  ,'jalmansa'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '31'  ,''  ,''  ,'jgarciamoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '32'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '33'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '34'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '35'  ,''  ,''  ,'dgonzalezq'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '36'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '37'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '38'  ,''  ,''  ,'dgonzalezq'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '39'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '40'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '41'  ,''  ,''  ,'ataboadaa'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '42'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '43'  ,''  ,''  ,'mpoblet'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '44'  ,''  ,''  ,'jgarciamoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '45'  ,''  ,''  ,'lopezgasco'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '46'  ,''  ,''  ,'mruiz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '47'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '48'  ,''  ,''  ,'jgarciamoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '49'  ,''  ,''  ,'avegas'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '50'  ,''  ,''  ,'jgarciamoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '51'  ,''  ,''  ,'ataboadaa'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'02'  , '52'  ,''  ,''  ,'tpg'),
-- BANKIA - GESTOR COMERCIAL - SINGULAR
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '1'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '2'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '3'  ,''  ,''  ,'mii'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '4'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '5'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '6'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '7'  ,''  ,''  ,'mii'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '8'  ,''  ,''  ,'lmunoz'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '9'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '10'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '11'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '12'  ,''  ,''  ,'mii'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '13'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '14'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '15'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '16'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '17'  ,''  ,''  ,'lmunoz'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '18'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '19'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '20'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '21'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '22'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '23'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '24'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '25'  ,''  ,''  ,'lmunoz'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '26'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '27'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '28'  ,''  ,''  ,'mii'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '29'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '30'  ,''  ,''  ,'mii'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '31'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '32'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '33'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '34'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '35'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '36'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '37'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '38'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '39'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '40'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '41'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '42'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '43'  ,''  ,''  ,'lmunoz'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '44'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '45'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '46'  ,''  ,''  ,'mii'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '47'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '48'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '49'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '50'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '51'  ,''  ,''  ,'enavarro'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'01'  , '52'  ,''  ,''  ,'enavarro'),
-- SAREB - GESTOR COMERCIAL - SINGULAR	
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '1'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '2'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '3'  ,''  ,''  ,'ivazquez'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '4'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '5'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '6'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '7'  ,''  ,''  ,'ivazquez'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '8'  ,''  ,''  ,'lmunoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '9'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '10'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '11'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '12'  ,''  ,''  ,'amartinez'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '13'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '14'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '15'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '16'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '17'  ,''  ,''  ,'lmunoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '18'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '19'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '20'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '21'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '22'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '23'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '24'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '25'  ,''  ,''  ,'lmunoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '26'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '27'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '28'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '29'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '30'  ,''  ,''  ,'ivazquez'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '31'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '32'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '33'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '34'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '35'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '36'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '37'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '38'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '39'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '40'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '41'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '42'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '43'  ,''  ,''  ,'lmunoz'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '44'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '45'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '46'  ,''  ,''  ,'amartinez'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '47'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '48'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '49'  ,''  ,''  ,'acabanir'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '50'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '51'  ,''  ,''  ,'gromero'),
		T_TIPO_DATA('GCOM'  ,'02'  ,''  ,'01'  , '52'  ,''  ,''  ,'gromero'),
-- CAJAMAR - GESTOR COMERCIAL - RETAIL
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '1'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '2'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '3'  ,''  ,''  ,'jvila'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '4'  ,''  ,''  ,'falonsor'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '5'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '6'  ,''  ,''  ,'egalan'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '7'  ,''  ,''  ,'tbuendia'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '8'  ,''  ,''  ,'tbuendia'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '9'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '10'  ,''  ,''  ,'egalan'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '11'  ,''  ,''  ,'falonsor'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '12'  ,''  ,''  ,'jvila'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '13'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '14'  ,''  ,''  ,'egalan'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '15'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '16'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '17'  ,''  ,''  ,'tbuendia'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '18'  ,''  ,''  ,'alirola'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '19'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '20'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '21'  ,''  ,''  ,'egalan'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '22'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '23'  ,''  ,''  ,'alirola'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '24'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '25'  ,''  ,''  ,'tbuendia'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '26'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '27'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '28'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '29'  ,''  ,''  ,'falonsor'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '30'  ,''  ,''  ,'falonsor'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '31'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '32'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '33'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '34'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '35'  ,''  ,''  ,'ecabrera'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '36'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '37'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '38'  ,''  ,''  ,'ecabrera'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '39'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '40'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '41'  ,''  ,''  ,'egalan'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '42'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '43'  ,''  ,''  ,'tbuendia'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '44'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '45'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,''  ,''  ,'jvila'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '47'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '48'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '49'  ,''  ,''  ,'kbajo'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '50'  ,''  ,''  ,'msanchezf'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '51'  ,''  ,''  ,'rdelaplaza'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '52'  ,''  ,''  ,'rdelaplaza'),
-- CAJAMAR - GESTOR COMERCIAL - SINGULAR			
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '1'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '2'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '3'  ,''  ,''  ,'aalonso'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '4'  ,''  ,''  ,'lguillen'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '5'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '6'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '7'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '8'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '9'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '10'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '11'  ,''  ,''  ,'pblanco'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '12'  ,''  ,''  ,'hgimenez'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '13'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '14'  ,''  ,''  ,'pblanco'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '15'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '16'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '17'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '18'  ,''  ,''  ,'aalonso'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '19'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '20'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '21'  ,''  ,''  ,'pblanco'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '22'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '23'  ,''  ,''  ,'aalonso'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '24'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '25'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '26'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '27'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '28'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '29'  ,''  ,''  ,'pblanco'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '30'  ,''  ,''  ,'aalonso'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '31'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '32'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '33'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '34'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '35'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '36'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '37'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '38'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '39'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '40'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '41'  ,''  ,''  ,'pblanco'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '42'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '43'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '44'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '45'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '46'  ,''  ,''  ,'hgimenez'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '47'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '48'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '49'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '50'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '51'  ,''  ,''  ,'mtugores'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'01'  , '52'  ,''  ,''  ,'mtugores')
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO IS NULL '||
					' AND COD_POSTAL IS NULL ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = ''HREOS-1683'' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO IS NULL '||
					' AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA PROVINCIA: '||TRIM(V_TMP_TIPO_DATA(5)));
          
       --Si no existe, lo insertamos   
       ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(4)||''','||V_TMP_TIPO_DATA(5)||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, ''HREOS-1683'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA PROVINCIA: '||TRIM(V_TMP_TIPO_DATA(5)));
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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

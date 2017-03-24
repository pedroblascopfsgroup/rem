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
    
    -- Array para insertar el cod_estado_activo y distinguir entre TERMINADO/NO TERMINADO
    TYPE T_TIPO_ESTADO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_ESTADO IS TABLE OF T_TIPO_ESTADO;
    V_TIPO_ESTADO T_ARRAY_ESTADO := T_ARRAY_ESTADO(
   	--				ESTADO_ACTIVO	Indicador Terminado/No terminado
   		T_TIPO_ESTADO('01'			,'2'),
		T_TIPO_ESTADO('02'			,'0'),
		T_TIPO_ESTADO('03'			,'1'),
		T_TIPO_ESTADO('04'			,'1'),
		T_TIPO_ESTADO('05'			,'1')
    ); 
    V_TMP_TIPO_ESTADO T_TIPO_ESTADO;

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		--  	TGE	   CRA	Terminado  TCR	PRV	 LOC  POSTAL	USERNAME
-- BANKIA - GESTOR ACTIVOS - TERMINADO 
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '1'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '2'  ,''  ,''  ,'ckuhnel'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '3'  ,''  ,''  ,'rdl'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '4'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '5'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '6'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '7'  ,''  ,''  ,'rdl'),
		
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '9'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '10'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '11'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '12'  ,''  ,''  ,'rdura'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '13'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '14'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '15'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '16'  ,''  ,''  ,'nhorcajo'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '17'  ,''  ,''  ,'jberenguer'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '18'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '19'  ,''  ,''  ,'ckuhnel'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '20'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '21'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '22'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '23'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '24'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '25'  ,''  ,''  ,'jberenguer'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '26'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '27'  ,''  ,''  ,'agonzaleza'),
		
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '29'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '30'  ,''  ,''  ,'ckuhnel'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '31'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '32'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '33'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '34'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '35'  ,''  ,''  ,'ckuhnel'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '36'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '37'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '38'  ,''  ,''  ,'nhorcajo'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '39'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '40'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '41'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '42'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '43'  ,''  ,''  ,'adelaroja'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '44'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '45'  ,''  ,''  ,'nhorcajo'),
		
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '47'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '48'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '49'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '50'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '51'  ,''  ,''  ,'nhorcajo'),
		T_TIPO_DATA('GACT'  ,'03'  ,'1'  ,''  , '52'  ,''  ,''  ,'aruiza'),
-- SAREB - GESTOR ACTIVOS - TERMINADO
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '1'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '2'  ,''  ,''  ,'ckuhnel'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '3'  ,''  ,''  ,'rdl'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '4'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '5'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '6'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '7'  ,''  ,''  ,'rdl'),
		
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '9'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '10'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '11'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '12'  ,''  ,''  ,'rdura'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '13'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '14'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '15'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '16'  ,''  ,''  ,'nhorcajo'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '17'  ,''  ,''  ,'jberenguer'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '18'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '19'  ,''  ,''  ,'ckuhnel'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '20'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '21'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '22'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '23'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '24'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '25'  ,''  ,''  ,'jberenguer'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '26'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '27'  ,''  ,''  ,'agonzaleza'),
		
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '29'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '30'  ,''  ,''  ,'ckuhnel'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '31'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '32'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '33'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '34'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '35'  ,''  ,''  ,'ckuhnel'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '36'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '37'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '38'  ,''  ,''  ,'nhorcajo'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '39'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '40'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '41'  ,''  ,''  ,'aruiza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '42'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '43'  ,''  ,''  ,'adelaroja'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '44'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '45'  ,''  ,''  ,'nhorcajo'),
		
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '47'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '48'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '49'  ,''  ,''  ,'gmoreno'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '50'  ,''  ,''  ,'agonzaleza'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '51'  ,''  ,''  ,'nhorcajo'),
		T_TIPO_DATA('GACT'  ,'02'  ,'1'  ,''  , '52'  ,''  ,''  ,'aruiza'),
-- BANKIA - GESTOR ACTIVOS - NO TERMINADO
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '1'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '2'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '3'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '4'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '5'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '6'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '7'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '8'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '9'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '10'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '11'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '12'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '13'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '14'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '15'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '16'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '17'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '18'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '19'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '20'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '21'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '22'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '23'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '24'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '25'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '26'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '27'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '28'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '29'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '30'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '31'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '32'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '33'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '34'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '35'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '36'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '37'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '38'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '39'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '40'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '41'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '42'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '43'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '44'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '45'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '46'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '47'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '48'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '49'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '50'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '51'  ,''  ,''  ,'bcarrascos'),
		T_TIPO_DATA('GACT'  ,'03'  ,'0'  ,''  , '52'  ,''  ,''  ,'bcarrascos'),
-- SAREB - GESTOR ACTIVOS - NO TERMINADO
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '1'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '2'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '3'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '4'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '5'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '6'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '7'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '8'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '9'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '10'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '11'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '12'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '13'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '14'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '15'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '16'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '17'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '18'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '19'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '20'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '21'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '22'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '23'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '24'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '25'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '26'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '27'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '28'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '29'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '30'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '31'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '32'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '33'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '34'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '35'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '36'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '37'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '38'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '39'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '40'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '41'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '42'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '43'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '44'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '45'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '46'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '47'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '48'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '49'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '50'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '51'  ,''  ,''  ,'csalvador'),
		T_TIPO_DATA('GACT'  ,'02'  ,'0'  ,''  , '52'  ,''  ,''  ,'csalvador'),
-- CAJAMAR - GESTOR ACTIVOS - TERMINADO		
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '1'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '2'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '3'  ,''  ,''  ,'mgarciade'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '4'  ,''  ,''  ,'mperez'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '5'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '6'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '7'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '8'  ,''  ,''  ,'mperez'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '9'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '10'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '11'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '12'  ,''  ,''  ,'mgarciade'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '13'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '14'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '15'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '16'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '17'  ,''  ,''  ,'mperez'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '18'  ,''  ,''  ,'mperez'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '19'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '20'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '21'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '22'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '23'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '24'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '25'  ,''  ,''  ,'mperez'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '26'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '27'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '28'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '29'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '30'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '31'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '32'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '33'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '34'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '35'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '36'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '37'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '38'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '39'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '40'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '41'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '42'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '43'  ,''  ,''  ,'mperez'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '44'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '45'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '46'  ,''  ,''  ,'mgarciade'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '47'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '48'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '49'  ,''  ,''  ,'mcanton'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '50'  ,''  ,''  ,'rguirado'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '51'  ,''  ,''  ,'saragon'),
		T_TIPO_DATA('GACT'  ,'01'  ,'1'  ,''  , '52'  ,''  ,''  ,'saragon'),		
-- CAJAMAR - GESTOR ACTIVOS - NO TERMINADO
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '1'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '2'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '3'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '4'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '5'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '6'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '7'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '8'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '9'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '10'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '11'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '12'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '13'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '14'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '15'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '16'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '17'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '18'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '19'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '20'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '21'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '22'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '23'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '24'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '25'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '26'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '27'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '28'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '29'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '30'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '31'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '32'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '33'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '34'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '35'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '36'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '37'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '38'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '39'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '40'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '41'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '42'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '43'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '44'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '45'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '46'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '47'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '48'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '49'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '50'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '51'  ,''  ,''  ,'jmateo'),
		T_TIPO_DATA('GACT'  ,'01'  ,'0'  ,''  , '52'  ,''  ,''  ,'jmateo'),
-- BANKIA - GESTOR ACTIVOS - SUELO
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '1'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '2'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '3'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '4'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '5'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '6'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '7'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '8'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '9'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '10'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '11'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '12'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '13'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '14'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '15'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '16'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '17'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '18'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '19'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '20'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '21'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '22'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '23'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '24'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '25'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '26'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '27'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '28'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '29'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '30'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '31'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '32'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '33'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '34'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '35'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '36'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '37'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '38'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '39'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '40'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '41'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '42'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '43'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '44'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '45'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '46'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '47'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '48'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '49'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '50'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '51'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'03'  ,'2'  ,''  , '52'  ,''  ,''  ,'jbadia'),
-- SAREB - GESTOR ACTIVOS - SUELO				
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '1'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '2'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '3'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '4'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '5'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '6'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '7'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '8'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '9'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '10'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '11'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '12'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '13'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '14'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '15'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '16'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '17'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '18'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '19'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '20'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '21'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '22'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '23'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '24'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '25'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '26'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '27'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '28'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '29'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '30'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '31'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '32'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '33'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '34'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '35'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '36'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '37'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '38'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '39'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '40'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '41'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '42'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '43'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '44'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '45'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '46'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '47'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '48'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '49'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '50'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '51'  ,''  ,''  ,'jbadia'),
		T_TIPO_DATA('GACT'  ,'02'  ,'2'  ,''  , '52'  ,''  ,''  ,'jbadia'),
-- CAJAMAR - GESTOR ACTIVOS - SUELO
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '1'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '2'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '3'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '4'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '5'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '6'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '7'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '8'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '9'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '10'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '11'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '12'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '13'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '14'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '15'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '16'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '17'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '18'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '19'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '20'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '21'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '22'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '23'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '24'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '25'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '26'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '27'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '28'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '29'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '30'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '31'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '32'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '33'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '34'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '35'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '36'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '37'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '38'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '39'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '40'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '41'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '42'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '43'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '44'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '45'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '46'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '47'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '48'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '49'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '50'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '51'  ,''  ,''  ,'mgomezp'),
		T_TIPO_DATA('GACT'  ,'01'  ,'2'  ,''  , '52'  ,''  ,''  ,'mgomezp')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        FOR X IN V_TIPO_ESTADO.FIRST .. V_TIPO_ESTADO.LAST
    	 LOOP
    	 	V_TMP_TIPO_ESTADO := V_TIPO_ESTADO(X);
    	 	
    		IF V_TMP_TIPO_DATA(3) = V_TMP_TIPO_ESTADO(2) THEN
				
    			--Comprobamos el dato a insertar
		        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
		        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
							' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
							' AND COD_ESTADO_ACTIVO = '''||TRIM(V_TMP_TIPO_ESTADO(1))||''' '||
							' AND COD_TIPO_COMERZIALZACION IS NULL '||
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
							' AND COD_ESTADO_ACTIVO = '''||TRIM(V_TMP_TIPO_ESTADO(1))||''' '||
							' AND COD_TIPO_COMERZIALZACION IS NULL '||
							' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
							' AND COD_MUNICIPIO IS NULL '||
							' AND COD_POSTAL IS NULL ';
		          EXECUTE IMMEDIATE V_MSQL;
		          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA PROVINCIA: '||TRIM(V_TMP_TIPO_DATA(5))||' y Codigo ESTADO: '||TRIM(V_TMP_TIPO_ESTADO(1)));
		          
		       --Si no existe, lo insertamos   
		       ELSE
		       
		          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
		          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
		          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
		                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
		                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
								', '||V_TMP_TIPO_DATA(2)||','''||V_TMP_TIPO_ESTADO(1)||''','''||V_TMP_TIPO_DATA(4)||''','||V_TMP_TIPO_DATA(5)||' ' ||
								', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
								', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
								', 0, ''HREOS-1683'',SYSDATE,0 FROM DUAL';
		          EXECUTE IMMEDIATE V_MSQL;
		          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA PROVINCIA: '||TRIM(V_TMP_TIPO_DATA(5))||' y Codigo ESTADO: '||TRIM(V_TMP_TIPO_ESTADO(1)));
		        
		       END IF;
    		
    		END IF;
    	 END LOOP;

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

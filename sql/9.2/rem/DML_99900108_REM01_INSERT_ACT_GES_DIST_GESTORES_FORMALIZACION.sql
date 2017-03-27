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
    			-- TGE		 CRA	EAC	  TCR	PRV	 LOC  POSTAL	USERNAME
-- BANKIA - GESTORES DE FORMALIZACIÓN
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '4'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '11'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '14'  ,''  ,''  ,'iperez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '18'  ,''  ,''  ,'iperez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '21'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '23'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '29'  ,''  ,''  ,'iperez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '41'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '22'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '44'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '50'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '33'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '7'  ,''  ,''  ,'cmartinez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '7'  ,''  ,''  ,'mlopez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '7'  ,''  ,''  ,'rcf'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '35'  ,''  ,''  ,'ebenitezt'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '35'  ,''  ,''  ,'rmoreno'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '38'  ,''  ,''  ,'ebenitezt'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '38'  ,''  ,''  ,'rmoreno'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '39'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '2'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '13'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '16'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '19'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '45'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '5'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '9'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '24'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '34'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '37'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '40'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '42'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '47'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '49'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '8'  ,''  ,''  ,'nbertran'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '8'  ,''  ,''  ,'jdella'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '8'  ,''  ,''  ,'sulldemoli'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '8'  ,''  ,''  ,'agimenez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '8'  ,''  ,''  ,'marcas'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '17'  ,''  ,''  ,'nbertran'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '17'  ,''  ,''  ,'jdella'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '17'  ,''  ,''  ,'sulldemoli'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '17'  ,''  ,''  ,'agimenez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '17'  ,''  ,''  ,'marcas'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '25'  ,''  ,''  ,'nbertran'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '25'  ,''  ,''  ,'jdella'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '25'  ,''  ,''  ,'sulldemoli'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '25'  ,''  ,''  ,'agimenez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '25'  ,''  ,''  ,'marcas'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '43'  ,''  ,''  ,'nbertran'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '43'  ,''  ,''  ,'jdella'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '43'  ,''  ,''  ,'sulldemoli'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '43'  ,''  ,''  ,'agimenez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '43'  ,''  ,''  ,'marcas'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '51'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '6'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '10'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '15'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '27'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '32'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '36'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '26'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '28'  ,''  ,''  ,'zmartin'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '28'  ,''  ,''  ,'mramos'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '52'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '30'  ,''  ,''  ,'ptranche'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '30'  ,''  ,''  ,'jcarbonell'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '31'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '1'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '20'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '48'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '3'  ,''  ,''  ,'ptranche'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '3'  ,''  ,''  ,'jcarbonell'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '12'  ,''  ,''  ,'cmartinez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '12'  ,''  ,''  ,'mlopez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '12'  ,''  ,''  ,'rcf'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '46'  ,''  ,''  ,'cmartinez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '46'  ,''  ,''  ,'mlopez'),
		T_TIPO_DATA('GFORM'  ,'03'  ,''  ,''  , '46'  ,''  ,''  ,'rcf'),
-- SAREB - GESTORES DE FORMALIZACIÓN
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '4'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '11'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '14'  ,''  ,''  ,'iperez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '18'  ,''  ,''  ,'iperez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '21'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '23'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '29'  ,''  ,''  ,'iperez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '41'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '22'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '44'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '50'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '33'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '7'  ,''  ,''  ,'cmartinez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '7'  ,''  ,''  ,'mlopez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '7'  ,''  ,''  ,'rcf'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '35'  ,''  ,''  ,'ebenitezt'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '35'  ,''  ,''  ,'rmoreno'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '38'  ,''  ,''  ,'ebenitezt'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '38'  ,''  ,''  ,'rmoreno'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '39'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '2'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '13'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '16'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '19'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '45'  ,''  ,''  ,'jespinosa'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '5'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '9'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '24'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '34'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '37'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '40'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '42'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '47'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '49'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '8'  ,''  ,''  ,'nbertran'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '8'  ,''  ,''  ,'jdella'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '8'  ,''  ,''  ,'sulldemoli'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '8'  ,''  ,''  ,'agimenez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '8'  ,''  ,''  ,'marcas'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '17'  ,''  ,''  ,'nbertran'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '17'  ,''  ,''  ,'jdella'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '17'  ,''  ,''  ,'sulldemoli'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '17'  ,''  ,''  ,'agimenez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '17'  ,''  ,''  ,'marcas'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '25'  ,''  ,''  ,'nbertran'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '25'  ,''  ,''  ,'jdella'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '25'  ,''  ,''  ,'sulldemoli'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '25'  ,''  ,''  ,'agimenez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '25'  ,''  ,''  ,'marcas'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '43'  ,''  ,''  ,'nbertran'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '43'  ,''  ,''  ,'jdella'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '43'  ,''  ,''  ,'sulldemoli'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '43'  ,''  ,''  ,'agimenez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '43'  ,''  ,''  ,'marcas'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '51'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '6'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '10'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '15'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '27'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '32'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '36'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '26'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '28'  ,''  ,''  ,'zmartin'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '28'  ,''  ,''  ,'mramos'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '52'  ,''  ,''  ,'lmillan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '30'  ,''  ,''  ,'ptranche'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '30'  ,''  ,''  ,'jcarbonell'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '31'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '1'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '20'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '48'  ,''  ,''  ,'mganan'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '3'  ,''  ,''  ,'ptranche'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '3'  ,''  ,''  ,'jcarbonell'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '12'  ,''  ,''  ,'cmartinez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '12'  ,''  ,''  ,'mlopez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '12'  ,''  ,''  ,'rcf'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '46'  ,''  ,''  ,'cmartinez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '46'  ,''  ,''  ,'mlopez'),
		T_TIPO_DATA('GFORM'  ,'02'  ,''  ,''  , '46'  ,''  ,''  ,'rcf'),	
-- CAJAMAR - GESTORES DE FORMALIZACIÓN
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '4'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '11'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '14'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '18'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '21'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '23'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '29'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '41'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '22'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '44'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '50'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '33'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '7'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '35'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '38'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '39'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '2'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '13'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '16'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '19'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '45'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '5'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '9'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '24'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '34'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '37'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '40'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '42'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '47'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '49'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '8'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '17'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '25'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '43'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '51'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '6'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '10'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '15'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '27'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '32'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '36'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '26'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '28'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '52'  ,''  ,''  ,'dvalero'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '30'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '31'  ,''  ,''  ,'mveintimil'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '1'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '20'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '48'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '3'  ,''  ,''  ,'amanas'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '12'  ,''  ,''  ,'lgl'),
		T_TIPO_DATA('GFORM'  ,'01'  ,''  ,''  , '46'  ,''  ,''  ,'lgl')
		
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
					' AND COD_TIPO_COMERZIALZACION IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO IS NULL'||
					' AND COD_POSTAL IS NULL '||
					' AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe NO hacemos nada, ni siquera UPDATE, de los cuatro datos que vienen, los 4 sirven de identificador único (Solo para gestor Formalización, es un caso especial)
        IF V_NUM_TABLAS > 0 THEN				

          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO EXISTE - NO SE HACE NADA');
          
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
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '|| TRIM(V_TMP_TIPO_DATA(5)));
        
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

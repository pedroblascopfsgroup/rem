--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170322
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
-- BANKIA - GESTORIAS DE ADMISION
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '4'   ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '11'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '14'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '18'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '21'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '23'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '29'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '41'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '22'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '44'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '50'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '33'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '7'   ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '35'  ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '38'  ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '39'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '2'   ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '13'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '16'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '19'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '45'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '5'   ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '9'   ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '24'  ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '34'  ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '37'  ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '40'  ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '42'  ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '47'  ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '49'  ,''  ,''  ,'uniges01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '8'   ,''  ,''  ,'pinos01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '17'  ,''  ,''  ,'pinos01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '25'  ,''  ,''  ,'pinos01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '43'  ,''  ,''  ,'pinos01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '51'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '6'   ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '10'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '15'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '27'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '32'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '36'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '26'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '28'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '52'  ,''  ,''  ,'gl01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '30'  ,''  ,''  ,'pinos01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '31'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '1'   ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '20'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '48'  ,''  ,''  ,'montalvo01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '3'   ,''  ,''  ,'garsa01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '12'  ,''  ,''  ,'garsa01'),
		T_TIPO_DATA('GGADM'  ,'03'  ,''  ,''  , '46'  ,''  ,''  ,'garsa01'),
-- SAREB - GESTORIAS DE ADMISION		
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '4'   ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '11'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '14'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '18'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '21'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '23'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '29'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '41'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '22'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '44'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '50'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '33'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '7'   ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '35'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '38'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '39'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '2'   ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '13'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '16'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '19'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '45'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '5'   ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '9'   ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '24'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '34'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '37'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '40'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '42'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '47'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '49'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '8'   ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '17'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '25'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '43'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '51'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '6'   ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '10'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '15'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '27'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '32'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '36'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '26'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '28'  ,''  ,''  ,'tecnotra01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '52'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '30'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '31'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '1'   ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '20'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '48'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '3'   ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '12'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GGADM'  ,'02'  ,''  ,''  , '46'  ,''  ,''  ,'ogf01'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '4'  ,''  ,''  ,'gl02'),
-- BANKIA - GESTORIAS DE ADMINISTRACION
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '11'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '14'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '18'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '21'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '23'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '29'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '41'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '22'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '44'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '50'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '33'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '7'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '35'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '38'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '39'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '2'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '13'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '16'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '19'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '45'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '5'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '9'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '24'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '34'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '37'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '40'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '42'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '47'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '49'  ,''  ,''  ,'uniges02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '8'  ,''  ,''  ,'pinos02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '17'  ,''  ,''  ,'pinos02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '25'  ,''  ,''  ,'pinos02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '43'  ,''  ,''  ,'pinos02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '51'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '6'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '10'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '15'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '27'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '32'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '36'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '26'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '28'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '52'  ,''  ,''  ,'gl02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '30'  ,''  ,''  ,'pinos02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '31'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '1'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '20'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '48'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '3'  ,''  ,''  ,'garsa02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '12'  ,''  ,''  ,'montalvo02'),
		T_TIPO_DATA('GIAADMT'  ,'03'  ,''  ,''  , '46'  ,''  ,''  ,'garsa02'),
-- SAREB - GESTORIAS DE ADMINISTRACION
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '4'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '11'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '14'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '18'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '21'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '23'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '29'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '41'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '22'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '44'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '50'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '33'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '7'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '35'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '38'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '39'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '2'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '13'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '16'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '19'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '45'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '5'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '9'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '24'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '34'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '37'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '40'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '42'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '47'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '49'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '8'  ,''  ,''  ,'pinos02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '17'  ,''  ,''  ,'pinos02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '25'  ,''  ,''  ,'pinos02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '43'  ,''  ,''  ,'pinos02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '51'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '6'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '10'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '15'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '27'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '32'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '36'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '26'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '28'  ,''  ,''  ,'tecnotra02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '52'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '30'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '31'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '1'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '20'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '48'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '3'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '12'  ,''  ,''  ,'ogf02'),
		T_TIPO_DATA('GIAADMT'  ,'02'  ,''  ,''  , '46'  ,''  ,''  ,'ogf02'),
-- BANKIA - GESTORIAS DE FORMALIZACIÓN
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '4'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '11'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '14'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '18'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '21'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '23'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '29'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '41'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '22'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '44'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '50'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '33'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '7'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '35'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '38'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '39'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '2'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '13'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '16'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '19'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '45'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '5'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '9'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '24'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '34'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '37'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '40'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '42'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '47'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '49'  ,''  ,''  ,'uniges03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '8'  ,''  ,''  ,'pinos03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '17'  ,''  ,''  ,'pinos03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '25'  ,''  ,''  ,'pinos03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '43'  ,''  ,''  ,'pinos03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '51'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '6'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '10'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '15'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '27'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '32'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '36'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '26'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '28'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '52'  ,''  ,''  ,'gl03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '30'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '31'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '1'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '20'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '48'  ,''  ,''  ,'montalvo03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '3'  ,''  ,''  ,'garsa03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '12'  ,''  ,''  ,'garsa03'),
		T_TIPO_DATA('GIAFORM'  ,'03'  ,''  ,''  , '46'  ,''  ,''  ,'garsa03'),
-- SAREB - GESTORIAS DE FORMALIZACIÓN
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '4'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '11'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '14'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '18'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '21'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '23'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '29'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '41'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '22'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '44'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '50'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '33'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '7'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '35'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '38'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '39'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '2'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '13'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '16'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '19'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '45'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '5'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '9'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '24'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '34'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '37'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '40'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '42'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '47'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '49'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '8'  ,''  ,''  ,'pinos03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '17'  ,''  ,''  ,'pinos03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '25'  ,''  ,''  ,'pinos03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '43'  ,''  ,''  ,'pinos03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '51'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '6'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '10'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '15'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '27'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '32'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '36'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '26'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '28'  ,''  ,''  ,'tecnotra03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '52'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '30'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '31'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '1'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '20'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '48'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '3'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '12'  ,''  ,''  ,'ogf03'),
		T_TIPO_DATA('GIAFORM'  ,'02'  ,''  ,''  , '46'  ,''  ,''  ,'ogf03')
		
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	-- TRUNCATE - Primer script de carga, por tanto podemos truncarla, el resto que siguen a este, no hacermos un truncate.
	-- Mientras sea una tabla de configuración de la que extraemos información y no haya ninguna FK apuntando a su id, 
    -- podemos borrar la tabla completa y volver a generar la configuración.
    V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TRUNCADA');

	 
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
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO  IS NULL '||
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
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
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
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
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

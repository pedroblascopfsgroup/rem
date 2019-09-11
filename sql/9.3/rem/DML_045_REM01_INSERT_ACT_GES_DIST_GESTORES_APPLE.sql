--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190820
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5092
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
    			-- TGE		 CRA	SCRA	PRV	USERNAME
    			-- TGE		 CRA	EAC	  TCR	PRV	 LOC  POSTAL	USERNAME
			-- 1			2	3		4	5		6	7		8
	--GPM
		--pgarciafraile
		T_TIPO_DATA('GPM', '7', '138', '30', 'pgarciafraile'),
		T_TIPO_DATA('GPM', '7', '138', '12', 'pgarciafraile'),
		T_TIPO_DATA('GPM', '7', '138', '46', 'pgarciafraile'),
		T_TIPO_DATA('GPM', '7', '138', '3', 'pgarciafraile'),
		T_TIPO_DATA('GPM', '7', '138', '7', 'pgarciafraile'),
		T_TIPO_DATA('GPM', '7', '138', '43', 'pgarciafraile'),
		T_TIPO_DATA('GPM', '7', '138', '8', 'pgarciafraile'),
		T_TIPO_DATA('GPM', '7', '138', '25', 'pgarciafraile'),
		T_TIPO_DATA('GPM', '7', '138', '17', 'pgarciafraile'),
		--omora
		T_TIPO_DATA('GPM', '7', '138', '21', 'omora'),
		T_TIPO_DATA('GPM', '7', '138', '41', 'omora'),
		T_TIPO_DATA('GPM', '7', '138', '14', 'omora'),
		T_TIPO_DATA('GPM', '7', '138', '23', 'omora'),
		T_TIPO_DATA('GPM', '7', '138', '4', 'omora'),
		T_TIPO_DATA('GPM', '7', '138', '18', 'omora'),
		T_TIPO_DATA('GPM', '7', '138', '29', 'omora'),
		T_TIPO_DATA('GPM', '7', '138', '11', 'omora'),
		--jguarch
		T_TIPO_DATA('GPM', '7', '138', '38', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '35', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '28', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '15', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '27', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '32', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '36', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '33', 'jguarch'),

		T_TIPO_DATA('GPM', '7', '138', '39', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '1', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '20', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '48', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '31', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '22', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '50', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '44', 'jguarch'),

		T_TIPO_DATA('GPM', '7', '138', '26', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '45', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '13', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '16', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '19', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '2', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '42', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '9', 'jguarch'),

		T_TIPO_DATA('GPM', '7', '138', '47', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '49', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '34', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '24', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '40', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '5', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '37', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '10', 'jguarch'),
		T_TIPO_DATA('GPM', '7', '138', '6', 'jguarch'),
	--MO
		--lcarrillo
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '30', 'lcarrillo'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '12', 'lcarrillo'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '46', 'lcarrillo'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '3', 'lcarrillo'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '7', 'lcarrillo'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '43', 'lcarrillo'),
		
		--msanzi
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '8', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '25', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '17', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '21', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '41', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '14', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '23', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '4', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '18', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '29', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '11', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '38', 'msanzi'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '35', 'msanzi'),
		
		--lrisco
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '28', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '15', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '27', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '32', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '36', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '33', 'lrisco'),

		T_TIPO_DATA('HAYAGBOINM', '7', '138', '39', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '1', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '20', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '48', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '31', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '22', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '50', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '44', 'lrisco'),

		T_TIPO_DATA('HAYAGBOINM', '7', '138', '26', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '45', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '13', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '16', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '19', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '2', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '42', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '9', 'lrisco'),

		T_TIPO_DATA('HAYAGBOINM', '7', '138', '47', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '49', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '34', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '24', 'jguarch'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '40', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '5', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '37', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '10', 'lrisco'),
		T_TIPO_DATA('HAYAGBOINM', '7', '138', '6', 'lrisco'),

	--AM
		
		T_TIPO_DATA('GCOM', '7', '138', '30', 'aferrandiz'),

		T_TIPO_DATA('GCOM', '7', '138', '12', 'mjmagana'),
		T_TIPO_DATA('GCOM', '7', '138', '46', 'gruamvalman'),
		T_TIPO_DATA('GCOM', '7', '138', '3', 'aferrandiz'),
		T_TIPO_DATA('GCOM', '7', '138', '7', 'aferrandiz'),

		T_TIPO_DATA('GCOM', '7', '138', '43', 'mjmagana'), 
		
		T_TIPO_DATA('GCOM', '7', '138', '8', 'mguillen'),
		T_TIPO_DATA('GCOM', '7', '138', '25', 'mguillen'),
		T_TIPO_DATA('GCOM', '7', '138', '17', 'mguillen'),

		T_TIPO_DATA('GCOM', '7', '138', '21', 'asanchezpo'),
		T_TIPO_DATA('GCOM', '7', '138', '41', 'asanchezpo'),

		T_TIPO_DATA('GCOM', '7', '138', '14', 'aalonso'),
		T_TIPO_DATA('GCOM', '7', '138', '23', 'aalonso'),
		T_TIPO_DATA('GCOM', '7', '138', '4', 'aalonso'),
		T_TIPO_DATA('GCOM', '7', '138', '18', 'aalonso'),

		T_TIPO_DATA('GCOM', '7', '138', '29', 'asanchezpo'),
		T_TIPO_DATA('GCOM', '7', '138', '11', 'asanchezpo'),

		T_TIPO_DATA('GCOM', '7', '138', '38', 'etraviesol'),
		T_TIPO_DATA('GCOM', '7', '138', '35', 'etraviesol'),

		T_TIPO_DATA('GCOM', '7', '138', '28', 'anavarroj'),

		T_TIPO_DATA('GCOM', '7', '138', '15', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '27', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '32', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '36', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '33', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '39', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '1', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '20', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '48', 'rjimeno'),

		T_TIPO_DATA('GCOM', '7', '138', '31', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '22', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '50', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '44', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '26', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '45', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '13', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '16', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '19', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '2', 'anavarroj'),

		T_TIPO_DATA('GCOM', '7', '138', '42', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '9', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '47', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '49', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '34', 'rjimeno'),
		T_TIPO_DATA('GCOM', '7', '138', '24', 'rjimeno'),

		T_TIPO_DATA('GCOM', '7', '138', '40', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '5', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '37', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '10', 'anavarroj'),
		T_TIPO_DATA('GCOM', '7', '138', '6', 'anavarroj'),

		--grusbackoffman
		T_TIPO_DATA('HAYASBOINM', '7', '138', '1', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '2', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '3', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '4', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '5', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '6', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '7', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '8', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '9', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '10', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '11', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '12', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '13', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '14', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '15', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '16', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '17', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '18', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '19', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '20', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '21', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '22', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '23', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '24', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '25', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '26', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '27', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '28', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '29', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '30', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '31', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '32', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '33', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '34', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '35', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '36', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '37', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '38', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '39', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '40', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '41', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '42', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '43', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '44', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '45', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '46', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '47', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '48', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '49', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '50', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '51', 'grusbackoffman'),
		T_TIPO_DATA('HAYASBOINM', '7', '138', '52', 'grusbackoffman'),

		--gruscomman
		T_TIPO_DATA('SCOM', '7', '138', '1', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '2', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '3', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '4', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '5', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '6', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '7', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '8', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '9', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '10', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '11', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '12', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '13', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '14', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '15', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '16', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '17', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '18', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '19', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '20', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '21', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '22', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '23', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '24', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '25', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '26', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '27', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '28', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '29', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '30', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '31', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '32', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '33', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '34', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '35', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '36', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '37', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '38', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '39', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '40', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '41', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '42', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '43', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '44', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '45', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '46', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '47', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '48', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '49', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '50', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '51', 'gruscomman'),
		T_TIPO_DATA('SCOM', '7', '138', '52', 'gruscomman')
		
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
--    V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' WHERE COD_CARTERA = 3'; 
--    EXECUTE IMMEDIATE V_MSQL;
--    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TRUNCADA');

	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_SUBCARTERA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND (COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(4))||''') '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
		  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''') '||
					' , USUARIOMODIFICAR = ''REMVIP-5092'' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_SUBCARTERA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND (COD_PROVINCIA IS NULL OR COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(4))||''') '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
  		  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_PROVINCIA, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''' ' ||
						', '''||V_TMP_TIPO_DATA(4)||''','''||V_TMP_TIPO_DATA(5)||''' ' ||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''') '||
						', 0, ''REMVIP-5092'',SYSDATE,0,'''||TRIM(V_TMP_TIPO_DATA(3))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
        
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

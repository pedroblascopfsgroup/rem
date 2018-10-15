--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2011
--## PRODUCTO=NO
--##
--## Finalidad: Script para sustituir el gestor actual de las configuraciones por las de una Excel adjunta en el item.
--## 			(Cambio en configuración de gestor de activo y supervisor de activo)
--##			Añade en la tabla ACT_GES_DIST_GESTORES los datos del array T_ARRAY_DATA
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
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-2011';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

    		--  		 TGE	  CRA	  EAC   TCR	  PRV	  LOC  POSTAL	USERNAME
    		--GRUPO GESTOR DE ACTIVOS y SUPERVISORES DE ACTIVOS
    		
         T_TIPO_DATA('GESRES', '02', '', '', '4', '', '', 'gcarbonell'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4001', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4002', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4003', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4007', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4010', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4011', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4013', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4015', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4029', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4030', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4038', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4041', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4043', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4046', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4047', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4050', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4051', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4052', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4054', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4055', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4057', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4065', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4067', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4077', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4079', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4081', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4091', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4101', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4102', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4901', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4902', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '4', '4903', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '02', '', '', '11', '', '', 'mjimenezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '14', '', '', 'mjimenezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '18', '', '', 'maguilar'), 
         T_TIPO_DATA('GESRES', '02', '', '', '21', '', '', 'mjimenezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '23', '', '', 'maguilar'), 
         T_TIPO_DATA('GESRES', '02', '', '', '29', '', '', 'mjimenezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '41', '', '', 'mjimenezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '22', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '44', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '50', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '7', '', '', 'maguilar'), 
         T_TIPO_DATA('GESRES', '02', '', '', '35', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '38', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '39', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '2', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '13', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '16', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '19', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '45', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '5', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '9', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '24', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '34', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '37', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '40', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '42', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '47', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '49', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '8', '', '', 'maguilar'), 
         T_TIPO_DATA('GESRES', '02', '', '', '17', '', '', 'maguilar'), 
         T_TIPO_DATA('GESRES', '02', '', '', '25', '', '', 'maguilar'), 
         T_TIPO_DATA('GESRES', '02', '', '', '43', '', '', 'maguilar'), 
         T_TIPO_DATA('GESRES', '02', '', '', '3', '', '', 'acebrianm'), 
         T_TIPO_DATA('GESRES', '02', '', '', '12', '', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '', '', 'mmaldonado'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '', '', 'mmaldonado'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46011', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46012', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46016', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46017', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46024', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46028', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46030', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46031', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46036', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46040', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46044', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46045', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46051', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46053', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46058', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46064', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46067', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46070', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46076', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46077', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46078', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46079', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46080', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46082', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46083', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46084', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46089', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46095', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46099', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46100', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46101', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46103', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46106', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46109', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46111', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46112', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46114', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46115', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46116', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46119', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46120', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46122', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46130', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46133', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46135', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46136', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46142', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46144', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46147', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46148', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46149', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46157', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46158', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46160', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46161', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46162', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46178', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46182', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46190', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46191', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46202', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46203', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46209', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46213', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46214', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46216', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46222', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46227', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46228', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46229', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46234', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46239', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46242', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46245', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46246', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46247', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46248', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46249', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46256', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46257', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46258', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46259', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46261', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46262', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46263', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '46', '46903', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '02', '', '', '6', '', '', 'mjimenezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '10', '', '', 'mjimenezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '15', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '27', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '32', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '36', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '28', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '30', '', '', 'gcarbonell'), 
         T_TIPO_DATA('GESRES', '02', '', '', '31', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '1', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '20', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '48', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '33', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '26', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '51', '', '', 'mjimenezr'), 
         T_TIPO_DATA('GESRES', '02', '', '', '52', '', '', 'mjimenezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '4', '', '', 'fsamper'), 
         T_TIPO_DATA('GESRES', '01', '', '', '11', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '14', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '18', '', '', 'acebrianm'), 
         T_TIPO_DATA('GESRES', '01', '', '', '21', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '23', '', '', 'acebrianm'), 
         T_TIPO_DATA('GESRES', '01', '', '', '29', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '41', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '22', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '44', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '50', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '7', '', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '01', '', '', '35', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '38', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '39', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '2', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '13', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '16', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '19', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '45', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '5', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '9', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '24', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '34', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '37', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '40', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '42', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '47', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '49', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '8', '', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '01', '', '', '17', '', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '01', '', '', '25', '', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '01', '', '', '43', '', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '01', '', '', '3', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '12', '', '', 'ateruel'), 
         T_TIPO_DATA('GESRES', '01', '', '', '46', '', '', 'asalag'), 
         T_TIPO_DATA('GESRES', '01', '', '', '6', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '10', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '15', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '27', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '32', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '36', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '28', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '30', '', '', 'acebrianm'), 
         T_TIPO_DATA('GESRES', '01', '', '', '31', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '1', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '20', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '48', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '33', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '26', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '51', '', '', 'igomezr'), 
         T_TIPO_DATA('GESRES', '01', '', '', '52', '', '', 'igomezr'), 
                 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4001', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4002', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4003', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4007', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4010', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4011', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4013', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4015', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4029', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4030', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4038', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4041', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4043', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4046', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4047', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4050', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4051', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4052', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4054', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4055', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4057', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4065', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4067', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4077', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4079', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4081', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4091', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4101', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4102', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4901', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4902', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '4', '4903', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '11', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '14', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '18', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '21', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '23', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '29', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '41', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '22', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '44', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '50', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '7', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '35', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '38', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '39', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '2', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '13', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '16', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '19', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '45', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '5', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '9', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '24', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '34', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '37', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '40', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '42', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '47', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '49', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '8', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '17', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '25', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '43', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '3', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '12', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46011', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46012', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46016', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46017', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46024', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46028', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46030', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46031', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46036', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46040', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46044', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46045', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46051', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46053', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46058', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46064', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46067', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46070', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46076', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46077', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46078', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46079', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46080', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46082', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46083', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46084', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46089', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46095', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46099', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46100', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46101', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46103', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46106', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46109', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46111', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46112', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46114', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46115', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46116', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46119', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46120', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46122', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46130', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46133', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46135', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46136', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46142', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46144', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46147', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46148', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46149', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46157', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46158', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46160', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46161', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46162', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46178', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46182', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46190', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46191', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46202', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46203', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46209', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46213', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46214', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46216', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46222', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46227', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46228', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46229', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46234', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46239', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46242', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46245', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46246', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46247', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46248', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46249', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46256', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46257', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46258', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46259', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46261', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46262', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46263', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '46', '46903', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '6', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '10', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '15', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '27', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '32', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '36', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '28', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '30', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '31', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '1', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '20', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '48', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '33', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '26', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '51', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '02', '', '', '52', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '4', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '11', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '14', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '18', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '21', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '23', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '29', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '41', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '22', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '44', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '50', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '7', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '35', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '38', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '39', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '2', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '13', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '16', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '19', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '45', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '5', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '9', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '24', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '34', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '37', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '40', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '42', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '47', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '49', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '8', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '17', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '25', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '43', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '3', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '12', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '46', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '6', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '10', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '15', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '27', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '32', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '36', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '28', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '30', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '31', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '1', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '20', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '48', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '33', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '26', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '51', '', '', 'rsanchez'), 
         T_TIPO_DATA('SUPRES', '01', '', '', '52', '', '', 'rsanchez')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- LOOP para insertar o modificar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

 	V_COND1 := 'IS NULL';
	IF (V_TMP_TIPO_DATA(6) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF;
        
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = 01 '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND1||' '||
					' AND COD_POSTAL IS NULL ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = '''||V_USU||''' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = 01 '||
					' AND COD_ESTADO_ACTIVO  IS NULL '||
					' AND COD_TIPO_COMERZIALZACION ='''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND1||' '||
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
						', 01,'''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','||TRIM(V_TMP_TIPO_DATA(5))||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, '''||V_USU||''',SYSDATE,0 FROM DUAL';
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

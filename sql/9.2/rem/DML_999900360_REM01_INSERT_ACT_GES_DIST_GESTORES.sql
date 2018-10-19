--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=2018105
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2105
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
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-2105';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

    		--  		 TGE	  CRA	  EAC   TCR	  PRV	  LOC  POSTAL	USERNAME
    		--GRUPO GESTOR DE ACTIVOS y SUPERVISORES DE ACTIVOS
    		
         T_TIPO_DATA('GFORM', '', '', '', '4', '', '', 'cbenavides'), 
         T_TIPO_DATA('GFORM', '', '', '', '4', '', '', 'jdrodriguez'), 
         T_TIPO_DATA('GFORM', '', '', '', '11', '', '', 'dvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '11', '', '', 'ebretones'), 
         T_TIPO_DATA('GFORM', '', '', '', '11', '', '', 'fclares'), 
         T_TIPO_DATA('GFORM', '', '', '', '14', '', '', 'dvalerodvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '14', '', '', 'ebretones'), 
         T_TIPO_DATA('GFORM', '', '', '', '14', '', '', 'fclares'), 
         T_TIPO_DATA('GFORM', '', '', '', '18', '', '', 'cbenavides'), 
         T_TIPO_DATA('GFORM', '', '', '', '18', '', '', 'jdrodriguez'), 
         T_TIPO_DATA('GFORM', '', '', '', '21', '', '', 'dvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '21', '', '', 'ebretones'), 
         T_TIPO_DATA('GFORM', '', '', '', '21', '', '', 'fclares'), 
         T_TIPO_DATA('GFORM', '', '', '', '23', '', '', 'cbenavides'), 
         T_TIPO_DATA('GFORM', '', '', '', '23', '', '', 'jdrodriguez'), 
         T_TIPO_DATA('GFORM', '', '', '', '29', '', '', 'dvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '29', '', '', 'ebretones'), 
         T_TIPO_DATA('GFORM', '', '', '', '29', '', '', 'fclares'), 
         T_TIPO_DATA('GFORM', '', '', '', '41', '', '', 'dvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '41', '', '', 'ebretones'), 
         T_TIPO_DATA('GFORM', '', '', '', '41', '', '', 'fclares'), 
         T_TIPO_DATA('GFORM', '', '', '', '22', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '22', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '22', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '44', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '44', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '44', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '50', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '50', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '50', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '7', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '7', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '7', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '35', '', '', 'cbenavides'), 
         T_TIPO_DATA('GFORM', '', '', '', '35', '', '', 'jdrodriguez'), 
         T_TIPO_DATA('GFORM', '', '', '', '38', '', '', 'cbenavides'), 
         T_TIPO_DATA('GFORM', '', '', '', '38', '', '', 'jdrodriguez'), 
         T_TIPO_DATA('GFORM', '', '', '', '39', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '39', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '39', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '2', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '2', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '2', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '13', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '13', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '13', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '16', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '16', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '16', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '19', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '19', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '19', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '45', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '45', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '45', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '5', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '5', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '5', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '9', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '9', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '9', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '24', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '24', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '24', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '34', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '34', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '34', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '37', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '37', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '37', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '40', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '40', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '40', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '42', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '42', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '42', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '47', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '47', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '47', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '49', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '49', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '49', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '8', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '8', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '8', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '17', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '17', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '17', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '25', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '25', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '25', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '43', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '43', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '43', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '3', '', '', 'mlopez'), 
         T_TIPO_DATA('GFORM', '', '', '', '3', '', '', 'nmunoz'), 
         T_TIPO_DATA('GFORM', '', '', '', '12', '', '', 'dvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '12', '', '', 'fclares'), 
         T_TIPO_DATA('GFORM', '', '', '', '12', '', '', 'mcozar'), 
         T_TIPO_DATA('GFORM', '', '', '', '46', '', '', 'mlopez'), 
         T_TIPO_DATA('GFORM', '', '', '', '46', '', '', 'nmunoz'), 
         T_TIPO_DATA('GFORM', '', '', '', '6', '', '', 'dvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '6', '', '', 'ebretones'), 
         T_TIPO_DATA('GFORM', '', '', '', '6', '', '', 'fclares'), 
         T_TIPO_DATA('GFORM', '', '', '', '10', '', '', 'dvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '10', '', '', 'ebretones'), 
         T_TIPO_DATA('GFORM', '', '', '', '10', '', '', 'fclares'),
         T_TIPO_DATA('GFORM', '', '', '', '15', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '15', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '15', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '27', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '27', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '27', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '32', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '32', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '32', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '36', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '36', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '36', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '28', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '28', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '28', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '30', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '30', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '30', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '31', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '31', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '31', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '1', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '1', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '1', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '20', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '20', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '20', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '48', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '48', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '48', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '33', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '33', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '33', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '26', '', '', 'ebenitezt'), 
         T_TIPO_DATA('GFORM', '', '', '', '26', '', '', 'jmartinezsa'), 
         T_TIPO_DATA('GFORM', '', '', '', '26', '', '', 'texposito'), 
         T_TIPO_DATA('GFORM', '', '', '', '51', '', '', 'dvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '51', '', '', 'ebretones'), 
         T_TIPO_DATA('GFORM', '', '', '', '51', '', '', 'fclares'), 
         T_TIPO_DATA('GFORM', '', '', '', '52', '', '', 'dvalero'), 
         T_TIPO_DATA('GFORM', '', '', '', '52', '', '', 'ebretones'), 
         T_TIPO_DATA('GFORM', '', '', '', '52', '', '', 'fclares'),

         T_TIPO_DATA('SFORM', '', '', '', '4', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '11', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '14', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '18', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '21', '', '', 'fclares'),  
         T_TIPO_DATA('SFORM', '', '', '', '23', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '29', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '41', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '22', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '44', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '50', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '7', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '35', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '38', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '39', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '2', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '13', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '16', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '19', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '45', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '5', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '9', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '24', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '34', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '37', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '40', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '42', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '47', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '49', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '8', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '17', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '25', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '43', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '3', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '12', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '46', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '6', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '10', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '15', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '27', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '32', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '36', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '28', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '30', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '31', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '1', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '20', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '48', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '33', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '26', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '51', '', '', 'fclares'), 
         T_TIPO_DATA('SFORM', '', '', '', '52', '', '', 'fclares'),

         T_TIPO_DATA('GIAFORM', '', '', '', '4', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '4', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '11', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '11', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '11', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '14', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '14', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '14', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '18', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '18', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '21', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '21', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '21', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '23', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '23', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '29', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '29', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '29', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '41', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '41', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '41', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '22', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '22', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '22', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '44', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '44', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '44', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '50', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '50', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '50', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '7', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '7', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '7', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '35', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '35', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '38', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '38', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '39', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '39', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '39', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '2', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '2', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '2', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '13', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '13', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '13', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '16', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '16', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '16', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '19', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '19', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '19', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '45', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '45', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '45', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '5', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '5', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '5', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '9', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '9', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '9', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '24', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '24', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '24', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '34', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '34', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '34', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '37', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '37', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '37', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '40', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '40', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '40', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '42', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '42', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '42', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '47', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '47', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '47', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '49', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '49', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '49', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '8', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '8', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '8', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '17', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '17', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '17', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '25', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '25', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '25', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '43', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '43', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '43', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '3', '', '', 'garsa03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '3', '', '', 'garsa03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '12', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '12', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '12', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '46', '', '', 'garsa03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '46', '', '', 'garsa03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '6', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '6', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '6', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '10', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '10', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '10', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '15', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '15', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '15', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '27', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '27', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '27', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '32', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '32', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '32', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '36', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '36', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '36', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '28', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '28', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '28', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '30', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '30', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '30', '', '', 'ogf03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '31', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '31', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '31', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '1', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '1', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '1', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '20', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '20', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '20', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '48', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '48', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '48', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '33', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '33', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '33', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '26', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '26', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '26', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '51', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '51', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '51', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '52', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '52', '', '', 'tecnotra03'), 
         T_TIPO_DATA('GIAFORM', '', '', '', '52', '', '', 'tecnotra03')




    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');


	V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES WHERE COD_CARTERA = 1 AND TIPO_GESTOR IN (''GIAFORM'', ''GFORM'', ''SFORM'')';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO CORRECTO');
	
    -- LOOP para insertar o modificar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

 	V_COND1 := 'IS NULL';
	IF (V_TMP_TIPO_DATA(6) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF;
        			
  
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

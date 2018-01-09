--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3608
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
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-3608';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		
    		--  		 TGE	  CRA	  EAC   TCR	  PRV	  LOC  POSTAL	USERNAME
    		--GRUPO GESTOR DE ACTIVOS y SUPERVISORES DE ACTIVOS
    		
			T_TIPO_DATA('GCOM',' 2', '', '2', '3', '', '', 'jalmansa'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28079', '', 'amonge'),
			T_TIPO_DATA('GACT',' 3', '', '', '26', '', '', 'amonge'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28001', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28002', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28003', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28004', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28005', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28006', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28007', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28008', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28009', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28010', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28011', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28012', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28013', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28014', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28015', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28016', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28017', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28018', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28019', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28020', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28021', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28022', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28023', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28024', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28025', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28026', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28027', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28028', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28029', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28030', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28031', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28032', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28033', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28034', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28035', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28036', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28037', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28038', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28039', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28040', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28041', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28042', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28043', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28044', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28045', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28046', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28047', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28048', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28049', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28050', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28051', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28052', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28053', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28054', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28055', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28056', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28057', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28058', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28059', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28060', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28061', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28062', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28063', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28064', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28065', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28066', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28067', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28068', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28069', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28070', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28071', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28072', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28073', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28074', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28075', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28076', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28078', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28080', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28082', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28083', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28084', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28085', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28086', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28087', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28088', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28089', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28090', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28091', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28092', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28093', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28094', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28095', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28096', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28097', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28099', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28100', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28101', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28102', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28104', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28106', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28107', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28108', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28109', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28110', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28111', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28112', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28113', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28114', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28115', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28116', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28117', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28118', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28119', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28120', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28121', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28122', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28123', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28124', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28125', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28126', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28127', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28128', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28129', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28130', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28131', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28132', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28133', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28134', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28135', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28136', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28137', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28138', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28140', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28141', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28143', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28144', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28145', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28146', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28147', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28148', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28149', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28150', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28151', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28152', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28153', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28154', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28155', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28156', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28157', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28158', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28159', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28160', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28161', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28162', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28163', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28164', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28165', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28166', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28167', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28168', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28169', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28170', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28171', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28172', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28173', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28174', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28175', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28176', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28177', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28178', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28179', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28180', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28181', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28182', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28183', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28901', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28902', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '28', '28903', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '22', '', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '44', '', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '50', '', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 3', '', '', '1', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '5', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '9', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '15', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '20', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '24', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '27', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '31', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '32', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '33', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '34', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '36', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '37', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '39', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '40', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '42', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '47', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '48', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 3', '', '', '49', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28079', '', 'amonge'),
			T_TIPO_DATA('GACT',' 2', '', '', '26', '', '', 'amonge'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28001', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28002', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28003', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28004', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28005', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28006', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28007', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28008', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28009', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28010', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28011', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28012', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28013', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28014', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28015', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28016', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28017', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28018', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28019', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28020', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28021', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28022', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28023', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28024', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28025', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28026', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28027', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28028', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28029', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28030', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28031', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28032', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28033', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28034', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28035', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28036', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28037', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28038', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28039', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28040', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28041', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28042', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28043', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28044', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28045', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28046', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28047', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28048', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28049', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28050', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28051', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28052', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28053', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28054', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28055', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28056', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28057', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28058', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28059', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28060', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28061', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28062', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28063', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28064', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28065', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28066', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28067', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28068', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28069', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28070', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28071', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28072', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28073', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28074', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28075', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28076', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28078', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28080', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28082', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28083', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28084', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28085', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28086', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28087', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28088', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28089', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28090', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28091', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28092', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28093', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28094', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28095', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28096', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28097', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28099', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28100', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28101', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28102', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28104', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28106', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28107', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28108', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28109', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28110', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28111', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28112', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28113', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28114', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28115', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28116', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28117', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28118', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28119', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28120', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28121', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28122', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28123', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28124', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28125', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28126', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28127', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28128', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28129', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28130', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28131', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28132', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28133', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28134', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28135', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28136', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28137', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28138', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28140', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28141', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28143', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28144', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28145', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28146', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28147', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28148', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28149', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28150', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28151', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28152', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28153', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28154', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28155', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28156', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28157', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28158', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28159', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28160', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28161', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28162', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28163', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28164', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28165', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28166', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28167', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28168', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28169', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28170', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28171', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28172', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28173', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28174', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28175', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28176', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28177', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28178', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28179', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28180', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28181', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28182', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28183', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28901', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28902', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '28', '28903', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '22', '', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '44', '', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '50', '', '', 'agonzaleza'),
			T_TIPO_DATA('GACT',' 2', '', '', '1', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '5', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '9', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '15', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '20', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '24', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '27', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '31', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '32', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '33', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '34', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '36', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '37', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '39', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '40', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '42', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '47', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '48', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 2', '', '', '49', '', '', 'acabello'),
			T_TIPO_DATA('GACT',' 1', '', '', '1', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '2', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '5', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '6', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '7', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '8', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '9', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '10', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '13', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '15', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '16', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '17', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '19', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '20', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '22', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '24', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '25', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '26', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '27', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '28', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '30', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '31', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '32', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '33', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '34', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '36', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '37', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '39', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '40', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '42', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '43', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '44', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '45', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '47', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '48', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '49', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '50', '', '', 'ndelaossa'),
			T_TIPO_DATA('GACT',' 1', '', '', '11', '', '', 'rguirado'),
			T_TIPO_DATA('GACT',' 1', '', '', '14', '', '', 'rguirado'),
			T_TIPO_DATA('GACT',' 1', '', '', '18', '', '', 'rguirado'),
			T_TIPO_DATA('GACT',' 1', '', '', '21', '', '', 'rguirado'),
			T_TIPO_DATA('GACT',' 1', '', '', '23', '', '', 'rguirado'),
			T_TIPO_DATA('GACT',' 1', '', '', '29', '', '', 'rguirado'),
			T_TIPO_DATA('GACT',' 1', '', '', '41', '', '', 'rguirado'),
			T_TIPO_DATA('GACT',' 1', '', '', '4', '', '', 'mperez'),
			T_TIPO_DATA('GACT',' 1', '', '', '46', '', '', 'maranda'),
			T_TIPO_DATA('GACT',' 1', '', '', '3', '', '', 'mgarciade'),
			T_TIPO_DATA('GACT',' 1', '', '', '12', '', '', 'mgarciade'),
			T_TIPO_DATA('GACT',' 1', '', '', '35', '', '', 'mgarciade'),
			T_TIPO_DATA('GACT',' 1', '', '', '38', '', '', 'mgarciade'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46002', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46003', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46004', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46006', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46008', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46011', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46015', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46016', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46017', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46019', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46020', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46024', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46029', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46037', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46039', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46040', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46042', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46043', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46044', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46045', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46046', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46047', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46048', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46049', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46053', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46054', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46055', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46056', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46061', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46071', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46072', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46081', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46083', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46084', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46085', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46098', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46104', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46105', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46107', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46118', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46119', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46122', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46123', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46125', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46127', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46128', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46131', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46132', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46137', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46138', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46139', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46140', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46143', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46145', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46146', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46150', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46154', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46155', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46157', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46160', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46162', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46170', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46173', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46174', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46179', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46181', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46183', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46184', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46187', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46188', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46189', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46194', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46195', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46197', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46198', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46200', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46203', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46211', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46217', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46218', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46219', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46231', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46233', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46235', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46236', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46238', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46240', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46246', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46250', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46251', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46255', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46257', '', 'mdiez'),
			T_TIPO_DATA('GCOM',' 2', '', '2', '46', '46263', '', 'mdiez')

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
		V_COND2 := 'IS NULL';
        IF (V_TMP_TIPO_DATA(4) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(4))||''' ';
        END IF;
        IF (V_TMP_TIPO_DATA(6) is not null) THEN
			V_COND2 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF;
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  '||V_COND1||' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = '''||V_USU||''' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO  IS NULL '||
					' AND COD_TIPO_COMERZIALZACION '||V_COND1||' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
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
						', '||V_TMP_TIPO_DATA(2)||','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||TRIM(V_TMP_TIPO_DATA(5))||' ' ||
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

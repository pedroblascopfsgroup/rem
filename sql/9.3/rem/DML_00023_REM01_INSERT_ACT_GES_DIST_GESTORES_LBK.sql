--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5668
--## PRODUCTO=NO
--##
--## Finalidad:	Añade en la tabla ACT_GES_DIST_GESTORES los datos del array T_ARRAY_DATA
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
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-5668';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND3 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
    		-- TGE | CRA | EAC | TCR | PRV | LOC | POSTAL | USERNAME | NOMBRE_APELLIDO | SCRA

    	T_TIPO_DATA('GCOM', '8', '', '', '1', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '2', '', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '3', '', '', 'erobles', 'Esther Robles Casado', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '4', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '5', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '6', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '7', '', '', 'erobles', 'Esther Robles Casado', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '8', '', '', 'erobles', 'Esther Robles Casado', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '9', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '10', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '11', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '12', '', '', 'erobles', 'Esther Robles Casado', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '13', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '14', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '15', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '16', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '17', '', '', 'erobles', 'Esther Robles Casado', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '18', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '19', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '20', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '21', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '22', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '23', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '24', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '25', '', '', 'erobles', 'Esther Robles Casado', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '26', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '27', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '28', '', '', 'lalbendin', 'Laura Albendin Reyes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '29', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '30', '', '', 'erobles', 'Esther Robles Casado', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '31', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '32', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '33', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '34', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '35', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '36', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '37', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '38', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '39', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '40', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '41', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '42', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '43', '', '', 'erobles', 'Esther Robles Casado', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '44', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '46', '', '', 'erobles', 'Esther Robles Casado', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '47', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '48', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '49', '', '', 'rjimeno', 'Raul Jimeno Fuentes', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '50', '', '', 'cruiz', 'Carlos Ruiz Miguel', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '51', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '52', '', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45001', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45002', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45003', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45004', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45005', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45006', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45007', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45008', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45009', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45010', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45011', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45012', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45013', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45014', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45015', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45016', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45017', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45018', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45019', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45020', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45021', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45022', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45023', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45024', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45025', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45026', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45027', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45028', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45029', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45030', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45031', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45032', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45033', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45034', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45035', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45036', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45037', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45038', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45039', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45040', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45041', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45042', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45043', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45045', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45046', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45047', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45048', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45049', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45056', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45057', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45050', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45051', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45052', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45053', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45054', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45055', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45058', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45059', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45060', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45061', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45062', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45063', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45064', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45065', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45066', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45067', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45068', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45069', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45070', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45071', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45072', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45073', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45074', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45075', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45076', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45077', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45078', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45079', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45080', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45081', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45082', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45083', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45084', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45085', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45086', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45087', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45088', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45089', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45090', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45091', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45092', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45093', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45094', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45095', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45096', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45097', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45098', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45099', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45100', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45101', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45102', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45103', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45104', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45105', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45106', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45107', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45108', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45109', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45110', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45111', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45112', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45113', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45114', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45115', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45116', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45117', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45118', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45119', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45120', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45121', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45122', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45123', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45124', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45125', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45126', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45127', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45128', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45129', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45130', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45131', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45132', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45133', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45134', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45135', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45136', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45137', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45138', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45139', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45140', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45141', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45142', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45143', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45144', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45145', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45146', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45147', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45148', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45149', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45150', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45151', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45152', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45153', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45154', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45155', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45156', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45157', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45158', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45901', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45159', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45160', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45161', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45162', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45163', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45164', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45165', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45166', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45167', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45168', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45169', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45171', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45170', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45172', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45173', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45174', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45175', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45176', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45177', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45179', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45180', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45181', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45182', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45183', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45184', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45186', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45185', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45187', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45188', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45189', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45190', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45191', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45192', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45193', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45194', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45195', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45196', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45197', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45198', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45199', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45200', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45201', '', 'jgarciam', 'Jose Garcia Moreno', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45202', '', 'jfragua', 'Jorge Fragua Pastor', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45203', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45204', '', 'cvidegain', 'Cristina Videgain Jimenez', ''),
	T_TIPO_DATA('GCOM', '8', '', '', '45', '45205', '', 'cvidegain', 'Cristina Videgain Jimenez', '')
         
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
	V_COND3 := 'IS NULL';

        IF (V_TMP_TIPO_DATA(4) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(4))||''' ';
        END IF;
        IF (V_TMP_TIPO_DATA(6) is not null) THEN
			V_COND2 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF;
 	IF (V_TMP_TIPO_DATA(10) is not null)  THEN
			V_COND3 := '= '''||TRIM(V_TMP_TIPO_DATA(10))||''' ';
        END IF;
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  '||V_COND1||' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL '||
					' AND COD_SUBCARTERA '||V_COND3||' ';
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
					' AND COD_POSTAL IS NULL '||
					' AND COD_SUBCARTERA '||V_COND3||' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||TRIM(V_TMP_TIPO_DATA(5))||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, '''||V_USU||''',SYSDATE,0, '''||TRIM(V_TMP_TIPO_DATA(10))||''' FROM DUAL';
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

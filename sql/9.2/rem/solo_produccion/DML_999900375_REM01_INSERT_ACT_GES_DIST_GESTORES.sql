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
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-2288';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

    		--  		 TGE	  CRA	  EAC   TCR	  PRV	  LOC  POSTAL	USERNAME
    		--GRUPO GESTOR DE ACTIVOS y SUPERVISORES DE ACTIVOS
    		
         T_TIPO_DATA('GACT', '', '', '', '45', '45001', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45002', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45003', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45004', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45006', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45007', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45009', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45012', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45013', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45014', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45015', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45016', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45018', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45019', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45021', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45023', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45025', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45026', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45027', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45028', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45029', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45030', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45031', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45032', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45034', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45036', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45037', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45038', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45039', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45040', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45041', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45043', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45045', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45046', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45047', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45056', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45057', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45050', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45051', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45052', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45053', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45054', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45055', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45058', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45059', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45060', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45061', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45062', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45064', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45066', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45067', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45069', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45070', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45071', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45072', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45074', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45076', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45077', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45078', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45081', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45083', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45084', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45085', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45086', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45087', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45088', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45089', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45090', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45091', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45092', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45094', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45095', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45097', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45098', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45099', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45101', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45102', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45104', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45105', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45106', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45107', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45109', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45110', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45112', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45115', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45116', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45117', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45118', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45119', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45120', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45121', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45122', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45123', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45124', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45125', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45126', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45127', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45128', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45129', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45130', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45132', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45133', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45134', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45135', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45136', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45137', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45138', '', 'mgonzaleze'),
         T_TIPO_DATA('GACT', '', '', '', '45', '45140', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45141', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45142', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45143', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45145', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45147', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45150', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45151', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45152', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45153', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45154', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45156', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45157', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45158', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45160', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45161', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45163', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45165', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45166', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45167', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45168', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45169', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45171', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45172', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45173', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45175', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45176', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45179', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45180', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45181', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45182', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45183', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45185', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45186', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45187', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45188', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45189', '', 'mgonzaleze'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45190', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45191', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45192', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45193', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45195', '', 'cmartinc'),
         T_TIPO_DATA('GACT', '', '', '', '45', '45196', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45197', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45198', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45199', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45200', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45201', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45202', '', 'cmartinc'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45203', '', 'ssalazar'), 
         T_TIPO_DATA('GACT', '', '', '', '45', '45204', '', 'ssalazar'),
         T_TIPO_DATA('GACT', '', '', '', '45', '45205', '', 'ssalazar'),
         T_TIPO_DATA('GACT', '', '', '', '45', '45901', '', 'mgonzaleze')



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
        			
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', 08,'''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','||TRIM(V_TMP_TIPO_DATA(5))||' ' ||
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

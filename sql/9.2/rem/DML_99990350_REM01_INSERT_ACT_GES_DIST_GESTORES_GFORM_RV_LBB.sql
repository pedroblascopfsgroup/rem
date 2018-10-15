--/*
--##########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180820
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1571
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
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,4 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,4 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,11 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,11 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,14 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,14 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,18 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,18 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,21 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,21 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,23 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,23 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,29 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,29 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,41 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,41 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,22 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,44 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,50 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,7 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,7 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,35 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,38 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,39 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,2 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,2 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,2 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,2 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,2 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,2 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,13 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,13 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,13 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,13 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,13 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,13 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,16 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,16 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,16 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,16 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,16 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,16 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,19 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,19 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,19 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,19 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,19 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,19 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,45 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,45 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,45 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,45 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,45 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,45 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,5 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,9 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,24 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,34 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,37 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,40 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,42 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,47 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,49 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,8 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,17 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,25 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,43 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,3 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,3 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,12 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,12 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,46 ,'' ,'' ,'nrivilla'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,46 ,'' ,'' ,'psanchez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,6 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,10 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,15 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,15 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,27 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,27 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,32 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,32 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,36 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,36 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,28 ,'' ,'' ,'mramosg'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,28 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,30 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,31 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,1 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,20 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,48 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,33 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,33 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,26 ,'' ,'' ,'pdiez'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,51 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,51 ,'' ,'' ,'mfuentesm'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,52 ,'' ,'' ,'gsantos'),
                       T_TIPO_DATA('GFORM' ,8 ,'' ,'' ,52 ,'' ,'' ,'mfuentesm'),
                       
                       
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,1 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,2 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,3 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,4 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,5 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,6 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,7 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,8 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,9 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,10 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,11 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,12 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,13 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,14 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,15 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,16 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,17 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,18 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,19 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,20 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,21 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,22 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,23 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,24 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,25 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,26 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,27 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,28 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,29 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,30 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,31 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,32 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,33 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,34 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,35 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,36 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,37 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,38 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,39 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,40 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,41 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,42 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,43 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,44 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,45 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,46 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,47 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,48 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,49 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,50 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,51 ,'' ,'' ,'garsa03'),
                       T_TIPO_DATA('GIAFORM' ,8 ,'' ,'' ,52 ,'' ,'' ,'garsa03')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
	          ' WHERE TIPO_GESTOR = ''GFORM'' AND COD_CARTERA = 8';
	EXECUTE IMMEDIATE V_SQL;
	
	
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
                  ' WHERE TIPO_GESTOR = ''GIAFORM'' AND COD_CARTERA = 8';
        EXECUTE IMMEDIATE V_SQL;
	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    

          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(4)||''','||V_TMP_TIPO_DATA(5)||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, ''REMVIP-1571'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA PROVINCIA: '||TRIM(V_TMP_TIPO_DATA(5)));
        
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

EXIT;

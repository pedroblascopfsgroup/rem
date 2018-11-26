--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2651
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar Situación posesoria de todos los activos que no la tengan
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);
  V_COUNT NUMBER(16);
    
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('332424'),
	T_TIPO_DATA('332426'),
	T_TIPO_DATA('332427'),
	T_TIPO_DATA('332428'),
	T_TIPO_DATA('332429'),
	T_TIPO_DATA('332431'),
	T_TIPO_DATA('332433'),
	T_TIPO_DATA('332434'),
	T_TIPO_DATA('333059'),
	T_TIPO_DATA('333060'),
	T_TIPO_DATA('333061'),
	T_TIPO_DATA('333063'),
	T_TIPO_DATA('333064'),
	T_TIPO_DATA('333065'),
	T_TIPO_DATA('333066'),
	T_TIPO_DATA('333067'),
	T_TIPO_DATA('333068'),
	T_TIPO_DATA('333069'),
	T_TIPO_DATA('333070'),
	T_TIPO_DATA('333071'),
	T_TIPO_DATA('333072'),
	T_TIPO_DATA('333074'),
	T_TIPO_DATA('333075'),
	T_TIPO_DATA('333076'),
	T_TIPO_DATA('333078'),
	T_TIPO_DATA('333079'),
	T_TIPO_DATA('333080'),
	T_TIPO_DATA('333082'),
	T_TIPO_DATA('333083'),
	T_TIPO_DATA('333084'),
	T_TIPO_DATA('333085'),
	T_TIPO_DATA('333086'),
	T_TIPO_DATA('333087'),
	T_TIPO_DATA('333090'),
	T_TIPO_DATA('333091'),
	T_TIPO_DATA('333092'),
	T_TIPO_DATA('333093'),
	T_TIPO_DATA('333094'),
	T_TIPO_DATA('333095'),
	T_TIPO_DATA('333100'),
	T_TIPO_DATA('333102'),
	T_TIPO_DATA('333103'),
	T_TIPO_DATA('333104'),
	T_TIPO_DATA('333106'),
	T_TIPO_DATA('333109'),
	T_TIPO_DATA('333110'),
	T_TIPO_DATA('333111'),
	T_TIPO_DATA('333112'),
	T_TIPO_DATA('333113'),
	T_TIPO_DATA('333114'),
	T_TIPO_DATA('333117'),
	T_TIPO_DATA('333118'),
	T_TIPO_DATA('333122'),
	T_TIPO_DATA('333124'),
	T_TIPO_DATA('333125'),
	T_TIPO_DATA('333741'),
	T_TIPO_DATA('334322'),
	T_TIPO_DATA('334326'),
	T_TIPO_DATA('334327'),
	T_TIPO_DATA('343213'),
	T_TIPO_DATA('343950'),
	T_TIPO_DATA('343952'),
	T_TIPO_DATA('343953'),
	T_TIPO_DATA('344496'),
	T_TIPO_DATA('344497'),
	T_TIPO_DATA('344499'),
	T_TIPO_DATA('344503'),
	T_TIPO_DATA('344504'),
	T_TIPO_DATA('344505'),
	T_TIPO_DATA('344507'),
	T_TIPO_DATA('344527'),
	T_TIPO_DATA('344532'),
	T_TIPO_DATA('344535'),
	T_TIPO_DATA('344538'),
	T_TIPO_DATA('344944'),
	T_TIPO_DATA('344947'),
	T_TIPO_DATA('344948'),
	T_TIPO_DATA('344949'),
	T_TIPO_DATA('344950'),
	T_TIPO_DATA('344951'),
	T_TIPO_DATA('344952'),
	T_TIPO_DATA('344953'),
	T_TIPO_DATA('344954'),
	T_TIPO_DATA('344955'),
	T_TIPO_DATA('344956'),
	T_TIPO_DATA('344958'),
	T_TIPO_DATA('344959'),
	T_TIPO_DATA('345000'),
	T_TIPO_DATA('345004'),
	T_TIPO_DATA('345126'),
	T_TIPO_DATA('345127'),
	T_TIPO_DATA('345128'),
	T_TIPO_DATA('345129'),
	T_TIPO_DATA('345130'),
	T_TIPO_DATA('345131'),
	T_TIPO_DATA('345132'),
	T_TIPO_DATA('345133'),
	T_TIPO_DATA('345134'),
	T_TIPO_DATA('345135'),
	T_TIPO_DATA('345136'),
	T_TIPO_DATA('345137'),
	T_TIPO_DATA('345138'),
	T_TIPO_DATA('345139'),
	T_TIPO_DATA('345143')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');

 DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_SPS ');
 
   -- LOOP para insertar los valores en ACT_SPS_SIT_POSESORIA, ZON_PEF_USU Y USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en usu_usuario--
       -------------------------------------------------

       --Si existe no se modifica
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ACT_SPS_SIT_POSESORIA');   
        
        V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA WHERE ACT_ID = '|| TRIM(V_TMP_TIPO_DATA(1)) ||'';
        
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        
        IF V_COUNT = 0 THEN
        
			V_MSQL := 'SELECT '||V_ESQUEMA||'.S_ACT_SPS_SIT_POSESORIA.NEXTVAL FROM DUAL';
			
			EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
			
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA (' ||
						  'SPS_ID
						  ,ACT_ID
						  ,VERSION
						  ,FECHACREAR
						  ,USUARIOCREAR
						  ,BORRADO) ' ||
						  'SELECT '|| V_ID || ',
						  '|| TRIM(V_TMP_TIPO_DATA(1)) ||',
						  ''0'',
						  SYSDATE,
						  ''REMVIP-2651'',
						  0 
						  FROM DUAL';
												
			  EXECUTE IMMEDIATE V_MSQL;
			  
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE');        
			
		END IF;
    
    END LOOP;
    
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

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

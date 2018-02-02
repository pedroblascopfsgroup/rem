--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.0.14-rem
--## INCIDENCIA_LINK=HREOS-3703
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza o inserta en ACT_GES_DIST_GESTORES
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar cosas 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COD_CARTERA NUMBER(16);
    V_UPDATE NUMBER(16);
    V_INSERT NUMBER(16);
    V_COD_PROVINCIA NUMBER(16);
	V_TIPO_GESTOR VARCHAR2(25 CHAR);
	V_HREOS VARCHAR2(25 CHAR) := 'HREOS-3703';
	V_USERNAME VARCHAR2(25 CHAR);
	V_NOMBRE_USUARIO VARCHAR2(62 CHAR);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

	--		TIPO_GESTOR	COD_CARTERA	COD_PROVINCIA USERNAME			  NOMBRE_USUARIO
	T_TIPO_DATA('GACT',		'1'		,'1'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'2'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'3'		,'mgarciade'		,'Maria del Mar Garcia Delgado'),
	T_TIPO_DATA('GACT',		'1'		,'4'		,'mperez'			,'Maria Perez Alonso'),
	T_TIPO_DATA('GACT',		'1'		,'5'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'6'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'7'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'8'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'9'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'10'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'11'		,'rguirado' 		,'Rosa Fernanda Guirado'),
	T_TIPO_DATA('GACT',		'1'		,'12'		,'mgarciade'		,'Maria del Mar Garcia Delgado'),
	T_TIPO_DATA('GACT',		'1'		,'13'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'14'		,'rguirado' 		,'Rosa Fernanda Guirado'),
	T_TIPO_DATA('GACT',		'1'		,'15'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'16'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'17'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'18'		,'rguirado' 		,'Rosa Fernanda Guirado'),
	T_TIPO_DATA('GACT',		'1'		,'19'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'20'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'21'		,'rguirado' 		,'Rosa Fernanda Guirado'),
	T_TIPO_DATA('GACT',		'1'		,'22'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'23'		,'rguirado' 		,'Rosa Fernanda Guirado'),
	T_TIPO_DATA('GACT',		'1'		,'24'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'25'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'26'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'27'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'28'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'29'		,'rguirado' 		,'Rosa Fernanda Guirado'),
	T_TIPO_DATA('GACT',		'1'		,'30'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'31'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'32'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'33'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'34'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'35'		,'mgarciade'  		,'Maria del Mar Garcia Delgado'),
	T_TIPO_DATA('GACT',		'1'		,'36'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'37'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'38'		,'mgarciade'		,'Maria del Mar Garcia Delgado'),
	T_TIPO_DATA('GACT',		'1'		,'39'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'40'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'41'		,'rguirado' 		,'Rosa Fernanda Guirado'),
	T_TIPO_DATA('GACT',		'1'		,'42'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'43'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'44'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'45'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'46'		,'maranda'  		,'María Elena Aranda'),
	T_TIPO_DATA('GACT',		'1'		,'47'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'48'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'49'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'50'		,'ndelaossa'		,'Nuria de la Ossa'),
	T_TIPO_DATA('GACT',		'1'		,'51'		,'rguirado' 		,'Rosa Fernanda Guirado'),
	T_TIPO_DATA('GACT',		'1'		,'52'		,'rguirado' 		,'Rosa Fernanda Guirado')

    ); 
    V_GESTOR T_TIPO_DATA;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_GESTOR := V_TIPO_DATA(I);
        
        V_TIPO_GESTOR 	 := V_GESTOR(1);
        V_COD_CARTERA 	 := V_GESTOR(2);
        V_COD_PROVINCIA  := V_GESTOR(3);
        V_USERNAME 		 := V_GESTOR(4);
        V_NOMBRE_USUARIO := V_GESTOR(5);
    	
    	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
    	USING (SELECT '''||V_TIPO_GESTOR||''' TIPO_GESTOR
    				, '||V_COD_CARTERA||' COD_CARTERA
    				, 0 COD_ESTADO_ACTIVO
    				, '||V_COD_PROVINCIA||' COD_PROVINCIA
    				, 0 COD_MUNICIPIO
    				, '''||V_USERNAME||''' USERNAME
    				, '''||V_NOMBRE_USUARIO||''' NOMBRE_USUARIO
    		 	FROM DUAL) T2
			 ON (T1.TIPO_GESTOR = T2.TIPO_GESTOR 
			 AND T1.COD_CARTERA = T2.COD_CARTERA
			 AND NVL(T1.COD_ESTADO_ACTIVO, 0) = T2.COD_ESTADO_ACTIVO
			 AND T1.COD_PROVINCIA = T2.COD_PROVINCIA
			 AND NVL(T1.COD_MUNICIPIO, 0) = T2.COD_MUNICIPIO
			 )
		WHEN MATCHED THEN UPDATE SET
			  T1.USERNAME = T2.USERNAME
			, T1.NOMBRE_USUARIO = T2.NOMBRE_USUARIO
			, T1.VERSION = T1.VERSION+1
			, USUARIOMODIFICAR = '''||V_HREOS||'''
			, FECHAMODIFICAR = SYSDATE
		WHERE T1.USERNAME <> T2.USERNAME
		WHEN NOT MATCHED THEN INSERT
			(   ID
			  , TIPO_GESTOR
			  , COD_CARTERA
			  , COD_PROVINCIA
			  , USERNAME
			  , NOMBRE_USUARIO
			  , USUARIOCREAR
			  , FECHACREAR
			) VALUES
			(
			    S_'||V_TABLA||'.NEXTVAL
			  , T2.TIPO_GESTOR
			  , T2.COD_CARTERA
			  , T2.COD_PROVINCIA
			  , T2.USERNAME
			  , T2.NOMBRE_USUARIO
			  , '''||V_HREOS||'''
			  , SYSDATE  
			)
    	';
    	
    	EXECUTE IMMEDIATE V_SQL;
      
      END LOOP;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADA LA TABLA '||V_TABLA);
      
      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOMODIFICAR = '''||V_HREOS||'''' INTO V_UPDATE;
      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_HREOS||'''' INTO V_INSERT;
      
      DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS '||V_UPDATE||' REGISTROS');
      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS '||V_INSERT||' REGISTROS');
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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

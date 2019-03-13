--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190313
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3587
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza en ACT_GES_DIST_GESTORES
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
	V_HREOS VARCHAR2(25 CHAR) := 'HREOS-3587';
	V_USERNAME VARCHAR2(25 CHAR);
	V_NOMBRE_USUARIO VARCHAR2(62 CHAR);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

	--		TIPO_GESTOR	COD_CARTERA	COD_PROVINCIA USERNAME			  NOMBRE_USUARIO
	T_TIPO_DATA('GIAADMT',		'8'		,'1'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'2'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'3'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'4'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'5'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'6'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'7'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'8'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'9'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'10'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'11'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'12'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'13'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'14'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'15'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'16'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'18'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'19'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'20'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'21'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'22'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'23'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'24'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'26'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'27'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'29'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'30'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'31'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'32'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'33'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'34'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'35'		,'pinos02'  	,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'36'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'37'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'38'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'39'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'40'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'41'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'42'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'44'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'46'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'47'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'48'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'49'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'50'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración '),
	T_TIPO_DATA('GIAADMT',		'8'		,'51'		,'pinos02'		,'GESTORIA PINOS XXI,S.L. Administración ')

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
    				, '||V_COD_PROVINCIA||' COD_PROVINCIA
    				, '''||V_USERNAME||''' USERNAME
    				, '''||V_NOMBRE_USUARIO||''' NOMBRE_USUARIO
    		 	FROM DUAL) T2
			 ON (T1.TIPO_GESTOR = T2.TIPO_GESTOR 
			 AND T1.COD_CARTERA = T2.COD_CARTERA
			 AND T1.COD_PROVINCIA = T2.COD_PROVINCIA
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

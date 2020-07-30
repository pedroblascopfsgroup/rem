--/*
--##########################################
--## AUTOR=JUAN BAUTISTA ALFONSO
--## FECHA_CREACION=20200729
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7859
--## PRODUCTO=NO
--## 
--## Finalidad: Script para poner antiocupa, ocupado y tapiado a 0 o 1, not null
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_SPS_SIT_POSESORIA';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7859';    
    

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('SPS_ACC_TAPIADO', 'NUMBER'),
	T_TIPO_DATA('SPS_ACC_ANTIOCUPA', 'NUMBER'),
	T_TIPO_DATA('SPS_OCUPADO', 'NUMBER')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
 
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and DATA_TYPE = '''||TRIM(V_TMP_TIPO_DATA(2))||''' and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 1 THEN
	  			 
			DBMS_OUTPUT.PUT_LINE('UPDATEANDO REGISTROS CON '''||TRIM(V_TMP_TIPO_DATA(1))||''' NULL A 0');

			V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
		  		SET '||TRIM(V_TMP_TIPO_DATA(1))||' = 0
		     		,USUARIOMODIFICAR = '''||V_USUARIO||'''
		     		,FECHAMODIFICAR = SYSDATE
		 		WHERE '||TRIM(V_TMP_TIPO_DATA(1))||' IS NULL';

		        EXECUTE IMMEDIATE V_SQL;	

			DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros en '''||TRIM(V_TMP_TIPO_DATA(1))||'''');  

		ELSE  
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' '||TRIM(V_TMP_TIPO_DATA(1))||'''... NO existe');    
	
	END IF;
      END LOOP;	
    COMMIT;

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

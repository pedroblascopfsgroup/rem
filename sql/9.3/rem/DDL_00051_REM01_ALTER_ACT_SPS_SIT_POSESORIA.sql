--/*
--##########################################
--## AUTOR=IVAN REPISO y JUAN BAUTISTA ALFONSO
--## FECHA_CREACION=20200731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7859
--## PRODUCTO=NO
--## Finalidad: AÑADIR DEFAULT A COLUMNA SPS_ACC_TAPIADO, SPS_ACC_ANTIOCUPA Y SPS_OCUPADO y NULLABLE NO - Actualiza datos null a 0 de campos 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_SPS_SIT_POSESORIA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7859'; 

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('SPS_ACC_TAPIADO', 'NUMBER','DEFAULT 0 NOT NULL'),
		T_TIPO_DATA('SPS_ACC_ANTIOCUPA', 'NUMBER','DEFAULT 0 NOT NULL'),
		T_TIPO_DATA('SPS_OCUPADO', 'NUMBER','DEFAULT 0 NOT NULL')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
BEGIN
		

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	LOOP      
        	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		DBMS_OUTPUT.PUT_LINE('[INICIO] UPDATE DATOS DE '''||TRIM(V_TMP_TIPO_DATA(1))||''' NULL A 0');

		-- Comprobamos si existe columna 
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and DATA_TYPE = '''||TRIM(V_TMP_TIPO_DATA(2))||''' and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 1 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
		  		SET '||TRIM(V_TMP_TIPO_DATA(1))||' = 0
		     		,USUARIOMODIFICAR = '''||V_USUARIO||'''
		     		,FECHAMODIFICAR = SYSDATE
		 		WHERE '||TRIM(V_TMP_TIPO_DATA(1))||' IS NULL';

		        EXECUTE IMMEDIATE V_MSQL;	

			DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros en '''||TRIM(V_TMP_TIPO_DATA(1))||'''');    

    		COMMIT;
	    
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY '||TRIM(V_TMP_TIPO_DATA(1))||' '||TRIM(V_TMP_TIPO_DATA(3))||'';
			DBMS_OUTPUT.PUT_LINE('	[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||TRIM(V_TMP_TIPO_DATA(1))||'... MODIFICADA');   
		
		ELSE  
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||TRIM(V_TMP_TIPO_DATA(1))||'''... NO existe');   
 
       		END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN] ALTER TABLE '''||TRIM(V_TMP_TIPO_DATA(1))||''' A NOT NULL Y DEFAULT 0');
      END LOOP;

	  DBMS_OUTPUT.PUT_LINE('[FIN]');		

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
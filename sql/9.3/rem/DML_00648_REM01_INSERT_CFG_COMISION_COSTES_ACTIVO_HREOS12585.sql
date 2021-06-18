--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20210617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9902
--## PRODUCTO=NO
--##
--## Finalidad: Script que crea la tabla CFG_COMISION_COSTES_ACTIVO con los datos añadidos en T_ARRAY_DATA
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
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-9902';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CFG_COMISION_COSTES_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    V_ID_ACT NUMBER(16,0); 
    V_ID_SACT NUMBER(16,0); 
    V_ID_TCM NUMBER(16,0); 
    V_ID_CRA NUMBER(16,0); 
    V_ID_CLA VARCHAR2(16);
    V_ID_TPR VARCHAR2(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- CFG_COMISION_COSTES_ACTIVO   DD_TCT_CODIGO  DD_TCT_PORCENTAJE  
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('16','NULL','NULL','03','13','B_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','03','14','B_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','03','16','B_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','05','20','B_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','05','21','B_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','05','22','B_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','04','17','B_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','04','18','B_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','04','37','B_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','07','24','A_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','07','25','A_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','01','01','C_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','01','02','C_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','01','03','C_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','01','04','C_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','01','27','C_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','02','05','A_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','02','06','A_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','02','07','A_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','02','08','A_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','02','09','A_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','02','10','A_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','02','11','A_BBVA'),
        T_TIPO_DATA('16','NULL','NULL','02','12','A_BBVA'),
        T_TIPO_DATA('01','02','04','03','13','B_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','03','14','B_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','03','16','B_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','05','20','B_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','05','21','B_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','05','22','B_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','04','17','B_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','04','18','B_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','04','37','B_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','07','24','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','07','25','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','01','01','C_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','01','02','C_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','01','03','C_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','01','04','C_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','01','27','C_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','02','05','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','02','06','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','02','07','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','02','08','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','02','09','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','02','10','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','02','11','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','04','02','12','A_CAJAMAR_API'),
        T_TIPO_DATA('01','02','29','03','13','B_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','03','14','B_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','03','16','B_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','05','20','B_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','05','21','B_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','05','22','B_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','04','17','B_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','04','18','B_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','04','37','B_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','07','24','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','07','25','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','01','01','C_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','01','02','C_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','01','03','C_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','01','04','C_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','01','27','C_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','02','05','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','02','06','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','02','07','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','02','08','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','02','09','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','02','10','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','02','11','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','02','29','02','12','A_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','04','03','13','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','03','14','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','03','16','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','05','20','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','05','21','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','05','22','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','04','17','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','04','18','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','04','37','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','07','24','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','07','25','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','01','01','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','01','02','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','01','03','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','01','04','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','01','27','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','02','05','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','02','06','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','02','07','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','02','08','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','02','09','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','02','10','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','02','11','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','04','02','12','D_CAJAMAR_API'),
        T_TIPO_DATA('01','01','29','03','13','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','03','14','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','03','16','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','05','20','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','05','21','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','05','22','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','04','17','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','04','18','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','04','37','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','07','24','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','07','25','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','01','01','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','01','02','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','01','03','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','01','04','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','01','27','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','02','05','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','02','06','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','02','07','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','02','08','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','02','09','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','02','10','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','02','11','D_CAJAMAR_OFICINA'),
        T_TIPO_DATA('01','01','29','02','12','D_CAJAMAR_OFICINA')
        
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ELIMINAMOS REGISTROS EN '||V_TEXT_TABLA||' ');
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
		
	END IF;
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        
         EXECUTE IMMEDIATE 'SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''' INTO V_ID_CRA;
         
         
      	IF V_TMP_TIPO_DATA(2) <> 'NULL' THEN
        
	       	EXECUTE IMMEDIATE 'SELECT DD_CLA_ID FROM '|| V_ESQUEMA ||'.DD_CLA_CLASE_ACTIVO WHERE DD_CLA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''' INTO V_ID_CLA;
	        
   		 ELSE
	    	
	    	V_ID_CLA := V_TMP_TIPO_DATA(2);
	    	
   		END IF;
   		
	   	
         
         IF V_TMP_TIPO_DATA(3) <> 'NULL' THEN
        
	       	EXECUTE IMMEDIATE 'SELECT DD_TPR_ID FROM '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''' INTO V_ID_TPR;
	        
   		 ELSE
	    	
	    	V_ID_TPR := V_TMP_TIPO_DATA(3);
	    	
   		END IF;
   		
   		

         EXECUTE IMMEDIATE 'SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''' INTO V_ID_ACT;
         

         EXECUTE IMMEDIATE 'SELECT DD_SAC_ID FROM '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO WHERE DD_SAC_CODIGO = '''||V_TMP_TIPO_DATA(5)||'''' INTO V_ID_SACT;
         

         EXECUTE IMMEDIATE 'SELECT DD_TCM_ID FROM '|| V_ESQUEMA ||'.DD_TCM_TIPO_COMISION WHERE DD_TCM_CODIGO = '''||V_TMP_TIPO_DATA(6)||'''' INTO V_ID_TCM;
         

         V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
	                  CFG_CCA_ID, DD_CRA_ID, DD_CLA_ID, DD_TPR_ID, DD_TPA_ID, DD_SAC_ID, DD_TCM_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES(
	                   '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
	                   ,'||V_ID_CRA||','||V_ID_CLA||','||V_ID_TPR||','||V_ID_ACT||','||V_ID_SACT||','||V_ID_TCM||'
	                   ,0,'''||V_ITEM||''',SYSDATE,0)';

         
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');
   

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

--/*
--##########################################
--## AUTOR=CARLOS PEREZ
--## FECHA_CREACION=20151016
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=--
--## PRODUCTO=SI
--## 
--## Finalidad: Insertar datos en tabla TPL_TIPO_POLICITA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

 
 TYPE T_MPH IS TABLE OF VARCHAR2(500);
 TYPE T_ARRAY_MPH IS TABLE OF T_MPH; 

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
  
 V_ESQUEMA 			VARCHAR2(25 CHAR):= '#ESQUEMA#'; 							-- Configuracion Esquema
 V_ESQUEMA_MASTER   		VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 					-- Configuracion Esquema Master
 v_column_count  		NUMBER(3); 									-- Vble. para validar la existencia de las Columnas.
 v_constraint_count 		NUMBER(3); 									-- Vble. para validar la existencia de las Constraints.
 err_num  			NUMBER; 									-- Numero de errores
 err_msg  			VARCHAR2(2048); 								-- Mensaje de error 
 V_MSQL 			VARCHAR2(4000 CHAR);
 V_EXIST  			NUMBER(10);
 V_ENTIDAD_ID  			NUMBER(16); 
 

--Código de tabla


   V_MPH T_ARRAY_MPH := T_ARRAY_MPH(		   
     T_MPH('TPL01','ASC','Mantener','0','0','0','0','DD','SYSDATE','0')
    , T_MPH('TPL02','DES','Extinguir','0','0','0','0','DD','SYSDATE','0')
    , T_MPH('TPL03','DES','Dación en pago','0','0','0','0','DD','SYSDATE','0')
    , T_MPH('TPL04','MAN','Reestructurar','0','0','0','0','DD','SYSDATE','0')
    , T_MPH('TPL05','MAN','Recuperación judicial','0','0','0','0','DD','SYSDATE','0')
    , T_MPH('TPL02b','DES','Refinanciar','0','0','0','0','DD','SYSDATE','0')
    , T_MPH('TPL05b','MAN','Seguir','0','0','0','0','DD','SYSDATE','0')
		 );
		 

 V_TMP_MPH T_MPH;	

BEGIN

 
 V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = 'S_TPL_TIPO_POLITICA' and sequence_owner= V_ESQUEMA;
 
 if V_ENTIDAD_ID is null OR V_ENTIDAD_ID = 0 then     
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_TPL_TIPO_POLITICA
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER'); 
 end if;
 
 
 FOR I IN V_MPH.FIRST .. V_MPH.LAST
 LOOP
 
  V_TMP_MPH := V_MPH(I);
 -- V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL FROM DUAL';
--  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;


  DBMS_OUTPUT.PUT_LINE('Creando TPL_TIPO_POLITICA: '||V_TMP_MPH(1)); 

  V_MSQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.TPL_TIPO_POLITICA WHERE TPL_CODIGO = ''' || V_TMP_MPH(1) || '''';
  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
  
  if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] LA POLITICA '||V_TMP_MPH(1) || ' YA EXISTE'); 
  ELSE
  
      V_MSQL := 'INSERT INTO ' ||V_ESQUEMA|| '.TPL_TIPO_POLITICA 
            (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
             values (S_TPL_TIPO_POLITICA.NEXTVAL,'''
                        ||V_TMP_MPH(1)||q'[',]' 
                        ||q'[(select ten_id from ]' ||V_ESQUEMA|| q'[.TEN_TENDENCIA where ten_codigo = ']'||V_TMP_MPH(2)||q'['),']'                    
                        ||V_TMP_MPH(3)||q'[',']' 
                        ||V_TMP_MPH(4)||q'[',']'
                        ||V_TMP_MPH(5)||q'[',']' 
                        ||V_TMP_MPH(6)||q'[',']' 
                        ||V_TMP_MPH(7)||q'[',']'  
                        ||V_TMP_MPH(8)||q'[',]'  
                        ||V_TMP_MPH(9)||q'[,']' 
                        ||V_TMP_MPH(10)||q'[')]' 
                        ;
             
    
      DBMS_OUTPUT.PUT_LINE('Creando TPL_POLITICA: '||V_TMP_MPH(1));
      --DBMS_OUTPUT.PUT_LINE (V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
    END IF;
    
   END LOOP; 
   V_TMP_MPH := NULL; 

 COMMIT;


 EXCEPTION

 WHEN OTHERS THEN  
   err_num := SQLCODE;
   err_msg := SQLERRM;

   DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
   DBMS_OUTPUT.put_line(err_msg);
  
   ROLLBACK;
   RAISE;
 END;
 /
 EXIT;

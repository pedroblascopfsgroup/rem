--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151016
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-924  
--## PRODUCTO=NO
--## 
--## Finalidad: Acualizar diccionarios para DD_PAR_PARCELAS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

 
 TYPE T_PAR IS TABLE OF VARCHAR2(1000);
 TYPE T_ARRAY_PAR IS TABLE OF T_PAR; 

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
  
 V_ESQUEMA 			             VARCHAR2(25 CHAR):= '#ESQUEMA#'; 				          -- Configuracion Esquema
 V_ESQUEMA_MASTER    		     VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 			-- Configuracion Esquema Master
 seq_count 			             NUMBER(3); 						                      -- Vble. para validar la existencia de las Secuencias.
 table_count 		     	       NUMBER(3); 						                      -- Vble. para validar la existencia de las Tablas.
 v_column_count  	   	       NUMBER(3); 					                      	-- Vble. para validar la existencia de las Columnas.
 v_constraint_count  		     NUMBER(3); 						                      -- Vble. para validar la existencia de las Constraints.
 err_num  			             NUMBER; 							                        -- Numero de errores
 err_msg  			             VARCHAR2(2048); 						                  -- Mensaje de error 
 V_MSQL 			               VARCHAR2(4000 CHAR);
 V_EXIST  			             NUMBER(10);
 V_ENTIDAD_ID  		   	       NUMBER(16); 
 V_ENTIDAD 			             NUMBER(16);

 V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   
				   --Código de tabla

   V_PAR T_ARRAY_PAR := T_ARRAY_PAR(
				   T_PAR ('1','ACTIVIDAD','Actividad','Actividad','CUANTITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_PAR ('2','PROD.MERCADO','Productos/Mercado','Productos/Mercado','CUANTITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_PAR ('3','SOLVENCIA','Solvencia','Solvencia','CUALITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_PAR ('4','CAPREEMB','Capacidad de Reembolso','Capacidad de Reembolso','CUALITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_PAR ('5','ACCIONADO','Accionado','Accionado','CUANTITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_PAR ('6','GERENCIA','Gerencia','Gerencia','CUANTITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_PAR ('7','GRUPO','Grupo','Grupo','CUANTITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_PAR ('8','MATPRIMA','Materia Prima','Materia Prima','CUANTITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_PAR ('9','INSTALAC','Instalaciones','Instalaciones','CUANTITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_PAR ('10','PLANTILLA','Plantilla','Plantilla','CUANTITATIVO','0','DD',SYSDATE,'null','null','null','null','0')
				 );
				 
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/

 V_TMP_PAR T_PAR;
 
 BEGIN

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_PAR_PARCELAS');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.DD_PAR_PARCELAS');
 
 --CONTADORES

 DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
 
 V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = 'S_DD_PAR_PARCELAS' and sequence_owner= V_ESQUEMA;
 
 if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
 DBMS_OUTPUT.PUT_LINE('Contador 1');
 EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA|| '.S_DD_PAR_PARCELAS');
 end if;
 
 EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_DD_PAR_PARCELAS
 START WITH 1
 MAXVALUE 999999999999999999999999999
 MINVALUE 1
 NOCYCLE
 CACHE 20
 NOORDER'
  ); 

 DBMS_OUTPUT.PUT_LINE('Creando DD_PAR_PARCELAS......');
 FOR I IN V_PAR.FIRST .. V_PAR.LAST
 LOOP
 
  V_TMP_PAR := V_PAR(I);
  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_PAR_PARCELAS.NEXTVAL FROM DUAL';
  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
  
  --FIN CONTADORES
  
  --INICIO INSERT
 
  DBMS_OUTPUT.PUT_LINE('Creando DD_PAR_PARCELAS: '||V_TMP_PAR(1)); 

  
  
  V_MSQL := 'INSERT INTO ' ||V_ESQUEMA|| '.DD_PAR_PARCELAS 
           ( DD_PAR_ID,DD_PAR_CODIGO,DD_PAR_DESCRIPCION,DD_PAR_DESCRIPCION_LARGA,DD_TAN_ID,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO)'

	 ||' VALUES (
                   '||V_TMP_PAR(1)||q'[,']'
                    ||V_TMP_PAR(2)||q'[',']' 
                    ||V_TMP_PAR(3)||q'[',']' 
                    ||V_TMP_PAR(4)||q'[',]'
                    ||q'[(select DD_TAN_ID FROM ]' ||V_ESQUEMA|| q'[.DD_TAN_TIPO_ANALISIS WHERE DD_TAN_CODIGO = ']'||V_TMP_PAR(5)||q'['),]' 
                    ||V_TMP_PAR(6)||q'[,']' 
                    ||V_TMP_PAR(7)||q'[',']' 
                    ||V_TMP_PAR(8)||q'[',']' 
                    ||V_TMP_PAR(9)||q'[',]' 
                    ||V_TMP_PAR(10)||q'[,]'
                    ||V_TMP_PAR(11)||q'[,]' 
                    ||V_TMP_PAR(12)||q'[,]'
                    ||V_TMP_PAR(13)||q'[)]';
 
 
 --DBMS_OUTPUT.put_line(V_MSQL);

   EXECUTE IMMEDIATE V_MSQL;
   END LOOP; 
   V_TMP_PAR := NULL; 

 COMMIT;
 
 --FINAL INSERT
 
 --EXCEPCIONES

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
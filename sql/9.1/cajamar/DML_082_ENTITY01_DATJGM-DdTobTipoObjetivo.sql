--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151016
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-924  
--## PRODUCTO=NO
--## 
--## Finalidad: Acualizar diccionarios para TOB_TIPO_OBJETIVO
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

 
 TYPE T_TOB IS TABLE OF VARCHAR2(1000);
 TYPE T_ARRAY_TOB IS TABLE OF T_TOB; 

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
  
 V_ESQUEMA 			             VARCHAR2(25 CHAR):= '#ESQUEMA#'; 				    -- Configuracion Esquema
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

   V_TOB T_ARRAY_TOB := T_ARRAY_TOB(
				   T_TOB ('1','TOB01','Objetivo manual','null','0','0','null','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('2','TOB02','Riesgo Directo de persona','null','1','0','RDP','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('3','TOB03','Riesgo Indirecto de persona','null','1','0','RIP','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('4','TOB04','Riesgo Irregular de persona','null','1','0','RIrrP','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('5','TOB05','Riesgo Garantizado de persona','null','1','0','RGP','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('6','TOB06','Riesgo no Garantizado de persona','null','1','0','RNGP','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('7','TOB07','Porcentaje Riesgo no Garantizado - RD de persona','null','1','0','RNG/RD','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('8','TOB08','Porcentaje Riesgo Irregular - RD de persona','null','1','0','RIrr/RD','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('9','TOB09','Riesgo de contrato','null','1','1','RC','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('10','TOB10','Riesgo Irregular de contrato','null','1','1','RIrrC','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('11','TOB11','Riesgo Garantizado de contrato','null','1','1','RGC','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('12','TOB12','Riesgo no Garantizado de contrato','null','1','1','RNGC','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('13','TOB13','Límite descubierto de contrato','null','1','1','LDC','0','DD',SYSDATE,'null','null','null','null','0')
				 , T_TOB ('14','TOB14','Dispuesto de contrato','null','1','1','DC','0','DD',SYSDATE,'null','null','null','null','0')
				 );
				 
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/

 V_TMP_TOB T_TOB;
 
 BEGIN

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de TOB_TIPO_OBJETIVO');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.TOB_TIPO_OBJETIVO');
 
 --CONTADORES

 DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
 
 V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = 'S_TOB_TIPO_OBJETIVO' and sequence_owner= V_ESQUEMA;
 
 if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
 DBMS_OUTPUT.PUT_LINE('Contador 1');
 EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA|| '.S_TOB_TIPO_OBJETIVO');
 end if;
 
 EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_TOB_TIPO_OBJETIVO
 START WITH 1
 MAXVALUE 999999999999999999999999999
 MINVALUE 1
 NOCYCLE
 CACHE 20
 NOORDER'
  ); 

 DBMS_OUTPUT.PUT_LINE('Creando TOB_TIPO_OBJETIVO......');
 FOR I IN V_TOB.FIRST .. V_TOB.LAST
 LOOP
 
  V_TMP_TOB := V_TOB(I);
  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TOB_TIPO_OBJETIVO.NEXTVAL FROM DUAL';
  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
  
  --FIN CONTADORES
  
  --INICIO INSERT
 
  DBMS_OUTPUT.PUT_LINE('Creando TOB_TIPO_OBJETIVO: '||V_TMP_TOB(1)); 

  
  
  V_MSQL := 'INSERT INTO ' ||V_ESQUEMA|| '.TOB_TIPO_OBJETIVO 
           ( TOB_ID,TOB_CODIGO,TOB_DESCRIPCION,TOB_DESCRIPCION_LARGA,TOB_AUTOMATICO,TOB_CONTRATO,CDO_ID,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO)'

	 ||' VALUES (
                   '||V_TMP_TOB(1)||q'[,']'
                    ||V_TMP_TOB(2)||q'[',']' 
                    ||V_TMP_TOB(3)||q'[',]' 
                    ||V_TMP_TOB(4)||q'[,]'
                    ||V_TMP_TOB(5)||q'[,]' 
                    ||V_TMP_TOB(6)||q'[,]' 
                    ||q'[(select CDO_ID FROM ]' ||V_ESQUEMA|| q'[.CDO_CAMPO_DESTINO_OBJETIVO WHERE CDO_CODIGO = ']'||V_TMP_TOB(7)||q'['),]'
                    ||V_TMP_TOB(8)||q'[,']' 
                    ||V_TMP_TOB(9)||q'[',']' 
                    ||V_TMP_TOB(10)||q'[',]'
                    ||V_TMP_TOB(11)||q'[,]' 
                    ||V_TMP_TOB(12)||q'[,]' 
                    ||V_TMP_TOB(13)||q'[,]'
                    ||V_TMP_TOB(14)||q'[,]'
                    ||V_TMP_TOB(15)||q'[)]';
 
 
 --DBMS_OUTPUT.put_line(V_MSQL);

   EXECUTE IMMEDIATE V_MSQL;

   END LOOP; 
   V_TMP_TOB := NULL; 

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
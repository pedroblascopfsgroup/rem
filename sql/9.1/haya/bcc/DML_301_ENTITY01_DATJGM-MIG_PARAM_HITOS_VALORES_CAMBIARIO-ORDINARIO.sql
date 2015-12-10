--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151013
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-911
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar datos en tabla MIG_PARAM_HITOS_VALORES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

 
 TYPE T_MPH IS TABLE OF VARCHAR2(1000);
 TYPE T_ARRAY_MPH IS TABLE OF T_MPH; 

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
  
 V_ESQUEMA 			     VARCHAR2(25 CHAR):= '#ESQUEMA#'; 				-- Configuracion Esquema
 V_ESQUEMA_MASTER    		     VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 			-- Configuracion Esquema Master
 seq_count 			     NUMBER(3); 						-- Vble. para validar la existencia de las Secuencias.
 table_count 		     	     NUMBER(3); 						-- Vble. para validar la existencia de las Tablas.
 v_column_count  	   	     NUMBER(3); 						-- Vble. para validar la existencia de las Columnas.
 v_constraint_count  		     NUMBER(3); 						-- Vble. para validar la existencia de las Constraints.
 err_num  			     NUMBER; 							-- Numero de errores
 err_msg  			     VARCHAR2(2048); 						-- Mensaje de error 
 V_MSQL 			     VARCHAR2(4000 CHAR);
 V_EXIST  			     NUMBER(10);
 V_ENTIDAD_ID  		   	     NUMBER(16); 
 V_ENTIDAD 			     NUMBER(16);

 V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Código de tabla

   V_MPH T_ARRAY_MPH := T_ARRAY_MPH(
				   T_MPH ('1','1','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H016_interposicionDemandaMasBienes','fecha')
				 , T_MPH ('2','1','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H016_interposicionDemandaMasBienes','comboPlaza')
				 , T_MPH ('3','1','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H016_interposicionDemandaMasBienes','fechaCierre')
				 , T_MPH ('4','1','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H016_interposicionDemandaMasBienes','principalDemanda')
				 , T_MPH ('5','1','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H016_interposicionDemandaMasBienes','interesesOrdinarios')
				 , T_MPH ('6','1','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H016_interposicionDemandaMasBienes','provisionFondos')
				 , T_MPH ('7','2','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H016_confAdmiDecretoEmbargo','fecha')
				 , T_MPH ('8','2','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H016_confAdmiDecretoEmbargo','comboPlaza')
				 , T_MPH ('9','2','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H016_confAdmiDecretoEmbargo','comboJuzgado')
				 , T_MPH ('10','2','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H016_confAdmiDecretoEmbargo','numProcedimiento')
				 , T_MPH ('11','2','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H016_confAdmiDecretoEmbargo','comboAdmision')
				 , T_MPH ('12','2','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(COUNT(1),0,0,1)','6','0','H016_confAdmiDecretoEmbargo','comboBienes')
				 , T_MPH ('13','4','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H016_confNotifRequerimientoPago','fecha')
				 , T_MPH ('14','4','MIG_PROCEDIMIENTOS_DEMANDADOS','REQUERIDO','2','0','H016_confNotifRequerimientoPago','comboResultado')
				 , T_MPH ('15','5','MIG_PROCEDIMIENTOS_EMBARGOS','MIN(FECHA_REGISTRO_EMBARGO)','1','1','H062_confirmarAnotacionRegistro','fecha')
				 , T_MPH ('16','5','MIG_PROCEDIMIENTOS_CABECERA','1','2','0','H062_confirmarAnotacionRegistro','comboAlerta')
				 , T_MPH ('17','6','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','1','1','H016_registrarDemandaOposicion','fecha')
				 , T_MPH ('18','6','MIG_PROCEDIMIENTOS_DEMANDADOS','NVL(MAX(OPOSICION),0)','2','0','H016_registrarDemandaOposicion','comboOposicion')
				 , T_MPH ('19','6','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','3','0','H016_registrarDemandaOposicion','fechaVista')
				 , T_MPH ('20','7','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H016_registrarJuicioComparecencia','fecha')
				 , T_MPH ('21','8','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_registrarResolucion','fecha')
				 , T_MPH ('22','8','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(RESULTADO_RESOLUCION,2,1,0)','2','0','H016_registrarResolucion','comboResultado')
				 , T_MPH ('23','9','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_resolucionFirme','fecha')
				 , T_MPH ('24','10','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_CambiarioDecision','fecha')
				 , T_MPH ('25','12','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H024_InterposicionDemanda','fecha')
				 , T_MPH ('26','12','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_InterposicionDemanda','plazaJuzgado')
				 , T_MPH ('27','12','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H024_InterposicionDemanda','fechaCierre')
				 , T_MPH ('28','12','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H024_InterposicionDemanda','principalDemanda')
				 , T_MPH ('29','12','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H024_InterposicionDemanda','interesesOrdinarios')
				 , T_MPH ('30','12','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H024_InterposicionDemanda','provisionFondos')
				 , T_MPH ('31','13','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H024_ConfirmarAdmision','fecha')
				 , T_MPH ('32','13','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_ConfirmarAdmision','nPlaza')
				 , T_MPH ('33','13','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H024_ConfirmarAdmision','numJuzgado')
				 , T_MPH ('34','13','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H024_ConfirmarAdmision','numProcedimiento')
				 , T_MPH ('35','13','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H024_ConfirmarAdmision','comboResultado')
				 , T_MPH ('36','15','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H024_ConfirmarNotDemanda','fecha')
				 , T_MPH ('37','15','MIG_PROCEDIMIENTOS_DEMANDADOS','REQUERIDO','2','0','H024_ConfirmarNotDemanda','comboResultado')
				 , T_MPH ('38','16','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','1','1','H024_ConfirmarOposicion','fechaOposicion')
				 , T_MPH ('39','16','MIG_PROCEDIMIENTOS_DEMANDADOS','NVL(MAX(OPOSICION),0)','2','0','H024_ConfirmarOposicion','comboResultado')
				 , T_MPH ('40','16','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','3','0','H024_ConfirmarOposicion','fechaAudiencia')
				 , T_MPH ('41','17','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','1','1','H024_RegistrarAudienciaPrevia','fechaJuicio')
				 , T_MPH ('42','17','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(RESULTADO_VISTA,1,1,0)','2','0','H024_RegistrarAudienciaPrevia','comboResultado')
				 , T_MPH ('43','18','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H024_RegistrarJuicio','fecha')
				 , T_MPH ('44','19','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H024_RegistrarResolucion','fecha')
				 , T_MPH ('45','19','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(RESULTADO_RESOLUCION,2,1,0)','2','0','H024_RegistrarResolucion','comboResultado')
				 , T_MPH ('46','20','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H024_ResolucionFirme','fecha')
				 );
				 
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/

 V_TMP_MPH T_MPH;
 
 BEGIN

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de MIG_PARAM_HITOS_VALORES');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.MIG_PARAM_HITOS_VALORES');
 
 --CONTADORES

 DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
 
 V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = 'S_MIG_PARAM_HITOS_VALORES' and sequence_owner= V_ESQUEMA;
 
 if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
 DBMS_OUTPUT.PUT_LINE('Contador 1');
 EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA|| '.S_MIG_PARAM_HITOS_VALORES');
 end if;
 
 EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_MIG_PARAM_HITOS_VALORES
 START WITH 1
 MAXVALUE 999999999999999999999999999
 MINVALUE 1
 NOCYCLE
 CACHE 20
 NOORDER'
  ); 

  DBMS_OUTPUT.PUT_LINE('Creando MIG_PARAM_HITOS_VALORES......');
 FOR I IN V_MPH.FIRST .. V_MPH.LAST
 LOOP
 
  V_TMP_MPH := V_MPH(I);
  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_MIG_PARAM_HITOS_VALORES.NEXTVAL FROM DUAL';
  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
  
  --FIN CONTADORES
  
  --INICIO INSERT
 
  DBMS_OUTPUT.PUT_LINE('Creando MIG_PARAM_HITOS_VALORES: '||V_TMP_MPH(1)); 

  
  
  V_MSQL := 'INSERT INTO ' ||V_ESQUEMA|| '.MIG_PARAM_HITOS_VALORES 
           ( MIG_PHV_ID,MIG_PARAM_HITO_ID,TABLA_MIG,CAMPO_INTERFAZ,ORDEN,FLAG_ES_FECHA,TAP_CODIGO,TEV_NOMBRE)'
            /*||', VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' || ' */
	 ||' VALUES (
                   '||V_TMP_MPH(1)||q'[,]'
                    ||V_TMP_MPH(2)||q'[,']' 
                    ||V_TMP_MPH(3)||q'[',']' 
                    ||V_TMP_MPH(4)||q'[',]'
                    ||V_TMP_MPH(5)||q'[,]' 
                    ||V_TMP_MPH(6)||q'[,']' 
                    ||V_TMP_MPH(7)||q'[',']'   
                    ||V_TMP_MPH(8)||q'[')]';
 

   EXECUTE IMMEDIATE V_MSQL;
   END LOOP; 
   V_TMP_MPH := NULL; 

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

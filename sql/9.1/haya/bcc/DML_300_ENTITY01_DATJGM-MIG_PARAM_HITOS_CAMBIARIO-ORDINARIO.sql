--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151008
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-911
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar datos en tabla MIG_PARAM_HITOS
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
 seq_count 			NUMBER(3); 									-- Vble. para validar la existencia de las Secuencias.
 table_count 			NUMBER(3); 									-- Vble. para validar la existencia de las Tablas.
 v_column_count  		NUMBER(3); 									-- Vble. para validar la existencia de las Columnas.
 v_constraint_count 		NUMBER(3); 									-- Vble. para validar la existencia de las Constraints.
 err_num  			NUMBER; 									-- Numero de errores
 err_msg  			VARCHAR2(2048); 								-- Mensaje de error 
 V_MSQL 			VARCHAR2(4000 CHAR);
 V_EXIST  			NUMBER(10);
 V_ENTIDAD_ID  			NUMBER(16); 
 V_ENTIDAD 			NUMBER(16);

 V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Código de tabla


   V_MPH T_ARRAY_MPH := T_ARRAY_MPH(
		   T_MPH ('1','35','Cambiario','H016','P. Cambiario - HCJ','1','H016_interposicionDemandaMasBienes','1','Interposición de la demanda más marcado de bienes','0','0')
		 , T_MPH ('2','35','Cambiario','H016','P. Cambiario - HCJ','2','H016_confAdmiDecretoEmbargo','2','Confirmar admisión más marcado bienes decreto embargo','0','0')
		 , T_MPH ('3','35','Cambiario','HC103','T. Provisión Fondos - HCJ','2','HC103_SolicitarProvision','3','Solicitar provisión','0','0')
		 , T_MPH ('4','35','Cambiario','H016','P. Cambiario - HCJ','3','H016_confNotifRequerimientoPago','4','Confirmar notificación requerimiento de pago','0','0')
		 , T_MPH ('5','35','Cambiario','H062','T. Vigilancia y Caducidad Embargos - HCJ','3','H062_confirmarAnotacionRegistro','5','Confirmar anotación en el registro','0','0')
		 , T_MPH ('6','35','Cambiario','H016','P. Cambiario - HCJ','5','H016_registrarDemandaOposicion','6','Registrar demanda de oposición','0','0')
		 , T_MPH ('7','35','Cambiario','H016','P. Cambiario - HCJ','6','H016_registrarJuicioComparecencia','7','Registrar juicio y comparecencia','0','1')
		 , T_MPH ('8','35','Cambiario','H016','P. Cambiario - HCJ','6','H016_registrarResolucion','8','Registrar resolución','0','0')
		 , T_MPH ('9','35','Cambiario','H016','P. Cambiario - HCJ','7','H016_resolucionFirme','9','Resolución firme','0','0')
		 , T_MPH ('10','35','Cambiario','H016','P. Cambiario - HCJ','8','H016_CambiarioDecision','10','Tarea toma de decisión','0','0')
		 , T_MPH ('11','35','Cambiario','H030','T. certificación de cargas y revisión - HCJ','9','H030_SolicitarInformacionCargasAnt','11','Solicitar información de cargas anteriores','0','0')
		 , T_MPH ('12','33','Declarativo Ordinario','H024','P. ordinario - HCJ','10','H024_InterposicionDemanda','1','Interposición de la demanda','0','0')
		 , T_MPH ('13','33','Declarativo Ordinario','H024','P. ordinario - HCJ','11','H024_ConfirmarAdmision','2','Confirmar admisión de la demanda','0','0')
		 , T_MPH ('14','33','Declarativo Ordinario','HC103','T. Provisión Fondos - HCJ','11','HC103_SolicitarProvision','3','Solicitar provisión','0','0')
		 , T_MPH ('15','33','Declarativo Ordinario','H024','P. ordinario - HCJ','12','H024_ConfirmarNotDemanda','4','Confirmar notificación de la demanda','0','0')
		 , T_MPH ('16','33','Declarativo Ordinario','H024','P. ordinario - HCJ','13','H024_ConfirmarOposicion','5','Confirmar si existe oposición','0','1')
		 , T_MPH ('17','33','Declarativo Ordinario','H024','P. ordinario - HCJ','13','H024_RegistrarAudienciaPrevia','6','Registrar audiencia prévia','0','0')
		 , T_MPH ('18','33','Declarativo Ordinario','H024','P. ordinario - HCJ','14','H024_RegistrarJuicio','7','Confirmar celebración juicio','0','0')
		 , T_MPH ('19','33','Declarativo Ordinario','H024','P. ordinario - HCJ','15','H024_RegistrarResolucion','8','Registrar resolucion','0','0')
		 , T_MPH ('20','33','Declarativo Ordinario','H024','P. ordinario - HCJ','16','H024_ResolucionFirme','9','Resolución firme','0','0')
		 , T_MPH ('21','33','Declarativo Ordinario','H024','P. ordinario - HCJ','19','H024_OrdinarioDecision','10','Tarea toma de decisión','0','0')
		 );
		 
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  

 V_TMP_MPH T_MPH;	

BEGIN

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de MIG_PARAM_HITOS');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.MIG_PARAM_HITOS_VALORES');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.MIG_PARAM_HITOS');
 
 --CONTADORES
 
 DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
 
 V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = 'S_MIG_PARAM_HITOS' and sequence_owner= V_ESQUEMA;
 
 if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
 DBMS_OUTPUT.PUT_LINE('Contador 1');
 EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA|| '.S_MIG_PARAM_HITOS');
 end if;
 
 EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_MIG_PARAM_HITOS
 START WITH 1
 MAXVALUE 999999999999999999999999999
 MINVALUE 1
 NOCYCLE
 CACHE 20
 NOORDER'
  ); 

  DBMS_OUTPUT.PUT_LINE('Creando MIG_PARAM_HITOS......');
 FOR I IN V_MPH.FIRST .. V_MPH.LAST
 LOOP
 
  V_TMP_MPH := V_MPH(I);
  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_MIG_PARAM_HITOS.NEXTVAL FROM DUAL';
  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;

  --FIN CONTADORES
  
  --INICIO INSERT
 
  DBMS_OUTPUT.PUT_LINE('Creando MIG_PARAM_HITOS: '||V_TMP_MPH(1)); 

  V_MSQL := 'INSERT INTO ' ||V_ESQUEMA|| '.MIG_PARAM_HITOS 
           ( MIG_PARAM_HITO_ID, COD_TIPO_PROCEDIMIENTO, TIPO_PROCEDIMIENTO, DD_TPO_CODIGO, DD_TPO_DESC, COD_HITO_ACTUAL, TAP_CODIGO, ORDEN, TAR_TAREA_PENDIENTE, FLAG_POR_CADA_BIEN, TAR_FINALIZADA)'
           /*||', VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' || ' */
        ||' VALUES (
                   '||V_TMP_MPH(1)||q'[,]'
                    ||V_TMP_MPH(2)||q'[,']' 
                    ||V_TMP_MPH(3)||q'[',']' 
                    ||V_TMP_MPH(4)||q'[',']'
                    ||V_TMP_MPH(5)||q'[',]' 
                    ||V_TMP_MPH(6)||q'[,']' 
                    ||V_TMP_MPH(7)||q'[',]'  
                    ||V_TMP_MPH(8)||q'[,']'  
                    ||V_TMP_MPH(9)||q'[',]' 
                    ||V_TMP_MPH(10)||q'[,]' 
                    ||V_TMP_MPH(11)||q'[)]';

  --DBMS_OUTPUT.PUT_LINE('Creando MIG_PARAM_HITOS: '||V_MSQL);
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

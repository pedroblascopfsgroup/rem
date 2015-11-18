--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151022
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.2
--## INCIDENCIA_LINK=CMREC-911  
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar parametros en MIG_PARAM_HITOS
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
 TABLA                               VARCHAR(100 CHAR):= 'MIG_PARAM_HITOS';
 SECUENCIA                           VARCHAR(100 CHAR):= 'S_MIG_PARAM_HITOS';
 TABLA_VALORES                       VARCHAR(100 CHAR):= 'MIG_PARAM_HITOS_VALORES';
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
              T_MPH ( '1','35','Cambiario','H016','P. Cambiario - HCJ','1','H016_interposicionDemandaMasBienes','1','Interposición de la demanda más marcado de bienes','0','0')
                  , T_MPH ( '2','35','Cambiario','H016','P. Cambiario - HCJ','2','H016_confAdmiDecretoEmbargo','2','Confirmar admisión más marcado bienes decreto embargo','0','0')
                  , T_MPH ( '3','35','Cambiario','HC103','T. Provisión Fondos - HCJ','2','HC103_SolicitarProvision','3','Solicitar provisión','0','0')
                  , T_MPH ( '4','35','Cambiario','H016','P. Cambiario - HCJ','3','H016_confNotifRequerimientoPago','4','Confirmar notificación requerimiento de pago','0','0')
                  , T_MPH ( '5','35','Cambiario','H062','T. Vigilancia y Caducidad Embargos - HCJ','3','H062_confirmarAnotacionRegistro','5','Confirmar anotación en el registro','0','0')
                  , T_MPH ( '6','35','Cambiario','H016','P. Cambiario - HCJ','5','H016_registrarDemandaOposicion','6','Registrar demanda de oposición','0','0')
                  , T_MPH ( '7','35','Cambiario','H016','P. Cambiario - HCJ','6','H016_registrarJuicioComparecencia','7','Registrar juicio y comparecencia','0','1')
                  , T_MPH ( '8','35','Cambiario','H016','P. Cambiario - HCJ','6','H016_registrarResolucion','8','Registrar resolución','0','0')
                  , T_MPH ( '9','35','Cambiario','H016','P. Cambiario - HCJ','7','H016_resolucionFirme','9','Resolución firme','0','0')
                  , T_MPH ( '10','35','Cambiario','H016','P. Cambiario - HCJ','8','H016_CambiarioDecision','10','Tarea toma de decisión','0','0')
                  , T_MPH ( '11','35','Cambiario','H030','T. certificación de cargas y revisión - HCJ','9','H030_SolicitarInformacionCargasAnt','11','Solicitar información de cargas anteriores','0','0')
                  , T_MPH ( '12','33','Declarativo Ordinario','H024','P. ordinario - HCJ','10','H024_InterposicionDemanda','1','Interposición de la demanda','0','0')
                  , T_MPH ( '13','33','Declarativo Ordinario','H024','P. ordinario - HCJ','11','H024_ConfirmarAdmision','2','Confirmar admisión de la demanda','0','0')
                  , T_MPH ( '14','33','Declarativo Ordinario','HC103','T. Provisión Fondos - HCJ','11','HC103_SolicitarProvision','3','Solicitar provisión','0','0')
                  , T_MPH ( '15','33','Declarativo Ordinario','H024','P. ordinario - HCJ','12','H024_ConfirmarNotDemanda','4','Confirmar notificación de la demanda','0','0')
                  , T_MPH ( '16','33','Declarativo Ordinario','H024','P. ordinario - HCJ','13','H024_ConfirmarOposicion','5','Confirmar si existe oposición','0','1')
                  , T_MPH ( '17','33','Declarativo Ordinario','H024','P. ordinario - HCJ','13','H024_RegistrarAudienciaPrevia','6','Registrar audiencia prévia','0','0')
                  , T_MPH ( '18','33','Declarativo Ordinario','H024','P. ordinario - HCJ','14','H024_RegistrarJuicio','7','Confirmar celebración juicio','0','0')
                  , T_MPH ( '19','33','Declarativo Ordinario','H024','P. ordinario - HCJ','15','H024_RegistrarResolucion','8','Registrar resolucion','0','0')
                  , T_MPH ( '20','33','Declarativo Ordinario','H024','P. ordinario - HCJ','16','H024_ResolucionFirme','9','Resolución firme','0','0')
                  , T_MPH ( '21','33','Declarativo Ordinario','H024','P. ordinario - HCJ','19','H024_OrdinarioDecision','10','Tarea toma de decisión','0','0')
                  , T_MPH ( '22','22','Declarativo Verbal','H026','P. verbal - HCJ','20','H026_InterposicionDemanda','1','Interposición de la demanda','0','0')
                  , T_MPH ( '23','22','Declarativo Verbal','H026','P. verbal - HCJ','21','H026_ConfirmarAdmisionDemanda','2','Confirmar admisión de la demanda','0','0')
                  , T_MPH ( '24','22','Declarativo Verbal','HC103','T. Provisión Fondos - HCJ','21','HC103_SolicitarProvision','3','Solicitar provisión','0','0')
                  , T_MPH ( '25','22','Declarativo Verbal','H026','P. verbal - HCJ','22','H026_ConfirmarNotifiDemanda','4','Confirmar notificación de la demanda','0','0')
                  , T_MPH ( '26','22','Declarativo Verbal','H026','P. verbal - HCJ','23','H026_RegistrarJuicio','5','Registrar juicio','0','0')
                  , T_MPH ( '27','22','Declarativo Verbal','H026','P. verbal - HCJ','24','H026_RegistrarResolucion','6','Registrar resolución','0','0')
                  , T_MPH ( '28','22','Declarativo Verbal','H026','P. verbal - HCJ','25','H026_ResolucionFirme','7','Resolución firme','0','0')
                  , T_MPH ( '29','22','Declarativo Verbal','H026','P. verbal - HCJ','27','H026_VerbalDecision','8','Tarea toma de decisión','0','0')
                  , T_MPH ( '30','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','29','H001_DemandaCertificacionCargas','1','Interposición demanda + Certificación de cargas','0','0')
                  , T_MPH ( '31','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','30','H001_AutoDespachandoEjecucion','2','Auto despachando ejecución','0','0')
                  , T_MPH ( '32','1','Ejecución Hipotecaria','HC103','T. Provisión Fondos - HCJ','30','HC103_SolicitarProvision','3','Solicitar provisión','0','0')
                  , T_MPH ( '33','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','31','H001_RegistrarCertificadoCargas','4','Cumplimentar mandamiento de certificación de cargas','0','0')
                  , T_MPH ( '34','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','31','H001_ConfirmarNotificacionReqPago','5','Confirmar notificación del auto despachando ejecución','0','0')
                  , T_MPH ( '35','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','32','H001_SolicitudOficioJuzgado','6','Solicitud oficio en el juzgado','0','0')
                  , T_MPH ( '36','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','33','H001_ConfirmarSiExisteOposicion','7','Confirmar si existe oposición','0','1')
                  , T_MPH ( '37','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','33','H001_PresentarAlegaciones','8','Presentar alegaciones','0','1')
                  , T_MPH ( '38','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','33','H001_RegistrarComparecencia','9','Registrar comparecencia','0','1')
                  , T_MPH ( '39','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','33','H001_RegistrarResolucion','10','Registrar resolución','0','1')
                  , T_MPH ( '40','1','Ejecución Hipotecaria','H001','P. hipotecario - HCJ','33','H001_ResolucionFirme','11','Resolución firme','0','0')
                  , T_MPH ( '41','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','34','H002_SolicitudSubasta','12','Solicitud de subasta','0','1')
                  , T_MPH ( '42','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','34','H002_SenyalamientoSubasta','13','Señalamiento de subasta','0','1')
                  , T_MPH ( '43','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','34','H002_RevisarDocumentacion','14','Revisar documentación','0','0')
                  , T_MPH ( '44','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','35','H002_PrepararInformeSubasta','15','Preparar propuesta subasta','0','1')
                  , T_MPH ( '45','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','35','H002_ValidarInformeDeSubasta','16','Validar propuesta','0','1')
                  , T_MPH ( '46','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','35','H002_ObtenerValidacionComite','17','Obtener validación comité','0','1')
                  , T_MPH ( '47','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','35','H002_DictarInstruccionesSubasta','18','Dictar instrucciones','0','1')
                  , T_MPH ( '48','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','36','H002_LecturaConfirmacionInstrucciones','19','Lectura y confirmación de instrucciones','0','1')
                  , T_MPH ( '49','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','37','H002_SolicitarSuspenderSubasta','20','Solicitar suspender subasta','0','1')
                  , T_MPH ( '50','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','37','H002_RegistrarResSuspSubasta','21','Registrar resolución suspensión subasta','0','1')
                  , T_MPH ( '51','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','37','H002_DictarInstruccionesDeneSuspension','22','Dictar instrucciones por denegación de suspensión','0','1')
                  , T_MPH ( '52','1','Ejecución Hipotecaria','H002','T. de subasta - HCJ','34','H002_CelebracionSubasta','23','Celebración de subasta','0','0')       
                                   );
                                   
/*
##########################################
## FIN Configuraciones a rellenar
##########################################
*/

 V_TMP_MPH T_MPH;
 
 BEGIN 

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de '||TABLA_VALORES||'');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.'||TABLA_VALORES||'');

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de '||TABLA||'');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.'||TABLA||'');
 
 --CONTADORES

 DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
 
 V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = ''||SECUENCIA||'' and sequence_owner= V_ESQUEMA;
 
 if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
 DBMS_OUTPUT.PUT_LINE('Contador 1');
 EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA|| '.'||SECUENCIA);
 end if;
 
 EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.'||SECUENCIA||'
 START WITH 1
 MAXVALUE 999999999999999999999999999
 MINVALUE 1
 NOCYCLE
 CACHE 20
 NOORDER'
  ); 

DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||'......');
 FOR I IN V_MPH.FIRST .. V_MPH.LAST
 LOOP
 
  V_TMP_MPH := V_MPH(I);
  V_MSQL := 'SELECT '||V_ESQUEMA||'.'||SECUENCIA||'.NEXTVAL FROM DUAL';
  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
  
  --FIN CONTADORES
  
  --INICIO INSERT
 
  DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': '||V_TMP_MPH(1)); 
  
  V_MSQL := 'INSERT INTO ' ||V_ESQUEMA|| '.MIG_PARAM_HITOS 
           ( MIG_PARAM_HITO_ID, COD_TIPO_PROCEDIMIENTO, TIPO_PROCEDIMIENTO, DD_TPO_CODIGO, DD_TPO_DESC, COD_HITO_ACTUAL, TAP_CODIGO, ORDEN, TAR_TAREA_PENDIENTE, FLAG_POR_CADA_BIEN, TAR_FINALIZADA)'
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

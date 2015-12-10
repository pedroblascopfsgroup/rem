--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151022
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=CMREC-911  
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar parametros en MIG_PARAM_HITOS_VALORES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:0.3
--##        
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
 TABLA                               VARCHAR(100 CHAR):= 'MIG_PARAM_HITOS_VALORES';
 SECUENCIA                           VARCHAR(100 CHAR):= 'S_MIG_PARAM_HITOS_VALORES';
 seq_count 			     NUMBER(3); 						-- Vble. para validar la existencia de las Secuencias.
 table_count 		     	     NUMBER(3); 						-- Vble. para validar la existencia de las Tablas.
 v_column_count  	   	     NUMBER(3); 						-- Vble. para validar la existencia de las Columnas.
 v_constraint_count  		     NUMBER(3); 						-- Vble. para validar la existencia de las Constraints.
 err_num  			     NUMBER; 							-- Numero de errores
 err_msg  			     VARCHAR2(2048); 						-- Mensaje de error 
 V_MSQL 			     VARCHAR2(4000 CHAR);
 V_MSQL2 			     VARCHAR2(4000 CHAR);
 V_EXIST  			     NUMBER(10);
 V_ENTIDAD_ID  		   	     NUMBER(16); 
 V_ENTIDAD 			     NUMBER(16);

 V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Código de tabla

   V_MPH T_ARRAY_MPH := T_ARRAY_MPH(
				    T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H016_interposicionDemandaMasBienes','fecha','P06')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H016_interposicionDemandaMasBienes','comboPlaza','P06')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H016_interposicionDemandaMasBienes','fechaCierre','P06')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H016_interposicionDemandaMasBienes','principalDemanda','P06')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H016_interposicionDemandaMasBienes','interesesOrdinarios', 'P06')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H016_interposicionDemandaMasBienes','provisionFondos', 'P06')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H016_confAdmiDecretoEmbargo','fecha','P06')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H016_confAdmiDecretoEmbargo','comboPlaza','P06')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H016_confAdmiDecretoEmbargo','comboJuzgado','P06')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H016_confAdmiDecretoEmbargo','numProcedimiento','P06')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H016_confAdmiDecretoEmbargo','comboAdmision','P06')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(COUNT(1),0,0,1)','6','1','H016_confAdmiDecretoEmbargo','comboBienes','P06')
              , T_MPH ( '4','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H016_confNotifRequerimientoPago','fecha','P06')
              , T_MPH ( '4','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(REQUERIDO,''S'',1,0))]','2','0','H016_confNotifRequerimientoPago','comboResultado','P06')
              , T_MPH ( '5','MIG_PROCEDIMIENTOS_EMBARGOS','MIN(FECHA_REGISTRO_EMBARGO)','1','1','H062_confirmarAnotacionRegistro','fecha','P06')
              , T_MPH ( '5','MIG_PROCEDIMIENTOS_CABECERA','1','2','0','H062_confirmarAnotacionRegistro','comboAlerta','P06')
              , T_MPH ( '6','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H016_registrarDemandaOposicion','comboOposicion','P06')
              , T_MPH ( '6','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H016_registrarDemandaOposicion','fecha','P06')
              , T_MPH ( '6','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','3','0','H016_registrarDemandaOposicion','fechaVista','P06')
              , T_MPH ( '7','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H016_registrarJuicioComparecencia','fecha','P06')
              , T_MPH ( '8','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_registrarResolucion','fecha','P06')
              , T_MPH ( '8','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),1,1,0)','2','0','H016_registrarResolucion','comboResultado','P06')
              , T_MPH ( '9','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_resolucionFirme','fecha','P06')
              , T_MPH ( '10','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_CambiarioDecision','fecha','P06')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H024_InterposicionDemanda','fecha','P07')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_InterposicionDemanda','plazaJuzgado','P07')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H024_InterposicionDemanda','fechaCierre','P07')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H024_InterposicionDemanda','principalDemanda','P07')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H024_InterposicionDemanda','interesesOrdinarios','P07')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H024_InterposicionDemanda','provisionFondos','P07')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H024_ConfirmarAdmision','fecha','P07')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_ConfirmarAdmision','nPlaza','P07')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H024_ConfirmarAdmision','numJuzgado','P07')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H024_ConfirmarAdmision','numProcedimiento','P07')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H024_ConfirmarAdmision','comboResultado','P07')
              , T_MPH ( '15','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H024_ConfirmarNotDemanda','fecha','P07')
              , T_MPH ( '15','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(REQUERIDO,''S'',1,0))]','2','0','H024_ConfirmarNotDemanda','comboResultado','P07')
              , T_MPH ( '16','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','1','1','H024_ConfirmarOposicion','fechaOposicion','P07')
              , T_MPH ( '16','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','2','0','H024_ConfirmarOposicion','comboResultado','P07')
              , T_MPH ( '16','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','3','0','H024_ConfirmarOposicion','fechaAudiencia','P07')
              , T_MPH ( '17','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_VISTA),1,1,0)','1','1','H024_RegistrarAudienciaPrevia','comboResultado','P07')
              , T_MPH ( '17','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','2','1','H024_RegistrarAudienciaPrevia','fechaJuicio','P07')
              , T_MPH ( '18','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H024_RegistrarJuicio','fecha','P07')
              , T_MPH ( '19','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H024_RegistrarResolucion','fecha','P07')
              , T_MPH ( '19','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),1,1,0)','2','1','H024_RegistrarResolucion','comboResultado','P07')
              , T_MPH ( '20','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H024_ResolucionFirme','fecha','P07')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H026_InterposicionDemanda','fechainterposicion','P08')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H026_InterposicionDemanda','comboPlaza','P08')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H026_InterposicionDemanda','fechaCierre','P08')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H026_InterposicionDemanda','principalDemanda','P08')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H026_InterposicionDemanda','interesesOrdinarios','P08')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H026_InterposicionDemanda','provisionFondos','P08')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H026_ConfirmarAdmisionDemanda','fecha','P08')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H026_ConfirmarAdmisionDemanda','comboPlaza','P08')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H026_ConfirmarAdmisionDemanda','numJuzgado','P08')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H026_ConfirmarAdmisionDemanda','numProcedimiento','P08')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H026_ConfirmarAdmisionDemanda','comboAdmisionDemanda','P08')
              , T_MPH ( '25','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H026_ConfirmarNotifiDemanda','fecha','P08')
              , T_MPH ( '25','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[DECODE(MAX(REQUERIDO),''S'',1,0)]','2','0','H026_ConfirmarNotifiDemanda','comboResultado','P08')
              , T_MPH ( '26','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H026_RegistrarJuicio','fecha','P08')
              , T_MPH ( '27','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H026_RegistrarResolucion','fecha','P08')
              , T_MPH ( '27','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),2,1,0)','2','0','H026_RegistrarResolucion','comboResultado','P08')
              , T_MPH ( '28','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H026_ResolucionFirme','fecha','P08')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H001_DemandaCertificacionCargas','fechaPresentacionDemanda','P01')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H001_DemandaCertificacionCargas','plazaJuzgado','P01')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H001_DemandaCertificacionCargas','fechaCierreDeuda','P01')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H001_DemandaCertificacionCargas','principalDeLaDemanda','P01')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H001_DemandaCertificacionCargas','interesesOrdinariosEnElCierre','P01')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H001_DemandaCertificacionCargas','provisionFondos','P01')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H001_AutoDespachandoEjecucion','fecha','P01')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H001_AutoDespachandoEjecucion','comboPlaza','P01')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H001_AutoDespachandoEjecucion','numJuzgado','P01')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H001_AutoDespachandoEjecucion','numProcedimiento','P01')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H001_AutoDespachandoEjecucion','comboResultado','P01')
              , T_MPH ( '33','MIG_PROCEDIMIENTOS_BIENES','MAX(FECHA_CERTIFICACION_CARGAS)','1','1','H001_RegistrarCertificadoCargas','fecha','P01')
              , T_MPH ( '34','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H001_ConfirmarNotificacionReqPago','fecha','P01')
              , T_MPH ( '34','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[DECODE(MAX(REQUERIDO),''S'',1,0)]','2','0','H001_ConfirmarNotificacionReqPago','comboResultado','P01')
              , T_MPH ( '35','MIG_PROCEDIMIENTOS_BIENES','NVL(MAX(TOTAL_CARGAS_ANTERIORES),0)','1','1','H001_SolicitudOficioJuzgado','cargasPrevias','P01')
              , T_MPH ( '36','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H001_ConfirmarSiExisteOposicion','comboResultado','P01')
              , T_MPH ( '36','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H001_ConfirmarSiExisteOposicion','fechaOposicion','P01')
              , T_MPH ( '36','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','3','0','H001_ConfirmarSiExisteOposicion','fechaComparecencia','P01')
              , T_MPH ( '37','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H001_PresentarAlegaciones','fecha','P01')
              , T_MPH ( '37','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(FECHA_COMPARECENCIA),NULL,0,1)','2','0','H001_PresentarAlegaciones','comparecencia','P01')
              , T_MPH ( '38','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H001_RegistrarComparecencia','fecha','P01')
              , T_MPH ( '39','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H001_RegistrarResolucion','fecha','P01')
              , T_MPH ( '39','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),2,1,0)','2','0','H001_RegistrarResolucion','resultado','P01')
              , T_MPH ( '40','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H001_ResolucionFirme','fechaFirmeza','P01')
              , T_MPH ( '41','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)','1','1','H002_SolicitudSubasta','fechaSolicitud','P01')
              , T_MPH ( '42','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SENALAMIENTO_SUBASTA)','1','1','H002_SenyalamientoSubasta','fechaSenyalamiento','P01')
              , T_MPH ( '42','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_LETRADO)','2','0','H002_SenyalamientoSubasta','costasLetrado','P01')
              , T_MPH ( '42','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_PROCURADOR)','3','0','H002_SenyalamientoSubasta','costasProcurador','P01')
              , T_MPH ( '43','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)+1','1','1','H002_RevisarDocumentacion','fecha','P01')
              , T_MPH ( '44','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','1','1','H002_PrepararInformeSubasta','fecha','P01')
              , T_MPH ( '45','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MIN(TIPO_SUBASTA),1,1,0)','1','1','H002_ValidarInformeDeSubasta','comboAtribuciones','P01')
              , T_MPH ( '46','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(RESOLUCION_COMITE)','1','1','H002_ObtenerValidacionComite','comboResultado','P01')
              , T_MPH ( '46','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','2','1','H002_ObtenerValidacionComite','fecha','P01')
              , T_MPH ( '47','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+1','1','1','H002_DictarInstruccionesSubasta','fecha','P01')
              , T_MPH ( '47','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MAX(RESOLUCION_COMITE),0,1,1)','2','1','H002_DictarInstruccionesSubasta','comboSuspender','P01')
              , T_MPH ( '48','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+2','1','1','H002_LecturaConfirmacionInstrucciones','fecha','P01')
              , T_MPH ( '49','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+3','1','1','H002_SolicitarSuspenderSubasta','fecha','P01')
              , T_MPH ( '50','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_RegistrarResSuspSubasta','fecha','P01')
              , T_MPH ( '51','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_DictarInstruccionesDeneSuspension','fecha','P01')
              , T_MPH ( '52','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUBASTA_CELEBRADA)','1','1','H002_CelebracionSubasta','comboCelebrada','P01')
              , T_MPH ( '52','MIG_PROCS_SUBASTAS_LOTES','MAX(CON_POSTORES)','2','0','H002_CelebracionSubasta','comboPostores','P01')
              , T_MPH ( '52','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUSPENDIDA_POR)','3','0','H002_CelebracionSubasta','comboDecisionSuspension','P01')
              , T_MPH ( '52','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MOTIVO_SUSPENSION)','4','0','H002_CelebracionSubasta','comboMotivoSuspension','P01')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H020_InterposicionDemandaMasBienes','fechaInterposicion','P03')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H020_InterposicionDemandaMasBienes','nPlaza','P03')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H020_InterposicionDemandaMasBienes','fechaCierre','P03')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H020_InterposicionDemandaMasBienes','principalDemanda','P03')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H020_InterposicionDemandaMasBienes','interesesOrdinarios','P03')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H020_InterposicionDemandaMasBienes','provisionFondos','P03')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H020_AutoDespaEjecMasDecretoEmbargo','fecha','P03')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H020_AutoDespaEjecMasDecretoEmbargo','comboPlaza','P03')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H020_AutoDespaEjecMasDecretoEmbargo','numJuzgado','P03')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H020_AutoDespaEjecMasDecretoEmbargo','numProcedimiento','P03')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H020_AutoDespaEjecMasDecretoEmbargo','comboAdmisionDemanda','P03')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(COUNT(1),0,0,1)','6','1','H020_AutoDespaEjecMasDecretoEmbargo','bienesEmbargables','P03')
              , T_MPH ( '103','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H020_ConfirmarNotifiReqPago','fecha','P03')
              , T_MPH ( '103','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[DECODE(MAX(REQUERIDO),''S'',1,0)]','2','0','H020_ConfirmarNotifiReqPago','comboConfirmacionReqPago','P03')
              , T_MPH ( '104','MIG_PROCEDIMIENTOS_EMBARGOS','MIN(FECHA_REGISTRO_EMBARGO)','1','1','H062_confirmarAnotacionRegistro','fecha','P03')
              , T_MPH ( '104','MIG_PROCEDIMIENTOS_CABECERA','1','2','0','H062_confirmarAnotacionRegistro','comboAlerta','P03')
              , T_MPH ( '105','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H020_ConfirmarSiExisteOposicion','comboConfirmacion','P03')
              , T_MPH ( '105','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H020_ConfirmarSiExisteOposicion','fecha','P03')
              , T_MPH ( '106','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_SOLICITUD_EMBARGO)','1','1','H030_SolicitudCertificacion','fecha','P03')
              , T_MPH ( '107','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_SOLICITUD_EMBARGO)+1','1','1','H030_RegistrarCertificacion','fecha','P03')
              , T_MPH ( '109','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_AVALUO)-1','1','1','H058_SolicitarAvaluo','fecha','P03')
              , T_MPH ( '110','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_AVALUO)','1','1','H058_ObtencionAvaluo','fecha','P03')
              , T_MPH ( '111','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_AVALUO)+1','1','1','H058_SolitarTasacionInterna','fecha','P03')
              , T_MPH ( '111','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(MAX(IMPORTE_TASACION),0,0,1)','2','0','H058_SolitarTasacionInterna','combo','P03')
              , T_MPH ( '112','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_TASACION)','1','1','H058_ObtencionTasacionInterna','fecha','P03')
              , T_MPH ( '113','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(IMPORTE_TASACION)','1','0','H058_EstConformidadOAlegacion','avaluoInterno','P03')
              , T_MPH ( '113','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(IMPORTE_AVALUO)','1','0','H058_EstConformidadOAlegacion','avaluoExterno','P03')
              , T_MPH ( '114','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)-1','1','1','H020_ConfirmarPresentacionImpugnacion','fecha','P03')
              , T_MPH ( '115','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(DECODE(FECHA_VISTA,NULL,0,1))','1','1','H020_ConfirmarVista','comboHayVista','P03')
              , T_MPH ( '115','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','1','1','H020_ConfirmarVista','fechaVista','P03')
              , T_MPH ( '116','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','1','1','H020_RegistrarCelebracionVista','fecha','P03')
              , T_MPH ( '117','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H020_RegistrarResolucion','fechaResolucion','P03')
              , T_MPH ( '117','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),2,1,0)','2','0','H020_RegistrarResolucion','combo','P03')
              , T_MPH ( '118','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)+1','1','1','H020_ResolucionFirme','fechaResolucion','P03')
              , T_MPH ( '120','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)','1','1','H002_SolicitudSubasta','fechaSolicitud','P03')
              , T_MPH ( '121','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SENALAMIENTO_SUBASTA)','1','1','H002_SenyalamientoSubasta','fechaSenyalamiento','P03')
              , T_MPH ( '121','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_LETRADO)','2','0','H002_SenyalamientoSubasta','costasLetrado','P03')
              , T_MPH ( '121','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_PROCURADOR)','3','0','H002_SenyalamientoSubasta','costasProcurador','P03')
              , T_MPH ( '122','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)+1','1','1','H002_RevisarDocumentacion','fecha','P03')
              , T_MPH ( '123','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','1','1','H002_PrepararInformeSubasta','fecha','P03')
              , T_MPH ( '124','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MIN(TIPO_SUBASTA),1,1,0)','1','1','H002_ValidarInformeDeSubasta','comboAtribuciones','P03')
              , T_MPH ( '125','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(RESOLUCION_COMITE)','1','1','H002_ObtenerValidacionComite','comboResultado','P03')
              , T_MPH ( '125','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','2','1','H002_ObtenerValidacionComite','fecha','P03')
              , T_MPH ( '126','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+1','1','1','H002_DictarInstruccionesSubasta','fecha','P03')
              , T_MPH ( '126','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MAX(RESOLUCION_COMITE),0,1,1)','2','1','H002_DictarInstruccionesSubasta','comboSuspender','P03')
              , T_MPH ( '127','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+2','1','1','H002_LecturaConfirmacionInstrucciones','fecha','P03')
              , T_MPH ( '128','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+3','1','1','H002_SolicitarSuspenderSubasta','fecha','P03')
              , T_MPH ( '129','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_RegistrarResSuspSubasta','fecha','P03')
              , T_MPH ( '130','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_DictarInstruccionesDeneSuspension','fecha','P03')
              , T_MPH ( '131','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUBASTA_CELEBRADA)','1','1','H002_CelebracionSubasta','comboCelebrada','P03')
              , T_MPH ( '131','MIG_PROCS_SUBASTAS_LOTES','MAX(CON_POSTORES)','2','0','H002_CelebracionSubasta','comboPostores','P03')
              , T_MPH ( '131','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUSPENDIDA_POR)','3','0','H002_CelebracionSubasta','comboDecisionSuspension','P03')
              , T_MPH ( '131','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MOTIVO_SUSPENSION)','4','0','H002_CelebracionSubasta','comboMotivoSuspension','P03')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H022_InterposicionDemanda','fechaSolicitud','P02')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H022_InterposicionDemanda','plazaJuzgado','P02')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H022_InterposicionDemanda','fechaCierre','P02')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','1','H022_InterposicionDemanda','principalDemanda','P02')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H022_InterposicionDemanda','interesesOrdinarios','P02')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H022_InterposicionDemanda','provisionFondos','P02')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H022_ConfirmarAdmisionDemanda','fecha','P02')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H022_ConfirmarAdmisionDemanda','nPlaza','P02')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H022_ConfirmarAdmisionDemanda','numJuzgado','P02')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H022_ConfirmarAdmisionDemanda','numProcedimiento','P02')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H022_ConfirmarAdmisionDemanda','comboResultado','P02')
              , T_MPH ( '153','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H016_confNotifRequerimientoPago','fecha','P02')
              , T_MPH ( '153','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(REQUERIDO,''S'',1,0))]','2','0','H016_confNotifRequerimientoPago','comboResultado','P02')
              , T_MPH ( '154','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H022_ConfirmarOposicionCuantia','comboResultado','P02')
              , T_MPH ( '154','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H022_ConfirmarOposicionCuantia','fechaOposicion','P02')
              , T_MPH ( '154','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','3','0','H022_ConfirmarOposicionCuantia','procedimiento','P02')
              , T_MPH ( '154','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','4','0','H022_ConfirmarOposicionCuantia','fechaJuicio','P02')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H024_InterposicionDemanda','fecha','P02')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_InterposicionDemanda','plazaJuzgado','P02')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H024_InterposicionDemanda','fechaCierre','P02')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H024_InterposicionDemanda','principalDemanda','P02')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H024_InterposicionDemanda','interesesOrdinarios','P02')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H024_ConfirmarAdmision','fecha','P02')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_ConfirmarAdmision','nPlaza','P02')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H024_ConfirmarAdmision','numJuzgado','P02')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H024_ConfirmarAdmision','numProcedimiento','P02')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H024_ConfirmarAdmision','comboResultado','P02')
              , T_MPH ( '158','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H018_InterposicionDemanda','fecha','P02')
              , T_MPH ( '158','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H018_InterposicionDemanda','plazaJuzgado','P02')
              , T_MPH ( '158','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H018_InterposicionDemanda','numJuzgado','P02')
              , T_MPH ( '159','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H018_AutoDespachando','fecha','P02')
              , T_MPH ( '159','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','2','0','H018_AutoDespachando','nProc','P02')
              , T_MPH ( '159','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','3','0','H018_AutoDespachando','comboSiNo','P02')
              , T_MPH ( '161','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H028_RegistrarJuicioVerbal','fechaSolicitud','P02')
                       );
                       
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/

 V_TMP_MPH T_MPH;
 
 BEGIN

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de '||TABLA||'');
 EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.'||TABLA||'');
 
 --CONTADORES

 DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
 
 V_ENTIDAD_ID:=0;
 SELECT count(*) INTO V_ENTIDAD_ID
 FROM all_sequences
 WHERE sequence_name = ''||SECUENCIA||'' and sequence_owner= V_ESQUEMA;
 DBMS_OUTPUT.PUT_LINE('PASA');
 
 
 if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
 DBMS_OUTPUT.PUT_LINE('Contador 1');
 EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA|| '.'||SECUENCIA);
 end if;
 
 
 
 EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.'||SECUENCIA||'
 START WITH 1
 INCREMENT BY 1
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
 
  DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': '||V_ENTIDAD_ID); 

  
  
  V_MSQL := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLA||' 
           ( MIG_PHV_ID,MIG_PARAM_HITO_ID,TABLA_MIG,CAMPO_INTERFAZ,ORDEN,FLAG_ES_FECHA,TAP_CODIGO,TEV_NOMBRE)'
	 ||' VALUES ('||V_ENTIDAD_ID||q'[,]'
                    --||V_TMP_MPH(1)||q'[,']' 
		    ||q'[(select MIG_PARAM_HITO_ID from mig_param_hitos where tap_codigo = ']'||V_TMP_MPH(6)||q'[' and cod_tipo_procedimiento = ']'||V_TMP_MPH(8)||q'['),']'
                    ||V_TMP_MPH(2)||q'[',']' 
                    ||V_TMP_MPH(3)||q'[',]'
                    ||V_TMP_MPH(4)||q'[,]' 
                    ||V_TMP_MPH(5)||q'[,']' 
                    ||V_TMP_MPH(6)||q'[',']'   
                    ||V_TMP_MPH(7)||q'[')]';

  V_MSQL2 := q'[select count(1) from mig_param_hitos where tap_codigo = ']'||V_TMP_MPH(6)||q'[' and cod_tipo_procedimiento = ']'||V_TMP_MPH(8)||q'[']';
  DBMS_OUTPUT.PUT_LINE('Select...  '||V_MSQL2);

  EXECUTE IMMEDIATE V_MSQL2 INTO V_EXIST;

   if V_EXIST is not null and V_EXIST > 0 then 
	EXECUTE IMMEDIATE V_MSQL;
   	DBMS_OUTPUT.PUT_LINE('Insert...  '||V_MSQL); 
   else 
	DBMS_OUTPUT.PUT_LINE('Insert no realizado...  '||V_MSQL); 
   end if;

   -- EXIT;
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

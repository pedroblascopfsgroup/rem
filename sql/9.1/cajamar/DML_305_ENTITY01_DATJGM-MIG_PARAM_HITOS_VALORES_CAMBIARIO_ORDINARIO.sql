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
  
 V_ESQUEMA 			     VARCHAR2(25 CHAR):= 'ESQUEMA'; 				-- Configuracion Esquema
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
 V_EXIST  			     NUMBER(10);
 V_ENTIDAD_ID  		   	     NUMBER(16); 
 V_ENTIDAD 			     NUMBER(16);

 V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Código de tabla

   V_MPH T_ARRAY_MPH := T_ARRAY_MPH(
				    T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H016_interposicionDemandaMasBienes','fecha')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H016_interposicionDemandaMasBienes','comboPlaza')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H016_interposicionDemandaMasBienes','fechaCierre')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H016_interposicionDemandaMasBienes','principalDemanda')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H016_interposicionDemandaMasBienes','interesesOrdinarios')
              , T_MPH ( '1','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H016_interposicionDemandaMasBienes','provisionFondos')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H016_confAdmiDecretoEmbargo','fecha')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H016_confAdmiDecretoEmbargo','comboPlaza')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H016_confAdmiDecretoEmbargo','comboJuzgado')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H016_confAdmiDecretoEmbargo','numProcedimiento')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H016_confAdmiDecretoEmbargo','comboAdmision')
              , T_MPH ( '2','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(COUNT(1),0,0,1)','6','1','H016_confAdmiDecretoEmbargo','comboBienes')
              , T_MPH ( '4','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H016_confNotifRequerimientoPago','fecha')
              , T_MPH ( '4','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(REQUERIDO,''S'',1,0))]','2','0','H016_confNotifRequerimientoPago','comboResultado')
              , T_MPH ( '5','MIG_PROCEDIMIENTOS_EMBARGOS','MIN(FECHA_REGISTRO_EMBARGO)','1','1','H062_confirmarAnotacionRegistro','fecha')
              , T_MPH ( '5','MIG_PROCEDIMIENTOS_CABECERA','1','2','0','H062_confirmarAnotacionRegistro','comboAlerta')
              , T_MPH ( '6','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H016_registrarDemandaOposicion','comboOposicion')
              , T_MPH ( '6','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H016_registrarDemandaOposicion','fecha')
              , T_MPH ( '6','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','3','0','H016_registrarDemandaOposicion','fechaVista')
              , T_MPH ( '7','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H016_registrarJuicioComparecencia','fecha')
              , T_MPH ( '8','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_registrarResolucion','fecha')
              , T_MPH ( '8','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),1,1,0)','2','0','H016_registrarResolucion','comboResultado')
              , T_MPH ( '9','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_resolucionFirme','fecha')
              , T_MPH ( '10','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_CambiarioDecision','fecha')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H024_InterposicionDemanda','fecha')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_InterposicionDemanda','plazaJuzgado')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H024_InterposicionDemanda','fechaCierre')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H024_InterposicionDemanda','principalDemanda')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H024_InterposicionDemanda','interesesOrdinarios')
              , T_MPH ( '12','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H024_InterposicionDemanda','provisionFondos')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H024_ConfirmarAdmision','fecha')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_ConfirmarAdmision','nPlaza')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H024_ConfirmarAdmision','numJuzgado')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H024_ConfirmarAdmision','numProcedimiento')
              , T_MPH ( '13','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H024_ConfirmarAdmision','comboResultado')
              , T_MPH ( '15','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H024_ConfirmarNotDemanda','fecha')
              , T_MPH ( '15','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(REQUERIDO,''S'',1,0))]','2','0','H024_ConfirmarNotDemanda','comboResultado')
              , T_MPH ( '16','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','1','1','H024_ConfirmarOposicion','fechaOposicion')
              , T_MPH ( '16','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','2','0','H024_ConfirmarOposicion','comboResultado')
              , T_MPH ( '16','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','3','0','H024_ConfirmarOposicion','fechaAudiencia')
              , T_MPH ( '17','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_VISTA),1,1,0)','1','1','H024_RegistrarAudienciaPrevia','comboResultado')
              , T_MPH ( '17','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','2','1','H024_RegistrarAudienciaPrevia','fechaJuicio')
              , T_MPH ( '18','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H024_RegistrarJuicio','fecha')
              , T_MPH ( '19','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H024_RegistrarResolucion','fecha')
              , T_MPH ( '19','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),1,1,0)','2','1','H024_RegistrarResolucion','comboResultado')
              , T_MPH ( '20','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H024_ResolucionFirme','fecha')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H026_InterposicionDemanda','fechainterposicion')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H026_InterposicionDemanda','comboPlaza')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H026_InterposicionDemanda','fechaCierre')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H026_InterposicionDemanda','principalDemanda')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H026_InterposicionDemanda','interesesOrdinarios')
              , T_MPH ( '22','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H026_InterposicionDemanda','provisionFondos')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H026_ConfirmarAdmisionDemanda','fecha')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H026_ConfirmarAdmisionDemanda','comboPlaza')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H026_ConfirmarAdmisionDemanda','numJuzgado')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H026_ConfirmarAdmisionDemanda','numProcedimiento')
              , T_MPH ( '23','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H026_ConfirmarAdmisionDemanda','comboAdmisionDemanda')
              , T_MPH ( '25','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H026_ConfirmarNotifiDemanda','fecha')
              , T_MPH ( '25','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[DECODE(MAX(REQUERIDO),''S'',1,0)]','2','0','H026_ConfirmarNotifiDemanda','comboResultado')
              , T_MPH ( '26','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H026_RegistrarJuicio','fecha')
              , T_MPH ( '27','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H026_RegistrarResolucion','fecha')
              , T_MPH ( '27','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),2,1,0)','2','0','H026_RegistrarResolucion','comboResultado')
              , T_MPH ( '28','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H026_ResolucionFirme','fecha')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H001_DemandaCertificacionCargas','fechaPresentacionDemanda')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H001_DemandaCertificacionCargas','plazaJuzgado')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H001_DemandaCertificacionCargas','fechaCierreDeuda')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H001_DemandaCertificacionCargas','principalDeLaDemanda')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H001_DemandaCertificacionCargas','interesesOrdinariosEnElCierre')
              , T_MPH ( '30','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H001_DemandaCertificacionCargas','provisionFondos')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H001_AutoDespachandoEjecucion','fecha')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H001_AutoDespachandoEjecucion','comboPlaza')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H001_AutoDespachandoEjecucion','numJuzgado')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H001_AutoDespachandoEjecucion','numProcedimiento')
              , T_MPH ( '31','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H001_AutoDespachandoEjecucion','comboResultado')
              , T_MPH ( '33','MIG_PROCEDIMIENTOS_BIENES','MAX(FECHA_CERTIFICACION_CARGAS)','1','1','H001_RegistrarCertificadoCargas','fecha')
              , T_MPH ( '34','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H001_ConfirmarNotificacionReqPago','fecha')
              , T_MPH ( '34','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[DECODE(MAX(REQUERIDO),''S'',1,0)]','2','0','H001_ConfirmarNotificacionReqPago','comboResultado')
              , T_MPH ( '35','MIG_PROCEDIMIENTOS_BIENES','NVL(MAX(TOTAL_CARGAS_ANTERIORES),0)','1','1','H001_SolicitudOficioJuzgado','cargasPrevias')
              , T_MPH ( '36','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H001_ConfirmarSiExisteOposicion','comboResultado')
              , T_MPH ( '36','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H001_ConfirmarSiExisteOposicion','fechaOposicion')
              , T_MPH ( '36','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','3','0','H001_ConfirmarSiExisteOposicion','fechaComparecencia')
              , T_MPH ( '37','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H001_PresentarAlegaciones','fecha')
              , T_MPH ( '37','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(FECHA_COMPARECENCIA),NULL,0,1)','2','0','H001_PresentarAlegaciones','comparecencia')
              , T_MPH ( '38','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H001_RegistrarComparecencia','fecha')
              , T_MPH ( '39','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H001_RegistrarResolucion','fecha')
              , T_MPH ( '39','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),2,1,0)','2','0','H001_RegistrarResolucion','resultado')
              , T_MPH ( '40','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H001_ResolucionFirme','fechaFirmeza')
              , T_MPH ( '41','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)','1','1','H002_SolicitudSubasta','fechaSolicitud')
              , T_MPH ( '42','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SENALAMIENTO_SUBASTA)','1','1','H002_SenyalamientoSubasta','fechaSenyalamiento')
              , T_MPH ( '42','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_LETRADO)','2','0','H002_SenyalamientoSubasta','costasLetrado')
              , T_MPH ( '42','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_PROCURADOR)','3','0','H002_SenyalamientoSubasta','costasProcurador')
              , T_MPH ( '43','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)+1','1','1','H002_RevisarDocumentacion','fecha')
              , T_MPH ( '44','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','1','1','H002_PrepararInformeSubasta','fecha')
              , T_MPH ( '45','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MIN(TIPO_SUBASTA),1,1,0)','1','1','H002_ValidarInformeDeSubasta','comboAtribuciones')
              , T_MPH ( '46','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(RESOLUCION_COMITE)','1','1','H002_ObtenerValidacionComite','comboResultado')
              , T_MPH ( '46','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','2','1','H002_ObtenerValidacionComite','fecha')
              , T_MPH ( '47','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+1','1','1','H002_DictarInstruccionesSubasta','fecha')
              , T_MPH ( '47','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MAX(RESOLUCION_COMITE),0,1,1)','2','1','H002_DictarInstruccionesSubasta','comboSuspender')
              , T_MPH ( '48','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+2','1','1','H002_LecturaConfirmacionInstrucciones','fecha')
              , T_MPH ( '49','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+3','1','1','H002_SolicitarSuspenderSubasta','fecha')
              , T_MPH ( '50','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_RegistrarResSuspSubasta','fecha')
              , T_MPH ( '51','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_DictarInstruccionesDeneSuspension','fecha')
              , T_MPH ( '52','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUBASTA_CELEBRADA)','1','1','H002_CelebracionSubasta','comboCelebrada')
              , T_MPH ( '52','MIG_PROCS_SUBASTAS_LOTES','MAX(CON_POSTORES)','2','0','H002_CelebracionSubasta','comboPostores')
              , T_MPH ( '52','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUSPENDIDA_POR)','3','0','H002_CelebracionSubasta','comboDecisionSuspension')
              , T_MPH ( '52','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MOTIVO_SUSPENSION)','4','0','H002_CelebracionSubasta','comboMotivoSuspension')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H020_InterposicionDemandaMasBienes','fechaInterposicion')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H020_InterposicionDemandaMasBienes','nPlaza')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H020_InterposicionDemandaMasBienes','fechaCierre')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H020_InterposicionDemandaMasBienes','principalDemanda')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H020_InterposicionDemandaMasBienes','interesesOrdinarios')
              , T_MPH ( '100','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H020_InterposicionDemandaMasBienes','provisionFondos')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H020_AutoDespaEjecMasDecretoEmbargo','fecha')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H020_AutoDespaEjecMasDecretoEmbargo','comboPlaza')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H020_AutoDespaEjecMasDecretoEmbargo','numJuzgado')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H020_AutoDespaEjecMasDecretoEmbargo','numProcedimiento')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H020_AutoDespaEjecMasDecretoEmbargo','comboAdmisionDemanda')
              , T_MPH ( '101','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(COUNT(1),0,0,1)','6','1','H020_AutoDespaEjecMasDecretoEmbargo','bienesEmbargables')
              , T_MPH ( '103','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H020_ConfirmarNotifiReqPago','fecha')
              , T_MPH ( '103','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[DECODE(MAX(REQUERIDO),''S'',1,0)]','2','0','H020_ConfirmarNotifiReqPago','comboConfirmacionReqPago')
              , T_MPH ( '104','MIG_PROCEDIMIENTOS_EMBARGOS','MIN(FECHA_REGISTRO_EMBARGO)','1','1','H062_confirmarAnotacionRegistro','fecha')
              , T_MPH ( '104','MIG_PROCEDIMIENTOS_CABECERA','1','2','0','H062_confirmarAnotacionRegistro','comboAlerta')
              , T_MPH ( '105','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H020_ConfirmarSiExisteOposicion','comboConfirmacion')
              , T_MPH ( '105','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H020_ConfirmarSiExisteOposicion','fecha')
              , T_MPH ( '106','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_SOLICITUD_EMBARGO)','1','1','H030_SolicitudCertificacion','fecha')
              , T_MPH ( '107','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_SOLICITUD_EMBARGO)+1','1','1','H030_RegistrarCertificacion','fecha')
              , T_MPH ( '109','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_AVALUO)-1','1','1','H058_SolicitarAvaluo','fecha')
              , T_MPH ( '110','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_AVALUO)','1','1','H058_ObtencionAvaluo','fecha')
              , T_MPH ( '111','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_AVALUO)+1','1','1','H058_SolitarTasacionInterna','fecha')
              , T_MPH ( '111','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(MAX(IMPORTE_TASACION),0,0,1)','2','0','H058_SolitarTasacionInterna','combo')
              , T_MPH ( '112','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_TASACION)','1','1','H058_ObtencionTasacionInterna','fecha')
              , T_MPH ( '113','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(IMPORTE_TASACION)','1','0','H058_EstConformidadOAlegacion','avaluoInterno')
              , T_MPH ( '113','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(IMPORTE_AVALUO)','1','0','H058_EstConformidadOAlegacion','avaluoExterno')
              , T_MPH ( '114','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)-1','1','1','H020_ConfirmarPresentacionImpugnacion','fecha')
              , T_MPH ( '115','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(DECODE(FECHA_VISTA,NULL,0,1))','1','1','H020_ConfirmarVista','comboHayVista')
              , T_MPH ( '115','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','1','1','H020_ConfirmarVista','fechaVista')
              , T_MPH ( '116','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','1','1','H020_RegistrarCelebracionVista','fecha')
              , T_MPH ( '117','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H020_RegistrarResolucion','fechaResolucion')
              , T_MPH ( '117','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),2,1,0)','2','0','H020_RegistrarResolucion','combo')
              , T_MPH ( '118','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)+1','1','1','H020_ResolucionFirme','fechaResolucion')
              , T_MPH ( '120','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)','1','1','H002_SolicitudSubasta','fechaSolicitud')
              , T_MPH ( '121','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SENALAMIENTO_SUBASTA)','1','1','H002_SenyalamientoSubasta','fechaSenyalamiento')
              , T_MPH ( '121','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_LETRADO)','2','0','H002_SenyalamientoSubasta','costasLetrado')
              , T_MPH ( '121','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_PROCURADOR)','3','0','H002_SenyalamientoSubasta','costasProcurador')
              , T_MPH ( '122','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)+1','1','1','H002_RevisarDocumentacion','fecha')
              , T_MPH ( '123','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','1','1','H002_PrepararInformeSubasta','fecha')
              , T_MPH ( '124','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MIN(TIPO_SUBASTA),1,1,0)','1','1','H002_ValidarInformeDeSubasta','comboAtribuciones')
              , T_MPH ( '125','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(RESOLUCION_COMITE)','1','1','H002_ObtenerValidacionComite','comboResultado')
              , T_MPH ( '125','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','2','1','H002_ObtenerValidacionComite','fecha')
              , T_MPH ( '126','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+1','1','1','H002_DictarInstruccionesSubasta','fecha')
              , T_MPH ( '126','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MAX(RESOLUCION_COMITE),0,1,1)','2','1','H002_DictarInstruccionesSubasta','comboSuspender')
              , T_MPH ( '127','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+2','1','1','H002_LecturaConfirmacionInstrucciones','fecha')
              , T_MPH ( '128','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+3','1','1','H002_SolicitarSuspenderSubasta','fecha')
              , T_MPH ( '129','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_RegistrarResSuspSubasta','fecha')
              , T_MPH ( '130','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_DictarInstruccionesDeneSuspension','fecha')
              , T_MPH ( '131','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUBASTA_CELEBRADA)','1','1','H002_CelebracionSubasta','comboCelebrada')
              , T_MPH ( '131','MIG_PROCS_SUBASTAS_LOTES','MAX(CON_POSTORES)','2','0','H002_CelebracionSubasta','comboPostores')
              , T_MPH ( '131','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUSPENDIDA_POR)','3','0','H002_CelebracionSubasta','comboDecisionSuspension')
              , T_MPH ( '131','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MOTIVO_SUSPENSION)','4','0','H002_CelebracionSubasta','comboMotivoSuspension')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H022_InterposicionDemanda','fechaSolicitud')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H022_InterposicionDemanda','plazaJuzgado')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H022_InterposicionDemanda','fechaCierre')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','1','H022_InterposicionDemanda','principalDemanda')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H022_InterposicionDemanda','interesesOrdinarios')
              , T_MPH ( '150','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H022_InterposicionDemanda','provisionFondos')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H022_ConfirmarAdmisionDemanda','fecha')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H022_ConfirmarAdmisionDemanda','nPlaza')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H022_ConfirmarAdmisionDemanda','numJuzgado')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H022_ConfirmarAdmisionDemanda','numProcedimiento')
              , T_MPH ( '151','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H022_ConfirmarAdmisionDemanda','comboResultado')
              , T_MPH ( '153','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H016_confNotifRequerimientoPago','fecha')
              , T_MPH ( '153','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(REQUERIDO,''S'',1,0))]','2','0','H016_confNotifRequerimientoPago','comboResultado')
              , T_MPH ( '154','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H022_ConfirmarOposicionCuantia','comboResultado')
              , T_MPH ( '154','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H022_ConfirmarOposicionCuantia','fechaOposicion')
              , T_MPH ( '154','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','3','0','H022_ConfirmarOposicionCuantia','procedimiento')
              , T_MPH ( '154','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','4','0','H022_ConfirmarOposicionCuantia','fechaJuicio')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H024_InterposicionDemanda','fecha')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_InterposicionDemanda','plazaJuzgado')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H024_InterposicionDemanda','fechaCierre')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H024_InterposicionDemanda','principalDemanda')
              , T_MPH ( '155','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H024_InterposicionDemanda','interesesOrdinarios')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H024_ConfirmarAdmision','fecha')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_ConfirmarAdmision','nPlaza')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H024_ConfirmarAdmision','numJuzgado')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H024_ConfirmarAdmision','numProcedimiento')
              , T_MPH ( '156','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H024_ConfirmarAdmision','comboResultado')
              , T_MPH ( '158','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H018_InterposicionDemanda','fecha')
              , T_MPH ( '158','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H018_InterposicionDemanda','plazaJuzgado')
              , T_MPH ( '158','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H018_InterposicionDemanda','numJuzgado')
              , T_MPH ( '159','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H018_AutoDespachando','fecha')
              , T_MPH ( '159','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','2','0','H018_AutoDespachando','nProc')
              , T_MPH ( '159','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','3','0','H018_AutoDespachando','comboSiNo')
              , T_MPH ( '161','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H028_RegistrarJuicioVerbal','fechaSolicitud')
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
                    ||V_TMP_MPH(1)||q'[,']' 
                    ||V_TMP_MPH(2)||q'[',']' 
                    ||V_TMP_MPH(3)||q'[',]'
                    ||V_TMP_MPH(4)||q'[,]' 
                    ||V_TMP_MPH(5)||q'[,']' 
                    ||V_TMP_MPH(6)||q'[',']'   
                    ||V_TMP_MPH(7)||q'[')]';

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

--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151103
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=CMREC-976
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
 V_EXIST  			     NUMBER(10);
 V_ENTIDAD_ID  		   	     NUMBER(16); 
 V_ENTIDAD 			     NUMBER(16);

 V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Código de tabla

   V_MPH T_ARRAY_MPH := T_ARRAY_MPH(
				       T_MPH ( '1','1','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H016_interposicionDemandaMasBienes','fecha')
                    , T_MPH ( '2','1','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H016_interposicionDemandaMasBienes','comboPlaza')
                    , T_MPH ( '3','1','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H016_interposicionDemandaMasBienes','fechaCierre')
                    , T_MPH ( '4','1','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H016_interposicionDemandaMasBienes','principalDemanda')
                    , T_MPH ( '5','1','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H016_interposicionDemandaMasBienes','interesesOrdinarios')
                    , T_MPH ( '6','1','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H016_interposicionDemandaMasBienes','provisionFondos')
                    , T_MPH ( '7','2','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H016_confAdmiDecretoEmbargo','fecha')
                    , T_MPH ( '8','2','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H016_confAdmiDecretoEmbargo','comboPlaza')
                    , T_MPH ( '9','2','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H016_confAdmiDecretoEmbargo','comboJuzgado')
                    , T_MPH ( '10','2','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H016_confAdmiDecretoEmbargo','numProcedimiento')
                    , T_MPH ( '11','2','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H016_confAdmiDecretoEmbargo','comboAdmision')
                    , T_MPH ( '12','2','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(COUNT(1),0,0,1)','6','1','H016_confAdmiDecretoEmbargo','comboBienes')
                    , T_MPH ( '13','4','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H016_confNotifRequerimientoPago','fecha')
                    , T_MPH ( '14','4','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(REQUERIDO,''S'',1,0))]','2','0','H016_confNotifRequerimientoPago','comboResultado')
                    , T_MPH ( '15','5','MIG_PROCEDIMIENTOS_EMBARGOS','MIN(FECHA_REGISTRO_EMBARGO)','1','1','H062_confirmarAnotacionRegistro','fecha')
                    , T_MPH ( '16','5','MIG_PROCEDIMIENTOS_CABECERA','1','2','0','H062_confirmarAnotacionRegistro','comboAlerta')
                    , T_MPH ( '17','6','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H016_registrarDemandaOposicion','comboOposicion')
                    , T_MPH ( '18','6','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H016_registrarDemandaOposicion','fecha')
                    , T_MPH ( '19','6','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','3','0','H016_registrarDemandaOposicion','fechaVista')
                    , T_MPH ( '20','7','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H016_registrarJuicioComparecencia','fecha')
                    , T_MPH ( '21','8','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_registrarResolucion','fecha')
                    , T_MPH ( '22','8','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),1,1,0)','2','0','H016_registrarResolucion','comboResultado')
                    , T_MPH ( '23','9','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_resolucionFirme','fecha')
                    , T_MPH ( '24','10','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H016_CambiarioDecision','fecha')
                    , T_MPH ( '25','12','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H024_InterposicionDemanda','fecha')
                    , T_MPH ( '26','12','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_InterposicionDemanda','plazaJuzgado')
                    , T_MPH ( '27','12','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H024_InterposicionDemanda','fechaCierre')
                    , T_MPH ( '28','12','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H024_InterposicionDemanda','principalDemanda')
                    , T_MPH ( '29','12','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H024_InterposicionDemanda','interesesOrdinarios')
                    , T_MPH ( '30','12','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H024_InterposicionDemanda','provisionFondos')
                    , T_MPH ( '31','13','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H024_ConfirmarAdmision','fecha')
                    , T_MPH ( '32','13','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_ConfirmarAdmision','nPlaza')
                    , T_MPH ( '33','13','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H024_ConfirmarAdmision','numJuzgado')
                    , T_MPH ( '34','13','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H024_ConfirmarAdmision','numProcedimiento')
                    , T_MPH ( '35','13','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H024_ConfirmarAdmision','comboResultado')
                    , T_MPH ( '36','15','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H024_ConfirmarNotDemanda','fecha')
                    , T_MPH ( '37','15','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(REQUERIDO,''S'',1,0))]','2','0','H024_ConfirmarNotDemanda','comboResultado')
                    , T_MPH ( '38','16','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','1','1','H024_ConfirmarOposicion','fechaOposicion')
                    , T_MPH ( '39','16','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','2','0','H024_ConfirmarOposicion','comboResultado')
                    , T_MPH ( '40','16','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','3','0','H024_ConfirmarOposicion','fechaAudiencia')
                    , T_MPH ( '41','17','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_VISTA),1,1,0)','1','1','H024_RegistrarAudienciaPrevia','comboResultado')
                    , T_MPH ( '42','17','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','2','1','H024_RegistrarAudienciaPrevia','fechaJuicio')
                    , T_MPH ( '43','18','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H024_RegistrarJuicio','fecha')
                    , T_MPH ( '44','19','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H024_RegistrarResolucion','fecha')
                    , T_MPH ( '45','19','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),1,1,0)','2','1','H024_RegistrarResolucion','comboResultado')
                    , T_MPH ( '46','20','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H024_ResolucionFirme','fecha')
                    , T_MPH ( '47','22','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H026_InterposicionDemanda','fechainterposicion')
                    , T_MPH ( '48','22','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H026_InterposicionDemanda','comboPlaza')
                    , T_MPH ( '49','22','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H026_InterposicionDemanda','fechaCierre')
                    , T_MPH ( '50','22','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H026_InterposicionDemanda','principalDemanda')
                    , T_MPH ( '51','22','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H026_InterposicionDemanda','interesesOrdinarios')
                    , T_MPH ( '52','22','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H026_InterposicionDemanda','provisionFondos')
                    , T_MPH ( '53','23','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H026_ConfirmarAdmisionDemanda','fecha')
                    , T_MPH ( '54','23','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H026_ConfirmarAdmisionDemanda','comboPlaza')
                    , T_MPH ( '55','23','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H026_ConfirmarAdmisionDemanda','numJuzgado')
                    , T_MPH ( '56','23','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H026_ConfirmarAdmisionDemanda','numProcedimiento')
                    , T_MPH ( '57','23','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H026_ConfirmarAdmisionDemanda','comboAdmisionDemanda')
                    , T_MPH ( '58','25','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H026_ConfirmarNotifiDemanda','fecha')
                    , T_MPH ( '59','25','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[DECODE(MAX(REQUERIDO),''S'',1,0)]','2','0','H026_ConfirmarNotifiDemanda','comboResultado')
                    , T_MPH ( '60','26','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H026_RegistrarJuicio','fecha')
                    , T_MPH ( '61','27','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H026_RegistrarResolucion','fecha')
                    , T_MPH ( '62','27','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),2,1,0)','2','0','H026_RegistrarResolucion','comboResultado')
                    , T_MPH ( '63','28','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H026_ResolucionFirme','fecha')
                    , T_MPH ( '64','30','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H001_DemandaCertificacionCargas','fechaPresentacionDemanda')
                    , T_MPH ( '65','30','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H001_DemandaCertificacionCargas','plazaJuzgado')
                    , T_MPH ( '66','30','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H001_DemandaCertificacionCargas','fechaCierreDeuda')
                    , T_MPH ( '67','30','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H001_DemandaCertificacionCargas','principalDeLaDemanda')
                    , T_MPH ( '68','30','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H001_DemandaCertificacionCargas','interesesOrdinariosEnElCierre')
                    , T_MPH ( '69','30','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H001_DemandaCertificacionCargas','provisionFondos')
                    , T_MPH ( '70','31','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H001_AutoDespachandoEjecucion','fecha')
                    , T_MPH ( '71','31','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H001_AutoDespachandoEjecucion','comboPlaza')
                    , T_MPH ( '72','31','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H001_AutoDespachandoEjecucion','numJuzgado')
                    , T_MPH ( '73','31','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H001_AutoDespachandoEjecucion','numProcedimiento')
                    , T_MPH ( '74','31','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H001_AutoDespachandoEjecucion','comboResultado')
                    , T_MPH ( '75','33','MIG_PROCEDIMIENTOS_BIENES','MAX(FECHA_CERTIFICACION_CARGAS)','1','1','H001_RegistrarCertificadoCargas','fecha')
                    , T_MPH ( '76','34','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H001_ConfirmarNotificacionReqPago','fecha')
                    , T_MPH ( '77','34','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[DECODE(MAX(REQUERIDO),''S'',1,0)]','2','0','H001_ConfirmarNotificacionReqPago','comboResultado')
                    , T_MPH ( '78','35','MIG_PROCEDIMIENTOS_BIENES','NVL(MAX(TOTAL_CARGAS_ANTERIORES),0)','1','1','H001_SolicitudOficioJuzgado','cargasPrevias')
                    , T_MPH ( '79','36','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H001_ConfirmarSiExisteOposicion','comboResultado')
                    , T_MPH ( '80','36','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H001_ConfirmarSiExisteOposicion','fechaOposicion')
                    , T_MPH ( '81','36','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','3','0','H001_ConfirmarSiExisteOposicion','fechaComparecencia')
                    , T_MPH ( '82','37','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H001_PresentarAlegaciones','fecha')
                    , T_MPH ( '83','37','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(FECHA_COMPARECENCIA),NULL,0,1)','2','0','H001_PresentarAlegaciones','comparecencia')
                    , T_MPH ( '84','38','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','1','1','H001_RegistrarComparecencia','fecha')
                    , T_MPH ( '85','39','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H001_RegistrarResolucion','fecha')
                    , T_MPH ( '86','39','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),2,1,0)','2','0','H001_RegistrarResolucion','resultado')
                    , T_MPH ( '87','40','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H001_ResolucionFirme','fechaFirmeza')
                    , T_MPH ( '88','41','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)','1','1','H002_SolicitudSubasta','fechaSolicitud')
                    , T_MPH ( '89','42','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SENALAMIENTO_SUBASTA)','1','1','H002_SenyalamientoSubasta','fechaSenyalamiento')
                    , T_MPH ( '90','42','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_LETRADO)','2','0','H002_SenyalamientoSubasta','costasLetrado')
                    , T_MPH ( '91','42','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_PROCURADOR)','3','0','H002_SenyalamientoSubasta','costasProcurador')
                    , T_MPH ( '92','43','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)+1','1','1','H002_RevisarDocumentacion','fecha')
                    , T_MPH ( '93','44','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','1','1','H002_PrepararInformeSubasta','fecha')
                    , T_MPH ( '94','45','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MIN(TIPO_SUBASTA),1,1,0)','1','1','H002_ValidarInformeDeSubasta','comboAtribuciones')
                    , T_MPH ( '95','46','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(RESOLUCION_COMITE)','1','1','H002_ObtenerValidacionComite','comboResultado')
                    , T_MPH ( '96','46','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','2','1','H002_ObtenerValidacionComite','fecha')
                    , T_MPH ( '97','47','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+1','1','1','H002_DictarInstruccionesSubasta','fecha')
                    , T_MPH ( '98','47','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MAX(RESOLUCION_COMITE),0,1,1)','2','1','H002_DictarInstruccionesSubasta','comboSuspender')
                    , T_MPH ( '99','48','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+2','1','1','H002_LecturaConfirmacionInstrucciones','fecha')
                    , T_MPH ( '100','49','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+3','1','1','H002_SolicitarSuspenderSubasta','fecha')
                    , T_MPH ( '101','50','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_RegistrarResSuspSubasta','fecha')
                    , T_MPH ( '102','51','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_DictarInstruccionesDeneSuspension','fecha')
                    , T_MPH ( '103','52','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUBASTA_CELEBRADA)','1','1','H002_CelebracionSubasta','comboCelebrada')
                    , T_MPH ( '104','52','MIG_PROCS_SUBASTAS_LOTES','MAX(CON_POSTORES)','2','0','H002_CelebracionSubasta','comboPostores')
                    , T_MPH ( '105','52','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUSPENDIDA_POR)','3','0','H002_CelebracionSubasta','comboDecisionSuspension')
                    , T_MPH ( '106','52','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MOTIVO_SUSPENSION)','4','0','H002_CelebracionSubasta','comboMotivoSuspension')
                    , T_MPH ( '130','100','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H020_InterposicionDemandaMasBienes','fechaInterposicion')
                    , T_MPH ( '131','100','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H020_InterposicionDemandaMasBienes','nPlaza')
                    , T_MPH ( '132','100','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H020_InterposicionDemandaMasBienes','fechaCierre')
                    , T_MPH ( '133','100','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H020_InterposicionDemandaMasBienes','principalDemanda')
                    , T_MPH ( '134','100','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H020_InterposicionDemandaMasBienes','interesesOrdinarios')
                    , T_MPH ( '135','100','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H020_InterposicionDemandaMasBienes','provisionFondos')
                    , T_MPH ( '136','101','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H020_AutoDespaEjecMasDecretoEmbargo','fecha')
                    , T_MPH ( '137','101','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H020_AutoDespaEjecMasDecretoEmbargo','comboPlaza')
                    , T_MPH ( '138','101','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H020_AutoDespaEjecMasDecretoEmbargo','numJuzgado')
                    , T_MPH ( '139','101','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H020_AutoDespaEjecMasDecretoEmbargo','numProcedimiento')
                    , T_MPH ( '140','101','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H020_AutoDespaEjecMasDecretoEmbargo','comboAdmisionDemanda')
                    , T_MPH ( '141','101','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(COUNT(1),0,0,1)','6','1','H020_AutoDespaEjecMasDecretoEmbargo','bienesEmbargables')
                    , T_MPH ( '142','103','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H020_ConfirmarNotifiReqPago','fecha')
                    , T_MPH ( '143','103','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[DECODE(MAX(REQUERIDO),''S'',1,0)]','2','0','H020_ConfirmarNotifiReqPago','comboConfirmacionReqPago')
                    , T_MPH ( '144','104','MIG_PROCEDIMIENTOS_EMBARGOS','MIN(FECHA_REGISTRO_EMBARGO)','1','1','H062_confirmarAnotacionRegistro','fecha')
                    , T_MPH ( '145','104','MIG_PROCEDIMIENTOS_CABECERA','1','2','0','H062_confirmarAnotacionRegistro','comboAlerta')
                    , T_MPH ( '146','105','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H020_ConfirmarSiExisteOposicion','comboConfirmacion')
                    , T_MPH ( '147','105','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H020_ConfirmarSiExisteOposicion','fecha')
                    , T_MPH ( '148','106','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_SOLICITUD_EMBARGO)','1','1','H030_SolicitudCertificacion','fecha')
                    , T_MPH ( '149','107','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_SOLICITUD_EMBARGO)+1','1','1','H030_RegistrarCertificacion','fecha')
                    , T_MPH ( '150','109','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_AVALUO)-1','1','1','H058_SolicitarAvaluo','fecha')
                    , T_MPH ( '151','110','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_AVALUO)','1','1','H058_ObtencionAvaluo','fecha')
                    , T_MPH ( '152','111','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_AVALUO)+1','1','1','H058_SolitarTasacionInterna','fecha')
                    , T_MPH ( '153','111','MIG_PROCEDIMIENTOS_EMBARGOS','DECODE(MAX(IMPORTE_TASACION),0,0,1)','2','0','H058_SolitarTasacionInterna','combo')
                    , T_MPH ( '154','112','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(FECHA_TASACION)','1','1','H058_ObtencionTasacionInterna','fecha')
                    , T_MPH ( '155','113','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(IMPORTE_TASACION)','1','0','H058_EstConformidadOAlegacion','avaluoInterno')
                    , T_MPH ( '156','113','MIG_PROCEDIMIENTOS_EMBARGOS','MAX(IMPORTE_AVALUO)','1','0','H058_EstConformidadOAlegacion','avaluoExterno')
                    , T_MPH ( '157','114','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)-1','1','1','H020_ConfirmarPresentacionImpugnacion','fecha')
                    , T_MPH ( '158','115','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(DECODE(FECHA_VISTA,NULL,0,1))','1','1','H020_ConfirmarVista','comboHayVista')
                    , T_MPH ( '159','115','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','1','1','H020_ConfirmarVista','fechaVista')
                    , T_MPH ( '160','116','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_VISTA)','1','1','H020_RegistrarCelebracionVista','fecha')
                    , T_MPH ( '161','117','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)','1','1','H020_RegistrarResolucion','fechaResolucion')
                    , T_MPH ( '162','117','MIG_PROCEDIMIENTOS_DEMANDADOS','DECODE(MAX(RESULTADO_RESOLUCION),2,1,0)','2','0','H020_RegistrarResolucion','combo')
                    , T_MPH ( '163','118','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_RESOLUCION)+1','1','1','H020_ResolucionFirme','fechaResolucion')
                    , T_MPH ( '164','120','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)','1','1','H002_SolicitudSubasta','fechaSolicitud')
                    , T_MPH ( '165','121','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SENALAMIENTO_SUBASTA)','1','1','H002_SenyalamientoSubasta','fechaSenyalamiento')
                    , T_MPH ( '166','121','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_LETRADO)','2','0','H002_SenyalamientoSubasta','costasLetrado')
                    , T_MPH ( '167','121','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MINUTA_PROCURADOR)','3','0','H002_SenyalamientoSubasta','costasProcurador')
                    , T_MPH ( '168','122','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_SOLICITUD_SUBASTA)+1','1','1','H002_RevisarDocumentacion','fecha')
                    , T_MPH ( '169','123','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','1','1','H002_PrepararInformeSubasta','fecha')
                    , T_MPH ( '170','124','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MIN(TIPO_SUBASTA),1,1,0)','1','1','H002_ValidarInformeDeSubasta','comboAtribuciones')
                    , T_MPH ( '171','125','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(RESOLUCION_COMITE)','1','1','H002_ObtenerValidacionComite','comboResultado')
                    , T_MPH ( '172','125','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)','2','1','H002_ObtenerValidacionComite','fecha')
                    , T_MPH ( '173','126','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+1','1','1','H002_DictarInstruccionesSubasta','fecha')
                    , T_MPH ( '174','126','MIG_PROCEDIMIENTOS_SUBASTAS','DECODE(MAX(RESOLUCION_COMITE),0,1,1)','2','1','H002_DictarInstruccionesSubasta','comboSuspender')
                    , T_MPH ( '175','127','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+2','1','1','H002_LecturaConfirmacionInstrucciones','fecha')
                    , T_MPH ( '176','128','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+3','1','1','H002_SolicitarSuspenderSubasta','fecha')
                    , T_MPH ( '177','129','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_RegistrarResSuspSubasta','fecha')
                    , T_MPH ( '178','130','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(FECHA_RESOLUCION_PROPUESTA)+4','1','1','H002_DictarInstruccionesDeneSuspension','fecha')
                    , T_MPH ( '179','131','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUBASTA_CELEBRADA)','1','1','H002_CelebracionSubasta','comboCelebrada')
                    , T_MPH ( '180','131','MIG_PROCS_SUBASTAS_LOTES','MAX(CON_POSTORES)','2','0','H002_CelebracionSubasta','comboPostores')
                    , T_MPH ( '181','131','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(SUSPENDIDA_POR)','3','0','H002_CelebracionSubasta','comboDecisionSuspension')
                    , T_MPH ( '182','131','MIG_PROCEDIMIENTOS_SUBASTAS','MAX(MOTIVO_SUSPENSION)','4','0','H002_CelebracionSubasta','comboMotivoSuspension')
                    , T_MPH ( '210','150','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H022_InterposicionDemanda','fechaSolicitud')
                    , T_MPH ( '211','150','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H022_InterposicionDemanda','plazaJuzgado')
                    , T_MPH ( '212','150','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H022_InterposicionDemanda','fechaCierre')
                    , T_MPH ( '213','150','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','1','H022_InterposicionDemanda','principalDemanda')
                    , T_MPH ( '214','150','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H022_InterposicionDemanda','interesesOrdinarios')
                    , T_MPH ( '215','150','MIG_PROCEDIMIENTOS_CABECERA','1','6','0','H022_InterposicionDemanda','provisionFondos')
                    , T_MPH ( '216','151','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H022_ConfirmarAdmisionDemanda','fecha')
                    , T_MPH ( '217','151','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H022_ConfirmarAdmisionDemanda','nPlaza')
                    , T_MPH ( '218','151','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H022_ConfirmarAdmisionDemanda','numJuzgado')
                    , T_MPH ( '219','151','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H022_ConfirmarAdmisionDemanda','numProcedimiento')
                    , T_MPH ( '220','151','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H022_ConfirmarAdmisionDemanda','comboResultado')
                    , T_MPH ( '221','153','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_REQUERIMIENTO)','1','1','H016_confNotifRequerimientoPago','fecha')
                    , T_MPH ( '222','153','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(REQUERIDO,''S'',1,0))]','2','0','H016_confNotifRequerimientoPago','comboResultado')
                    , T_MPH ( '223','154','MIG_PROCEDIMIENTOS_DEMANDADOS',q'[MAX(DECODE(OPOSICION,''S'',1,0))]','1','1','H022_ConfirmarOposicionCuantia','comboResultado')
                    , T_MPH ( '224','154','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_OPOSICION)','2','1','H022_ConfirmarOposicionCuantia','fechaOposicion')
                    , T_MPH ( '225','154','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','3','0','H022_ConfirmarOposicionCuantia','procedimiento')
                    , T_MPH ( '226','154','MIG_PROCEDIMIENTOS_DEMANDADOS','MAX(FECHA_COMPARECENCIA)','4','0','H022_ConfirmarOposicionCuantia','fechaJuicio')
                    , T_MPH ( '227','155','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H024_InterposicionDemanda','fecha')
                    , T_MPH ( '228','155','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_InterposicionDemanda','plazaJuzgado')
                    , T_MPH ( '229','155','MIG_PROCEDIMIENTOS_CABECERA','FECHA_APROBACION_LITC','3','0','H024_InterposicionDemanda','fechaCierre')
                    , T_MPH ( '230','155','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_PRINCIPAL','4','0','H024_InterposicionDemanda','principalDemanda')
                    , T_MPH ( '231','155','MIG_PROCEDIMIENTOS_CABECERA','IMPORTE_INTERESES_APROBADOS','5','0','H024_InterposicionDemanda','interesesOrdinarios')
                    , T_MPH ( '232','156','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H024_ConfirmarAdmision','fecha')
                    , T_MPH ( '233','156','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H024_ConfirmarAdmision','nPlaza')
                    , T_MPH ( '234','156','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H024_ConfirmarAdmision','numJuzgado')
                    , T_MPH ( '235','156','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','4','0','H024_ConfirmarAdmision','numProcedimiento')
                    , T_MPH ( '236','156','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','5','0','H024_ConfirmarAdmision','comboResultado')
                    , T_MPH ( '237','158','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H018_InterposicionDemanda','fecha')
                    , T_MPH ( '238','158','MIG_PROCEDIMIENTOS_CABECERA','PLAZA','2','0','H018_InterposicionDemanda','plazaJuzgado')
                    , T_MPH ( '239','158','MIG_PROCEDIMIENTOS_CABECERA','JUZGADO','3','0','H018_InterposicionDemanda','numJuzgado')
                    , T_MPH ( '240','159','MIG_PROCEDIMIENTOS_CABECERA','NVL(FECHA_ADMISION_DEMANDA,FECHA_INADMISION_DEMANDA)','1','1','H018_AutoDespachando','fecha')
                    , T_MPH ( '241','159','MIG_PROCEDIMIENTOS_CABECERA','NUM_AUTO_SIN_FORMATO','2','0','H018_AutoDespachando','nProc')
                    , T_MPH ( '242','159','MIG_PROCEDIMIENTOS_CABECERA','DECODE(FECHA_ADMISION_DEMANDA,NULL,0,1)','3','0','H018_AutoDespachando','comboSiNo')
                    , T_MPH ( '243','161','MIG_PROCEDIMIENTOS_CABECERA','FECHA_PRESENTACION_DEMANDA','1','1','H028_RegistrarJuicioVerbal','fechaSolicitud')
                    , T_MPH ( '250','170','MIG_CONCURSOS_CABECERA','FECHA_PUBLICACION_BOE','1','1','H009_RegistrarPublicacionBOE','fecha')
                    , T_MPH ( '251','170','MIG_CONCURSOS_CABECERA','FECHA_AUTO_DECLAR_CONCURSO','2','0','H009_RegistrarPublicacionBOE','fechaAuto')
                    , T_MPH ( '252','170','MIG_CONCURSOS_CABECERA',q'[REPLACE(PLAZA,''X'','')]','3','0','H009_RegistrarPublicacionBOE','plazaJuzgado')
                    , T_MPH ( '253','170','MIG_CONCURSOS_CABECERA',q'[REPLACE(JUZGADO,''X'','')]','4','0','H009_RegistrarPublicacionBOE','nJuzgado')
                    , T_MPH ( '254','170','MIG_CONCURSOS_CABECERA','NUM_AUTO_SIN_FORMATO','5','0','H009_RegistrarPublicacionBOE','nAuto')
                    , T_MPH ( '255','170','MIG_CONCURSOS_CABECERA','ADM_CONCURSAL_NOMBRE','6','0','H009_RegistrarPublicacionBOE','admNombre')
                    , T_MPH ( '256','170','MIG_CONCURSOS_CABECERA','ADM_CONCURSAL_TELF','7','0','H009_RegistrarPublicacionBOE','admTelefono')
                    , T_MPH ( '257','170','MIG_CONCURSOS_CABECERA','ADM_CONCURSAL_MAIL','8','0','H009_RegistrarPublicacionBOE','admEmail')
                    , T_MPH ( '258','171','MIG_CONCURSOS_CABECERA','(FECHA_PUBLICACION_BOE)+1','1','1','H009_RevisarEjecuciones','fecha')
                    , T_MPH ( '259','172','MIG_CONCURSOS_CABECERA','(FECHA_PUBLICACION_BOE)+2','1','1','H009_RegistrarInsinuacionCreditos','fecha')
                    , T_MPH ( '260','173','MIG_CONCURSOS_CABECERA','FECHA_COMUNICACION_CREDITOS','1','1','H009_PresentarEscritoInsinuacion','fecha')
                    , T_MPH ( '261','173','MIG_CONCURSOS_CABECERA','TOTAL_CONTRA_MASA','2','0','H009_PresentarEscritoInsinuacion','tCredMasa')
                    , T_MPH ( '262','173','MIG_CONCURSOS_CABECERA','TOTAL_PRIVILEGIADO','3','0','H009_PresentarEscritoInsinuacion','tCredPrivGen')
                    , T_MPH ( '263','173','MIG_CONCURSOS_CABECERA','TOTAL_ORDINARIO','4','0','H009_PresentarEscritoInsinuacion','tCredOrd')
                    , T_MPH ( '264','173','MIG_CONCURSOS_CABECERA','TOTAL_SUBORDINADO','5','0','H009_PresentarEscritoInsinuacion','tCredSub')
                    , T_MPH ( '265','173','MIG_CONCURSOS_CABECERA','TOTAL_CONTINGENTE','6','0','H009_PresentarEscritoInsinuacion','tCredContigentes')
                    , T_MPH ( '266','174','MIG_CONCURSOS_CABECERA','(FECHA_PUBLICACION_BOE)+2','1','1','H009_RevisarInsinuacionCreditos','fecha')
                    , T_MPH ( '267','175','MIG_CONCURSOS_CABECERA','DECODE(POSTURA_ENTIDAD_IMPUGNACION,0,1,0)','1','1','H009_RegistrarProyectoInventario','comFavorable')
                    , T_MPH ( '268','176','MIG_CONCURSOS_CABECERA','FECHA_INFORME_ADM_CONCURSAL','1','1','H009_RegistrarInformeAdmonConcursal','fecha')
                    , T_MPH ( '269','177','MIG_CONCURSOS_CABECERA','DECODE(POSTURA_ENTIDAD_ADM_CONCURSAL,0,1,0)','1','1','H009_RevisarResultadoInfAdmon','comboResultado')
                    , T_MPH ( '270','177','MIG_CONCURSOS_CABECERA','0','2','0','H009_RevisarResultadoInfAdmon','comboAdenda')
                    , T_MPH ( '271','177','MIG_CONCURSOS_CABECERA','DECODE(FECHA_IMPUGNACION,NULL,0,1)','3','0','H009_RevisarResultadoInfAdmon','comboDemanda')
                    , T_MPH ( '272','178','MIG_CONCURSOS_CABECERA','(FECHA_INFORME_ADM_CONCURSAL)+1','1','1','H009_PresentacionAdenda','fecha')
                    , T_MPH ( '273','179','MIG_CONCURSOS_CABECERA','(FECHA_INFORME_ADM_CONCURSAL)+2','1','1','H009_PresentacionJuzgado','fecha')
                    , T_MPH ( '274','180','MIG_CONCURSOS_CABECERA','1','1','1','H009_ResolucionJuzgado','comboAdmitida')
                    , T_MPH ( '275','181','MIG_CONCURSOS_CABECERA','1','1','1','H009_ActualizarEstadoCreditos','observaciones')
                    , T_MPH ( '276','182','MIG_CONCURSOS_CABECERA','FECHA_RESULTADO_IMPUGNACION','1','1','H009_AnyadirTextosDefinitivos','fecha')
                    , T_MPH ( '277','182','MIG_CONCURSOS_CABECERA',q'[DECODE(SUBSTR(FASE_CONCURSO,1,INSTR(FASE_CONCURSO,''-'')-1),''FASE LIQUIDACION'' 1,0)]','1','1','H009_AnyadirTextosDefinitivos','comboLiquidacion')
                    , T_MPH ( '278','183','MIG_CONCURSOS_CABECERA','FECHA_JUNTA_ACREEDORES','1','1','H017_AutoApertura','fechaJunta')
                    , T_MPH ( '279','184','MIG_CONCURSOS_CABECERA','FECHA_JUNTA_ACREEDORES','1','1','H017_PresentacionPropuesta','fecha')
                    , T_MPH ( '280','185','MIG_CONCURSOS_CABECERA','FECHA_JUNTA_ACREEDORES','1','1','H017_ObtenerInformeAdmConcursal','fecha')
                    , T_MPH ( '281','186','MIG_CONCURSOS_CABECERA','FECHA_JUNTA_ACREEDORES','1','1','H017_ElaborarInformeJuntaAcreedores','fecha')
                    , T_MPH ( '282','187','MIG_CONCURSOS_CABECERA','FECHA_JUNTA_ACREEDORES','1','1','H017_ElevarAComite','fecha')
                    , T_MPH ( '283','188','MIG_CONCURSOS_CABECERA','FECHA_JUNTA_ACREEDORES','1','1','H017_RegistrarRespuestaComite','fecha')
                    , T_MPH ( '284','189','MIG_CONCURSOS_CABECERA','FECHA_JUNTA_ACREEDORES','1','1','H017_LecturaInstrucciones','fecha')
                    , T_MPH ( '285','190','MIG_CONCURSOS_CABECERA','FECHA_JUNTA_ACREEDORES','1','1','H017_NotificarInstruccionesProcurador','fecha')
                    , T_MPH ( '286','191','MIG_CONCURSOS_CABECERA','FECHA_JUNTA_ACREEDORES','1','1','H017_RegistrarCelebracionJunta','fechaJunta')
                    , T_MPH ( '287','191','MIG_CONCURSOS_CABECERA','DECODE(RESULTADO_JUNTA_ACREEDORES,0,1,0)','2','0','H017_RegistrarCelebracionJunta','comboAprobacion')
                    , T_MPH ( '288','192','MIG_CONCURSOS_CABECERA','(FECHA_JUNTA_ACREEDORES)+1','1','1','H017_AdjuntarActaJunta','fecha')
                    , T_MPH ( '289','193','MIG_CONCURSOS_CABECERA','(FECHA_JUNTA_ACREEDORES)+2','1','1','H017_RegistrarSentenciaFirme','fecha')
                    , T_MPH ( '290','194','MIG_CONCURSOS_CABECERA','(FECHA_JUNTA_ACREEDORES)+3','1','1','H017_RevisarEjecucionesParalizadas','fecha')
                    , T_MPH ( '291','195','MIG_CONCURSOS_CABECERA','FECHA_LIQUIDACION','1','1','H033_aperturaFase','fecha')
                    , T_MPH ( '292','195','MIG_CONCURSOS_CABECERA','CONSIDERACIONES_LIQUIDACION','2','0','H033_aperturaFase','observaciones')
                       );
                       
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/

 V_TMP_MPH T_MPH;
 
 BEGIN

 DBMS_OUTPUT.PUT_LINE('Se borra la configuración de '||TABLA||'');
 DBMS_OUTPUT.PUT_LINE('DELETE FROM '||V_ESQUEMA||'.'||TABLA||'');


 EXECUTE IMMEDIATE('DELETE FROM '||V_ESQUEMA||'.'||TABLA||'');

  DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||'......');
 FOR I IN V_MPH.FIRST .. V_MPH.LAST
 LOOP
 
  V_TMP_MPH := V_MPH(I);
  
  --FIN CONTADORES
  
  --INICIO INSERT
 
  DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': '||V_TMP_MPH(1)); 

  
  
  V_MSQL:= 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLA||' 
           ( MIG_PHV_ID,MIG_PARAM_HITO_ID,TABLA_MIG,CAMPO_INTERFAZ,ORDEN,FLAG_ES_FECHA,TAP_CODIGO,TEV_NOMBRE)'
	 ||' VALUES ('||V_TMP_MPH(1)||q'[,]'
                    ||V_TMP_MPH(2)||q'[,']' 
                    ||V_TMP_MPH(3)||q'[',']' 
                    ||V_TMP_MPH(4)||q'[',]'
                    ||V_TMP_MPH(5)||q'[,]' 
                    ||V_TMP_MPH(6)||q'[,']' 
                    ||V_TMP_MPH(7)||q'[',']'   
                    ||V_TMP_MPH(8)||q'[')]';
--DBMS_OUTPUT.PUT_LINE(V_MSQL);
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
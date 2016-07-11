--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160516
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0.4
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza campos de TFI_TAREAS_FORM_ITEMS - Obligatorios
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --                TAP_CODIGO                                              TFI_NOMBRE                               TFI_ERROR_VALIDACION
		   T_TFI(   'T001_CheckingInformacion'                        ,        'fecha'                       ,         'Debe indicar la fecha de verificaci&oacute;n'                           ),
		   T_TFI(   'T001_CheckingDocumentacionAdmision'              ,        'fecha'                       ,         'Debe indicar la fecha de verificaci&oacute;n'                           ),
		   T_TFI(   'T001_CheckingDocumentacionGestion'               ,        'fecha'                       ,         'Debe indicar la fecha de verificaci&oacute;n'                           ),
		   T_TFI(   'T001_VerificarEstadoPosesorio'                   ,        'comboOcupado'                ,         'Debe indicar si el activo est&aacute; ocupado'                          ),
		   T_TFI(   'T001_VerificarEstadoPosesorio'                   ,        'comboTitulo'                 ,         'Debe indicar si tiene t&iacute;tulo'                                    ),
		   T_TFI(   'T001_VerificarEstadoPosesorio'                   ,        'fecha'                       ,         'Debe indicar la fecha de verificaci&oacute;n'                           ),
		   T_TFI(   'T002_AnalisisPeticion'                           ,        'comboTramitar'               ,         'Debe indicar si se tramita la petici&oacute;n'                          ),
		   T_TFI(   'T002_AnalisisPeticion'                           ,        'motivoDenegacion'            ,         'Debe indicar un motivo de denegaci&oacute;n'                            ),
		   T_TFI(   'T002_AnalisisPeticion'                           ,        'comboGasto'                  ,         'Debe indicar si se encarga a gestor&iacute;a'                           ),
		   T_TFI(   'T002_AnalisisPeticion'                           ,        'saldoDisponible'             ,         'Debe indicar el saldo disponible'                                       ),
		   T_TFI(   'T002_AnalisisPeticion'                           ,        'comboSaldo'                  ,         'Debe indicar si existe saldo suficiente'                                ),
		   T_TFI(   'T002_SolicitudLPOGestorInterno'                  ,        'fechaSolicitud'              ,         'Debe indicar la fecha de solicitud del documento'                       ),
		   T_TFI(   'T002_AutorizacionPropietario'                    ,        'fecha'                       ,         'Debe indicar la fecha de autorizaci&oacute;n'                           ),
		   T_TFI(   'T002_AutorizacionPropietario'                    ,        'comboAmpliacion'             ,         'Debe indicar si se ampl&iacute;a el presupuesto'                        ),
		   T_TFI(   'T002_AutorizacionPropietario'                    ,        'numIncremento'               ,         'Debe indicar el importe de incremento del presupuesto'                  ),
		   T_TFI(   'T003_AnalisisPeticion'                           ,        'comboTramitar'               ,         'Debe indicar si se tramita la petici&oacute;n'                          ),
		   T_TFI(   'T003_AnalisisPeticion'                           ,        'motivoDenegacion'            ,         'Debe indicar un motivo de denegaci&oacute;n'                            ),
		   T_TFI(   'T003_AnalisisPeticion'                           ,        'saldoDisponible'             ,         'Debe indicar el saldo disponible'                                       ),
		   T_TFI(   'T003_AnalisisPeticion'                           ,        'comboSaldo'                  ,         'Debe indicar si existe saldo suficiente'                                ),
		   T_TFI(   'T003_EmisionCertificado'                         ,        'fechaEmision'                ,         'Debe indicar la fecha de emisi&oacute;n del documento'                  ),
		   T_TFI(   'T003_EmisionCertificado'                         ,        'comboCalificacion'           ,         'Debe indicar la calificaci&oacute;n energ&eacute;tica'                  ),
		   T_TFI(   'T003_EmisionCertificado'                         ,        'comboProcede'                ,         'Debe indicar si procede inscripci&oacute;n de etiqueta'                 ),
		   T_TFI(   'T003_SolicitudEtiqueta'                          ,        'fechaPresentacion'           ,         'Debe indicar la fecha de presentaci&oacute;n'                           ),
		   T_TFI(   'T003_ObtencionEtiqueta'                          ,        'fechaInscripcion'            ,         'Debe indicar la fecha de inscripci&oacute;n'                            ),
		   T_TFI(   'T003_ObtencionEtiqueta'                          ,        'refEtiqueta'                 ,         'Debe indicar la referencia de la etiqueta EE'                           ),
		   T_TFI(   'T003_CierreEconomico'                            ,        'fechaCierre'                 ,         'Debe indicar la fecha de cierre econ&oacute;mico'                       ),
		   T_TFI(   'T004_SolicitudExtraordinaria'                    ,        'fecha'                       ,         'Debe indicar la fecha de solicitud extraordinaria'                      ),
		   T_TFI(   'T004_AutorizacionPropietario'                    ,        'fecha'                       ,         'Debe indicar la fecha de autorizaci&oacute;n'                           ),
		   T_TFI(   'T004_AutorizacionPropietario'                    ,        'comboAmpliacion'             ,         'Debe indicar si se ampl&iacute;a el presupuesto'                        ),
		   T_TFI(   'T004_AutorizacionPropietario'                    ,        'numIncremento'               ,         'Debe indicar el importe de incremento del presupuesto'                  ),
		   T_TFI(   'T004_FijacionPlazo'                              ,        'fechaTope'                   ,         ''                                                                       ),
--		   T_TFI(   'T004_FijacionPlazo'                              ,        'fechaConcreta'               ,         ''                                                                       ),
--		   T_TFI(   'T004_FijacionPlazo'                              ,        'horaConcreta'                ,         ''                                                                       ),
		   T_TFI(   'T004_ResultadoTarificada'                        ,        'fechaFinalizacion'           ,         'Debe indicar la fecha de finalizaci&oacute;n del trabajo'               ),
		   T_TFI(   'T004_ResultadoNoTarificada'                      ,        'comboModificacion'           ,         'Debe indicar si hay modificaci&oacute;n del presupuesto'                ),
		   T_TFI(   'T004_ResultadoNoTarificada'                      ,        'fechaFinalizacion'           ,         'Debe indicar la fecha de finalizaci&oacute;n del trabajo'               ),
		   T_TFI(   'T004_SolicitudPresupuestoComplementario'         ,        'fechaFinalizacion'           ,         'Debe indicar la fecha de autorizaci&oacute;n del nuevo presupuesto'     ),
		   T_TFI(   'T003_SolicitudExtraordinaria'                    ,        'fecha'                       ,         'Debe indicar la fecha de solicitud extraordinaria'                      ),
		   T_TFI(   'T003_AutorizacionPropietario'                    ,        'fecha'                       ,         'Debe indicar la fecha de autorizaci&oacute;n'                           ),
		   T_TFI(   'T003_AutorizacionPropietario'                    ,        'comboAmpliacion'             ,         'Debe indicar si se ampl&iacute;a el presupuesto'                        ),
		   T_TFI(   'T003_AutorizacionPropietario'                    ,        'numIncremento'               ,         'Debe indicar el importe de incremento del presupuesto'                  ),
		   T_TFI(   'T004_AnalisisPeticion'                           ,        'comboTramitar'               ,         'Debe indicar si se tramita la petici&oacute;n'                          ),
		   T_TFI(   'T004_AnalisisPeticion'                           ,        'comboCubierto'               ,         'Debe indicar si est&aacute; cubierto por seguro'                        ),
		   T_TFI(   'T004_AnalisisPeticion'                           ,        'comboAseguradoras'           ,         'Debe indicar la aseguradora'                                            ),
		   T_TFI(   'T004_AnalisisPeticion'                           ,        'comboTarifa'                 ,         'Debe indicar si est&aacute; sujeto a tarifa'                            ),
		   T_TFI(   'T004_AnalisisPeticion'                           ,        'motivoDenegacion'            ,         'Debe indicar un motivo de denegaci&oacute;n'                            ),
		   T_TFI(   'T004_SolicitudPresupuestos'                      ,        'fechaEmision'                ,         'Debe indicar la fecha de solicitud de presupuestos a proveedores'       ),
		   T_TFI(   'T004_EleccionPresupuesto'                        ,        'comboPresupuesto'            ,         'Debe indicar si el presupuesto es v&aacute;lido'                        ),
		   T_TFI(   'T004_EleccionPresupuesto'                        ,        'motivoInvalidez'             ,         'Debe indicar un motivo de invalidez'                                    ),
		   T_TFI(   'T004_EleccionPresupuesto'                        ,        'fechaEmision'                ,         'Debe indicar la fecha de selecci&oacute;n presupuestos a proveedores'   ),
		   T_TFI(   'T004_EleccionProveedorYTarifa'                   ,        'fechaEmision'                ,         'Debe indicar la fecha de emisi&oacute;n'                                ),
		   T_TFI(   'T004_DisponibilidadSaldo'                        ,        'comboSaldo'                  ,         'Debe indicar si hay disponibilidad de saldo'                            ),
		   T_TFI(   'T002_ObtencionLPOGestorInterno'                  ,        'fechaEmision'                ,         'Debe indicar la fecha de obtenci&oacute;n del documento'                ),
		   T_TFI(   'T002_ObtencionLPOGestorInterno'                  ,        'refDocumento'                ,         'Debe indicar la referencia del documento'                               ),
		   T_TFI(   'T002_ObtencionLPOGestorInterno'                  ,        'comboObtencion'              ,         'Debe indicar si se ha obtenido el documento'                            ),
		   T_TFI(   'T002_ObtencionLPOGestorInterno'                  ,        'motivoNoObtencion'           ,         'Debe indicar un motivo de <<no obtenci&oacute;n>>'                      ),
		   T_TFI(   'T002_SolicitudDocumentoGestoria'                 ,        'fechaSolicitud'              ,         'Debe indicar la fecha de solicitud del documento'                       ),
		   T_TFI(   'T002_ObtencionDocumentoGestoria'                 ,        'fechaEmision'                ,         'Debe indicar la fecha de obtenci&oacute;n del documento'                ),
		   T_TFI(   'T002_ObtencionDocumentoGestoria'                 ,        'refDocumento'                ,         'Debe indicar la referencia del documento'                               ),
		   T_TFI(   'T002_ObtencionDocumentoGestoria'                 ,        'comboObtencion'              ,         'Debe indicar si se ha obtenido el documento'                            ),
		   T_TFI(   'T002_ObtencionDocumentoGestoria'                 ,        'motivoNoObtencion'           ,         'Debe indicar un motivo de <<no obtenci&oacute;n>>'                      ),
		   T_TFI(   'T002_ValidacionActuacion'                        ,        'fechaValidacion'             ,         'Debe indicar la fecha de validaci&oacute;n del documento'               ),
		   T_TFI(   'T002_ValidacionActuacion'                        ,        'comboCorreccion'             ,         'Debe indicar si el documento es correcto'                               ),
		   T_TFI(   'T002_ValidacionActuacion'                        ,        'motivoIncorreccion'          ,         'Debe indicar un motivo de incorrecci&oacute;n'                          ),
		   T_TFI(   'T002_ValidacionActuacion'                        ,        'comboValoracion'             ,         'Debe indicar la valoraci&oacute;n del proveedor'                        ),
		   T_TFI(   'T002_CierreEconomico'                            ,        'fechaCierre'                 ,         'Debe indicar la fecha de cierre econ&oacute;mico'                       ),
		   T_TFI(   'T002_SolicitudExtraordinaria'                    ,        'fecha'                       ,         'Debe indicar la fecha de solicitud extraordinaria'                      ),
		   T_TFI(   'T005_AutorizacionPropietario'                    ,        'fecha'                       ,         'Debe indicar la fecha de autorizaci&oacute;n'                           ),
		   T_TFI(   'T005_AutorizacionPropietario'                    ,        'comboAmpliacion'             ,         'Debe indicar si se ampl&iacute;a el presupuesto'                        ),
		   T_TFI(   'T005_AutorizacionPropietario'                    ,        'numIncremento'               ,         'Debe indicar el importe de incremento del presupuesto'                  ),
		   T_TFI(   'T006_AnalisisPeticion'                           ,        'comboTramitar'               ,         'Debe indicar si se tramita la petici&oacute;n'                          ),
		   T_TFI(   'T006_AnalisisPeticion'                           ,        'motivoDenegacion'            ,         'Debe indicar un motivo de denegaci&oacute;n'                            ),
		   T_TFI(   'T006_AnalisisPeticion'                           ,        'saldoDisponible'             ,         'Debe indicar el saldo disponible'                                       ),
		   T_TFI(   'T006_AnalisisPeticion'                           ,        'comboSaldo'                  ,         'Debe indicar si existe saldo suficiente'                                ),
		   T_TFI(   'T006_EmisionInforme'                             ,        'fechaEmision'                ,         'Debe indicar la fecha de emisi&oacute;n de tasaci&oacute;n'             ),
		   T_TFI(   'T006_EmisionInforme'                             ,        'comboImposibilidad'          ,         'Debe indicar si el informe se ha emitido correctamente'                 ),
		   T_TFI(   'T006_EmisionInforme'                             ,        'motivoNoEmision'             ,         'Debe indicar un motivo de <<no emisi&oacute;n>>'                        ),
		   T_TFI(   'T006_ValidacionInforme'                          ,        'fechaValidacion'             ,         'Debe indicar la fecha de validaci&oacute;n del informe'                 ),
		   T_TFI(   'T006_ValidacionInforme'                          ,        'comboCorreccion'             ,         'Debe indicar si hay correcci&oacute;n del informe'                      ),
		   T_TFI(   'T006_ValidacionInforme'                          ,        'motivoIncorreccion'          ,         'Debe indicar un motivo de incorrecci&oacute;n'                          ),
		   T_TFI(   'T006_ValidacionInforme'                          ,        'comboValoracion'             ,         'Debe indicar la valoraci&oacute;n del proveedor'                        ),
		   T_TFI(   'T006_SolicitudExtraordinaria'                    ,        'fecha'                       ,         'Debe indicar la fecha de solicitud extraordinaria'                      ),
		   T_TFI(   'T006_AutorizacionPropietario'                    ,        'fecha'                       ,         'Debe indicar si hay autorizaci&oacute;n'                                ),
		   T_TFI(   'T006_AutorizacionPropietario'                    ,        'comboAmpliacion'             ,         'Debe indicar si se ampl&iacute;a el presupuesto'                        ),
		   T_TFI(   'T006_AutorizacionPropietario'                    ,        'numIncremento'               ,         'Debe indicar el importe de incremento del presupuesto'                  ),
		   T_TFI(   'T006_CierreEconomico'                            ,        'fechaCierre'                 ,         'Debe indicar la fecha de cierre econ&oacute;mico'                       ),
		   T_TFI(   'T007_DescargaListadoMensual'                     ,        'fechaDescarga'               ,         'Debe indicar la fecha de descarga'                                      ),
		   T_TFI(   'T007_EnvioListadoPrefactura'                     ,        'fechaEnvio'                  ,         'Debe indicar la fecha de env&iacute;o de prefacturas'                   ),
		   T_TFI(   'T007_RemisionFacturas'                           ,        'fechaEnvio'                  ,         'Debe indicar la fecha de env&iacute;o de facturas'                      ),
		   T_TFI(   'T007_SubidaListados'                             ,        'fechaSubida'                 ,         'Debe indicar la fecha de subida de facturas'                            ),
		   T_TFI(   'T008_SolicitudDocumento'                         ,        'fechaSolicitud'              ,         'Debe indicar la fecha de solicitud del informe'                         ),
		   T_TFI(   'T008_ObtencionDocumento'                         ,        'fechaEmision'                ,         'Debe indicar la fecha de obtenci&oacute;n del documento'                ),
		   T_TFI(   'T008_ObtencionDocumento'                         ,        'refDocumento'                ,         'Debe indicar la referencia del documento'                               ),
		   T_TFI(   'T008_ObtencionDocumento'                         ,        'comboObtencion'              ,         'Debe indicar si el documento se ha obtenido correctamente.'             ),
		   T_TFI(   'T008_ObtencionDocumento'                         ,        'motivoNoObtencion'           ,         'Debe indicar un motivo de <<no obtenci&oacute;n>>'                      ),
		   T_TFI(   'T008_CierreEconomico'                            ,        'fechaCierre'                 ,         'Debe indicar la fecha de cierre econ&oacute;mico'                       ),
		   T_TFI(   'T004_ValidacionTrabajo'                          ,        'comboEjecutado'              ,         'Debe indicar si el trabajo se ha ejecutado correctamente'               ),
		   T_TFI(   'T004_ValidacionTrabajo'                          ,        'motivoIncorreccion'          ,         'Debe indicar un motivo de incorrecci&oacute;n'                          ),
		   T_TFI(   'T004_ValidacionTrabajo'                          ,        'fechaValidacion'             ,         'Debe indicar la fecha de validaci&oacute;n del trabajo'                 ),
		   T_TFI(   'T004_ValidacionTrabajo'                          ,        'comboValoracion'             ,         'Debe indicar la valoraci&oacute;n del proveedor'                        ),
		   T_TFI(   'T004_CierreEconomico'                            ,        'fechaCierre'                 ,         'Debe indicar la fecha de cierre econ&oacute;mico'                       ),
		   T_TFI(   'T005_AnalisisPeticion'                           ,        'comboTramitar'               ,         'Debe indicar si se tramita la petici&oacute;n'                          ),
		   T_TFI(   'T005_AnalisisPeticion'                           ,        'motivoDenegacion'            ,         'Debe indicar un motivo de denegaci&oacute;n'                            ),
		   T_TFI(   'T005_AnalisisPeticion'                           ,        'saldoDisponible'             ,         'Debe indicar el saldo disponible'                                       ),
		   T_TFI(   'T005_AnalisisPeticion'                           ,        'comboSaldo'                  ,         'Debe indicar si existe saldo suficiente'                                ),
		   T_TFI(   'T005_EmisionTasacion'                            ,        'fechaEmision'                ,         'Debe indicar la fecha de emisi&oacute;n de tasaci&oacute;n'             ),
		   T_TFI(   'T005_CierreEconomico'                            ,        'fechaCierre'                 ,         'Debe indicar la fecha de cierre econ&oacute;mico'                       ),
		   T_TFI(   'T005_SolicitudExtraordinaria'                    ,        'fecha'                       ,         'Debe indicar la fecha de solicitud extraordinaria'                      )

		);
    V_TMP_T_TFI T_TFI;
    
    
    
 -- ## FIN DATOS
 -- ########################################################################################
    
    


BEGIN

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando datos de TFI_TAREAS_FORM_ITEMS. Estableciendo campos obligatorios y textos de validación.');
	-- Bucle UPDATE tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	LOOP
	  V_TMP_T_TFI := V_TFI(I);
	  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ' ||
	  			  'SET TFI_VALIDACION = ''false'' '||
	  			  ',   TFI_ERROR_VALIDACION = '||''''||V_TMP_T_TFI(3)||''''
	  ||' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||''''||V_TMP_T_TFI(1)||''''||')'
	  ||' AND TFI_NOMBRE = '||''''||V_TMP_T_TFI(2)||'''';
	  DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO - Set Campo OBLIGATORIO: '''||V_TMP_T_TFI(2)||''' de '''||V_TMP_T_TFI(1)||''''); 
--	  DBMS_OUTPUT.PUT_LINE(V_MSQL);
	  EXECUTE IMMEDIATE V_MSQL;
	END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Actualizado correctamente.');
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
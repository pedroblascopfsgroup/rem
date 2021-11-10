package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelValidator;

@Component
public class MSVExcelValidatorFactoryImpl {

	@Autowired
	private MSVAgrupacionRestringidoExcelValidator agrupacionRestringidoExcelValidator;

	@Autowired
	private MSVAgrupacionObraNuevaExcelValidator agrupacionObraNuevaExcelValidator;

	@Autowired
	private MSVAgrupacionAsistidaPDVExcelValidator agrupacionAsistidaExcelValidator;

	@Autowired
	private MSVAgrupacionLoteComercialExcelValidator agrupacionLoteComercialExcelValidator;

	@Autowired
	private MSVAgrupacionLoteComercialAlquilerExcelValidator agrupacionLoteComercialAlquilerExcelValidator;

	@Autowired
	private MSVAgrupacionProyectoExcelValidator agrupacionProyectoExcelValidator;

	@Autowired
	private MSVListadoActivosExcelValidator listadoActivosExcelValidator;

	@Autowired
	private MSVActualizarEstadoPublicacion actualizarEstadoPublicacion; // TODO: eliminar.

	@Autowired
	private MSVActualizadorPublicadoVentaExcelValidator actualizadorPublicadoVentaExcelValidator;

	@Autowired
	private MSVActualizadorPublicadoAlquilerExcelValidator actualizadorPublicadoAlquilerExcelValidator;

	@Autowired
	private MSVActualizarPropuestaPreciosActivo actualizarPropuestaPrecioActivo;

	@Autowired
	private MSVActualizarPropuestaPreciosActivoEntidad01 actualizarPropuestaPrecioActivoEntidad01;

	@Autowired
	private MSVActualizarPropuestaPreciosActivoEntidad02 actualizarPropuestaPrecioActivoEntidad02;

	@Autowired
	private MSVActualizarPropuestaPreciosActivoEntidad03 actualizarPropuestaPrecioActivoEntidad03;

	@Autowired
	private MSVActualizarPreciosActivoImporte actualizarPrecioActivo;

	@Autowired
	private MSVActualizarPreciosFSVActivoImporte actualizarPrecioFSVActivo;

	@Autowired
	private MSVAltaActivosExcelValidator altaActvos;

	@Autowired
	private MSVAltaActivosTPExcelValidator altaActivosTP;

	@Autowired
	private MSVActualizarPreciosActivoBloqueo actualizarBloqueoPrecioActivo;

	@Autowired
	private MSVActualizarPreciosActivoBloqueo actualizarDesbloqueoPrecioActivo;

	@Autowired
	private MSVActualizarPerimetroActivo actualizarPerimetroActivo;

	@Autowired
	private MSVActualizarIbiExentoActivo actualizarIbiExentoActivo;

	@Autowired
	private MSVAsociarActivosGasto asociarActivosGasto;

	@Autowired
	private MSVActualizarGestores actualizarGestores;

	@Autowired
	private MSVOcultacionVenta ocultacionVenta;

	@Autowired
	private MSVOcultacionAlquiler ocultacionAlquiler;

	@Autowired
	private MSVVentaDeCarteraExcelValidator ventaDeCartera;

	@Autowired
	private MSVOkTecnicoSelloCalidadExcelValidator okTecnicoValidator;

	@Autowired
	private MSVActivosGastoPorcentajeValidator activosGastoPorcentajeValidator;

	@Autowired
	private MSVInfoDetallePrinexLbkExcelValidator infoDetallePrinexLbk;

	@Autowired
	private MSVDesocultacionVenta desocultacionVenta;

	@Autowired
	private MSVDesocultacionAlquiler desocultarAlquiler;

	@Autowired
	private MSVExclusionDwh excluirDwh;

	@Autowired
	private MSVCargaMasivaSancionExcelValidator cargaMasivaSancionValidator;

	@Autowired
	private MSVValidatorCargaMasivaReclamacion ValidatorNombreCargaMasiva;

	@Autowired
	private MSVValidatorCargaMasivaComunicaciones validatorCargaMasivaComunicaciones;

	@Autowired
	private MSVSituacionComunidadesPropietariosExcelValidator situacionComunidadesPropietarios;

	@Autowired
	private MSVSituacionImpuestosExcelValidator situacionImpuestos;

	@Autowired
	private MSVSituacionPlusvaliaExcelValidator situacionPlusvalia;

	@Autowired
	private MSVValidatorIndicadorActivoVenta indicadorActivoVenta;

	@Autowired
	private MSVValidatorIndicadorActivoAlquiler indicadorActivoAlquiler;

	@Autowired
	private MSVValidadorCargaMasivaAdecuacion adecuacion;

	@Autowired
	private MSVValidatorAgrupacionPromocionAlquiler promocionAlquiler;

	@Autowired
	private MSVImpuestosExcelValidator cargaMasivaImpuestos;

	@Autowired
	private MSVEnvioBurofaxExcelValidator envioBurofax;

	@Autowired
	private MSVSuperGestEcoTrabajosExcelValidator cargaMasivaEcoTrabajos;

	@Autowired
	private MSVOfertasGTAMExcelValidator ofertasGtam;

	@Autowired
	private MSVActualizacionSuperficieExcelValidator actualizadorSuperficie;

	@Autowired
	private MSVActualizadorFechaIngresoChequeExcelValidator fechaIngresoCheque;

	@Autowired
	private MSVActualizacionFormalizacionExcelValidator cargaMasivaFormalizacion ;

	@Autowired
	private MSVActualizacionLPOExcelValidator cargaMasivaLPO;

	@Autowired 
	private MSVSuperDiscPublicacionesExcelValidator disclamerPublicaciones;
	
	@Autowired
	private MSVActualizacionDistribucionPreciosExcelValidator cargaDistribucionPrecios;

	@Autowired 
	private MSVActualizacionPerimetroAppleExcelValidator valoresPerimetroApple;
	
	@Autowired 
	private MSVActualizacionDocAdministrativaExcelValidator docAdministrativa;
		
	@Autowired
	private MSVControlTributosExcelValidator controlTributos;

	@Autowired
	private MSVReclamacionesPlusvaliasExcelValidator reclamacionesPlusvalia;

	@Autowired
	private MSVJuntasOrdinariaExtraExcelValidator juntasOrdinariasExtraordinarias;

	@Autowired
	private MSVGastosRefacturablesExcelValidator gastosRefacturables;
	
	@Autowired
	private MSVActualizacionInformacionInscripcionExcelValidator informacionInscripcion;
	
	@Autowired
	private MSVActualizacionTomaPosesionExcelValidator tomaPosesion;
	
	@Autowired
	private MSVActualizacionFasesPublicacionValidator FasesPublicacion;
	
	@Autowired
	private MSVCambioApiValidator cambioApiValidator;
	
	@Autowired
	private MSVBorradoTrabajosValidator borradoTrabajosValidator;

	@Autowired
	private MSVActualizacionDireccionesComercialesValidator direccionesComerciales;
	
	@Autowired
	private MSVActualizaTrabajosValidator actualizaTrabajos;

	@Autowired
	private MSVGestionPeticionesDePreciosExcelValidator gestionPeticionesDePrecios;
	
	@Autowired
	private MSVTacticoEspartaPublicacionesValidator tacticoEspartaPublicaciones;
	
	@Autowired
	private MSVMasivaSuministrosValidator cargaMasivaSuministros;
	
	@Autowired
	private MSVValidatorEstadosAdmision estadosAdmision;

	@Autowired
	private MSVActualizarCalidadDatosExcelValidator calidadDatos;
	
	@Autowired
	private MSVActualizacionCamposConvivenciaSarebValidator convivenciaSareb;
	
	@Autowired
	private MSVMasivaModificacionLineasDetalleValidator modificacionLineasDetalle;

	@Autowired
	private MSVMasivaUnicaGastosValidator cargaMasivaUnicaGastos;

	@Autowired
	private MSVValidatorConfiguracionPeriodosVoluntarios cargaMasivaConfiguracionPeriodosVoluntarios;

	@Autowired
	private MSVActualizacionComplementoTituloValidator complementoTitulo;

	@Autowired
	private MSVValidatorTarifasPresupuestos validatorTarifasPresupuesto;

	@Autowired
	private MSVSancionesBBVAExcelValidator sancionesBBVA;

	@Autowired
	private MSVMasivaDatosSobreGastoValidator datosSobreGasto;

	@Autowired
	private MSVValidatorCargaGastosAsociadosAdquisicion cargaGastosAsociadosAdquisicion;

	@Autowired
	private MSVMasivaAltaBBVAValidator altaActivosBBVA;

	@Autowired
	private MSVActualizarEstadosTrabajos cargaMasivaEstadoTrabajos;

	@Autowired
	private MSVActualizarPorcentajeConstruccion actualizarPorcentajeConstruccion;

	@Autowired
	private MSVMasivaAltaTrabajosValidator altaTrabajos;
	
	@Autowired
	private MSVMasivaFechasTituloYPosesionValidator fechaTituloYposesion;

	@Autowired
	private MSVValidatorCargaCamposAccesibilidad cargaCamposAccesibilidad;
	
	@Autowired
	private MSVConfiguracionRecomendacionValidator msvConfigRecomendacion;

	public MSVExcelValidator getForTipoValidador(String codTipoOperacion) {

		if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPATION_RESTRICTED.equals(codTipoOperacion)) {
			return agrupacionRestringidoExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_NEW_BUILDING.equals(codTipoOperacion)) {
			return agrupacionObraNuevaExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_ASISTIDA.equals(codTipoOperacion)) {
			return agrupacionAsistidaExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_LOTE_COMERCIAL.equals(codTipoOperacion)) {
			return agrupacionLoteComercialExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_PROYECTO.equals(codTipoOperacion)) {
			return agrupacionProyectoExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_FINANCIEROS.equals(codTipoOperacion)) {
			return altaActvos;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_LISTAACTIVOS.equals(codTipoOperacion)) {
			return listadoActivosExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO.equals(codTipoOperacion)) {
			return actualizarPropuestaPrecioActivo;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD01.equals(codTipoOperacion)) {
			return actualizarPropuestaPrecioActivoEntidad01;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD02.equals(codTipoOperacion)) {
			return actualizarPropuestaPrecioActivoEntidad02;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD03.equals(codTipoOperacion)) {
			return actualizarPropuestaPrecioActivoEntidad03;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_IMPORTE.equals(codTipoOperacion)) {
			return actualizarPrecioActivo;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_FSV_ACTIVO_IMPORTE.equals(codTipoOperacion)) {
			return actualizarPrecioFSVActivo;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_BLOQUEO.equals(codTipoOperacion)) {
			return actualizarBloqueoPrecioActivo;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_DESBLOQUEO.equals(codTipoOperacion)) {
			return actualizarDesbloqueoPrecioActivo;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR_ORDINARIA.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARACTIVO.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARACTIVO.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARPRECIO.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARPRECIO.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESPUBLICAR.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESMARCAR_PUBLICAR_FORZADO.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESMARCAR_DESPUBLICAR_FORZADO.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_AUTORIZAREDICION.equals(codTipoOperacion)) {
			return actualizarEstadoPublicacion;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PERIMETRO_ACTIVO.equals(codTipoOperacion)) {
			return actualizarPerimetroActivo;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_MARCAR_IBI_EXENTO_ACTIVO.equals(codTipoOperacion) || MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_DESMARCAR_IBI_EXENTO_ACTIVO.equals(codTipoOperacion)) {
			return actualizarIbiExentoActivo;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ASOCIAR_ACTIVOS_GASTO.equals(codTipoOperacion)) {
			return asociarActivosGasto;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_GESTORES.equals(codTipoOperacion)) {
			return actualizarGestores;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_OCULTACION_VENTA.equals(codTipoOperacion)) {
			return ocultacionVenta;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_THIRD_PARTY.equals(codTipoOperacion)) {
			return altaActivosTP;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CENTRAL_TECNICA_OK_TECNICO_SELLO_CALIDAD.equals(codTipoOperacion)) {
			return okTecnicoValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_OCULTACION_ALQUILER.equals(codTipoOperacion)) {
			return ocultacionAlquiler;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PUBLICAR_ACTIVOS_VENTA.equals(codTipoOperacion)) {
			return actualizadorPublicadoVentaExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PUBLICAR_ACTIVOS_ALQUILER.equals(codTipoOperacion)) {
			return actualizadorPublicadoAlquilerExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VENTA_DE_CARTERA.equals(codTipoOperacion)) {
			return ventaDeCartera;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_ACTIVOS_GASTOS_PORCENTAJE.equals(codTipoOperacion)) {
			return activosGastoPorcentajeValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_INFO_DETALLE_PRINEX_LBK.equals(codTipoOperacion)) {
			return infoDetallePrinexLbk;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_SITUACION_COMUNIDADEDES_PROPIETARIOS.equals(codTipoOperacion)) {
			return situacionComunidadesPropietarios;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_SITUACION_IMPUESTOS.equals(codTipoOperacion)) {
			return situacionImpuestos;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_SITUACION_PLUSVALIA.equals(codTipoOperacion)) {
			return situacionPlusvalia;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_LOTE_COMERCIAL_ALQUILER.equals(codTipoOperacion)) {
			return agrupacionLoteComercialAlquilerExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_DESOCULTACION_VENTA.equals(codTipoOperacion)) {
			return desocultacionVenta;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_DESOCULTACION_ALQUILER.equals(codTipoOperacion)) {
			return desocultarAlquiler;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_INDICADOR_ACTIVO_VENTA.equals(codTipoOperacion)) {
			return indicadorActivoVenta;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_INDICADOR_ACTIVO_ALQUILER.equals(codTipoOperacion)) {
			return indicadorActivoAlquiler;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_ADECUACION.equals(codTipoOperacion)) {
			return adecuacion;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_EXCLUSION_DWH.equals(codTipoOperacion)) {
			return excluirDwh;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_PROMOCION_ALQUILER.equals(codTipoOperacion)) {
			return promocionAlquiler;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_IMPUESTOS.equals(codTipoOperacion)) {
			return cargaMasivaImpuestos;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_ENVIO_BUROFAX.equals(codTipoOperacion)) {
			return envioBurofax;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_ACTUALIZACION_SUPERFICIE.equals(codTipoOperacion)) {
			return actualizadorSuperficie;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_ACTUALIZADOR_FECHA_INGRESO_CHEQUE.equals(codTipoOperacion)) {
			return fechaIngresoCheque;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SANCIONES.equals(codTipoOperacion)) {
			return cargaMasivaSancionValidator;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_RECLAMACIONES.equals(codTipoOperacion)) {
			return ValidatorNombreCargaMasiva;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_COMUNICACIONES.equals(codTipoOperacion) ) {
			return validatorCargaMasivaComunicaciones;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_OFERTAS_GTAM.equals(codTipoOperacion)){
			return ofertasGtam;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_GESTION_ECONOMICA_TRABAJOS.equals(codTipoOperacion)) {
			return cargaMasivaEcoTrabajos;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FORMALIZACION.equals(codTipoOperacion)) {
			return cargaMasivaFormalizacion;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_DISCLAIMER_PUBLICACION.equals(codTipoOperacion)) {
			return disclamerPublicaciones;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_DISTRIBUCION_PRECIOS.equals(codTipoOperacion)) {
			return cargaDistribucionPrecios;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALORES_PERIMETRO_APPLE.equals(codTipoOperacion)) {
			return valoresPerimetroApple;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_LPO.equals(codTipoOperacion)) {
			return cargaMasivaLPO;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_DOCUMENTACION_ADMINISTRATIVA.equals(codTipoOperacion)) {
			return docAdministrativa;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CONTROL_TRIBUTOS.equals(codTipoOperacion)) {
			return controlTributos;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_RECLAMACIONES_PLUSVALIAS.equals(codTipoOperacion)) {
			return reclamacionesPlusvalia;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_JUNTAS.equals(codTipoOperacion)) {
			return juntasOrdinariasExtraordinarias;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_SUPER_GASTOS_REFACTURABLES.equals(codTipoOperacion)) {
			return gastosRefacturables;
		}else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_INSCRIPCIONES.equals(codTipoOperacion)) {
			return informacionInscripcion;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_TOMA_POSESION.equals(codTipoOperacion)) {
			return tomaPosesion;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FASES_PUBLICACION.equals(codTipoOperacion)) {
			return FasesPublicacion;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_API_VALIDATOR.equals(codTipoOperacion)) {
			return cambioApiValidator;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SUPER_BORRADO_TRABAJOS.equals(codTipoOperacion)) {
			return borradoTrabajosValidator; 
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_DIRECCIONES_COMERCIALES.equals(codTipoOperacion)) {
			return direccionesComerciales;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_TRABAJOS.equals(codTipoOperacion)) {
            return actualizaTrabajos;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_GESTION_PETICIONES_PRECIOS.equals(codTipoOperacion)) {
			return gestionPeticionesDePrecios;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_TACTICO_ESPARTA_PUBLICACIONES.equals(codTipoOperacion)) {
			return tacticoEspartaPublicaciones;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SUMINISTROS.equals(codTipoOperacion)) {
			return cargaMasivaSuministros;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ESTADOS_ADMISION.equals(codTipoOperacion)) {
			return estadosAdmision;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_MASIVO_CALIDAD_DATOS.equals(codTipoOperacion)) {
			return calidadDatos;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZACION_CAMPOS_ESPARTAR_CONVIVENCIA_SAREB.equals(codTipoOperacion)) {
			return convivenciaSareb;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_MODIFICACION_LINEAS_DE_DETALLE.equals(codTipoOperacion)) {
			return modificacionLineasDetalle;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_UNICA_GASTOS.equals(codTipoOperacion)) {
			return cargaMasivaUnicaGastos;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CONFIGURACION_PERIODOS_VOLUNTARIOS.equals(codTipoOperacion)) {
			return cargaMasivaConfiguracionPeriodosVoluntarios;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_COMPLEMENTO_TITULO.equals(codTipoOperacion)) {
			return complementoTitulo;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_GASTOS_ASOCIADOS_ADQUISICION.equals(codTipoOperacion)) {
			return cargaGastosAsociadosAdquisicion;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ALTA_ACTIVOS_BBVA.equals(codTipoOperacion)) {
			return altaActivosBBVA;
		}else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_MASIVO_TARIFAS_PRESUPUESTO.equals(codTipoOperacion)) {
			return validatorTarifasPresupuesto;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SANCIONES_BBVA.equals(codTipoOperacion)) {
			return sancionesBBVA;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CAMPOS_ACCESIBILIDAD.equals(codTipoOperacion)) {
			return cargaCamposAccesibilidad;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SOBRE_GASTOS.equals(codTipoOperacion)) {
			return datosSobreGasto;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_ESTADO_TRABAJOS.equals(codTipoOperacion)) {
			return cargaMasivaEstadoTrabajos;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ALTA_TRABAJOS.equals(codTipoOperacion)) {
			return altaTrabajos;
		}else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_MASIVO_TARIFAS_PRESUPUESTO.equals(codTipoOperacion)) {
			return validatorTarifasPresupuesto;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_COMPLEMENTO_TITULO.equals(codTipoOperacion)) {
			return complementoTitulo;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_GASTOS_ASOCIADOS_ADQUISICION.equals(codTipoOperacion)) {
			return cargaGastosAsociadosAdquisicion;
		}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ALTA_ACTIVOS_BBVA.equals(codTipoOperacion)) {
			return altaActivosBBVA;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SANCIONES_BBVA.equals(codTipoOperacion)) {
			return sancionesBBVA;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CONFIGURACION_PERIODOS_VOLUNTARIOS.equals(codTipoOperacion)) {
			return cargaMasivaConfiguracionPeriodosVoluntarios;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FECHA_TITULO_Y_POSESION.equals(codTipoOperacion)) {
			return fechaTituloYposesion;
		} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PORCENTAJE_CONSTRUCCION.equals(codTipoOperacion)) {
			return actualizarPorcentajeConstruccion;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CONFIGURACION_RECOMENDACION.equals(codTipoOperacion)) {
			return msvConfigRecomendacion;
		}

		return null;
	}
}

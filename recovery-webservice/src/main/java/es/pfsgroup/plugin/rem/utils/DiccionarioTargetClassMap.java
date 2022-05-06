package es.pfsgroup.plugin.rem.utils;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.dd.*;

@Component
public class DiccionarioTargetClassMap{

	public static Map<String, Class<?>> mapaDiccionarios = createHashMap();
	
	/**
	 * Método que devuelve la clase del diccionario solicitado
	 * @param diccionario
	 * @return Class del diccinario
	 */
	public static Class<?> convertToTargetClass(String diccionario) {
		
		return mapaDiccionarios.get(diccionario);
		
	}

	/**
	 * Método que crea el mapa con los valores tipoDiccionario y clase a la que pertenece
	 * @return {@link HashMap}
	 */
	private static Map<String, Class<?>> createHashMap() {
		
		Map<String, Class<?>> mapa = new HashMap<String, Class<?>>();
		
		mapa.put("tiposVia", DDTipoVia.class);		
		mapa.put("entidadesPropietarias", DDCartera.class);
		mapa.put("subentidadesPropietarias", DDSubcartera.class);
		mapa.put("tiposUsoDestino", DDTipoUsoDestino.class);
		mapa.put("acabadosCarpinteria", DDAcabadoCarpinteria.class);
		mapa.put("estadosActivo", DDEstadoActivo.class);
		mapa.put("tiposCuota", DDTipoCuota.class);
		mapa.put("tiposVpo", DDTipoVpo.class);
		mapa.put("tiposPosesorio", DDTipoTituloPosesorio.class);
		mapa.put("estadosObraNueva", DDEstadoObraNueva.class);
		mapa.put("estadosDivHorizontal", DDEstadoDivHorizontal.class);
		mapa.put("estadosPresupuesto", DDEstadoPresupuesto.class);
		mapa.put("tiposGradoPropiedad", DDTipoGradoPropiedad.class);
		mapa.put("tiposTitulo", DDTipoTituloActivo.class);
		mapa.put("subtiposTitulo", DDSubtipoTituloActivo.class);
		mapa.put("estadosTitulo", DDEstadoTitulo.class);
		mapa.put("tiposUbicacion", DDTipoUbicacion.class);
		mapa.put("ubicacionActivo", DDUbicacionActivo.class);
		mapa.put("ubicacionesAparcamiento", DDTipoUbicaAparcamiento.class);
		mapa.put("estadosConstruccion", DDEstadoConstruccion.class);
		mapa.put("estadosConservacion", DDEstadoConservacion.class);
		mapa.put("tiposFachada",DDTipoFachada.class);
		mapa.put("tiposVivienda", DDTipoVivienda.class);
		mapa.put("tiposOrientacion", DDTipoOrientacion.class);
		mapa.put("tiposRenta", DDTipoRenta.class);
		mapa.put("tiposActivo", DDTipoActivo.class);
		mapa.put("tiposActivoBde", DDTipoActivoBDE.class);
		mapa.put("provincias", DDProvincia.class);
		mapa.put("subtiposActivo", DDSubtipoActivo.class);
		mapa.put("subtiposActivoBde", DDSubtipoActivoBDE.class);
		mapa.put("tiposCarga", DDTipoCargaActivo.class);
		mapa.put("subtiposCarga", DDSubtipoCarga.class);
		mapa.put("tiposHabitaculo", DDTipoHabitaculo.class);
		mapa.put("situacionCarga", DDSituacionCarga.class);
		mapa.put("estadosCarga", DDEstadoCarga.class);
		mapa.put("subestadosCarga", DDSubestadoCarga.class);
		mapa.put("estadosAdjudicacion", DDEstadoAdjudicacion.class);
		mapa.put("tiposJuzgado", TipoJuzgado.class);
		mapa.put("entidadesAdjudicacion", DDEntidadAdjudicataria.class);
		mapa.put("estadoDocumento", DDEstadoDocumento.class);	
		mapa.put("tipoAgrupacion", DDTipoAgrupacion.class);
		mapa.put("tiposTrabajo", DDTipoTrabajo.class);
		mapa.put("subtiposTrabajo", DDSubtipoTrabajo.class);
		mapa.put("tipoTasacion", DDTipoTasacion.class);
		mapa.put("estadoTrabajo", DDEstadoTrabajo.class);
		mapa.put("valoracionTrabajo", DDTipoCalidad.class);
		mapa.put("tiposDocumento", DDTipoDocumentoActivo.class);
		mapa.put("tiposFoto", DDTipoFoto.class);
		mapa.put("descripcionesFoto", DDDescripcionFotoActivo.class);
		mapa.put("tiposTramite", TipoProcedimiento.class);
		mapa.put("tiposCalculo", DDTipoCalculo.class);
		mapa.put("tiposRecargo", DDTipoRecargoProveedor.class);
		mapa.put("tiposAdelanto", DDTipoAdelanto.class);
		mapa.put("tiposPlaza", TipoPlaza.class);
		mapa.put("entidadEjecutante", DDEntidadEjecutante.class);
		mapa.put("estadosPropuesta", DDEstadoPropuestaPrecio.class);
		mapa.put("estadosPropuestaActivo", DDEstadoPropuestaActivo.class);
		mapa.put("estadoDisponibilidadComercial", DDEstadoDisponibilidadComercial.class);
		mapa.put("estadosOfertas", DDEstadoOferta.class);
		mapa.put("tiposOfertas", DDTipoOferta.class);
		mapa.put("tiposTextoOferta", DDTiposTextoOferta.class);
		mapa.put("estadosVisita", DDEstadosVisita.class);
		mapa.put("estadosVisitaOferta", DDEstadosVisitaOferta.class);
		mapa.put("estadosInformeComercial", DDEstadoInformeComercial.class);
		mapa.put("tiposArras", DDTiposArras.class);
		mapa.put("estadoProveedor", DDEstadoProveedor.class);
		mapa.put("tipoProveedor", DDEntidadProveedor.class);
		mapa.put("subtipoProveedor", DDTipoProveedor.class);
		mapa.put("tipoPersona", DDTiposPersona.class);
		mapa.put("municipio", Localidad.class);
		mapa.put("tiposDocumentos", DDTipoDocumento.class);
		mapa.put("tiposDocumentoExpediente", DDTipoDocumentoExpediente.class);
		mapa.put("subtiposDocumentoExpediente", DDSubtipoDocumentoExpediente.class);
		mapa.put("estadosCiviles", DDEstadosCiviles.class);
		mapa.put("unidadPoblacional", DDUnidadPoblacional.class);
		mapa.put("estadosFinanciacion", DDEstadoFinanciacion.class);
		mapa.put("entidadesFinancieras", DDEntidadesFinancieras.class);
		mapa.put("tiposPorCuenta", DDTiposPorCuenta.class);
		mapa.put("tiposImpuestos", DDTiposImpuesto.class);
		mapa.put("situacionesPosesoria", DDSituacionesPosesoria.class);
		mapa.put("usosActivo", DDUsosActivo.class);
		mapa.put("regimenesMatrimoniales", DDRegimenesMatrimoniales.class);
		mapa.put("tiposComparecientes", DDTiposCompareciente.class);
		mapa.put("calificacionProveedor", DDCalificacionProveedor.class);
		mapa.put("calificacionProveedorRetirar", DDCalificacionProveedorRetirar.class);		
		mapa.put("resultadoProcesoBlanqueo", DDResultadoProcesoBlanqueo.class);
		mapa.put("motivoRetencionPago", DDMotivoRetencion.class);
		mapa.put("tipoActivosCartera", DDTipoActivosCartera.class);
		mapa.put("tipoDireccionProveedor", DDTipoDireccionProveedor.class);
		mapa.put("cargoProveedor", DDCargoProveedorContacto.class);
		mapa.put("tipoDocumentoProveedor", DDTipoDocumentoProveedor.class);
		mapa.put("motivoAplicaComercializarActivo", DDMotivoComercializacion.class);
		mapa.put("claseActivoBancario", DDClaseActivoBancario.class);
		mapa.put("subtipoClaseActivoBancario", DDSubtipoClaseActivoBancario.class);
		mapa.put("tipoProductoBancario", DDTipoProductoBancario.class);
		mapa.put("estadoExpRiesgoBancario", DDEstadoExpRiesgoBancario.class);
		mapa.put("estadoExpIncorrienteBancario", DDEstadoExpIncorrienteBancario.class);
		mapa.put("motivoNoAplicaComercializarActivo", DDMotivoNoComercializacion.class);
		mapa.put("tipoPeriocidad", DDTipoPeriocidad.class);
		mapa.put("tiposGasto", DDTipoGasto.class);
		mapa.put("destinatariosGasto", DDDestinatarioGasto.class);
		mapa.put("subtiposGasto", DDSubtipoGasto.class);
		mapa.put("tipoPagador", DDTipoPagador.class);
		mapa.put("destinataioPago", DDDestinatarioPago.class);
		mapa.put("estadosProvision", DDEstadoProvisionGastos.class);
		mapa.put("motivosAutorizacionPropietaro", DDMotivoAutorizacionPropietario.class);
		mapa.put("estadosAutorizacionHaya", DDEstadoAutorizacionHaya.class);
		mapa.put("motivosRechazoHaya", DDMotivoRechazoAutorizacionHaya.class);
		mapa.put("estadosAutorizacionPropietario", DDEstadoAutorizacionPropietario.class);
		mapa.put("motivosAnulados", DDMotivoAnulacionGasto.class);
		mapa.put("motivosRetenerPago", DDMotivoRetencionPago.class);
		mapa.put("resultadosImpugnacion", DDResultadoImpugnacionGasto.class);
		mapa.put("tiposDocumentosGasto", DDTipoDocumentoGasto.class);
		mapa.put("tiposColaborador", DDTiposColaborador.class);
		mapa.put("canalesPrescripcion", DDCanalPrescripcion.class);
		mapa.put("estadoGasto", DDEstadoGasto.class);
		mapa.put("estadosPublicacion", DDEstadoPublicacionVenta.class);
		mapa.put("estadosPublicacionAlquiler", DDEstadoPublicacionAlquiler.class);
		mapa.put("comitesSancion", DDComiteSancion.class);
		mapa.put("tiposProveedorHonorario", DDTipoProveedorHonorario.class);
		mapa.put("accionesGasto", DDAccionGastos.class);
		mapa.put("estadosDevolucion", DDEstadoDevolucion.class);
		mapa.put("motivoAnulacionExpediente", DDMotivoAnulacionExpediente.class);
		mapa.put("motivoRechazoExpediente", DDMotivoRechazoExpediente.class);
		mapa.put("motivoAnulacionOferta", DDMotivoAnulacionOferta.class);
		mapa.put("operativa", DDOperativa.class);
		mapa.put("tiposComercializacionActivo", DDTipoComercializacion.class);
		mapa.put("tiposComercializarActivo", DDTipoComercializar.class);
		mapa.put("tiposAlquilerActivo", DDTipoAlquiler.class);
		mapa.put("tiposEstadoAlquiler", DDTipoEstadoAlquiler.class);
		mapa.put("resultadoTanteo", DDResultadoTanteo.class);
		mapa.put("tipoTenedor", DDTipoTenedor.class);
		mapa.put("tipoOperacionGasto", DDTipoOperacionGasto.class);
		mapa.put("subtipoPlazaGaraje", DDSubtipoPlazaGaraje.class);
		mapa.put("areaBloqueo", DDAreaBloqueo.class);
		mapa.put("tipoBloqueo", DDTipoBloqueo.class);
		mapa.put("situacionComercial", DDSituacionComercial.class);
		mapa.put("tipoPropuestaPrecio", DDTipoPropuestaPrecio.class);
		mapa.put("indicadorCondicionPrecio", DDCondicionIndicadorPrecio.class);
		mapa.put("tiposFinanciacion", DDTipoRiesgoClase.class);
		mapa.put("devolucionReserva", DDDevolucionReserva.class);
		mapa.put("estadosExpediente", DDEstadosExpedienteComercial.class);
		mapa.put("tipoObservacionActivo", DDTipoObservacionActivo.class);
		mapa.put("ratingActivo", DDRatingActivo.class);
		mapa.put("administracion", DDAdministracion.class);
		mapa.put("motivosDesbloqueo", DDMotivosDesbloqueo.class);
		mapa.put("motivosAvisoGasto", DDMotivosAvisoGasto.class);
		mapa.put("paises", DDPaises.class);
		mapa.put("origenDato", DDOrigenDato.class);
		mapa.put("tipoRechazoOferta", DDTipoRechazoOferta.class);
		mapa.put("motivoRechazoOferta", DDMotivoRechazoOferta.class);
		mapa.put("entradaActivoBankia", DDEntradaActivoBankia.class);
		mapa.put("favorableDesfavorable", DDFavorable.class);
		mapa.put("calificacionEnergetica", DDTipoCalificacionEnergetica.class);
		mapa.put("motivosOcultacion", DDMotivosOcultacion.class);
		mapa.put("comboAdecuacionAlquiler", DDAdecuacionAlquiler.class);
		mapa.put("tareaDestinoSalto", DDTareaDestinoSalto.class);
		mapa.put("countries", DDCicCodigoIsoCirbeBKP.class);
		mapa.put("calculoImpuesto", DDCalculoImpuesto.class);
		mapa.put("tiposInquilino", DDTipoInquilino.class);
		mapa.put("estadoScoring", DDEstadoScoring.class);
		mapa.put("estadoSeguroRentas", DDEstadoSeguroRentas.class);
		mapa.put("entidadesAvalistas", DDEntidadesAvalistas.class);
		mapa.put("tiposDocumentoPromocion", DDTipoDocumentoPromocion.class);
		mapa.put("tiposDocumentoProyecto", DDTipoDocumentoProyecto.class);
		mapa.put("estadosReserva", DDEstadosReserva.class);
		mapa.put("situacionActivo", DDSituacionActivo.class);
		mapa.put("calificacionNegativa", DDCalificacionNegativa.class);
		mapa.put("motivosCalificacionNegativa", DDMotivoCalificacionNegativa.class);
		mapa.put("tipoTituloActivoTPA", DDTipoTituloActivoTPA.class);
		mapa.put("sancionGencat", DDSancionGencat.class);
		mapa.put("estadoComunicacionGencat", DDEstadoComunicacionGencat.class);
		mapa.put("tipoDocumentoGencat", DDTipoDocumentoGencat.class);
		mapa.put("tipoNotificacionGencat", DDTipoNotificacionGencat.class);
		mapa.put("tipoDocumentoComunicacion", DDTipoDocumentoComunicacion.class);
		mapa.put("estadoMotivoCalificacionNegativa", DDEstadoMotivoCalificacionNegativa.class);
		mapa.put("responsableSubsanar", DDResponsableSubsanar.class);
		mapa.put("clasificacionApple", DDClasificacionApple.class);
		mapa.put("entidadFinanciera", DDEntidadFinanciera.class);
		mapa.put("origenComprador", DDOrigenComprador.class);
		mapa.put("estadosCivilesURSUS", DDEstadosCivilesURSUS.class);
		mapa.put("EstadoPresentacion", DDEstadoPresentacion.class);
		mapa.put("fasePublicacion", DDFasePublicacion.class);
		mapa.put("tipoDocumentoAgrupacion", DDTipoDocumentoAgrupacion.class);
		mapa.put("claseOferta", DDClaseOferta.class);
		mapa.put("servicerActivo", DDServicerActivo.class);
		mapa.put("cesionSaneamiento", DDCesionSaneamiento.class);
		mapa.put("tiposEquipoGestion", DDEquipoGestion.class);
		mapa.put("tiposDeRecargo", DDTipoRecargoGasto.class);
		mapa.put("tipoEstadoLoc", DDEstadoLocalizacion.class);
		mapa.put("tipoSubestadoGestion", DDSubestadoGestion.class);
		mapa.put("motivoAutorizacionTramitacion", DDMotivoAutorizacionTramitacion.class);
		mapa.put("tipoSolicitudTributo", DDTipoSolicitudTributo.class);
		mapa.put("tipoDocJunta", DDTipoDocJuntas.class);
		mapa.put("tipoDocumentoPlusvalia", DDTipoDocPlusvalias.class);
		mapa.put("estadoGestionPlusvalia", DDEstadoGestionPlusv.class);
		mapa.put("faseDePublicacion", DDFasePublicacion.class);
		mapa.put("subfaseDePublicacion", DDSubfasePublicacion.class);
		mapa.put("cesionUso", DDCesionUso.class);
		mapa.put("DDSiNo", DDSinSiNo.class);
		mapa.put("tipoDireccionComercial", DDTerritorio.class);
		mapa.put("canalDePublicacionActivo", DDPortal.class);
		mapa.put("direccionTerritorial", DDDireccionTerritorial.class);
		mapa.put("situacionPagoAnterior", DDSociedadPagoAnterior.class);
		mapa.put("tipoPublicacion", DDTipoPublicacion.class);
		mapa.put("tipoSegmento", DDTipoSegmento.class);
		mapa.put("origenAnterior", DDOrigenAnterior.class);
		mapa.put("tipoPeticionPrecio", DDTipoPeticionPrecio.class);
		mapa.put("tipoComision", DDTipoComisionado.class);
		mapa.put("tipoElemento", DDEntidadGasto.class);
		mapa.put("tipoApunte", DDTipoApunte.class);
		mapa.put("tiposGastos", DDTipoGasto.class);
		mapa.put("tipoTransmision", DDTipoTransmision.class);
		mapa.put("tipoAlta", DDTipoAlta.class);
		mapa.put("tributacionAdquisicion", DDTributacionAdquisicion.class);
		mapa.put("tipoTributo", DDTipoTributo.class);
		mapa.put("tipoSuministro", DDTipoSuministro.class);
		mapa.put("subtipoSuministro", DDSubtipoSuministro.class);
		mapa.put("companiaSuministradora", ActivoProveedor.class);
		mapa.put("domiciliado", DDSinSiNo.class);
		mapa.put("periodicidad", DDPeriodicidad.class);
		mapa.put("motivoAltaSuministro", DDMotivoAltaSuministro.class);
		mapa.put("motivoBajaSuministro", DDMotivoBajaSuministro.class);
		mapa.put("validado", DDSinSiNo.class);
		mapa.put("estadoVenta", DDEstadoVenta.class);
		mapa.put("motivoExento", DDMotivoExento.class);
		mapa.put("resultadoSolicitud", DDResultadoSolicitud.class);
		mapa.put("estadosAdmision", DDEstadoAdmision.class); //
		mapa.put("subEstadosAdmision", DDSubestadoAdmision.class); //
		mapa.put("subtipologias", DDSubtipologiaAgenda.class);
		mapa.put("siNoNoAplica", DDSiNoNoAplica.class);
		mapa.put("situacionInicialInscripcion",DDSituacionInicialInscripcion.class);
		mapa.put("situacionPosesoriaInicial",DDSituacionPosesoriaInicial.class);
		mapa.put("situacionInicialCargas",DDSituacionInicialCargas.class);
		mapa.put("tipoTitularidad",DDTipoTitularidad.class);
		mapa.put("autorizacionTransmision",DDAutorizacionTransmision.class);
		mapa.put("anotacionConcurso",DDAnotacionConcurso.class);
		mapa.put("estadoGestion",DDEstadoGestion.class);
		mapa.put("licenciaPrimeraOcupacion",DDLicenciaPrimeraOcupacion.class);
		mapa.put("boletines",DDBoletines.class);
		mapa.put("seguroDecenal",DDSeguroDecenal.class);
		mapa.put("cedulaHabitabilidad",DDCedulaHabitabilidad.class);
		mapa.put("tipoArrendamiento",DDTipoArrendamiento.class);
		mapa.put("tipoExpedienteAdministrativo",DDTipoExpedienteAdministrativo.class);
		mapa.put("tipoIncidenciaRegistral",DDTipoIncidenciaRegistral.class);
		mapa.put("tipoOcupacionLegal",DDTipoOcupacionLegal.class);
		mapa.put("tipoagendasaneamiento",DDTipoAgendaSaneamiento.class);
		mapa.put("subtipoagendasaneamiento", DDSubtipoAgendaSaneamiento.class);
		mapa.put("situacionConstructivaRegistral", DDSituacionConstructivaRegistral.class);
		mapa.put("proteccionOficial", DDProteccionOficial.class);
		mapa.put("tipoIncidencia", DDTipoIncidencia.class);
		mapa.put("tipoTituloInfoRegistal", DDTipoTituloAdicional.class);
		mapa.put("estadoRegistral", DDEstadoRegistralActivo.class);
		mapa.put("tipoTituloComplemento", DDTipoTituloComplemento.class);
		mapa.put("tipoGastoAsociado", DDTipoGastoAsociado.class);
		mapa.put("tipoDocGastoAsociado", DDTipoDocumentoGastoAsociado.class);
		mapa.put("motivoAmpliacionArras", DDMotivoAmpliacionArras.class);
		mapa.put("motivoGestionComercial", DDMotivoGestionComercial.class);
		mapa.put("estadoAdecuacionSareb", DDEstadoAdecucionSareb.class);
		mapa.put("estadoFisicoActivoDND", DDValidaEstadoActivo.class);
		mapa.put("tipoRiesgoOperacion", DDTipoRiesgoOperacion.class);
		mapa.put("identificadorReam", DDIdentificadorReam.class);
		mapa.put("tipoRetencion", DDTipoRetencion.class);
		mapa.put("estadoAdecuacionSareb", DDEstadoAdecucionSareb.class);
		mapa.put("tiposAdmiteMascota", DDSiniSiNoIndiferente.class); 
		mapa.put("estadosExpedienteBc", DDEstadoExpedienteBc.class); 
		mapa.put("tipoResponsable", DDResponsableDocumentacionCliente.class);
		mapa.put("tipoProcedenciaProducto", DDProcedenciaProducto.class);
		mapa.put("categoriaComercializacion", DDCategoriaComercializacion.class);
		mapa.put("tipoListaEmisiones", DDListaEmisiones.class);
		mapa.put("motivoNecesidadArras", DDMotivoNecesidadArras.class);
		mapa.put("tipoResponsable", DDResponsableDocumentacionCliente.class); 
		mapa.put("plantaEdificio", DDPlantaEdificio.class); 
		mapa.put("escaleraEdificio", DDEscaleraEdificio.class); 
		mapa.put("estadoTecnico", DDEstadoTecnicoActivo.class);  
		mapa.put("estadoComercialVenta", DDEstadoComercialVentaCaixa.class);  
		mapa.put("estadoComercialAlquiler", DDEstadoComercialAlquilerCaixa.class);  
		mapa.put("tipoCorrectivoSareb", DDTipoCorrectivoSareb.class); 
		mapa.put("tipoCuotaComunidad", DDTipoCuotaComunidad.class);
		mapa.put("segmentacionSareb", DDSegmentoSareb.class);
		mapa.put("fuenteTestigos", DDFuenteTestigos.class);
		mapa.put("estadoContraste", DDEstadoContrasteListas.class);
		mapa.put("sociedadOrigenCaixa", DDSociedadOrigen.class);  
		mapa.put("bancoOrigenCaixa", DDBancoOrigen.class);
		mapa.put("tributacionPropClienteExentoIva", DDTributacionPropuestaClienteExentoIva.class);
		mapa.put("tributacionPropVenta", DDTributacionPropuestaVenta.class);
		mapa.put("vinculoCaixa", DDVinculoCaixa.class);
		mapa.put("motivoRescisionArras", DDMotivoRescisionArras.class);
		mapa.put("tipoImpositivoItp", DDTipoITP.class);
		mapa.put("tipoImpositivoIva", DDTipoIVA.class);
		mapa.put("impuestoAdquisicion", DDTipoImpuestoCompra.class);
		mapa.put("motivoRescisionArras", DDMotivoRescisionArras.class);		
		mapa.put("disponibleAdministrativo", DDDisponibleAdministracion.class);
		mapa.put("disponibleTecnico", DDDisponibleTecnico.class);
		mapa.put("motivoTecnico", DDMotivoTecnico.class);
		mapa.put("subestadosExpediente", DDSubestadosExpedienteComercial.class);
		mapa.put("clasificacionAlquiler", DDClasificacionContratoAlquiler.class);
		mapa.put("motivoRechazoAntiguoDeudor", DDMotivoRechazoAntiguoDeud.class);
		mapa.put("regimenFianzaCCAA",  DDRegimenFianzaCCAA.class);
		mapa.put("metodoActualizacionRenta",  DDMetodoActualizacionRenta.class);
		mapa.put("resolucionComite",  DDResolucionComite.class);
		mapa.put("motivoAnulacionBc",  DDMotivoAnulacionBC.class);
		mapa.put("tipologiaVentaBc",  DDTipologiaVentaBc.class);
		mapa.put("estadoDeposito",  DDEstadoDeposito.class);		 
		mapa.put("tipoGrupoImpuesto",  DDGrupoImpuesto.class);
		mapa.put("tipoResultadoScoring",  DDResultadoScoring.class);
		mapa.put("tipoResultadoCampo",  DDResultadoCampo.class);
		mapa.put("tipoRatingScoring",  DDRatingScoringServicer.class);
		mapa.put("tipoOfertaAlquiler",  DDTipoOfertaAlquiler.class);
		mapa.put("estadoComunicacionC4C",  DDEstadoComunicacionC4C.class);
		mapa.put("tipoGastoRepercutido",  DDTipoGastoRepercutido.class);
		mapa.put("subtipoOfertaAlquiler",  DDSubtipoOfertaAlquiler.class);
		mapa.put("claseContratoAlquiler", DDClaseContratoAlquiler.class);
		mapa.put("tipoDeDocumento", DDTipoDeDocumento.class);
		mapa.put("metodoValoracion", DDMetodoValoracion.class);
		mapa.put("desarrolloPlanteamiento", DDDesarrolloPlanteamiento.class);
		mapa.put("faseGestion", DDFaseGestion.class);
		mapa.put("productoDesarrollar", DDProductoDesarrollar.class);
		mapa.put("proximidadRespectoNucleoUrbano", DDProximidadRespectoNucleoUrbano.class);
		mapa.put("sistemaGestion", DDSistemaGestion.class);
		mapa.put("productoDesarrollarPrevisto", DDProductoDesarrollar.class);
		mapa.put("tipoDatoUtilizadoInmuebleComparable", DDTipoDatoUtilizadoInmuebleComparable.class);
		mapa.put("tipoFinanciacion", DDTfnTipoFinanciacion.class);
		mapa.put("siNoNosabe", DDSnsSiNoNosabe.class);
		mapa.put("fuenteTestigos", DDFuenteTestigos.class);
		mapa.put("recomendacionRCDC", DDRecomendacionRCDC.class);
		mapa.put("admision", DDAdmision.class);
		mapa.put("clasificacion", DDClasificacion.class);
		mapa.put("disponibilidad", DDDisponibilidad.class);
		mapa.put("estadoConservacionEdificio", DDEstadoConservacionEdificio.class);
		mapa.put("estadoInformeMediador", DDEstadoInformeMediador.class);
		mapa.put("estadoMobiliario", DDEstadoMobiliario.class);
		mapa.put("estadoOcupacional", DDEstadoOcupacional.class);
		mapa.put("exteriorInterior", DDExteriorInterior.class);
		mapa.put("tipoCalefaccion", DDTipoCalefaccion.class);
		mapa.put("tipoPuerta", DDTipoPuerta.class);
		mapa.put("usoActivo", DDUsoActivo.class);
		mapa.put("valoracionUbicacion", DDValoracionUbicacion.class);
		mapa.put("ratingCocina", DDRatingCocina.class);
		mapa.put("tipoClimatizacion", DDTipoClimatizacion.class);
		mapa.put("activoAccesibilidad", DDActivoAccesibilidad.class);
		mapa.put("tasadoraCaixa", DDTasadoraCaixa.class);
		mapa.put("suborigenContrato", DDSuborigenContrato.class);
		mapa.put("comunidadAutonoma", DDComunidadAutonoma.class);
		mapa.put("segmentacionCartera", DDCarteraBc.class);
		mapa.put("motivoExoneracionCee", DDMotivoExoneracionCee.class);
		mapa.put("incidenciaCee", DDIncidenciaCee.class);
		return Collections.unmodifiableMap(mapa);
	}
	

	/**
	 * Método que mapea la relación entre tipo documento y subtipo de trabajo. Devuelve un subtipo trabajo para un codigo documento dado.
	 * @return {@link HashMap}
	 */
    public String getSubtipoTrabajo(String codigoDocumento){
    	
    	Map<String,String> mapa = new HashMap<String,String>();

    	mapa.put(DDTipoDocumentoActivo.CODIGO_NOTA_SIMPLE_ACTUALIZADA, DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_ACTUALIZADA);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_VPO_SOLICITUD_AUTORIZACION, DDSubtipoTrabajo.CODIGO_VPO_AUTORIZACION_VENTA);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_VPO_NOTIFICACION_ADJUDICACION, DDSubtipoTrabajo.CODIGO_VPO_NOTIFICACION_ADJUDICACION);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_VPO_SOLICITUD_IMPORTE, DDSubtipoTrabajo.CODIGO_VPO_SOLICITUD_DEVOLUCION);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_CEE_TRABAJO, DDSubtipoTrabajo.CODIGO_CEE);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_LPO, DDSubtipoTrabajo.CODIGO_LPO);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_CEDULA_HABITABILIDAD, DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_CFO, DDSubtipoTrabajo.CODIGO_CFO);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_BOLETIN_AGUA, DDSubtipoTrabajo.CODIGO_BOLETIN_AGUA);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_BOLETIN_ELECTRICIDAD, DDSubtipoTrabajo.CODIGO_BOLETIN_ELECTRICIDAD);
    	mapa.put(DDTipoDocumentoActivo.CODIGO_BOLETIN_GAS, DDSubtipoTrabajo.CODIGO_BOLETIN_GAS);
    	
		return mapa.get(codigoDocumento);
    }
	
	
    public String getTipoDocumento(String codigoSubtipoTrabajo){
    	
    	Map<String,String> mapa = new HashMap<String,String>();

    	mapa.put(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_ACTUALIZADA, DDTipoDocumentoActivo.CODIGO_NOTA_SIMPLE_ACTUALIZADA);
    	mapa.put(DDSubtipoTrabajo.CODIGO_VPO_AUTORIZACION_VENTA, DDTipoDocumentoActivo.CODIGO_VPO_SOLICITUD_AUTORIZACION);
    	mapa.put(DDSubtipoTrabajo.CODIGO_VPO_NOTIFICACION_ADJUDICACION, DDTipoDocumentoActivo.CODIGO_VPO_NOTIFICACION_ADJUDICACION);
    	mapa.put(DDSubtipoTrabajo.CODIGO_VPO_SOLICITUD_DEVOLUCION, DDTipoDocumentoActivo.CODIGO_VPO_SOLICITUD_IMPORTE);
    	mapa.put(DDSubtipoTrabajo.CODIGO_CEE, DDTipoDocumentoActivo.CODIGO_CEE_TRABAJO);
    	mapa.put(DDSubtipoTrabajo.CODIGO_LPO, DDTipoDocumentoActivo.CODIGO_LPO);
    	mapa.put(DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD, DDTipoDocumentoActivo.CODIGO_CEDULA_HABITABILIDAD);
    	mapa.put(DDSubtipoTrabajo.CODIGO_CFO, DDTipoDocumentoActivo.CODIGO_CFO);
    	mapa.put(DDSubtipoTrabajo.CODIGO_BOLETIN_AGUA, DDTipoDocumentoActivo.CODIGO_BOLETIN_AGUA);
    	mapa.put(DDSubtipoTrabajo.CODIGO_BOLETIN_ELECTRICIDAD, DDTipoDocumentoActivo.CODIGO_BOLETIN_ELECTRICIDAD);
    	mapa.put(DDSubtipoTrabajo.CODIGO_BOLETIN_GAS, DDTipoDocumentoActivo.CODIGO_BOLETIN_GAS);
    	
		return mapa.get(codigoSubtipoTrabajo);
    }

}

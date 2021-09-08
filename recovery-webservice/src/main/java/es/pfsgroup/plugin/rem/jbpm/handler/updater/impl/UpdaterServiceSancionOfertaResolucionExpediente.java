package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.rem.model.dd.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.OfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaTramitesActivo;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;
import es.pfsgroup.plugin.rem.rest.dto.WSDevolBankiaDto;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateOfertaApi;

@Component
public class UpdaterServiceSancionOfertaResolucionExpediente implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private ActivoAdapter activoAdapter;

    @Autowired
    private UvemManagerApi uvemManagerApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private UpdaterStateOfertaApi updaterStateOfertaApi;
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	@Autowired
	private ActivoTramiteDao activoTramiteDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private NotificationOfertaManager notificationOfertaManager;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionExpediente.class);

    private static final String COMBO_PROCEDE = "comboProcede";
    private static final String MOTIVO_ANULACION = "motivoAnulacion";
    public static final String MOTIVO_ANULACION_RESERVA = "comboMotivoAnulacionReserva";
    private static final String CODIGO_T013_RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";
    private static final String CODIGO_T017_RESOLUCION_EXPEDIENTE = "T017_ResolucionExpediente";
    private static final String CODIGO_T017 = "T017";
    private static final String CHECK_ANULAR_Y_CLONAR = "clonarYAnular";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		boolean estadoBcModificado = false;
		ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Boolean mandaCorreo = false;
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			String estadoOriginal = null;
			if (!Checks.esNulo(expediente.getEstado())){
				estadoOriginal = expediente.getEstado().getCodigo();
			}
			String valorComboProcede= null;
			String valorComboMotivoAnularReserva= null;
			String peticionario = null;
			Activo activo = expediente.getOferta().getActivoPrincipal();
			boolean checkFormalizar = false;
			boolean clonarYAnular = false;
			if(!Checks.esNulo(activo)){
				PerimetroActivo pac = genericDao.get(PerimetroActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo", activo));
				checkFormalizar = pac.getAplicaFormalizar() != 0;
			}

			if(!Checks.esNulo(expediente)) {

				boolean tieneReserva = false;
				if(valores != null && !valores.isEmpty()){
					tieneReserva = ofertaApi.checkReserva(valores.get(0).getTareaExterna()) && !Checks.esNulo(expediente.getReserva()) && 
							!Checks.esNulo(expediente.getReserva().getEstadoReserva()) &&
							(DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo()) ||
									DDEstadosReserva.CODIGO_RESUELTA_POSIBLE_REINTEGRO.equals(expediente.getReserva().getEstadoReserva().getCodigo()) || 
									DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION.equals(expediente.getReserva().getEstadoReserva().getCodigo()));
				}

				DDEstadoExpedienteBc estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA));
				expediente.setEstadoBc(estadoExpedienteBc);
				estadoBcModificado = true;

				for(TareaExternaValor valor :  valores) {
					if(CHECK_ANULAR_Y_CLONAR.equals(valor.getNombre())) {
						clonarYAnular = !Checks.esNulo(valor.getValor()) && valor.getValor().equals("on");
					}
				}
				if(clonarYAnular) { // Aqui solo se comprueba que cumple las condiciones para clonar la oferta.  Se clona al final del metodo si el resto de partes han ido correctamente.
					if(tieneReserva) {
						throw new UserException("No es posible clonar el expediente porque el activo se encuentra \"Reservado\"");
					}
					
					List<ActivoOferta> ofertasActivo = activo.getOfertas();
					
					boolean sePuedeClonarExpediente = true;
					
					for (ActivoOferta activoOferta : ofertasActivo) {
						Filter ofertaId = genericDao.createFilter(FilterType.EQUALS, "id", activoOferta.getOferta());
						Oferta ofr = genericDao.get(Oferta.class, ofertaId);
						
						if (ofr.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_ACEPTADA) && !ofr.getId().equals(ofertaAceptada.getId())) {
							sePuedeClonarExpediente = false;
							break;
						}
					}
					
					if (!sePuedeClonarExpediente) {
						throw new UserException("No se puede anular y clonar el expediente porque existen más ofertas en estado \"Tramitada\"");
					}
				}
				
				for(TareaExternaValor valor :  valores) {
					
					if(!DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
							&& COMBO_PROCEDE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							valorComboProcede= valor.getValor();
							
							updaterStateOfertaApi.updaterStateDevolucionReserva(valorComboProcede, tramite, ofertaAceptada, expediente);
					}
					
					if(MOTIVO_ANULACION_RESERVA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						valorComboMotivoAnularReserva= valor.getValor();
					}

					if(MOTIVO_ANULACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
						// Se incluye un motivo de anulacion del expediente, si se indico en la tarea
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
						DDMotivoAnulacionExpediente motivoAnulacion = genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
						expediente.setMotivoAnulacion(motivoAnulacion);
						
						// Guardamos el usuario que realiza la tarea
						TareaExterna tex = valor.getTareaExterna();
						if (!Checks.esNulo(tex)) {
							TareaNotificacion tar = tex.getTareaPadre();
							peticionario = tar.getAuditoria().getUsuarioBorrar();
						}
						expediente.setPeticionarioAnulacion(peticionario);

						if(!tieneReserva && DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo()) &&
								!DDEstadosExpedienteComercial.EN_TRAMITACION.equals(estadoOriginal) && checkFormalizar && 
								!CODIGO_T017.equals(tramite.getTipoTramite().getCodigo())) {
							// Notificar del rechazo de la oferta a Bankia.
							try {
								uvemManagerApi.anularOferta(ofertaAceptada.getNumOferta().toString(), uvemManagerApi.obtenerMotivoAnulacionOfertaPorCodigoMotivoAnulacion(valor.getValor()));
							} catch (Exception e) {
								logger.error("Error al invocar el servicio de anular oferta de Uvem.", e);
								throw new UserException(e.getMessage());
							}
						}

						// TODO: Publicaciones - Implementar en el SP de publicación la siguiente condición:
						// Si la oferta es express, el activo se encuentra en estado publicado oculto y su motivo del estado es "Oferta Express Cajamar".
						//activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
						idActivoActualizarPublicacion.add(activo.getId());

						//Tipo rechazo y motivo rechazo ofertas cajamar
						DDTipoRechazoOferta tipoRechazo = (DDTipoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRechazoOferta.class, DDTipoRechazoOferta.CODIGO_ANULADA);

						DDMotivoRechazoOferta motivoRechazo = (DDMotivoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class, valor.getValor());
						if(motivoRechazo != null) {
							motivoRechazo.setTipoRechazo(tipoRechazo);
						}	
						ofertaAceptada.setMotivoRechazo(motivoRechazo);
						genericDao.save(Oferta.class, ofertaAceptada);
						genericDao.save(ExpedienteComercial.class, expediente);
					}
				}
				
				WSDevolBankiaDto dto = null;
				
				if(DDDevolucionReserva.CODIGO_NO.equals(valorComboProcede)){
					if(tieneReserva && DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo()) && Checks.esNulo(expediente.getCorrecw())
							&& !CODIGO_T017.equals(tramite.getTipoTramite().getCodigo())){
						try {
							 dto = uvemManagerApi.notificarDevolucionReserva(ofertaAceptada.getNumOferta().toString(), uvemManagerApi.obtenerMotivoAnulacionPorCodigoMotivoAnulacionReserva(valorComboMotivoAnularReserva),
									UvemManagerApi.INDICADOR_DEVOLUCION_RESERVA.NO_DEVOLUCION_RESERVA, UvemManagerApi.CODIGO_SERVICIO_MODIFICACION.PROPUESTA_ANULACION_RESERVA_FIRMADA);
						} catch (Exception e) {
							logger.error("Error al invocar el servicio de devolucion de reserva de Uvem.", e);
							throw new UserException(e.getMessage());
						}
					}
				}
				else{
					if(tieneReserva && DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo()) && Checks.esNulo(expediente.getCorrecw())
							&& !CODIGO_T017.equals(tramite.getTipoTramite().getCodigo())){
						try {
							dto = uvemManagerApi.notificarDevolucionReserva(ofertaAceptada.getNumOferta().toString(), uvemManagerApi.obtenerMotivoAnulacionPorCodigoMotivoAnulacionReserva(valorComboMotivoAnularReserva),
									UvemManagerApi.INDICADOR_DEVOLUCION_RESERVA.DEVOLUCION_RESERVA, UvemManagerApi.CODIGO_SERVICIO_MODIFICACION.PROPUESTA_ANULACION_RESERVA_FIRMADA);
						} catch (Exception e) {
							logger.error("Error al invocar el servicio de devolucion de reserva de Uvem.", e);
							throw new UserException(e.getMessage());
						}
					}

				}

				if(tieneReserva && DDCartera.CODIGO_CARTERA_CAJAMAR.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
					&& Checks.esNulo(expediente.getReserva().getFechaContabilizacionReserva())){
					DDEstadosReserva estadoReserva =  genericDao.get(DDEstadosReserva.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_ANULADA));
					expediente.getReserva().setEstadoReserva(estadoReserva);
				}
				
				if(!Checks.esNulo(dto)) {
					try {
						beanUtilNotNull.copyProperties(expediente, dto);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

				if(valores != null && !valores.isEmpty()) {
					if(tieneReserva && !DDDevolucionReserva.CODIGO_NO.equals(valorComboProcede) && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())){
						// Anula el expediente con pendiente de devolución si tiene reserva y es de cartera Liberbank.
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO_PDTE_DEVOLUCION);
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setFechaVenta(null);
						expediente.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

						expediente.setFechaAnulacion(new Date());
					}else if(!tieneReserva){
						// Anula el expediente si NO tiene reserva.
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setFechaVenta(null);
						expediente.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

						expediente.setFechaAnulacion(new Date());
						mandaCorreo=true;
					}
					
					// --- INICIO --- HREOS-5052 ---
					// Si un expediente esta bloqueado por Gencat(lo sabemos mirando si tiene comuncacionesGencat)
					for (ActivoOferta actOfr : ofertaAceptada.getActivosOferta()) {
						ActivoOfertaPk actOfrePk = actOfr.getPrimaryKey();
						Activo act = actOfrePk.getActivo();
						ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(act.getId());
						if (!Checks.esNulo(comunicacionGencat)) {
							DDEstadoComunicacionGencat estadoComunicacion = comunicacionGencat.getEstadoComunicacion();
							if (DDEstadoComunicacionGencat.COD_CREADO.equals(estadoComunicacion.getCodigo()) || (!Checks.esNulo(comunicacionGencat.getSancion()) && DDSancionGencat.COD_EJERCE.equalsIgnoreCase(comunicacionGencat.getSancion().getCodigo())) ) {
								
								Filter filtroActivoId = genericDao.createFilter(FilterType.EQUALS, "idActivo", act.getId());
								Filter filtroCodTipoTramite = genericDao.createFilter(FilterType.EQUALS, "codigoTipoTramite", ActivoTramiteApi.CODIGO_TRAMITE_COMUNICACION_GENCAT);
								Filter filtroFechaFinalizacionIsNull = genericDao.createFilter(FilterType.NULL, "fechaFinalizacion");
								List<VBusquedaTramitesActivo> tramitesActivo = genericDao.getList(VBusquedaTramitesActivo.class, filtroActivoId, filtroCodTipoTramite, filtroFechaFinalizacionIsNull);
								
								if (!Checks.estaVacio(tramitesActivo)) {
									Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
									VBusquedaTramitesActivo vBusquedaTramitesActivo = tramitesActivo.get(0);
									ActivoTramite activoTramite = activoTramiteDao.get(vBusquedaTramitesActivo.getIdTramite());
									activoAdapter.borradoLogicoTareaExternaByIdTramite(activoTramite, usuarioLogado);
									
									//Finaliza el trámite
									activoAdapter.cerrarActivoTramite(usuarioLogado, activoTramite);
								}
								/////COMO SABER A QUE OFERTA PERTENECE EL TRÁMITE
								 OfertaGencat ofertaGencat = genericDao.get(OfertaGencat.class, genericDao.createFilter(FilterType.EQUALS,"oferta", expediente.getOferta()), genericDao.createFilter(FilterType.EQUALS,"comunicacion", comunicacionGencat));
								// finalizamos la tarea
								if((!Checks.esNulo(ofertaGencat) && !Checks.esNulo(ofertaGencat.getIdOfertaAnterior())) || DDEstadoComunicacionGencat.COD_CREADO.equals(estadoComunicacion.getCodigo())) {
									DDEstadoComunicacionGencat estado = new DDEstadoComunicacionGencat();
									if(DDEstadoComunicacionGencat.COD_CREADO.equals(estadoComunicacion.getCodigo())){
										Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoComunicacionGencat.COD_RECHAZADO);
										estado = genericDao.get(DDEstadoComunicacionGencat.class, filtro);
									}else {
										Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoComunicacionGencat.COD_ANULADO);
										estado = genericDao.get(DDEstadoComunicacionGencat.class, filtro);
									}
									comunicacionGencat.setEstadoComunicacion(estado);
									comunicacionGencat.setFechaAnulacion(new Date());
									if(!Checks.esNulo(estado) && (DDEstadoComunicacionGencat.COD_RECHAZADO.equals(estado.getCodigo()) || DDEstadoComunicacionGencat.COD_ANULADO.equals(estado.getCodigo()))) {
										comunicacionGencat.setComunicadoAnulacionAGencat(true);
									}
									
									genericDao.save(ComunicacionGencat.class, comunicacionGencat);
								}
								
							} else if (DDEstadoComunicacionGencat.COD_COMUNICADO.equals(estadoComunicacion.getCodigo())) {
								GestorEntidadDto gestorEntidadDto = new GestorEntidadDto();
								gestorEntidadDto.setIdEntidad(act.getId());
								gestorEntidadDto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
								List<GestorEntidadHistorico> listaGestores = gestorActivoApi.getListGestoresActivosAdicionalesHistoricoData(gestorEntidadDto);
								for (GestorEntidadHistorico gestor : listaGestores) {
									if ((GestorActivoApi.CODIGO_GESTORIA_FORMALIZACION.equals(gestor.getTipoGestor().getCodigo())
											|| GestorActivoApi.CODIGO_GESTOR_FORMALIZACION.equals(gestor.getTipoGestor().getCodigo())
											|| GestorActivoApi.CODIGO_GESTOR_FORMALIZACION_ADMINISTRACION.equals(gestor.getTipoGestor().getCodigo()))
											&& !Checks.esNulo(gestor.getUsuario().getEmail())) {
										
											enviarCorreoAnularOfertaActivoBloqueadoPorGencat(act,gestor.getUsuario().getEmail());
									}
								}
							}
						}
					}
					// --- FIN --- HREOS-5052 ---
					
					if (!tieneReserva) {
						//Finaliza el trámite
						Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", UpdaterStateOfertaApi.CODIGO_TRAMITE_FINALIZADO);
						tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
						genericDao.save(ActivoTramite.class, tramite);

						//Rechaza la oferta y descongela el resto
						ofertaApi.rechazarOferta(ofertaAceptada);
						
						if (mandaCorreo) {
							if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta()) && !Checks.esNulo(activo)) {
								Oferta oferta = expediente.getOferta();
								notificationOfertaManager.sendNotificationDND(oferta, activo);
							}
						}

						try {
							ofertaApi.descongelarOfertas(expediente);
						} catch (Exception e) {
							logger.error("Error descongelando ofertas.", e);
						}
					}
					
					genericDao.save(ExpedienteComercial.class, expediente);
					
					DDEstadoTrabajo estadoTrabajoAnulado = genericDao.get(DDEstadoTrabajo.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoTrabajo.ESTADO_ANULADO));
					Trabajo trabajo = tramite.getTrabajo();
					if(!Checks.esNulo(trabajo)) {
						trabajo.setEstado(estadoTrabajoAnulado);
						genericDao.save(Trabajo.class, trabajo);
					}
				}
				if(clonarYAnular) { // Si no han dado error las comprobaciones anteriores y se quiere clonar, se cloan la oferta.
					boolean esAgrupacion = !Checks.esNulo(expediente.getOferta().getAgrupacion());
					
					if(esAgrupacion) {
						genericAdapter.clonateOferta("" + expediente.getOferta().getId(), true);
					}else {
						genericAdapter.clonateOferta("" + expediente.getOferta().getId(), false);
					}
				}
			}

			ofertaApi.darDebajaAgrSiOfertaEsLoteCrm(ofertaAceptada);
			if(!Checks.esNulo(activo)) {
				activoApi.actualizarOfertasTrabajosVivos(activo);
			}
			ofertaApi.updateStateDispComercialActivosByOferta(ofertaAceptada);
			
			if(ofertaApi.isOfertaDependiente(ofertaAceptada)) {
				OfertasAgrupadasLbk agrupada = genericDao.get(OfertasAgrupadasLbk.class, genericDao.createFilter(FilterType.EQUALS, "ofertaDependiente", ofertaAceptada));
				genericDao.deleteById(OfertasAgrupadasLbk.class, agrupada.getId());
				ofertaApi.calculoComiteLBK(agrupada.getOfertaPrincipal().getId(), null);
			}
			if(estadoBcModificado) {
				ofertaApi.replicateOfertaFlushDto(expediente.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESOLUCION_EXPEDIENTE, CODIGO_T017_RESOLUCION_EXPEDIENTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private Boolean enviarCorreoAnularOfertaActivoBloqueadoPorGencat(Activo activo, String email) {
		boolean resultado = false;

		try {
			ArrayList<String> mailsPara = new ArrayList<String>();
			mailsPara.add(email);
			String asunto = "Anulación de la oferta del activo "+ activo.getNumActivo() +" comunicada a GENCAT";
			String cuerpo = "<p>Se ha anulado la oferta del activo " + activo.getNumActivo() + " comunicada a GENCAT. "
					+ "<br></br>"
					+ "<br></br>"
					+ "Un saludo. </p>";

			genericAdapter.sendMail(mailsPara, new ArrayList<String>(),asunto,cuerpo);
			resultado = true;
		} catch (Exception e) {
			logger.error("No se ha podido notificar la anulación de la oferta del activo.", e);
		}
		
		return resultado;
	}
}

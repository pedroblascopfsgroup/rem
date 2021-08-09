package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.NotificacionApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;

@Component
public class UpdaterServiceSancionOfertaResolucionComite implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private NotificacionApi notificacionApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private GencatApi gencatApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	@Autowired
	private  GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	@Autowired
	private BoardingComunicacionApi boardingComunicacionApi;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionComite.class);
	 
	private static final String COMBO_RESOLUCION = "comboResolucion";
	private static final String FECHA_RESPUESTA = "fechaRespuesta";
	private static final String IMPORTE_CONTRAOFERTA = "numImporteContra";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_T013_RESOLUCION_COMITE = "T013_ResolucionComite";
	private static final String COMITE_SANCIONADOR = "comiteSancionador";
 	private static final Integer RESERVA_SI = 1;


	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		GestorEntidadDto ge = new GestorEntidadDto();
		
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			Activo activo = ofertaAceptada.getActivoPrincipal();
			if (!Checks.esNulo(expediente)) {
						
				for (TareaExternaValor valor : valores) {
	
					if (FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						try {
							expediente.setFechaSancion(ft.parse(valor.getValor()));
						} catch (ParseException e) {
							logger.error(e.getMessage(),e);
						}
	
					}
					
					if (COMITE_SANCIONADOR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()) 
							&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
							expediente.setComiteSancion(expedienteComercialApi.comiteSancionadorByCodigo(valor.getValor()));
					}
					
					if (COMBO_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
						if (DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
							List<ActivoOferta> listActivosOferta = expediente.getOferta().getActivosOferta();
							for (ActivoOferta activoOferta : listActivosOferta) {
								ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(activoOferta.getPrimaryKey().getActivo().getId());
								Oferta oferta = expediente.getOferta();	
								OfertaGencat ofertaGencat = null;
								Date fSancion= expediente.getFechaSancion();
								if(Checks.esNulo(expediente.getReserva()) && activoApi.isAfectoGencat(activoOferta.getPrimaryKey().getActivo())){
									
									if (!Checks.esNulo(comunicacionGencat)) {
										ofertaGencat = genericDao.get(OfertaGencat.class,genericDao.createFilter(FilterType.EQUALS,"oferta", oferta), genericDao.createFilter(FilterType.EQUALS,"comunicacion", comunicacionGencat));
									}
									if(!Checks.esNulo(ofertaGencat)) {
											if(Checks.esNulo(ofertaGencat.getIdOfertaAnterior()) && !ofertaGencat.getAuditoria().isBorrado()) {
												gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
											}
									}else{	
										gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());									
									}	
									
								}
								
								if(oferta!=null && fSancion!=null) {
									ofertaApi.comprobarFechasParaLanzarComisionamiento(oferta, fSancion);
								}
							}
							
							
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
							
							if(expediente.getCondicionante().getSolicitaReserva()!=null && RESERVA_SI.equals(expediente.getCondicionante().getSolicitaReserva()) && ge!=null
									&& gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GBOAR") == null) {															
								EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
										.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GBOAR");
								
								ge.setIdEntidad(expediente.getId());
								ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
								ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gruboarding")).getId());	
								ge.setIdTipoGestor(tipoGestorComercial.getId());
								gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);																	
								
							}
							
							// Una vez aprobado el expediente, se congelan el resto de ofertas que no
							// estén rechazadas (aceptadas y pendientes)
							List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
							for (Oferta oferta : listaOfertas) {
								if (!oferta.getId().equals(ofertaAceptada.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())) {
									ofertaApi.congelarOferta(oferta);
								}
							}
							
							// Se comprueba si cada activo tiene KO de admisión o de gestión
							// y se envía una notificación
							notificacionApi.enviarNotificacionPorActivosAdmisionGestion(expediente);
														
						} else {
							if (DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
								// Deniega el expediente
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADO);
	
								//finalizamos las posibles tareas de validación pendientes
								expedienteComercialApi.finalizarTareaValidacionClientes(expediente);
								// Finaliza el trámite
								Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
								tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
								genericDao.save(ActivoTramite.class, tramite);
	
								// Rechaza la oferta y descongela el resto
								ofertaApi.rechazarOferta(ofertaAceptada);
								ofertaApi.finalizarOferta(ofertaAceptada);
								
								// Tipo rechazo y motivo rechazo ofertas cajamar
								DDTipoRechazoOferta tipoRechazo = (DDTipoRechazoOferta) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDTipoRechazoOferta.class,
												DDTipoRechazoOferta.CODIGO_DENEGADA);
								
								DDMotivoRechazoOferta motivoRechazo = (DDMotivoRechazoOferta) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class,
												DDMotivoRechazoOferta.CODIGO_DECISION_COMITE);
								
								motivoRechazo.setTipoRechazo(tipoRechazo);
								ofertaAceptada.setMotivoRechazo(motivoRechazo);
								genericDao.save(Oferta.class, ofertaAceptada);
								
								
								try {
									ofertaApi.descongelarOfertas(expediente);
								} catch (Exception e) {
									logger.error("Error descongelando ofertas.", e);
								}
	
							} else if (DDResolucionComite.CODIGO_CONTRAOFERTA.equals(valor.getValor())) {
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.CONTRAOFERTADO);
							}
						}
	
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

	
					}
					if (IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						String doubleValue = valor.getValor();
						doubleValue = doubleValue.replace(',', '.');
						ofertaAceptada.setImporteContraOferta(Double.valueOf(doubleValue));
						genericDao.save(Oferta.class, ofertaAceptada);
	
						expedienteComercialApi.updateParticipacionActivosOferta(ofertaAceptada);
						expedienteComercialApi.actualizarImporteReservaPorExpediente(expediente);
						
						// Actualizar honorarios para el nuevo importe de contraoferta.
						expedienteComercialApi.actualizarHonorariosPorExpediente(expediente.getId());
						
					}
				}
				genericDao.save(ExpedienteComercial.class, expediente);
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_RESOLUCION_COMITE };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}

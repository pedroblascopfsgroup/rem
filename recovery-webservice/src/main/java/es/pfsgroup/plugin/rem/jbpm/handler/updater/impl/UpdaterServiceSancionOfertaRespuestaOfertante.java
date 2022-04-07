package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
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
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.NotificacionApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankiaDto;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDRespuestaOfertante;
import es.pfsgroup.plugin.rem.model.dd.DDTipoResolucion;
import es.pfsgroup.plugin.rem.resolucionComite.dao.ResolucionComiteDao;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

@Component
public class UpdaterServiceSancionOfertaRespuestaOfertante implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private TrabajoApi trabajoApi;

    @Autowired
	private NotificacionApi notificacionApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;

    @Autowired
    private UvemManagerApi uvemManagerApi;
    
	@Autowired
	private ResolucionComiteApi resolucionComiteApi;
    
	@Autowired
	private ResolucionComiteDao resolucionComiteDao;
	
	@Autowired
	private GencatApi gencatApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaRespuestaOfertante.class);

    private static final String COMBO_RESPUESTA = "comboRespuesta";
    private static final String IMPORTE_OFERTANTE = "importeOfertante";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
   	private static final String CODIGO_T013_RESPUESTA_OFERTANTE = "T013_RespuestaOfertante";
   	private static final String MOTIVO_COMPRADOR_NO_INTERES = "100"; //EL COMPRADOR NO ESTÁ INTERESADO EN LA OPERACIÓN
   	private static final Integer RESERVA_SI = 1;

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			Activo activo = ofertaAceptada.getActivoPrincipal();

			if(!Checks.esNulo(expediente)) {

				for(TareaExternaValor valor :  valores) {

					if(COMBO_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						Filter filtro;
						if(DDRespuestaOfertante.CODIGO_ACEPTA.equals(valor.getValor()) || DDRespuestaOfertante.CODIGO_CONTRAOFERTA.equals(valor.getValor())){
							//Si el activo es de Bankia, se ratifica el comité
							if(!trabajoApi.checkBankia(expediente.getTrabajo())){
								List<ActivoOferta> listActivosOferta = expediente.getOferta().getActivosOferta();
								for (ActivoOferta activoOferta : listActivosOferta) {
									ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(activoOferta.getPrimaryKey().getActivo().getId());
									if(Checks.esNulo(expediente.getReserva()) && (DDRespuestaOfertante.CODIGO_ACEPTA.equals(valor.getValor()) && !DDCartera.CODIGO_CARTERA_BANKIA.equals(activoOferta.getPrimaryKey().getActivo().getCartera().getCodigo())) 
											&& activoApi.isAfectoGencat(activoOferta.getPrimaryKey().getActivo())){
										Oferta oferta = expediente.getOferta();	
										OfertaGencat ofertaGencat = null;
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
								}
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
								DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
								
								expediente.setEstado(estado);
								recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

								if(DDEstadosExpedienteComercial.APROBADO.equals(estado.getCodigo())) {
									if(expediente.getCondicionante().getSolicitaReserva()!=null && RESERVA_SI.equals(expediente.getCondicionante().getSolicitaReserva())) {															
										EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
												.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GBOAR");

										if(gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GBOAR") == null) {
											GestorEntidadDto ge = new GestorEntidadDto();
											ge.setIdEntidad(expediente.getId());
											ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
											ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gruboarding")).getId());								
											ge.setIdTipoGestor(tipoGestorComercial.getId());
											gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);																	
										}
									}
									
									expedienteComercialApi.calculoFormalizacionCajamar(ofertaAceptada);
									
									if(ofertaAceptada.getCheckForzadoCajamar() != null) {
										if(ofertaAceptada.getCheckForzadoCajamar()) {
											GestorEntidadDto ge = new GestorEntidadDto();
											EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
													.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GIAFORM");
											
											ge.setIdEntidad(expediente.getId());
											ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
											ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gestformcajamar")).getId());								
											ge.setIdTipoGestor(tipoGestorComercial.getId());
											gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);
										}
									}else {
										if(ofertaAceptada.getCheckFormCajamar()) {
											GestorEntidadDto ge = new GestorEntidadDto();
											EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
													.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GIAFORM");
											
											ge.setIdEntidad(expediente.getId());
											ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
											ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gestformcajamar")).getId());								
											ge.setIdTipoGestor(tipoGestorComercial.getId());
											gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);
										}
									}
									
								}

								//Una vez aprobado el expediente, se congelan el resto de ofertas que no estén rechazadas (aceptadas y pendientes)
								List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
								for(Oferta oferta : listaOfertas){
									if(!oferta.getId().equals(ofertaAceptada.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())){
										ofertaApi.congelarOferta(oferta);
									}
								}
							}

							// Se comprueba si cada activo tiene KO de admisión o de gestión
							// y se envía una notificación
							notificacionApi.enviarNotificacionPorActivosAdmisionGestion(expediente);
														
						}else {
							//Resuelve el expediente
							if(!DDCartera.CODIGO_CARTERA_GIANTS.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
							} else{
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.CONTRAOFERTA_DENEGADA);
							}
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setFechaVenta(null);
							expediente.setEstado(estado);
							recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);


							//Finaliza el trámite
							Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
							tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
							genericDao.save(ActivoTramite.class, tramite);

							//Rechaza la oferta y descongela el resto
							ofertaApi.rechazarOferta(ofertaAceptada);
							ofertaApi.finalizarOferta(ofertaAceptada);
							try {
								ofertaApi.descongelarOfertas(expediente);
							} catch (Exception e) {
								logger.error("Error descongelando ofertas.", e);
							}

							/*if(DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
								// Notificar del rechazo de la oferta a Bankia.
								try {
									uvemManagerApi.anularOferta(ofertaAceptada.getNumOferta().toString(), UvemManagerApi.MOTIVO_ANULACION_OFERTA.COMPRADOR_NO_INTERESADO_OPERACION);
								} catch (Exception e) {
									logger.error("Error al invocar el servicio de anular oferta de Uvem.", e);
									throw new UserException(e.getMessage());
								}
							}*/

							// Motivo anulacion: EL COMPRADOR NO ESTÁ INTERESADO EN LA OPERACIÓN
							DDMotivoAnulacionExpediente motivoAnulacionExpediente = 
									(DDMotivoAnulacionExpediente) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoAnulacionExpediente.class, MOTIVO_COMPRADOR_NO_INTERES);
							expediente.setMotivoAnulacion(motivoAnulacionExpediente);
	
						}
	
					}if (IMPORTE_OFERTANTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {						
						ofertaAceptada.setImporteContraOferta(Double.valueOf(valor.getValor().replace(',', '.')));
						genericDao.save(Oferta.class, ofertaAceptada);
	
						// Actualizamos la participación de los activos en la oferta;
						expedienteComercialApi.updateParticipacionActivosOferta(ofertaAceptada);
						expedienteComercialApi.actualizarImporteReservaPorExpediente(expediente);
						
						// Actualizar honorarios para el nuevo importe de contraoferta.
						expedienteComercialApi.actualizarHonorariosPorExpediente(expediente.getId());
						
					}					
				}
				ResolucionComiteBankiaDto resolDto = null;
				List<ResolucionComiteBankia> listaResol = null;
				ResolucionComiteDto dto = new ResolucionComiteDto();
				dto.setOfertaHRE(ofertaAceptada.getNumOferta());
				dto.setCodigoTipoResolucion(DDTipoResolucion.CODIGO_TIPO_RESOLUCION);						
				dto.setImporteContraoferta(ofertaAceptada.getImporteContraOferta());
				dto.setCodigoComite(expediente.getComiteSancion().getCodigo());
				dto.setCodigoResolucion(DDEstadoResolucion.CODIGO_ERE_CONTRAOFERTA);
				try {
					resolDto = resolucionComiteApi.getResolucionComiteBankiaDtoFromResolucionComiteDto(dto);
					if(Checks.esNulo(resolDto)){
						throw new Exception("Se ha producido un error en la búsqueda de resoluciones.");
					}
					
					//Obtenemos la lista de resoluciones por expediente y tipo si existe
					listaResol = resolucionComiteApi.getResolucionesComiteByExpedienteTipoRes(resolDto);
					if(!Checks.esNulo(listaResol) && listaResol.size()>0){
						for(int i = 0; i< listaResol.size(); i++){					
							resolucionComiteDao.delete(listaResol.get(i));								
						}
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				genericDao.save(ExpedienteComercial.class, expediente);
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESPUESTA_OFERTANTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
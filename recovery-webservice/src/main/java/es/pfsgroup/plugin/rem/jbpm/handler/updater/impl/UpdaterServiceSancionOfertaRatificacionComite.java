package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
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
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorActivoHistorico;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.resolucionComite.dao.ResolucionComiteDao;

@Component
public class UpdaterServiceSancionOfertaRatificacionComite implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private UvemManagerApi uvemManagerApi;

    @Autowired
	private NotificacionApi notificacionApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;
    
	@Autowired
	private ResolucionComiteApi resolucionComiteApi;
    
	@Autowired
	private ResolucionComiteDao resolucionComiteDao;
	
	@Autowired
	private GencatApi gencatApi;
	
	@Autowired
	private ActivoApi activoApi;
		
	@Autowired
	private  GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaRatificacionComite.class);

    private static final String COMBO_RATIFICACION = "comboRatificacion";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String IMPORTE_CONTRAOFERTA = "importeContraoferta";
   	private static final String CODIGO_T013_RATIFICACION_COMITE = "T013_RatificacionComite";
   	private static final String MOTIVO_NO_RATIFICADA = "604"; //NO RATIFICADA
   	private static final Integer RESERVA_SI = 1;

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		GestorEntidadDto ge = new GestorEntidadDto();		
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			Activo activo = ofertaAceptada.getActivoPrincipal();

			if(!Checks.esNulo(expediente)) {
				
				for(TareaExternaValor valor :  valores) {
					
					if(COMBO_RATIFICACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						Filter filtro;
						if(DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
							List<ActivoOferta> listActivosOferta = expediente.getOferta().getActivosOferta();
							for (ActivoOferta activoOferta : listActivosOferta) {
								ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(activoOferta.getPrimaryKey().getActivo().getId());
								if(Checks.esNulo(expediente.getReserva()) && activoApi.isAfectoGencat(activoOferta.getPrimaryKey().getActivo())){
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
								if(expediente.getCondicionante().getSolicitaReserva()!=null && RESERVA_SI.equals(expediente.getCondicionante().getSolicitaReserva()) && ge!=null) {															
									EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
											.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GBOAR");
									
									if(gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GBOAR") == null) {
										ge.setIdEntidad(expediente.getId());
										ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
										ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gruboarding")).getId());								
										ge.setIdTipoGestor(tipoGestorComercial.getId());
										gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);																	
									}
								}
							}
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);
							ofertaApi.actualizarOfertaBoarding(expediente.getOferta());

							
							
							//Una vez aprobado el expediente, se congelan el resto de ofertas que no estén rechazadas (aceptadas y pendientes)
							List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
							for(Oferta oferta : listaOfertas){
								if(!oferta.getId().equals(ofertaAceptada.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())){
									ofertaApi.congelarOferta(oferta);
								}
							}
							// Se comprueba si cada activo tiene KO de admisión o de gestión
							// y se envía una notificación
							notificacionApi.enviarNotificacionPorActivosAdmisionGestion(expediente);
						} else if(DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
							//Resuelve el expediente
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

							expediente.setFechaVenta(null);

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

							// Motivo anulacion: NO RATIFICADA
							DDMotivoAnulacionExpediente motivoAnulacionExpediente = 
									(DDMotivoAnulacionExpediente) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoAnulacionExpediente.class, MOTIVO_NO_RATIFICADA);
							expediente.setMotivoAnulacion(motivoAnulacionExpediente);
						}
					}
					if (IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						ofertaAceptada.setImporteContraOferta(Double.valueOf(valor.getValor().replace(',', '.')));
						genericDao.save(Oferta.class, ofertaAceptada);
	
						// Actualizamos la participación de los activos en la oferta;
						expedienteComercialApi.updateParticipacionActivosOferta(ofertaAceptada);
						expedienteComercialApi.actualizarImporteReservaPorExpediente(expediente);
						
						// Actualizar honorarios para el nuevo importe de contraoferta.
						expedienteComercialApi.actualizarHonorariosPorExpediente(expediente.getId());
						
//						ResolucionComiteBankiaDto resolDto = null;
//						List<ResolucionComiteBankia> listaResol = null;
//						ResolucionComiteDto dto = new ResolucionComiteDto();
//						dto.setOfertaHRE(ofertaAceptada.getNumOferta());
//						dto.setCodigoTipoResolucion(DDTipoResolucion.CODIGO_TIPO_RESOLUCION);						
//						dto.setImporteContraoferta(ofertaAceptada.getImporteContraOferta());
//						dto.setCodigoComite(expediente.getComiteSancion().getCodigo());
//						dto.setCodigoResolucion(DDEstadoResolucion.CODIGO_ERE_CONTRAOFERTA);
//						try {
//							resolDto = resolucionComiteApi.getResolucionComiteBankiaDtoFromResolucionComiteDto(dto);
//							if(Checks.esNulo(resolDto)){
//								throw new Exception("Se ha producido un error en la búsqueda de resoluciones.");
//							}
//							
//							//Obtenemos la lista de resoluciones por expediente y tipo si existe
//							listaResol = resolucionComiteApi.getResolucionesComiteByExpedienteTipoRes(resolDto);
//							if(!Checks.esNulo(listaResol) && listaResol.size()>0){
//								for(int i = 0; i< listaResol.size(); i++){					
//									resolucionComiteDao.delete(listaResol.get(i));
//								}
//							}
//							
//						} catch (Exception e) {
//							// TODO Auto-generated catch block
//							e.printStackTrace();
//						}
					}	
				}
				genericDao.save(ExpedienteComercial.class, expediente);
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RATIFICACION_COMITE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}

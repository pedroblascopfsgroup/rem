package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

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
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;

@Component
public class UpdaterServiceSancionOfertaRatificacionComite implements UpdaterService {

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
	private  GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaRatificacionComite.class);

    private static final String COMBO_RATIFICACION = "comboRatificacion";
	private static final String IMPORTE_CONTRAOFERTA = "importeContraoferta";
   	private static final String CODIGO_T013_RATIFICACION_COMITE = "T013_RatificacionComite";
   	private static final String MOTIVO_NO_RATIFICADA = "604"; //NO RATIFICADA
   	private static final Integer RESERVA_SI = 1;

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		GestorEntidadDto ge = new GestorEntidadDto();	
		boolean rechazar = false;
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

							ofertaApi.congelarOfertasAndReplicate(activo, ofertaAceptada);
							
							expedienteComercialApi.calculoFormalizacionCajamar(ofertaAceptada);

							if((ofertaAceptada.getCheckForzadoCajamar() != null && ofertaAceptada.getCheckForzadoCajamar()
									|| (ofertaAceptada.getCheckForzadoCajamar() == null && ofertaAceptada.getCheckFormCajamar() != null && ofertaAceptada.getCheckFormCajamar()))) {
								EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
										.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GIAFORM");

								ge.setIdEntidad(expediente.getId());
								ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
								ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gestformcajamar")).getId());
								ge.setIdTipoGestor(tipoGestorComercial.getId());
								gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);
							}
							
							
							// Se comprueba si cada activo tiene KO de admisión o de gestión
							// y se envía una notificación
							notificacionApi.enviarNotificacionPorActivosAdmisionGestion(expediente);
						} else if(DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
							rechazar = true;

							expediente.setFechaVenta(null);

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
					}	
				}
				genericDao.save(ExpedienteComercial.class, expediente);
				
				if (rechazar) {
					ofertaApi.inicioRechazoDeOfertaSinLlamadaBC(ofertaAceptada, DDEstadosExpedienteComercial.ANULADO);
				}
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

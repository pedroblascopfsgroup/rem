package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaSoloRechazo;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;

@Component
public class UpdaterServiceSancionOfertaResolucionProManzana implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private NotificatorServiceSancionOfertaSoloRechazo notificatorRechazo;
	
	@Autowired
	private GencatApi gencatApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionProManzana.class);

	private static final String CODIGO_T017_RESOLUCION_PRO_MANZANA = "T017_ResolucionPROManzana";
	private static final String COMBO_RESPUESTA = "comboRespuesta";
	private static final String FECHA_RESPUESTA = "fechaRespuesta";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_T017_PBCRESERVA = "T017_PBCReserva";
	private static final String CODIGO_T017_PBCVENTA = "T017_PBCVenta";
	private static final String CODIGO_T017_INSTRUCCIONES_RESERVA = "T017_InstruccionesReserva";
	private static final String CODIGO_T017_OBTENCION_CONTRATO_RESERVA = "T017_ObtencionContratoReserva";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {	
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if (ofertaAceptada != null) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			Filter filtro = null;
			Boolean solicitaReserva = ofertaApi.checkReserva(ofertaAceptada);
			Boolean obtencionReservaFinalizada = false;
			
			if (expediente != null) {
				if(solicitaReserva) {
					if(ofertaApi.tieneTarea(tramite, CODIGO_T017_PBCRESERVA) == 0 
							&& ofertaApi.tieneTarea(tramite, CODIGO_T017_INSTRUCCIONES_RESERVA) == 0 
							&& ofertaApi.tieneTarea(tramite, CODIGO_T017_OBTENCION_CONTRATO_RESERVA) == 0
							&& ofertaApi.tieneTarea(tramite, CODIGO_T017_PBCVENTA) == 0) {					// este if controla si el tramite es de los migrados de divarian sin parte PBC
						obtencionReservaFinalizada = true;
					}else {				
						obtencionReservaFinalizada = ofertaApi.tieneTarea(tramite, CODIGO_T017_OBTENCION_CONTRATO_RESERVA) == 2;
					}
				}
				for (TareaExternaValor valor : valores) {			
					if (COMBO_RESPUESTA.equals(valor.getNombre()) && valor.getValor() != null) {
						if (DDApruebaDeniega.CODIGO_APRUEBA.equals(valor.getValor())) {
							if (obtencionReservaFinalizada) {
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESERVADO);
							} else {
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
							}
						} else if (DDApruebaDeniega.CODIGO_DENIEGA.equals(valor.getValor())){
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADO_PRO_MANZANA);
							if(((expediente.getReserva() != null)
									&& expediente.getReserva().getEstadoReserva() != null
									&& !DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo()))
									|| expediente.getReserva() == null
									|| !solicitaReserva) {
								expediente.setFechaVenta(null);
								expediente.setFechaAnulacion(new Date());
								// Finaliza el trámite
								Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
								tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
								genericDao.save(ActivoTramite.class, tramite);
								// Rechaza la oferta y descongela el resto
								ofertaApi.rechazarOferta(ofertaAceptada);
								try {
									ofertaApi.descongelarOfertas(expediente);
									ofertaApi.finalizarOferta(ofertaAceptada);
								} catch (Exception e) {
									logger.error("Error descongelando ofertas.", e);
								}
								notificatorRechazo.notificatorFinTareaConValores(tramite, valores);
							}
						}
					}
					if (FECHA_RESPUESTA.equals(valor.getNombre()) && valor.getValor() != null) {
						try {
							ofertaAceptada.setFechaRespuesta(ft.parse(valor.getValor()));
							ofertaAceptada.setFechaAprobacionProManzana(ft.parse(valor.getValor()));
						} catch (ParseException e) {
							logger.error("Error al formaterar una fecha en la tarea Resolución PRO Manzana", e);
							throw new UserException(e.getMessage());
						}
					}
				}
				
				List<ActivoOferta> listActivosOferta = ofertaAceptada.getActivosOferta();				
				
				//Revisamos si es afecto a GENCAT para lanzar tramite
				if(!solicitaReserva || (solicitaReserva && obtencionReservaFinalizada)) {
					for (ActivoOferta activoOferta : listActivosOferta) {
						ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(activoOferta.getPrimaryKey().getActivo().getId());
						if(activoApi.isAfectoGencat(activoOferta.getPrimaryKey().getActivo())){
							Oferta oferta = expediente.getOferta();	
							OfertaGencat ofertaGencat = null;
							if (comunicacionGencat != null) {
								ofertaGencat = genericDao.get(OfertaGencat.class,genericDao.createFilter(FilterType.EQUALS,"oferta", oferta), genericDao.createFilter(FilterType.EQUALS,"comunicacion", comunicacionGencat));
							}
							if(ofertaGencat != null) {
									if(ofertaGencat.getIdOfertaAnterior() == null && !ofertaGencat.getAuditoria().isBorrado()) {
										gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
									}
							}else{	
								gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
							}					
						}
					}
				}
				if(filtro != null) {				
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expediente.setEstado(estado);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

				}
				genericDao.update(ExpedienteComercial.class, expediente);
				genericDao.update(Oferta.class, ofertaAceptada);
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[] {CODIGO_T017_RESOLUCION_PRO_MANZANA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}

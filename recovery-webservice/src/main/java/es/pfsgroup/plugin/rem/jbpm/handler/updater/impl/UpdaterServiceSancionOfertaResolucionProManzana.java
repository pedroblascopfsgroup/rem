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
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaSoloRechazo;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
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
	
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionProManzana.class);

	private static final String CODIGO_T017_RESOLUCION_PRO_MANZANA = "T017_ResolucionPROManzana";
	private static final String COMBO_RESPUESTA = "comboRespuesta";
	private static final String FECHA_RESPUESTA = "fechaRespuesta";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {	
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi
					.expedienteComercialPorOferta(ofertaAceptada.getId());
			Filter filtro = null;
			if (!Checks.esNulo(expediente)) {
				for (TareaExternaValor valor : valores) {			
					if (COMBO_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (DDApruebaDeniega.CODIGO_APRUEBA.equals(valor.getValor())) {
							if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaReserva()) && expediente.getCondicionante().getSolicitaReserva() == 1) {
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESERVADO);
							} else {
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
							}
						} else if (DDApruebaDeniega.CODIGO_DENIEGA.equals(valor.getValor())){
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADO_PRO_MANZANA);
							if(!DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo())) {
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
								} catch (Exception e) {
									logger.error("Error descongelando ofertas.", e);
								}
								notificatorRechazo.notificatorFinTareaConValores(tramite, valores);
							}
						}
					}
					if (FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						try {
							ofertaAceptada.setFechaRespuesta(ft.parse(valor.getValor()));
							ofertaAceptada.setFechaAprobacionProManzana(ft.parse(valor.getValor()));
						} catch (ParseException e) {
							logger.error("Error al formaterar una fecha en la tarea Resolución PRO Manzana", e);
							throw new UserException(e.getMessage());
						}
					}
				}
				DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				expediente.setEstado(estado);
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

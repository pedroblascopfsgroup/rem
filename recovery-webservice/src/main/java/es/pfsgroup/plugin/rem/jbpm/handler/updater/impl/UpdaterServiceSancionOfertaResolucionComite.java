package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.NotificacionApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankiaDto;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoResolucion;
import es.pfsgroup.plugin.rem.resolucionComite.dao.ResolucionComiteDao;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

@Component
public class UpdaterServiceSancionOfertaResolucionComite implements UpdaterService {

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
	private GencatApi gencatApi;


	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionComite.class);
	 
	private static final String COMBO_RESOLUCION = "comboResolucion";
	private static final String FECHA_RESPUESTA = "fechaRespuesta";
	private static final String IMPORTE_CONTRAOFERTA = "numImporteContra";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_T013_RESOLUCION_COMITE = "T013_ResolucionComite";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) {
						
				for (TareaExternaValor valor : valores) {
	
					if (FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						try {
							expediente.setFechaSancion(ft.parse(valor.getValor()));
						} catch (ParseException e) {
							e.printStackTrace();
						}
	
					}
					if (COMBO_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
						if (DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
	
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
							
							//TODO COMPROBACION PRE BLOQUEO GENCAT 

							gencatApi.bloqueoExpedienteGENCAT(expediente, tramite);
														
						} else {
							if (DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
								// Deniega el expediente
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADO);
	
								// Finaliza el trámite
								Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
								tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
								genericDao.save(ActivoTramite.class, tramite);
	
								// Rechaza la oferta y descongela el resto
								ofertaApi.rechazarOferta(ofertaAceptada);
								
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
	
							} else if (DDResolucionComite.CODIGO_CONTRAOFERTA.equals(valor.getValor())) 
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.CONTRAOFERTADO);
						}
	
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
	
					}
					if (IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						String doubleValue = valor.getValor();
						doubleValue = doubleValue.replace(',', '.');
						ofertaAceptada.setImporteContraOferta(Double.valueOf(doubleValue));
						genericDao.save(Oferta.class, ofertaAceptada);
	
						// Actualizar honorarios para el nuevo importe de contraoferta.
						expedienteComercialApi.actualizarHonorariosPorExpediente(expediente.getId());
	
						// Actualizamos la participación de los activos en la oferta;
						expedienteComercialApi.updateParticipacionActivosOferta(ofertaAceptada);
						expedienteComercialApi.actualizarImporteReservaPorExpediente(expediente);
						
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

package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaRespuestaOfertantePM implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaRespuestaOfertantePM.class);
	 
	private static final String CODIGO_T017_RESPUESTA_OFERTANTE_PM = "T017_RespuestaOfertantePM";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String COMBO_RESOLUCION = "comboRespuesta";
	private static final String FECHA_RESPUESTA = "fechaRespuesta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			
			if(!Checks.esNulo(expediente)) {
				for(TareaExternaValor valor : valores) {
					
					if (FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						try {
							ofertaAceptada.setFechaRespuestaOfertantePM(ft.parse(valor.getValor()));
						} catch (ParseException e) {
							logger.error("Error seteando la fecha de respuesta PM", e);
						}
	
					}
					
					if (COMBO_RESOLUCION.equals(valor.getNombre()) 
							&& !Checks.esNulo(valor.getValor())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_SANCION_CES);
						
						/*if (DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADA_OFERTANTE_PM);

							expediente.setFechaVenta(null);
							expediente.setFechaAnulacion(new Date());

							Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
							tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
							genericDao.save(ActivoTramite.class, tramite);

							ofertaApi.rechazarOferta(ofertaAceptada);
							
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

						}*/
						
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

					}	
				}
				genericDao.save(Oferta.class, ofertaAceptada);
				genericDao.save(ExpedienteComercial.class, expediente);
			}
		}
		
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_RESPUESTA_OFERTANTE_PM };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}

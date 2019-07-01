package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import java.text.SimpleDateFormat;
import java.util.Date;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.NotificacionApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaRespuestaOfertante implements UpdaterService {
	@Autowired
 	private GenericABMDao genericDao;
 
 	@Autowired
 	private OfertaApi ofertaApi;
 	
 	@Autowired
 	private NotificacionApi notificacionApi;
 
 	@Autowired
 	private ExpedienteComercialApi expedienteComercialApi;
 	
 	@Autowired
 	private ActivoApi activoApi;
 	
 
 	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaRespuestaOfertanteCES.class);
 
 	private static final String CODIGO_T017_RESPUESTA_OFERTANTE_CES = "T017_RespuestaOfertanteCES";
 	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
 	private static final String COMBO_RESPUESTA = "comboRespuesta";
 	private static final String FECHA_RESPUESTA = "fechaRespuesta";
 
 	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
 
 	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {	
 	try {
 		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
 		ExpedienteComercial expediente = expedienteComercialApi
 				.expedienteComercialPorOferta(ofertaAceptada.getId());
 		for (TareaExternaValor valor : valores) {			
 			if (FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
 				SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");
 				ofertaAceptada.setFechaRespuestaCES(formatter.parse(valor.getValor()));
 				genericDao.save(Oferta.class, ofertaAceptada);
 			}else if (COMBO_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
 				if (DDApruebaDeniega.CODIGO_APRUEBA.equals(valor.getValor())) {
 					Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadosExpedienteComercial.APROBADO_CES_PTE_PRO_MANZANA);
 					DDEstadosExpedienteComercial aprobado = genericDao.get(DDEstadosExpedienteComercial.class, f1);
 					expediente.setEstado(aprobado);
 				}else if (DDApruebaDeniega.CODIGO_DENIEGA.equals(valor.getValor())) {
 					ofertaApi.rechazarOferta(ofertaAceptada);
 					Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADA_OFERTA_CES);
 					DDEstadosExpedienteComercial denegado = genericDao.get(DDEstadosExpedienteComercial.class, f1);
 					expediente.setEstado(denegado);
 					Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
 					tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
 					genericDao.save(ActivoTramite.class, tramite);
 				}
 			}
 		}
 		genericDao.save(Oferta.class, ofertaAceptada);
 		genericDao.save(ExpedienteComercial.class, expediente);
 	}catch(ParseException e) {
 		 e.printStackTrace();
 	}
 		}
 		
 	public String[] getCodigoTarea() {
 		return new String[] { CODIGO_T017_RESPUESTA_OFERTANTE_CES };
 	}
 
 	public String[] getKeys() {
 		return this.getCodigoTarea();
 	}
 
 

}

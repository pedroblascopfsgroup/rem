package es.pfsgroup.plugin.rem.thread;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class AvanzaTareaOfertasBulkAN implements Runnable {

	@Autowired
	private RestApi restApi;
	
	@Autowired
	private HibernateUtils hibernateUtils;
	 
	@Autowired
	private AgendaAdapter agendaAdapter;
	
	
	@Autowired
	private OfertaDao ofertaDao;
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private List<Long> listIdsOfertasDelBulk = new ArrayList<Long>();
	private Long idOfertaActual= null;
	private Map<String,String[]> valoresTarea = null;
	
	private static final String COD_TAP_TAREA_AUTORIZACION_PROPIEDAD = "T017_ResolucionPROManzana";
	
	public AvanzaTareaOfertasBulkAN(String userName, List<Long> listIdsOfertasDelBulk, Long idOfertaActual, Map<String,String[]> valoresTarea ) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.listIdsOfertasDelBulk = listIdsOfertasDelBulk;
		this.idOfertaActual = idOfertaActual;
		this.valoresTarea = valoresTarea;
	}

	@Override
	public void run() {

		try {
			restApi.doSessionConfig(this.userName);
			Session sessionObj = hibernateUtils.getSessionFactory().openSession();
			Oferta ofertaDelBulk = null;
			Oferta ofertaActual = (Oferta) sessionObj.get(Oferta.class, idOfertaActual);
			for (Long idOfertaDelBulk : listIdsOfertasDelBulk) {
				ofertaDelBulk = (Oferta) sessionObj.get(Oferta.class, idOfertaDelBulk);
				if(!Checks.esNulo(ofertaActual) && !ofertaActual.getNumOferta().toString().equals(ofertaDelBulk.getNumOferta().toString())) {
					if(ofertaDao.tieneTareaActiva(COD_TAP_TAREA_AUTORIZACION_PROPIEDAD, ofertaDelBulk.getNumOferta().toString())) {
						ExpedienteComercial expedienteComercial=  expedienteComercialDao.getExpedienteComercialByIdOferta(idOfertaDelBulk);
						List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(expedienteComercial.getTrabajo().getId());
						List<TareaExterna> tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(listaTramites.get(0).getId());					
						valoresTarea.put("idTarea", new String[] { tareasTramite.get(0).getTareaPadre().getId().toString() });
						agendaAdapter.save(valoresTarea);
					}else {
						throw new Exception("No se puede avanzar la tarea, la oferta no tiene la tarea Autorizaci&oacute;n Propiedad activa.");
					}
				}
			}
			sessionObj.flush();
			sessionObj.close();
		} catch (Exception e) {
			logger.error("[ERROR] Error en AvanzaTareaOfertasBulkAN al intentar avanzar la tarea de la oferta", e);
		}
	}

}

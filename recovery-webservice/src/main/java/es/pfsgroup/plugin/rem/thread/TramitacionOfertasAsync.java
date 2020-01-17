package es.pfsgroup.plugin.rem.thread;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.tramitacionOfertas.TramitacionOfertasManager;



public class TramitacionOfertasAsync implements Runnable {

	@Autowired
	private RestApi restApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private ActivoManager activoManager;
	
	@Autowired
	private TramitacionOfertasManager tramitacionOfertasManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private HibernateUtils hibernateUtils;
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private Long idActivo = null;
	private Boolean aceptado = null;
	private Long idTrabajo = null;
	private Long idOferta = null;
	private Long idExpedienteComercial;

	public TramitacionOfertasAsync(Long idActivo, Boolean aceptado, Long idTrabajo, Long idOferta, 
			Long idExpedienteComercial, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idActivo = idActivo;
		this.aceptado = aceptado;
		this.idTrabajo = idTrabajo;
		this.idOferta = idOferta;
		this.idExpedienteComercial = idExpedienteComercial;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			
			Session sessionObj = hibernateUtils.getSessionFactory().openSession();
			
			Activo activo = (Activo) sessionObj.get(Activo.class, idActivo);
			Trabajo trabajo = (Trabajo) sessionObj.get(Trabajo.class, idTrabajo);
			Oferta oferta = (Oferta) sessionObj.get(Oferta.class, idOferta);
			ExpedienteComercial expedienteComercial = (ExpedienteComercial) 
					sessionObj.get(ExpedienteComercial.class, idExpedienteComercial);
			
			if(aceptado) {	
				// Creación de formalización y condicionantes. Evita errores en los
				// trámites al preguntar por datos de algunos de estos objetos y aún
				// no esten creados. Para ello creamos los objetos vacios con el
				// unico fin que se cree la fila.
				expedienteComercial = tramitacionOfertasManager.crearCondicionanteYTanteo(activo, oferta, expedienteComercial);
				expedienteComercial = tramitacionOfertasManager.crearExpedienteReserva(expedienteComercial);
				expedienteComercialApi.crearCondicionesActivoExpediente(oferta.getActivoPrincipal(), expedienteComercial);
				
				Formalizacion formalizacion = tramitacionOfertasManager.crearFormalizacion(expedienteComercial);
				expedienteComercial.setFormalizacion(formalizacion);
				
				DDComiteSancion comite = tramitacionOfertasManager.devuelveComiteByCartera(activo.getCartera().getCodigo(), oferta);
				
				expedienteComercial.setComiteSancion(comite);
				
				if(DDCartera.CODIGO_CARTERA_LIBERBANK.equals(activo.getCartera().getCodigo())){
					expedienteComercial.setComitePropuesto(comite);
				}
				
				tramitacionOfertasManager.crearCompradores(oferta, expedienteComercial);
				
				tramitacionOfertasManager.crearGastosExpediente(oferta, expedienteComercial);
				
				// Se asigna un gestor de Formalización al crear un nuevo expediente.
				tramitacionOfertasManager.asignarGestorYSupervisorFormalizacionToExpediente(expedienteComercial);
				
				trabajoApi.createTramiteTrabajo(trabajo);
			}
			
			if(activo != null) {
				activoManager.actualizarOfertasTrabajosVivos(activo);
			}
			
			sessionObj.flush();
            sessionObj.close();
			
		} catch (Exception e) {
			logger.error("error creando expediente comercial", e);
		}

	}

}

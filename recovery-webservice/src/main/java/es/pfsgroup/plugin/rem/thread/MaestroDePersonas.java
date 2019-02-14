package es.pfsgroup.plugin.rem.thread;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;
import es.pfsgroup.plugin.gestorDocumental.manager.GestorDocumentalMaestroManager;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class MaestroDePersonas  implements Runnable{
	@Autowired
	private GestorDocumentalMaestroManager gestorDocumentalMaestroManager;
	
    @Autowired
    private GenericABMDao genericDao;
    
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private HibernateUtils hibernateUtils;

	private final Log logger = LogFactory.getLog(getClass());

	private Long expedienteComercial = null;
	
	private String userName = null;

	private String cartera = null;
	
	private String idPersonaHayaNoExiste = "1001";

	private PersonaInputDto personaDto = new PersonaInputDto();

	public MaestroDePersonas(Long expedienteComercial, String userName, String cartera) {
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.expedienteComercial = expedienteComercial;
		this.cartera=cartera;
	}

	public void run() {
		Session sessionObj = null;
		List<CompradorExpediente> listaPersonas = null;
		try {
			restApi.doSessionConfig(this.userName);
			Thread.sleep(5000);
		    sessionObj = hibernateUtils.getSessionFactory().openSession();
			if(!Checks.esNulo(expedienteComercial)) {
				ExpedienteComercial expedienteCom = llamadaExpedienteComercial(sessionObj);
				if(!Checks.esNulo(expedienteCom.getCompradores())) {					
					listaPersonas = expedienteCom.getCompradores();
				}
				 if(!Checks.estaVacio(listaPersonas)){
					 for (CompradorExpediente compradorExpediente : listaPersonas) {
						 if(Checks.esNulo(compradorExpediente.getIdPersonaHaya()) || idPersonaHayaNoExiste.equals(compradorExpediente.getIdPersonaHaya())) {
						 	personaDto.setEvent(PersonaInputDto.EVENTO_IDENTIFICADOR_PERSONA_ORIGEN);
							personaDto.setIdPersonaOrigen(compradorExpediente.getPrimaryKey().getComprador().getDocumento());
							personaDto.setIdIntervinienteHaya(PersonaInputDto.ID_INTERVINIENTE_HAYA);
							personaDto.setIdCliente(cartera);
							
							logger.error("[MAESTRO DE PERSONAS] LLAMAMOS A EJECUTAR PERSONA");
							logger.error("[MAESTRO DE PERSONAS] Datos de la llamada: ".concat(personaDto.toString()));
							PersonaOutputDto personaOutputDto = gestorDocumentalMaestroManager.ejecutarPersona(personaDto);
							logger.error("[MAESTRO DE PERSONAS] VOLVEMOS DE EJECUTAR PERSONA");
							logger.error("[MAESTRO DE PERSONAS] Datos de la respuesta: ".concat(personaOutputDto.toString()));
							
							if (Checks.esNulo(personaOutputDto)) {
								logger.error("[MAESTRO DE PERSONAS] personaOutputDto ES NULO");
							} else if (Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
								logger.error("[MAESTRO DE PERSONAS] getIdIntervinienteHaya ES NULO");
							} else {
								logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
							}
							
							if(!Checks.esNulo(personaOutputDto)) {
								if(!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
									compradorExpediente.setIdPersonaHaya(personaOutputDto.getIdIntervinienteHaya());
								}else {
									compradorExpediente.setIdPersonaHaya(idPersonaHayaNoExiste);
								}
								genericDao.update(CompradorExpediente.class, compradorExpediente);
							}
						}	
					}
				 }
			}
			sessionObj.close();
		} catch (Exception e) {
			logger.error("Error maestro de personas", e);
		}
	}

	private ExpedienteComercial llamadaExpedienteComercial(Session sessionObj) {
		Criteria criteria = sessionObj.createCriteria(ExpedienteComercial.class);
		criteria.add(Restrictions.eq("id", expedienteComercial));
		return  HibernateUtils.castObject(ExpedienteComercial.class, criteria.uniqueResult());
	}
}



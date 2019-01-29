package es.pfsgroup.plugin.rem.thread;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TmpClienteGDPR;
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
	
	private String numDocCliente = null;
	
	private String userName = null;

	private String cartera = null;
	
	private String idPersonaHayaNoExiste = "1001";
	
	private static final String ID_CLIENTE_HAYA = "HAYA";
	private static final String MOTIVO_OPERACION_ALTA = "ALTA";
	private static final String ID_ORIGEN_REM = "REM";
	private static final String ID_TIPO_IDENTIFICADOR_NIF_CIF = "NIF/CIF";
	private static final String ID_ROL_16 = "16";

	private PersonaInputDto personaDto = new PersonaInputDto();
	 
	public  MaestroDePersonas(Long expedienteComercial, String userName, String cartera) {
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.expedienteComercial = expedienteComercial;
		this.cartera=cartera;
	}
	
	public  MaestroDePersonas(String numDocCliente, String userName, String cartera) {
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.numDocCliente = numDocCliente;
		this.cartera=cartera;
	}
	
	public void run() {
		Session sessionObj = null;
		try {
			restApi.doSessionConfig(this.userName);
			Thread.sleep(5000);
		    sessionObj = hibernateUtils.getSessionFactory().openSession();
			if(!Checks.esNulo(expedienteComercial)) {
				ExpedienteComercial expedienteCom = llamadaExpedienteComercial(sessionObj);
				 List<CompradorExpediente> listaPersonas = expedienteCom.getCompradores();
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
								
								SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
								String today = df.format(new Date());
								
								logger.error("[MAESTRO DE PERSONAS] GENERANDO ID PERSONA");
								personaDto.setEvent(PersonaInputDto.EVENTO_ALTA_PERSONA);
								personaDto.setIdCliente(ID_CLIENTE_HAYA);
								personaDto.setIdPersonaOrigen(compradorExpediente.getPrimaryKey().getComprador().getDocumento());
								personaDto.setIdMotivoOperacion(MOTIVO_OPERACION_ALTA);
								personaDto.setIdOrigen(ID_ORIGEN_REM);
								personaDto.setFechaOperacion(today);
								personaDto.setIdTipoIdentificador(ID_TIPO_IDENTIFICADOR_NIF_CIF);
								personaDto.setIdRol(ID_ROL_16);
								
								personaOutputDto = gestorDocumentalMaestroManager.ejecutarPersona(personaDto);
								
								logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
								if (!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
									TmpClienteGDPR tmpClienteGDPR = new TmpClienteGDPR();
									tmpClienteGDPR.setIdPersonaHaya(Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
									tmpClienteGDPR.setNumDocumento(personaDto.getIdPersonaOrigen());
									genericDao.save(TmpClienteGDPR.class, tmpClienteGDPR);
								}
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
			} else if (!Checks.esNulo(numDocCliente)) {
				String documento = null, idPersonaHaya = null;
				ClienteComercial clienteCom = null;
				ClienteGDPR clienteGDPR = llamadaClienteGDPR(sessionObj);
				if(!Checks.esNulo(clienteGDPR)) {
					clienteCom = llamadaClienteComercial(sessionObj, clienteGDPR);
					documento = clienteCom.getDocumento();
					idPersonaHaya = clienteCom.getIdPersonaHaya();
				} else {
					documento = numDocCliente;
				} 
					if(Checks.esNulo(clienteCom) || Checks.esNulo(idPersonaHaya) || idPersonaHayaNoExiste.equals(idPersonaHaya)) {
						personaDto.setEvent(PersonaInputDto.EVENTO_IDENTIFICADOR_PERSONA_ORIGEN);
						personaDto.setIdPersonaOrigen(documento);
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
							
							SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
							String today = df.format(new Date());
							
							logger.error("[MAESTRO DE PERSONAS] GENERANDO ID PERSONA");
							personaDto.setEvent(PersonaInputDto.EVENTO_ALTA_PERSONA);
							personaDto.setIdCliente(ID_CLIENTE_HAYA);
							personaDto.setIdPersonaOrigen(documento);
							personaDto.setIdMotivoOperacion(MOTIVO_OPERACION_ALTA);
							personaDto.setIdOrigen(ID_ORIGEN_REM);
							personaDto.setFechaOperacion(today);
							personaDto.setIdTipoIdentificador(ID_TIPO_IDENTIFICADOR_NIF_CIF);
							personaDto.setIdRol(ID_ROL_16);
							
							personaOutputDto = gestorDocumentalMaestroManager.ejecutarPersona(personaDto);
							
							logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
							if (!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
								TmpClienteGDPR tmpClienteGDPR = new TmpClienteGDPR();
								tmpClienteGDPR.setIdPersonaHaya(Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
								tmpClienteGDPR.setNumDocumento(personaDto.getIdPersonaOrigen());
								genericDao.save(TmpClienteGDPR.class, tmpClienteGDPR);
							}
						} else {
							logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
						}
							
						if(!Checks.esNulo(personaOutputDto) && !Checks.esNulo(clienteCom)) {
							if(!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
								clienteCom.setIdPersonaHaya(personaOutputDto.getIdIntervinienteHaya());
							}else {
								clienteCom.setIdPersonaHaya(idPersonaHayaNoExiste);
							}
							genericDao.update(ClienteComercial.class, clienteCom);
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
	
	private ClienteGDPR llamadaClienteGDPR(Session sessionObj) {
		Criteria criteria = sessionObj.createCriteria(ClienteGDPR.class);
		criteria.add(Restrictions.eq("numDocumento", numDocCliente));
		return  HibernateUtils.castObject(ClienteGDPR.class, criteria.uniqueResult());
	}
	
	private ClienteComercial llamadaClienteComercial(Session sessionObj, ClienteGDPR clienteGDPR) {
		Criteria criteria = sessionObj.createCriteria(ClienteComercial.class);
		criteria.add(Restrictions.eq("id", clienteGDPR.getCliente().getId()));
		return  HibernateUtils.castObject(ClienteComercial.class, criteria.uniqueResult());
	}
}



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
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;
import es.pfsgroup.plugin.gestorDocumental.manager.GestorDocumentalMaestroManager;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TmpClienteGDPR;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class MaestroDePersonas implements Runnable {
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
	private static final String ID_PERSONA_SIMULACION = "simulacion";

	private PersonaInputDto personaDto = new PersonaInputDto();

	public MaestroDePersonas(Long expedienteComercial, String userName, String cartera) {
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.expedienteComercial = expedienteComercial;
		this.cartera = cartera;
	}

	public MaestroDePersonas(String numDocCliente, String userName, String cartera) {
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.numDocCliente = numDocCliente;
		this.cartera = cartera;
	}

	@Transactional
	public void run() {
		Session sessionObj = null;
		List<CompradorExpediente> listaPersonas = null;
		Integer idPersonaSimulado = (int) (Math.random() * 1000000) + 1;
		try {
			restApi.doSessionConfig(this.userName);
			Thread.sleep(5000);
			sessionObj = hibernateUtils.getSessionFactory().openSession();
			if (!Checks.esNulo(expedienteComercial)) {
				ExpedienteComercial expedienteCom = llamadaExpedienteComercial(sessionObj);
				if (!Checks.esNulo(expedienteCom.getCompradores())) {
					listaPersonas = expedienteCom.getCompradores();
				}
				if (!Checks.estaVacio(listaPersonas)) {
					for (CompradorExpediente compradorExpediente : listaPersonas) {
						if (Checks.esNulo(compradorExpediente.getIdPersonaHaya())
								|| idPersonaHayaNoExiste.equals(compradorExpediente.getIdPersonaHaya())) {
							personaDto.setEvent(PersonaInputDto.EVENTO_IDENTIFICADOR_PERSONA_ORIGEN);
							personaDto.setIdPersonaOrigen(
									compradorExpediente.getPrimaryKey().getComprador().getDocumento());
							personaDto.setIdIntervinienteHaya(PersonaInputDto.ID_INTERVINIENTE_HAYA);
							personaDto.setIdCliente(cartera);

							logger.error("[MAESTRO DE PERSONAS] LLAMAMOS A EJECUTAR PERSONA");
							logger.error("[MAESTRO DE PERSONAS] Datos de la llamada: ".concat(personaDto.toString()));
							PersonaOutputDto personaOutputDto = gestorDocumentalMaestroManager
									.ejecutarPersona(personaDto);
							logger.error("[MAESTRO DE PERSONAS] VOLVEMOS DE EJECUTAR PERSONA");
							logger.error("[MAESTRO DE PERSONAS] Datos de la respuesta: "
									.concat(personaOutputDto.toString()));

							if (Checks.esNulo(personaOutputDto)) {
								logger.error("[MAESTRO DE PERSONAS] personaOutputDto ES NULO");
							} else if (Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
								logger.error("[MAESTRO DE PERSONAS] getIdIntervinienteHaya ES NULO");

								SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
								String today = df.format(new Date());

								logger.error("[MAESTRO DE PERSONAS] GENERANDO ID PERSONA");
								personaDto.setEvent(PersonaInputDto.EVENTO_ALTA_PERSONA);
								personaDto.setIdCliente(ID_CLIENTE_HAYA);
								personaDto.setIdPersonaOrigen(
										compradorExpediente.getPrimaryKey().getComprador().getDocumento());
								personaDto.setIdMotivoOperacion(MOTIVO_OPERACION_ALTA);
								personaDto.setIdOrigen(ID_ORIGEN_REM);
								personaDto.setFechaOperacion(today);
								personaDto.setIdTipoIdentificador(ID_TIPO_IDENTIFICADOR_NIF_CIF);
								personaDto.setIdRol(ID_ROL_16);

								personaOutputDto = gestorDocumentalMaestroManager.ejecutarPersona(personaDto);

								logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES "
										+ personaOutputDto.getIdIntervinienteHaya());
								if (!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
									TmpClienteGDPR tmpClienteGDPR = new TmpClienteGDPR();
									tmpClienteGDPR.setIdPersonaHaya(
											Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
									tmpClienteGDPR.setNumDocumento(personaDto.getIdPersonaOrigen());
									genericDao.save(TmpClienteGDPR.class, tmpClienteGDPR);
								} else if (ID_PERSONA_SIMULACION.equals(personaOutputDto.getResultDescription())) {
									Criteria criteria = sessionObj.createCriteria(TmpClienteGDPR.class);
									criteria.add(Restrictions.eq("numDocumento",
											compradorExpediente.getPrimaryKey().getComprador().getDocumento()));
									TmpClienteGDPR tmpClienteGDPR = HibernateUtils.castObject(TmpClienteGDPR.class,
											criteria.uniqueResult());

									if (Checks.esNulo(tmpClienteGDPR)) {
										tmpClienteGDPR = new TmpClienteGDPR();
										tmpClienteGDPR.setIdPersonaHaya(Long.parseLong(idPersonaSimulado.toString()));
										tmpClienteGDPR.setNumDocumento(personaDto.getIdPersonaOrigen());
										genericDao.save(TmpClienteGDPR.class, tmpClienteGDPR);
									}
								}
							} else {
								logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES "
										+ personaOutputDto.getIdIntervinienteHaya());
							}

							if (!Checks.esNulo(personaOutputDto)) {
								if (!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
									compradorExpediente.setIdPersonaHaya(personaOutputDto.getIdIntervinienteHaya());
								} else if (ID_PERSONA_SIMULACION.equals(personaOutputDto.getResultDescription())) {
									compradorExpediente.setIdPersonaHaya(idPersonaSimulado.toString());
								} else {
									compradorExpediente.setIdPersonaHaya(idPersonaHayaNoExiste);
								}
								genericDao.update(CompradorExpediente.class, compradorExpediente);
							}
						}
					}
				}
			} else if (!Checks.esNulo(numDocCliente)) {
				String documento = null, idPersonaHaya = null;
				List<ClienteComercial> clienteCom = llamadaClienteComercial(sessionObj, numDocCliente);
				ClienteGDPR clienteGDPR = llamadaClienteGDPR(sessionObj);
				Comprador comprador = llamadaComprador(sessionObj);
				if (!Checks.esNulo(clienteGDPR)) {
					documento = numDocCliente;
					for (ClienteComercial clc : clienteCom) {
						if (clc.getIdPersonaHaya() != null) {
							idPersonaHaya = clc.getIdPersonaHaya();
							break;
						}
					}
				} else {
					documento = numDocCliente;
				}

				if (Checks.esNulo(clienteCom) || Checks.esNulo(idPersonaHaya)
						|| idPersonaHayaNoExiste.equals(idPersonaHaya)) {
					personaDto.setEvent(PersonaInputDto.EVENTO_IDENTIFICADOR_PERSONA_ORIGEN);
					personaDto.setIdPersonaOrigen(documento);
					personaDto.setIdIntervinienteHaya(PersonaInputDto.ID_INTERVINIENTE_HAYA);
					personaDto.setIdCliente(cartera);

					logger.error("[MAESTRO DE PERSONAS] LLAMAMOS A EJECUTAR PERSONA");
					logger.error("[MAESTRO DE PERSONAS] Datos de la llamada: ".concat(personaDto.toString()));
					
					//PersonaOutputDto personaOutputDto = gestorDocumentalMaestroManager.ejecutarPersona(personaDto);
					PersonaOutputDto personaOutputDto = new PersonaOutputDto();
					
					logger.error("[MAESTRO DE PERSONAS] VOLVEMOS DE EJECUTAR PERSONA");
					logger.error("[MAESTRO DE PERSONAS] Datos de la respuesta: ".concat(!Checks.esNulo(personaOutputDto) ? personaOutputDto.toString() : "NULL"));

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

						//personaOutputDto = gestorDocumentalMaestroManager.ejecutarPersona(personaDto);
						personaOutputDto.setIdIntervinienteHaya("123456789");

						logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
						if (!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
							Criteria criteria = sessionObj.createCriteria(TmpClienteGDPR.class);
							criteria.add(Restrictions.eq("idPersonaHaya", Long.parseLong(personaOutputDto.getIdIntervinienteHaya())));
							criteria.add(Restrictions.eq("numDocumento", documento));
							TmpClienteGDPR tmpClienteGDPR = HibernateUtils.castObject(TmpClienteGDPR.class, criteria.uniqueResult());
							
							if(Checks.esNulo(tmpClienteGDPR)) {
								tmpClienteGDPR = new TmpClienteGDPR();
								tmpClienteGDPR.setIdPersonaHaya(Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
								tmpClienteGDPR.setNumDocumento(personaDto.getIdPersonaOrigen());
								genericDao.save(TmpClienteGDPR.class, tmpClienteGDPR);
							}
						} else if (ID_PERSONA_SIMULACION.equals(personaOutputDto.getResultDescription())) {
							Criteria criteria = sessionObj.createCriteria(TmpClienteGDPR.class);
							criteria.add(Restrictions.eq("numDocumento", documento));
							TmpClienteGDPR tmpClienteGDPR = HibernateUtils.castObject(TmpClienteGDPR.class, criteria.uniqueResult());
							
							if(Checks.esNulo(tmpClienteGDPR)) {
								tmpClienteGDPR = new TmpClienteGDPR();
								tmpClienteGDPR.setIdPersonaHaya(Long.parseLong(idPersonaSimulado.toString()));
								tmpClienteGDPR.setNumDocumento(personaDto.getIdPersonaOrigen());
								genericDao.save(TmpClienteGDPR.class, tmpClienteGDPR);
							}
						}
					} else {
						logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
					}

					if (!Checks.esNulo(personaOutputDto) && !Checks.esNulo(clienteCom) && clienteCom.size() > 0) {

						for (ClienteComercial clc : clienteCom) {
							if (!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
								clc.setIdPersonaHaya(personaOutputDto.getIdIntervinienteHaya());
							} else {
								clc.setIdPersonaHaya(idPersonaHayaNoExiste);
							}
							genericDao.update(ClienteComercial.class, clc);

						}						
					} else if(!Checks.esNulo(personaOutputDto) && !Checks.esNulo(comprador)) {
						if(!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
							comprador.setIdPersonaHaya(Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
						}else if (ID_PERSONA_SIMULACION.equals(personaOutputDto.getResultDescription())){
							comprador.setIdPersonaHaya(Long.parseLong(idPersonaSimulado.toString()));
						}else {
							comprador.setIdPersonaHaya(Long.parseLong(idPersonaHayaNoExiste));
						}
						genericDao.update(Comprador.class, comprador);
					}
				}
			}
			sessionObj.close();
		} catch (

		Exception e) {
			logger.error("Error maestro de personas", e);
		}
	}

	private ExpedienteComercial llamadaExpedienteComercial(Session sessionObj) {
		Criteria criteria = sessionObj.createCriteria(ExpedienteComercial.class);
		criteria.add(Restrictions.eq("id", expedienteComercial));
		return HibernateUtils.castObject(ExpedienteComercial.class, criteria.uniqueResult());
	}

	@SuppressWarnings("unchecked")
	private ClienteGDPR llamadaClienteGDPR(Session sessionObj) {
		Criteria criteria = sessionObj.createCriteria(ClienteGDPR.class);
		List<ClienteGDPR> listadoClientes = null;
		criteria.add(Restrictions.eq("numDocumento", numDocCliente));
		criteria.setFirstResult(0);
		criteria.setMaxResults(1);

		listadoClientes = criteria.list();

		if (!Checks.esNulo(listadoClientes) && !Checks.estaVacio(listadoClientes)) {
			return listadoClientes.get(0);
		}

		return null;
	}
	
	private Comprador llamadaComprador(Session sessionObj) {
		Criteria criteria = sessionObj.createCriteria(Comprador.class);
		criteria.add(Restrictions.eq("documento", numDocCliente));
		return  HibernateUtils.castObject(Comprador.class, criteria.uniqueResult());
	}
	
	@SuppressWarnings("unchecked")
	private List<ClienteComercial> llamadaClienteComercial(Session sessionObj, String numCliente) {
		Criteria criteria = sessionObj.createCriteria(ClienteComercial.class);
		criteria.add(Restrictions.eq("documento", numCliente));
		return criteria.list();
	}
}

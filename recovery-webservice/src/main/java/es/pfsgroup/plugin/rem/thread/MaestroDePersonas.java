package es.pfsgroup.plugin.rem.thread;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;
import es.pfsgroup.plugin.gestorDocumental.manager.GestorDocumentalMaestroManager;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.MapeoGestorDocumental;
import es.pfsgroup.plugin.rem.model.TmpClienteGDPR;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
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
	
	@Autowired
	private ProveedoresDao proveedoresDao;

	private final Log logger = LogFactory.getLog(getClass());

	private Long expedienteComercial = null;

	private String numDocCliente = null;
	
	private ActivoProveedor proveedor = null;

	private String userName = null;

	private String cartera = null;
	
	private DDCartera ddCartera = null;
	
	private DDSubcartera subcartera = null;
	
	private List<MapeoGestorDocumental> listaMapeoGD = null;

	private String idPersonaHayaNoExiste = "1001";

	private static final String ID_CLIENTE_HAYA = "HAYA";
	private static final String ID_HAYA = "ID_HAYA";
	private static final String MOTIVO_OPERACION_ALTA = "ALTA";
	private static final String ID_ORIGEN_REM = "REM";
	private static final String ID_TIPO_IDENTIFICADOR_NIF_CIF = "NIF/CIF";
	private static final String ID_ROL_16 = "16";
	private static final String ID_ROL_PROVEEDOR_29 = "29";
	private static final String ID_PERSONA_SIMULACION = "simulacion";

	private PersonaInputDto personaDto = new PersonaInputDto();
	
	private PersonaOutputDto personaOutputDto = new PersonaOutputDto();

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
	
	public MaestroDePersonas(ActivoProveedor proveedor, String userName, DDCartera ddCartera, DDSubcartera subcartera, List<MapeoGestorDocumental> listaMapeoGD) {
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.proveedor = proveedor;
		this.ddCartera = ddCartera;
		this.subcartera = subcartera;
		this.listaMapeoGD = listaMapeoGD;
	}

	@Transactional(readOnly = false)	
	public void run() {
		Session sessionObj = null;
		List<CompradorExpediente> listaPersonas = null;
		Integer idPersonaSimulado = (int) (Math.random() * 1000000) + 1;
		try {
			restApi.doSessionConfig(this.userName);
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
							personaOutputDto = new PersonaOutputDto();
							BeanUtils.copyProperties(gestorDocumentalMaestroManager
									.ejecutar(personaDto), personaOutputDto);

							logger.info("[MAESTRO DE PERSONAS] VOLVEMOS DE EJECUTAR PERSONA");
							logger.info("[MAESTRO DE PERSONAS] Datos de la respuesta: "
									.concat(personaOutputDto.toString()));

							if (Checks.esNulo(personaOutputDto)) {
								logger.info("[MAESTRO DE PERSONAS] personaOutputDto ES NULO");
							} else if (Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
								logger.info("[MAESTRO DE PERSONAS] getIdIntervinienteHaya ES NULO");

								SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
								String today = df.format(new Date());

								logger.info("[MAESTRO DE PERSONAS] GENERANDO ID PERSONA");
								personaDto.setEvent(PersonaInputDto.EVENTO_ALTA_PERSONA);
								personaDto.setIdCliente(ID_CLIENTE_HAYA);
								personaDto.setIdPersonaOrigen(
										compradorExpediente.getPrimaryKey().getComprador().getDocumento());
								personaDto.setIdMotivoOperacion(MOTIVO_OPERACION_ALTA);
								personaDto.setIdOrigen(ID_ORIGEN_REM);
								personaDto.setFechaOperacion(today);
								personaDto.setIdTipoIdentificador(ID_TIPO_IDENTIFICADOR_NIF_CIF);
								personaDto.setIdRol(ID_ROL_16);

								BeanUtils.copyProperties(gestorDocumentalMaestroManager
										.ejecutar(personaDto), personaOutputDto);

								logger.info("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES "
										+ personaOutputDto.getIdIntervinienteHaya());
								if (!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
									Criteria criteria = sessionObj.createCriteria(TmpClienteGDPR.class);
									criteria.add(Restrictions.eq("idPersonaHaya",Long.valueOf(personaOutputDto.getIdIntervinienteHaya())));
									TmpClienteGDPR tmpClienteGDPR = HibernateUtils.castObject(TmpClienteGDPR.class,
											criteria.uniqueResult());
									if(tmpClienteGDPR == null){
										tmpClienteGDPR = new TmpClienteGDPR();
										tmpClienteGDPR.setIdPersonaHaya(Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
									}									
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
								logger.info("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES "
										+ personaOutputDto.getIdIntervinienteHaya());
							}

							if (!Checks.esNulo(personaOutputDto)) {
								Long personaHaya = null;
								if (!Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
									compradorExpediente.setIdPersonaHaya(personaOutputDto.getIdIntervinienteHaya());
									personaHaya = Long.valueOf(personaOutputDto.getIdIntervinienteHaya());
								} else if (ID_PERSONA_SIMULACION.equals(personaOutputDto.getResultDescription())) {
									compradorExpediente.setIdPersonaHaya(idPersonaSimulado.toString());
									personaHaya = Long.valueOf(idPersonaSimulado);
								} else {
									compradorExpediente.setIdPersonaHaya(idPersonaHayaNoExiste);
									personaHaya = Long.valueOf(idPersonaHayaNoExiste);
								}
								Comprador comprador =compradorExpediente.getPrimaryKey().getComprador();
								comprador.setIdPersonaHaya(Long.valueOf(personaHaya));
								genericDao.update(Comprador.class, comprador);
								genericDao.update(CompradorExpediente.class, compradorExpediente);
							}
						}else{
							Comprador comprador =compradorExpediente.getPrimaryKey().getComprador();
							Long compradorIdhaya = null;
							if(comprador.getIdPersonaHaya() != null){
								compradorIdhaya = comprador.getIdPersonaHaya();
							}
							if(!Checks.esNulo(compradorExpediente.getIdPersonaHaya()) && !compradorExpediente.getIdPersonaHaya().equals(compradorIdhaya)){
								comprador.setIdPersonaHaya(Long.valueOf(compradorExpediente.getIdPersonaHaya()));
								genericDao.update(Comprador.class, comprador);								
							}
						}
					}
				}
				
			// LLAMADA MAESTRO PERSONAS GDPR
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
					personaOutputDto = new PersonaOutputDto();
					BeanUtils.copyProperties(personaOutputDto,gestorDocumentalMaestroManager
							.ejecutar(personaDto));
					//PersonaOutputDto personaOutputDto = new PersonaOutputDto();
					
					logger.info("[MAESTRO DE PERSONAS] VOLVEMOS DE EJECUTAR PERSONA");
					logger.info("[MAESTRO DE PERSONAS] Datos de la respuesta: ".concat(!Checks.esNulo(personaOutputDto) ? personaOutputDto.toString() : "NULL"));

					if (Checks.esNulo(personaOutputDto)) {
						logger.info("[MAESTRO DE PERSONAS] personaOutputDto ES NULO");
					} else if (Checks.esNulo(personaOutputDto.getIdIntervinienteHaya())) {
						logger.info("[MAESTRO DE PERSONAS] getIdIntervinienteHaya ES NULO");

						SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
						String today = df.format(new Date());

						logger.info("[MAESTRO DE PERSONAS] GENERANDO ID PERSONA");
						personaDto.setEvent(PersonaInputDto.EVENTO_ALTA_PERSONA);
						personaDto.setIdCliente(ID_CLIENTE_HAYA);
						personaDto.setIdPersonaOrigen(documento);
						personaDto.setIdMotivoOperacion(MOTIVO_OPERACION_ALTA);
						personaDto.setIdOrigen(ID_ORIGEN_REM);
						personaDto.setFechaOperacion(today);
						personaDto.setIdTipoIdentificador(ID_TIPO_IDENTIFICADOR_NIF_CIF);
						personaDto.setIdRol(ID_ROL_16);
						BeanUtils.copyProperties(gestorDocumentalMaestroManager
								.ejecutar(personaDto), personaOutputDto);
						//personaOutputDto.setIdIntervinienteHaya("123456789");

						logger.info("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
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
						logger.info("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
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
				
			// LLAMADA MAESTRO PERSONAS PROVEEDOR
			} /*else if (!Checks.esNulo(proveedor)) {
				
				String cliente = null;
				ActivoProveedorCartera activoProveedorCartera = null;
				String idPersonaHaya = null;
				
				if(!Checks.estaVacio(listaMapeoGD)) {
					
					for(MapeoGestorDocumental mgd : listaMapeoGD) {
						
						activoProveedorCartera = llamadaActivoProveedorCartera(sessionObj, mgd.getCartera(), mgd.getSubcartera(), mgd.getClienteGestorDocumental());
						
						if(!Checks.esNulo(activoProveedorCartera) && !Checks.esNulo(activoProveedorCartera.getIdPersonaHaya())) {
							idPersonaHaya = activoProveedorCartera.getIdPersonaHaya().toString();
						}
						
						if (Checks.esNulo(activoProveedorCartera) || Checks.esNulo(idPersonaHaya) || idPersonaHayaNoExiste.equals(idPersonaHaya)) {
							
							llamadaEjecutarPersona(mgd.getClienteGestorDocumental(), ID_ROL_PROVEEDOR_29);
		
							if (!Checks.esNulo(personaOutputDto) && !Checks.esNulo(personaOutputDto.getIdIntervinienteHaya()) && !Checks.esNulo(activoProveedorCartera)) {
								activoProveedorCartera.setIdPersonaHaya(Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
								genericDao.update(ActivoProveedorCartera.class, activoProveedorCartera);						
							} else if(!Checks.esNulo(personaOutputDto) && !Checks.esNulo(personaOutputDto.getIdIntervinienteHaya()) && Checks.esNulo(activoProveedorCartera)) {
								activoProveedorCartera = new ActivoProveedorCartera();
								activoProveedorCartera.setIdPersonaHaya(Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
								activoProveedorCartera.setProveedor(proveedor);
								activoProveedorCartera.setCartera(mgd.getCartera());
								activoProveedorCartera.setSubcartera(mgd.getSubcartera());
								activoProveedorCartera.setClienteGestorDocumental(mgd.getClienteGestorDocumental());
								genericDao.save(ActivoProveedorCartera.class, activoProveedorCartera);
							} else if(ID_PERSONA_SIMULACION.equals(personaOutputDto.getResultDescription()) && !Checks.esNulo(activoProveedorCartera)) {
								idPersonaSimulado = (int) (Math.random() * 1000000) + 1;
								activoProveedorCartera.setIdPersonaHaya(Long.valueOf(idPersonaSimulado));
								genericDao.update(ActivoProveedorCartera.class, activoProveedorCartera);
							} else if(ID_PERSONA_SIMULACION.equals(personaOutputDto.getResultDescription()) && Checks.esNulo(activoProveedorCartera)) {
								idPersonaSimulado = (int) (Math.random() * 1000000) + 1;
								activoProveedorCartera = new ActivoProveedorCartera();
								activoProveedorCartera.setIdPersonaHaya(Long.valueOf(idPersonaSimulado));
								activoProveedorCartera.setProveedor(proveedor);
								activoProveedorCartera.setCartera(mgd.getCartera());
								activoProveedorCartera.setSubcartera(mgd.getSubcartera());
								activoProveedorCartera.setClienteGestorDocumental(mgd.getClienteGestorDocumental());
								genericDao.save(ActivoProveedorCartera.class, activoProveedorCartera);
							}
						}						
					}
				} else {
					
					List<MapeoGestorDocumental> mapeoGestorDocumental = proveedoresDao.getCarteraClientesProveedores();
					for(MapeoGestorDocumental mgd : mapeoGestorDocumental) {
						if(!Checks.esNulo(proveedor) && (!Checks.esNulo(ddCartera) || !Checks.esNulo(subcartera))) {
							activoProveedorCartera = llamadaActivoProveedorCartera(sessionObj, ddCartera, subcartera, mgd.getClienteGestorDocumental());
							if(!Checks.esNulo(activoProveedorCartera)) {
								cliente = activoProveedorCartera.getClienteGestorDocumental();
								break;
							}
						} else if (!Checks.esNulo(proveedor) && Checks.esNulo(ddCartera) && Checks.esNulo(subcartera)) {
							activoProveedorCartera = llamadaActivoProveedorCartera(sessionObj, null, null, ID_HAYA);
							if(!Checks.esNulo(activoProveedorCartera)) {
								cliente = activoProveedorCartera.getClienteGestorDocumental();
								break;
							}
							
						}
					}
					
					if(!Checks.esNulo(activoProveedorCartera) && !Checks.esNulo(activoProveedorCartera.getIdPersonaHaya())) {
						idPersonaHaya = activoProveedorCartera.getIdPersonaHaya().toString();
					}
	
					if (Checks.esNulo(activoProveedorCartera) || Checks.esNulo(idPersonaHaya) || idPersonaHayaNoExiste.equals(idPersonaHaya)) {
						
						if(!Checks.esNulo(proveedor) && !Checks.esNulo(ddCartera) && !Checks.esNulo(subcartera)) {
							MapeoGestorDocumental mgd = llamadaMapeoGestorDocumental(sessionObj, ddCartera, subcartera);
							cliente = mgd.getClienteGestorDocumental();
						} else if (!Checks.esNulo(proveedor) && Checks.esNulo(ddCartera) && Checks.esNulo(subcartera)){
							cliente = ID_HAYA;
						}
						
						llamadaEjecutarPersona(cliente, ID_ROL_PROVEEDOR_29);
	
						if (!Checks.esNulo(personaOutputDto) && !Checks.esNulo(personaOutputDto.getIdIntervinienteHaya()) && !Checks.esNulo(activoProveedorCartera)) {
							activoProveedorCartera.setIdPersonaHaya(Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
							genericDao.update(ActivoProveedorCartera.class, activoProveedorCartera);						
						} else if(!Checks.esNulo(personaOutputDto) && !Checks.esNulo(personaOutputDto.getIdIntervinienteHaya()) && Checks.esNulo(activoProveedorCartera)) {
							activoProveedorCartera = new ActivoProveedorCartera();
							activoProveedorCartera.setIdPersonaHaya(Long.parseLong(personaOutputDto.getIdIntervinienteHaya()));
							activoProveedorCartera.setProveedor(proveedor);
							activoProveedorCartera.setCartera(ddCartera);
							activoProveedorCartera.setSubcartera(subcartera);
							activoProveedorCartera.setClienteGestorDocumental(cliente);
							genericDao.save(ActivoProveedorCartera.class, activoProveedorCartera);
						} else if(ID_PERSONA_SIMULACION.equals(personaOutputDto.getResultDescription()) && !Checks.esNulo(idPersonaSimulado) && !Checks.esNulo(activoProveedorCartera)) {
							activoProveedorCartera.setIdPersonaHaya(Long.parseLong(idPersonaSimulado.toString()));
							genericDao.update(ActivoProveedorCartera.class, activoProveedorCartera);
						} else if(ID_PERSONA_SIMULACION.equals(personaOutputDto.getResultDescription()) && !Checks.esNulo(idPersonaSimulado) && Checks.esNulo(activoProveedorCartera)) {
							activoProveedorCartera = new ActivoProveedorCartera();
							activoProveedorCartera.setIdPersonaHaya(Long.parseLong(idPersonaSimulado.toString()));
							activoProveedorCartera.setProveedor(proveedor);
							activoProveedorCartera.setCartera(ddCartera);
							activoProveedorCartera.setSubcartera(subcartera);
							activoProveedorCartera.setClienteGestorDocumental(cliente);
							genericDao.save(ActivoProveedorCartera.class, activoProveedorCartera);
						}
					}
				}
			}*/
			sessionObj.close();
		} catch (Exception e) {
			logger.error("Error maestro de personas", e);
		}
	}
	
	private void llamadaEjecutarPersona(String cliente, String rol) {
		personaDto.setEvent(PersonaInputDto.EVENTO_IDENTIFICADOR_PERSONA_ORIGEN);
		personaDto.setIdPersonaOrigen(proveedor.getDocIdentificativo());
		personaDto.setIdIntervinienteHaya(PersonaInputDto.ID_INTERVINIENTE_HAYA);
		personaDto.setIdCliente(cliente);

		logger.error("[MAESTRO DE PERSONAS] LLAMAMOS A EJECUTAR PERSONA");
		logger.error("[MAESTRO DE PERSONAS] Datos de la llamada: ".concat(personaDto.toString()));
		BeanUtils.copyProperties(personaOutputDto,gestorDocumentalMaestroManager
				.ejecutar(personaDto));
		
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
			personaDto.setIdPersonaOrigen(proveedor.getDocIdentificativo());
			personaDto.setIdMotivoOperacion(MOTIVO_OPERACION_ALTA);
			personaDto.setIdOrigen(ID_ORIGEN_REM);
			personaDto.setFechaOperacion(today);
			personaDto.setIdTipoIdentificador(ID_TIPO_IDENTIFICADOR_NIF_CIF);
			personaDto.setIdRol(rol);
			BeanUtils.copyProperties(gestorDocumentalMaestroManager
					.ejecutar(personaDto), personaOutputDto);

			logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
		} else {
			logger.error("[MAESTRO DE PERSONAS] EL ID RECUPERADO ES " + personaOutputDto.getIdIntervinienteHaya());
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
	
	/*private ActivoProveedorCartera llamadaActivoProveedorCartera(Session sessionObj, DDCartera cartera, DDSubcartera subcartera, String clienteGestorDocumental) {
		Criteria criteria = sessionObj.createCriteria(ActivoProveedorCartera.class);
		criteria.add(Restrictions.eq("proveedor", proveedor));
		if(Checks.esNulo(subcartera)) {
			criteria.add(Restrictions.isNull("subcartera"));
		} else {
			criteria.add(Restrictions.eq("subcartera", subcartera));
		}
		if(Checks.esNulo(cartera)) {
			criteria.add(Restrictions.isNull("cartera"));
		} else {
			criteria.add(Restrictions.eq("cartera", cartera));
		}
		if(Checks.esNulo(clienteGestorDocumental)) {
			criteria.add(Restrictions.isNull("clienteGestorDocumental"));
		} else {
			criteria.add(Restrictions.eq("clienteGestorDocumental", clienteGestorDocumental));
		}
		return  HibernateUtils.castObject(ActivoProveedorCartera.class, criteria.uniqueResult());
	}*/
	
	private MapeoGestorDocumental llamadaMapeoGestorDocumental(Session sessionObj, DDCartera cartera, DDSubcartera subcartera) {
		Criteria criteria = sessionObj.createCriteria(MapeoGestorDocumental.class);
		if(Checks.esNulo(subcartera)) {
			criteria.add(Restrictions.isNull("subcartera"));
		} else {
			criteria.add(Restrictions.eq("subcartera", subcartera));
		}
		if(Checks.esNulo(cartera)) {
			criteria.add(Restrictions.isNull("cartera"));
		} else {
			criteria.add(Restrictions.eq("cartera", cartera));
		}
		return  HibernateUtils.castObject(MapeoGestorDocumental.class, criteria.uniqueResult());
	}
	
	@SuppressWarnings("unchecked")
	private List<ClienteComercial> llamadaClienteComercial(Session sessionObj, String numCliente) {
		Criteria criteria = sessionObj.createCriteria(ClienteComercial.class);
		criteria.add(Restrictions.eq("documento", numCliente));
		return criteria.list();
	}
}

package es.capgemini.pfs.expediente;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.actitudAptitudActuacion.model.ActitudAptitudActuacion;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDtoImpl;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.model.EstadoCliente;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.expediente.EXTExpedientesApi;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.exceptions.NonRollbackException;
import es.capgemini.pfs.exceptions.ParametrizationException;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.model.AdjuntoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.api.contrato.EXTContratoApi;
import es.pfsgroup.recovery.ext.api.contrato.model.EXTInfoAdicionalContratoInfo;
import es.pfsgroup.recovery.ext.api.expediente.EXTExpedienteApi;
import es.pfsgroup.recovery.ext.api.itinerario.EXTInfoAdicionalItinerarioApi;
import es.pfsgroup.recovery.ext.api.itinerario.model.EXTDDTipoInfoAdicionalItinerarioInfo;
import es.pfsgroup.recovery.ext.api.itinerario.model.EXTInfoAdicionalItinerarioInfo;

@Component
public class EXTExpedientesManager implements EXTExpedientesApi{
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private static final String MAP_CONTRATOS_PASE = "contratosPase";
	private static final String MAP_CONTRATOS_MARCADOS = "contratosMarcados";
	private static final String MAP_CONTRATOS_GRUPO = "contratosGrupo";
	private static final String MAP_CONTRATOS_GENERACION_1 = "contratosGeneracion1";
	private static final String MAP_CONTRATOS_GENERACION_2 = "contratosGeneracion2";

	private static final String MAP_PERSONAS_PASE = "personasPase";
	private static final String MAP_PERSONAS_MARCADAS = "personasMarcadas";
	private static final String MAP_PERSONAS_GRUPO = "personasGrupo";
	private static final String MAP_PERSONAS_GENERACION_1 = "personasGeneracion1";
	private static final String MAP_PERSONAS_GENERACION_2 = "personasGeneracion2";
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ExpedienteDao expedienteDao;

	@Override
	@BusinessOperation(BO_CORE_EXPEDIENTE_ADJUNTOSCONTRATOS_EXP)
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		List<Contrato> contratos =(List<Contrato>) executor.execute("expedienteManager.findContratosRiesgoExpediente",id);
		List<ExtAdjuntoGenericoDto> adjuntosMapeado=new ArrayList<ExtAdjuntoGenericoDto>();
		
		Comparator<AdjuntoContrato> comparador = new Comparator<AdjuntoContrato>() {
			@Override
			public int compare(AdjuntoContrato o1, AdjuntoContrato o2) {
				if(Checks.esNulo(o1)&& Checks.esNulo(o2)){
					return 0;
				}
				else if (Checks.esNulo(o1)) {
					return -1;
				}
				else if (Checks.esNulo(o2)) {
					return 1;				
				}
				else{
					return o2.getAuditoria().getFechaCrear().compareTo(
						o1.getAuditoria().getFechaCrear());
				}	
			}
		};
		
		for(Contrato c : contratos){
			List<AdjuntoContrato> adjuntos = c.getAdjuntosAsList();
			Collections.sort(adjuntos, comparador);
			ExtAdjuntoGenericoDtoImpl dto = new ExtAdjuntoGenericoDtoImpl();
			dto.setId(c.getId());
			dto.setDescripcion(c.getDescripcion());
			dto.setAdjuntosAsList(adjuntos);
			dto.setAdjuntos(adjuntos);
			adjuntosMapeado.add(dto);
		}
		return adjuntosMapeado;
		
	}

	@Override
	@BusinessOperation(BO_CORE_EXPEDIENTE_ADJUNTOSPERSONA_EXP)
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		List<Persona> personas =(List<Persona>) executor.execute("expedienteManager.findPersonasByExpedienteId",id);
		List<ExtAdjuntoGenericoDto> adjuntosMapeado=new ArrayList<ExtAdjuntoGenericoDto>();
		
		Comparator<AdjuntoPersona> comparador = new Comparator<AdjuntoPersona>() {
			@Override
			public int compare(AdjuntoPersona o1, AdjuntoPersona o2) {
				if(Checks.esNulo(o1)&& Checks.esNulo(o2)){
					return 0;
				}
				else if (Checks.esNulo(o1)) {
					return -1;
				}
				else if (Checks.esNulo(o2)) {
					return 1;				
				}
				else{
					return o2.getAuditoria().getFechaCrear().compareTo(
						o1.getAuditoria().getFechaCrear());
				}	
			}
		};
		
		for(Persona p : personas){
			List<AdjuntoPersona> adjuntos = p.getAdjuntosAsList();
			Collections.sort(adjuntos, comparador);
			ExtAdjuntoGenericoDtoImpl dto =new ExtAdjuntoGenericoDtoImpl();
			dto.setId(p.getId());
			dto.setDescripcion(p.getDescripcion());
			dto.setAdjuntosAsList(adjuntos);
			dto.setAdjuntos(adjuntos);
			adjuntosMapeado.add(dto);
		}
		return adjuntosMapeado;
		
	}
	
	/**
	 * Crea un expediente. Sobreescribe la operaci�n de negocio original para
	 * que tenga en cuenta un nuevo �mbito de expediente del itinerario
	 * 
	 * @param idContrato
	 *            id del contrato principal
	 * @param idArquetipo
	 *            id del arquetipo del cliente
	 * @param idBPMExpediente
	 *            proceso BPM asociado
	 * @param idPersona
	 *            id
	 * @param idBPMCliente
	 *            proceso bpm del cliente?
	 * @return Expediente
	 * 
	 */
	@BusinessOperation(overrides = InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_AUTO)
	@Transactional(readOnly = false)
	public Expediente crearExpedienteAutomatico(Long idContrato,
			Long idPersona, Long idArquetipo, Long idBPMExpediente,
			Long idBPMCliente) {
			validarContratoPase(idContrato);

		Expediente expediente = new Expediente();
		expediente.setExpProcessBpm(idBPMExpediente);

		// Seteamos las personas/contratos del expediente
		setearPersonasContratosExpediente(expediente, idContrato, idPersona,
				idArquetipo);

		// Estado Expediente
		setEstadoExpediente(expediente);
		DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor
				.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
						DDEstadoExpediente.class,
						DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO);

		expediente.setEstadoExpediente(estadoExpediente);

		// AAA
		ActitudAptitudActuacion aaa = new ActitudAptitudActuacion();
		aaa.setAuditoria(Auditoria.getNewInstance());
		expediente.setAaa(aaa);

		// El expediente no es manual
		expediente.setManual(false);

		// Seteo el arquetipo del expediente
		Arquetipo arq = (Arquetipo) executor.execute(
				ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, idArquetipo);
		expediente.setArquetipo(arq);

		// Obtenemos la oficina del contrato de pase
		// VRE
		// List<Cliente> clientes =
		// clienteManager.buscarClientesTitularesPorContrato(idContrato);
		// Long oficina = obtenerMayorVRE(idContrato);
		Contrato cnt = (Contrato) executor.execute(
				PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);

		if (cnt != null) {
			Oficina ofi = cnt.getOficina();
			expediente.setOficina(ofi);
		} else {
			// new
			// ParametrizationException("No existe oficina para el expediente a generar");
			throw new GenericRollbackException("expediente.oficinaNoExistente");
		}
		// Anular Clientes relacionados
		eliminarProcesosClientesRelacionados(expediente, idBPMCliente);

		// Le seteamos el nombre ya que ahora no se obtiene a trav�s de una
		// f�rmula
		setearNombreExpediente(expediente, idPersona);

	  // Seteamos el tipo de expediente
        DDTipoExpediente tipo = null;
        if(arq !=null && arq.getItinerario()!=null && arq.getItinerario().getdDtipoItinerario().getItinerarioSeguimiento())
        	tipo = genericDao.get(DDTipoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoExpediente.TIPO_EXPEDIENTE_SEGUIMIENTO), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
        else
        	tipo = genericDao.get(DDTipoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoExpediente.TIPO_EXPEDIENTE_RECUPERACION), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
        expediente.setTipoExpediente(tipo); 
	
		
		expedienteDao.saveOrUpdate(expediente);

		executor
				.execute(
						InternaBusinessOperation.BO_POL_MGR_INICIALIZAR_POLITICAS_EXPEDIENTE,
						expediente);

		return expediente;
	}

	
	private Expediente getExpediente(Long id) {
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "id", id);
		Expediente exp = genericDao.get(Expediente.class, filtroExpediente);
		return exp;
	}

	@Override
	@BusinessOperation(BO_CORE_EXPEDIENTE_ADJUNTOSMAPEADOS)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		List<AdjuntoDto> adjuntosConBorrado = new ArrayList<AdjuntoDto>();

		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class)
				.getUsuarioLogado();

		final Boolean borrarOtrosUsu = tieneFuncion(usuario,
				"BORRAR_ADJ_OTROS_USU");
		
		Expediente exp = getExpediente(id);
		List<AdjuntoExpediente> adjuntos= new ArrayList<AdjuntoExpediente>();
		if (!Checks.esNulo(exp)){
			adjuntos = exp.getAdjuntosAsList();
		}
		Comparator<AdjuntoExpediente> comparador = new Comparator<AdjuntoExpediente>() {
			@Override
			public int compare(AdjuntoExpediente o1, AdjuntoExpediente o2) {
				if(Checks.esNulo(o1)&& Checks.esNulo(o2)){
					return 0;
				}
				else if (Checks.esNulo(o1)) {
					return -1;
				}
				else if (Checks.esNulo(o2)) {
					return 1;				
				}
				else{
					return o2.getAuditoria().getFechaCrear().compareTo(
						o1.getAuditoria().getFechaCrear());
				}	
			}
		};
		Collections.sort(adjuntos, comparador);
		for (final AdjuntoExpediente adj : adjuntos){
			AdjuntoDto dto = new AdjuntoDto() {
				
				@Override
				public Boolean getPuedeBorrar() {
					if (borrarOtrosUsu
							|| adj.getAuditoria().getUsuarioCrear().equals(
									usuario.getUsername())) {
						return true;
					} else {
						return false;
					}
				}
				
				@Override
				public Object getAdjunto() {
					return adj;
				}
			};
			adjuntosConBorrado.add(dto);
		}
		return adjuntosConBorrado;
	}
	
	private boolean tieneFuncion(Usuario usuario, String codigo) {
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil per : perfiles) {
			for (Funcion fun : per.getFunciones()) {
				if (fun.getDescripcion().equals(codigo)) {
					return true;
				}
			}
		}

		return false;
	}

	/**
	 * Valida que el contrato no exista en un expediente activo, bloqueado o
	 * congelado. De ser asi lanza una excepci�n
	 * 
	 * @param idContrato
	 * @throws BusinessOperationException
	 *             contrato en otro expediente.
	 */
	private void validarContratoPase(Long idContrato) {
		Expediente exp = expedienteDao
				.buscarExpedientesParaContrato(idContrato);
		if (exp != null) {
			logger.error("expediente.contrato.invalido.otroExpediente: "+idContrato);
			throw new NonRollbackException(
					"expediente.contrato.invalido.otroExpediente", idContrato);
		}
	}

	/**
	 * Setea la personas y los contratos de un expediente.
	 * 
	 * @param expediente
	 *            Expediente donde almacenar personas y contratos
	 * @param idContrato
	 *            Contrato de pase
	 * @param idPersona
	 *            Persona de pase
	 * @param idArquetipo
	 *            Arquetipo de la persona
	 */
	private void setearPersonasContratosExpediente(Expediente expediente,
			Long idContrato, Long idPersona, Long idArquetipo) {
		Arquetipo arq = (Arquetipo) executor.execute(
				ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, idArquetipo);
		DDAmbitoExpediente ambitoExpediente = arq.getItinerario()
				.getAmbitoExpediente();
		Boolean expedienteRecuperacion = arq.getItinerario()
				.getdDtipoItinerario().getItinerarioRecuperacion();

		EXTInfoAdicionalItinerarioInfo marca = proxyFactory
				.proxy(EXTInfoAdicionalItinerarioApi.class)
				.getInfoAdicionalItinerarioByTipo(
						arq.getItinerario().getId(),
						EXTDDTipoInfoAdicionalItinerarioInfo.MARCA_ACUMULAR_CONTRATOS);

		Integer limitePersonas = getLimitePersonasAdicionales();
		Integer limiteContratos = getLimiteContratosAdicionales();

		HashMap<String, List<Long>> hContratos;
		HashMap<String, List<Long>> hPersonas;

		// Dependiendo de si la generaci�n es de recuperaci�n de seguimiento
		if (expedienteRecuperacion) {
			hContratos = obtenerContratosGeneracionExpediente(idContrato,
					idPersona, ambitoExpediente.getCodigo(), limiteContratos,
					marca);
			hPersonas = obtenerPersonasDeContratos(idPersona, idContrato,
					hContratos);
			// hPersonas = obtenerPersonasDeContratos(idContrato, idPersona,
			// hContratos);

		} else {
			validarPersonaPase(idPersona);

			hPersonas = obtenerPersonasGeneracionExpediente(idPersona,
					ambitoExpediente.getCodigo(), limitePersonas);
			hContratos = obtenerContratosDePersonas(idPersona, idContrato,
					hPersonas);
		}

		List<ExpedienteContrato> contratos = setearContratosExpediente(
				idContrato, hContratos, expediente, limiteContratos);
		List<ExpedientePersona> personas = setearPersonasExpediente(idPersona,
				hPersonas, expediente, limitePersonas);

		expediente.setContratos(contratos);
		expediente.setPersonas(personas);
	}
	
	/**
	 * Recupera el m�ximo de personas adicionales para un expediente. Si no
	 * existe valor en la BBDD informa el error y usa el valor 20 por defecto
	 * 
	 * @return Integer
	 */
	private Integer getLimitePersonasAdicionales() {
		try {
			Parametrizacion param = (Parametrizacion) executor
					.execute(
							ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
							Parametrizacion.LIMITE_PERSONAS_ADICIONALES);
			return Integer.valueOf(param.getValor());
		} catch (ParametrizationException e) {
			logger
					.warn("No esta parametrizada la cantidad maxima de personas por expediente, se toma un valor por default");
			return Integer.valueOf("10");
		}
	}
	
	/**
	 * setea el estado del expediente.
	 * 
	 * @param expediente
	 *            expediente
	 */
	private void setEstadoExpediente(Expediente expediente) {

		DDEstadoItinerario estado = (DDEstadoItinerario) executor.execute(
				ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE,
				DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
		expediente.setEstadoItinerario(estado);
		expediente.setFechaEstado(new Date());
	}
	
	/**
	 * Borra todos los clientes relacionados.
	 * 
	 * @param expediente
	 *            expediente
	 * @param idInvocacion
	 *            id proceso bpm original
	 */
	@SuppressWarnings("unchecked")
	private void eliminarProcesosClientesRelacionados(Expediente expediente,
			Long idInvocacion) {

		// Borramos clientes por contrato
		for (ExpedienteContrato expContrato : expediente.getContratos()) {
			Long idContrato = expContrato.getContrato().getId();
			List<Cliente> clientes = (List<Cliente>) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_BUSCAR_CLIENTES_POR_CONTRATO, idContrato);
			for (Cliente cliente : clientes) {
				// AHORA EN NINGÚN CASO SE CREA BPM PARA EL CLIENTE
				/*
				if (!Checks.esNulo(idInvocacion) && !Checks.esNulo(cliente.getProcessBPM())
						&& !cliente.getProcessBPM().equals(idInvocacion)) {
					executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS,cliente.getProcessBPM());
				} else if (cliente.getProcessBPM() == null) {
				
//						&& EstadoCliente.ESTADO_CLIENTE_MANUAL.equals(cliente
//								.getEstadoCliente().getCodigo())) {
					// En caso de que se hayan generado manualmente
					executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE, cliente.getId());
				}*/
				executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE, cliente.getId());
			}
		}

		// Borramos clientes por personas
		for (ExpedientePersona expPersona : expediente.getPersonas()) {
			Cliente cliente = expPersona.getPersona().getClienteActivo();

			if (cliente != null) {
				// AHORA EN NINGÚN CASO SE CREA BPM PARA EL CLIENTE
				/*
				if (!Checks.esNulo(idInvocacion) && !Checks.esNulo(cliente.getProcessBPM())
						&& !cliente.getProcessBPM().equals(idInvocacion)) {
					executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, cliente.getProcessBPM());
				} else if (cliente.getProcessBPM() == null
						&& EstadoCliente.ESTADO_CLIENTE_MANUAL.equals(cliente
								.getEstadoCliente().getCodigo())) {
					// En caso de que se hayan generado manualmente
					executor
							.execute(
									PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE,
									cliente.getId());
				}
				*/
				executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE,cliente.getId());
			}
		}
	}
	
	/**
	 * M�todo para setearle el nombre a un expediente en funci�n del nombre del
	 * primer titular.
	 * 
	 * @param expediente
	 *            Expediente al que debemos setearle el nombre
	 */
	private void setearNombreExpediente(Expediente expediente) {
		Persona persona = expediente.getContratoPase().getPrimerTitular();

		if (persona == null || persona.getApellidoNombre() == null
				|| persona.getApellidoNombre().trim().length() == 0) {
			expediente.setDescripcionExpediente("EXP_CNT_"
					+ expediente.getContratoPase().getCodigoContrato());
		} else {
			expediente.setDescripcionExpediente(persona.getApellidoNombre());
		}
	}
	
	/**
	 * Método para setearle el nombre a un expediente si tenemos la persona principal, 
	 * sino utiliza el método anterior.
	 * @param expediente
	 * @param persona
	 */
	private void setearNombreExpediente(Expediente expediente, Long idPersona) {
		Persona persona = proxyFactory.proxy(PersonaApi.class).get(idPersona);
		if (persona == null || persona.getApellidoNombre() == null
				|| persona.getApellidoNombre().trim().length() == 0) {
			setearNombreExpediente(expediente);
		} else {
			expediente.setDescripcionExpediente(persona.getApellidoNombre());
		}
	}
	/**
	 * Recupera el m�ximo de contratos adicionales para un expediente. Si no
	 * existe valor en la BBDD informa el error y usa el valor 20 por defecto
	 * 
	 * @return Integer
	 */
	private Integer getLimiteContratosAdicionales() {
		try {
			Parametrizacion param = (Parametrizacion) executor
					.execute(
							ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
							Parametrizacion.LIMITE_CONTRATOS_ADICIONALES);
			return Integer.valueOf(param.getValor());
		} catch (Exception e) {
			logger
					.warn("No esta parametrizada la cantidad maxima de contratos por expediente, se toma un valor por default");
			return Integer.valueOf("20");
		}
	}
	
	/**
	 * Retorna todos los contratos de todos los intervinientes y sus relaciones
	 * dependiendo del ambito del expediente.
	 * 
	 * @param idContrato
	 *            Long con el id del contrato de pase
	 * @param idPersona
	 *            Long con el id de la persona de pase
	 * @param ambitoExpediente
	 *            String con el c�digo del �mbito del expediente
	 * @return List
	 */
	private HashMap<String, List<Long>> obtenerContratosGeneracionExpediente(
			Long idContrato, Long idPersona, String ambitoExpediente,
			Integer cantidadMaxima, EXTInfoAdicionalItinerarioInfo marca) {
		HashMap<String, List<Long>> hContratos = new HashMap<String, List<Long>>(
				3);
		List<Long> contratosExpediente = new ArrayList<Long>();
		contratosExpediente.add(idContrato);

		List<Long> contratosPase = new ArrayList<Long>(1);
		contratosPase.add(idContrato);
		hContratos.put(MAP_CONTRATOS_PASE, contratosPase);

		try {
			// Si debemos de insertar s�lamente los contratos marcados
			if ((contratosExpediente.size() < cantidadMaxima)
					&& EXTExpedienteApi.AMBITO_EXPEDIENTE_CONTRATOS_MARCADOS
							.equals(ambitoExpediente)) {
				if (Checks.esNulo(marca)) {
					throw new BusinessOperationException(
							"no hay marca de acumulaci�n de contratos para este itinerario");
				} else {
					EXTInfoAdicionalContratoInfo iac = proxyFactory.proxy(
							EXTContratoApi.class).getInfoAdicionalContratoByTipo(
							idContrato, marca.getValue());
					if (!Checks.esNulo(iac)) {

						List<Long> contratosTemporal = proxyFactory.proxy(
								EXTContratoApi.class)
								.findIdContratosConInfoAdicional(iac);
						hContratos.put(MAP_CONTRATOS_MARCADOS,
								getListaRecortada(cantidadMaxima,
										contratosExpediente.size(),
										contratosTemporal));
						agregaContratosLista(cantidadMaxima, contratosTemporal,
								contratosExpediente);
					}
				}
			}
			// Si debemos recuperar los contratos del grupo
			if ((contratosExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.CONTRATOS_GRUPO
							.equals(ambitoExpediente)
							|| DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION
									.equals(ambitoExpediente) || DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION
							.equals(ambitoExpediente))) {

				List<Long> contratosTemporal = expedienteDao
						.obtenerContratosRelacionadosExpedienteGrupo(
								contratosExpediente, idPersona);
				hContratos.put(MAP_CONTRATOS_GRUPO, getListaRecortada(
						cantidadMaxima, contratosExpediente.size(),
						contratosTemporal));
				agregaContratosLista(cantidadMaxima, contratosTemporal,
						contratosExpediente);
			}

			// Si debemos recuperar los contratos de la primera generaci�n
			if ((contratosExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION
							.equals(ambitoExpediente) || DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION
							.equals(ambitoExpediente))) {

				List<Long> contratosTemporal = expedienteDao
						.obtenerContratosRelacionadosExpedientePrimeraGeneracion(contratosExpediente);
				hContratos.put(MAP_CONTRATOS_GENERACION_1, getListaRecortada(
						cantidadMaxima, contratosExpediente.size(),
						contratosTemporal));
				agregaContratosLista(cantidadMaxima, contratosTemporal,
						contratosExpediente);
			}

			// Si debemos recuperar los contratos de la segunda generaci�n
			if ((contratosExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION
							.equals(ambitoExpediente))) {

				List<Long> contratosTemporal = expedienteDao
						.obtenerContratosRelacionadosExpedienteSegundaGeneracion(contratosExpediente);
				hContratos.put(MAP_CONTRATOS_GENERACION_2, getListaRecortada(
						cantidadMaxima, contratosExpediente.size(),
						contratosTemporal));
				agregaContratosLista(cantidadMaxima, contratosTemporal,
						contratosExpediente);
			}

		} catch (NonRollbackException boe) {
			logger
					.info("Llegue a la maxima cantidad de contratos para un expediente, se descartan los demas. Contrato de Pase: "
							+ idContrato);
		}

		return hContratos;
	}
	
	/**
	 * Extrae de los vectores de contratos (hContratos), las personas asociadas
	 * a esos contratos y devuelve un conjunto de vectores
	 * 
	 * @param idPersona
	 * @param idContrato
	 * @param hContratos
	 * @return
	 */
	private HashMap<String, List<Long>> obtenerPersonasDeContratos(
			Long idPersona, Long idContrato,
			HashMap<String, List<Long>> hContratos) {
		HashMap<String, List<Long>> hPersonas = new HashMap<String, List<Long>>(
				4);
		List<Long> contratosPase = hContratos.get(MAP_CONTRATOS_PASE);
		List<Long> contratosMarcados = hContratos.get(MAP_CONTRATOS_MARCADOS);
		List<Long> contratosGrupo = hContratos.get(MAP_CONTRATOS_GRUPO);
		List<Long> contratosGeneracion1 = hContratos
				.get(MAP_CONTRATOS_GENERACION_1);
		List<Long> contratosGeneracion2 = hContratos
				.get(MAP_CONTRATOS_GENERACION_2);

		Integer limitePersonas = Integer.MAX_VALUE;

		if (contratosPase != null && contratosPase.size() > 0) {
			List<Long> vectorTemporal = expedienteDao
					.obtenerPersonasDeContratos(idPersona, idContrato,
							contratosPase, limitePersonas);
			hPersonas.put(MAP_PERSONAS_PASE, vectorTemporal);
		}

		if (contratosMarcados != null && contratosMarcados.size() > 0) {
			List<Long> vectorTemporal = expedienteDao
					.obtenerPersonasDeContratos(idPersona, idContrato,
							contratosPase, limitePersonas);
			hPersonas.put(MAP_PERSONAS_MARCADAS, vectorTemporal);
		}

		if (contratosGrupo != null && contratosGrupo.size() > 0) {
			List<Long> vectorTemporal = expedienteDao
					.obtenerPersonasDeContratos(idPersona, idContrato,
							contratosGrupo, limitePersonas);
			hPersonas.put(MAP_PERSONAS_GRUPO, vectorTemporal);
		}

		if (contratosGeneracion1 != null && contratosGeneracion1.size() > 0) {
			List<Long> vectorTemporal = expedienteDao
					.obtenerPersonasDeContratos(idPersona, idContrato,
							contratosGeneracion1, limitePersonas);
			hPersonas.put(MAP_PERSONAS_GENERACION_1, vectorTemporal);
		}

		if (contratosGeneracion2 != null && contratosGeneracion2.size() > 0) {
			List<Long> vectorTemporal = expedienteDao
					.obtenerPersonasDeContratos(idPersona, idContrato,
							contratosGeneracion2, limitePersonas);
			hPersonas.put(MAP_PERSONAS_GENERACION_2, vectorTemporal);
		}
		return hPersonas;
	}
	
	/**
	 * Valida que la persona no exista en un expediente activo, bloqueado o
	 * congelado de seguimiento. De ser asi lanza una excepci�n
	 * 
	 * @param idPersona
	 * @throws BusinessOperationException
	 *             contrato en otro expediente.
	 */
	private void validarPersonaPase(Long idPersona) {
		Expediente exp = expedienteDao
				.buscarExpedientesSeguimientoParaPersona(idPersona);
		if (exp != null) {
			throw new NonRollbackException(
					"expediente.persona.invalido.otroExpediente", idPersona);
		}
	}
	
	/**
	 * Retorna todas las personas intervinientes y sus relaciones dependiendo
	 * del ambito del expediente.
	 * 
	 * @param idPersona
	 *            Long con el id de la persona de pase
	 * @param ambitoExpediente
	 *            String con el c�digo del �mbito del expediente
	 * @return List
	 */
	private HashMap<String, List<Long>> obtenerPersonasGeneracionExpediente(
			Long idPersona, String ambitoExpediente, Integer cantidadMaxima) {
		HashMap<String, List<Long>> hPersonas = new HashMap<String, List<Long>>(
				3);
		List<Long> personasExpediente = new ArrayList<Long>();
		personasExpediente.add(idPersona);

		List<Long> personasPase = new ArrayList<Long>(1);
		personasPase.add(idPersona);
		hPersonas.put(MAP_PERSONAS_PASE, personasPase);

		try {

			// Si debemos recuperar las personas del grupo
			if ((personasExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.PERSONAS_GRUPO
							.equals(ambitoExpediente)
							|| DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION
									.equals(ambitoExpediente) || DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION
							.equals(ambitoExpediente))) {

				List<Long> personasTemporal = expedienteDao
						.obtenerPersonasRelacionadosExpedienteGrupo(idPersona);
				hPersonas.put(MAP_PERSONAS_GRUPO, getListaRecortada(
						cantidadMaxima, personasExpediente.size(),
						personasTemporal));
				agregaContratosLista(cantidadMaxima, personasTemporal,
						personasExpediente);
			}

			// Si debemos recuperar las personas de la primera generaci�n
			if ((personasExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION
							.equals(ambitoExpediente) || DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION
							.equals(ambitoExpediente))) {

				List<Long> personasTemporal = expedienteDao
						.obtenerPersonasRelacionadosExpedientePrimeraGeneracion(personasExpediente);
				hPersonas.put(MAP_PERSONAS_GENERACION_1, getListaRecortada(
						cantidadMaxima, personasExpediente.size(),
						personasTemporal));
				agregaContratosLista(cantidadMaxima, personasTemporal,
						personasExpediente);
			}

			// Si debemos recuperar las personas de la segunda generaci�n
			if ((personasExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION
							.equals(ambitoExpediente))) {

				List<Long> personasTemporal = expedienteDao
						.obtenerPersonasRelacionadosExpedienteSegundaGeneracion(personasExpediente);
				hPersonas.put(MAP_PERSONAS_GENERACION_2, getListaRecortada(
						cantidadMaxima, personasExpediente.size(),
						personasTemporal));
				agregaContratosLista(cantidadMaxima, personasTemporal,
						personasExpediente);
			}

		} catch (NonRollbackException boe) {
			logger
					.info("Llegue a la maxima cantidad de personas para un expediente, se descartan los demas. Persona de Pase: "
							+ idPersona);
		}

		return hPersonas;
	}
	
	/**
	 * Extrae de los vectores de personas (hPersonas), los contratos asociados a
	 * esas personas y devuelve un conjunto de vectores
	 * 
	 * @param idPersona
	 * @param idContrato
	 * @param hPersonas
	 * @return
	 */
	private HashMap<String, List<Long>> obtenerContratosDePersonas(
			Long idPersona, Long idContrato,
			HashMap<String, List<Long>> hPersonas) {
		HashMap<String, List<Long>> hContratos = new HashMap<String, List<Long>>(
				3);
		List<Long> personasPase = hPersonas.get(MAP_PERSONAS_PASE);
		List<Long> personasGrupo = hPersonas.get(MAP_PERSONAS_GRUPO);
		List<Long> personasGeneracion1 = hPersonas
				.get(MAP_PERSONAS_GENERACION_1);
		List<Long> personasGeneracion2 = hPersonas
				.get(MAP_PERSONAS_GENERACION_2);

		Integer limiteContratos = Integer.MAX_VALUE;

		if (personasPase != null && personasPase.size() > 0) {
			List<Long> vectorTemporal = expedienteDao
					.obtenerContratosDePersonas(idPersona, idContrato,
							personasPase, limiteContratos);
			hContratos.put(MAP_CONTRATOS_PASE, vectorTemporal);
		}

		if (personasGrupo != null && personasGrupo.size() > 0) {
			List<Long> vectorTemporal = expedienteDao
					.obtenerContratosDePersonas(idPersona, idContrato,
							personasGrupo, limiteContratos);
			hContratos.put(MAP_CONTRATOS_GRUPO, vectorTemporal);
		}

		if (personasGeneracion1 != null && personasGeneracion1.size() > 0) {
			List<Long> vectorTemporal = expedienteDao
					.obtenerContratosDePersonas(idPersona, idContrato,
							personasGeneracion1, limiteContratos);
			hContratos.put(MAP_CONTRATOS_GENERACION_1, vectorTemporal);
		}

		if (personasGeneracion2 != null && personasGeneracion2.size() > 0) {
			List<Long> vectorTemporal = expedienteDao
					.obtenerContratosDePersonas(idPersona, idContrato,
							personasGeneracion2, limiteContratos);
			hContratos.put(MAP_CONTRATOS_GENERACION_2, vectorTemporal);
		}
		return hContratos;
	}
	
	/**
	 * setea los contratos de un expediente.
	 * 
	 * @param contratoPrincipal
	 *            contrato principal
	 * @param contratosAdicionales
	 *            contratos adicionales.
	 * @param expediente
	 *            expediente
	 * @return lista de contratos
	 */
	private List<ExpedienteContrato> setearContratosExpediente(
			Long contratoPrincipal, HashMap<String, List<Long>> hContratos,
			Expediente expediente, Integer cantidadMaxima) {
		/*
		 * En este m�todo es necesario crear expl�citamente un objeto de
		 * auditor�a poruqe los objetos ExpedienteContrato se salvan
		 * indirectamente al salvar el expediente, por lo tanto nunca se ejecuta
		 * el save de su dao, que es el que deber�a crear el obj de
		 * auditor�a. No se puede llamar al save del dao de ExpedienteContrato
		 * porque todav�a no existe el Expediente al cual asociarlo.
		 */
		List<Long> contratosPase = new ArrayList<Long>(1);
		List<Long> contratosMarcados = hContratos.get(MAP_CONTRATOS_MARCADOS);
		List<Long> contratosPaseAux = hContratos.get(MAP_CONTRATOS_PASE);
		List<Long> contratosGrupo = hContratos.get(MAP_CONTRATOS_GRUPO);
		List<Long> contratosGeneracion1 = hContratos
				.get(MAP_CONTRATOS_GENERACION_1);
		List<Long> contratosGeneracion2 = hContratos
				.get(MAP_CONTRATOS_GENERACION_2);

		contratosPase.add(contratoPrincipal);
		if (contratosMarcados == null)
			contratosMarcados = new ArrayList<Long>(0);
		if (contratosPaseAux == null)
			contratosPaseAux = new ArrayList<Long>(0);
		if (contratosGrupo == null)
			contratosGrupo = new ArrayList<Long>(0);
		if (contratosGeneracion1 == null)
			contratosGeneracion1 = new ArrayList<Long>(0);
		if (contratosGeneracion2 == null)
			contratosGeneracion2 = new ArrayList<Long>(0);

		int size = 1 + contratosMarcados.size() + contratosPaseAux.size()
				+ contratosGrupo.size() + contratosGeneracion1.size()
				+ contratosGeneracion2.size();
		List<Long> controlDuplicados = new ArrayList<Long>(size);
		List<ExpedienteContrato> contratos = new ArrayList<ExpedienteContrato>(
				size);

		// Seteamos los cuatro niveles de contratos
		DDAmbitoExpediente ambitoExpedientePase = (DDAmbitoExpediente) executor
				.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
						DDAmbitoExpediente.class,
						DDAmbitoExpediente.CONTRATO_PASE);

		DDAmbitoExpediente ambitoExpedienteContratosMarcados = (DDAmbitoExpediente) executor
				.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
						DDAmbitoExpediente.class,
						EXTExpedienteApi.AMBITO_EXPEDIENTE_CONTRATOS_MARCADOS);

		DDAmbitoExpediente ambitoGrupo = (DDAmbitoExpediente) executor.execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
				DDAmbitoExpediente.class, DDAmbitoExpediente.CONTRATOS_GRUPO);

		DDAmbitoExpediente ambitoGen1 = (DDAmbitoExpediente) executor.execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
				DDAmbitoExpediente.class,
				DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION);

		DDAmbitoExpediente ambitoGen2 = (DDAmbitoExpediente) executor.execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
				DDAmbitoExpediente.class,
				DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION);

		cantidadMaxima = addContratos(controlDuplicados, contratosPase,
				contratos, ambitoExpedientePase, expediente, true,
				cantidadMaxima);
		cantidadMaxima = addContratos(controlDuplicados, contratosPaseAux,
				contratos, ambitoExpedientePase, expediente, false,
				cantidadMaxima);
		cantidadMaxima = addContratos(controlDuplicados, contratosMarcados,
				contratos, ambitoExpedienteContratosMarcados, expediente,
				false, cantidadMaxima);
		cantidadMaxima = addContratos(controlDuplicados, contratosGrupo,
				contratos, ambitoGrupo, expediente, false, cantidadMaxima);
		cantidadMaxima = addContratos(controlDuplicados, contratosGeneracion1,
				contratos, ambitoGen1, expediente, false, cantidadMaxima);
		addContratos(controlDuplicados, contratosGeneracion2,
				contratos, ambitoGen2, expediente, false, cantidadMaxima);

		return contratos;
	}
	
	/**
	 * setea las personas de un expediente.
	 * 
	 * @param personaPrincipal
	 *            persona principal
	 * @param hPersonas
	 *            personas adicionales.
	 * @param expediente
	 *            expediente
	 * @return lista de personas
	 */
	private List<ExpedientePersona> setearPersonasExpediente(
			Long personaPrincipal, HashMap<String, List<Long>> hPersonas,
			Expediente expediente, Integer cantidadMaxima) {
		/*
		 * En este m�todo es necesario crear expl�citamente un objeto de
		 * auditor�a porque los objetos ExpedientePersona se salvan
		 * indirectamente al salvar el expediente, por lo tanto nunca se ejecuta
		 * el save de su dao, que es el que deber�a crear el obj de auditor�a.
		 * No se puede llamar al save del dao de ExpedientePersona porque
		 * todav�a no existe el Expediente al cual asociarlo.
		 */
		List<Long> personasPase = new ArrayList<Long>(1);
		List<Long> personasPaseAux = hPersonas.get(MAP_PERSONAS_PASE);
		List<Long> personasGrupo = hPersonas.get(MAP_PERSONAS_GRUPO);
		List<Long> personasGeneracion1 = hPersonas
				.get(MAP_PERSONAS_GENERACION_1);
		List<Long> personasGeneracion2 = hPersonas
				.get(MAP_PERSONAS_GENERACION_2);

		personasPase.add(personaPrincipal);
		if (personasPaseAux == null)
			personasPaseAux = new ArrayList<Long>(0);
		if (personasGrupo == null)
			personasGrupo = new ArrayList<Long>(0);
		if (personasGeneracion1 == null)
			personasGeneracion1 = new ArrayList<Long>(0);
		if (personasGeneracion2 == null)
			personasGeneracion2 = new ArrayList<Long>(0);

		int size = 1 + personasPaseAux.size() + personasGrupo.size()
				+ personasGeneracion1.size() + personasGeneracion2.size();
		List<Long> controlDuplicados = new ArrayList<Long>(size);
		List<ExpedientePersona> personas = new ArrayList<ExpedientePersona>(
				size);

		// Seteamos los cuatro niveles de personas
		DDAmbitoExpediente ambitoExpedientePase = (DDAmbitoExpediente) executor
				.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
						DDAmbitoExpediente.class,
						DDAmbitoExpediente.PERSONA_PASE);

		DDAmbitoExpediente ambitoGrupo = (DDAmbitoExpediente) executor.execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
				DDAmbitoExpediente.class, DDAmbitoExpediente.PERSONAS_GRUPO);

		DDAmbitoExpediente ambitoGen1 = (DDAmbitoExpediente) executor.execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
				DDAmbitoExpediente.class,
				DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION);

		DDAmbitoExpediente ambitoGen2 = (DDAmbitoExpediente) executor.execute(
				ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
				DDAmbitoExpediente.class,
				DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION);

		cantidadMaxima = addPersonas(controlDuplicados, personasPase, personas,
				ambitoExpedientePase, expediente, true, cantidadMaxima);
		cantidadMaxima = addPersonas(controlDuplicados, personasPaseAux,
				personas, ambitoExpedientePase, expediente, false,
				cantidadMaxima);
		cantidadMaxima = addPersonas(controlDuplicados, personasGrupo,
				personas, ambitoGrupo, expediente, false, cantidadMaxima);
		cantidadMaxima = addPersonas(controlDuplicados, personasGeneracion1,
				personas, ambitoGen1, expediente, false, cantidadMaxima);
		addPersonas(controlDuplicados, personasGeneracion2,
				personas, ambitoGen2, expediente, false, cantidadMaxima);

		return personas;

	}
	
	/**
	 * Recorta la lista
	 * 
	 * @param cantidadMaxima
	 * @param tamActualLista
	 * @param contratosTemp
	 * @return
	 */
	private List<Long> getListaRecortada(Integer cantidadMaxima,
			int tamActualLista, List<Long> contratosTemp) {
		List<Long> lista = new ArrayList<Long>();

		int cantTemp = contratosTemp.size();
		int cantExp = tamActualLista;
		if ((cantTemp + cantExp) > cantidadMaxima) {
			int cantPerm = cantidadMaxima - cantExp;
			for (int i = cantTemp - 1; i >= cantPerm; i--) {
				contratosTemp.remove(i);
			}
			lista.addAll(contratosTemp);
			return lista;
		} else {
			lista.addAll(contratosTemp);
			return lista;
		}
	}
	
	/**
	 * agrega contratos a la lista de contratos de expediente siempre y cuando
	 * no se pase del limite. Si se pasa lanza una BusinessOperationException
	 * para que se frene el proceso.
	 * 
	 * @param cantidadMaxima
	 *            cantidadMaxima
	 * @param contratosTemp
	 *            contratosTemp
	 * @param contratosExpediente
	 *            contratosExpediente
	 */
	private void agregaContratosLista(Integer cantidadMaxima,
			List<Long> contratosTemp, List<Long> contratosExpediente) {
		int cantTemp = contratosTemp.size();
		int cantExp = contratosExpediente.size();
		if ((cantTemp + cantExp) > cantidadMaxima) {
			int cantPerm = cantidadMaxima - cantExp;
			for (int i = cantTemp - 1; i >= cantPerm; i--) {
				contratosTemp.remove(i);
			}
			contratosExpediente.addAll(contratosTemp);
			throw new NonRollbackException("Se llego al limite de contratos");
		}
		contratosExpediente.addAll(contratosTemp);

	}
	
	/**
	 * A�ade al vectorDestino los contratos del vectorOrigen que no est�n en el
	 * 'controlDuplicados'. A esos contratos les pondr� un ambito definido
	 * 
	 * @param controlDuplicados
	 * @param vectorOrigen
	 * @param vectorDestino
	 * @param ambito
	 * @param expediente
	 * @param isPase
	 */
	private int addContratos(List<Long> controlDuplicados,
			List<Long> vectorOrigen, List<ExpedienteContrato> vectorDestino,
			DDAmbitoExpediente ambito, Expediente expediente, Boolean isPase,
			int cantidadMaxima) {
		ExpedienteContrato expCon;
		Contrato contrato;

		if (cantidadMaxima == 0)
			return cantidadMaxima;

		for (Long c : vectorOrigen) {
			if (!controlDuplicados.contains(c)) {
				controlDuplicados.add(c);

				contrato = (Contrato) executor.execute(
						PrimariaBusinessOperation.BO_CNT_MGR_GET, c);

				expCon = new ExpedienteContrato();
				expCon.setAuditoria(Auditoria.getNewInstance());
				expCon.setAmbitoExpediente(ambito);

				if (isPase) {
					expCon.setCexPase(1);
				} else {
					expCon.setCexPase(0);
				}
				expCon.setExpediente(expediente);
				expCon.setContrato(contrato);

				vectorDestino.add(expCon);
			}
			cantidadMaxima--;
			if (cantidadMaxima == 0)
				return cantidadMaxima;
		}

		return cantidadMaxima;
	}
	
	/**
	 * A�ade al vectorDestino las personas del vectorOrigen que no est�n en el
	 * 'controlDuplicados'. A esas personas les pondr� un ambito definido
	 * 
	 * @param controlDuplicados
	 * @param vectorOrigen
	 * @param vectorDestino
	 * @param ambito
	 * @param expediente
	 * @param isPase
	 */
	private int addPersonas(List<Long> controlDuplicados,
			List<Long> vectorOrigen, List<ExpedientePersona> vectorDestino,
			DDAmbitoExpediente ambito, Expediente expediente, Boolean isPase,
			int cantidadMaxima) {
		ExpedientePersona expPer;
		Persona persona;

		if (cantidadMaxima == 0)
			return cantidadMaxima;

		for (Long id : vectorOrigen) {
			if (!controlDuplicados.contains(id)) {
				controlDuplicados.add(id);

				persona = (Persona) executor.execute(
						PrimariaBusinessOperation.BO_PER_MGR_GET, id);

				expPer = new ExpedientePersona();
				expPer.setAuditoria(Auditoria.getNewInstance());

				if (isPase) {
					expPer.setPase(1);
				} else {
					expPer.setPase(0);
				}

				expPer.setAmbitoExpediente(ambito);
				expPer.setExpediente(expediente);
				expPer.setPersona(persona);
				vectorDestino.add(expPer);

				cantidadMaxima--;
				if (cantidadMaxima == 0)
					return cantidadMaxima;
			}
		}

		return cantidadMaxima;
	}

	@Override
	@BusinessOperation(BO_CORE_EXPEDIENTE_OBTENER_OFICINAS_EXP)
	public List<Oficina> getoficinasExpediente(Long id) {
	     List<Oficina> oficinas = new ArrayList<Oficina>();
	     oficinas.addAll(obtenerOficinasContratosExpediente(id));
	     return oficinas;
	}
	/***
	 * @param  idExpediente
	 * @return Lista de todas las oficinas comprendidas en los contratos del expediente y en los 
	 * 		   intervinientes de estos. 
	 */
	@SuppressWarnings("unchecked")
	private List<Oficina> obtenerOficinasContratosExpediente(Long idExpediente){
		Expediente expediente = getExpediente(idExpediente);
		List<Oficina> listaOficina=new ArrayList<Oficina>();
        for (ExpedienteContrato contrato : expediente.getContratos()) {
            Long idContrato = contrato.getContrato().getId();
            List<Cliente> clientes = (List<Cliente>) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_BUSCAR_CLIENTES_POR_CONTRATO, idContrato);
            for (Cliente cliente : clientes) {
            	Oficina oficina=cliente.getOficina();
                if (listaOficina.contains(oficina)){
                	break;
                }else{
                	listaOficina.add(oficina);
                }
            }
            Oficina oficinaContrato = contrato.getContrato().getOficina();  
            /*if (listaOficina.contains(oficinaContrato)){
            	break;
            }else{
            	listaOficina.add(oficinaContrato);
            }*/
            if (!listaOficina.contains(oficinaContrato)){
            	listaOficina.add(oficinaContrato);
            }
        }
		return listaOficina;
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_CORE_EXPEDIENTE_CAMBIAR_OFICINA_EXP)
	public void cambiarOficinaExpediente(Long idExpediente,Long idOficina) {
		Expediente exp=getExpediente(idExpediente);
		Filter filtroIdOficina= genericDao.createFilter(FilterType.EQUALS, "id", idOficina);
		Oficina ofi = genericDao.get(Oficina.class, filtroIdOficina);
		exp.setOficina(ofi);
		expedienteDao.saveOrUpdate(exp);
	}

	public ExpedienteContrato getExpedienteContratoByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		ExpedienteContrato cex = genericDao.get(ExpedienteContrato.class, filtro);
		return cex;
	}
	
	
}

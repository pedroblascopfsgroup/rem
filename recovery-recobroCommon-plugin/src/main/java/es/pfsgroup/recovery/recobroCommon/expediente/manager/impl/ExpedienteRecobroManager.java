package es.pfsgroup.recovery.recobroCommon.expediente.manager.impl;

import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.actitudAptitudActuacion.model.ActitudAptitudActuacion;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.AcuerdoContrato;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.acuerdo.model.RecobroDDTipoPalanca;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.model.EstadoCliente;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.exceptions.NonRollbackException;
import es.capgemini.pfs.exceptions.ParametrizationException;
import es.capgemini.pfs.expediente.dao.ExpedienteContratoDao;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.dao.PropuestaExpedienteManualDao;
import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.DDMotivoExpedienteManual;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.expediente.model.PropuestaExpedienteManual;
import es.capgemini.pfs.gestorEntidad.model.GestorExpediente;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.api.GestorEntidadApi;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api.RecobroAgenciaApi;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoGestionCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;
import es.pfsgroup.recovery.recobroCommon.expediente.dao.ExpedienteRecobroDao;
import es.pfsgroup.recovery.recobroCommon.expediente.dao.OficinaEmailDao;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.AcuerdoExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.DtoCreacionManualExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.EnvEmailAcuerdoDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.ExpedienteRecobroDto;
import es.pfsgroup.recovery.recobroCommon.expediente.manager.ExpedienteRecobroApi;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpediente;
import es.pfsgroup.recovery.recobroCommon.expediente.model.EnvioEmailAcuerdo;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.motivos.model.DDMotivoBaja;
import es.pfsgroup.recovery.recobroCommon.persona.model.CicloRecobroPersona;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaAcuerdosPalanca;
import es.pfsgroup.recovery.recobroCommon.utils.CorreoUtils;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.ExpedienteRecobroContants;

/**
 * Manager de la entidad expediente recobro.
 * 
 * @author Oscar
 * 
 */
@Component
public class ExpedienteRecobroManager implements ExpedienteRecobroApi {

	@Autowired
	ExpedienteRecobroDao expedienteRecobroDao;

	@Autowired
	private ExpedienteDao expedienteDao;
	
	@Autowired
	private PersonaDao personaDao;

	@Autowired
	private Executor executor;

	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	AcuerdoDao acuerdoDao;
	
	@Autowired
	DespachoExternoDao despachoDao;

	@Autowired
	private ExpedienteContratoDao expedienteContratoDao;

	@Autowired
	private PropuestaExpedienteManualDao propuestaExpedienteManualDao;

	@Autowired
	private OficinaEmailDao oficinaEmailDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	private final Log logger = LogFactory.getLog(getClass());

	private static final String MAP_CONTRATOS_PASE = "contratosPase";
	private static final String MAP_CONTRATOS_GRUPO = "contratosGrupo";
	private static final String MAP_CONTRATOS_GENERACION_1 = "contratosGeneracion1";
	private static final String MAP_CONTRATOS_GENERACION_2 = "contratosGeneracion2";

	private static final String MAP_PERSONAS_PASE = "personasPase";
	private static final String MAP_PERSONAS_GRUPO = "personasGrupo";
	private static final String MAP_PERSONAS_GENERACION_1 = "personasGeneracion1";
	private static final String MAP_PERSONAS_GENERACION_2 = "personasGeneracion2";

	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_REC_OBTENER_NUM_CONTRATOS_GENERACION_EXP_MANUAL)
	public int obtenerNumContratosGeneracionExpManual(Long idPersona) {
		List<Contrato> list = (List<Contrato>) expedienteRecobroDao.obtenerContratosPersonaParaGeneracionExpManual(idPersona);
		if (list != null) {
			return list.size();
		}

		return 0;
	}

	/**
	 * Se cancela el expediente generado manualmente a partir de un cliente.
	 * 
	 * @param idExpediente
	 *            Long: id del expediente propuesto
	 * @param idPersona
	 *            Long: id de la persona con la que se generó el expediente (y
	 *            el cliente manual)
	 */
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_REC_CANCELA_EXP_MANUAL_RECOBRO)
	@Transactional(readOnly = false)
	public void cancelacionExpManualRecobro(Long idExpediente, Long idPersona) {
		Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
		Expediente expediente = expedienteDao.get(idExpediente);
		String codigoSubtipoTarea;
		if (expediente.getGestionDeuda()) {
			codigoSubtipoTarea = "SOLEXPMGDEUDA";
		} else {
			if (expediente.getSeguimiento()) {
				codigoSubtipoTarea = "501"; // FIXME
											// SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG;
			} else {
				codigoSubtipoTarea = SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL;
			}
		}
		
		Cliente clienteActivo = persona.getClienteActivo();
		cancelacionExp(idExpediente, true);

		if (clienteActivo!=null) {
			executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA, clienteActivo.getId(), DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE, codigoSubtipoTarea);
		}
		
		PropuestaExpedienteManual propuesta = getPropuestaExpedienteManual(idExpediente);
		if (propuesta != null) {
			propuestaExpedienteManualDao.delete(propuesta);
		}
		if (clienteActivo!=null && clienteActivo.getEstadoCliente().getCodigo().equals(EstadoCliente.ESTADO_CLIENTE_MANUAL)) {
			executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE, clienteActivo.getId());
		}
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_REC_CREARF_EXP_MANUAL_RECOBRO)
	public Expediente crearExpedienteManual(Long idPersona, Long idContrato) {
		Persona persona = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", idPersona), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		// Validamos que alguien mas no haya creado un expediente
		// concurrentemente
		Boolean sinExpedientesActivos = this.sinExpedientesActivosDeUnaPersona(idPersona);

		if (!sinExpedientesActivos) {
			throw new BusinessOperationException("expediente.creacionManual.existente", persona.getApellidoNombre());
		}
		
		Long idExpedientePropuesto = personaDao.obtenerIdExpedientePropuestoPersona(idPersona);
		if(!Checks.esNulo(idExpedientePropuesto)){
			throw new BusinessOperationException("expediente.creacionManual.existente", persona.getApellidoNombre());
		}
		
		Cliente cliente = persona.getClienteActivo();
		//Obtenemos el arquetipo genérico de recobro
		Arquetipo arquetipo = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_BY_NOMBRE,Arquetipo.ARQUETIPO_GEN_RECOBRO);
		
		Long idArquetipo = (!Checks.esNulo(arquetipo) ? arquetipo.getId() : null);
		if (cliente == null) {
			//Si no se encuentra el arquetipo genérico se obtiene de la forma estandar
			if (Checks.esNulo(arquetipo)) idArquetipo = persona.getArquetipoCalculado();
			DDEstadoItinerario estado = (DDEstadoItinerario) executor.execute(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE,
	                DDEstadoItinerario.ESTADO_CREACION_MANUAL_EXPEDIENTE_RECOBRO);
			executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_CREAR_CLIENTE_W_ESTADO, idPersona, null, idArquetipo, true, estado);
		} 
		else {
			//Si no se encuentra el arquetipo genérico se obtiene de la forma estandar
			if (Checks.esNulo(arquetipo)) idArquetipo = cliente.getArquetipo().getId();
		}

		ExpedienteRecobro expediente = new ExpedienteRecobro();

		// Seteamos las personas/contratos del expediente
		setearPersonasContratosExpediente(expediente, idContrato, idPersona, idArquetipo);

		// Seteo expediente MANUAL
		expediente.setManual(true);
		// Estado Expediente = VIGILANCIA METAS VOLANTES
		setEstadoExpediente(expediente,DDEstadoItinerario.ESTADO_CREACION_MANUAL_EXPEDIENTE_RECOBRO);
		DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoExpediente.class,
				DDEstadoExpediente.ESTADO_EXPEDIENTE_PROPUESTO);

		expediente.setEstadoExpediente(estadoExpediente);
		// AAA
		// Seteo el arquetipo del expediente
		Arquetipo arq = Checks.esNulo(arquetipo) ? (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, idArquetipo) : arquetipo;
		expediente.setArquetipo(arq);
		// VRE
		// Long oficina = obtenerMayorVRE(idContrato);
		Contrato cnt = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);

		if (cnt != null) {
			Oficina ofi = cnt.getOficina();
			expediente.setOficina(ofi);
		} else {
			// No existe el cliente aun, tomo la oficina del contrato
			Contrato contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);
			expediente.setOficina(contrato.getOficina());
		}

		// Le seteamos el nombre ya que ahora no se obtiene a través de una
		// fórmula
		setearNombreExpediente(expediente);
		
		//Seteamos el tipo de expediente
		DDTipoExpediente tpx = genericDao.get(DDTipoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoExpediente.TIPO_EXPEDIENTE_RECOBRO), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		expediente.setTipoExpediente(tpx);

		expedienteDao.saveOrUpdate(expediente);

		return expediente;
	}

	public Boolean sinExpedientesActivosDeUnaPersona(Long idPersona) {
		Long nExp = 0L;

		Persona persona = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", idPersona), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (persona.getArquetipoCalculado() != null) {
			Arquetipo arq = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, persona.getArquetipoCalculado());
			Boolean isRecuperacion = arq.getItinerario().getdDtipoItinerario().getItinerarioRecuperacion();

			// Si se va a crear un expediente de recuperación
			if (isRecuperacion) {
				// Se buscan expedientes de seguimiento
				nExp = expedienteDao.getNumExpedientesActivos(persona.getId(), false);
			} else {
				// Si se crea un expediente de seguimiento se busca cualquier
				// tipo de expediente
				nExp = expedienteDao.getNumExpedientesActivos(persona.getId(), true) + expedienteDao.getNumExpedientesActivos(persona.getId(), false);
			}
		}

		return nExp.longValue() == 0;

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
	private void setearPersonasContratosExpediente(Expediente expediente, Long idContrato, Long idPersona, Long idArquetipo) {
		Arquetipo arq = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, idArquetipo);
		DDAmbitoExpediente ambitoExpediente = arq.getItinerario().getAmbitoExpediente();
		Boolean expedienteRecuperacion = arq.getItinerario().getdDtipoItinerario().getItinerarioRecuperacion();

		Integer limitePersonas = getLimitePersonasAdicionales();
		Integer limiteContratos = getLimiteContratosAdicionales();

		HashMap<String, List<Long>> hContratos;
		HashMap<String, List<Long>> hPersonas;

		// Dependiendo de si la generación es de recuperación de seguimiento
		if (expedienteRecuperacion) {
			hContratos = obtenerContratosGeneracionExpediente(idContrato, idPersona, ambitoExpediente.getCodigo(), limiteContratos);
			hPersonas = obtenerPersonasDeContratos(idPersona, idContrato, hContratos);
			// hPersonas = obtenerPersonasDeContratos(idContrato, idPersona,
			// hContratos);

		} else {
			validarPersonaPase(idPersona);

			hPersonas = obtenerPersonasGeneracionExpediente(idPersona, ambitoExpediente.getCodigo(), limitePersonas);
			hContratos = obtenerContratosDePersonas(idPersona, idContrato, hPersonas);
		}

		List<ExpedienteContrato> contratos = setearContratosExpediente(idContrato, hContratos, expediente, limiteContratos);
		List<ExpedientePersona> personas = setearPersonasExpediente(idPersona, hPersonas, expediente, limitePersonas);

		expediente.setContratos(contratos);
		expediente.setPersonas(personas);
	}

	/**
	 * Recupera el máximo de personas adicionales para un expediente. Si no
	 * existe valor en la BBDD informa el error y usa el valor 20 por defecto
	 * 
	 * @return Integer
	 */
	private Integer getLimitePersonasAdicionales() {
		try {
			Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_PERSONAS_ADICIONALES);
			return Integer.valueOf(param.getValor());
		} catch (ParametrizationException e) {
			logger.warn("No esta parametrizada la cantidad maxima de personas por expediente, se toma un valor por default");
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

		DDEstadoItinerario estado = (DDEstadoItinerario) executor.execute(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE, DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
		
		if (!Checks.esNulo(estado)) {
			expediente.setEstadoItinerario(estado);
			expediente.setFechaEstado(new Date());
		}
	}
	
	/**
	 * setea el estado del expediente pasandole el estado del itinerario
	 * @param expediente
	 * @param codItinerario
	 */
	private void setEstadoExpediente(Expediente expediente, String codItinerario) {

		DDEstadoItinerario estado = (DDEstadoItinerario) executor.execute(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE, codItinerario);
		
		if (!Checks.esNulo(estado)) {
			expediente.setEstadoItinerario(estado);
			expediente.setFechaEstado(new Date());
		}
	}

	/**
	 * método para setearle el nombre a un expediente en función del nombre del
	 * primer titular.
	 * 
	 * @param expediente
	 *            Expediente al que debemos setearle el nombre
	 */
	private void setearNombreExpediente(Expediente expediente) {
		Persona persona = expediente.getContratoPase().getPrimerTitular();

		if (persona == null || persona.getApellidoNombre() == null || persona.getApellidoNombre().trim().length() == 0) {
			expediente.setDescripcionExpediente("EXP_CNT_" + expediente.getContratoPase().getCodigoContrato());
		} else {
			expediente.setDescripcionExpediente(persona.getApellidoNombre());
		}
	}

	/**
	 * Recupera el máximo de contratos adicionales para un expediente. Si no
	 * existe valor en la BBDD informa el error y usa el valor 20 por defecto
	 * 
	 * @return Integer
	 */
	private Integer getLimiteContratosAdicionales() {
		try {
			Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_CONTRATOS_ADICIONALES);
			return Integer.valueOf(param.getValor());
		} catch (Exception e) {
			logger.warn("No esta parametrizada la cantidad maxima de contratos por expediente, se toma un valor por default");
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
	 *            String con el código del ámbito del expediente
	 * @return List
	 */
	private HashMap<String, List<Long>> obtenerContratosGeneracionExpediente(Long idContrato, Long idPersona, String ambitoExpediente, Integer cantidadMaxima) {
		HashMap<String, List<Long>> hContratos = new HashMap<String, List<Long>>(3);
		List<Long> contratosExpediente = new ArrayList<Long>();
		contratosExpediente.add(idContrato);

		List<Long> contratosPase = new ArrayList<Long>(1);
		contratosPase.add(idContrato);
		hContratos.put(MAP_CONTRATOS_PASE, contratosPase);

		try {

			// Si debemos recuperar los contratos del grupo
			if ((contratosExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.CONTRATOS_GRUPO.equals(ambitoExpediente) || DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION.equals(ambitoExpediente) || DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION
							.equals(ambitoExpediente))) {

				List<Long> contratosTemporal = expedienteDao.obtenerContratosRelacionadosExpedienteGrupo(contratosExpediente, idPersona);
				hContratos.put(MAP_CONTRATOS_GRUPO, getListaRecortada(cantidadMaxima, contratosExpediente.size(), contratosTemporal));
				agregaContratosLista(cantidadMaxima, contratosTemporal, contratosExpediente);
			}

			// Si debemos recuperar los contratos de la primera generación
			if ((contratosExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION.equals(ambitoExpediente) || DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION.equals(ambitoExpediente))) {

				List<Long> contratosTemporal = expedienteDao.obtenerContratosRelacionadosExpedientePrimeraGeneracion(contratosExpediente);
				hContratos.put(MAP_CONTRATOS_GENERACION_1, getListaRecortada(cantidadMaxima, contratosExpediente.size(), contratosTemporal));
				agregaContratosLista(cantidadMaxima, contratosTemporal, contratosExpediente);
			}

			// Si debemos recuperar los contratos de la segunda generación
			if ((contratosExpediente.size() < cantidadMaxima) && (DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION.equals(ambitoExpediente))) {

				List<Long> contratosTemporal = expedienteDao.obtenerContratosRelacionadosExpedienteSegundaGeneracion(contratosExpediente);
				hContratos.put(MAP_CONTRATOS_GENERACION_2, getListaRecortada(cantidadMaxima, contratosExpediente.size(), contratosTemporal));
				agregaContratosLista(cantidadMaxima, contratosTemporal, contratosExpediente);
			}

		} catch (NonRollbackException boe) {
			logger.info("Llegue a la maxima cantidad de contratos para un expediente, se descartan los demas. Contrato de Pase: " + idContrato);
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
	private HashMap<String, List<Long>> obtenerPersonasDeContratos(Long idPersona, Long idContrato, HashMap<String, List<Long>> hContratos) {
		HashMap<String, List<Long>> hPersonas = new HashMap<String, List<Long>>(4);
		List<Long> contratosPase = hContratos.get(MAP_CONTRATOS_PASE);
		List<Long> contratosGrupo = hContratos.get(MAP_CONTRATOS_GRUPO);
		List<Long> contratosGeneracion1 = hContratos.get(MAP_CONTRATOS_GENERACION_1);
		List<Long> contratosGeneracion2 = hContratos.get(MAP_CONTRATOS_GENERACION_2);

		Integer limitePersonas = Integer.MAX_VALUE;

		if (contratosPase != null && contratosPase.size() > 0) {
			List<Long> vectorTemporal = expedienteDao.obtenerPersonasDeContratos(idPersona, idContrato, contratosPase, limitePersonas);
			hPersonas.put(MAP_PERSONAS_PASE, vectorTemporal);
		}

		if (contratosGrupo != null && contratosGrupo.size() > 0) {
			List<Long> vectorTemporal = expedienteDao.obtenerPersonasDeContratos(idPersona, idContrato, contratosGrupo, limitePersonas);
			hPersonas.put(MAP_PERSONAS_GRUPO, vectorTemporal);
		}

		if (contratosGeneracion1 != null && contratosGeneracion1.size() > 0) {
			List<Long> vectorTemporal = expedienteDao.obtenerPersonasDeContratos(idPersona, idContrato, contratosGeneracion1, limitePersonas);
			hPersonas.put(MAP_PERSONAS_GENERACION_1, vectorTemporal);
		}

		if (contratosGeneracion2 != null && contratosGeneracion2.size() > 0) {
			List<Long> vectorTemporal = expedienteDao.obtenerPersonasDeContratos(idPersona, idContrato, contratosGeneracion2, limitePersonas);
			hPersonas.put(MAP_PERSONAS_GENERACION_2, vectorTemporal);
		}
		return hPersonas;
	}

	/**
	 * Valida que la persona no exista en un expediente activo, bloqueado o
	 * congelado de seguimiento. De ser asi lanza una excepción
	 * 
	 * @param idPersona
	 * @throws BusinessOperationException
	 *             contrato en otro expediente.
	 */
	private void validarPersonaPase(Long idPersona) {
		Expediente exp = expedienteDao.buscarExpedientesSeguimientoParaPersona(idPersona);
		if (exp != null) {
			throw new NonRollbackException("expediente.persona.invalido.otroExpediente", idPersona);
		}
	}

	/**
	 * Retorna todas las personas intervinientes y sus relaciones dependiendo
	 * del ambito del expediente.
	 * 
	 * @param idPersona
	 *            Long con el id de la persona de pase
	 * @param ambitoExpediente
	 *            String con el código del ámbito del expediente
	 * @return List
	 */
	private HashMap<String, List<Long>> obtenerPersonasGeneracionExpediente(Long idPersona, String ambitoExpediente, Integer cantidadMaxima) {
		HashMap<String, List<Long>> hPersonas = new HashMap<String, List<Long>>(3);
		List<Long> personasExpediente = new ArrayList<Long>();
		personasExpediente.add(idPersona);

		List<Long> personasPase = new ArrayList<Long>(1);
		personasPase.add(idPersona);
		hPersonas.put(MAP_PERSONAS_PASE, personasPase);

		try {

			// Si debemos recuperar las personas del grupo
			if ((personasExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.PERSONAS_GRUPO.equals(ambitoExpediente) || DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION.equals(ambitoExpediente) || DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION
							.equals(ambitoExpediente))) {

				List<Long> personasTemporal = expedienteDao.obtenerPersonasRelacionadosExpedienteGrupo(idPersona);
				hPersonas.put(MAP_PERSONAS_GRUPO, getListaRecortada(cantidadMaxima, personasExpediente.size(), personasTemporal));
				agregaContratosLista(cantidadMaxima, personasTemporal, personasExpediente);
			}

			// Si debemos recuperar las personas de la primera generación
			if ((personasExpediente.size() < cantidadMaxima)
					&& (DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION.equals(ambitoExpediente) || DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION.equals(ambitoExpediente))) {

				List<Long> personasTemporal = expedienteDao.obtenerPersonasRelacionadosExpedientePrimeraGeneracion(personasExpediente);
				hPersonas.put(MAP_PERSONAS_GENERACION_1, getListaRecortada(cantidadMaxima, personasExpediente.size(), personasTemporal));
				agregaContratosLista(cantidadMaxima, personasTemporal, personasExpediente);
			}

			// Si debemos recuperar las personas de la segunda generación
			if ((personasExpediente.size() < cantidadMaxima) && (DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION.equals(ambitoExpediente))) {

				List<Long> personasTemporal = expedienteDao.obtenerPersonasRelacionadosExpedienteSegundaGeneracion(personasExpediente);
				hPersonas.put(MAP_PERSONAS_GENERACION_2, getListaRecortada(cantidadMaxima, personasExpediente.size(), personasTemporal));
				agregaContratosLista(cantidadMaxima, personasTemporal, personasExpediente);
			}

		} catch (NonRollbackException boe) {
			logger.info("Llegue a la maxima cantidad de personas para un expediente, se descartan los demas. Persona de Pase: " + idPersona);
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
	private HashMap<String, List<Long>> obtenerContratosDePersonas(Long idPersona, Long idContrato, HashMap<String, List<Long>> hPersonas) {
		HashMap<String, List<Long>> hContratos = new HashMap<String, List<Long>>(3);
		List<Long> personasPase = hPersonas.get(MAP_PERSONAS_PASE);
		List<Long> personasGrupo = hPersonas.get(MAP_PERSONAS_GRUPO);
		List<Long> personasGeneracion1 = hPersonas.get(MAP_PERSONAS_GENERACION_1);
		List<Long> personasGeneracion2 = hPersonas.get(MAP_PERSONAS_GENERACION_2);

		Integer limiteContratos = Integer.MAX_VALUE;

		if (personasPase != null && personasPase.size() > 0) {
			List<Long> vectorTemporal = expedienteDao.obtenerContratosDePersonas(idPersona, idContrato, personasPase, limiteContratos);
			hContratos.put(MAP_CONTRATOS_PASE, vectorTemporal);
		}

		if (personasGrupo != null && personasGrupo.size() > 0) {
			List<Long> vectorTemporal = expedienteDao.obtenerContratosDePersonas(idPersona, idContrato, personasGrupo, limiteContratos);
			hContratos.put(MAP_CONTRATOS_GRUPO, vectorTemporal);
		}

		if (personasGeneracion1 != null && personasGeneracion1.size() > 0) {
			List<Long> vectorTemporal = expedienteDao.obtenerContratosDePersonas(idPersona, idContrato, personasGeneracion1, limiteContratos);
			hContratos.put(MAP_CONTRATOS_GENERACION_1, vectorTemporal);
		}

		if (personasGeneracion2 != null && personasGeneracion2.size() > 0) {
			List<Long> vectorTemporal = expedienteDao.obtenerContratosDePersonas(idPersona, idContrato, personasGeneracion2, limiteContratos);
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
	private List<ExpedienteContrato> setearContratosExpediente(Long contratoPrincipal, HashMap<String, List<Long>> hContratos, Expediente expediente, Integer cantidadMaxima) {
		/*
		 * En este método es necesario crear explícitamente un objeto de
		 * auditoría poruqe los objetos ExpedienteContrato se salvan
		 * indirectamente al salvar el expediente, por lo tanto nunca se ejecuta
		 * el save de su dao, que es el que debería crear el obj de auditoría.
		 * No se puede llamar al save del dao de ExpedienteContrato porque
		 * todavía no existe el Expediente al cual asociarlo.
		 */
		List<Long> contratosPase = new ArrayList<Long>(1);
		List<Long> contratosPaseAux = hContratos.get(MAP_CONTRATOS_PASE);
		List<Long> contratosGrupo = hContratos.get(MAP_CONTRATOS_GRUPO);
		List<Long> contratosGeneracion1 = hContratos.get(MAP_CONTRATOS_GENERACION_1);
		List<Long> contratosGeneracion2 = hContratos.get(MAP_CONTRATOS_GENERACION_2);

		contratosPase.add(contratoPrincipal);
		if (contratosPaseAux == null)
			contratosPaseAux = new ArrayList<Long>(0);
		if (contratosGrupo == null)
			contratosGrupo = new ArrayList<Long>(0);
		if (contratosGeneracion1 == null)
			contratosGeneracion1 = new ArrayList<Long>(0);
		if (contratosGeneracion2 == null)
			contratosGeneracion2 = new ArrayList<Long>(0);

		int size = 1 + contratosPaseAux.size() + contratosGrupo.size() + contratosGeneracion1.size() + contratosGeneracion2.size();
		List<Long> controlDuplicados = new ArrayList<Long>(size);
		List<ExpedienteContrato> contratos = new ArrayList<ExpedienteContrato>(size);

		// Seteamos los cuatro niveles de contratos
		DDAmbitoExpediente ambitoExpedientePase = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class, DDAmbitoExpediente.CONTRATO_PASE);

		DDAmbitoExpediente ambitoGrupo = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class, DDAmbitoExpediente.CONTRATOS_GRUPO);

		DDAmbitoExpediente ambitoGen1 = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class,
				DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION);

		DDAmbitoExpediente ambitoGen2 = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class,
				DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION);

		cantidadMaxima = addContratos(controlDuplicados, contratosPase, contratos, ambitoExpedientePase, expediente, true, cantidadMaxima);
		cantidadMaxima = addContratos(controlDuplicados, contratosPaseAux, contratos, ambitoExpedientePase, expediente, false, cantidadMaxima);
		cantidadMaxima = addContratos(controlDuplicados, contratosGrupo, contratos, ambitoGrupo, expediente, false, cantidadMaxima);
		cantidadMaxima = addContratos(controlDuplicados, contratosGeneracion1, contratos, ambitoGen1, expediente, false, cantidadMaxima);
		cantidadMaxima = addContratos(controlDuplicados, contratosGeneracion2, contratos, ambitoGen2, expediente, false, cantidadMaxima);

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
	private List<ExpedientePersona> setearPersonasExpediente(Long personaPrincipal, HashMap<String, List<Long>> hPersonas, Expediente expediente, Integer cantidadMaxima) {
		/*
		 * En este método es necesario crear explícitamente un objeto de
		 * auditoría porque los objetos ExpedientePersona se salvan
		 * indirectamente al salvar el expediente, por lo tanto nunca se ejecuta
		 * el save de su dao, que es el que debería crear el obj de auditoría.
		 * No se puede llamar al save del dao de ExpedientePersona porque
		 * todavía no existe el Expediente al cual asociarlo.
		 */
		List<Long> personasPase = new ArrayList<Long>(1);
		List<Long> personasPaseAux = hPersonas.get(MAP_PERSONAS_PASE);
		List<Long> personasGrupo = hPersonas.get(MAP_PERSONAS_GRUPO);
		List<Long> personasGeneracion1 = hPersonas.get(MAP_PERSONAS_GENERACION_1);
		List<Long> personasGeneracion2 = hPersonas.get(MAP_PERSONAS_GENERACION_2);

		personasPase.add(personaPrincipal);
		if (personasPaseAux == null)
			personasPaseAux = new ArrayList<Long>(0);
		if (personasGrupo == null)
			personasGrupo = new ArrayList<Long>(0);
		if (personasGeneracion1 == null)
			personasGeneracion1 = new ArrayList<Long>(0);
		if (personasGeneracion2 == null)
			personasGeneracion2 = new ArrayList<Long>(0);

		int size = 1 + personasPaseAux.size() + personasGrupo.size() + personasGeneracion1.size() + personasGeneracion2.size();
		List<Long> controlDuplicados = new ArrayList<Long>(size);
		List<ExpedientePersona> personas = new ArrayList<ExpedientePersona>(size);

		// Seteamos los cuatro niveles de personas
		DDAmbitoExpediente ambitoExpedientePase = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class, DDAmbitoExpediente.PERSONA_PASE);

		DDAmbitoExpediente ambitoGrupo = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class, DDAmbitoExpediente.PERSONAS_GRUPO);

		DDAmbitoExpediente ambitoGen1 = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class,
				DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION);

		DDAmbitoExpediente ambitoGen2 = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class,
				DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION);

		cantidadMaxima = addPersonas(controlDuplicados, personasPase, personas, ambitoExpedientePase, expediente, true, cantidadMaxima);
		cantidadMaxima = addPersonas(controlDuplicados, personasPaseAux, personas, ambitoExpedientePase, expediente, false, cantidadMaxima);
		cantidadMaxima = addPersonas(controlDuplicados, personasGrupo, personas, ambitoGrupo, expediente, false, cantidadMaxima);
		cantidadMaxima = addPersonas(controlDuplicados, personasGeneracion1, personas, ambitoGen1, expediente, false, cantidadMaxima);
		cantidadMaxima = addPersonas(controlDuplicados, personasGeneracion2, personas, ambitoGen2, expediente, false, cantidadMaxima);

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
	private List<Long> getListaRecortada(Integer cantidadMaxima, int tamActualLista, List<Long> contratosTemp) {
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
	 * Añade al vectorDestino las personas del vectorOrigen que no estén en el
	 * 'controlDuplicados'. A esas personas les pondrá un ambito definido
	 * 
	 * @param controlDuplicados
	 * @param vectorOrigen
	 * @param vectorDestino
	 * @param ambito
	 * @param expediente
	 * @param isPase
	 */
	private int addPersonas(List<Long> controlDuplicados, List<Long> vectorOrigen, List<ExpedientePersona> vectorDestino, DDAmbitoExpediente ambito, Expediente expediente, Boolean isPase,
			int cantidadMaxima) {
		ExpedientePersona expPer;
		Persona persona;

		if (cantidadMaxima == 0)
			return cantidadMaxima;

		for (Long id : vectorOrigen) {
			if (!controlDuplicados.contains(id)) {
				controlDuplicados.add(id);

				persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, id);

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
	private void agregaContratosLista(Integer cantidadMaxima, List<Long> contratosTemp, List<Long> contratosExpediente) {
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
	 * Añade al vectorDestino los contratos del vectorOrigen que no estén en el
	 * 'controlDuplicados'. A esos contratos les pondrá un ambito definido
	 * 
	 * @param controlDuplicados
	 * @param vectorOrigen
	 * @param vectorDestino
	 * @param ambito
	 * @param expediente
	 * @param isPase
	 */
	private int addContratos(List<Long> controlDuplicados, List<Long> vectorOrigen, List<ExpedienteContrato> vectorDestino, DDAmbitoExpediente ambito, Expediente expediente, Boolean isPase,
			int cantidadMaxima) {
		ExpedienteContrato expCon;
		Contrato contrato;

		if (cantidadMaxima == 0)
			return cantidadMaxima;

		for (Long c : vectorOrigen) {
			if (!controlDuplicados.contains(c)) {
				controlDuplicados.add(c);

				contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, c);

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
	 * Devuelve un expediente a partir de su id.
	 * 
	 * @param idExpediente
	 *            el id del expediente
	 * @return El expediente
	 */
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_GET_BY_ID)
	public Expediente getExpediente(Long idExpediente) {
		EventFactory.onMethodStart(this.getClass());
		return expedienteDao.get(idExpediente);
	}

	/**
	 * obtiene la propuesta de expediente manual activa.
	 * 
	 * @param idExpediente
	 *            id expediente
	 * @return propuesta
	 */
	public PropuestaExpedienteManual getPropuestaExpedienteManual(Long idExpediente) {
		return propuestaExpedienteManualDao.getPropuestaDelExpediente(idExpediente);
	}

	/**
	 * Se cancela el expediente.
	 * 
	 * @param idExpediente
	 *            id
	 * @param conNotificacion
	 *            conNotificacion
	 */
	@BusinessOperation(overrides = InternaBusinessOperation.BO_EXP_MGR_CANCELACION_EXPEDIENTE)
	@Transactional(readOnly = false)
	public void cancelacionExp(Long idExpediente, boolean conNotificacion) {
		Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);

		// Si es un expediente de recobro, cancelamos los ciclos de recobro.
		if (exp instanceof ExpedienteRecobro) {
			this.cancelaCiclosRecobro((ExpedienteRecobro) exp);
		}

		DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoExpediente.class,
				DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO);
		exp.setEstadoExpediente(estadoExpediente);
		// expedienteDao.delete(exp);
		// for (ExpedienteContrato ec : exp.getContratos()){
		// expedienteContratoDao.delete(ec);
		// }
		executor.execute(InternaBusinessOperation.BO_EXP_MGR_SAVE_OR_UPDATE, exp);
		// Borrar todas las tareas asociadas y bpms
		if (exp.getProcessBpm() != null) {
			executor.execute(ComunBusinessOperation.BO_JBPM_MGR_MANDAR_A_FIN_PROCESS, exp.getProcessBpm());
		}

		executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_EXPEDIENTE, exp.getId());

		if (conNotificacion) {
			// Crea una notificacion para el gestor para que sepa q se cancelo
			// el expediente
			executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_CERRADO, null);
		}
		executor.execute(ComunBusinessOperation.BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD_ELIMINADA, exp.getId(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
	}

	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_REC_GETEXPEDIENTE)
	public ExpedienteRecobro getExpedienteRecobro(Long id) {
		return expedienteRecobroDao.get(id);
	}

	/**
	 * Cancela los ciclos de recobro de un expediente.
	 * 
	 * @param exp
	 */
	@Transactional(readOnly = false)
	private void cancelaCiclosRecobro(ExpedienteRecobro exp) {
		CicloRecobroExpediente cre = exp.getCicloRecobroActivo();
		if (cre != null) {
			this.cancelaCiclosRecobroPersona(cre);
			this.cancelaCiclosRecobroContrato(cre);
			cre.setFechaBaja(new Date());
			genericDao.save(CicloRecobroExpediente.class, cre);
		}
	}

	/**
	 * Cancela los ciclos de recobro de Contrato de un Ciclo de recobro de un
	 * expediente.
	 * 
	 * @param cre
	 *            CicloRecobroExpediente
	 */
	@Transactional(readOnly = false)
	private void cancelaCiclosRecobroContrato(CicloRecobroExpediente cre) {
		List<CicloRecobroContrato> listado = genericDao.getList(CicloRecobroContrato.class, genericDao.createFilter(FilterType.EQUALS, "cicloRecobroExpediente.id", cre.getId()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		for (CicloRecobroContrato crc : listado) {
			crc.setFechaBaja(new Date());
			genericDao.save(CicloRecobroContrato.class, crc);
		}

	}

	/**
	 * Cancela los ciclos de recobro de Personas de un Ciclo de recobro de un
	 * expediente.
	 * 
	 * @param cre
	 *            CicloRecobroExpediente
	 */
	@Transactional(readOnly = false)
	private void cancelaCiclosRecobroPersona(CicloRecobroExpediente cre) {
		List<CicloRecobroPersona> listado = genericDao.getList(CicloRecobroPersona.class, genericDao.createFilter(FilterType.EQUALS, "cicloRecobroExpediente.id", cre.getId()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		for (CicloRecobroPersona crp : listado) {
			crp.setFechaBaja(new Date());
			genericDao.save(CicloRecobroPersona.class, crp);
		}
	}

	/**
	 * Obtiene los modelos de facturacion distintos de ranking
	 * 
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_REC_GET_MODELO_FACTURACION)
	public List<RecobroModeloFacturacion> getModeloFacturacion() {

		List<RecobroModeloFacturacion> listado = expedienteRecobroDao.getModeloFacturacion();

		return listado;

	}

	/**
	 * propone un expediente o lo activa en caso de que sea supervisor.
	 * 
	 * @param dto
	 *            DtoCreacionManualExpediente:
	 *            <ul>
	 *            <li>idExpediente id del expediente</li>
	 *            <li>idPersona id de la persona titular del contrato que se
	 *            seleccionó para generar el pase</li>
	 *            <li>codigoMotivo motivo</li>
	 *            <li>observaciones observaciones</li>
	 *            <li>idPropuesta id propuesta manual</li>
	 *            <li>isSupervisor isSupervisor</li>
	 *            </ul>
	 */
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_MGR_PROPONER_ACTIVAR_EXPEDIENTE_RECOBRO)
	@Transactional(readOnly = false)
	public void proponerActivarExpedienteRecobro(DtoCreacionManualExpedienteRecobro dto) {
		ExpedienteRecobro exp = genericDao.get(ExpedienteRecobro.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdExpediente()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		Persona per = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, dto.getIdPersona());
		if (!dto.getIsSupervisor()) {
			// Proponiendo
			PropuestaExpedienteManual propuesta = new PropuestaExpedienteManual();
			propuesta.setExpediente(exp);

			DDMotivoExpedienteManual motivoExpedienteManual = (DDMotivoExpedienteManual) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDMotivoExpedienteManual.class,
					dto.getCodigoMotivo());
			propuesta.setMotivo(motivoExpedienteManual);
			propuesta.setObservaciones(dto.getObservaciones());

			PlazoTareasDefault plazo;
			if (exp.getSeguimiento()) {
				plazo = (PlazoTareasDefault) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO, PlazoTareasDefault.CODIGO_SOLICITUD_EXPEDIENTE_MANUAL_SEG);
			} else {
				plazo = (PlazoTareasDefault) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO, PlazoTareasDefault.CODIGO_SOLICITUD_EXPEDIENTE_MANUAL);
			}
			executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD);
			Map<String, Object> param = new HashMap<String, Object>();
			param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, per.getClienteActivo().getId());
			param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
			if (exp.getSeguimiento()) {
				// FIXME poner constante
				// param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA,
				// SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG);
				param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, "501");
			} else {
				param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL);
			}
			param.put(TareaBPMConstants.PLAZO_PROPUESTA, plazo.getPlazo());

			// Seteamos la descripcion de la tarea
			SubtipoTarea subtipoTarea;
			if (exp.getSeguimiento()) {
				subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE, SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL);
			} else {
				// FIXME poner constante
				// subtipoTarea = (SubtipoTarea)
				// executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
				// SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG);
				subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE, "501");
			}
			String descripcion = subtipoTarea.getDescripcionLarga() + ". " + propuesta.getMotivo().getDescripcionLarga() + ". " + propuesta.getObservaciones() + ".";
			if (descripcion.length() > APPConstants.TAREA_NOTIFICACION_MAX_DESCRIPCION) {
				descripcion = descripcion.substring(0, APPConstants.TAREA_NOTIFICACION_MAX_DESCRIPCION);
			}

			Long bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, TareaBPMConstants.TAREA_PROCESO, param);

			Long idTareaAsociada = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmid, TareaBPMConstants.ID_TAREA);
			TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTareaAsociada);
			// param.put(TareaBPMConstants.DESCRIPCION_TAREA, descripcion);
			tarea.setDescripcionTarea(descripcion);
			executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
			propuesta.setIdBPM(bpmid);
			propuestaExpedienteManualDao.save(propuesta);
		} else {
			if (dto.getIdPropuesta() != null && dto.getIdPropuesta() != -1) {
				// Avanza el proceso BPM de tareas genericas
				PropuestaExpedienteManual propuesta = propuestaExpedienteManualDao.get(dto.getIdPropuesta());
				executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, propuesta.getIdBPM(), TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
				propuestaExpedienteManualDao.delete(propuesta);
			}

			// activando

			DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoExpediente.class,
					DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO);
			exp.setEstadoExpediente(estadoExpediente);
			// AAA
			ActitudAptitudActuacion aaa = new ActitudAptitudActuacion();
			aaa.setAuditoria(Auditoria.getNewInstance());
			exp.setAaa(aaa);
			// Elimina los clientes si es que existieran
			eliminarProcesosClientesRelacionados(exp, null);
			executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD);
			// Crear proceso de expediente
			//Si es manual no tiene sentido que cree un proceso
//			Map<String, Object> param = new HashMap<String, Object>();
//			param.put(ExpedienteBPMConstants.EXPEDIENTE_MANUAL_ID, exp.getId());
//			param.put(ClienteBPMConstants.PERSONA_ID, per.getId());

//			Long bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, ExpedienteBPMConstants.EXPEDIENTE_PROCESO, param);
//			exp.setProcessBpm(bpmid);
			saveOrUpdate(exp);

			executor.execute(InternaBusinessOperation.BO_POL_MGR_INICIALIZAR_POLITICAS_EXPEDIENTE, exp);
		}

		this.crearCicloRecobro(exp, dto);
		this.asignarGestorDefectoAgencia(exp.getId(), dto.getAgenciaRecobro(), null);
		this.asignarGestorDefectoAgencia(exp.getId(), dto.getAgenciaRecobro(), dto.getIdSupervisor());
	}

	/**
	 * Método para asignar gestor por defecto al expediente de acuerdo a la
	 * agencia seleccionada
	 * idSupervisor Si no es nulo es supervisor, sino inserta un gestor
	 * 
	 * @param agenciaRecobro
	 */
	private void asignarGestorDefectoAgencia(Long expId, String agenciaRecobro, Long idSupervisor) {

		RecobroAgencia agencia = genericDao.get(RecobroAgencia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", agenciaRecobro),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (!Checks.esNulo(agencia)) {
			GestorEntidadDto dto = new GestorEntidadDto();

			dto.setIdEntidad(expId);
			dto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE);

			if (Checks.esNulo(idSupervisor)) {
				if (!Checks.esNulo(agencia.getGestor()))
					dto.setIdUsuario(agencia.getGestor().getId());
			} else {
				dto.setIdUsuario(idSupervisor);
			}
			if (!Checks.esNulo(agencia.getDespacho()))
				dto.setIdTipoDespacho(agencia.getDespacho().getId());

			EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", 
					(Checks.esNulo(idSupervisor) ? EXTDDTipoGestor.CODIGO_TIPO_GESTOR_AGENCIA_RECOBRO : EXTDDTipoGestor.CODIGO_TIPO_SUPERVISOR_AGENCIA_RECOBRO)),
					genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			if (!Checks.esNulo(tipoGestor))
				dto.setIdTipoGestor(tipoGestor.getId());

			proxyFactory.proxy(GestorEntidadApi.class).insertarGestorAdicionalEntidad(dto);
		}

	}
	

	/**
	 * Da de alta los ciclos de recobro de un expediente.
	 * 
	 * @param exp
	 *            ExpedienteRecobro
	 * @param dto
	 * 
	 */
	@Transactional(readOnly = false)
	private void crearCicloRecobro(ExpedienteRecobro exp, DtoCreacionManualExpedienteRecobro dto) {

		CicloRecobroExpediente cre = new CicloRecobroExpediente();
		cre.setExpediente(exp);
		cre.setFechaAlta(new Date());
		cre.setMarcadoBpm(false);
		cre.setAuditoria(Auditoria.getNewInstance());

		RecobroDDTipoGestionCartera tgc = genericDao.get(RecobroDDTipoGestionCartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoRiesgo()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		cre.setTipoGestionCartera(tgc);

		RecobroAgencia age = genericDao.get(RecobroAgencia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getAgenciaRecobro()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		cre.setAgencia(age);

		RecobroModeloFacturacion modelo = genericDao.get(RecobroModeloFacturacion.class, genericDao.createFilter(FilterType.EQUALS, "nombre", dto.getModeloFacturacion()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		cre.setModeloFacturacion(modelo);
		
		//BCFI-587
		//Esquema
		RecobroEsquema esquema = genericDao.get(RecobroEsquema.class, genericDao.createFilter(FilterType.EQUALS, "nombre", "Expedientes manuales"));
		cre.setEsquema(esquema);
		
		//CarteraEsquema
		RecobroCarteraEsquema carteraEsquema = genericDao.get(RecobroCarteraEsquema.class, genericDao.createFilter(FilterType.EQUALS, "esquema.nombre", "Expedientes manuales"),
				genericDao.createFilter(FilterType.EQUALS, "cartera.nombre", "EXPEDIENTES MANUALES"));
		cre.setCarteraEsquema(carteraEsquema);

		//SubCartera
		RecobroSubCartera subcartera = null;
		if (carteraEsquema!=null){
			subcartera = genericDao.get(RecobroSubCartera.class, genericDao.createFilter(FilterType.EQUALS, "carteraEsquema.id", carteraEsquema.getId()));
		}
		cre.setSubcartera(subcartera);
		
		//SubCarteraAgencia
		RecobroSubcarteraAgencia subCarteraAgencia = null;
		
		if( subcartera!=null && age!=null ){
			subCarteraAgencia = genericDao.get(RecobroSubcarteraAgencia.class, genericDao.createFilter(FilterType.EQUALS, "subCartera.id", subcartera.getId()),
												genericDao.createFilter(FilterType.EQUALS, "agencia.id", age.getId()));
		}
		cre.setSubCarteraAgencia(subCarteraAgencia);

		genericDao.save(CicloRecobroExpediente.class, cre);

		List<CicloRecobroContrato> crcList = this.crearCicloRecobroContrato(cre);
		this.crearCicloRecobroPersona(cre);

		if (Checks.estaVacio(cre.getCiclosRecobroContrato())) {
			cre.setCiclosRecobroContrato(crcList);
		} else {
			cre.getCiclosRecobroContrato().addAll(crcList);
		}
		modificarDatosEconomicosCRE(cre);

	}

	@Transactional(readOnly = false)
	private void modificarDatosEconomicosCRE(CicloRecobroExpediente cre) {
		List<CicloRecobroContrato> listCrc = cre.getCiclosRecobroContrato();

		if (!Checks.esNulo(cre.getCiclosRecobroContrato())) {
			Float posVivaNoVencida = new Float(0);
			Float posVivaVencida = new Float(0);
			Float intOrdinarios = new Float(0);
			Float intMoratorios = new Float(0);
			Float comisiones = new Float(0);
			Float gastos = new Float(0);
			Float impuestos = new Float(0);

			for (CicloRecobroContrato crc : listCrc) {
				// sumatorio, sólo los ciclos activos.
				if (crc.getFechaBaja() == null){
					posVivaNoVencida += Checks.esNulo(crc.getPosVivaNoVencida()) ? 0F : crc.getPosVivaNoVencida();
					posVivaVencida += Checks.esNulo(crc.getPosVivaVencida()) ? 0F : crc.getPosVivaVencida();
					intOrdinarios += Checks.esNulo(crc.getInteresesOrdDeven()) ? 0F : crc.getInteresesOrdDeven();
					intMoratorios += Checks.esNulo(crc.getInteresesMorDeven()) ? 0F : crc.getInteresesMorDeven();
					comisiones += Checks.esNulo(crc.getComisiones()) ? 0F : crc.getComisiones();
					gastos += Checks.esNulo(crc.getGastos()) ? 0F : crc.getGastos();
					impuestos += Checks.esNulo(crc.getImpuestos()) ? 0F : crc.getImpuestos();
				}
			}

			cre.setPosVivaNoVencida(posVivaNoVencida);
			cre.setPosVivaVencida(posVivaVencida);
			cre.setInteresesOrdDeven(intOrdinarios);
			cre.setInteresesMorDeven(intMoratorios);
			cre.setComisiones(comisiones);
			cre.setGastos(gastos);
			cre.setImpuestos(impuestos);

			genericDao.update(CicloRecobroExpediente.class, cre);
		}
	}

	/**
	 * Da de alta los ciclos de recobro de contrato de un ciclo de recobro de
	 * expediente
	 * 
	 * @param cre
	 *            CicloRecobroExpediente
	 * 
	 */
	@Transactional(readOnly = false)
	private List<CicloRecobroContrato> crearCicloRecobroContrato(CicloRecobroExpediente cre) {
		List<ExpedienteContrato> listado = genericDao.getList(ExpedienteContrato.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", cre.getExpediente().getId()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		CicloRecobroContrato crc;
		List<CicloRecobroContrato> crcList = new ArrayList<CicloRecobroContrato>();

		Calendar today = Calendar.getInstance();
		DateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		String todayStr = formatter.format(today.getTime());

		for (ExpedienteContrato cex : listado) {
			
			String idEnvioStr = String.format("%s%d", todayStr, cex.getContrato().getId());
			BigInteger idEnvio = new BigInteger(idEnvioStr);
			crc = new CicloRecobroContrato();
			crc.setCicloRecobroExpediente(cre);
			crc.setFechaAlta(new Date());
			crc.setContrato(cex.getContrato());
			crc.setIdEnvio(idEnvio);
			
			// datos económicos
			incluirDatosEconomicosContrato(crc, cex.getContrato().getLastMovimiento());

			crc.setAuditoria(Auditoria.getNewInstance());
			crcList.add(crc);
			genericDao.save(CicloRecobroContrato.class, crc);
		}

		return crcList;
	}

	/**
	 * Da de alta los ciclos de recobro de persona de un ciclo de recobro de
	 * expediente
	 * 
	 * @param cre
	 *            CicloRecobroExpediente
	 * 
	 */
	@Transactional(readOnly = false)
	private void crearCicloRecobroPersona(CicloRecobroExpediente cre) {
		List<ExpedientePersona> listado = genericDao.getList(ExpedientePersona.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", cre.getExpediente().getId()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		CicloRecobroPersona crp;
		for (ExpedientePersona pex : listado) {
			crp = new CicloRecobroPersona();
			crp.setCicloRecobroExpediente(cre);
			crp.setFechaAlta(new Date());
			crp.setPersona(pex.getPersona());
			// datos económicos
			crp.setPosVivaNoVencida(pex.getPersona().getRiesgoDirecto());
			crp.setPosVivaVencida(pex.getPersona().getRiesgoIndirecto());
			crp.setAuditoria(Auditoria.getNewInstance());

			genericDao.save(CicloRecobroPersona.class, crp);
		}

	}

	/**
	 * Incluye un contrato de un expediente.
	 * 
	 * @param dto
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation(overrides = ExpedienteRecobroContants.MEJ_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE)
	@Transactional(readOnly = false)
	public void incluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto) {

		List<Contrato> contratos = (List<Contrato>) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET_CONTRATOS_BY_ID, dto.getContratos());
		Expediente expediente = expedienteDao.get(dto.getIdExpediente());

		if (expediente instanceof ExpedienteRecobro) {
			this.incluirContratosAlExpedienteRecobro((ExpedienteRecobro) expediente, contratos);
		}

		ExpedienteContrato cex;

		Contrato contrato;
		Cliente cliente;
		for (int i = 0; i < contratos.size(); i++) {
			cex = new ExpedienteContrato();
			contrato = contratos.get(i);
			cex.setContrato(contrato);
			cex.setExpediente(expediente);
			cex.setPase(0);
			DDAmbitoExpediente ambitoExpediente = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDAmbitoExpediente.class,
					DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION);
			cex.setAmbitoExpediente(ambitoExpediente);
			expedienteContratoDao.save(cex);
			expediente.getContratos().add(cex);

			// Si el contrato es pase de algun cliente, marcamos al cliente como
			// cancelado
			// para que en la próxima carga del batch vuelva a generar el
			// cliente con el contrato
			// de pase que corresponda.
			cliente = (Cliente) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_FIND_CLIENTE_POR_CONTRATO_PASE_ID, contrato.getId());

			if (cliente != null) {
				executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLI_Y_BPM, cliente.getId());
			}

			for (ContratoPersona personaContratoInsertado : getPersonasTitularesContrato(contrato.getId())) {// for1
				if ((personaContratoInsertado.getPersona() != null) && (personaContratoInsertado.getPersona().getId() != null)) { // if1
					Boolean encontrado = false;
					for (ExpedientePersona pex : getExpedientePersonas(dto.getIdExpediente())) {// for2
						if ((pex.getPersona() != null) && pex.getPersona().getId() != null) {
							if (pex.getPersona().getId().equals(personaContratoInsertado.getPersona().getId())) {
								encontrado = true;
								break;
							}
						}
					}// for2
					if (!encontrado) {
						incluirEnExpedientePersona(expediente, personaContratoInsertado.getPersona());
						if (expediente instanceof ExpedienteRecobro) {
							this.incluirPersonaAlExpedienteRecobro((ExpedienteRecobro) expediente, personaContratoInsertado.getPersona());
						}
					}
				}// if 1

			}// for1

		}
		expedienteDao.save(expediente);
	}

	/**
	 * Incluye los contratos de un expediente de recobro.
	 * 
	 * @param idContrato
	 * @param exp
	 */
	private void incluirContratosAlExpedienteRecobro(ExpedienteRecobro exp, List<Contrato> contratos) {

		// Añadimos el crc
		CicloRecobroExpediente cre = exp.getCicloRecobroActivo();

		List<CicloRecobroContrato> crcList = new ArrayList<CicloRecobroContrato>();

		Calendar today = Calendar.getInstance();
		DateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		String todayStr = formatter.format(today.getTime());
		
		if (!Checks.esNulo(cre)) {
			if (contratos != null && contratos.size() > 0) {
				for (Contrato cnt : contratos) {
					if (isRiesgoIrregular(cnt.getLastMovimiento())) {
						
						String idEnvioStr = String.format("%s%d", todayStr, cnt.getId());
						BigInteger idEnvio = new BigInteger(idEnvioStr);
						
						CicloRecobroContrato crc = new CicloRecobroContrato();
						crc.setCicloRecobroExpediente(cre);
						crc.setFechaAlta(new Date());
						crc.setContrato(cnt);
						crc.setIdEnvio(idEnvio);
						incluirDatosEconomicosContrato(crc, cnt.getLastMovimiento());
						crc.setAuditoria(Auditoria.getNewInstance());
						genericDao.save(CicloRecobroContrato.class, crc);
						crcList.add(crc);
					}
				}
			}

			if (Checks.estaVacio(cre.getCiclosRecobroContrato())) {
				cre.setCiclosRecobroContrato(crcList);
			} else if (!cre.getCiclosRecobroContrato().containsAll(crcList)) {
				cre.getCiclosRecobroContrato().addAll(crcList);
			}
			modificarDatosEconomicosCRE(cre);
		}

	}

	private boolean isRiesgoIrregular(Movimiento mov) {

		if (mov.getComisiones() + mov.getPosVivaNoVencida() + mov.getPosVivaVencida() + mov.getGastos() + mov.getMovIntMoratorios() + mov.getMovIntRemuneratorios() + mov.getImpuestos() > 0)
			return true;
		return false;
	}

	private void incluirDatosEconomicosContrato(CicloRecobroContrato crc, Movimiento mov) {

		crc.setGastos(mov.getGastos());
		crc.setPosVivaNoVencida(mov.getPosVivaNoVencida());
		crc.setPosVivaVencida(mov.getPosVivaVencida());
		crc.setInteresesOrdDeven(mov.getMovIntRemuneratorios());
		crc.setInteresesMorDeven(mov.getMovIntMoratorios());
		crc.setComisiones(mov.getComisiones());
		crc.setImpuestos(mov.getImpuestos());

	}

	/**
	 * Incluye las personas de un expediente de recobro.
	 * 
	 * @param Persona
	 * @param exp
	 */
	private void incluirPersonaAlExpedienteRecobro(ExpedienteRecobro exp, Persona per) {

		// Añadimos el crp
		CicloRecobroExpediente crex = exp.getCicloRecobroActivo();
		if (!Checks.esNulo(crex)) {
			if (per != null) {
				CicloRecobroPersona crp = new CicloRecobroPersona();
				crp.setCicloRecobroExpediente(crex);
				crp.setFechaAlta(new Date());
				crp.setPersona(per);
				crp.setAuditoria(Auditoria.getNewInstance());
				genericDao.save(CicloRecobroPersona.class, crp);
			}
		}
	}

	private List<ExpedientePersona> getExpedientePersonas(Long idExpediente) {
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		List<ExpedientePersona> lista = genericDao.getList(ExpedientePersona.class, filtro, filtroBorrado);

		return lista;
	}

	private void incluirEnExpedientePersona(Expediente expediente, Persona persona) {
		ExpedientePersona expedientePersona = new ExpedientePersona();
		expedientePersona.setExpediente(expediente);
		expedientePersona.setPersona(persona);

		// Le asignamos el ARQUETIPO por el que se creó el expediente donde vinculamos el contrato.
		Arquetipo arq = expediente.getArquetipo();
		DDAmbitoExpediente ambitoExpediente = arq.getItinerario().getAmbitoExpediente();

		expedientePersona.setAmbitoExpediente(ambitoExpediente);
		expedientePersona.setAuditoria(Auditoria.getNewInstance());

		genericDao.save(ExpedientePersona.class, expedientePersona);

	}

	private List<ContratoPersona> getPersonasTitularesContrato(Long idContrato) {
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
		Filter filtroSoloTitulares = genericDao.createFilter(FilterType.EQUALS, "tipoIntervencion.titular", true);
		List<ContratoPersona> lista = genericDao.getList(ContratoPersona.class, filtro, filtroBorrado, filtroSoloTitulares);

		return lista;
	}

	/**
	 * Excluye un contrato de un expediente.
	 * 
	 * @param dto
	 */
	@BusinessOperation(overrides = ExpedienteRecobroContants.MEJ_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE)
	@Transactional(readOnly = false)
	public void excluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto) {

		Expediente exp = this.getExpediente(dto.getIdExpediente());

		if (exp instanceof ExpedienteRecobro) {
			this.excluirContratosAlExpedienteRecobro((ExpedienteRecobro) exp, Long.parseLong(dto.getContratos()));
		}

		Long idContrato = Long.parseLong(dto.getContratos());

		// Borramos el cex_
		ExpedienteContrato expedienteContrato = expedienteContratoDao.get(dto.getIdExpediente(), idContrato);
		expedienteContratoDao.delete(expedienteContrato);

		// Comprobamos si hay que borrar las personas de pex_ (no aparecen en
		// ningún contrato)
		for (ContratoPersona personaContratoEliminado : getPersonasContrato(idContrato)) {// for1
			if ((personaContratoEliminado.getPersona() != null) && (personaContratoEliminado.getPersona().getId() != null)) {// if
																																// 1
				Boolean encontrado = false;
				for (ExpedienteContrato contratoExpediente : getContratosExpediente(dto.getIdExpediente())) {// for2
					for (ContratoPersona personaContrato : getPersonasContrato(contratoExpediente.getContrato().getId())) {
						if ((personaContrato.getPersona() != null) && (personaContrato.getPersona().getId() != null)) {
							if (personaContrato.getPersona().getId().equals(personaContratoEliminado.getPersona().getId())) {
								encontrado = true;
								break;
							}
						}
					}
				}// for2
				if (!encontrado) {
					expedienteRecobroDao.deletePersonaExpediente(dto.getIdExpediente(), personaContratoEliminado.getPersona().getId());
					if (exp instanceof ExpedienteRecobro) {
						this.excluirPersonaAlExpedienteRecobro((ExpedienteRecobro) exp, personaContratoEliminado.getPersona().getId());
					}
				}
			}// if 1
		}// for1
	}

	private DDMotivoBaja getMotivoBajaExcluir() {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", "DESVINCULAR"); // TODO
																								// cambiar
																								// el
																								// código
																								// correcto.
		DDMotivoBaja motivoBaja = genericDao.get(DDMotivoBaja.class, filter);
		return motivoBaja;
	}

	private List<ContratoPersona> getPersonasContrato(Long idContrato) {
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);

		List<ContratoPersona> lista = genericDao.getList(ContratoPersona.class, filtro, filtroBorrado);
		return lista;
	}

	private List<ExpedienteContrato> getContratosExpediente(Long idExpediente) {
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);

		List<ExpedienteContrato> lista = genericDao.getList(ExpedienteContrato.class, filtro, filtroBorrado);

		return lista;
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
	private void eliminarProcesosClientesRelacionados(Expediente expediente, Long idInvocacion) {

		// Borramos clientes por contrato
		for (ExpedienteContrato expContrato : expediente.getContratos()) {
			Long idContrato = expContrato.getContrato().getId();
			List<Cliente> clientes = (List<Cliente>) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_BUSCAR_CLIENTES_POR_CONTRATO, idContrato);
			for (Cliente cliente : clientes) {
				if (cliente.getProcessBPM() != null && !cliente.getProcessBPM().equals(idInvocacion)) {
					executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, cliente.getProcessBPM());
				} else if (cliente.getProcessBPM() == null && EstadoCliente.ESTADO_CLIENTE_MANUAL.equals(cliente.getEstadoCliente().getCodigo())) {
					// En caso de que se hayan generado manualmente
					executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE, cliente.getId());
				}
			}
		}

		// Borramos clientes por personas
		for (ExpedientePersona expPersona : expediente.getPersonas()) {
			Cliente cliente = expPersona.getPersona().getClienteActivo();

			if (cliente != null) {
				if (cliente.getProcessBPM() != null && !cliente.getProcessBPM().equals(idInvocacion)) {
					executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, cliente.getProcessBPM());
				} else if (cliente.getProcessBPM() == null && EstadoCliente.ESTADO_CLIENTE_MANUAL.equals(cliente.getEstadoCliente().getCodigo())) {
					// En caso de que se hayan generado manualmente
					executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE, cliente.getId());
				}
			}
		}
	}

	/**
	 * Salva un expediente.
	 * 
	 * @param exp
	 *            el expediente a salvar
	 * 
	 */
	@Transactional(readOnly = false)
	public void saveOrUpdate(Expediente exp) {
		expedienteDao.saveOrUpdate(exp);
	}

	/**
	 * Excluye los contratos de un expediente de recobro.
	 * 
	 * @param idContrato
	 * @param exp
	 */
	private void excluirContratosAlExpedienteRecobro(ExpedienteRecobro exp, Long idContrato) {

		// Borramos el crc
		CicloRecobroExpediente crex = exp.getCicloRecobroActivo();
		if (!Checks.esNulo(crex)) {
			List<CicloRecobroContrato> crcList = crex.getCiclosRecobroContrato();
			if (idContrato != null && crcList != null && crcList.size() > 0) {
				for (CicloRecobroContrato crc : crcList) {
					if (crc.getFechaBaja() == null && idContrato.equals(crc.getContrato().getId())) {
						crc.setFechaBaja(new Date());
						crc.setMotivoBaja(this.getMotivoBajaExcluir());
						genericDao.update(CicloRecobroContrato.class, crc);
					}
				}
			}

			modificarDatosEconomicosCRE(crex);
		}
	}

	/**
	 * Excluye las persona de un expediente de recobro.
	 * 
	 * @param exp
	 * @param idPersona
	 */
	private void excluirPersonaAlExpedienteRecobro(ExpedienteRecobro exp, Long idPersona) {

		// Borramos el crp
		CicloRecobroExpediente crex = exp.getCicloRecobroActivo();
		if (!Checks.esNulo(crex)) {
			List<CicloRecobroPersona> crpList = crex.getCiclosRecobroPersona();
			if (idPersona != null && crpList != null && crpList.size() > 0) {
				for (CicloRecobroPersona crp : crpList) {
					if (crp.getFechaBaja() == null && idPersona.equals(crp.getPersona().getId())) {
						crp.setFechaBaja(new Date());
						crp.setMotivoBaja(this.getMotivoBajaExcluir());
						genericDao.update(CicloRecobroPersona.class, crp);

					}
				}
			}
		}
	}

	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_MGR_BUSQUEDA_CONTRATOS_RECOBRO)
	public Page busquedaContratosRecobro(BusquedaContratosDto dto) {
		EventFactory.onMethodStart(this.getClass());

		dto.setCodigosZona(getCodigosDeZona(dto));
		dto.setEstadosContrato(getEstadosContrato(dto));
		Usuario usuLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

		EventFactory.onMethodStop(this.getClass());

		return expedienteRecobroDao.buscarContratosRecobroPaginados(dto, usuLogado);

	}

	private Set<String> getCodigosDeZona(BusquedaContratosDto dto) {
		Set<String> zonas;
		if (dto.getCodigoZona() != null && dto.getCodigoZona().trim().length() > 0) {
			List<String> list = Arrays.asList((dto.getCodigoZona().split(",")));
			zonas = new HashSet<String>(list);
		} else {
			Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			zonas = usuario.getCodigoZonas();
		}
		return zonas;
	}

	/**
	 * Devuelve los estados de un contrato seleccionados en el form.
	 * 
	 * @param dto
	 * @return
	 */
	private Set<String> getEstadosContrato(BusquedaContratosDto dto) {
		Set<String> estados = null;
		if (dto.getStringEstadosContrato() != null && dto.getStringEstadosContrato().trim().length() > 0) {
			List<String> list = Arrays.asList((dto.getStringEstadosContrato().split(",")));
			estados = new HashSet<String>(list);
		}
		return estados;
	}

	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_GET_AGENCIAS_RECOBRO)
	public List<RecobroAgencia> getAgenciasRecobro() {
		return genericDao.getList(RecobroAgencia.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_GET_AGENCIAS_RECOBRO_USU)
	public List<RecobroAgencia> getAgenciasRecobroUsuario() {
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (usu.getUsuarioExterno()){
			return proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgenciasDeUsuario(usu.getId());
		} else {
			return this.getAgenciasRecobro();
		}
	}

	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_GET_CABECERA_EXPEDIENTE_RECOBRO)
	public ExpedienteRecobroDto getCabeceraExpedienteRecobro(Long id) {
		ExpedienteRecobroDto dto  = new ExpedienteRecobroDto();
		
		ExpedienteRecobro expedienteRecobro = expedienteRecobroDao.get(id);
		if (!Checks.esNulo(expedienteRecobro)) {
			CicloRecobroExpediente cicloRecobroExpediente = expedienteRecobro.getCicloRecobroActivo();
			if (!Checks.esNulo(cicloRecobroExpediente)) {
				dto.setAgencia(cicloRecobroExpediente.getAgencia());
				dto.setCarteraEsquema(cicloRecobroExpediente.getCarteraEsquema());
				dto.setSubCartera(cicloRecobroExpediente.getSubcartera());
				dto.setFechaAsignacion(cicloRecobroExpediente.getFechaAlta());			
				if (!Checks.esNulo(cicloRecobroExpediente.getSubcartera()) && !Checks.esNulo(cicloRecobroExpediente.getSubcartera().getItinerarioMetasVolantes())) {
					dto.setItinerarioMV(cicloRecobroExpediente.getSubcartera().getItinerarioMetasVolantes());
					
					Date fechaAlta = cicloRecobroExpediente.getFechaAlta();
					Long plazoGestion = cicloRecobroExpediente.getSubcartera().getItinerarioMetasVolantes().getPlazoMaxGestion();
					if (!Checks.esNulo(fechaAlta) && !Checks.esNulo(plazoGestion)) {
						
						Calendar calendar = new GregorianCalendar();
						calendar.setTime(fechaAlta);
						calendar.add(Calendar.DAY_OF_YEAR, Integer.parseInt(plazoGestion.toString()));								
						dto.setFechaMaxEnAgencia(Timestamp.valueOf(df.format(calendar.getTime())));
					}
					
					Long plazoSinGestion = cicloRecobroExpediente.getSubcartera().getItinerarioMetasVolantes().getPlazoSinGestion();
					if (!Checks.esNulo(fechaAlta) && !Checks.esNulo(plazoSinGestion)) {
						Calendar calendar = new GregorianCalendar();
						calendar.setTime(fechaAlta);
						calendar.add(Calendar.DAY_OF_YEAR, Integer.parseInt(plazoSinGestion.toString()));
						dto.setFechaMaxCobroParcial(Timestamp.valueOf(df.format(calendar.getTime())));
						
					}
				}				
			}
		}
		
		return dto;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_GET_GESTORRECOBRO_ACTIVO_BO)
	public GestorExpediente getGestorRecobroActualExpediente(Long idExpediente) {
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_AGENCIA_RECOBRO);
		
		GestorExpediente gestorRecobro = genericDao.get(GestorExpediente.class, filtroExpediente, filtroBorrado, filtroTipoGestor);
		return gestorRecobro;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_IS_GESTORRECOBROEXP)
	public Boolean esGestorRecobroExpediente(Long idExpediente, Long idUsuario) {
		GestorExpediente gestor = this.getGestorRecobroActualExpediente(idExpediente);
		if (!Checks.esNulo(gestor) && !Checks.esNulo(idUsuario)){
			if (idUsuario.equals(gestor.getUsuario().getId())){
				return true;
			}
		}
		return false;
		
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_IS_SUPERVISORRECOBROEXP)
	public Boolean esSupervisorRecobroExpediente(Long idExpediente,
			Long idUsuario) {
		if (Checks.esNulo(idUsuario) || idUsuario==0){
			Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			idUsuario=usuario.getId();
		}
		GestorExpediente gestor = this.getSupervisorRecobroActualExpediente(idExpediente);
		if (!Checks.esNulo(gestor) && !Checks.esNulo(idUsuario)){
			if (idUsuario.equals(gestor.getUsuario().getId())){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_IS_AGENCIARECOBRO_EXP)
	public Boolean esAgenciaRecobroExpediente(Long idExpediente, Long idUsuario) {
		Boolean esAgencia=false;
		if (Checks.esNulo(idUsuario) || idUsuario==0){
			Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			idUsuario=usuario.getId();
		}
		
		List<RecobroAgencia> agencias = proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgenciasDeUsuario(idUsuario);
		ExpedienteRecobro exp = this.getExpedienteRecobro(idExpediente);
		if (!Checks.esNulo(exp)){
			if (!Checks.esNulo(exp.getCicloRecobroActivo())){
				if (!Checks.esNulo(agencias) && !Checks.estaVacio(agencias)){
					for (RecobroAgencia age : agencias){
						if (age.getId().equals(exp.getCicloRecobroActivo().getAgencia().getId())){
							esAgencia=true;
							break;
						}
					}
				}
			}
		}
		return esAgencia;
	}

	private GestorExpediente getSupervisorRecobroActualExpediente(
			Long idExpediente) {
		Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", EXTDDTipoGestor.CODIGO_TIPO_SUPERVISOR_AGENCIA_RECOBRO);
		
		GestorExpediente gestorRecobro = genericDao.get(GestorExpediente.class, filtroExpediente, filtroBorrado, filtroTipoGestor);
		return gestorRecobro;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_GETLIST_ACUERDOS)
	public List<Acuerdo> getAcuerdosExpediente(Long idExpediente) {
		
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (usu.getUsuarioExterno()) {
			List<RecobroAgencia> agencias = proxyFactory.proxy(RecobroAgenciaApi.class).buscaAgenciasDeUsuario(usu.getId());
			if (Checks.estaVacio(agencias)) {
				return acuerdoDao.getAcuerdosDelExpediente(idExpediente);
			} else {
				List<Long> idsDespachos = new ArrayList<Long>();
				for (RecobroAgencia recobroAgencia : agencias) {
					idsDespachos.add(recobroAgencia.getDespacho().getId());
				}				 
				return acuerdoDao.getAcuerdosDelExpedienteDespacho(idExpediente, idsDespachos);
			}
		} else {
			return acuerdoDao.getAcuerdosDelExpediente(idExpediente);			
		}
		
//		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
//		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
//		return genericDao.getList(Acuerdo.class, filtro, filtroBorrado);
	}
	
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_LISTA_PALANCAS_PERMITIDAS)
	public List<RecobroDDTipoPalanca> buscaPalancasPermitidasExpediente(
			Long idExpediente) {
		ExpedienteRecobro exp = this.getExpedienteRecobro(idExpediente);
		CicloRecobroExpediente cre = exp.getCicloRecobroActivo();
		List<RecobroDDTipoPalanca> palancas= new ArrayList<RecobroDDTipoPalanca>();
		if (exp.isManual()){
			palancas = proxyFactory.proxy(DiccionarioApi.class).dameValoresDiccionario(RecobroDDTipoPalanca.class);
		} else {
			if (!Checks.esNulo(cre)){
				if (!Checks.esNulo(cre.getSubcartera())){
					if (!Checks.esNulo(cre.getSubcartera().getPoliticaAcuerdos())){
						for (RecobroPoliticaAcuerdosPalanca p : cre.getSubcartera().getPoliticaAcuerdos().getPoliticaAcuerdosPalancas()){
							if (!palancas.contains(p.getSubtipoPalanca().getTipoPalanca())){
								palancas.add(p.getSubtipoPalanca().getTipoPalanca());
							}	
						}
					}
				}
			}
			
		}
		return palancas;
		
	}


	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_GUARDA_ACUERDO_EXPEDIENTE)
	@Transactional(readOnly=false)
	public void guardarAcuerdoExpediente(AcuerdoExpedienteDto dto) {
		Acuerdo acuerdo= null;
		if (Checks.esNulo(dto.getIdAcuerdo())){
			if (!Checks.esNulo(dto.getIdExpediente())){
				Expediente expediente = dameExpediente(dto.getIdExpediente());
				if (!Checks.esNulo(expediente)){
					acuerdo = new Acuerdo();
					acuerdo.setExpediente(expediente);
					acuerdo.setEstadoAcuerdo((DDEstadoAcuerdo) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_EN_CONFORMACION));	
				}
				
			}
		}
		else {
			acuerdo =proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(dto.getIdAcuerdo());	
		}
		if (!Checks.esNulo(acuerdo)){
			acuerdo.setObservaciones(dto.getObservaciones());
			if (!Checks.esNulo(dto.getSolicitante())){
				acuerdo.setSolicitante((DDSolicitante) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(DDSolicitante.class, dto.getSolicitante()));
			}
			if (!Checks.esNulo(dto.getImportePago())){
				acuerdo.setImportePago(Double.parseDouble(dto.getImportePago()));
			}
			acuerdo.setPorcentajeQuita(dto.getQuita());
			
			if (!Checks.esNulo(dto.getTipoPalanca())){
				RecobroDDTipoPalanca tipoPalanca = (RecobroDDTipoPalanca) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDTipoPalanca.class, dto.getTipoPalanca());
				acuerdo.setTipoPalanca(tipoPalanca);
			}
			
			if (!Checks.esNulo(dto.getIdDespacho())) {
				DespachoExterno despacho = despachoDao.get(dto.getIdDespacho());
				if (!Checks.esNulo(despacho)) {
					acuerdo.setDespacho(despacho);
				}
			}
			
			Double deudaTotal = acuerdo.getExpediente().getVolumenRiesgo();		
			
			acuerdo.setDeudaTotal(Checks.esNulo(deudaTotal) ? 0D : deudaTotal);
			
			Long idAcuerdo = acuerdoDao.save(acuerdo);
			
			if (!Checks.esNulo(dto.getContratos())){
				guardaContratosAcuerdo(idAcuerdo, dto.getContratos());
			}
		}
	}
	
	private void guardaContratosAcuerdo(Long idAcuerdo, String contratos) {
		Collection<Long> listaContratos = Conversiones.createLongCollection(contratos, ",");
		for (Long idContrato: listaContratos){
			List<Long> contratosExistentes = new ArrayList<Long>();
			Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(idAcuerdo);
			if (!Checks.esNulo(acuerdo.getContratos())){
				for (AcuerdoContrato acuCnt : acuerdo.getContratos()){
					if (!listaContratos.contains(acuCnt.getContrato().getId())){
						borrarAcuerdoContrato(acuCnt.getId());
					}else {
						contratosExistentes.add(acuCnt.getContrato().getId());
					}
				}
				if (!contratosExistentes.contains(idContrato)){
					Contrato contrato = dameContrato(idContrato);
					anyadirContratoAcuerdo(acuerdo, contrato);	
				}
			}
			else {
				Contrato contrato = dameContrato(idContrato);
				anyadirContratoAcuerdo(acuerdo, contrato);
			}
			
		}
		
	}

	private void anyadirContratoAcuerdo(Acuerdo acuerdo, Contrato contrato) {
		AcuerdoContrato ac= new AcuerdoContrato();
		ac.setAcuerdo(acuerdo);
		ac.setContrato(contrato);
		genericDao.save(AcuerdoContrato.class, ac);
		
	}

	private void borrarAcuerdoContrato(Long id) {
		genericDao.deleteById(AcuerdoContrato.class, id);
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_PROPONER_ACUERDO)
	@Transactional(readOnly=false)
	public void proponerAcuerdo(Long idAcuerdo) {
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(idAcuerdo);
		if (!Checks.esNulo(acuerdo)){
			DDEstadoAcuerdo estado = (DDEstadoAcuerdo) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_PROPUESTO);
			acuerdo.setEstadoAcuerdo(estado);
			acuerdo.setFechaPropuesta(new Date());
			genericDao.save(Acuerdo.class, acuerdo);
			prepararEnvioMailOficinas(acuerdo);
		}
	}

	/**
	 * @author pedro
	 * 
	 * @param acuerdo Acuerdo para el que se va a generar el envío de mails a la/s oficina/s
	 */
	private void prepararEnvioMailOficinas(Acuerdo acuerdo) {
		
		String vacio = "";

		if (acuerdo == null || acuerdo.getId() == null) {
			logger.error("Error al intentar enviar email a oficinas en un acuerdo: no existe.");
			return;
		}
		if (acuerdo.getContratos() == null) {
			logger.error("Error al intentar enviar email a oficinas en un acuerdo " + acuerdo.getId() + ": no tiene contratos.");
			return;
		}
		
		// Obtener los contratos a los que afecta el acuerdo (y las oficinas asociadas) 
		List<Contrato> contratos = new ArrayList<Contrato>();
		Set<Oficina> oficinas = new HashSet<Oficina>();
		Set<Persona> personas = new HashSet<Persona>();
		for (AcuerdoContrato acuerdoContrato : acuerdo.getContratos()) {
			if (acuerdoContrato != null && acuerdoContrato.getContrato() != null) {
				Contrato contrato = acuerdoContrato.getContrato();
				contratos.add(contrato);
				if (contrato.getOficina() != null) {
					Oficina oficina = contrato.getOficina(); 
					oficinas.add(oficina);
				}
				if (contrato.getPrimerTitular() != null) {
					Persona titular = contrato.getPrimerTitular();
					personas.add(titular);
				}
			}
		}
		if (oficinas.isEmpty()) {
			logger.error("Error al intentar enviar email a oficinas en un acuerdo " + acuerdo.getId() + ": sus contratos no tienen oficinas.");
			return;
		}
		if (personas.isEmpty()) {
			logger.error("Error al intentar enviar email a oficinas en un acuerdo " + acuerdo.getId() + ": sus contratos no tienen titulares.");
			return;
		}
		
		EnvEmailAcuerdoDto envioDto = new EnvEmailAcuerdoDto();

		// Obtener los datos de las personas titulares de los contratos
		String separador = ", ";
		String personasTexto = "";
		for (Persona persona : personas) {
			String nombre = (persona.getNom50() == null ? vacio: persona.getNom50());
			String dni = (persona.getDocId() == null ? vacio: persona.getDocId());
			personasTexto = personasTexto + nombre + " (" + dni + ")" + separador;
		}
		if (personasTexto.length()>separador.length()) {
			personasTexto = personasTexto.substring(0, personasTexto.length() - separador.length());
		}
		envioDto.setDatosCliente(personasTexto);
		
		// Obtener el resto de los datos del mensaje
		envioDto.setAgencia((acuerdo.getDespacho() == null ? vacio: acuerdo.getDespacho().getDespacho()));
		envioDto.setTipoAcuerdo((acuerdo.getTipoPalanca() == null ? vacio: acuerdo.getTipoPalanca().getDescripcionLarga()));
		if (acuerdo.getImportePago() != null) {
			DecimalFormat df = new DecimalFormat( "#,###,###,##0.00");
			envioDto.setImportePago(df.format(acuerdo.getImportePago()));
		} else {
			envioDto.setImportePago(vacio);
		}
		envioDto.setPorcentajeQuita(((acuerdo.getPorcentajeQuita() == null ? vacio: acuerdo.getPorcentajeQuita().toString())));
		envioDto.setContratos(((acuerdo.getContratosString() == null ? vacio: acuerdo.getContratosString())));
		envioDto.setObservaciones(((acuerdo.getObservaciones() == null ? vacio: acuerdo.getObservaciones())));
		
		// Recorrer las oficinas y obtener los datos de envío
		for (Oficina oficina : oficinas) {
			boolean envioOk = true;
			//Obtener la dirección de correo electrónico de la oficina
			String emailOficina = oficinaEmailDao.obtenerEmailOficina(oficina.getId());
			if (emailOficina != null) {
				try {
					envioEmailAcuerdo(envioDto, emailOficina);
				} catch (Exception e) {
					logger.error("Error al intentar enviar el correo electrónico del acuerdo " + acuerdo.getId() + " a la oficina " + oficina.getId());
					envioOk = false;
				}
			}
			registrarEnvioEmailAcuerdo(acuerdo, envioDto, envioOk, oficina);
			
		}
	}

	private void registrarEnvioEmailAcuerdo(Acuerdo acuerdo, EnvEmailAcuerdoDto envioDto,
			boolean envioOk, Oficina oficina) {
		
		EnvioEmailAcuerdo envio = new EnvioEmailAcuerdo();
		envio.setAcuerdo(acuerdo);
		envio.setOficina(oficina);
		envio.setEnviado(envioOk);
		envio.setFechaPropuesta(new Date());
		envio.setAuditoria(Auditoria.getNewInstance());
		genericDao.save(EnvioEmailAcuerdo.class, envio);
		
	}

	private void envioEmailAcuerdo(EnvEmailAcuerdoDto envioDto, String emailOficina) throws Exception {
		
		//Montar campos del email e invocar a la clase de utilidad que genera y envía el mensaje
		String to = emailOficina;
		String subject = "Propuesta de Acuerdo Negociada entre Cliente y Sociedad de Cobro";
		StringBuffer body = new StringBuffer();
		body.append("Buenos días\n\n");
		body.append("Les comunicamos que con fecha de hoy la Agencia de Recobro ");
		body.append(envioDto.getAgencia());
		body.append(" ha llegado a un acuerdo/compromiso de ");
		body.append(envioDto.getTipoAcuerdo());
		body.append("  con su cliente ");
		body.append(envioDto.getDatosCliente());
		body.append(" en los siguientes términos:\n\n");
		body.append("- Tipo de acuerdo: ");
		body.append(envioDto.getTipoAcuerdo());
		body.append("\n\n");
		body.append("- Importe de pago: ");
		body.append(envioDto.getImportePago());
		body.append("\n\n");
		body.append("- Porcentaje de quita: ");
		body.append(envioDto.getPorcentajeQuita());
		body.append("% \n\n");
		body.append("- Contrato/s: ");
		body.append(envioDto.getContratos());
		body.append("\n\n");
		body.append("- Observaciones: ");
		body.append(envioDto.getObservaciones());
		body.append("\n\n\n");
		body.append("\t- En caso de quita, la Sociedad de Cobro informará al cliente de la resolución de la propuesta y si ésta es positiva, le dirigirá a su oficina para realizar la entrega a cuenta y formalizar el acuerdo.\n\n");
		body.append("\t- En caso de adecuación, la Sociedad de Cobro coordinará una cita entre la oficina y el cliente con el fin de agilizar la tramitación de la adecuación propuesta para formalizar a la mayor brevedad posible.\n\n");
		body.append("Saludos.");
		body.append("\n\n\n");
		body.append("Rogamos no responder a esta dirección de correo. Para cualquier asunto relacionado con ");
		body.append("este correo, por favor diríjase a la Sociedad de Cobro indicada en el mismo, cuya dirección ");
		body.append("la puede encontrar en NOS/ FICHA DE SEGUIMIENTO Y RECUPERACIONES/EXPEDIENTE/POSICIÓN Y MOVIMIENTO ");
		body.append("(elegir nº contrato)/SOCIEDAD DE COBRO. Para cualquier otra consulta relacionada con la gestión ");
		body.append("de Sociedades de Cobro, también puede dirigirse al correo: “G021309@bankia.com ­- Control de Sociedades Cobro.\n\n”");

		CorreoUtils.dameInstancia().enviarCorreo(to, subject, body.toString());
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_CANCELAR_ACUERDO)
	@Transactional(readOnly=false)
	public void cancelarAcuerdo(Long idAcuerdo) {
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(idAcuerdo);
		if (!Checks.esNulo(acuerdo)){
			DDEstadoAcuerdo estado = (DDEstadoAcuerdo) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_FINALIZADO);
			acuerdo.setEstadoAcuerdo(estado);
			acuerdo.setFechaPropuesta(new Date());
			genericDao.save(Acuerdo.class, acuerdo);
		}
	}
	
	private Expediente dameExpediente(Long idExpediente) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idExpediente);
		return genericDao.get(Expediente.class, filtro);
	}

	private Contrato dameContrato(Long idContrato) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idContrato);
		return genericDao.get(Contrato.class, filtro);
	}

	@Override
	@BusinessOperation(ExpedienteRecobroContants.BO_EXP_GET_ID_SAGER)
	public Long getIdSager() {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", EXTDDTipoGestor.CODIGO_TIPO_SUPERVISOR_AGENCIA_RECOBRO);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtro);
		return tipoGestor.getId();
	}


}
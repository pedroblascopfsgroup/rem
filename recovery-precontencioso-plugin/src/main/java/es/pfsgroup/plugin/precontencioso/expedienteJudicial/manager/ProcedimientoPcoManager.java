package es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager;

import java.io.File;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.AsuntosManager;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.dao.NivelDao;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContext;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDEstadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.ConfigEntidadProcTipoFicheroPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDUnidadGestionPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.assembler.ProcedimientoPCOAssembler;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.assembler.ProcedimientoPcoGridDTOAssembler;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ActualizarProcedimientoPcoDtoInfo;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.ProcedimientoPcoGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.handler.PrecontenciosoBPMConstants;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDTipoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.HistoricoEstadoProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.manager.LiquidacionManager;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDEstadoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGrupoUsuariosApi;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Service
public class ProcedimientoPcoManager implements ProcedimientoPcoApi {

	private static final String LITIGIO = "litigio";
	private static final String CONCURSO = "concurso";
	
	private static final String PRETURNADO = "preturnado";
	private static final String POSTURNADO = "posturnado";
	
	private static final String LETRADO = "GEXT";
	private static final String SUPERVISOR = "SUP_PCO";
	private static final String DIRLIT_PCO = "DULI";
	private static final String PREDOC = "PREDOC";
	private static final String CM_GE_PCO = "CM_GE_PCO";
	private static final String CM_GD_PCO = "CM_GD_PCO";
	private static final String CM_GL_PCO = "CM_GL_PCO";
	private static final String SUP_PCO = "SUP_PCO";

	@Resource
	private Properties appProperties;
	
	@Autowired
	private ProcedimientoPCODao procedimientoPcoDao;
	
	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	@Autowired
	private TareaExternaDao tareaExternaDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private NivelDao nivelDao;

	@Autowired
	UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private AsuntosManager asuntosManager;
	
    @Autowired
    private Executor executor;

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private LiquidacionManager liquidacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

    @Autowired
    protected TareaExternaManager tareaExternaManager;

	@Autowired
	ProcedimientoManager procedimientoManager;

	@Autowired
	PrecontenciosoProjectContext precontenciosoContext;
	
	@Autowired
	private GestorTareasManager gestorTareasManager;
	
	@Autowired
	private GestorAdicionalAsuntoApi gestorAdicionalAsuntomanager;
	
	@Autowired
	private EXTGrupoUsuariosApi grupoUsuarios;
	
	@BusinessOperation(BO_PCO_COMPROBAR_FINALIZAR_PREPARACION_EXPEDIENTE)
	@Override
	public boolean comprobarFinalizarPreparacionExpedienteJudicialPorProcedimientoId(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = genericDao.get(ProcedimientoPCO.class, 
				genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento));

		// comprobacion, todos los documentos se encuentren correctamente 
		for(DocumentoPCO documento : procedimientoPco.getDocumentos()) {
			DDEstadoDocumentoPCO estadoDocumento = documento.getEstadoDocumento();

			Boolean documentoCompletoAdjuntado = (DDEstadoDocumentoPCO.DISPONIBLE.equals(estadoDocumento.getCodigo()) && documento.getAdjuntado());
			Boolean documentoDescartado = DDEstadoDocumentoPCO.DESCARTADO.equals(estadoDocumento.getCodigo());

			// se considera como documentos correctos, aquellos documentos los cuales esten en estado disponible y adjuntado o aquellos documentos descartados
			if (!(documentoCompletoAdjuntado || documentoDescartado)) {
				return false;
			}
		}

		return true;
	}

	@BusinessOperation(BO_PCO_FINALIZAR_PREPARACION_EXPEDIENTE_JUDICIAL_POR_PRC_ID)
	@Override
	@Transactional(readOnly = false)
	public boolean finalizarPreparacionExpedienteJudicialPorProcedimientoId(Long idProcedimiento) {

		//ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);
		ProcedimientoPCO procedimientoPco = genericDao.get(ProcedimientoPCO.class, 
				genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento));
		
		boolean finalizar = true;
		HistoricoEstadoProcedimientoPCO historico = procedimientoPco.getEstadoActualByHistorico();
		if (!DDEstadoPreparacionPCO.PREPARADO.equals(historico.getEstadoPreparacion().getCodigo())) {				
			historico.setFechaFin(new Date());
			genericDao.update(HistoricoEstadoProcedimientoPCO.class, historico);
			
			HistoricoEstadoProcedimientoPCO historicoNuevoRegistro = new HistoricoEstadoProcedimientoPCO();
			historicoNuevoRegistro.setProcedimientoPCO(procedimientoPco);
			DDEstadoPreparacionPCO estadoPreparado = (DDEstadoPreparacionPCO)diccionarioApi.dameValorDiccionarioByCod(DDEstadoPreparacionPCO.class, 
					DDEstadoPreparacionPCO.PREPARADO);
			historicoNuevoRegistro.setEstadoPreparacion(estadoPreparado);
			historicoNuevoRegistro.setFechaInicio(new Date());
			genericDao.save(HistoricoEstadoProcedimientoPCO.class, historicoNuevoRegistro);
		} else {
			finalizar = false;
		}	
		if (finalizar) {
			avanzarTareaPrepararExpediente(procedimientoPco);
		}

		return finalizar;
	}

	private void avanzarTareaPrepararExpediente(ProcedimientoPCO procedimientoPco) {

		// Avanzar el BPM
		Set<TareaNotificacion> listaTars = procedimientoPco.getProcedimiento().getTareas();
		for (TareaNotificacion tareaNotificacion : listaTars) {
			if (!Checks.esNulo(tareaNotificacion) && 
					PrecontenciosoBPMConstants.PCO_PrepararExpediente.equals(
							tareaNotificacion.getTareaExterna().getTareaProcedimiento().getCodigo())) {
				
				TareaExterna tex = tareaNotificacion.getTareaExterna();
				if (!Checks.esNulo(tex) && !Checks.esNulo(tex.getTokenIdBpm())) {
	                //Lanzamos el signal al token maestro
	                executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN, tex.getTokenIdBpm(), 
	                		BPMContants.TRANSICION_AVANZA_BPM);
				}
			}
		}

	}

	@Override
	@Transactional(readOnly = false)
	public void devolverPreparacionPorProcedimientoId(Long idProcedimiento) {
		//ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);
		ProcedimientoPCO procedimientoPco = genericDao.get(ProcedimientoPCO.class, 
				genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento));


		// Comprobacion que el estado actual del procedimiento sea preparado
		if (procedimientoPco.getEstadoActual() != null && !DDEstadoPreparacionPCO.PREPARADO.equals(procedimientoPco.getEstadoActual().getCodigo())) {
			throw new BusinessOperationException("Estado incorrecto");
		}

		// Actualizar fecha fin estado actual
		HistoricoEstadoProcedimientoPCO historico = procedimientoPco.getEstadoActualByHistorico();
		historico.setFechaFin(new Date());
		genericDao.update(HistoricoEstadoProcedimientoPCO.class, historico);

		// Nuevo registro en historico con el nuevo estado
		DDEstadoPreparacionPCO estadoPreparacion = (DDEstadoPreparacionPCO) diccionarioApi.dameValorDiccionarioByCod(DDEstadoPreparacionPCO.class, DDEstadoPreparacionPCO.PREPARACION);

		HistoricoEstadoProcedimientoPCO historicoNuevoRegistro = new HistoricoEstadoProcedimientoPCO();
		historicoNuevoRegistro.setProcedimientoPCO(procedimientoPco);
		historicoNuevoRegistro.setEstadoPreparacion(estadoPreparacion);
		historicoNuevoRegistro.setFechaInicio(new Date());
		genericDao.save(HistoricoEstadoProcedimientoPCO.class, historicoNuevoRegistro);	
		
		//Cancelar tarea actual
//		cancelarTareaActual(procedimientoPco);
		
//		Long idProc = procedimientoPco.getProcedimiento().getId();
		
		//Crear tarea Preparar Expediente
//		proxyFactory.proxy(GestorTareasApi.class).crearTareaEspecial(idProc, PrecontenciosoBPMConstants.PCO_PrepararExpediente);		
	}

//	private void cancelarTareaActual(ProcedimientoPCO procedimientoPco) {
//
//		// Cancelamos tarea/s actual/es
//		List<TareaExterna> listaTareas = tareaExternaManager.getActivasByIdProcedimiento(procedimientoPco.getProcedimiento().getId());
//		
//		for (TareaExterna tareaExterna : listaTareas) {
//			cancelaTarea(tareaExterna);
//		}
//
//	}
//
//	private void cancelaTarea(TareaExterna tareaExterna) {
//
//		if (tareaExterna != null) {
//            tareaExterna.setCancelada(false);
//            tareaExterna.setDetenida(false);
//            tareaExternaManager.borrar(tareaExterna);
//            
//            TareaNotificacion tarNotif = proxyFactory.proxy(TareaNotificacionApi.class).get(tareaExterna.getTareaPadre().getId());
//            tarNotif.setTareaFinalizada(true);
//            proxyFactory.proxy(TareaNotificacionApi.class).saveOrUpdate(tarNotif);
//            
//            //Buscamos si tiene prorroga activa
//            Prorroga prorroga = tareaExterna.getTareaPadre().getProrrogaAsociada();
//            //Borramos (finalizamos) la prorroga si es que tiene
//            if (prorroga != null) {
//            	proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(prorroga.getTarea().getId());
//            }
//            if (logger.isDebugEnabled()) {
//                logger.debug("Cancelamos tarea: " + tareaExterna.getId());
//            }
//        }
//
//	}

	@Override
	public List<HistoricoEstadoProcedimientoDTO> getEstadosPorIdProcedimiento(Long idProcedimiento) {
		//ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);
		ProcedimientoPCO procedimientoPco = genericDao.get(ProcedimientoPCO.class, 
				genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento));

		List<HistoricoEstadoProcedimientoDTO> historicoEstadosOut = null;

		if (procedimientoPco != null) {
			historicoEstadosOut = ProcedimientoPCOAssembler.historicoEstadosEntityToHistoricoEstadosDto(procedimientoPco.getEstadosPreparacionProc());
		}

		return historicoEstadosOut;
	}

	@BusinessOperation(ProcedimientoPcoApi.BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID)
	@Override
	public ProcedimientoPCODTO getPrecontenciosoPorProcedimientoId(Long idProcedimiento) {
		//ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);
		ProcedimientoPCO procedimientoPco = genericDao.get(ProcedimientoPCO.class, 
				genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento));

		ProcedimientoPCODTO procedimientoDto = ProcedimientoPCOAssembler.entityToDto(procedimientoPco);

		return procedimientoDto;
	}

	@Override
	public Integer countBusquedaPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Integer count = procedimientoPcoDao.countBusquedaPorFiltro(filtro);
		return count;
	}

	@Override
	public List<ProcedimientoPcoGridDTO> busquedaProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<HashMap<String, Object>> procedimientos = procedimientoPcoDao.busquedaProcedimientosPcoPorFiltro(filtro);
		List<ProcedimientoPcoGridDTO> procedimientosGridDto = ProcedimientoPcoGridDTOAssembler.fromProcedimientosListHashMap(procedimientos);

		return procedimientosGridDto;
	}

	@Override
	public List<ProcedimientoPcoGridDTO> busquedaSolicitudesDocumentoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<HashMap<String, Object>> documentos = procedimientoPcoDao.busquedaDocumentosPorFiltro(filtro);
		List<ProcedimientoPcoGridDTO> documentosGridDto = ProcedimientoPcoGridDTOAssembler.fromDocumentosListHashMap(documentos);

		return documentosGridDto;
	}

	@Override
	public List<ProcedimientoPcoGridDTO> busquedaLiquidacionesPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<HashMap<String, Object>> liquidaciones = procedimientoPcoDao.busquedaLiquidacionesPorFiltro(filtro);
		List<ProcedimientoPcoGridDTO> liquidacionGridDto = ProcedimientoPcoGridDTOAssembler.fromLiquidacionesListHashMap(liquidaciones);

		return liquidacionGridDto;
	}

	@Override
	public List<ProcedimientoPcoGridDTO> busquedaBurofaxPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<HashMap<String, Object>> burofaxes = procedimientoPcoDao.busquedaBurofaxPorFiltro(filtro);
		List<ProcedimientoPcoGridDTO> burofaxesGridDto = ProcedimientoPcoGridDTOAssembler.fromBurofaxesListHashMap(burofaxes);

		return burofaxesGridDto;
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_PCO_ACTUALIZAR_PROCEDIMIENTO_Y_PCO)
	public void actualizaProcedimiento(ActualizarProcedimientoPcoDtoInfo dto) {
		Procedimiento p = null;
		ProcedimientoPCO pco = null;
		if (!Checks.esNulo(dto.getId())) {
			p = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
			pco = genericDao.get(ProcedimientoPCO.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", dto.getId()));
		} else {
			throw new BusinessOperationException(
					"plugin.santander.actualizaProcedimiento.idNulo");
		}
		if (!Checks.esNulo(dto.getTipoReclamacion())) {
			Filter filtroTipoReclamacion = genericDao.createFilter(FilterType.EQUALS, "id", dto.getTipoReclamacion());
			DDTipoReclamacion reclamacion = genericDao.get(DDTipoReclamacion.class, filtroTipoReclamacion);
			p.setTipoReclamacion(reclamacion);
		}
		if (!Checks.esNulo(dto.getTipoJuzgado())) {
			Filter filtroJuzgado = genericDao.createFilter(FilterType.EQUALS, "id", dto.getTipoJuzgado());
			TipoJuzgado juzgado = genericDao.get(TipoJuzgado.class, filtroJuzgado);
			p.setJuzgado(juzgado);
		}
		if (!Checks.esNulo(dto.getPrincipal())) {
			p.setSaldoRecuperacion(dto.getPrincipal());
		}
		if (!Checks.esNulo(dto.getEstimacion())) {
			p.setPorcentajeRecuperacion(dto.getEstimacion());
		}
		if (!Checks.esNulo(dto.getPlazoRecuperacion())) {
			p.setPlazoRecuperacion(dto.getPlazoRecuperacion());
		}
		if (!Checks.esNulo(dto.getNumeroAutos())){
			p.setCodigoProcedimientoEnJuzgado(dto.getNumeroAutos());
		}
		if(!Checks.esNulo(dto.getNumExpExterno())){
			pco.setNumExpExterno(dto.getNumExpExterno());
		}

		genericDao.update(Procedimiento.class, p);
		genericDao.update(ProcedimientoPCO.class, pco);
	}
	
	@Override
	public List<Nivel> getNiveles(){
		return nivelDao.getList();
	}
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_PCO_CAMBIAR_ESTADO_EXPEDIENTE)
	public void cambiarEstadoExpediente(Long idProcedimiento, String codigoEstado) {
		
		Date fechaCambio = new Date();
		
		//ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);
		ProcedimientoPCO procedimientoPco = genericDao.get(ProcedimientoPCO.class, 
				genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento));

		
		if (!Checks.esNulo(procedimientoPco)) {
			HistoricoEstadoProcedimientoPCO historico = procedimientoPco.getEstadoActualByHistorico();
			if (!Checks.esNulo(historico)) {
				historico.setFechaFin(fechaCambio);
				genericDao.update(HistoricoEstadoProcedimientoPCO.class, historico);
			}
	
			HistoricoEstadoProcedimientoPCO historicoNuevoRegistro = new HistoricoEstadoProcedimientoPCO();
			historicoNuevoRegistro.setProcedimientoPCO(procedimientoPco);
			DDEstadoPreparacionPCO nuevoEstado = (DDEstadoPreparacionPCO) diccionarioApi.dameValorDiccionarioByCod(DDEstadoPreparacionPCO.class, codigoEstado);
			historicoNuevoRegistro.setEstadoPreparacion(nuevoEstado);
			historicoNuevoRegistro.setFechaInicio(fechaCambio);
			genericDao.save(HistoricoEstadoProcedimientoPCO.class, historicoNuevoRegistro);
		}
	}
	
	public String dameProcedimientoPropuesto(Long idProcedimiento) {
		try {		
			//ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);
			ProcedimientoPCO procedimientoPco = genericDao.get(ProcedimientoPCO.class, 
					genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento));
			if (procedimientoPco != null) {
				return procedimientoPco.getTipoProcPropuesto().getCodigo();
			} else {
				return "";
			}
		} catch (Exception e) {
			return "";
		}

	}

	public String dameTipoAsunto(Long idProc) {
		String resultado = "";
		try {
			Procedimiento procedimiento = procedimientoManager.getProcedimiento(idProc);
			String tipoAsunto = procedimiento.getAsunto().getTipoAsunto().getCodigo();
			if (DDTiposAsunto.LITIGIO.equals(tipoAsunto)){
				resultado = LITIGIO;
			} else if (DDTiposAsunto.CONCURSAL.equals(tipoAsunto)){
				resultado = CONCURSO;
			}
		} catch (Exception e) {}
		return resultado;		
	}
	
	public String dameTipoTurnado(Long idProc) {
		String resultado = POSTURNADO;
		try {
			ProcedimientoPCO procedimientoPco = genericDao.get(ProcedimientoPCO.class, 
					genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProc));
			if (procedimientoPco != null) {
				if(procedimientoPco.getPreturnado()) {
					resultado = PRETURNADO;
				}
			}
		} catch (Exception e) {}
		return resultado;		
	}
	
	
	/**
	 * Devuelve el tipo de asunto al que está asignado el procedimiento (litigio, concurso) para usarlo como transición del BPM
	 * @param idProcedimiento
	 * @return
	 */
	public String dameTipoAsuntoPorProc(Procedimiento procedimiento) {
		String resultado = "";
		try {		
			String tipoAsunto = procedimiento.getAsunto().getTipoAsunto().getCodigo();
			if (DDTiposAsunto.LITIGIO.equals(tipoAsunto)){
				resultado = LITIGIO;
			} else if (DDTiposAsunto.CONCURSAL.equals(tipoAsunto)){
				resultado = CONCURSO;
			}
		} catch (Exception e) {}
		return resultado;
	}
	
	/**
	 * Comprueba que el asunto correspondiente al procedimiento tenga los siguientes gestores asignados:
	 * 	Letrado, Supervisor del asunto, Director unidad de litigio y Preparador documental.
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean existenGestoresCorrectos(Long idProcedimiento) {
		Boolean resultado = false;
		try {
			Procedimiento proc = procedimientoManager.getProcedimiento(idProcedimiento);
			Long idAsunto = proc.getAsunto().getId();
			List<String> listaTiposGestores = procedimientoPcoDao.getTiposGestoresAsunto(idAsunto);
			if (listaTiposGestores.contains(LETRADO) && listaTiposGestores.contains(SUPERVISOR) &&
					listaTiposGestores.contains(DIRLIT_PCO) && listaTiposGestores.contains(PREDOC)) {
				resultado = true;
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return resultado;
	}
	
	@BusinessOperation(BO_PCO_EXPEDIENTE_BY_PRC_ID)
	@Override
	public ProcedimientoPCO getPCOByProcedimientoId(Long idProcedimiento) {
		return genericDao.get(ProcedimientoPCO.class, 
				genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento));
	}
	
	@Override
	@BusinessOperation(BO_PCO_EXPEDIENTE_UPDATE)
	public void update(ProcedimientoPCO pco) {
		procedimientoPcoDao.update(pco);
	}
	
	@Override
	@BusinessOperation(BO_PCO_INICIALIZAR)
	@Transactional(readOnly = false)
	public void inicializarPrecontencioso(Procedimiento procedimiento) {

		try {		
			Long idProc = procedimiento.getId();
			//ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProc);
			ProcedimientoPCO procedimientoPco = genericDao.get(ProcedimientoPCO.class, 
					genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProc));			
			if (Checks.esNulo(procedimientoPco)) {
				procedimientoPco = crearProcedimientoPco(procedimiento, DDEstadoPreparacionPCO.PREPARACION);
			} else {
				procedimiento = procedimientoPco.getProcedimiento();
				TipoProcedimiento procPropuesto = obtenerProcedimientoPropuesto(procedimiento);
				if (procPropuesto != null) {
					procedimientoPco.setTipoProcPropuesto(procPropuesto);
				}
				genericDao.save(ProcedimientoPCO.class, procedimientoPco);
				cambiarEstadoExpediente(idProc, DDEstadoPreparacionPCO.PREPARACION);
			}
			List<Contrato> contratos = new ArrayList<Contrato>(procedimiento.getAsunto().getContratos());
			Set<Persona> setPersonas = new HashSet<Persona>();
			Set<ContratoPersona> setContratosPersonas = new HashSet<ContratoPersona>();
			for (Contrato contrato : contratos) {
				for (ContratoPersona cp : contrato.getContratoPersona()) {
					setPersonas.add(cp.getPersona());
					setContratosPersonas.add(cp);
				}
			}
			List<Persona> personas = new ArrayList<Persona>(setPersonas);
			List<ContratoPersona> contratosPersonas = new ArrayList<ContratoPersona>(setContratosPersonas);
			List<Bien> bienes = procedimientoManager.getBienesDeUnProcedimiento(idProc);
			
			//Creamos un documento por cada una de las configuraciones correspondientes a contratos, personas y bienes
			List<DocumentoPCO> documentos = obtenerNuevosDocumentos(procedimientoPco, contratos, personas, bienes);
						
			//Creamos una liquidación por cada contrato
			List<LiquidacionPCO> liquidaciones = obtenerNuevasLiquidaciones(procedimientoPco, contratos);
			
			//Creamos un burofax por cada contrato-persona (si tipo de asuto es Litigio)
			List<BurofaxPCO> burofaxes = new ArrayList<BurofaxPCO>();
			boolean esLitigio = DDTiposAsunto.LITIGIO.equals(procedimiento.getAsunto().getTipoAsunto().getCodigo());
			if (esLitigio) {
				burofaxes = obtenerNuevosBurofaxes(procedimientoPco, contratosPersonas);
			}
			
			procedimientoPco.setDocumentos(documentos);
			procedimientoPco.setLiquidaciones(liquidaciones);
			procedimientoPco.setBurofaxes(burofaxes);
			genericDao.save(ProcedimientoPCO.class, procedimientoPco);

			try {
				if (documentos.size()>0 && esLitigio) {
					gestorTareasManager.crearTareaEspecial(idProc,PrecontenciosoBPMConstants.PCO_SolicitarDoc);
				}
				if (liquidaciones.size()>0) {
					gestorTareasManager.crearTareaEspecial(idProc,PrecontenciosoBPMConstants.PCO_GenerarLiq);
				}
			} catch (Exception e) {
				System.out.println("Error al intentar crear tarea especial: " + e.getMessage());
				logger.error(e.getMessage());
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	
	}

	@Override
	@BusinessOperation(BO_PCO_CREAR_PROCEDIMIENTO_PCO)
	@Transactional(readOnly = false)
	public ProcedimientoPCO crearProcedimientoPco(Procedimiento procedimiento, String codigoEstadoInicial) {
		ProcedimientoPCO procedimientoPco;
		procedimientoPco = new ProcedimientoPCO();
		procedimientoPco.setPreturnado(false);
		procedimientoPco.setProcedimiento(procedimiento);
		DDTipoPreparacionPCO tipoPrepDefecto = (DDTipoPreparacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).
			dameValorDiccionarioByCod(DDTipoPreparacionPCO.class, DDTipoPreparacionPCO.SENCILLO);
		procedimientoPco.setTipoPreparacion(tipoPrepDefecto);
		procedimientoPco.setTipoProcPropuesto(obtenerProcedimientoPropuesto(procedimiento));
		procedimientoPco.setTipoProcIniciado(null);
		procedimientoPco.setNumExpInterno("");
		procedimientoPco.setNumExpExterno("");
		procedimientoPco.setNombreExpJudicial(procedimiento.getCodigoProcedimientoEnJuzgado());
		genericDao.save(ProcedimientoPCO.class, procedimientoPco);
		List<HistoricoEstadoProcedimientoPCO> estadosPreparacionProc = new ArrayList<HistoricoEstadoProcedimientoPCO>();
		HistoricoEstadoProcedimientoPCO histEstadoInicial = new HistoricoEstadoProcedimientoPCO();
		DDEstadoPreparacionPCO estadoInicial = null;
		if (Checks.esNulo(codigoEstadoInicial)) {
			estadoInicial = (DDEstadoPreparacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).
					dameValorDiccionarioByCod(DDEstadoPreparacionPCO.class, DDEstadoPreparacionPCO.EN_ESTUDIO);
		} else {
			estadoInicial = (DDEstadoPreparacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).
					dameValorDiccionarioByCod(DDEstadoPreparacionPCO.class, codigoEstadoInicial);
		}
		histEstadoInicial.setEstadoPreparacion(estadoInicial);
		histEstadoInicial.setFechaInicio(new Date());
		histEstadoInicial.setFechaFin(null);
		histEstadoInicial.setProcedimientoPCO(procedimientoPco);
		genericDao.save(HistoricoEstadoProcedimientoPCO.class, histEstadoInicial);
		estadosPreparacionProc.add(histEstadoInicial);
		procedimientoPco.setEstadosPreparacionProc(estadosPreparacionProc);
		genericDao.save(ProcedimientoPCO.class, procedimientoPco);
		return procedimientoPco;
	}
	
	private List<DocumentoPCO> obtenerNuevosDocumentos(ProcedimientoPCO procedimientoPco, 
			List<Contrato> contratos, List<Persona> personas, List<Bien> bienes) {
	
		List<DocumentoPCO> documentos = procedimientoPco.getDocumentos();
		if (documentos == null) {
			documentos = new ArrayList<DocumentoPCO>();
		}

		DDEstadoDocumentoPCO estadoInicialDoc = (DDEstadoDocumentoPCO) proxyFactory.proxy(UtilDiccionarioApi.class).
			dameValorDiccionarioByCod(DDEstadoDocumentoPCO.class, DDEstadoDocumentoPCO.PENDIENTE_SOLICITAR);

		//Obtener tipo de procedimiento propuesto
		String tipoProcProp = null;
		try {
			tipoProcProp = procedimientoPco.getTipoProcPropuesto().getCodigo();
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		if (!Checks.esNulo(tipoProcProp)) {
			//Insertar los documentos de contratos
			DDUnidadGestionPCO ugContrato = (DDUnidadGestionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).
					dameValorDiccionarioByCod(DDUnidadGestionPCO.class, DDUnidadGestionPCO.CONTRATOS);
			List<ConfigEntidadProcTipoFicheroPCO> listaConfigDocsContratos = obtenerListaConfigDocs(tipoProcProp, DDUnidadGestionPCO.CONTRATOS);
			for (Contrato contrato : contratos) {
				for (ConfigEntidadProcTipoFicheroPCO config : listaConfigDocsContratos) {
					DocumentoPCO documento = informarValores(procedimientoPco, config.getTipoFichero(), 
						ugContrato, contrato.getNroContratoFormat(), contrato.getId(), estadoInicialDoc);
					genericDao.save(DocumentoPCO.class, documento);
					documentos.add(documento);
				}
			}
			//Insertar los documentos de personas
			DDUnidadGestionPCO ugPersona = (DDUnidadGestionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).
					dameValorDiccionarioByCod(DDUnidadGestionPCO.class, DDUnidadGestionPCO.PERSONAS);
			List<ConfigEntidadProcTipoFicheroPCO> listaConfigDocsPersonas = obtenerListaConfigDocs(tipoProcProp, DDUnidadGestionPCO.PERSONAS);
			for (Persona persona : personas) {
				for (ConfigEntidadProcTipoFicheroPCO config : listaConfigDocsPersonas) {
					DocumentoPCO documento = informarValores(procedimientoPco, config.getTipoFichero(), 
						ugPersona, persona.getNom50(), persona.getId(), estadoInicialDoc);
					genericDao.save(DocumentoPCO.class, documento);
					documentos.add(documento);
				}				
			}
			//Insertar los documentos de bienes
			DDUnidadGestionPCO ugBien = (DDUnidadGestionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).
					dameValorDiccionarioByCod(DDUnidadGestionPCO.class, DDUnidadGestionPCO.BIENES);
			List<ConfigEntidadProcTipoFicheroPCO> listaConfigDocsBienes = obtenerListaConfigDocs(tipoProcProp, DDUnidadGestionPCO.BIENES);
			for (Bien bien : bienes) {
				for (ConfigEntidadProcTipoFicheroPCO config : listaConfigDocsBienes) {
					DocumentoPCO documento = 
					informarValores(procedimientoPco, config.getTipoFichero(), 
						ugBien, bien.getDescripcionBien(), bien.getId(), estadoInicialDoc);
					genericDao.save(DocumentoPCO.class, documento);
					documentos.add(documento);
				}				
			}
		}
		return documentos;
	}

	private DocumentoPCO informarValores(ProcedimientoPCO procedimientoPco,
			DDTipoFicheroAdjunto tipoFichero, DDUnidadGestionPCO ug,
			String descripcion, Long id, DDEstadoDocumentoPCO estadoInicialDoc) {
		
		DocumentoPCO documento = new DocumentoPCO();
		documento.setAdjuntado(false);
		documento.setProcedimientoPCO(procedimientoPco);
		documento.setSolicitudes(new ArrayList<SolicitudDocumentoPCO>());
		documento.setTipoDocumento(tipoFichero);
		documento.setUnidadGestion(ug);
		documento.setUgDescripcion(descripcion);
		documento.setUnidadGestionId(id);
		documento.setEstadoDocumento(estadoInicialDoc);
		return documento;
		
	}

	private List<LiquidacionPCO> obtenerNuevasLiquidaciones(
			ProcedimientoPCO procedimientoPco, List<Contrato> contratos) {

		List<LiquidacionPCO> liquidaciones = procedimientoPco.getLiquidaciones();
		if (liquidaciones == null) {
			liquidaciones = new ArrayList<LiquidacionPCO>();
		}
		DDEstadoLiquidacionPCO estadoInicialLiq = (DDEstadoLiquidacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).
				dameValorDiccionarioByCod(DDEstadoLiquidacionPCO.class, DDEstadoLiquidacionPCO.PENDIENTE);
		for (Contrato contrato : contratos) {
			LiquidacionPCO liq = new LiquidacionPCO();
			liq.setContrato(contrato);
			liq.setEstadoLiquidacion(estadoInicialLiq);
			liq.setProcedimientoPCO(procedimientoPco);
			genericDao.save(LiquidacionPCO.class, liq);
			liquidaciones.add(liq);
		}
		return liquidaciones;
	}

	private List<BurofaxPCO> obtenerNuevosBurofaxes(
			ProcedimientoPCO procedimientoPco, List<ContratoPersona> contratosPersonas) {

		List<BurofaxPCO> burofaxes = procedimientoPco.getBurofaxes();
		if (burofaxes == null) {
			burofaxes = new ArrayList<BurofaxPCO>();
		}
		DDEstadoBurofaxPCO estadoInicialBur = (DDEstadoBurofaxPCO) proxyFactory.proxy(UtilDiccionarioApi.class).
				dameValorDiccionarioByCod(DDEstadoBurofaxPCO.class, DDEstadoBurofaxPCO.NO_NOTIFICADO);
		for (ContratoPersona cp : contratosPersonas) {
			BurofaxPCO bf = new BurofaxPCO();
			bf.setContrato(cp.getContrato());
			bf.setEnviosBurofax(new ArrayList<EnvioBurofaxPCO>());
			bf.setEstadoBurofax(estadoInicialBur);
			bf.setTipoIntervencion(cp.getTipoIntervencion());
			bf.setProcedimientoPCO(procedimientoPco);
			bf.setDemandado(cp.getPersona());
			genericDao.save(BurofaxPCO.class, bf);
			burofaxes.add(bf);
		}
		return burofaxes;
	}


	private List<ConfigEntidadProcTipoFicheroPCO> obtenerListaConfigDocs(
			String tipoProcProp, String codigoEntidadContrato) {
		
		Filter codigoTipoProcFilter = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.codigo", tipoProcProp);
		Filter codigoEntidadFilter = genericDao.createFilter(FilterType.EQUALS, "tipoEntidad.codigo", codigoEntidadContrato);
		List<ConfigEntidadProcTipoFicheroPCO> listaConfig = genericDao.getList(ConfigEntidadProcTipoFicheroPCO.class, codigoTipoProcFilter, codigoEntidadFilter);
		return listaConfig;
		
	}


	private TipoProcedimiento obtenerProcedimientoPropuesto(
			Procedimiento procedimiento) {
		
		TipoProcedimiento tipoProc = null;
		if (DDTiposAsunto.LITIGIO.equals(procedimiento.getAsunto().getTipoAsunto().getCodigo())) {
			for (TareaExterna tarea : tareaExternaDao.obtenerTareasPorProcedimiento(procedimiento.getId())) {
				if (PrecontenciosoBPMConstants.PCO_AsignacionGestores.equals(tarea.getTareaProcedimiento().getCodigo())) {
					 List<EXTTareaExternaValor> listaValores = obtenerValoresTareaByTexId(tarea.getId());
					 for (EXTTareaExternaValor valor : listaValores) {
						if (PrecontenciosoBPMConstants.PCO_Campo_ProcPropuesto.equals(valor.getNombre())) {
							tipoProc = (TipoProcedimiento)diccionarioApi.dameValorDiccionarioByCod(TipoProcedimiento.class,valor.getValor());						
						}
					}
				}
			}
		} else {
			String tipoProcFaseComun = precontenciosoContext.getCodigoFaseComun();
			tipoProc = (TipoProcedimiento)diccionarioApi.
					dameValorDiccionarioByCod(TipoProcedimiento.class, tipoProcFaseComun);
		}
		return tipoProc;
	}

	private List<EXTTareaExternaValor> obtenerValoresTareaByTexId(Long texId) {
		return genericDao.getList(EXTTareaExternaValor.class, genericDao
				.createFilter(FilterType.EQUALS, "tareaExterna.id", texId),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	public FileItem generarExcelExportacionElementos(
			FiltroBusquedaProcedimientoPcoDTO filter) {
		
		List<ProcedimientoPcoGridDTO> listaElementos = new ArrayList<ProcedimientoPcoGridDTO>();

		// DOCUMENTO - LIQUIDACION - BUROFAX
		if (FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_DOCUMENTO.equals(filter.getTipoBusqueda())) {
			listaElementos = busquedaSolicitudesDocumentoPorFiltro(filter);
		} 
		else if (FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_LIQUIDACION.equals(filter.getTipoBusqueda())) {
			listaElementos = busquedaLiquidacionesPorFiltro(filter);
		} 
		else if (FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_BUROFAX.equals(filter.getTipoBusqueda())) {
			listaElementos = busquedaBurofaxPorFiltro(filter);
		}
		
		return generarExcelElementos(listaElementos, filter.getTipoBusqueda());
	}

	private FileItem generarExcelElementos(
			List<ProcedimientoPcoGridDTO> listaElementos, String tipoBusqueda) 
	{
		List<List<String>> valores = new ArrayList<List<String>>();

		for (ProcedimientoPcoGridDTO row : listaElementos) {
			List<String> filaExportar = new ArrayList<String>();

			filaExportar.add(ObjectUtils.toString(row.getCodigo())); 						// Código del expediente judicial
			filaExportar.add(ObjectUtils.toString(row.getNombreExpediente()));				// Nombre del expediente judicial
			filaExportar.add(ObjectUtils.toString(row.getEstadoExpediente()));				// Estado del expediente
			filaExportar.add(DateFormat.toString(row.getFechaEstado()));					// Fecha estado
			filaExportar.add(DateFormat.toString(row.getFechaInicioPreparacion()));		// Fecha solicitud
			filaExportar.add(ObjectUtils.toString(row.getTipoProcPropuesto()));			// Procedimiento propuesto
			filaExportar.add(ObjectUtils.toString(row.getTipoPreparacion()));				// Tipo de preparación
			filaExportar.add(ObjectUtils.toString(row.getDiasEnPreparacion()));				// Días en preparación
			
			if(FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_DOCUMENTO.equals(tipoBusqueda)) {
				filaExportar.add(ObjectUtils.toString(row.getDocumento().getEstado()));				// Estado
				filaExportar.add(ObjectUtils.toString(row.getDocumento().getUltimaRespuesta())); 	// Respuesta última solicitud
				filaExportar.add(ObjectUtils.toString(row.getDocumento().getUltimoActor()));		// Actor última solicitud
				filaExportar.add(DateFormat.toString(row.getDocumento().getFechaResultado()));		// Fecha resultado
				filaExportar.add(DateFormat.toString(row.getDocumento().getFechaEnvio()));			// Fecha envío
				filaExportar.add(DateFormat.toString(row.getDocumento().getFechaRecepcion()));		// Fecha recepción
				filaExportar.add(row.getDocumento().getAdjunto() != null && row.getDocumento().getAdjunto()?"Sí":"No");						// Adjunto
			}
			else if(FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_LIQUIDACION.equals(tipoBusqueda)) {
				filaExportar.add(ObjectUtils.toString(row.getLiquidacion().getEstado()));			// Estado
				filaExportar.add(ObjectUtils.toString(row.getLiquidacion().getContrato()));			// Contrato
				filaExportar.add(DateFormat.toString(row.getLiquidacion().getFechaRecepcion()));	// Fecha de recepción
				filaExportar.add(DateFormat.toString(row.getLiquidacion().getFechaConfirmacion()));// Fecha de confirmación
				filaExportar.add(DateFormat.toString(row.getLiquidacion().getFechaCierre()));		// Fecha del cierre
				filaExportar.add(row.getLiquidacion().getTotal() != null?NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(row.getLiquidacion().getTotal()):"");			// Total
			}
			else if(FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_BUROFAX.equals(tipoBusqueda)) {
				filaExportar.add(ObjectUtils.toString(row.getBurofax().getEstado()));				// Estado
				filaExportar.add(ObjectUtils.toString(row.getBurofax().getNif()));					// NIF
				filaExportar.add(ObjectUtils.toString(row.getBurofax().getApellidoNombre()));		// Nombre apellidos		
				filaExportar.add(DateFormat.toString(row.getBurofax().getFechaSolicitud()));		// Fecha solicitud		
				filaExportar.add(DateFormat.toString(row.getBurofax().getFechaEnvio()));			// Fecha envío	
				filaExportar.add(DateFormat.toString(row.getBurofax().getFechaAcuse()));			// Fecha acuse	
				filaExportar.add(row.getBurofax().getResultado() != null && row.getBurofax().getResultado()?"Sí":"No");						// Resultado
			}

			valores.add(filaExportar);
		}

		String nombreFichero = (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + "-listaElementos.xls";
		String rutaCompletaFichero = !Checks.esNulo(appProperties.getProperty("files.temporaryPath")) ? appProperties.getProperty("files.temporaryPath") : "";

		rutaCompletaFichero += File.separator.equals(rutaCompletaFichero.substring(rutaCompletaFichero.length()-1)) || rutaCompletaFichero.length() == 0 ? nombreFichero : File.separator+nombreFichero; 

		//Creo el fichero excel
		HojaExcel hojaExcel = new HojaExcel();
		hojaExcel.crearNuevoExcel(rutaCompletaFichero, getListaCabecera(tipoBusqueda), valores);

		FileItem excelFileItem = new FileItem(hojaExcel.getFile());
		excelFileItem.setFileName(rutaCompletaFichero);
		excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
		excelFileItem.setLength(hojaExcel.getFile().length());

		return excelFileItem;
	}
	
	private ArrayList<String> getListaCabecera(String tipoBusqueda){
		
		ArrayList<String> cabeceras = new ArrayList<String>();
		
		
		//Cabecera de las columnas
		cabeceras.add(formatearString("Código del expediente judicial"));
		cabeceras.add(formatearString("Nombre del expediente judicial"));
		cabeceras.add(formatearString("Estado del expediente"));
		cabeceras.add(formatearString("Fecha estado"));
		cabeceras.add(formatearString("Fecha solicitud"));		
		cabeceras.add(formatearString("Procedimiento propuesto"));		
		cabeceras.add(formatearString("Tipo de preparación"));
		cabeceras.add(formatearString("Días en preparación"));
		
		if(FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_DOCUMENTO.equals(tipoBusqueda)) {
			cabeceras.add(formatearString("Estado"));
			cabeceras.add(formatearString("Respuesta última solicitud"));
			cabeceras.add(formatearString("Actor última solicitud"));
			cabeceras.add(formatearString("Fecha resultado"));
			cabeceras.add(formatearString("Fecha envío"));		
			cabeceras.add(formatearString("Fecha recepción"));
			cabeceras.add(formatearString("Adjunto"));
		}
		else if(FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_LIQUIDACION.equals(tipoBusqueda)) {
			cabeceras.add(formatearString("Estado"));
			cabeceras.add(formatearString("Contrato"));
			cabeceras.add(formatearString("Fecha de recepción"));
			cabeceras.add(formatearString("Fecha de confirmación"));
			cabeceras.add(formatearString("Fecha del cierre"));
			cabeceras.add(formatearString("Total"));
		}
		else if(FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_BUROFAX.equals(tipoBusqueda)) {
			cabeceras.add(formatearString("Estado"));
			cabeceras.add(formatearString("NIF"));
			cabeceras.add(formatearString("Nombre apellidos"));
			cabeceras.add(formatearString("Fecha solicitud"));
			cabeceras.add(formatearString("Fecha envío"));
			cabeceras.add(formatearString("Fecha acuse"));
			cabeceras.add(formatearString("Resultado"));
		}
		
		return cabeceras;
	}
	
	//Formatea las String introducidas que desean verse correctamente en la hoja excel
	private String formatearString(String texto){
		
		texto = texto.replace("ñ", "\u00f1");
		texto = texto.replace("Ñ", "\u00d1");
		
		texto = texto.replace("á", "\u00e1");
		texto = texto.replace("é", "\u00e9");
		texto = texto.replace("í", "\u00ed");
		texto = texto.replace("ó", "\u00f3");
		texto = texto.replace("ú", "\u00fa");
		
		texto = texto.replace("Á", "\u00c1");
		texto = texto.replace("É", "\u00c9");
		texto = texto.replace("Í", "\u00cd");
		texto = texto.replace("Ó", "\u00d3");
		texto = texto.replace("Ú", "\u00da");
		
		return texto;
	}


	@Override
	public boolean isExpedienteEditable(Long idProcedimiento) {

//		Se comprueba si el usuario conectado o un grupo al que pertenece está asignado al asunto como preparador del expediente judicial
		Usuario usuario = usuarioManager.getUsuarioLogado();
		Procedimiento procedimiento = procedimientoManager.getProcedimiento(idProcedimiento);
		List<Long> idsGrupo = grupoUsuarios.buscaIdsGrupos(usuario);
		
		for(Usuario usuarioGestor : gestorAdicionalAsuntomanager.findGestoresByAsunto(procedimiento.getAsunto().getId(), PREDOC)) {
			if(usuario.getUsername().equals(usuarioGestor.getUsername()) || idsGrupo.contains(usuarioGestor.getId())) {
				return true;
			}
		}
		
		// En el caso de la entidad Cajamar los preparadores son Gestor de estudio, Gestor de Documentación y Gestor de Liquidación		
		for(Usuario usuarioGestor : gestorAdicionalAsuntomanager.findGestoresByAsunto(procedimiento.getAsunto().getId(), CM_GE_PCO)) {
			if(usuario.getUsername().equals(usuarioGestor.getUsername()) || idsGrupo.contains(usuarioGestor.getId())) {
				return true;
			}
		}
		
		for(Usuario usuarioGestor : gestorAdicionalAsuntomanager.findGestoresByAsunto(procedimiento.getAsunto().getId(), CM_GD_PCO)) {
			if(usuario.getUsername().equals(usuarioGestor.getUsername()) || idsGrupo.contains(usuarioGestor.getId())) {
				return true;
			}
		}
		
		for(Usuario usuarioGestor : gestorAdicionalAsuntomanager.findGestoresByAsunto(procedimiento.getAsunto().getId(), CM_GL_PCO)) {
			if(usuario.getUsername().equals(usuarioGestor.getUsername()) || idsGrupo.contains(usuarioGestor.getId())) {
				return true;
			}
		}
		
// 		Se comprueba si el usuario conectado o un grupo al que pertenece está asignado al asunto como supervisor del expediente judicial
		for(Usuario usuarioGestor : gestorAdicionalAsuntomanager.findGestoresByAsunto(procedimiento.getAsunto().getId(), SUP_PCO)) {
			if(usuario.getUsername().equals(usuarioGestor.getUsername()) || idsGrupo.contains(usuarioGestor.getId())) {
				return true;
			}
		}
		
		return false;
	}
}

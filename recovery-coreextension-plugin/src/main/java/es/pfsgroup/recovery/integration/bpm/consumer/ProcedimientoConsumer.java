package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.DDSolvenciaGarantia;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.expediente.EXTExpedientesManager;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.persona.EXTPersonaManager;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.MEJRecursoManager;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.bienes.EXTBienesManager;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoDto;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.Guid;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoBienPayload;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.TareaExternaPayload;

public class ProcedimientoConsumer extends ConsumerAction<DataContainerPayload> {

	public final static String JBPM_CONTEXT_SOLICITUD_REMOTA = "solicitud.remota";

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private MEJRecursoManager mejRecursoManager;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	@Autowired
	private ProcedimientoManager procedimientoManager;

	@Autowired
	private EXTAsuntoManager extAsuntoManager;
	
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private TipoProcedimientoManager tipoProcedimientoManager;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private Executor executor;

	@Autowired
	private EXTExpedientesManager extExpedientesManager;
	
    @Autowired
    private JBPMProcessManager jbpmUtil;
	
    @Autowired
    private EXTPersonaManager extPersonaManager;
    
    @Autowired
    private EXTBienesManager extBienesManager;
    
	private boolean crearNuevo = false;
	private boolean iniciarBPM = false;
	private String forzarTipoProcedimiento = null;

	public ProcedimientoConsumer(Rule<DataContainerPayload> rules) {
		super(rules);
	}
	
	public ProcedimientoConsumer(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}

	public boolean isCrearNuevo() {
		return crearNuevo;
	}

	public void setCrearNuevo(boolean crearNuevo) {
		this.crearNuevo = crearNuevo;
	}
	
	public boolean isIniciarBPM() {
		return iniciarBPM;
	}

	public void setIniciarBPM(boolean iniciarBPM) {
		this.iniciarBPM = iniciarBPM;
	}

	public String getForzarTipoProcedimiento() {
		return forzarTipoProcedimiento;
	}

	public void setForzarTipoProcedimiento(String forzarTipoProcedimiento) {
		this.forzarTipoProcedimiento = forzarTipoProcedimiento;
	}

	protected String getGuidProcedimientoPadre(ProcedimientoPayload procedimiento) {
		return (this.isCrearNuevo()) 
				? procedimiento.getGuid() // String.format("%d-EXT", procedimiento.getIdOrigen())
				: procedimiento.getGuidProcedimientoPadre(); //String.format("%d-EXT", procedimiento.getIdOrigenProcedimientoPadre());
	}
	
	protected String getGuidProcedimiento(ProcedimientoPayload procedimiento) {
		return (this.isCrearNuevo()) 
				? Guid.getNewInstance().toString()
				: procedimiento.getGuid(); // String.format("%d-EXT", procedimiento.getIdOrigen());
	}

	protected String getGuidProcedimientoBien(ProcedimientoBienPayload procedimientoBien) {
		return (this.isCrearNuevo()) 
				? Guid.getNewInstance().toString()
				: procedimientoBien.getGuid(); // String.format("%d-EXT", procedimientoBien.getIdOrigen());
	}

	protected String getGuidTareaNotificacion(TareaExternaPayload tareaExternaPayload) {
		return tareaExternaPayload.getGuidTARTarea(); // String.format("%d-EXT", tareaExternaPayload.getIdTARTarea());
	}

	protected String getCodigoTipoProcedimiento(ProcedimientoPayload procedimiento) {
		return (!Checks.esNulo(this.getForzarTipoProcedimiento()))
				? this.getForzarTipoProcedimiento()
				: procedimiento.getTipoProcedimiento();
	}
	
	protected EXTProcedimientoDto buildProcedimientoDto(ProcedimientoPayload procedimiento) {
		String asuntoUUID = procedimiento.getAsunto().getGuid();
		String prcPadreUUID = getGuidProcedimientoPadre(procedimiento);
		String prcUUID = getGuidProcedimiento(procedimiento);
		String codigoTipoProcedimiento = getCodigoTipoProcedimiento(procedimiento);
		String valor;
		
		logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] Preparando datos para guardar procedimiento...", asuntoUUID, prcUUID));
		Procedimiento prc = (Checks.esNulo(prcUUID)) 
				? null 
				: extProcedimientoManager.getProcedimientoByGuid(prcUUID);
		
		EXTProcedimientoDto procDto = new EXTProcedimientoDto();
		if (prc!=null) {
			logger.debug(String.format("[INTEGRACION] ASU[%s] PRC[%s] Procedimiento encontrado, actualizando...", asuntoUUID, prcUUID));
			procDto.setIdProcedimiento(prc.getId());
		} else {
			logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] Procedimiento no encontrado, creando uno nuevo...", asuntoUUID, prcUUID));
			procDto.setGuid(prcUUID);

			// Asunto
			logger.debug(String.format("[INTEGRACION] ASU[%s] PRC[%s] Asignando asunto...", asuntoUUID, prcUUID));
			EXTAsunto asunto = extAsuntoManager.getAsuntoByGuid(asuntoUUID);
			if (asunto==null) {
				String logMsg = String.format("[INTEGRACION] ASU[%s] Asunto no encontrado!!!!, no se puede crear el procedimiento!!", asuntoUUID);
				logger.error(logMsg);
				throw new IntegrationDataException(logMsg);
			}
			procDto.setAsunto(asunto);

			// Tipo
			logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] TPO[%s] Asignando tipo procedimiento...", asuntoUUID, prcUUID, codigoTipoProcedimiento));
			TipoProcedimiento tipoProcedimiento = tipoProcedimientoManager.getByCodigo(codigoTipoProcedimiento);
			if (tipoProcedimiento==null) {
				String logMsg = String.format("[INTEGRACION] PRC[%s] TPO[%s] El tipo de procedimiento no existe!!, NO SE CREA EL PROCEDIMIENTO!!", prcUUID, codigoTipoProcedimiento);
				logger.error(logMsg);
				throw new IntegrationDataException(logMsg);
			}
			procDto.setTipoProcedimiento(tipoProcedimiento);
			
			// Prc Padre
			if (!Checks.esNulo(prcPadreUUID)) {
				MEJProcedimiento prcPadre = extProcedimientoManager.getProcedimientoByGuid(prcPadreUUID);
				procDto.setProcedimientoPadre(prcPadre);
			}
			
			procDto.setDecidido(procedimiento.getDecidido());
		}

		// DD tipoReclamacion
		valor = procedimiento.getTipoReclamacion();
		DDTipoReclamacion tipoReclamacion = (DDTipoReclamacion)diccionarioApi.dameValorDiccionarioByCod(DDTipoReclamacion.class, valor);
		procDto.setTipoReclamacion(tipoReclamacion);
		
		// DD estado
		valor = procedimiento.getEstado();
		DDEstadoProcedimiento estadoProcedimiento = (DDEstadoProcedimiento)diccionarioApi.dameValorDiccionarioByCod(DDEstadoProcedimiento.class, valor);
		procDto.setEstadoProcedimiento(estadoProcedimiento);

		// DD juzgado
		valor = procedimiento.getJuzgado();
		if (!Checks.esNulo(valor)) {
			logger.debug(String.format("[INTEGRACION] ASU[%s] PRC[%s] JUZ[%s] Asignando juzgado...", asuntoUUID, prcUUID, valor));
			TipoJuzgado juzgado = (TipoJuzgado)diccionarioApi.dameValorDiccionarioByCod(TipoJuzgado.class, valor);
			procDto.setJuzgado(juzgado);
		}
		
		procDto.setFechaRecopilacion(procedimiento.getFechaRecopilacion());
		procDto.setCodigoProcedimientoEnJuzgado(procedimiento.getCodigoProcedimientoEnJuzgado());
		procDto.setObservacionesRecopilacion(procedimiento.getObservacionesRecopilacion());
		procDto.setPlazoRecuperacion(procedimiento.getPlazoRecuperacion());
		procDto.setPorcentajeRecuperacion(procedimiento.getPorcentajeRecuperacion());
		procDto.setSaldoOriginalNoVencido(procedimiento.getSaldoOriginalNoVencido());
		procDto.setSaldoOriginalVencido(procedimiento.getSaldoOriginalVencido());
		procDto.setSaldoRecuperacion(procedimiento.getSaldoRecuperacion());
		
		logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] Asignando lista contrados-expediente...", asuntoUUID, prcUUID));
		List<ExpedienteContrato> expContratoList = mergeExpedienteContratos(procedimiento, prc);
		procDto.setExpedienteContratos(expContratoList);
		logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] Asignando lista personas...", asuntoUUID, prcUUID));
		List<Persona> personaList = mergePersonas(procedimiento, prc);
		procDto.setPersonas(personaList);
		List<ProcedimientoBien> prcBienList = mergeProcedimientoBienes(procedimiento, prc);
		procDto.setBienes(prcBienList);

		//
		logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] Datos preparados para guardar procedimiento!!", asuntoUUID, prcUUID));
		return procDto;
	}
	
	private List<ExpedienteContrato> mergeExpedienteContratos(ProcedimientoPayload procedimiento, Procedimiento prc) {
		List<String> cexGuids = procedimiento.getGuidContratos();
		if (cexGuids==null) {
			return null;
		}
		
		// Merge...
		List<ExpedienteContrato> resultado = new ArrayList<ExpedienteContrato>();
		if (prc!=null) {
			List<ExpedienteContrato> origen = prc.getExpedienteContratos();
			for (ExpedienteContrato cex : origen) {
				if (!Checks.esNulo(cex.getGuid()) && cexGuids.contains(cex.getGuid())) {
					cexGuids.remove(cex.getGuid());
					resultado.add(cex);
				}
			}
		}
		// El resto
		for (String guid : cexGuids) {
			ExpedienteContrato cnt = extExpedientesManager.getExpedienteContratoByGuid(guid);
			resultado.add(cnt);
		}
		return resultado;
	}

	private List<Persona> mergePersonas(ProcedimientoPayload procedimiento, Procedimiento prc) {
		List<String> perGuids = procedimiento.getGuidPersonas();
		if (perGuids==null) {
			return null;
		}
		// Merge
		List<Persona> resultado = new ArrayList<Persona>();
		if (prc!=null) {
			List<Persona> origen = prc.getPersonasAfectadas();
			for (Persona per : origen) {
				String codCliente = per.getCodClienteEntidad().toString();
				if (perGuids.contains(codCliente)) {
					perGuids.remove(codCliente);
					resultado.add(per);
				}
			}
		}
		// El resto
		for (String codClienteEntidad : perGuids) {
			Persona per = extPersonaManager.getPersonaByCodClienteEntidad(Long.parseLong(codClienteEntidad));
			resultado.add(per);
		}
		return resultado;
	}
	

	private List<ProcedimientoBien> mergeProcedimientoBienes(ProcedimientoPayload procedimiento, Procedimiento prc) {
		List<ProcedimientoBienPayload> bienes = procedimiento.getProcedimientoBien();
		if (bienes==null) {
			return null;
		}
		
		// Merge
		Map<String, ProcedimientoBienPayload> prcBienGuids = new HashMap<String, ProcedimientoBienPayload>();
		for (ProcedimientoBienPayload procedimientoBienDatos : bienes) {
			String prcBienGuid = getGuidProcedimientoBien(procedimientoBienDatos);
			prcBienGuids.put(prcBienGuid, procedimientoBienDatos);
		}

		// Merge
		List<ProcedimientoBien> resultado = new ArrayList<ProcedimientoBien>();
		if (prc!=null) {
			List<ProcedimientoBien> origen = prc.getBienes();
			for (ProcedimientoBien prcBien : origen) {
				boolean borrado = true;
				if (prcBienGuids.containsKey(prcBien.getGuid())) {
					ProcedimientoBienPayload prcBienDatos = prcBienGuids.get(prcBien.getGuid());
					borrado = prcBienDatos.getBorrado();
					String solvencia = prcBienDatos.getSolvenciaGaratia();
					if (Checks.esNulo(solvencia)) {
						DDSolvenciaGarantia solvenciaGar = (DDSolvenciaGarantia)diccionarioApi.dameValorDiccionarioByCod(DDSolvenciaGarantia.class, solvencia);
						prcBien.setSolvenciaGarantia(solvenciaGar);	
					}
					prcBienGuids.remove(prcBien.getGuid());
				}
				
				if (borrado) {
					prcBien.getAuditoria().setBorrado(true);
					prcBien.getAuditoria().setFechaBorrar(new Date());
				}
				resultado.add(prcBien);
			}
		}
		for (String s : prcBienGuids.keySet()) {
			ProcedimientoBienPayload procedimientoBienDatos = prcBienGuids.get(s);
			String prcBienGuid = getGuidProcedimientoBien(procedimientoBienDatos);
			
			ProcedimientoBien prcBien = extBienesManager.getProcedimientoBienByGuid(prcBienGuid);
			if (prcBien==null) {
				prcBien = new ProcedimientoBien();
				prcBien.setAuditoria(Auditoria.getNewInstance());

				// Recupera el bien
				String codigoInternoBien = procedimientoBienDatos.getCodigoInternoDelBien();
				NMBBien bien = extBienesManager.getBienByCodigoInterno(codigoInternoBien);
				if (bien==null) {
					continue;
				}
				prcBien.setBien(bien);
			}
			prcBien.setGuid(prcBienGuid);
			Boolean borrado = procedimientoBienDatos.getBorrado();
			if (borrado!=null && borrado) {
				prcBien.getAuditoria().setBorrado(true);
				prcBien.getAuditoria().setFechaBorrar(new Date());
			}
			resultado.add(prcBien);
		}

		return resultado;
	}
	
	protected void iniciarBPM(DataContainerPayload payload, Procedimiento prc) {
		TareaExternaPayload tareaExternaPayload = new TareaExternaPayload(payload);
		String tarUUID = getGuidTareaNotificacion(tareaExternaPayload);

		// Lanzar los JBPM para cada procedimiento
		logger.info(String.format("[INTEGRACION] PRC[%d] TAR[%s] Iniciando BPM...", prc.getId(), tarUUID));
        String nombreJBPM = prc.getTipoProcedimiento().getXmlJbpm();
        Map<String, Object> param = new HashMap<String, Object>();
        param.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, prc.getId());
        param.put(ProcedimientoPayload.JBPM_TAR_GUID_ORIGEN, tarUUID);
        param.put(ProcedimientoConsumer.JBPM_CONTEXT_SOLICITUD_REMOTA, true);
        Long idBPM = jbpmUtil.crearNewProcess(nombreJBPM, param);
        //
        prc.setProcessBPM(idBPM);
        //suplantarUsuario(prc);
        procedimientoManager.saveOrUpdateProcedimiento(prc);
		logger.info(String.format("[INTEGRACION] PRC[%d] TAR[%s] BPM iniciado!!", prc.getId(), tarUUID));
	}
	
	@Override
	protected void doAction(DataContainerPayload payload) {
		ProcedimientoPayload procedimiento = new ProcedimientoPayload(payload);
		String prcUUID = getGuidProcedimiento(procedimiento);
		//
		logger.info(String.format("[INTEGRACION] PRC[%s] Guardando procedimiento...", prcUUID));
		EXTProcedimientoDto procDto = buildProcedimientoDto(procedimiento);
		//
		Procedimiento prc = extProcedimientoManager.guardaProcedimiento(procDto);
		logger.info(String.format("[INTEGRACION] PRC[%s] Procedimiento guardado!!!", prcUUID));
		
		if (this.isIniciarBPM()) {
			iniciarBPM(payload, prc);
		}

	}

}

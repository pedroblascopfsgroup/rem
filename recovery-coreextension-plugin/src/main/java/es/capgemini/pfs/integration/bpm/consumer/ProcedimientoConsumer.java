package es.capgemini.pfs.integration.bpm.consumer;

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
import es.capgemini.pfs.asunto.dto.ProcedimientoDto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.integration.AsuntoPayload;
import es.capgemini.pfs.integration.ConsumerAction;
import es.capgemini.pfs.integration.IntegrationDataException;
import es.capgemini.pfs.integration.Rule;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.MEJRecursoManager;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;

public class ProcedimientoConsumer extends ConsumerAction<AsuntoPayload> {

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
    private JBPMProcessManager jbpmUtil;
	
	private boolean crearNuevo = false;
	private boolean iniciarBPM = false;
	private String forzarTipoProcedimiento = null;
	
	public ProcedimientoConsumer(Rule<AsuntoPayload> rules) {
		super(rules);
	}
	
	public ProcedimientoConsumer(List<Rule<AsuntoPayload>> rules) {
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

	protected String getGuidProcedimientoPadre(AsuntoPayload message) {
		return (this.isCrearNuevo()) 
				? message.getGuidProcedimiento()
				: message.getGuidProcedimientoPadre(); // "0a9012c8-6091-4a5b-9497-d1453d1cd81a"
	}
	
	protected String getGuidProcedimiento(AsuntoPayload message) {
		return (this.isCrearNuevo()) 
				? null 
				: String.format("%d-EXT", message.getIdProcedimiento()); //message.getGuidProcedimiento();
	}

	protected String getGuidTareaNotificacion(AsuntoPayload message) {
		return String.format("%d-EXT", message.getIdTARTarea()); // message.getGuidTARTarea();
	}

	protected String getCodigoTipoProcedimiento(AsuntoPayload payload) {
		return (!Checks.esNulo(this.getForzarTipoProcedimiento()))
				? this.getForzarTipoProcedimiento()
				: payload.getCodigoProcedimiento();
	}
	
	private MEJProcedimiento creaProcedimientoPadre(AsuntoPayload payLoad, String codTipoProcedimiento) {
		ProcedimientoDto procDto = new ProcedimientoDto();
		
		EXTAsunto asunto = extAsuntoManager.getAsuntoByGuid(payLoad.getGuidAsunto());
		if (asunto==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] Asunto con guid %s no existe, no se puede crear el procedimiento", payLoad.getGuidAsunto()));
		}
		procDto.setIdProcedimiento(null);
		procDto.setAsunto(asunto.getId());
		procDto.setTipoProcedimiento(codTipoProcedimiento);
		//
		String valor = String.format("%s.tipoActuacion", AsuntoPayload.KEY_PROCEDIMIENTO);
		if (payLoad.getCodigo().containsKey(valor)) {
			procDto.setActuacion(payLoad.getCodigo().get(valor));
		}
		//
		valor = String.format("%s.tipoReclamacion", AsuntoPayload.KEY_PROCEDIMIENTO);
		if (payLoad.getCodigo().containsKey(valor)) {
			procDto.setTipoReclamacion(payLoad.getCodigo().get(valor));
		}
		procDto.setSeleccionPersonas(payLoad.getExtraInfo().get(String.format("%s.personasAfectadas", AsuntoPayload.KEY_PROCEDIMIENTO)));
		
		procDto.setPlazo(payLoad.getValInt().get(String.format("%s.plazoRecuperacion", AsuntoPayload.KEY_PROCEDIMIENTO)));
		procDto.setRecuperacion(payLoad.getValInt().get(String.format("%s.porcentajeRecuperacion", AsuntoPayload.KEY_PROCEDIMIENTO)));
		procDto.setSaldorecuperar(payLoad.getValBDec().get(String.format("%s.saldoRecuperacion", AsuntoPayload.KEY_PROCEDIMIENTO)));
		procDto.setSaldoOriginalVencido(payLoad.getValBDec().get(String.format("%s.saldoOriginalVencido", AsuntoPayload.KEY_PROCEDIMIENTO)));
		procDto.setSaldoOriginalNoVencido(payLoad.getValBDec().get(String.format("%s.saldoOriginalNoVencido", AsuntoPayload.KEY_PROCEDIMIENTO)));
	
		Long idPrc = (Long)executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GUARDAR_PROCEDIMIMENTO, procDto);
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoById(idPrc);
		return prc;
	}
	
	private MEJProcedimiento creaProcedimientoHijo(AsuntoPayload payload, MEJProcedimiento prcPadre, String codTipoProcedimiento) {
		TipoProcedimiento tipoProcedimiento = tipoProcedimientoManager.getByCodigo(codTipoProcedimiento);
		if (tipoProcedimiento==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El tipo de procedimiento %s no existe para padre %s, NO SE CREA EL PROCEDIMIENTO.", codTipoProcedimiento, prcPadre.getGuid()));
		}
		logger.debug(String.format("[INTEGRACION] TPO [%s] Tipo de prodedimiento encontrado para prc_padre %s.", tipoProcedimiento.getCodigo(), prcPadre.getGuid()));
		Procedimiento prcHijo = (Procedimiento)executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREA_PROCEDIMIENTO_HIJO
				, tipoProcedimiento
				, prcPadre);
		logger.debug(String.format("[INTEGRACION] TPO[%s] prodedimiento creado", tipoProcedimiento.getCodigo()));
		
		if (!(prcHijo instanceof MEJProcedimiento)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] PRC [%d] Instancia de procedimiento no correcta.", prcHijo.getId()));
		}
		MEJProcedimiento prc = (MEJProcedimiento)prcHijo;
		return prc;
	}

	protected MEJProcedimiento decidirCreacionProcedimiento(AsuntoPayload payload) {
		String prcPadreUUID = getGuidProcedimientoPadre(payload);
		String prcUUID = getGuidProcedimiento(payload);
		String codigoTipoProcedimiento = getCodigoTipoProcedimiento(payload);
		
		logger.debug(String.format("[INTEGRACION] PRC [%s] Decidiendo creación o no de procedimiento", prcUUID));
		
		// Crea un procedimiento padre si no tiene padre
		MEJProcedimiento prc = (Checks.esNulo(prcUUID)) 
				? null 
				: extProcedimientoManager.getProcedimientoByGuid(prcUUID);
		if (prc==null) {
			logger.debug(String.format("[INTEGRACION] Creando procedimiento de tipo %s ...", codigoTipoProcedimiento));
			MEJProcedimiento prcPadre = extProcedimientoManager.getProcedimientoByGuid(prcPadreUUID);
			if (prcPadre==null) {
				logger.debug(String.format("[INTEGRACION] No se encuentra padre con guid %s, por tanto elección procedimiento sin padre", prcPadreUUID));
				//throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento padre %s no existe.", prcPadre));
				prc = creaProcedimientoPadre(payload, codigoTipoProcedimiento);
			} else {
				logger.debug(String.format("[INTEGRACION] Elección procedimiento con padre %s", prcPadreUUID));
				prc = creaProcedimientoHijo(payload, prcPadre, codigoTipoProcedimiento);
			}
			logger.debug(String.format("[INTEGRACION] Procedimiento %d de tipo %s creado!", prc.getId(), codigoTipoProcedimiento));
			prc.setGuid(prcUUID);
		} 
		return prc;
	}

	protected void iniciarBPM(AsuntoPayload payload, Procedimiento prc) {

		String tarUUID = getGuidTareaNotificacion(payload);

		// Lanzar los JBPM para cada procedimiento
		logger.debug(String.format("[INTEGRACION] PRC [%d] Iniciando BPM...", prc.getId()));
        String nombreJBPM = prc.getTipoProcedimiento().getXmlJbpm();
        Map<String, Object> param = new HashMap<String, Object>();
        param.put(BPMContants.PROCEDIMIENTO_TAREA_EXTERNA, prc.getId());
        param.put(AsuntoPayload.JBPM_TAR_GUID_ORIGEN, tarUUID);
        Long idBPM = jbpmUtil.crearNewProcess(nombreJBPM, param);
        
        //
        prc.setProcessBPM(idBPM);
        procedimientoManager.saveOrUpdateProcedimiento(prc);
        
		logger.debug(String.format("[INTEGRACION] PRC [%d] BPM creado...", prc.getId()));
	}
	
	@Override
	protected void doAction(AsuntoPayload payload) {

		// Decide la creación del procedimiento
		MEJProcedimiento prc = decidirCreacionProcedimiento(payload);

		// Esto lo hacemos siempre porque vienen más campos....
		logger.debug(String.format("[INTEGRACION] PRC [%d] Guardando datos adicionales de cabecera de procedimiento.", prc.getId()));
		prc.setPorcentajeRecuperacion(payload.getValInt().get(String.format("%s.porcentajeRecuperacion", AsuntoPayload.KEY_PROCEDIMIENTO)));
		prc.setPlazoRecuperacion(payload.getValInt().get(String.format("%s.plazoRecuperacion", AsuntoPayload.KEY_PROCEDIMIENTO)));
		//prc.setSaldoRecuperacion(payload.getValBDec().get("saldoRecuperacion")); <<< NO SE PORQUE NO GUARDA ESTE CAMPO, AL HACER EL COMMIT DA UN ERROR DE SOCKET!!!!!! SE COMENTA
		prc.setSaldoOriginalVencido(payload.getValBDec().get(String.format("%s.saldoOriginalVencido", AsuntoPayload.KEY_PROCEDIMIENTO)));
		prc.setSaldoOriginalNoVencido(payload.getValBDec().get(String.format("%s.saldoOriginalNoVencido", AsuntoPayload.KEY_PROCEDIMIENTO)));
		prc.setCodigoProcedimientoEnJuzgado(payload.getExtraInfo().get(String.format("%s.procEnJuzgado", AsuntoPayload.KEY_PROCEDIMIENTO)));
		
		String valor = payload.getCodigo().get(String.format("%s.juzgado", AsuntoPayload.KEY_PROCEDIMIENTO));
		if (!Checks.esNulo(valor)) {
			TipoJuzgado juzgado = (TipoJuzgado)diccionarioApi.dameValorDiccionarioByCod(TipoJuzgado.class, valor);
			prc.setJuzgado(juzgado);
		}
		prc.setFechaRecopilacion(payload.getFecha().get(String.format("%s.recopilacion", AsuntoPayload.KEY_PROCEDIMIENTO)));
		prc.setObservacionesRecopilacion(payload.getExtraInfo().get(String.format("%s.observaciones", AsuntoPayload.KEY_PROCEDIMIENTO)));
		procedimientoDao.saveOrUpdate(prc);
		logger.debug(String.format("[INTEGRACION] PRC [%d] Datos adicionales de cabecera de procedimiento guardados!", prc.getId()));
		
		if (this.isIniciarBPM()) {
			iniciarBPM(payload, prc);
		}
		
	}

}

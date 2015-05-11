package es.pfsgroup.concursal.analisisContratos;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.JbpmContext;
import org.jbpm.graph.exe.Token;
import org.springframework.beans.factory.annotation.Autowired;
import org.springmodules.workflow.jbpm31.JbpmCallback;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.procedimientos.contratos.IteradorActionHandler;
import es.pfsgroup.recovery.api.JBPMProcessApi;

@Service("analisisContratoBPMManager")
public class AnalisisContratosBPMManager {

	protected final Log logger = LogFactory.getLog(getClass());
	
	private static final String TAREA_DICTAR_INSTRUCCIONES_CODIGO = "P402_DictarInstrucciones";
	private static final String TAREA_DICTAR_INSTRUCCIONES_CAMPO_INSTRUCCIONES = "instrucciones";
	
	public static final String BO_NMB_ANALISIS_CONTRATOS_NOMBRE_CONTRATO_ASIGNADO_A_TAREA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.dameContratoAsignadoATarea";
	public static final String BO_NMB_ANALISIS_CONTRATOS_NOMBRE_CONTRATO_ASIGNADO_A_BPM = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.dameContratoAsignadoABPM";
	public static final String BO_NMB_ANALISIS_CONTRATOS_EXISTEN_INSTRUCCIONES_EN_TAREA = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.existenInstruccionesEnTarea";
	public static final String BO_NMB_ANALISIS_CONTRATOS_INSTRUCCIONES_INICIO_EXPEDIENTE_JUD = "es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.dameInstruccionesInicioExpedienteJudicial";
    
	@Autowired
	private ProcessManager processManager;

	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	/**
	 * Recupera la información codificada un contrato desde su ID en string
	 * @param contratoId
	 * @return
	 */
	private String dameContratoDescripcion(String contratoId) {
		String contrato = StringUtils.EMPTY;
		// Recupera el Nombre de contrato.
		if (StringUtils.isNotBlank(contratoId)) {
			try {
			Long idContrato = Long.parseLong(contratoId);  
			Contrato contratoObj = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);
			contrato = contratoObj.getDescripcionProductoCodificada();
			} catch (NumberFormatException ex) {
				logger.error(String.format("Error convirtiendo Id contrato {0} en Long.", contratoId));
			}
		} else {
			logger.warn(String.format("Id de contrato erróneo {0}.", contratoId));
		}
		return contrato;
	}
	
	/**
	 * Recupera el Contrato para el que se ha generado este token/tarea
	 * 
	 * @param idProcedimiento id del procedimiento desde el que se llama.
	 * @param tokenId identificador del token desde el cual estamos llamando
	 * @return Contrato
	 */
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_NOMBRE_CONTRATO_ASIGNADO_A_TAREA)
	public String dameContratoAsignadoATarea(Long idProcedimiento, final Long tokenId) {

		JBPMProcessApi jbpmApi = proxyFactory.proxy(JBPMProcessApi.class);
		String contrato = "no encontrado";
		
		Procedimiento proc = (Procedimiento) executor.execute(
				ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
				idProcedimiento);
		
		final Long idTokenParent = (Long) processManager.execute(new JbpmCallback() {
			@Override
			public Object doInJbpm(JbpmContext context) {
				return context.getGraphSession().getToken(tokenId).getParent().getId();
			}
		});
		
		
		String varIdAssigned = String.format(IteradorActionHandler.STR_LOOP_ID_ASSIGNED, idTokenParent);
		contrato = (String)jbpmApi.getVariablesToProcess(proc.getProcessBPM() ,varIdAssigned);
		contrato = dameContratoDescripcion(contrato);
		
		return contrato;
	}

	
	/**
	 * Recupera el Contrato para el que se ha generado este BPM
	 * 
	 * @param idProcedimiento id del procedimiento desde el que se llama.
	 * @return Contrato
	 */
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_NOMBRE_CONTRATO_ASIGNADO_A_BPM)
	public String dameContratoAsignadoABPM(Long idProcedimiento) {
		
		JBPMProcessApi jbpmApi = proxyFactory.proxy(JBPMProcessApi.class);
		
		Procedimiento proc = (Procedimiento) executor.execute(
				ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
				idProcedimiento);

		// Recupera la tarea Dictar instrucciones que contiene las instrucciones
		
		final Long idTokenPadre = (Long)jbpmApi.getVariablesToProcess(proc.getProcessBPM(), BPMContants.TOKEN_JBPM_PADRE);
		String contrato = (String) processManager.execute(new JbpmCallback() {
			@Override
			public Object doInJbpm(JbpmContext context) {
				String varIdAssigned = String.format(IteradorActionHandler.STR_LOOP_ID_ASSIGNED, idTokenPadre);
				// si venimos una tarea accedemos al padre que tiene la variable 
				Object contratoId = context.getGraphSession().getToken(idTokenPadre).getProcessInstance().getContextInstance().getVariable(varIdAssigned);
				if (contratoId == null) { // en caso de no tenerla accedemos al abuelo.
					Long idPadre = context.getGraphSession().getToken(idTokenPadre).getParent().getId();
					varIdAssigned = String.format(IteradorActionHandler.STR_LOOP_ID_ASSIGNED, idPadre);
					contratoId = context.getGraphSession().getToken(idTokenPadre).getProcessInstance().getContextInstance().getVariable(varIdAssigned);
				}
				return contratoId;
			}
		});
		contrato = dameContratoDescripcion(contrato);
		return contrato;
	}

	/**
	 * Devuelve si se han introducido o no instrucciones en la tarea  Dictar Instrucciones:
	 * TAREA_DICTAR_INSTRUCCIONES_CAMPO_INSTRUCCIONES
	 * 
	 * @param idTareaExterna  Id de tarea desde la que se llama
	 * @return true o false
	 */
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_EXISTEN_INSTRUCCIONES_EN_TAREA)
	public Boolean existenInstruccionesEnTarea(Long idTareaExterna) {
		
		TareaExterna tareaExterna = (TareaExterna)executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET, idTareaExterna); 
		if (tareaExterna == null) {
			return false;
		}
		
		// Recupera el valor de las instrucciones
		Boolean retorno = false;
		for (TareaExternaValor valor : tareaExterna.getValores()) {
			if (TAREA_DICTAR_INSTRUCCIONES_CAMPO_INSTRUCCIONES.equals(valor.getNombre())) {
				retorno = StringUtils.isNotBlank(valor.getValor());
				break;
			}
		}
		return retorno;
	}

	/**
	 * Devuelve las instrucciones para inicio de expediente judicial.
	 * Las busca en las tareas padre dentro de la tarea definida en TAREA_DICTAR_INSTRUCCIONES_CODIGO
	 * 
	 * @param idProcedimiento id del procedimiento desde el que se llama
	 * @return
	 */
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_INSTRUCCIONES_INICIO_EXPEDIENTE_JUD)
	public String dameInstruccionesInicioExpedienteJudicial(Long idProcedimiento) {
		
		JBPMProcessApi jbpmApi = proxyFactory.proxy(JBPMProcessApi.class);
		
		Procedimiento proc = (Procedimiento) executor.execute(
				ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
				idProcedimiento);

		// Recupera la tarea Dictar instrucciones que contiene las instrucciones
		final Long idTokenPadre = (Long)jbpmApi.getVariablesToProcess(proc.getProcessBPM(), BPMContants.TOKEN_JBPM_PADRE);
		Long idTareaExternaDictarInstrucciones = (Long) processManager.execute(new JbpmCallback() {
			@Override
			public Object doInJbpm(JbpmContext context) {
				String varTareaExternaDictarInstrucciones = String.format("id%s.%d", TAREA_DICTAR_INSTRUCCIONES_CODIGO, idTokenPadre);
				if (idTokenPadre==null) return null;
				Token tokenPadre = context.getGraphSession().getToken(idTokenPadre); 
				return tokenPadre.getProcessInstance().getContextInstance().getVariable(varTareaExternaDictarInstrucciones);
			}
		});
		if (idTareaExternaDictarInstrucciones == null) {
			return StringUtils.EMPTY;
		}
		
		TareaExterna tareaExterna = (TareaExterna)executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET, idTareaExternaDictarInstrucciones); 
		if (tareaExterna == null) {
			return StringUtils.EMPTY;
		}
		
		// Recupera el valor de las instrucciones
		String instrucciones = "no se han dictado instrucciones";
		for (TareaExternaValor valor : tareaExterna.getValores()) {
			if (TAREA_DICTAR_INSTRUCCIONES_CAMPO_INSTRUCCIONES.equals(valor.getNombre())) {
				instrucciones = valor.getValor();
			}
		}
		return instrucciones;
	}
	
}

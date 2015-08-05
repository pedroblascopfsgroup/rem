package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.ProcedimientoPayload;
import es.pfsgroup.recovery.integration.bpm.TareaExternaPayload;

/**
 * Transiciona un BPM según la transición desde el token que llega. 
 *  
 * @author gonzalo
 *
 */
public class TransicionarTareaBPM extends ConsumerAction<DataContainerPayload> {

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private EXTTareaNotificacionManager extTareaNotificacionManager;
	
    @Autowired
    private JBPMProcessManager jbpmUtil;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private TareaExternaValorDao tareaExternaValorDao;
    
    private String forzarTransicion;
    
	public TransicionarTareaBPM(Rule<DataContainerPayload> rule) {
		super(rule);
	}
	
	public TransicionarTareaBPM(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}

	public String getForzarTransicion() {
		return forzarTransicion;
	}

	public void setForzarTransicion(String forzarTransicion) {
		this.forzarTransicion = forzarTransicion;
	}
	
	private String getGuidTareaATransicionar(ProcedimientoPayload procedimiento) {
		if (Checks.esNulo(procedimiento.getTransicionBPM())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El mensaje no contiene la Info. extra '%s', indica el guid de la tarea sobre la que se va a generar la transición.", ProcedimientoPayload.JBPM_TAR_GUID_ORIGEN));
		}
		String tarGUID =  procedimiento.getTareaOrigenDelBPM();
		if (Checks.esNulo(tarGUID)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] No se ha indicado GUID de la tarea a transicionar.", tarGUID));
		}
		return tarGUID; 
	}

	private String getTransicionPropuesta(ProcedimientoPayload procedimiento) {
		return (!Checks.esNulo(procedimiento.getTransicionBPM())) 
				? procedimiento.getTransicionBPM() 
				: null;
	}
	
	protected void doTransicion(ProcedimientoPayload procedimiento, TareaExterna tex) {
		String transicionPropuesta = (!Checks.esNulo(forzarTransicion)) ? forzarTransicion : getTransicionPropuesta(procedimiento);
		if (Checks.esNulo(transicionPropuesta)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] TEX [%d] La tansición no se ha enviado, no se puede transicionar", tex.getId()));
		}
		logger.debug(String.format("[INTEGRACION] TEX [%d] transición candidata: %s", tex.getId(), transicionPropuesta));
		Long tokenId = tex.getTokenIdBpm();
		if (Checks.esNulo(tokenId)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] TEX [%d] La tarea asignada no tiene token BPM, no se puede transicionar", tex.getId()));
		}
		if (!jbpmUtil.hasTransitionToken(tokenId, transicionPropuesta)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] TEX [%d] La transicion %s no existe para esta tarea, Token %d no se puede transicionar", tex.getId(), transicionPropuesta, tokenId));
		}
		logger.info(String.format("[INTEGRACION] TEX [%d] transicionando a través de %s", tex.getId(), transicionPropuesta));
		saveFormValues(procedimiento.getData(), tex);
		jbpmUtil.signalToken(tex.getTokenIdBpm(), transicionPropuesta);
	}
	
	
	@Override
	protected void doAction(DataContainerPayload payload) {
		ProcedimientoPayload procedimiento = new ProcedimientoPayload(payload);
		String tarGUID = getGuidTareaATransicionar(procedimiento);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Inciando transición en tarea...", tarGUID));
		// OJO! El procediento padre del nuevo BPM será el procedimiento desde el que se genera (no el padre de este!).
		EXTTareaNotificacion tarNotif = extTareaNotificacionManager.getTareaNoficiacionByGuid(tarGUID);
		if (tarNotif==null || tarNotif.getTareaExterna()==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] TAR [%s] La tarea externa a transicionar no existe.", tarGUID));
		}
		doTransicion(procedimiento, tarNotif.getTareaExterna());
		logger.debug(String.format("[INTEGRACION] TAR [%s] Transición completada!", tarGUID));
	}

	
	private void saveFormValues(DataContainerPayload payload, TareaExterna tarea) {
		String tapCodigo = tarea.getTareaProcedimiento().getCodigo();
		logger.debug(String.format("[INTEGRACION] TAP [%s] Guardando campos formulario en tarea.", tapCodigo));
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", tarea.getTareaProcedimiento().getId()); 
		List<GenericFormItem> items = genericDao.getList(GenericFormItem.class, filtro);

		logger.debug(String.format("[INTEGRACION] TAP [%s] Num de items para encontrados en tarea: %d", tapCodigo, items.size()));
		
		for (GenericFormItem item : items) {
			if (!contieneValorParaCampo(payload, item.getNombre())) {
				logger.warn(String.format("[INTEGRACION] TAP [%s] TFI [%s] Campo no existe en la definición de recovery. ", tapCodigo, item.getNombre()));
				continue;
			}
			String valor = getValorCampoFormulario(payload, item.getNombre());

			EXTTareaExternaValor tevValor = new EXTTareaExternaValor();
			tevValor.setTareaExterna(tarea);
			tevValor.setNombre(item.getNombre());
			tevValor.setValor(valor);
			//suplantarUsuario(tareaExtenaPayload.getUsuario(), tevValor);

			// listaValores.add(valor);
			tareaExternaValorDao.saveOrUpdate(tevValor);
		}
		logger.debug(String.format("[INTEGRACION] TAP [%s] Fin campos guardados formulario.", tapCodigo));
	}
	
	private boolean contieneValorParaCampo(DataContainerPayload payload, String campo) {
		return payload.getExtraInfo().containsKey(String.format("%s.%s", ProcedimientoPayload.EXTRA_FIELD, campo));
	}

	private String getValorCampoFormulario(DataContainerPayload payload, String campo) {
		return (contieneValorParaCampo(payload, campo)) 
				? payload.getExtraInfo(String.format("%s.%s", ProcedimientoPayload.EXTRA_FIELD, campo)) 
				: null; 
	}
	
}

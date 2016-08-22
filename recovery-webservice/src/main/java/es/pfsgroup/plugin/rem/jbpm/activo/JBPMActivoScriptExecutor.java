package es.pfsgroup.plugin.rem.jbpm.activo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import es.capgemini.devon.scripting.ScriptEvaluator;
import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;

//@org.springframework.stereotype.Service(JBPMProcessManager.BEAN_KEY)
@Service("jbpmActivoScriptExecutor")
@Scope(BeanDefinition.SCOPE_SINGLETON)
public class JBPMActivoScriptExecutor implements JBPMActivoScriptExecutorApi {
	
    private final Log logger = LogFactory.getLog(getClass());
	
    @Autowired
    JBPMActivoTramiteManagerApi jbpmActivoTramiteManagerApi;
    
    @Autowired
    private ActivoTramiteApi activoTramiteManager;

    @Autowired
    private ActivoApi activoManager;
    
    @Autowired
    private ActivoTareaExternaApi tareaExternaManagerApi;
    
    @Autowired
    private TrabajoApi trabajoManager;
    
    @Resource
    private List<String> clasesDiccionarioAnotadas;

    private Map<String, Object> clasesDiccionario;
    
    private List<String> contextScripts;
    
    @Autowired
    private ScriptEvaluator evaluator;
	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcedimientoContextScriptManagerApi#setContextScripts(java.util.List)
	 */
	@Override
	public void setContextScripts(List<String> contextScript) {
        this.contextScripts = contextScript;
    }

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcedimientoContextScriptManagerApi#getContextScripts()
	 */
	@Override
	public List<String> getContextScripts() {
        return contextScripts;
    }
    
    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcedimientoContextScriptManagerApi#evaluaScriptPorContexto(java.lang.Long, java.lang.Long, java.lang.Long, java.util.Map, java.lang.String)
	 */
    @Override
	public Object evaluaScriptPorContexto(Long idTramite, Long idTareaExterna, Long idTareaProcedimiento, Map<String, Object> contextoOriginal,
            String script) throws Exception {
        if (!StringUtils.isBlank(script)) {
            Map<String, Object> params = new HashMap<String, Object>();
            if (Checks.esNulo(contextoOriginal)) {
            	params = creaContextoParaScript(idTramite, idTareaExterna, idTareaProcedimiento);
            } else {
                params.putAll(contextoOriginal);
            }
            String scriptAmpliado = getContextScriptsAsString() + script;

            return evaluator.evaluate(scriptAmpliado, params);
        }

        return null;
    }
    
    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcedimientoContextScriptManagerApi#evaluaScript(java.lang.Long, java.lang.Long, java.lang.Long, java.util.Map, java.lang.String)
	 */
    @Override
	public Object evaluaScript(Long idTramite, Long idTareaExterna, Long idTareaProcedimiento, Map<String, Object> contextoOriginal,
            String script) throws Exception {
        if (!StringUtils.isBlank(script)) {
            Map<String, Object> params = creaContextoParaScript(idTramite, idTareaExterna, idTareaProcedimiento);
            if (!Checks.esNulo(contextoOriginal)) {
                params.putAll(contextoOriginal);
            }
            String scriptAmpliado = getContextScriptsAsString() + script;

            return evaluator.evaluate(scriptAmpliado, params);
        }

        return null;
    }

    /* (non-Javadoc)
	 * @see es.pfsgroup.plugin.rem.test.jbpm.JBPMProcedimientoContextScriptManagerApi#getContextoParaScript(java.lang.Long, java.lang.Long, java.lang.Long)
	 */
    @Override
	public Map<String, Object> getContextoParaScript(Long idTramite, Long idTareaExterna, Long idTareaProcedimiento) throws ClassNotFoundException {
    	return this.creaContextoParaScript(idTramite, idTareaExterna, idTareaProcedimiento);
    }
	
    /**
     * Crea el contexto de ejecución para un script groovy introduciendo variables útiles, funciones y managers.
     * @return mapa
     * @throws ClassNotFoundException e
     */
    private Map<String, Object> creaContextoParaScript(Long idTramite, Long idTareaExterna, Long idTareaProcedimiento)
            throws ClassNotFoundException {
        Map<String, Object> context = new HashMap<String, Object>();

        //Añadimos los managers necesarios
        context.put("activoTramiteManager", activoTramiteManager);
        context.put("activoManager", activoManager);
        context.put("trabajoManager", trabajoManager);
        context.put("ctx", ApplicationContextUtil.getApplicationContext());

        //TODO: añadir contexto del procedimiento padre.
//        Procedimiento procedimientoPadre = procedimientoManager.getProcedimiento(idTramite).getProcedimientoPadre();
//        if (procedimientoPadre != null) {
//            context.put("valoresBPMPadre", creaMapValores(procedimientoPadre.getId()));
//        }

        //Añadimos las variables necesarias
        context.put("valores", jbpmActivoTramiteManagerApi.creaMapValores(idTramite));
        introduceDiccionarios(context);
        context.put("idTramite", idTramite);

        if (idTareaExterna != null) {
            TareaExterna tareaExterna = tareaExternaManagerApi.get(idTareaExterna);
            context.put("tareaExterna", tareaExterna);
        }
        
        int nVeces = getNVecesTareaExterna(idTramite, idTareaProcedimiento);
        context.put("nVecesTareaExterna", nVeces);
        
        Long idActivo = activoTramiteManager.get(idTramite).getActivo().getId();
        if(idActivo != null){
        	context.put("idActivo", idActivo);
        }

        return context;
    }
    
    /**
     * Introduce los diccionarios definidos en el bean clasesDiccionariosAnotadas en el contexto de los
     * script groovy para que tengamos acceso.
     * @param context contexto
     * @throws ClassNotFoundException e
     */
    private void introduceDiccionarios(Map<String, Object> context) throws ClassNotFoundException {
        context.putAll(getClasesDiccionario());
    }

    /**
     * Tan sÃ­lo haremos el cálculo de las clases diccionarios la primera vez para crear el contexto.
     * @return
     * @throws ClassNotFoundException
     */
    private Map<String, Object> getClasesDiccionario() throws ClassNotFoundException {
        if (clasesDiccionario == null) {
            clasesDiccionario = new HashMap<String, Object>();
            for (String clazz : clasesDiccionarioAnotadas) {
                String varName = StringUtils.substringAfterLast(clazz, ".");
                clasesDiccionario.put(varName, Class.forName(clazz));
            }
        }
        return clasesDiccionario;
    }
    
    


    private int getNVecesTareaExterna(Long idTramite, Long idTareaProcedimiento) {
        if (idTareaProcedimiento == null || idTramite == null) { return 0; }
        int resultado = 0;
        try {

            List<TareaExterna> lista = tareaExternaManagerApi.getByIdTareaProcedimientoIdTramite(idTramite, idTareaProcedimiento);

            if (lista != null) {
                resultado = lista.size();
            }
        } catch (Exception e) {
            logger.warn("Error al extraer el NVecesTareaExterna", e);
        }
        return resultado;
    }
    

    private String getContextScriptsAsString() {
        StringBuffer sb = new StringBuffer();
        for (String script : getContextScripts()) {
            sb.append(script).append("\n");
        }
        return sb.toString();
    }

}

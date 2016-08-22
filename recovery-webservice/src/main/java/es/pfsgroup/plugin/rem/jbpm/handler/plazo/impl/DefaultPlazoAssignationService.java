package es.pfsgroup.plugin.rem.jbpm.handler.plazo.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.procesosJudiciales.PlazoTareaExternaPlazaManager;
import es.capgemini.pfs.procesosJudiciales.model.PlazoTareaExternaPlaza;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoScriptExecutorApi;
import es.pfsgroup.plugin.rem.jbpm.handler.plazo.PlazoAssignationService;

@Component
public class DefaultPlazoAssignationService implements PlazoAssignationService{

    protected final Log logger = LogFactory.getLog(getClass());

    @Autowired
    protected JBPMActivoScriptExecutorApi jbpmActivoScriptExecutorApi;
    
    @Autowired
    private PlazoTareaExternaPlazaManager plazoTareaExternaPlazaManager;

    @Autowired
    private GenericABMDao genericDao;
    
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[]{DEFAULT_SERVICE_BEAN_KEY};
	}

	@Override
	public Long getPlazoTarea(Long idTipoTarea, Long idTramite) {
		Long plazo;
	    PlazoTareaExternaPlaza plazoTareaExternaPlaza = plazoTareaExternaPlazaManager.getByTipoTareaTipoPlazaTipoJuzgado(idTipoTarea, null, null);
		
	    String script = "Sin determinar";
	    try {
	        script = plazoTareaExternaPlaza.getScriptPlazo();
	        String result = jbpmActivoScriptExecutorApi.evaluaScript(idTramite, null, idTipoTarea, null, script).toString();
	        plazo = Long.parseLong(result.toString());
	    } catch (Exception e) {
	        logger.error("Error en el script de consulta de plazo [" + script + "]. Trámite [" + idTramite + "], tipoTarea ["
	                + idTipoTarea + "].", e);
	        throw new UserException("bpm.error.script");
	    }
	    return plazo;
	}
}


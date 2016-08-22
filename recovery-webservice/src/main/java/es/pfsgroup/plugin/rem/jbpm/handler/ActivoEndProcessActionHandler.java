package es.pfsgroup.plugin.rem.jbpm.handler;

import static es.capgemini.pfs.BPMContants.TOKEN_JBPM_PADRE;

import java.util.Date;
import java.util.Set;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;


import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.GestorActivo;
import es.pfsgroup.plugin.rem.model.TareaActivo;


/**
 * PONER JAVADOC FO.
 */
public class ActivoEndProcessActionHandler extends ActivoBaseActionHandler {
    private static final long serialVersionUID = 1L;

    @Autowired
    JBPMProcessManagerApi jbpmProcessManagerApi;
    
	@Autowired
	private GenericABMDao genericDao;
    
    /**
     * PONER JAVADOC FO.
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {

        logger.debug("Llegamos al final del BPM [" + getNombreProceso(executionContext) + "]");

        // Si llegamos al nodo fin y no hay más tareas pendiente cambiamos el estado del trámite
        ActivoTramite activoTramite = getActivoTramite(executionContext);
        Boolean tareaPendiente = false;
        Set<TareaActivo> tareas = activoTramite.getTareas();
        
        for(TareaActivo tac : tareas)
        	if(Checks.esNulo(tac.getFechaFin()))
        		tareaPendiente = true;

        if(!tareaPendiente){
	        DDEstadoProcedimiento estadoTramite = genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO));
			activoTramite.setEstadoTramite(estadoTramite);
			activoTramite.setFechaFin(new Date());
        }
        
        //si este proceso ha sido iniciado por otro, lanzará una señal con su nombre
        if (hasVariable(TOKEN_JBPM_PADRE, executionContext)) {

            Long idToken = (Long) getVariable(TOKEN_JBPM_PADRE, executionContext);
            String transitionName = getNombreProceso(executionContext);

            //Si cuando vayamos a avisar al nodo, existe ese nodo activo y existe una transición correcta
            if (jbpmProcessManagerApi.hasTransitionToken(idToken, transitionName)) {
            	jbpmProcessManagerApi.signalToken(idToken, transitionName);
            }
        }
    }

}

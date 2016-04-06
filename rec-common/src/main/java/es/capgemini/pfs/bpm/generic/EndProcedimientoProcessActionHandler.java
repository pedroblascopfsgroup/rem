package es.capgemini.pfs.bpm.generic;

import static es.capgemini.pfs.BPMContants.TOKEN_JBPM_PADRE;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

/**
 * PONER JAVADOC FO.
 */
@Component
public class EndProcedimientoProcessActionHandler extends BaseActionHandler {
    private static final long serialVersionUID = 1L;

    /**
     * PONER JAVADOC FO.
     * @throws Exception e
     */
    

    @Autowired
    private JBPMProcessManager jbpmUtil;

	@Autowired
	private GenericABMDao genericDao;
	
    @Override
    public void run() throws Exception {

        logger.debug("Finalizamos el procedimiento por completo [" + getNombreProceso() + "]");

        //si este proceso ha sido iniciado por otro, lanzará una señal con su nombre
        if (hasVariable(TOKEN_JBPM_PADRE)) {

            Long idToken = (Long) getVariable(TOKEN_JBPM_PADRE);
            String transitionName = getNombreProceso();

            //Si cuando vayamos a avisar al nodo, existe ese nodo activo y existe una transición correcta
            if (processUtils.hasTransitionToken(idToken, transitionName)) {
                processUtils.signalToken(idToken, transitionName);
            }
        }
        
        DDEstadoProcedimiento estadoFin = genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO),
        		genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
 		Procedimiento procedimiento = getProcedimiento();
 		procedimiento.setEstadoProcedimiento(estadoFin);
		genericDao.save(Procedimiento.class, procedimiento);
        
        jbpmUtil.finalizarProcedimiento(procedimiento.getId());
        
    }

}

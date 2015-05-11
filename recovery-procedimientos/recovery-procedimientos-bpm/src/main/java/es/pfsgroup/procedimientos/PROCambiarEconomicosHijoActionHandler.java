package es.pfsgroup.procedimientos;

import static es.pfsgroup.procedimientos.PROBPMContants.PROCEDIMIENTO_HIJO;

import java.math.BigDecimal;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.procedimientos.recoveryapi.ProcedimientoApi;

/**
 * Cambia los datos econ�micos: principal, porcentaje recuperaci�n y plazo del prc. con los datos introducidos en la tarea de seleccionProcedimiento
 *
 */

public class PROCambiarEconomicosHijoActionHandler extends PROBaseActionHandler implements PROJBPMEnterEventHandler {

    private static final long serialVersionUID = 1L;
    
    @Autowired
    protected JBPMProcessManager processUtils;
    
    @Autowired
	private ProcedimientoDao procedimientoDao;

    /**
     * Override del m�todo onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter(ExecutionContext executionContext) {
    	BigDecimal principal = null;
        Integer porcentaje = null;
        Integer plazo = null;
        
        Procedimiento procedimiento = getProcedimiento(executionContext);

        //Obtenemos los datos de la tarea
        Map<String, Map<String, String>> valores = processUtils.creaMapValores(procedimiento.getId());

        principal = BigDecimal.valueOf(Double.parseDouble(valores.get("P90_registrarDecisionProcedimiento").get("principal")));
        porcentaje = Integer.parseInt(valores.get("P90_registrarDecisionProcedimiento").get("porcentaje"));
        plazo = Integer.valueOf(valores.get("P90_registrarDecisionProcedimiento").get("plazo"));
        
        //Obtenemos el procedimiento Hijo
    	Procedimiento procHijo = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento((Long) getVariable(PROCEDIMIENTO_HIJO, executionContext));

    	//Modificamos los datos del procedimiento y lo guardamos
    	procHijo.setSaldoRecuperacion(principal);
    	procHijo.setPorcentajeRecuperacion(porcentaje);
    	procHijo.setPlazoRecuperacion(plazo);
    
        procedimientoDao.saveOrUpdate(procHijo);
        
    	logger.debug("\tModificado los datos econ�micos del procedimiento [" + procedimiento.getId() + "]");
    }
}

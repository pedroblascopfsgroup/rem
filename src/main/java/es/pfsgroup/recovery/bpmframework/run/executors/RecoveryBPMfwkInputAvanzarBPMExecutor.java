package es.pfsgroup.recovery.bpmframework.run.executors;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.JBPMProcessApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.bpm.RecoveryBPMFwkProcessApi;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Clase que sabe cómo procesar un input de tipo avance del BPM
 * 
 * @author bruno
 * 
 */
@Component
public class RecoveryBPMfwkInputAvanzarBPMExecutor extends RecoveryBPMfwkInputGenDocExecutor {

    @Autowired
    private transient ApiProxyFactory proxyFactory;

    public RecoveryBPMfwkInputAvanzarBPMExecutor() {
        super();
    }

	public String[] getTiposAccion() {
		return new String[]{RecoveryBPMfwkDDTipoAccion.AVANZAR_BPM};
	}

    @Override
    public void execute(final RecoveryBPMfwkInput myInput) throws Exception {

        // Guardamos los datos.
        super.execute(myInput);

        // Avanzamos BMP.

        Procedimiento proc = super.getProcedimiento(myInput.getIdProcedimiento());
        // String nodoProcedimiento =
        // proxyFactory.proxy(JBPMProcessApi.class).getActualNode(proc.getProcessBPM());
        List<String> nodosProcedimiento = proxyFactory.proxy(EXTJBPMProcessApi.class).getCurrentNodes(proc.getProcessBPM());

        for (String nodoProcedimiento : nodosProcedimiento) {
            RecoveryBPMfwkCfgInputDto config = super.getInputConfig(myInput.getTipo().getCodigo(), proc.getTipoProcedimiento().getCodigo(), nodoProcedimiento);

            try {
                if (config != null && config.getNombreTransicion() != null) {
                    // FIXME Ver un modo más elegante de gestionar las
                    // paralizaciones y
                    // las reactivaciones
                    if ("aplazarTareas".equals(config.getNombreTransicion())) {
                        // final Date fechaReactivar =
                        // getFechaReactivar(myInput.getDatos());
                        final Date fechaReactivar = todayPlus60Days();
                        guardaFechaReactivarEnBPM(proc.getProcessBPM(), fechaReactivar);
                    }
                    proxyFactory.proxy(RecoveryBPMFwkProcessApi.class).signalProcess(proc.getProcessBPM(), config.getNombreTransicion(), myInput);
                }
            } catch (Exception e) {
                throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION, "Error al intentar avanzar el BPM", e);
            }
        }

    }

    private Date todayPlus60Days() {
        final GregorianCalendar calendar = new GregorianCalendar();
        calendar.add(Calendar.DAY_OF_MONTH, 60);
        return calendar.getTime();
    }

    private void guardaFechaReactivarEnBPM(final Long processBPM, final Date fecha) {
        final HashMap<String, Object> variables = new HashMap<String, Object>();
        variables.put(BPMContants.FECHA_APLAZAMIENTO_TAREAS, fecha);
        proxyFactory.proxy(JBPMProcessApi.class).addVariablesToProcess(processBPM, variables);
    }

    @SuppressWarnings("unused")
	private Date getFechaReactivar(final Map<String, Object> datos) {
        if (Checks.estaVacio(datos)) {
            return null;
        }
        final Object fecha = datos.get(BPMContants.FECHA_APLAZAMIENTO_TAREAS);
        if (fecha instanceof Date) {
            return (Date) fecha;
        } else {
            return null;
        }
    }

}

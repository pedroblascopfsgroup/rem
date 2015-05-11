package es.capgemini.pfs.batch.mantenimiento;

import java.util.Date;

import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.batch.mantenimiento.MantenimientoConstantes.Genericas;
import es.capgemini.pfs.batch.mantenimiento.MantenimientoConstantes.ProcesoMantenimiento;

/**
 * Clase de punto de entrada de la consola JMX para el proceso de mantenimiento
 * @author Javier Ruiz
 *
 */
@Component
@ManagedResource(Genericas.DEVON_TYPE_BATCH_MANTENIMIENTO)
public class BatchMantenimientoConsolePlugin {

	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de c�lculo de Antecedentes
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoMantenimiento.DESCRIPCION_PROCESO_MANTENIMIENTO)
    public void ejecutarProcesoMantenimiento(String workingCode) {
    	ProcesoMantenimientoJobLauncher procesoMantenimientoJobLauncher = (ProcesoMantenimientoJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoMantenimiento.PROCESO_MANTENIMIENTO_HANDLER);
    	procesoMantenimientoJobLauncher.handle(workingCode,new Date());
    }
        
}

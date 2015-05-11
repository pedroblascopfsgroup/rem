package es.capgemini.pfs.batch.antecedentes;

import java.util.Date;

import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.batch.antecedentes.constantes.AntecedentesConstantes.Genericas;
import es.capgemini.pfs.batch.antecedentes.constantes.AntecedentesConstantes.ProcesoAntecedentes;
import es.capgemini.pfs.batch.antecedentes.jobs.ProcesoAntecedentesJobLauncher;

/**
 * Clase de punto de entrada de la consola JMX para el proceso de cálculo de Antecedentes
 * @author Guillem
 *
 */
@Component
@ManagedResource(Genericas.DEVON_TYPE_BATCH_ANTECEDENTES)
public class BatchAntecedentesConsolePlugin {

	/**
	 * Método de entrada para la ejecución por consola JMX del proceso de cálculo de Antecedentes
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoAntecedentes.DESCRIPCION_PROCESO_ANTECEDENTES)
    public void ejecutarProcesoAntecedentes(String workingCode) {
    	ProcesoAntecedentesJobLauncher procesoAntecedentesJobLauncher = (ProcesoAntecedentesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoAntecedentes.PROCESO_ANTECEDENTES_HANDLER);
    	procesoAntecedentesJobLauncher.handle(workingCode,new Date());
    }
        
}

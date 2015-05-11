package es.capgemini.pfs.batch.common;

import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;

/**
 * Representa una tarea de validación.
 * <br>
 * <br>
 * Es un conjunto de las interfaces
 * <code>Tasklet</code>
 * <code>StepExecutionListener</code>
 */
public interface ValidationTasklet extends Tasklet, StepExecutionListener {

   String ERROR_FIELD = "ERROR_FIELD";
   String ENTITY_CODE = "ENTITY_CODE";
}

package es.pfgroup.monioring.bach.load.logic;

import java.util.Date;

import es.pfgroup.monioring.bach.load.BatchExecutionData;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusWrongArgumentsException;

/**
 * Interface para la lógica de negocio de los checkeos del batch.
 * 
 * @author bruno
 * 
 */
public interface CheckStatusLogic {

    /**
     * Comprueba si hay errores de carga para un determinado job del batch.
     * 
     * @param entity
     *            Código de la entidad
     * @param jobName
     *            Nombre del job
     * @param lastTime
     *            Fecha y hora de la última ejecución, puede ser NULL si no
     *            existe este dato (primera vez)
     * 
     * @throws CheckStatusWrongArgumentsException
     *             Si los hay algn problema con los argumentos recibidos
     * 
     * @return
     * @throws CheckStatusRecoverableException Esto indica que el error puede ser transitorio, se puede reintentar.
     * 
     */
    boolean hasErrors(final Integer entity, String jobName, Date lastTime) throws CheckStatusWrongArgumentsException, CheckStatusRecoverableException;

    /**
     * Devuelve información sobre la ejecución de un determinado job del batch.
     * 
     * @param entity
     *            Código de la entidad
     * @param jobName
     *            Nombre del job
     * @param lastTime
     *            Fecha y hora de la última ejecución, puede ser NULL si no
     *            existe este dato (primera vez)
     * 
     * @throws CheckStatusWrongArgumentsException
     *             Si los hay algún problema con los argumentos recibidos
     * @throws CheckStatusRecoverableException Esto indica que el error puede ser transitorio, se puede reintentar.
     */
    BatchExecutionData getExecutionInfo(final Integer entity, String jobName, Date lastTime) throws CheckStatusWrongArgumentsException, CheckStatusRecoverableException;

}

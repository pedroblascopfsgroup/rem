package es.pfgroup.monioring.bach.load.dao;

import java.util.Date;
import java.util.List;

import es.pfgroup.monioring.bach.load.dao.model.CheckStatusTuple;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;

/**
 * Acceso a datos para el checkeo del estado del batch.
 * 
 * @author bruno
 * 
 */
public interface CheckStatusDao {

    public static final String EXIT_CODE_OK = "COMPLETED";
    public static final String EXIT_CODE_ERROR = "FAILED";

   
    /**
     * Debuelve  registros para un determinado job, ordenadadas por ID desdendientemente, la más reciente primero en la lista.
     * @param entity
     * @param jobName
     * @param lastTime
     * @return
     * @throws CheckStatusRecoverableException Esto indica que el error puede ser transitorio, se puede reintentar.
     */
    List<CheckStatusTuple> getTuplesForJobOrderedByIdDesc(Integer entity, String jobName, Date lastTime) throws CheckStatusRecoverableException;

    /**
     * Devuelve registros para un determinado job con un determinado exitCode, ordenadadas por ID desdendientemente, la más reciente primero en la lista.
     * 
     * @param entity
     * @param jobName
     * @param exitCode
     * @param lastTime
     *            Fecha y hora de la última ejecución. Este parámetro puede ser NULL, en este caso no se tendrá en cuenta en la consulta.
     * @return
     * @throws CheckStatusRecoverableException Esto indica que el error puede ser transitorio, se puede reintentar.
     */
    List<CheckStatusTuple> getTuplesForJobWithExitCodeOrderedByIdDesc(Integer entity, String jobName, String exitCodeError, Date lastTime) throws CheckStatusRecoverableException;



    

}

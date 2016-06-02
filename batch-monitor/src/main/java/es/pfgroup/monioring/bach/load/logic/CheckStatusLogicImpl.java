package es.pfgroup.monioring.bach.load.logic;

import java.util.Date;
import java.util.List;

import es.pfgroup.monioring.bach.load.BatchExecutionData;
import es.pfgroup.monioring.bach.load.CSConfigSingleton;
import es.pfgroup.monioring.bach.load.dao.CheckStatusDao;
import es.pfgroup.monioring.bach.load.dao.model.CheckStatusTuple;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusErrorType;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusWrongArgumentsException;

/**
 * Implementación de la lógica de negocio para el checkeo de la carga del batch
 * 
 * @author bruno
 * 
 */
public class CheckStatusLogicImpl implements CheckStatusLogic {

    private final CheckStatusDao dao;

    /**
     * Al crear el objeto es necesario inyectarle la capa de acceso a datos.
     * 
     * @param dao
     */
    public CheckStatusLogicImpl(final CheckStatusDao dao) {
        this.dao = dao;
    }

    @Override
    public boolean hasErrors(final Integer entity, final String jobName, final Date lastTime) throws CheckStatusWrongArgumentsException, CheckStatusRecoverableException {

        if ((entity == null) || (jobName == null) || ("".equals(jobName))) {
            throw new CheckStatusWrongArgumentsException();
        }

        final List<?> errors = dao.getTuplesForJobWithExitCodeOrderedByIdDesc(entity, jobName, CheckStatusDao.EXIT_CODE_ERROR, lastTime);

        if (errors.isEmpty()) {
            return false;
        } else {
            return true;
        }
    }

    @Override
    public BatchExecutionData getExecutionInfo(final Integer entity, final String jobName, final Date lastTime) throws CheckStatusWrongArgumentsException, CheckStatusRecoverableException {
        if ((entity == null) || (jobName == null) || ("".equals(jobName))) {
            throw new CheckStatusWrongArgumentsException();
        }
        boolean flagRunning = false;
        boolean flagErrors = false;
        boolean flagExecuted = false;
        boolean flagNoop = false;

        final List<CheckStatusTuple> tuples = dao.getTuplesForJobOrderedByIdDesc(entity, jobName, lastTime);
        boolean isFirst = true;
        if ((tuples != null) && (!tuples.isEmpty())) {

        	boolean usemark = CSConfigSingleton.getInstance().isUsePasajeProduccionMark();
            for (CheckStatusTuple t : tuples) {
                if (isFirst && CheckStatusTuple.CODIGO_ESTADO_RUNNING.equals(t.getCodigoEstado())) {
                    flagRunning = true;
                } else if (isFirst && CheckStatusTuple.CODIGO_SALIDA_FAILED.equals(t.getCodigoSalida())) {
                    flagErrors = true;
                    flagNoop = false;
                } else if (isFirst && CheckStatusTuple.CODIGO_ESTADO_COMPLETED.equals(t.getCodigoEstado()) && ((! usemark) || (!t.getNombreJob().contains(CheckStatusTuple.PASAJE_PRODUCCION_MARK)))) {
                	//FIXME  Al cambiar esto en la versión 1.3.1 ha dejado de funcionar un test. Revisar cual es el comportamiento correcto.
                    //flagRunning = true; Esto se comenta en la versión 1.3.1
                    flagExecuted = true; // Este cambio se introduce en la 1.3.1
                    flagNoop = CheckStatusTuple.CODIGO_SALIDA_NOOP.equals(t.getCodigoSalida());
                } else if (CheckStatusTuple.CODIGO_ESTADO_COMPLETED.equals(t.getCodigoEstado()) && ((! usemark) || (t.getNombreJob().contains(CheckStatusTuple.PASAJE_PRODUCCION_MARK)))) {
                	//FIXME Esta condición parece duplicada con la anterior, comprobarlo y quitarla en ese caso.	
                    flagExecuted = true;
                    flagNoop = CheckStatusTuple.CODIGO_SALIDA_NOOP.equals(t.getCodigoSalida());
                } 

                isFirst = false;
            }
        }

        return new BatchExecutionData(flagRunning, flagErrors, flagExecuted, flagNoop);
    }

}

package es.pfgroup.monioring.bach.load.dao.model.query;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Objeto que ayuda a construir las consultas sobre el modelo en base a
 * parámetros.
 * 
 * @author bruno
 * 
 */
public class OracleModelQueryBuilder {

    public final String DATE_TIME_FORMAT = "dd/MM/yyyy HH:mm";

    /**
     * Crea la consulta para devolver las tuplas de un determinado jobn,
     * ordenadas por ID descendientemente.
     * 
     * @param entity
     * @param jobName
     * @return
     */
    public String selectTuplesForJobOrderedByIdDesc(final Integer entity, final String jobName) {
        StringBuilder builder = createBasicQuery(entity, jobName);
        builder.append(" order by id desc");
        return builder.toString();
    }

    /**
     * Crea la consulta para devolver las tuplas de un determinado job. Además
     * filtra por la fecha y hora de la última ejecución, ordenadas por ID
     * descendientemente.
     * 
     * @param entity
     * @param jobName
     * @param lastTime
     * @return
     */
    public String selectTuplesForJobOrderedByIdDesc(final Integer entity, final String jobName, final Date lastTime) {
        StringBuilder builder = createBasicQuery(entity, jobName);
        String dateParsed = new SimpleDateFormat(DATE_TIME_FORMAT).format(lastTime);
        builder.append(" and comienza > to_date('").append(dateParsed).append("','dd/mm/rrrr HH24:MI')");
        builder.append(" order by id desc");
        return builder.toString();
    }

    /**
     * Crea la consulta para devolver las tuplas de un determinado job que
     * tengan un determinado código de salida, ordenadas por ID
     * descendientemente.
     * 
     * @param entity
     * @param jobName
     * @param exitCode
     * @return
     */
    public String selectTuplesForJobWithExitCodeOrderedByIdDesc(final Integer entity, final String jobName, final String exitCode) {
        StringBuilder builder = createBasicQuery(entity, jobName);
        builder.append(" and codigo_salida ='").append(exitCode).append("'");
        builder.append(" order by id desc");
        return builder.toString();
    }

    /**
     * Crea la consulta para devolver las tuplas de un determinado job que
     * tengan un determinado código de salida. Además filtra por la fecha y hora
     * de la última ejecución, ordenadas por ID descendientemente.
     * 
     * @param entity
     * @param jobName
     * @param exitCode
     * @param lastTime
     * @return
     */
    public String selectTuplesForJobWithExitCodeOrderedByIdDesc(final Integer entity, final String jobName, final String exitCode, final Date lastTime) {
        StringBuilder builder = createBasicQuery(entity, jobName);
        String dateParsed = new SimpleDateFormat(DATE_TIME_FORMAT).format(lastTime);
        builder.append(" and codigo_salida ='").append(exitCode).append("'");
        builder.append(" and comienza > to_date('").append(dateParsed).append("','dd/mm/rrrr HH24:MI')");
        builder.append(" order by id desc");
        return builder.toString();
    }

    private StringBuilder createBasicQuery(final Integer entity, final String jobName) {
        StringBuilder builder = new StringBuilder();
        builder.append("select entidad, nombre_job, comienza, finaliza, estado, codigo_salida from v_status_batch where nombre_job like '");
        builder.append(jobName).append("%'");
        builder.append(" and entidad = ").append(entity);
        return builder;
    }

}

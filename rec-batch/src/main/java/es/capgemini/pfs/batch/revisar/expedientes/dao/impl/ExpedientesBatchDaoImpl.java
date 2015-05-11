package es.capgemini.pfs.batch.revisar.expedientes.dao.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.batch.revisar.expedientes.ExpedienteBatch;
import es.capgemini.pfs.batch.revisar.expedientes.dao.ExpedientesBatchDao;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.favoritos.FavoritosManager;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Clase que contiene métodos de acceso a bbdd para la entidad Expediente.
 *
 * @author mtorrado
 *
 */
//@Repository("ExpedientesBatchDao")
public class ExpedientesBatchDaoImpl implements ExpedientesBatchDao {

    private final Log logger = LogFactory.getLog(getClass());

    private DataSource dataSource;
    private String queryExpedientesActivos;
    private String queryLiberarContrato;
    private String queryCancelarExpediente;

    @Autowired
    private TareaNotificacionManager tareaManager;

    @Autowired
    private FavoritosManager favoritosManager;

    @Autowired
    private JBPMProcessManager jbpmProcessUtils;

    /**
     * Libera un contrato de un expediente.
     *
     * @param idContrato el contrato a liberar
     * @param idExpediente el expediente que contiene al contrato
     */
    public void liberarContrato(Long idContrato, Long idExpediente) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(queryLiberarContrato, new Object[] { idContrato, idExpediente });
        logger.debug("Contrato " + idContrato + " liberado del expediente " + idExpediente);
    }

    /**
     * Cancela un Expediente.
     *
     * @param idExpediente el expediente a cancelar.
     * @param idJBPM proceso jbpm
     */
    public void cancelarExpediente(Long idExpediente, Long idJBPM) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(queryCancelarExpediente, new Object[] { DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO, idExpediente });
        logger.debug("Expediente " + idExpediente + " cancelado");

        if (idJBPM != null) {
            jbpmProcessUtils.destroyProcess(idJBPM);
        }

        //Borramos todas las tareas asociadas del expediente
        tareaManager.borrarTareasAsociadasExpediente(idExpediente);

        tareaManager
                .crearNotificacion(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_CERRADO, null);
        favoritosManager.eliminarFavoritosPorEntidadEliminada(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
        logger.debug("Notificación de expediente cancelado enviada");
    }

    /**
     * Devuelve la lista de expedientes activos para la fecha de extracción
     * indicada.
     *
     * @return la lista de expedientes activos
     */
    @SuppressWarnings("unchecked")
    public Set<ExpedienteBatch> buscarExpedientesActivos() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] args = { DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO, DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO,
                DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO };
        List<Map<String, Object>> expedientes = jdbcTemplate.queryForList(queryExpedientesActivos, args);
        Set<ExpedienteBatch> expedientesBatch = new TreeSet<ExpedienteBatch>();
        for (Map<String, Object> expediente : expedientes) {
            ExpedienteBatch exp = new ExpedienteBatch();
            Long idExpediente = Long.valueOf(expediente.get("EXP_ID").toString());
            exp.setId(idExpediente);

            Long idJBPM = null;
            if (expediente.get("EXP_PROCESS_BPM") != null) {
                idJBPM = Long.valueOf(expediente.get("EXP_PROCESS_BPM").toString());
            }

            exp.setIdJbpm(idJBPM);
            exp.setAutomatico(esAutomatico(expedientes.iterator(), idExpediente));
            exp.setIdContratoPase(getContratoPase(expedientes.iterator(), idExpediente));
            exp.setIdsContratosNoPase(getContratosNoPase(expedientes.iterator(), idExpediente));
            expedientesBatch.add(exp);
        }

        return expedientesBatch;
    }

    private boolean esAutomatico(Iterator<Map<String, Object>> iterator, Long idExpediente) {
        Map<String, Object> expediente;
        while (iterator.hasNext()) {
            expediente = iterator.next();
            if (idExpediente.equals(Long.valueOf(expediente.get("EXP_ID").toString()))) {
                return Integer.valueOf(expediente.get("EXP_MANUAL").toString()).equals(0);
            }
        }
        return false;
    }

    private List<Long> getContratosNoPase(Iterator<Map<String, Object>> iterator, Long idExpediente) {
        Map<String, Object> expediente;
        List<Long> contratosNoPase = new ArrayList<Long>();
        while (iterator.hasNext()) {
            expediente = iterator.next();
            if (idExpediente.equals(Long.valueOf(expediente.get("EXP_ID").toString()))) {
                if (0 == Long.valueOf(expediente.get("CEX_PASE").toString())) {
                    contratosNoPase.add(Long.valueOf(expediente.get("CNT_ID").toString()));
                }
            }
        }
        return contratosNoPase;
    }

    private Long getContratoPase(Iterator<Map<String, Object>> iterator, Long idExpediente) {
        Map<String, Object> expediente;
        while (iterator.hasNext()) {
            expediente = iterator.next();
            if (idExpediente.equals(Long.valueOf(expediente.get("EXP_ID").toString()))) {
                if (1 == Long.valueOf(expediente.get("CEX_PASE").toString())) {
                    return Long.valueOf(expediente.get("CNT_ID").toString());
                }
            }
        }
        return null;
    }

    /**
     * @return the dataSource
     */
    public DataSource getDataSource() {
        return dataSource;
    }

    /**
     * @param dataSource
     *            the dataSource to set
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * @return the queryExpedientesActivos
     */
    public String getQueryExpedientesActivos() {
        return queryExpedientesActivos;
    }

    /**
     * @param queryExpedientesActivos
     *            the queryExpedientesActivos to set
     */
    public void setQueryExpedientesActivos(String queryExpedientesActivos) {
        this.queryExpedientesActivos = queryExpedientesActivos;
    }

    /**
     * @return the queryLiberarContrato
     */
    public String getQueryLiberarContrato() {
        return queryLiberarContrato;
    }

    /**
     * @param queryLiberarContrato
     *            the queryLiberarContrato to set
     */
    public void setQueryLiberarContrato(String queryLiberarContrato) {
        this.queryLiberarContrato = queryLiberarContrato;
    }

    /**
     * @return the queryCancelarExpediente
     */
    public String getQueryCancelarExpediente() {
        return queryCancelarExpediente;
    }

    /**
     * @param queryCancelarExpediente
     *            the queryCancelarExpediente to set
     */
    public void setQueryCancelarExpediente(String queryCancelarExpediente) {
        this.queryCancelarExpediente = queryCancelarExpediente;
    }
}

package es.capgemini.pfs.batch.revisar.asuntos.dao.impl;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.batch.revisar.asuntos.dao.AsuntosBatchDao;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;

/**
 * Dao de asuntos.
 * @author jbosnjak
 *
 */
//@Repository("AsuntosBatchDao")
public class AsuntosBatchDaoImpl implements AsuntosBatchDao {

    private String queryBuscarContratosAsunto;

    private DataSource dataSource;

    /**
     * Busca todos los asuntos activos.
     * @return ids de los asuntos
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> obtenerAsuntosActivos() {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] args = new Object[] { DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO, DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO,
                DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO,
                DDEstadoContrato.ESTADO_CONTRATO_CANCELADO };
        return jdbcTemplate.queryForList(queryBuscarContratosAsunto, args);
    }

    /**
     * @param queryBuscarContratosAsunto the queryBuscarContratosAsunto to set
     */
    public void setQueryBuscarContratosAsunto(String queryBuscarContratosAsunto) {
        this.queryBuscarContratosAsunto = queryBuscarContratosAsunto;
    }

    /**
     * @param dataSource the dataSource to set
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}

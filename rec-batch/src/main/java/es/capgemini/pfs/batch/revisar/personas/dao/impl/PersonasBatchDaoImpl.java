package es.capgemini.pfs.batch.revisar.personas.dao.impl;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Required;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.arquetipo.model.DDTipoSaltoNivel;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.batch.revisar.personas.dao.PersonasBatchDao;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.politica.model.DDEstadoPolitica;

/**
 * Clase que contiene los m�todos de acceso a bbdd para la entidad Personas.
 *
 * @author pjimene
 *
 */
//@Repository("PersonasBatchDao")
public class PersonasBatchDaoImpl implements PersonasBatchDao {

    private DataSource dataSource;

    private String buscarFuturosClientesSeguimientoQuery;
    private String buscarArquetipoCalculadoQuery;

    private String updateFormulasPrecalculoPersonaQuery;
    private String updateFormulasPrecalculoGrupoQuery;
    private String updateArquetiposPorCalculados;

    private String historificaPrepoliticasQuery;
    
    private String buscarPersonasActivasQuery;
    private String buscarContratosQuery;

    /**
     * {@inheritDoc}
     */
    @Override
    public void realizaPrecalculosCarga() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        
        //FIXME: Modificado para BANKIA en espera de la soluci�n definitiva para producto
        
        // Filtramos por ESTADO_CONTRATO_ACTIVO porque sólo vamos a realizar el precálculo con los CNT que están en ese estado
        jdbcTemplate.update(updateFormulasPrecalculoPersonaQuery, new Object[] { DDEstadoContrato.ESTADO_CONTRATO_ACTIVO});
        
        /*
        jdbcTemplate.update(updateFormulasPrecalculoPersonaQuery, new Object[] { DDEstadoContrato.ESTADO_CONTRATO_CANCELADO,
                DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO,
                DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO,
                DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO,
                DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO });

        jdbcTemplate.update(updateFormulasPrecalculoGrupoQuery, new Object[] { DDEstadoContrato.ESTADO_CONTRATO_CANCELADO,
                DDEstadoContrato.ESTADO_CONTRATO_CANCELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO });
        */
                
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Long buscarArquetipoCalculado(Long personaId) {
        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForLong(buscarArquetipoCalculadoQuery, new Object[] { personaId });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Long> buscarFuturosClientesSeguimiento() {
        Object[] args = { DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO, DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO,
                DDEstadoPolitica.ESTADO_VIGENTE, DDTipoSaltoNivel.CODIGO_CUALQUIER_SALTO, DDTipoSaltoNivel.CODIGO_SALTO_ARRIBA,
                DDTipoSaltoNivel.CODIGO_SALTO_ABAJO, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO, DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO,
                DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO, DDEstadoContrato.ESTADO_CONTRATO_CANCELADO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION, DDTipoItinerario.ITINERARIO_RECUPERACION,
                DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO, DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO,
                DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO };

        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
        List<Long> listadoPersonas = jdbcTemplate.queryForList(buscarFuturosClientesSeguimientoQuery, args, Long.class);
        return listadoPersonas;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void historificaPrepoliticas() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(historificaPrepoliticasQuery);
    }

    @Override
    public void actualizarArquetiposPorCalculados() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(updateArquetiposPorCalculados);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
	@Override
    public List<Long> buscarPersonasActivas() {
    	JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
    	List<Long> listadoPersonas = jdbcTemplate.queryForList(buscarPersonasActivasQuery, null, Long.class);
    	return listadoPersonas;
    }
    
    /**
     * {@inheritDoc}
     */
	@SuppressWarnings("unchecked")
	@Override
    public List<Long> buscarContratos(Long perId) {
		Object[] args = {perId};
    	JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
    	List<Long> listadoPersonas = jdbcTemplate.queryForList(buscarContratosQuery, args, Long.class);
    	return listadoPersonas;
    }
    
    /*------------------------------
     * Setters
     *------------------------------*/

    /**
     * {@inheritDoc}
     */
    @Required
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * @param buscarFuturosClientesSeguimientoQuery the buscarFuturosClientesSeguimientoQuery to set
     */
    public void setBuscarFuturosClientesSeguimientoQuery(String buscarFuturosClientesSeguimientoQuery) {
        this.buscarFuturosClientesSeguimientoQuery = buscarFuturosClientesSeguimientoQuery;
    }

    /**
     * @param buscarArquetipoCalculadoQuery the buscarArquetipoCalculadoQuery to set
     */
    public void setBuscarArquetipoCalculadoQuery(String buscarArquetipoCalculadoQuery) {
        this.buscarArquetipoCalculadoQuery = buscarArquetipoCalculadoQuery;
    }

    /**
     * @param updateFormulasPrecalculoPersonaQuery the updateFormulasPrecalculoPersonaQuery to set
     */
    public void setUpdateFormulasPrecalculoPersonaQuery(String updateFormulasPrecalculoPersonaQuery) {
        this.updateFormulasPrecalculoPersonaQuery = updateFormulasPrecalculoPersonaQuery;
    }

    /**
     * @param updateFormulasPrecalculoGrupoQuery the updateFormulasPrecalculoGrupoQuery to set
     */
    public void setUpdateFormulasPrecalculoGrupoQuery(String updateFormulasPrecalculoGrupoQuery) {
        this.updateFormulasPrecalculoGrupoQuery = updateFormulasPrecalculoGrupoQuery;
    }

    /**
     * @param historificaPrepoliticasQuery the historificaPrepoliticasQuery to set
     */
    public void setHistorificaPrepoliticasQuery(String historificaPrepoliticasQuery) {
        this.historificaPrepoliticasQuery = historificaPrepoliticasQuery;
    }

    /**
     * @param updateArquetiposPorCalculados the updateArquetiposPorCalculados to set
     */
    public void setUpdateArquetiposPorCalculados(String updateArquetiposPorCalculados) {
        this.updateArquetiposPorCalculados = updateArquetiposPorCalculados;
    }

	public void setBuscarPersonasActivasQuery(String buscarPersonasActivasQuery) {
		this.buscarPersonasActivasQuery = buscarPersonasActivasQuery;
	}

	public void setBuscarContratosQuery(String buscarContratosQuery) {
		this.buscarContratosQuery = buscarContratosQuery;
	}       
	
}
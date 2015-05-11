package es.capgemini.pfs.batch.revisar.expedientes.dao;

import java.util.Set;

import javax.sql.DataSource;

import es.capgemini.pfs.batch.revisar.expedientes.ExpedienteBatch;

/**
 * Clase que contiene métodos de acceso a bbdd para la entidad Expediente.
 *
 * @author mtorrado
 *
 */
public interface ExpedientesBatchDao {

    /**
     * Libera un contrato de un expediente.
     *
     * @param idContrato el contrato a liberar
     * @param idExpediente el expediente que contiene al contrato
     */
    void liberarContrato(Long idContrato, Long idExpediente);

    /**
     * Cancela un Expediente.
     *
     * @param idExpediente el expediente a cancelar.
     * @param idJBPM proceso jbpm
     */
    void cancelarExpediente(Long idExpediente, Long idJBPM);

    /**
     * Devuelve la lista de expedientes activos para la fecha de extracción
     * indicada.
     * @return la lista de expedientes activos
     */
    Set<ExpedienteBatch> buscarExpedientesActivos();

    /**
     * @return the dataSource
     */
    DataSource getDataSource();

    /**
     * @param dataSource
     *            the dataSource to set
     */
    void setDataSource(DataSource dataSource);

    /**
     * @return the queryExpedientesActivos
     */
    String getQueryExpedientesActivos();

    /**
     * @param queryExpedientesActivos
     *            the queryExpedientesActivos to set
     */
    void setQueryExpedientesActivos(String queryExpedientesActivos);

    /**
     * @return the queryLiberarContrato
     */
    String getQueryLiberarContrato();

    /**
     * @param queryLiberarContrato
     *            the queryLiberarContrato to set
     */
    void setQueryLiberarContrato(String queryLiberarContrato);

    /**
     * @return the queryCancelarExpediente
     */
    String getQueryCancelarExpediente();

    /**
     * @param queryCancelarExpediente
     *            the queryCancelarExpediente to set
     */
    void setQueryCancelarExpediente(String queryCancelarExpediente);

}

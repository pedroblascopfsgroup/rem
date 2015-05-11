package es.capgemini.pfs.batch.revisar.expedientes;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.batch.revisar.expedientes.dao.ExpedientesBatchDao;

/**
 * Clase manager de la entidad expediente.
 *
 * @author mtorrado
 *
 */
public class ExpedientesBatchManager {

    @Autowired
    private ExpedientesBatchDao expedientesDao;

    /**
     * Libera un contrato de un expediente.
     *
     * @param idContrato
     *            el contrato a liberar
     * @param idExpediente
     *            el expediente que contiene al contrato
     */
    public void liberarContrato(Long idContrato, Long idExpediente) {
        expedientesDao.liberarContrato(idContrato, idExpediente);
    }

    /**
     * Cancela un Expediente.
     *
     * @param idExpediente el expediente a cancelar.
     * @param idJBPM proceso jbpm
     */
    @Transactional(readOnly = false)
    public void cancelarExpediente(Long idExpediente, Long idJBPM) {
        expedientesDao.cancelarExpediente(idExpediente, idJBPM);
    }

    /**
     * Devuelve la lista de expedientes activos para la fecha de extracción
     * indicada.
     *
     * @return la lista de expedientes activos
     */
    public Set<ExpedienteBatch> buscarExpedientesActivos() {
        return expedientesDao.buscarExpedientesActivos();
    }

}

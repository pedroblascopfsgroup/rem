package es.capgemini.pfs.asunto.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Dao para ProcedimientoContratoExpediente.
 *
 */
public interface ProcedimientoContratoExpedienteDao extends AbstractDao<ProcedimientoContratoExpediente, Long> {

    /**
     * Borra todos los CEX-PRC de un procedimiento y luego los vuelve a insertar.
     * @param list lista de ProcedimientoContratoExpediente
     * @param idProcedimiento long
     */
    void actualizaCEXProcedimiento(List<ProcedimientoContratoExpediente> list, Long idProcedimiento);

}

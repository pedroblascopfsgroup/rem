package es.pfsgroup.plugin.recovery.mejoras.asunto.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.dao.AbstractDao;

public interface MEJProcedimientoContratoExpedienteDao extends AbstractDao<ProcedimientoContratoExpediente, Long> {

	 /**
     * Borra todos los CEX-PRC de un procedimiento y luego los vuelve a insertar.
     * @param list lista de ProcedimientoContratoExpediente
     * @param idProcedimiento long
     */
    void actualizaCEXProcedimiento(List<ProcedimientoContratoExpediente> list, Long idProcedimiento);
    
    /**
     * Borra previo de los creditos asociados a un ContratoExpediente
     * PBO: Introducido para resolver la incidencia UGAS-1369
     * @param idProcedimiento, idContratoExpediente
     */
    public void borraCreditos(ProcedimientoContratoExpediente procContratoExpediente);
}

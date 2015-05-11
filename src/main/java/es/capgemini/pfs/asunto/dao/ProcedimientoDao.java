package es.capgemini.pfs.asunto.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Interfaz para manejar el acceso a datos de los procedimientos.
 * @author pamuller
 *
 */
public interface ProcedimientoDao extends AbstractDao<Procedimiento, Long> {

    /**
     * Devuelve los procedimientos asociados a un expediente.
     * @param idExpediente el id del expediente
     * @return la lista de procedimientos.
     */
    List<Procedimiento> getProcedimientosExpediente(Long idExpediente);

    /**
     * Devuelve el expedienteContrato correspondiente al contrato.
     * @param idContrato el id del contrato.
     * @return el ExpedienteContrato.
     */
    ExpedienteContrato getContratoExpediente(Long idContrato);



    /**
     * Devuelve los procedimientos asociados a un asunto.
     * @param idAsunto el id del asunto
     * @return la lista de procedimientos
     */
    List<Procedimiento> getProcedimientosAsunto(Long idAsunto);

    /**
     * Indica si el usuario logueado tiene que responder alguna comunicación.
     * @param idProcedimiento el id del procedimiento.
     * @param usuarioLogado el usuario logueado
     * @return true o false;
     */
    TareaNotificacion buscarTareaPendiente(Long idProcedimiento, Long usuarioLogado);
}

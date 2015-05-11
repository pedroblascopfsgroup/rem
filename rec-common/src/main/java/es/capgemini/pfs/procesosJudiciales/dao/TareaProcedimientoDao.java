package es.capgemini.pfs.procesosJudiciales.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

/**
 * Interfaz dao para las tareas procedimientos.
 *
 * @author pamuller
 *
 */
public interface TareaProcedimientoDao extends AbstractDao<TareaProcedimiento, Long> {

    /**
     * buscarPorTipoProcedimientoSubtipoTarea.
     *
     * @param codigoTareaProcedimiento
     *            codigo de la tarea del procedimiento
     * @return TareaProcedimiento
     */
    TareaProcedimiento buscarPorTipoProcedimientoPorCodigo(String codigoTareaProcedimiento);

    /**
     * getByTipoProcedimiento.
     * @param codigoTipoProcedimiento codigo
     * @return tp
     */
    List<TareaProcedimiento> getByTipoProcedimiento(String codigoTipoProcedimiento);

    /**
     * getByCodigoTareaIdTipoProcedimiento.
     * @param idTipoProcedimiento id
     * @param codigoTarea codigo
     * @return tp
     */
    TareaProcedimiento getByCodigoTareaIdTipoProcedimiento(Long idTipoProcedimiento, String codigoTarea);

}

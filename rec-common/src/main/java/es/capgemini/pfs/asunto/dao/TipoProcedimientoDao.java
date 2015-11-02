package es.capgemini.pfs.asunto.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

/**
 * Interfaz para manejar el acceso a datos de los procedimientos.
 * @author pamuller
 *
 */
public interface TipoProcedimientoDao extends AbstractDao<TipoProcedimiento, Long> {

    /**
     * Devuelve un TipoProcedimiento por su cÃ³digo.
     * @param codigo el codigo del TipoProcedimiento
     * @return el TipoProcedimiento.
     */
    TipoProcedimiento getByCodigo(String codigo);

    /**
     * Devuelve un listado de TipoProcedimiento de un tipo determinado de actuación
     * @param codigoActuacion
     * @return
     */
    List<TipoProcedimiento> getTipoProcedimientosPorTipoActuacion(String codigoActuacion);
    
	/**
	 * Busqueda de MEJTipoProcedimiento que la descripcion empiece po "P"
	 * @return Listado de MEJTipoProcedimiento que cumplen dicho filtro.
	 */
	List<TipoProcedimiento> busquedaProcedimientosAsignacionDeGestores();

}

package es.capgemini.pfs.asunto.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

public interface TipoProcedimientoDao extends AbstractDao<TipoProcedimiento, Long> {

    /**
     * Devuelve un TipoProcedimiento por su código.
     * @param codigo el codigo del TipoProcedimiento
     * @return el TipoProcedimiento.
     */
    TipoProcedimiento getByCodigo(String codigo);

    /**
     * Devuelve un listado de TipoProcedimiento de un tipo determinado de actuaci�n
     * @param codigoActuacion
     * @return
     */
    List<TipoProcedimiento> getTipoProcedimientosPorTipoActuacion(String codigoActuacion);

}


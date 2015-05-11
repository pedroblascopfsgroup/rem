package es.capgemini.pfs.asunto.dao;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.dao.AbstractDao;

public interface EstadoProcedimientoDao extends AbstractDao<DDEstadoProcedimiento, Long> {

    /**
     * Busca un estado de Procedimiento por su código.
     * @param codigo el codigo del Estado del Procedimiento,
     * @return el Estado del Procedimiento.
     */
    DDEstadoProcedimiento buscarPorCodigo(String codigo);
}

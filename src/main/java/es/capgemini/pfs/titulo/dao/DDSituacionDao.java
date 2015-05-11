package es.capgemini.pfs.titulo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.titulo.model.DDSituacion;

/**
 * Interfase que contiene los métodos de acceso a la entidad DDSituaci�n.
 * @author mtorrado
 *
 */
public interface DDSituacionDao extends AbstractDao<DDSituacion, Long> {

    /**
     * Retorna la situaci�n para un código determinado.
     * @param codigo String
     * @return DDSituacion
     */
    DDSituacion obtenerSituacion(String codigo);
}

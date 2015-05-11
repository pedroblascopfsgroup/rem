package es.capgemini.pfs.itinerario.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;

/**
 * Interfaz DDEstadoItinerarioDao.
 * @author jbosnjak
 *
 */
public interface DDEstadoItinerarioDao extends AbstractDao<DDEstadoItinerario, Long> {

    /**
     * findByCodigo.
     * @param codigo codigo estado
     * @return estado
     */
    List<DDEstadoItinerario> findByCodigo(String codigo);

    /**
     * devuelve los estados correspondientes a un tipo de entidad.
     * @param tipoEntidad el tipo de entidad
     * @return los estados.
     */
    List<DDEstadoItinerario> findByEntidad(String tipoEntidad);
}

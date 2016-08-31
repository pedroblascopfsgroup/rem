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
    
    /**
     * devuelve los estados correspondientes a un tipo de entidad y un tipo de itinerario.
     * @param tipoEntidad el tipo de entidad y codigo del tipo de itinerario
     * @return los estados.
     */
    List<DDEstadoItinerario> findByEntidadAndTipoItinerario(String tipoEntidad, String codigoTipoItinerario);
}

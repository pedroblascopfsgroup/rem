package es.capgemini.pfs.itinerario.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * Interfaz dao para los estados.
 * @author pajimene
 */
public interface EstadoDao extends AbstractDao<Estado, Long> {

    /**
     * Devuelve true o false dependiendo de si existe un gestor algún perfil indicado en el estado indicado.
     * @param vPerfiles listado de los perfiles buscados
     * @param estadoItinerario estado buscado
     * @return boolean
     */
    boolean existeGestorByPerfilEstadoItinerario(List<Perfil> vPerfiles, DDEstadoItinerario estadoItinerario);

    /**
     * Recupera un estado sabiendo su itinerario y su ddEstadoItinerario.
     * @param itinerario Itinerario
     * @param ddEstadoItinerario DDEstadoItinerario
     * @return Estado
     */
    Estado getEstado(Itinerario itinerario, DDEstadoItinerario ddEstadoItinerario);
}

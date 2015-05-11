package es.capgemini.pfs.itinerario;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.itinerario.dao.EstadoDao;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * Manager de Estado.
 *
 */
@Service
public class EstadoManager {
    @Autowired
    private EstadoDao estadoDao;

    /**
     * Recupera un estado sabiendo su itinerario y su ddEstadoItinerario.
     * @param itinerario Itinerario
     * @param ddEstadoItinerario DDEstadoItinerario
     * @return Estado
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_EST_MGR_GET)
    public Estado get(Itinerario itinerario, DDEstadoItinerario ddEstadoItinerario) {
        return estadoDao.getEstado(itinerario, ddEstadoItinerario);
    }

    /**
     * Devuelve true o false dependiendo de si existe un gestor algún perfil indicado en el estado indicado.
     * @param vPerfiles listado de los perfiles buscados
     * @param estadoItinerario estado buscado
     * @return boolean
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_EST_MGR_EXISTE_GESTOR_BY_PERFIL)
    public boolean existeGestorByPerfilEstadoItinerario(List<Perfil> vPerfiles, DDEstadoItinerario estadoItinerario){
    	return estadoDao.existeGestorByPerfilEstadoItinerario(vPerfiles, estadoItinerario);
    }

}

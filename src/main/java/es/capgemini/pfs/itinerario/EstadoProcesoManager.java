package es.capgemini.pfs.itinerario;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.EstadoProceso;

/**
 * manager de estado proceso.
 * @author jbosnjak
 *
 */
@Service
public class EstadoProcesoManager {

    

    /**
     * get estado proceso.
     * @param id id de proceso
     * @return proceso
     */
    @BusinessOperation
    public EstadoProceso get(Long id) {
        return null;
    }

    /**
     * save.
     * @param estado estado
     * @return id
     */
    @BusinessOperation
    public Long save(EstadoProceso estado) {
        return null;
    }

    /**
     * save.
     * @param estado estado
     */
    @BusinessOperation
    public void saveOrUpdate(EstadoProceso estado) {
      
    }

    /**
     * Agrega un nuevo estado.
     * @param entidad entidad
     * @param codigoTipoEntidad tipo entidad
     * @param estadoItinerario estadoItinerario
     * @param idBPM id bpm
     */
    @Transactional(readOnly = false)
    public void pasarDeEstado(Long entidad, String codigoTipoEntidad, Estado estadoItinerario, Long idBPM) {
       
    }

    /**
     * Borra la entida de estadoProcesoDao activa.
     * @param entidad id
     * @param codigoTipoEntidad tipoEntidad
     */
    @Transactional(readOnly = false)
    public void borrarEstadoProcesoActivo(Long entidad, String codigoTipoEntidad) {
        
    }

    /**
     * decofifica la entidad.
     * @param entidad entidad
     * @return entidaddecodificada
     */
    private void decodificarTipoEntidad(Long entidad, String codigoTipoEntidad, EstadoProceso estadoProceso) {
        
    }
}

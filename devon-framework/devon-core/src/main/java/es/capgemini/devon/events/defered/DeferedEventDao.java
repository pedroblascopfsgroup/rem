package es.capgemini.devon.events.defered;

import java.util.Date;
import java.util.List;

import org.springframework.dao.DataAccessException;

/**
 * Interfaz DAO para los eventos diferidos
 * 
 * @author Nicolás Cornaglia
 */
public interface DeferedEventDao {

    /**
     * Listar eventos por canal/fecha
     * 
     * @param channelName
     * @param before
     * @return
     * @throws DataAccessException
     */
    public List<DeferedEvent> findJobsToExecuteByName(String channelName, Date before) throws DataAccessException;

    /**
     * Obtener un evento por id
     * 
     * @param id
     * @return
     */
    public DeferedEvent get(Long id);

    /**
     * Actualizar/crear un evento
     * 
     * @param object
     */
    public void saveOrUpdate(DeferedEvent object);

}

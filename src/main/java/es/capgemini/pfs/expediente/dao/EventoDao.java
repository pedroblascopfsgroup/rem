package es.capgemini.pfs.expediente.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

public interface EventoDao extends AbstractDao<TareaNotificacion, Long> {

    /**
     * Devuelve las tareasNotificacion de un expediente en concreto.
     * @param idExpediente Identificador del expediente
     * @return Listado de tareaNotificacion.
     */
    public List<TareaNotificacion> getTareasExpediente(Long idExpediente);

    /**
     * Devuelve las tareasNotificacion de una persona en concreto.
     * @param idPersona Identificador de la persona
     * @return Listado de tareaNotificacion.
     */
    public List<TareaNotificacion> getTareasPersona(Long idPersona);

    /**
     * Devuelve las tareasNotificacion de un asunto en concreto.
     * @param idAsunto Identificador del asunto
     * @return Listado de tareaNotificacion.
     */
    public List<TareaNotificacion> getTareasAsunto(Long idAsunto);

}

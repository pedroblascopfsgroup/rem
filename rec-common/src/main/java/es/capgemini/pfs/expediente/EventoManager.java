package es.capgemini.pfs.expediente;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.expediente.dao.EventoDao;
import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Manager que alberga las businessOperations de acceso a los eventos.
 * @author pajimene
 *
 */
@Service
public class EventoManager {

    @Autowired
    private EventoDao eventoDao;


    @BusinessOperation(InternaBusinessOperation.BO_EVENTO_MGR_EVENTOS_EXPEDIENTE)
    public List<Evento> getEventosExpediente(Long idExpediente) {
        List<Evento> lista = new ArrayList<Evento>();

        for (TareaNotificacion t : eventoDao.getTareasExpediente(idExpediente)) {
            Evento e = new Evento(t, Evento.TIPO_EVENTO_EXPEDIENTE);
            lista.add(e);
        }

        return lista;
    }

    /**
     * Devuelve los eventos de una persona.
     * @param idPersona
     * @return List Evento
     */
    @BusinessOperation(InternaBusinessOperation.BO_EVENTO_MGR_EVENTOS_PERSONA)
    public List<Evento> getEventosPersona(Long idPersona) {
        List<Evento> lista = new ArrayList<Evento>();

        for (TareaNotificacion t : eventoDao.getTareasPersona(idPersona)) {
            Evento e = new Evento(t, Evento.TIPO_EVENTO_PERSONA);
            lista.add(e);
        }

        return lista;
    }

    /**
     * Devuelve los eventos de un Asunto.
     * @param idAsunto
     * @return List Evento
     */
    @BusinessOperation(InternaBusinessOperation.BO_EVENTO_MGR_EVENTOS_ASUNTO)
    public List<Evento> getEventosAsunto(Long idAsunto) {
        List<Evento> lista = new ArrayList<Evento>();

        for (TareaNotificacion t : eventoDao.getTareasAsunto(idAsunto)) {
            Evento e = new Evento(t, Evento.TIPO_EVENTO_ASUNTO);
            lista.add(e);
        }

        return lista;
    }

    /**
     * Devuelve una lista con el historico de eventos para una entidad de informacion.
     * @param tipoEntidad El Codigo de tipo de entidad (Ver {@link TipoEntidad} )
     * @param idEntidad El id de la entidad de informacion
     * @return List Evento
     */
    @BusinessOperation(InternaBusinessOperation.BO_EVENTO_MGR_HISTORICO_EVENTOS)
    public List<Evento> getHistoricoEventos(String tipoEntidad, Long idEntidad) {
        List<Evento> ls = null;
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
			return getEventosAsunto(idEntidad);
		}
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad)) {
			return getEventosPersona(idEntidad);
		}
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			return getEventosExpediente(idEntidad);
		}

        return ls;
    }
}

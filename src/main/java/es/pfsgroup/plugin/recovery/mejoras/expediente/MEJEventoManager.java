package es.pfsgroup.plugin.recovery.mejoras.expediente;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.expediente.EventoApi;
import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.recovery.mejoras.cliente.EventoClienteBuilder;
import es.pfsgroup.plugin.recovery.mejoras.expediente.dao.MEJEventoDao;

@Component
public class MEJEventoManager extends BusinessOperationOverrider<EventoApi> implements EventoApi{
	
	@Autowired
	MEJEventoDao eventoDao;
	
	@Autowired
	ApiProxyFactory proxyFactory;

	@Override
	public String managerName() {
		return "eventoManager";
	}

	@Autowired(required = false)
	private List<EventoClienteBuilder> builders;
	
	@Autowired(required = false)
	private List<EventoExpedienteBuilder> buildersExpediente;
	 /**
     * Devuelve los eventos de un Asunto.
     * @param idAsunto
     * @return List Evento
     */
	@Override
	@BusinessOperation(overrides=InternaBusinessOperation.BO_EVENTO_MGR_EVENTOS_ASUNTO)
	public List<Evento> getEventosAsunto(Long idAsunto) {
		List<Evento> lista = new ArrayList<Evento>();

        for (TareaNotificacion t : eventoDao.getTareasAsunto(idAsunto)) {
            Evento e = new Evento(t, Evento.TIPO_EVENTO_ASUNTO);
            lista.add(e);
        }
       

        return lista;
	}

	@Override
	@BusinessOperation(overrides = InternaBusinessOperation.BO_EVENTO_MGR_EVENTOS_EXPEDIENTE)
	public List<Evento> getEventosExpediente(Long idExpediente) {
		List<Evento> lista = new ArrayList<Evento>();

        for (TareaNotificacion t : eventoDao.getTareasExpediente(idExpediente)) {
            Evento e = new Evento(t, Evento.TIPO_EVENTO_EXPEDIENTE);
            lista.add(e);
        }
        if(buildersExpediente != null){
        	for(EventoExpedienteBuilder builder:buildersExpediente){
        		lista.addAll(builder.getEventos(idExpediente));
        	}
        }
        return lista;
	}

	@Override
	@BusinessOperation(overrides = InternaBusinessOperation.BO_EVENTO_MGR_EVENTOS_PERSONA)
	public List<Evento> getEventosPersona(Long idPersona) {
		List<Evento> lista = new ArrayList<Evento>();

        for (TareaNotificacion t : eventoDao.getTareasPersona(idPersona)) {
            Evento e = new Evento(t, Evento.TIPO_EVENTO_PERSONA);
            lista.add(e);
        }
        if(builders != null){
        	for(EventoClienteBuilder builder:builders){
        		lista.addAll(builder.getEventos(idPersona));
        	}
        }
        return lista;
	}

	/**
     * Devuelve una lista con el historico de eventos para una entidad de informacion.
     * @param tipoEntidad El Codigo de tipo de entidad (Ver {@link TipoEntidad} )
     * @param idEntidad El id de la entidad de informacion
     * @return List Evento
     */
	@Override
	@BusinessOperation(overrides=InternaBusinessOperation.BO_EVENTO_MGR_HISTORICO_EVENTOS)
	public List<Evento> getHistoricoEventos(String tipoEntidad, Long idEntidad) {
		List<Evento> ls = null;
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
			return proxyFactory.proxy(EventoApi.class).getEventosAsunto(idEntidad);
		}
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad)) {
			return proxyFactory.proxy(EventoApi.class).getEventosPersona(idEntidad);
		}
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			return proxyFactory.proxy(EventoApi.class).getEventosExpediente(idEntidad);
		}

        return ls;
	}

	

}

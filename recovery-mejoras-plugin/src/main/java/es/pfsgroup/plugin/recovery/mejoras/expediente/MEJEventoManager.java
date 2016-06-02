package es.pfsgroup.plugin.recovery.mejoras.expediente;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.expediente.EventoApi;
import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.cliente.EventoClienteBuilder;
import es.pfsgroup.plugin.recovery.mejoras.cliente.dto.MEJHistoricoEventosClientesDto;
import es.pfsgroup.plugin.recovery.mejoras.evento.model.MEJEvento;
import es.pfsgroup.plugin.recovery.mejoras.expediente.dao.MEJEventoDao;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJRegistro;

@Component
public class MEJEventoManager extends BusinessOperationOverrider<EventoApi> implements EventoApi{
	
	@Autowired
	MEJEventoDao eventoDao;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;

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

	
	public List<MEJHistoricoEventosClientesDto> getHistoricoEventosClientes (String tipoEntidad, Long idEntidad){
		List<MEJHistoricoEventosClientesDto> listaEventosClientes = new ArrayList<MEJHistoricoEventosClientesDto>();
		List<Evento> listaEventos = getHistoricoEventos(tipoEntidad, idEntidad);
		MEJEvento mejev = null;
		MEJHistoricoEventosClientesDto dto = null;
		for(Evento event : listaEventos){
			dto = new MEJHistoricoEventosClientesDto();
			if(!Checks.esNulo(event.getTarea())){
				dto.setIdTarea(event.getTarea().getId());
				dto.setDescripcion(event.getDescripcion());
				dto.setTipoSolicitud(event.getTarea().getTipoSolicitud());
				dto.setFechaInicio(event.getTarea().getFechaInicio());
				dto.setFechaFin(event.getTarea().getFechaFin());
				dto.setFechaVenc(event.getTarea().getFechaVenc());
				dto.setAlertada(event.getTarea().getAlerta());
				dto.setFinalizada(event.getTarea().getAuditoria().isBorrado());
				dto.setEmisor(event.getTarea().getEmisor());
				dto.setCodigoSubtipoTarea(event.getTarea().getSubtipoTarea().getCodigoSubtarea());
				dto.setCodigoTipoTarea(event.getTarea().getSubtipoTarea().getTipoTarea().getCodigoTarea());
				dto.setIdEntidad(event.getTarea().getIdEntidad());
				dto.setCodigoEntidadInformacion(event.getTarea().getTipoEntidad().getCodigo());
				dto.setDescripcionTarea(event.getTarea().getDescripcionTarea());
				dto.setDescripcionEntidad(event.getTarea().getDescripcionEntidad());
				dto.setFcreacionEntidad(event.getTarea().getFechaCreacionEntidadFormateada());
				dto.setCodigoSituacion(event.getTarea().getSituacionEntidad());
				dto.setIdEntidadPersona(event.getTarea().getIdEntidadPersona());
				if(event.getTarea().getProrroga() != null){
					dto.setMotivoProrroga(event.getTarea().getProrroga().getCausaProrroga().getDescripcion());
					dto.setFechaPropuestaProrroga(event.getTarea().getProrroga().getFechaPropuesta());
				}
				if(event.getClass().getSimpleName().equals("MEJEvento")) {
					mejev = (MEJEvento) event;
					dto.setIdTraza(mejev.getIdTraza());
				}
			}
			else if(!Checks.esNulo(event.getIdRegistro())){
				
				Filter f = genericDao.createFilter(FilterType.EQUALS, "id", event.getIdRegistro());
				MEJRegistro registro = genericDao.get(MEJRegistro.class, f);
				Filter f1 = genericDao.createFilter(FilterType.EQUALS, "registro.id", event.getIdRegistro());
				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "clave", "EMISOR_COMENT");
				MEJInfoRegistro infoRegistro1 = genericDao.get(MEJInfoRegistro.class, f1,f2);
				
				
				Filter f3 = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(infoRegistro1.getValor()));
				Usuario usuario = genericDao.get(Usuario.class, f3);
				
				Filter f4 = genericDao.createFilter(FilterType.EQUALS, "clave", "DESCRIPCION_COMENT");
				MEJInfoRegistro infoRegistro2 = genericDao.get(MEJInfoRegistro.class, f1,f4);
				
				Filter f5 = genericDao.createFilter(FilterType.EQUALS, "id", registro.getIdEntidadInformacion());
				Persona persona = genericDao.get(Persona.class, f5);

				dto.setCodigoEntidadInformacion(registro.getTipoEntidadInformacion());
				dto.setIdRegistro(registro.getId());
				dto.setEmisor(usuario.getUsername());
				dto.setDescripcionEntidad(persona.getNom50());
				dto.setDescripcion(infoRegistro2.getValor());
				dto.setFechaInicio(registro.getAuditoria().getFechaCrear());
				dto.setIdEntidad(persona.getId());
				dto.setTipoSolicitud(registro.getTipo().getDescripcionLarga());
				dto.setIdTraza(registro.getId());
				dto.setIsRegistro(true);
				
				
			}
			listaEventosClientes.add(dto);
			
		}
		return listaEventosClientes;
	}

}

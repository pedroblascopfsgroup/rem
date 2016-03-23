package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.registro;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.evento.model.MEJEvento;
import es.pfsgroup.plugin.recovery.mejoras.expediente.EventoExpedienteBuilder;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;

@Component
public class EventoExpedienteMostrarAnotaciones implements
		EventoExpedienteBuilder {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;	
	
	@Override
	public List<Evento> getEventos(long idExpediente) {
		MEJTrazaDto dto = creaDTOObtenerTrazasExpediente(idExpediente);
		List<? extends MEJRegistroInfo> eventos = proxyFactory.proxy(
				MEJRegistroApi.class).buscaTrazasEvento(dto);

		return convierteRegistroAEvento(eventos);
	}
	private List<Evento> convierteRegistroAEvento(
			List<? extends MEJRegistroInfo> lista) {

		List<Evento> listaEventos = new ArrayList<Evento>();

		if (!Checks.estaVacio(lista)) {
			for (MEJRegistroInfo evento : lista) {
				Map<String, String> infoAdicional = proxyFactory.proxy(
						MEJRegistroApi.class).getMapaRegistro(evento.getId());
				String idTareaStr = infoAdicional
				.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.ID_NOTIFICACION);
				
				if (!Checks.esNulo(idTareaStr)) {
					try {
						TareaNotificacion tarea = proxyFactory.proxy(
								TareaNotificacionApi.class).get(
								Long.parseLong(idTareaStr));
						if (tarea != null) {
							listaEventos.add(new MEJEvento(tarea,
									Evento.TIPO_EVENTO_EXPEDIENTE,evento.getId(), getTipoAnotacion(infoAdicional.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.TIPO_ANOTACION))));
						}
					} catch (NumberFormatException e) {
					}
				}
			}
		}

		return listaEventos;
	}

	private String getTipoAnotacion(String tipo) {
		
		DDTipoAnotacion tipoAnotacion = genericDao.get(DDTipoAnotacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipo));
		
		return !Checks.esNulo(tipoAnotacion) ? tipoAnotacion.getDescripcion() : "";
	}
	
	private MEJTrazaDto creaDTOObtenerTrazasExpediente(final long idExpediente) {
		return new MEJTrazaDto() {

			@Override
			public long getUsuario() {
				return 0;
			}

			@Override
			public String getTipoUnidadGestion() {
				return DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE;
			}

			@Override
			public String getTipoEvento() {
				return AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_NOTIFICACION;
			}

			@Override
			public Map<String, Object> getInformacionAdicional() {
				return null;
			}

			@Override
			public long getIdUnidadGestion() {
				return idExpediente;
			}
		};
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}
}

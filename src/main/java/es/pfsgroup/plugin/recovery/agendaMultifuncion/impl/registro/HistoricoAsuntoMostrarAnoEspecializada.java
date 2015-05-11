package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.registro;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.registro.HistoricoAsuntoBuilder;
import es.capgemini.pfs.registro.HistoricoAsuntoDto;
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

@Component
public class HistoricoAsuntoMostrarAnoEspecializada implements HistoricoAsuntoBuilder {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public List<HistoricoAsuntoDto> getHistorico(long arg0) {

		MEJTrazaDto dto = creaDTOObtenerTrazasAsunto(arg0);
		List<? extends MEJRegistroInfo> eventos = proxyFactory.proxy(
				MEJRegistroApi.class).buscaTrazasEvento(dto);

		return convierteEnHistorico(eventos);
	}

	private MEJTrazaDto creaDTOObtenerTrazasAsunto(final long idAsunto) {
		return new MEJTrazaDto() {

			@Override
			public long getUsuario() {
				return 0;
			}

			@Override
			public String getTipoUnidadGestion() {
				return DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
			}

			@Override
			public String getTipoEvento() {
				return AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_ANO_ESPECIALIZADA;
			}

			@Override
			public Map<String, Object> getInformacionAdicional() {
				return null;
			}

			@Override
			public long getIdUnidadGestion() {
				return idAsunto;
			}
		};
	}

	private List<HistoricoAsuntoDto> convierteEnHistorico(
			List<? extends MEJRegistroInfo> eventos) {
		ArrayList<HistoricoAsuntoDto> historico = new ArrayList<HistoricoAsuntoDto>();

		if (!Checks.estaVacio(eventos)) {
			for (MEJRegistroInfo evento : eventos) {
				Map<String, String> infoAdicional = proxyFactory.proxy(
						MEJRegistroApi.class).getMapaRegistro(evento.getId());
				String idTareaStr = infoAdicional
						.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.ID_TAREA);
				if (!Checks.esNulo(idTareaStr)) {
					try {
						TareaNotificacion tarea = proxyFactory.proxy(
								TareaNotificacionApi.class).get(
								Long.parseLong(idTareaStr));
						if (tarea != null) {
							historico
									.add(creaDto(evento, tarea, infoAdicional));
						}
					} catch (NumberFormatException e) {
					}
				}
			}
		}

		return historico;
	}

	private HistoricoAsuntoDto creaDto(final MEJRegistroInfo evento,
			final TareaNotificacion tarea,
			final Map<String, String> infoAdicional) {
		return new HistoricoAsuntoDto() {

			@Override
			public String getSubtipoTarea() {
				if(tarea != null && tarea.getSubtipoTarea() != null){
					return tarea.getSubtipoTarea().getCodigoSubtarea();
				}else if(infoAdicional.get(SUBTIPO_TAREA) != null){
					return infoAdicional.get(SUBTIPO_TAREA);
				}else{
					return String.valueOf(703);
				}
			}
			
			@Override
			public String getTipoRegistro() {
				if(infoAdicional.get(TIPO_REGISTRO) != null){
					return infoAdicional.get(TIPO_REGISTRO);
				}else{
					return "";
				}
			}
			
			@Override
			public long getTipoEntidad() {
				return getIdTipoEntidad(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
			}

			@Override
			public boolean getRespuesta() {
				return false;
			}

			@Override
			public String getNombreUsuario() {
				return evento.getUsuario().getApellidoNombre();
			}

			@Override
			public String getNombreTarea() {
				return Checks.esNulo(tarea.getDescripcionTarea()) ? tarea
						.getTarea() : tarea.getDescripcionTarea();
			}

			@Override
			public long getIdProcedimiento() {
				if (tarea.getProcedimiento() != null) {
					return tarea.getProcedimiento().getId();
				} else {
					return 0;
				}
			}

			@Override
			public long getIdEntidad() {
				return evento.getIdEntidadInformacion();
			}

			@Override
			public Date getFechaVencimiento() {
				return tarea.getFechaVenc();
			}

			@Override
			public Date getFechaRegistro() {
				return evento.getFecha();
			}

			@Override
			public Date getFechaIni() {
				return tarea.getFechaInicio();
			}

			@Override
			public Date getFechaFin() {
				return tarea.getFechaFin();
			}

			@Override
			public Long getIdTarea() {
				return tarea.getId();
			}

			@Override
			public Long getIdTraza() {
				return evento.getId();
			}

			@Override
			public String getTipoTraza() {
				return evento.getTipo().getCodigo();
			}

			@Override
			public String getGroup() {
				return "E";
			}

			@Override
			public String getDescripcionTarea() {
				return null;
			}
		};
	}

	protected long getIdTipoEntidad(String codigoEntidadAsunto) {
		if (Checks.esNulo(codigoEntidadAsunto)) {
			return 0;
		} else {
			DDTipoEntidad te = genericDao.get(DDTipoEntidad.class, genericDao
					.createFilter(FilterType.EQUALS, "codigo",
							codigoEntidadAsunto));
			if (te != null) {
				return te.getId();
			} else {
				return 0;
			}
		}
	}

}

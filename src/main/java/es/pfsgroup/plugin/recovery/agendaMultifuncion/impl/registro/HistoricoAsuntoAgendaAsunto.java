package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.registro;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.registro.HistoricoAsuntoBuilder;
import es.capgemini.pfs.registro.HistoricoAsuntoDto;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;

@Component
public class HistoricoAsuntoAgendaAsunto implements HistoricoAsuntoBuilder{

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public List<HistoricoAsuntoDto> getHistorico(long arg0) {
		
		MEJTrazaDto dto = creaDTOObtenerTrazasAsunto(arg0);
		List<? extends MEJRegistroInfo> eventos = proxyFactory.proxy(MEJRegistroApi.class).buscaTrazasEvento(dto);
		
		
		return convierteEnHistorico(eventos);
	}

	private List<HistoricoAsuntoDto> convierteEnHistorico(
			List<? extends MEJRegistroInfo> eventos) {
		ArrayList<HistoricoAsuntoDto> historico = new ArrayList<HistoricoAsuntoDto>();
		
		if (!Checks.estaVacio(eventos)){
			for (MEJRegistroInfo evento : eventos){
				Map<String, String> infoAdicional = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(evento.getId());
				historico.add(creaDto(evento, infoAdicional));
			}
		}
		
		return historico;
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
				return AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_COMENTARIO;
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

	private HistoricoAsuntoDto creaDto(final MEJRegistroInfo evento, final Map<String, String> infoAdicional) {
		return new HistoricoAsuntoDto() {
			
			@Override
			public String getSubtipoTarea() {
				return infoAdicional.get(SUBTIPO_TAREA);
			}
			
			@Override
			public String getTipoRegistro() {
				return infoAdicional.get(TIPO_REGISTRO);
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
				if (Checks.estaVacio(infoAdicional)){
					return null;
				}else{
					return infoAdicional.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.ASUNTO_COMENTARIO);
				}
			}
			
			@Override
			public long getIdProcedimiento() {
				return 0;
			}
			
			@Override
			public long getIdEntidad() {
				return evento.getIdEntidadInformacion();
			}
			
			@Override
			public Date getFechaVencimiento() {
				return null;
			}
			
			@Override
			public Date getFechaRegistro() {
				return evento.getFecha();
			}
			
			@Override
			public Date getFechaIni() {
				String fechaStr = infoAdicional.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.FECHA_CREACION_COMENTARIO);
				Long timesTamp = Long.parseLong(fechaStr);
				
				return new Date(timesTamp);
			}
			
			@Override
			public Date getFechaFin() {
				return null;
			}


			@Override
			public Long getIdTarea() {
				return null;
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
				return "D";
			}

			@Override
			public String getDescripcionTarea() {
				return null;
			}
		};
	}

	protected long getIdTipoEntidad(String codigoEntidadAsunto) {
		if (Checks.esNulo(codigoEntidadAsunto)){
			return 0;
		}else{
			DDTipoEntidad te = genericDao.get(DDTipoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEntidadAsunto));
			if (te != null){
				return te.getId();
			}else{
				return 0;
			}
		}
	}

}

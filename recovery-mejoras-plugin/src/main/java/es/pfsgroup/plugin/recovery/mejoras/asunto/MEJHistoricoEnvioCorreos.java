package es.pfsgroup.plugin.recovery.mejoras.asunto;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.registro.HistoricoAsuntoBuilder;
import es.capgemini.pfs.registro.HistoricoAsuntoDto;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;

/**
 * Muestra las trazas del envio de correos en el historico del asunto
 * @author bruno
 *
 */
@Component
public class MEJHistoricoEnvioCorreos implements HistoricoAsuntoBuilder{

	public static final String NOMBRE_TAREA = "Env�o de correo al gestor externo";

	protected static final long ID_TIPO_ENTIDAD_INFORMACION = 3L;

	protected static final boolean REQUIERE_RESPUESTA = false;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public List<HistoricoAsuntoDto> getHistorico(long idAsunto) {
		List<? extends MEJRegistroInfo> registro = proxyFactory.proxy(MEJRegistroApi.class).buscaTrazasEvento(dtoBusqueda(idAsunto));
		ArrayList<HistoricoAsuntoDto> historico = new ArrayList<HistoricoAsuntoDto>();
		if (registro != null){
			for (MEJRegistroInfo traza : registro){
				historico.add(dtoHistorico(idAsunto,traza));
			}
		}
		return historico;
	}

	private HistoricoAsuntoDto dtoHistorico(final long idAsunto, final MEJRegistroInfo traza) {
		HistoricoAsuntoDto dto = new HistoricoAsuntoDto() {
			
			@Override
			public String getSubtipoTarea() {
				return "";
			}
			
			@Override
			public String getDescripcionTarea() {
				return "";
			}
			
			@Override
			public String getTipoRegistro() {
				if(traza != null && traza.getTipo() != null){
					return traza.getTipo().getCodigo();
				}else{
					return "";
				}
			}
			
			@Override
			public long getTipoEntidad() {
				return ID_TIPO_ENTIDAD_INFORMACION;
			}
			
			@Override
			public boolean getRespuesta() {
				return REQUIERE_RESPUESTA;
			}
			
			@Override
			public String getNombreUsuario() {
				return traza.getUsuario().getUsername();
			}
			
			@Override
			public String getNombreTarea() {
				return NOMBRE_TAREA;
			}
			
			@Override
			public long getIdProcedimiento() {
				return idAsunto;
			}
			
			@Override
			public long getIdEntidad() {
				return traza.getIdEntidadInformacion();
			}
			
			@Override
			public Date getFechaVencimiento() {
				return null;
			}
			
			@Override
			public Date getFechaRegistro() {
				return null;
			}
			
			@Override
			public Date getFechaIni() {
				return traza.getFecha();
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
				return traza.getId();
			}

			@Override
			public String getTipoTraza() {
				return traza.getTipo().getCodigo();
			}

			@Override
			public String getGroup() {
				return "B";
			}
		};
		return dto;
	}

	private MEJTrazaDto dtoBusqueda(final long idAsunto) {
		return new MEJTrazaDto() {
			
			@Override
			public String getTipoUnidadGestion() {
				return DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
			}
			
			@Override
			public String getTipoEvento() {
				return MEJDDTipoRegistro.CODIGO_ENVIO_EMAILS;
			}
			
			@Override
			public long getIdUnidadGestion() {
				return idAsunto;
			}

			@Override
			public Map<String, Object> getInformacionAdicional() {
				// TODO Auto-generated method stub
				return null;
			}

			@Override
			public long getUsuario() {
				// TODO Auto-generated method stub
				return 0;
			}
		};
	}

}

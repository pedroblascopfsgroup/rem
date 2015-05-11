package es.pfsgroup.plugin.recovery.mejoras.asunto;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.registro.ModificacionAsuntoListener;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;

@Component
public class MEJModificacionAsuntoListenerImpl implements ModificacionAsuntoListener{
	
	@Autowired
	ApiProxyFactory proxyFactory;

	@Override
	public void fireEvent(final Map<String, Object> map) {
		final Usuario u =proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		MEJTrazaDto traza = new MEJTrazaDto() {
			@Override
			public long getUsuario() {
				return u.getId();
			}
			@Override
			public String getTipoUnidadGestion() {
				return DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
			}
			@Override
			public String getTipoEvento() {
				return MEJDDTipoRegistro.CODIGO_EDICION_ASUNTO;
			}
			@Override
			public Map<String, Object> getInformacionAdicional() {
				return map;
			}
			@Override
			public long getIdUnidadGestion() {
				return (Long) map.get(ID_ASUNTO);
			}
		};
		proxyFactory.proxy(MEJRegistroApi.class).guardatTrazaEvento(traza);
	}
	
	

}

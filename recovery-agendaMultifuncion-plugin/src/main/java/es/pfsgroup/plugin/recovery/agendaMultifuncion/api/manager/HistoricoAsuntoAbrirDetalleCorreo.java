package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.HistoricoAsuntoAbrirDetalleHandler;

@Component
public class HistoricoAsuntoAbrirDetalleCorreo implements
		HistoricoAsuntoAbrirDetalleHandler {

	
	  @Autowired
	  GenericABMDao genericDao;

	  @Autowired
	  private ApiProxyFactory proxyFactory;
	
	
	@Override
	public String getJspName() {
		return "plugin/agendaMultifuncion/asunto/detalleCorreoHistorico";
	}

	@Override
	public Object getViewData(Long idTarea, Long idTraza, Long idEntidad) {

        Map<String, String> info = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(idTraza);
        String body = info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_BODY);
        String to = info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_TO);
        String cc = info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_CC);
        String from = info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_FROM);
        String asunto = info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_ASUNTO);
        
        HashMap<String,Object> parametros = new HashMap<String, Object>();
        parametros.put("body", body);
        parametros.put("to", to);
        if(cc != null)
        	parametros.put("cc",cc);
        parametros.put("from", from);
        parametros.put("asunto", asunto);
        parametros.put("codUg",DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
        parametros.put("idAsunto", idEntidad);
        return parametros;
	}

	@Override
	public String getValidString() {
		return AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_CORREO_ELECTRONICO;
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}

}

package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.asunto;

import java.util.HashMap;

import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.RecoveryAgendaMultifuncionDtoBusquedaAsunto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.recovery.ext.api.asunto.EXTBusquedaAsuntoFiltroDinamico;

@Component
public class AgendaMultifuncionBusquedaAsuntoFiltro implements
		EXTBusquedaAsuntoFiltroDinamico {

	private static final String ORIGEN_FILTROS = "agendaMultifuncion";
	@Override
	public String getOrigenFiltros() {
		return ORIGEN_FILTROS;
	}

	@Override
	public String obtenerFiltro(String paramsDinamicos) {
		HashMap<String, Object> params = new HashMap<String, Object>();
		StringBuffer filtro = new StringBuffer();
		filtro.append(" select distinct v.id from BusquedaAsuntosFiltroAgendaBean v ");
		RecoveryAgendaMultifuncionDtoBusquedaAsunto dto = creaDtoParametros(paramsDinamicos);
		filtro.append(" where 1=1 ");		
		if (StringUtils.hasText(dto.getUsuarioDestinoTarea())) {
			filtro.append(" and v.usu_username = '"+dto.getUsuarioDestinoTarea()+"' ");
		}
		if (StringUtils.hasText(dto.getUsuarioOrigenTarea())) {
			filtro.append(" and v.tar_emisor = '"+dto.getUsuarioOrigenTarea()+"' ");
		}
        if (!Checks.esNulo(dto.getSoloAsuntosEnvioCorreo()) && dto.getSoloAsuntosEnvioCorreo() == true) {
        	filtro.append(" and v.dd_trg_codigo = '"+MEJDDTipoRegistro.CODIGO_ENVIO_EMAILS +"' ");
            if (StringUtils.hasText(dto.getDestinatarioEmail())) {
            	filtro.append(" and v.irg_clave = '"+MEJDDTipoRegistro.RegistroEmail.CLAVE_EMAIL_DESTINO +"' ");
            	
            	filtro.append(" and v.irg_valor = '|| :destEmail ||'");
            	params.put("destEmail", dto.getDestinatarioEmail().toLowerCase());
            	
//            	filtro.append(" and v.irg_valor = '"+dto.getDestinatarioEmail().toLowerCase()+"' ");
            }
        }
        if (StringUtils.hasText(dto.getTipoAnotacion())) {
        	filtro.append(" and (");
        	filtro.append(" (");
        	filtro.append(" v.dd_trg_codigo = '"+ AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_TAREA +"' ");
        	filtro.append(" and v.irg_clave = '"+ AgendaMultifuncionTipoEventoRegistro.EventoTarea.TIPO_ANOTACION +"' ");
        	filtro.append(" ) or (");
        	filtro.append(" v.dd_trg_codigo = '"+AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_NOTIFICACION +"' ");
        	filtro.append(" and v.irg_clave = '"+ AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.TIPO_ANOTACION +"' ");
        	filtro.append(" ) or (");
        	filtro.append(" v.dd_trg_codigo = '"+ AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_COMENTARIO+"' ");
        	filtro.append(" and v.irg_clave  = '"+ AgendaMultifuncionTipoEventoRegistro.EventoComentario.TIPO_ANOTACION +"' ");
        	filtro.append(" )");
        	filtro.append(" )");
        	filtro.append(" and v.irg_valor = '"+ dto.getTipoAnotacion().toLowerCase() +"' ");
        }		
		return filtro.toString();
	}

	@Override
	public boolean isValid(String paramsDinamicos) {
		String[] parametros = paramsDinamicos.split(";");		
		if(parametros != null && parametros.length > 0){
			String [] parametroOrigen = parametros[0].split(":");
			if(parametroOrigen != null && parametroOrigen.length == 2 ){
				if(parametroOrigen[0].equalsIgnoreCase("origen") && parametroOrigen[1].equalsIgnoreCase(ORIGEN_FILTROS))
					return true;
			}
		}
		return false;
	}
	
	private RecoveryAgendaMultifuncionDtoBusquedaAsunto creaDtoParametros(String paramsDinamicos){
		RecoveryAgendaMultifuncionDtoBusquedaAsunto dto = new RecoveryAgendaMultifuncionDtoBusquedaAsunto();		
		String[] parametros = paramsDinamicos.split(";");		
		if(parametros != null && parametros.length > 0){
			for(String param:parametros){
				String[] paramV = param.split(":");
				if(paramV != null && paramV.length == 2 ){
					if(paramV[0].equalsIgnoreCase("usuarioDestinoTarea") && paramV[1]!= "")
						dto.setUsuarioDestinoTarea(paramV[1]);
					if(paramV[0].equalsIgnoreCase("usuarioOrigenTarea") && paramV[1]!= "")
						dto.setUsuarioOrigenTarea(paramV[1]);
					if(paramV[0].equalsIgnoreCase("tipoAnotacion") && paramV[1]!= "")
						dto.setTipoAnotacion(paramV[1]);
					if(paramV[0].equalsIgnoreCase("soloAsuntosEnvioCorreo") && paramV[1]!= "")
						dto.setSoloAsuntosEnvioCorreo(Boolean.parseBoolean(paramV[1]));
					if(paramV[0].equalsIgnoreCase("destinatarioEmail") && paramV[1]!= "")
						dto.setDestinatarioEmail(paramV[1]);
				}
			}
		}
		return dto;
	}	

}

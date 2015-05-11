package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoMostrarAnotacion;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.HistoricoAsuntoAbrirDetalleHandler;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.impl.tareas.DDTipoAnotacion;

@Component
public class HistoricoAsuntoAbrirDetalleComentario implements HistoricoAsuntoAbrirDetalleHandler {

    @Autowired
    GenericABMDao genericDao;

    @Autowired
    private ApiProxyFactory proxyFactory;

    @Override
    public Object getViewData(Long idTarea, Long idTraza, Long idEntidad) {

        DtoMostrarAnotacion result = new DtoMostrarAnotacion();

        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");

        Map<String, String> info = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(idTraza);

        String fechaCreacion = info.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.FECHA_CREACION_COMENTARIO);
        if (StringUtils.hasText(fechaCreacion)) {
            Long fechaLong = Long.parseLong(fechaCreacion);
            result.setFecha(format.format(new Date(fechaLong)));
        }

        String tipoAnotacion = info.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.TIPO_ANOTACION);
        DDTipoAnotacion tipoAnotacionDD = genericDao.get(DDTipoAnotacion.class, 
        		genericDao.createFilter(FilterType.EQUALS, "codigo", tipoAnotacion),
        		genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
       
        if(tipoAnotacionDD !=null)
        	result.setTipoAnotacion(tipoAnotacionDD.getDescripcion());
//        if ("A".equals(tipoAnotacion)) {
//            result.setTipoAnotacion("Alerta");
//        } else if ("R".equals(tipoAnotacion)) {
//            result.setTipoAnotacion("Recordatorio");
//        } else {
//            result.setTipoAnotacion("Desconocido");
//        }
        result.setDescripcion(substituirCadenaEspacioHtml(info.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.DESCRIPCION_COMENTARIO)));
        Long idEmisor = Long.parseLong(info.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.EMISOR_COMENTARIO));
        Usuario emisor = proxyFactory.proxy(UsuarioApi.class).get(idEmisor);
        result.setEmisor(emisor.getApellidoNombre());
        result.setIdAsunto(idEntidad);
        result.setSituacion("Asunto");
        result.setCodUg(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
        result.setIdTarea(idTarea);
        result.setIdTraza(idTraza);
        return result;
    }

    @Override
    public String getJspName() {
        return "plugin/agendaMultifuncion/asunto/detalleAnotacionHistorico";
    }

    @Override
	public String getValidString() {
		return AgendaMultifuncionTipoEventoRegistro.TIPO_EVENTO_COMENTARIO;
	}
    
    /**
     * Metodo que substituye la cadena &nbsp; por un espacio
     * @param descripcion
     * @return descripcion
     */
    private String substituirCadenaEspacioHtml(String descripcion) {
		
    	String desc = "";
		if (!Checks.esNulo(descripcion))
			desc = descripcion.replaceAll("&nbsp;", " ");
		
		return desc;
	}

}

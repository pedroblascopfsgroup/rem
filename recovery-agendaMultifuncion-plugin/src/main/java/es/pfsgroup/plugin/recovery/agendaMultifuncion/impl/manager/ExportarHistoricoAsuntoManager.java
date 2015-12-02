package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.manager;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionTipoEventoRegistro;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoExportarDetalleAnotacionHistorico;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoExportarDetalleCorreoHistorico;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.ExportarHistoricoAsuntoManagerApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;

/**
 * Manager de exportaci�n de las anotaciones y correos del hist�rico de asuntos
 * @author Guillem
 *
 */
@Component
public class ExportarHistoricoAsuntoManager implements ExportarHistoricoAsuntoManagerApi{

	  @Autowired
	  private ApiProxyFactory proxyFactory;
	  
	  @Autowired
	  GenericABMDao genericDao;
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(HISTORICO_ASUNTOS_MANAGER_EXPORTAR_DETALLE_CORREO_HISTORICO)
	public DtoExportarDetalleCorreoHistorico exportaDetalleCorreoHistorico(DtoExportarDetalleCorreoHistorico dtoExportarDetalleCorreoHistorico){
		if(StringUtils.isNumeric(dtoExportarDetalleCorreoHistorico.getIdTraza()) && !dtoExportarDetalleCorreoHistorico.getIdTraza().equals("")){
			Map<String, String> info = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(Long.parseLong(dtoExportarDetalleCorreoHistorico.getIdTraza()));
			dtoExportarDetalleCorreoHistorico.setTexto(substituirCadenaEspacioHtml(info.get(AgendaMultifuncionTipoEventoRegistro.EventoCorreo.CORREO_BODY)));
		}
		return dtoExportarDetalleCorreoHistorico;
	}

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(HISTORICO_ASUNTOS_MANAGER_EXPORTAR_DETALLE_ANOTACION_HISTORICO)
	public DtoExportarDetalleAnotacionHistorico exportaDetalleAnotacionHistorico(DtoExportarDetalleAnotacionHistorico dtoExportarDetalleAnotacionHistorico){
		if(StringUtils.isNumeric(dtoExportarDetalleAnotacionHistorico.getIdTraza()) && !dtoExportarDetalleAnotacionHistorico.getIdTraza().equals("")){
	        Map<String, String> info = proxyFactory.proxy(MEJRegistroApi.class).getMapaRegistro(Long.parseLong(dtoExportarDetalleAnotacionHistorico.getIdTraza()));
			if(info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESCRIPCION_NOTIFICACION) != null && !info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESCRIPCION_NOTIFICACION).equals("")){
				dtoExportarDetalleAnotacionHistorico.setTexto(substituirCadenaEspacioHtml(info.get(AgendaMultifuncionTipoEventoRegistro.EventoNotificacion.DESCRIPCION_NOTIFICACION)));
			}else if(info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA) != null && !info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA).equals("")){
				dtoExportarDetalleAnotacionHistorico.setTexto(substituirCadenaEspacioHtml(info.get(AgendaMultifuncionTipoEventoRegistro.EventoTarea.DESCRIPCION_TAREA)));
			}else if(info.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.DESCRIPCION_COMENTARIO) != null && !info.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.DESCRIPCION_COMENTARIO).equals("")){
				dtoExportarDetalleAnotacionHistorico.setTexto(substituirCadenaEspacioHtml(info.get(AgendaMultifuncionTipoEventoRegistro.EventoComentario.DESCRIPCION_COMENTARIO)));
			}else{
				dtoExportarDetalleAnotacionHistorico.setTexto("");
			}
			
	        try{
				 Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.ID_TAREA_ORIGINAL);
			        Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", dtoExportarDetalleAnotacionHistorico.getIdTarea().toString());
			        Filter f3 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			        MEJInfoRegistro infoRegistro = genericDao.get(MEJInfoRegistro.class, f1, f2,f3);
			        
			        if(infoRegistro != null){//ESQUE HAY RESPUESTA
			        	  f1 = genericDao.createFilter(FilterType.EQUALS, "clave", AgendaMultifuncionTipoEventoRegistro.EventoRespuesta.RESPUESTA_TAREA);
			              f2 = genericDao.createFilter(FilterType.EQUALS, "registro.id", infoRegistro.getRegistro().getId());
			              MEJInfoRegistro infoRegistroRespuestaTarea = genericDao.get(MEJInfoRegistro.class, f1, f2,f3);
			              if(infoRegistroRespuestaTarea != null){
			            	  dtoExportarDetalleAnotacionHistorico.setRespuesta(infoRegistroRespuestaTarea.getValor());
			              }
			           
			        }			
			}catch(Throwable e){
				dtoExportarDetalleAnotacionHistorico.setRespuesta("");
			}
		} else if (dtoExportarDetalleAnotacionHistorico.getIdTarea() != null){
			try{
				 Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", "ID_NOTIF");
			        Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", dtoExportarDetalleAnotacionHistorico.getIdTarea().toString());
			        Filter f3 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			        MEJInfoRegistro infoRegistro = genericDao.get(MEJInfoRegistro.class, f1, f2,f3);
			        
			        if(infoRegistro != null){//ESQUE HAY RESPUESTA
			        	  f1 = genericDao.createFilter(FilterType.EQUALS, "clave", "DESCRIPCION_NOTIF");
			              f2 = genericDao.createFilter(FilterType.EQUALS, "registro.id", infoRegistro.getRegistro().getId());
			              MEJInfoRegistro infoRegistroRespuestaTarea = genericDao.get(MEJInfoRegistro.class, f1, f2,f3);
			              if(infoRegistroRespuestaTarea != null){
			            	  dtoExportarDetalleAnotacionHistorico.setRespuesta(infoRegistroRespuestaTarea.getValor());
			              }
			           
			        }			
			}catch(Throwable e){
				dtoExportarDetalleAnotacionHistorico.setRespuesta("");
			}
		}
		return dtoExportarDetalleAnotacionHistorico;
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

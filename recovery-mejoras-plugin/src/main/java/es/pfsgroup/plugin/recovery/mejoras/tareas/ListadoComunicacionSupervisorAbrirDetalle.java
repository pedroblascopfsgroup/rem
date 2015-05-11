package es.pfsgroup.plugin.recovery.mejoras.tareas;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.tareaNotificacion.dao.EXTTareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandler;

@Component
public class ListadoComunicacionSupervisorAbrirDetalle implements BuzonTareasViewHandler {

	protected static final Log logger = LogFactory.getLog(ListadoComunicacionSupervisorAbrirDetalle.class);
	private static final String JSP_NAME = "plugin/mejoras/tareas/consultaNotificacionSinRespuesta";
	private static final String SUBTIPO_TAREA = "26";	
	
	@Autowired
	private EXTTareaNotificacionDao extTareaNotificacionDao;
	
	@Override
	public String getValidString() {
		return SUBTIPO_TAREA;
	}

	@Override
	public Object getModel(Long idTarea) {
		Map<String, Object> param = new HashMap<String, Object>();		
		TareaNotificacion tareaNotificacion = extTareaNotificacionDao.get(idTarea);  
		param.put("textoComunicacion",tareaNotificacion.getDescripcionTarea());
		param.put("codigoTipoEntidad", tareaNotificacion.getTipoEntidad().getCodigo());
		param.put("situacion", tareaNotificacion.getProcedimiento().getEstadoProcedimiento().getDescripcion());
		SimpleDateFormat sd = new SimpleDateFormat("dd/MM/yyyy");
		param.put("fecha", sd.format(tareaNotificacion.getProcedimiento().getAuditoria().getFechaCrear()));
		param.put("idEntidad", tareaNotificacion.getProcedimiento().getId());
		param.put("readOnly", false);
		param.put("tipoTarea", tareaNotificacion.getCodigoTarea());
		param.put("idTarea", idTarea);
		
		return param;
	}

	@Override
	public String getJspName() {
		return JSP_NAME;
	}

}

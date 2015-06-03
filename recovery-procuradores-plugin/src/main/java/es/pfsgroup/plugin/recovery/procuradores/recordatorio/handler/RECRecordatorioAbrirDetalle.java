package es.pfsgroup.plugin.recovery.procuradores.recordatorio.handler;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.tareaNotificacion.dao.EXTTareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandler;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.dao.RECRecordatorioDao;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.model.RECRecordatorio;

@Component
public class RECRecordatorioAbrirDetalle implements BuzonTareasViewHandler {

	protected static final Log logger = LogFactory.getLog(RECRecordatorioAbrirDetalle.class);
	private static final String JSP_NAME = "plugin/procuradores/recordatorio/detalleTareaRecordatorio";
	private static final String SUBTIPO_TAREA = "TAREA_RECORDATORIO";	
	
	@Autowired
	private EXTTareaNotificacionDao extTareaNotificacionDao;
	
	@Autowired
	private RECRecordatorioDao recRecordatorioDao;
	
	@Override
	public String getValidString() {
		return SUBTIPO_TAREA;
	}

	@Override
	public Object getModel(Long idTarea) {
		Map<String, Object> param = new HashMap<String, Object>();	
		
		///Obtenemos los datos de la tarea
		TareaNotificacion tareaNotificacion = extTareaNotificacionDao.get(idTarea);  
		param.put("descripcion",tareaNotificacion.getDescripcionTarea());
		SimpleDateFormat sd = new SimpleDateFormat("dd/MM/yyyy");
		param.put("fechaVencimiento", sd.format(tareaNotificacion.getFechaVenc()));
		param.put("idTarea", idTarea);
		
		///Obtenemos los datos del recordatorio
		RECRecordatorio recordatorio = recRecordatorioDao.getRecordatorioByTarea(idTarea);
		param.put("recordatorio", recordatorio);
		
		
		return param;
	}

	@Override
	public String getJspName() {
		return JSP_NAME;
	}

}

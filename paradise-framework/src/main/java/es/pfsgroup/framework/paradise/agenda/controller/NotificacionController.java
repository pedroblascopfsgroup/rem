package es.pfsgroup.framework.paradise.agenda.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.pfsgroup.framework.paradise.agenda.adapter.NotificacionAdapter;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.utils.JsonViewer;

@Controller
public class NotificacionController {

	@Autowired
	private NotificacionAdapter notificacionAdapter;

	/**
	 * Método para modificar la plantilla de JSON utilizada en el servlet.
	 * 
	 * @param request
	 * @param binder
	 * @throws Exception
	 */
	@InitBinder
	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {

		JsonWriterConfiguratorTemplateRegistry registry = JsonWriterConfiguratorTemplateRegistry
				.load(request);
		registry.registerConfiguratorTemplate(new SojoJsonWriterConfiguratorTemplate() {
			@Override
			public SojoConfig getJsonConfig() {
				SojoConfig config = new SojoConfig();
				config.setIgnoreNullValues(true);
				return config;
			}
		});

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(
				dateFormat, false));
	}



	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findOne(Long id) throws ParseException {
		return JsonViewer.createModelAndViewJson(new ModelMap("data", notificacionAdapter.findOne(id)));
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveNotificacion(WebRequest request) throws ParseException {

		Map m= request.getParameterMap();
		Set s = m.entrySet();
		Iterator it = s.iterator();

        Notificacion notificacion = new Notificacion();
 
		while (it.hasNext()) {
			@SuppressWarnings("unchecked")
			Map.Entry<String, String[]> entry = (Map.Entry<String, String[]>) it.next();
			String key = entry.getKey();
			String[] value = entry.getValue();

			if (key.equals("idActivo")) notificacion.setIdActivo(new Long(value[0]));
			//if (key.equals("destinatarioNotificacion")) notificacion.setDestinatario(new Long(value[0]));
			if (key.equals("usuarioGestor")) notificacion.setDestinatario(new Long(value[0]));
			if (key.equals("tituloNotificacion")) notificacion.setTitulo(value[0]);
			if (key.equals("descripcionNotificacion")) notificacion.setDescripcion(value[0]);
			if (key.equals("fechaNotificacion")) notificacion.setStrFecha(value[0]);
		}
		
		notificacionAdapter.saveNotificacion(notificacion);		
		return JsonViewer.createModelAndViewJson(new ModelMap("data", request.getParameterMap()));
	}
	
    @RequestMapping(method = RequestMethod.POST)
    public ModelAndView saveNotificacionRespuesta(WebRequest request, ModelMap model){
    	boolean success = false;
    	model.put("success", success);
    	success = notificacionAdapter.saveNotificacionRespuesta(request.getParameterMap());
    	
    	return JsonViewer.createModelAndViewJson(model);
    }
    
    @RequestMapping(method = RequestMethod.POST)
    public ModelAndView finalizarNotificacion(Long idTarea, ModelMap model){
    	boolean success = false;
    	model.put("success",success);
    	success = notificacionAdapter.finalizarNotificacion(idTarea);
    	
    	return JsonViewer.createModelAndViewJson(model);
    }
	
}

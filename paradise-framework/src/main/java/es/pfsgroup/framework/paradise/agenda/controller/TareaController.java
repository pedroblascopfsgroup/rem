package es.pfsgroup.framework.paradise.agenda.controller;

import java.text.ParseException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.agenda.adapter.TareaAdapter;
import es.pfsgroup.framework.paradise.agenda.formulario.ParadiseFormManager;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.JsonViewer;

@Controller
public class TareaController extends ParadiseJsonController{

	@Autowired
	private TareaAdapter tareaAdapter;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private ParadiseFormManager genericFormManager;

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findOne(Long id) throws ParseException {
		return JsonViewer.createModelAndViewJson(new ModelMap("data", tareaAdapter.findOne(id)));
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveFormAndAdvance(WebRequest request) {
		
		DtoGenericForm dto = new DtoGenericForm();
    	Long idTarea = 0L;
    	
    	Map<String, String> camposFormulario = new HashMap<String,String>();
		Map<String, String[]> parameterNames = request.getParameterMap();

    	Iterator<String> it = parameterNames.keySet().iterator();
    	while(it.hasNext()){
    	  String key = it.next();
		    if (!key.equals("idTarea")){
		    	camposFormulario.put(key, (String)parameterNames.get(key)[0]);
		    }else{
		    	idTarea = Long.parseLong((String)parameterNames.get(key)[0]);
		    }
    	}

    	dto = this.rellenaDTO(idTarea,camposFormulario);
		tareaAdapter.saveForm(dto);
		
		TareaExterna tarea = dto.getForm().getTareaExterna();
		tareaAdapter.advance(tarea);
		
		//return JsonViewer.createModelAndViewJson(new ModelMap("data", tarea));
		return createModelAndViewJson(new ModelMap("sucess",true));
	}
	
    @SuppressWarnings("rawtypes")
	private DtoGenericForm rellenaDTO(Long idTarea, Map<String,String> camposFormulario) {
		
		TareaNotificacion tar = proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);				
		GenericForm genericForm = genericFormManager.get(tar.getTareaExterna().getId());
				
		DtoGenericForm dto = new DtoGenericForm();		
		dto.setForm(genericForm);
		String[] valores = new String[genericForm.getItems().size()];
		
		for (int i = 0; i < genericForm.getItems().size(); i++) {
			GenericFormItem gfi = genericForm.getItems().get(i);
			String nombreCampo = gfi.getNombre();
			for(Iterator it = camposFormulario.entrySet().iterator(); it.hasNext();){
				Map.Entry e = (Map.Entry)it.next();
				if(nombreCampo.equals(e.getKey())){
					String valorCampo = (String) e.getValue();
					if(valorCampo != null && !valorCampo.isEmpty() && nombreCampo.toUpperCase().contains("FECHA")){
						valorCampo = valorCampo.substring(6,10) + "-" + valorCampo.substring(3,5) + "-" + valorCampo.substring(0,2);
					}
					valores[i]= valorCampo;
					break;
				}
			}
		}
		
		dto.setValues(valores);
		return dto;
	}

}

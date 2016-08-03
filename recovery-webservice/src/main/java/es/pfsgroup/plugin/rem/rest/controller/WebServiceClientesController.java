package es.pfsgroup.plugin.rem.rest.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomBooleanEditor;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.framework.paradise.utils.ParadiseCustomDateEditor;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;



@Controller
public class WebServiceClientesController {

	@Autowired
	private ActivoAdapter adapter;
	

	
	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getListaActivos(ModelMap model){
		
		DtoActivoFilter dto= new DtoActivoFilter();
		dto.setNumActivo("22");
		
		Page page = adapter.getActivos(dto);
		
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());
		model.put("success", true);
		
		return createModelAndViewJson(model);
	}
	
	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivosWebService(HttpServletRequest request, DtoActivoFilter dtoActivoFiltro,
			ModelMap model) {
		    
		try {

			if (dtoActivoFiltro.getSort() != null){
				if (dtoActivoFiltro.getSort().equals("via")){
					dtoActivoFiltro.setSort("tipoViaCodigo, nombreVia, numActivo");
				}
				else{
					dtoActivoFiltro.setSort(dtoActivoFiltro.getSort()+",numActivo");	
				}
			}
			Page page = adapter.getActivos(dtoActivoFiltro);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getClientesJSONWebService(HttpServletRequest request, DtoWebServiceCliente dtoWebServiceCliente,
			ModelMap model) {
		
//Lo primero es obtener el texto que manda en el body como Content-Type: application/json		
//Desde aqui		
		StringBuffer jb = new StringBuffer();
		  String line = null;
		  try {
		    BufferedReader reader = request.getReader();
		    while ((line = reader.readLine()) != null)
		      jb.append(line);
		  } catch (Exception e) { /*report an error*/ }
//hasta aqui 
		 
		    JSONObject jsonObject = JSONObject.fromObject(jb.toString()); //Convierte este texto a un JSONObject para poder conseguir cada parametro
		    String idPeticion= jsonObject.getString("id"); //aqui obtener el primer parametro que es el id de la transaccion
		    JSONArray jsData= (JSONArray) jsonObject.get("data"); //Aqui obtenemos el parametro data, este parametro segun el documento es un array
		    List<JSONObject> listaClientesJson= new ArrayList<JSONObject>(); //creamos una lista de objetos JSON a la cual iremos añadiendo cada objeto del array anterior, es decir añadiremos un json por cada usuario que se haya pasado
		    
		    for(int i=0;i<jsData.size();i++){
		    	listaClientesJson.add(jsData.getJSONObject(i)); //añadimos todos los usuarios que existan en data
		    }
		    
		    if(listaClientesJson.size()==1){ //vamos a suponer que solo hay un cliente en el json en ese caso parseamos cada campo en el dto de prueba
		    	dtoWebServiceCliente.setIdClienteWebcom(listaClientesJson.get(0).getString("idClienteWebcom"));
		    	dtoWebServiceCliente.setIdClienteRem(listaClientesJson.get(0).getString("idClienteRem"));
		    	dtoWebServiceCliente.setRazonSocial(listaClientesJson.get(0).getString("razonSocial"));
		    	dtoWebServiceCliente.setNombre(listaClientesJson.get(0).getString("nombre"));
		    	dtoWebServiceCliente.setApellidos(listaClientesJson.get(0).getString("apellidos"));
		    	
		    }
		    
		    
		    
		    //si debugeamos podremos ver como el dto tiene todos los datos metidos. ahora faltaria la logica de saber si existe o no, crearlo, modificarlo....
		    
		    
		try {
			
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	
	
	
}

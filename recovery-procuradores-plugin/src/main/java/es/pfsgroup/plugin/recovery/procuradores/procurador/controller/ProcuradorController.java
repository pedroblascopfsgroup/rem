package es.pfsgroup.plugin.recovery.procuradores.procurador.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.procurador.api.ProcuradorApi;
import es.pfsgroup.plugin.recovery.procuradores.procurador.api.RelacionProcuradorProcedimientoApi;
import es.pfsgroup.plugin.recovery.procuradores.procurador.api.RelacionProcuradorSociedadProcuradoresApi;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dao.ProcuradorDao;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.ProcuradorDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.RelacionProcuradorProcedimientoDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorSociedadProcuradores;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.api.SociedadProcuradoresApi;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dto.SociedadProcuradoresDto;

/**
 * @author carlos gil
 *
 * Controlador encargado de atender las peticiones del plugin de procuradores. 
 */
@Controller
public class ProcuradorController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private ProcuradorDao procuradorDao;
	
	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	public static final String JSON_LISTA_PROCURADORES_JSON = "plugin/procuradores/procurador/procuradoresJSON";
	public static final String JSON_LISTA_SOCIEDADES_PROCURADORES_JSON = "plugin/procuradores/procurador/sociedadesProcuradoresJSON";
	public static final String JSON_LISTA_PROCURADORES_RELACION_SOCIEDAD_PROCURADOR_JSON = "plugin/procuradores/procurador/procuradoresDeLaSociedadJSON";
	
	/**
	 * Devuelve un JSON con el resultado de la búsqueda de {@link Categoria}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaProcuradores(ProcuradorDto dto, ModelMap map, WebRequest request){
		
		dto.setNombre(request.getParameter("query"));
		
		Page p = proxyFactory.proxy(ProcuradorApi.class).getListaProcuradores(dto);
		map.put("pagina", p);
		return JSON_LISTA_PROCURADORES_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaProcuradoresDeLaSociedad(ProcuradorDto dto, ModelMap map, WebRequest request){
		
		//dto.setSociedad(proxyFactory.proxy(SociedadProcuradoresApi.class).getSociedadProcuradores(Long.parseLong(request.getParameter("codigo"))));
		

		
		if(request.getParameter("codigo")!=null && !request.getParameter("codigo").equals("") && !request.getParameter("codigo").equals("0")){
			
			///Se selecciona una sociedad de procuradores
			
			List<RelacionProcuradorSociedadProcuradores> l = proxyFactory.proxy(RelacionProcuradorSociedadProcuradoresApi.class).getRelacionProcuradorSociedadProcuradoresDeLaSociedad(Long.parseLong(request.getParameter("codigo")),request.getParameter("query"));
			map.put("procuradores", l);
			map.put("size", l.size());
			return JSON_LISTA_PROCURADORES_RELACION_SOCIEDAD_PROCURADOR_JSON;
			
		}else{
			
			////No se selcciona una sociedad
			
			if(request.getParameter("procurador")!=null && !request.getParameter("procurador").equals("")){
				
				///Para la carga inicial del procurador
				RelacionProcuradorSociedadProcuradores rel = new RelacionProcuradorSociedadProcuradores();
				rel.setProcurador(proxyFactory.proxy(ProcuradorApi.class).getProcurador(Long.parseLong(request.getParameter("procurador"))));
				List<RelacionProcuradorSociedadProcuradores> l = new  ArrayList<RelacionProcuradorSociedadProcuradores>();
				l.add(rel);
				map.put("procuradores", l);
				map.put("size", l.size());
				
				return JSON_LISTA_PROCURADORES_RELACION_SOCIEDAD_PROCURADOR_JSON;
				
			}else{
				///Busqueda de un procurador sin seleccionar una sociedad
				dto.setNombre(request.getParameter("query"));
				Page p = proxyFactory.proxy(ProcuradorApi.class).getListaProcuradores(dto);
				map.put("pagina", p);
				return JSON_LISTA_PROCURADORES_JSON;
			}
			
		}
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListaSociedadesProcuradores(SociedadProcuradoresDto dto, ModelMap map, WebRequest request){
		
		dto.setNombre(request.getParameter("query"));
		
		Page p = proxyFactory.proxy(SociedadProcuradoresApi.class).getListaSociedadesProcuradores(dto);
		map.put("pagina", p);
		return JSON_LISTA_SOCIEDADES_PROCURADORES_JSON;
	}
	
	
	@RequestMapping
	public String saveDatosProcedimiento(WebRequest request){
		
		///Guardamos el procedimiento
		proxyFactory.proxy(ProcuradorApi.class).saveProcedimientoProcurador(request);
		
		///Guardamos relacion procedimiento - procurador
		Procedimiento procedimiento = null;
		Procurador procurador = null;
		
		if(request.getParameter("id")!= null && !request.getParameter("id").equals("") && request.getParameter("procuradorJuzgado")!= null && !request.getParameter("procuradorJuzgado").equals("")){ 
			procedimiento = procedimientoDao.get(Long.parseLong(request.getParameter("id")));
			procurador = procuradorDao.get(Long.parseLong(request.getParameter("procuradorJuzgado")));
			RelacionProcuradorProcedimientoDto dto = new RelacionProcuradorProcedimientoDto();
			dto.setProcedimiento(procedimiento);
			dto.setProcurador(procurador);
			
			proxyFactory.proxy(RelacionProcuradorProcedimientoApi.class).guardarRelacionProcuradorProcedimiento(dto);
		}
		
		return "default";
	}
	

}

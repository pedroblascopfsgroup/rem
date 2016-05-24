package es.pfsgroup.plugin.recovery.procuradores.configuracion.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.dto.ConfiguracionDespachoExternoDto;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.model.ConfiguracionDespachoExterno;


/**
 * Controlador de las pantallas relativas a las {@link ConfiguracionDespachoExterno}
 * @author anahuac
 *
 */
@Controller
public class ConfiguracionDespachoExternoController {

	public static final String JSON_CONFIGURACION_DESPACHO_EXTERNO_JSON  = "plugin/procuradores/configuracion/configuracionDespachoExternoJSON";


	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ConfiguracionDespachoExternoApi configuracionDespachoExternoApi;
	
	
	
	
	
	
	/**
	 * Obtiene una {@link ConfiguracionDespachoExterno} por idDespacho.
	 * @param request
	 * @param model
	 * @return json con la {@link ConfiguracionDespachoExterno}.
	 */
	@RequestMapping
	public String getConfiguracionDespachoExterno(WebRequest request, ModelMap model) {
		
		if (!Checks.esNulo(request.getParameter("idDespacho"))) {		
			Long idDespacho = Long.valueOf(request.getParameter("idDespacho"));		
			model.put("ConfiguracionDespachoExterno", configuracionDespachoExternoApi.getConfiguracion(idDespacho));		
		}		
		return JSON_CONFIGURACION_DESPACHO_EXTERNO_JSON;
	}
	
	
	/**
	 * Obtiene una {@link ConfiguracionDespachoExterno} por idUsuario.
	 * @param idUsuario
	 * @param model
	 * @return json con la {@link ConfiguracionDespachoExterno}.
	 */
	@RequestMapping
	public String getConfiguracionDespachoExternoDelUsuario(Long idUsuario, ModelMap map) {
		
		if (!Checks.esNulo(idUsuario)){
			List<GestorDespacho> gestorDespacho = configuracionDespachoExternoApi.buscaDespachosPorUsuarioYTipo(idUsuario, DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
			
			if((!Checks.esNulo(gestorDespacho) && gestorDespacho.size()>0)){
				DespachoExterno despacho = gestorDespacho.get(0).getDespachoExterno();	
				map.put("ConfiguracionDespachoExterno", configuracionDespachoExternoApi.getConfiguracion(despacho.getId()));
			}			
		}
				
		return JSON_CONFIGURACION_DESPACHO_EXTERNO_JSON;
	}
	
	
	
	
	/**
	 * Guarda los datos de {@link ConfiguracionDespachoExterno}
	 * @param dto dto con los datos de filtado.
	 * @throws Exception 
	 */
	@RequestMapping
	public String guardarConfDespachoExterno(ConfiguracionDespachoExternoDto dto) throws BusinessOperationException{		
		
		configuracionDespachoExternoApi.guardarConfiguracion(dto);
		return JSON_CONFIGURACION_DESPACHO_EXTERNO_JSON;
	}
	
		
	
	
}

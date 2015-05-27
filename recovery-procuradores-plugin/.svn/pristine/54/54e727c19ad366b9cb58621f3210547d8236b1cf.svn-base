package es.pfsgroup.plugin.recovery.procuradores.procedimientos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.procurador.api.ProcuradorApi;
import es.pfsgroup.plugin.recovery.procuradores.procurador.api.RelacionProcuradorProcedimientoApi;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.ProcuradorDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;

/**
 * @author carlos gil
 *
 * Controlador encargado de atender las peticiones del plugin de procuradores. 
 */
@Controller
public class ProcedimientoProcuradorController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	public static final String VISTA_EDIT_PROCEDIMIENTO_PROCURADOR = "plugin/procuradores/procurador/editaCabeceraProcedimiento";
	
	/**
	 * Devuelve una vista {@link Categoria}
	 * @param dto dto con la información de filtrado
	 * @param map 
	 * @return JSON con el resultado de la búsqueda
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String open (@RequestParam(value = "id", required = true) Long id, ModelMap map){
		Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(id);
		map.put("procedimiento", procedimiento);
		
		List<DDTipoReclamacion> tiposReclamacion = proxyFactory.proxy(ProcedimientoApi.class).getTiposReclamacion();
		map.put("tiposReclamacion", tiposReclamacion);
		
		Procurador procurador = proxyFactory.proxy(RelacionProcuradorProcedimientoApi.class).getProcurador(id);
		if(procurador == null){
			procurador = new Procurador();
			procurador.setId(null);
			procurador.setNombre("");
		}else{
			ProcuradorDto dto = new ProcuradorDto();
			dto.setId(procurador.getId());
			dto.setNombre(procurador.getNombre());
			map.put("posListProcuradores", proxyFactory.proxy(ProcuradorApi.class).getProcuradorPorCodigo(dto));
		}
		
		map.put("procuradorDelProcedimiento", procurador);
		

		
		
		
		/*
		List<TipoPlaza> plazas = proxyFactory.proxy(PlazaJuzgadoApi.class).listaPlazas();
		map.put("plazas",plazas);*/
		
		/*List<Procurador> procuradores = proxyFactory.proxy(ProcuradorApi.class).getListaProcuradores();
		map.put("procuradoresJuzgado",procuradores);*/
		
		return VISTA_EDIT_PROCEDIMIENTO_PROCURADOR;
		
	}
	

}

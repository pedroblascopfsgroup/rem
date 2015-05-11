package es.pfsgroup.plugin.recovery.mejoras.procedimiento.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.plazaJuzgado.BuscaPlazaPaginadoDtoInfo;
import es.capgemini.pfs.core.api.plazaJuzgado.PlazaJuzgadoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.procedimiento.ActualizarProcedimientoDtoInfo;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;

@Controller
public class EditProcedimientoController {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@RequestMapping
	public String open (@RequestParam(value = "id", required = true) Long id, ModelMap map){
		Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(id);
		map.put("procedimiento", procedimiento);
		
		List<DDTipoReclamacion> tiposReclamacion = proxyFactory.proxy(ProcedimientoApi.class).getTiposReclamacion();
		map.put("tiposReclamacion", tiposReclamacion);
		
		List<TipoPlaza> plazas = proxyFactory.proxy(PlazaJuzgadoApi.class).listaPlazas();
		map.put("plazas",plazas);
		
		return "plugin/mejoras/procedimientos/formulario/editaCabeceraProcedimiento";
		
	}
	
	@RequestMapping
	public String saveDatosProcedimiento(WebRequest request){
		ActualizarProcedimientoDtoInfo dto = creaDTOParaActualizar(request);
		
		proxyFactory.proxy(ProcedimientoApi.class).actualizaProcedimiento(dto);
		
		return "default";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String plazasPorDescripcion(final WebRequest request, ModelMap map){
		//BuscaPlazaPaginadoDto dto = new DynamicDTO<BuscaPlazaPaginadoDto>(BuscaPlazaPaginadoDto.class).create(request);
		//BuscaPlazaPaginadoDto dto = new BuscaPlazaPaginadoDtoImpl(request);
//		HashMap<String,Object> params = new HashMap<String, Object>();
//		params.put("start", request.getParameter("start"));
//		params.put("limit", request.getParameter("limit"));
//		params.put("sort", request.getParameter("sort"));
//		params.put("dir", request.getParameter("dir"));
//		params.put("query", request.getParameter("query"));
		
		BuscaPlazaPaginadoDtoInfo dto = DynamicDtoUtils.create(BuscaPlazaPaginadoDtoInfo.class, request);
		
		Page plazas = proxyFactory.proxy(PlazaJuzgadoApi.class).buscarPorDescripcion(dto);
		map.put("pagina", plazas);
		
		return "plugin/coreextension/tipoPlaza/listadoPlazasJSON";
	}
	
	@RequestMapping
	public String buscarJuzgadosPlaza(@RequestParam(value = "codigo", required = true) String codigo, ModelMap map){
		
		List<TipoJuzgado> juzgados = proxyFactory.proxy(PlazaJuzgadoApi.class).buscaJuzgadosPorPlaza(codigo);
		map.put("juzgados", juzgados);
		
		return "plugin/coreextension/tipoPlaza/listadoJuzgadosPlazaJSON";
	}
	
	@RequestMapping
	public String buscarJuzgadosPlazaPorId(@RequestParam(value = "codigo", required = true) Long codigo, ModelMap map){
		
		List<TipoJuzgado> juzgados = proxyFactory.proxy(PlazaJuzgadoApi.class).buscaJuzgadosPorIdPlaza(codigo);
		map.put("juzgados", juzgados);
		
		return "plugin/coreextension/tipoPlaza/listadoJuzgadosPlazaJSON";
	}

	@RequestMapping
	public String buscaPlazasPorCod(@RequestParam(value = "codigo", required = true) String codigo, ModelMap map){
		
		Integer pagina = proxyFactory.proxy(PlazaJuzgadoApi.class).buscarPorCodigo(codigo);
		map.put("paginaParaPlaza", pagina);
		
		return "plugin/coreextension/tipoPlaza/listadoPaginaPlazaJSON";
	}
	
	
	private ActualizarProcedimientoDtoInfo creaDTOParaActualizar(
			final WebRequest request) {
		return DynamicDtoUtils.create(ActualizarProcedimientoDtoInfo.class, request);
	}
	
	
	
}

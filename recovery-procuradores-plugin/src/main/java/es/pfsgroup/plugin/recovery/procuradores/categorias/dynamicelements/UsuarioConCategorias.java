package es.pfsgroup.plugin.recovery.procuradores.categorias.dynamicelements;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategoriaDto;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi;
import es.pfsgroup.plugins.web.menu.DynamicElementLogic;

public class UsuarioConCategorias implements DynamicElementLogic {

	@Autowired
	private UsuarioApi usuarioApi;

	@Autowired
	private CategoriaApi categoriaApi;

	@Autowired
	private ConfiguracionDespachoExternoApi configuracionDespachoExternoApi;

	@Override
	public Boolean validar() { 
		CategoriaDto dto = new CategoriaDto();
		dto.setLimit(1);
		dto.setStart(0);
		dto.setIdcategorizacion(Long.valueOf(-1));

		Long categorizacionActivaDelUser = configuracionDespachoExternoApi.activoCategorizacion();
		if(categorizacionActivaDelUser != null){
			dto.setIdcategorizacion(categorizacionActivaDelUser);
		}

		Page pageCategorias = categoriaApi.getListaCategorias(dto);

		return (pageCategorias != null && pageCategorias.getResults() != null &&  pageCategorias.getResults().size() > 0);
	}

}

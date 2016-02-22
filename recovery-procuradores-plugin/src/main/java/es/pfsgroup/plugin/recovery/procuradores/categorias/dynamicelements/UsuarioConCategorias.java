package es.pfsgroup.plugin.recovery.procuradores.categorias.dynamicelements;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugins.web.menu.DynamicElementLogic;

public class UsuarioConCategorias implements DynamicElementLogic {

	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private CategoriaApi categoriaApi;
	
	@Override
	public Boolean validar() { 
		
		Usuario u = usuarioApi.getUsuarioLogado();
		List<Categoria> lista = categoriaApi.getListaTotalCategorias(u.getId());
		
		return (lista != null && lista.size() > 0);
	}

}

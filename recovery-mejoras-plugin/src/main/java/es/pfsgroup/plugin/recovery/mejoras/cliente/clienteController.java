package es.pfsgroup.plugin.recovery.mejoras.cliente;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.persona.model.DDSituacConcursal;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Controller
public class clienteController {
	
	private static final String tipoConcursoJSON = "plugin/mejoras/clientes/tipoConcursoJSON";

	@Autowired
	ApiProxyFactory proxyFactory;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoConcursoData(ModelMap map){
		
		List<DDSituacConcursal> listadoConcursos = proxyFactory.proxy(MEJClienteApi.class).getListTipoConcursoData();
		map.put("listadoConcursos", listadoConcursos);
		return tipoConcursoJSON;
	}
}

package es.pfsgroup.plugin.recovery.config.despachoExterno.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.config.despachoExterno.ADMDespachoExternoManager;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoExternoDao;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMUsuarioDao;
import es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao;

@Controller
public class ADMDespachoExternoController {
	
	static final String JSON_LISTADO_USUARIOS = "plugin/config/despachoExterno/listadoGestoresJSON";
	static final String JSON_LISTADO_DESPACHOS = "plugin/config/despachoExterno/listadoDespachosSinAsociarJSON";
	private static final String DEFAULT = "default";

    @Autowired
    private ADMUsuarioDao admUsuarioDao;
    
    @Autowired
    private GenericABMDao genericDao;
    
	@Autowired
	private EXTGestoresDao extGestoresDao;
	
	@Autowired
	private GestorDespachoDao gestorDao;
	
	@Autowired
	private ADMDespachoExternoManager despachoManager;
	
	@Autowired
	private DespachoExternoDao despachoDao;
	
	@Autowired
	private ADMDespachoExternoDao admDespachoDao;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getUsuariosInstant(Integer idDespacho, String query, ModelMap model) {

		List<Usuario> listaUsuarios = admUsuarioDao.getListByExternosAndNombre(query);
		List<Usuario> listaUsuariosExistentes = extGestoresDao.getGestoresByDespacho(idDespacho);
		
		listaUsuarios.removeAll(listaUsuariosExistentes);
		model.put("listaGestoresExternos", listaUsuarios);
		
		return JSON_LISTADO_USUARIOS;
	}
	
	@RequestMapping
	public String guardarGestores(Integer id, String listaUsuariosId, ModelMap model) {
		String[] idUsuarios = listaUsuariosId.split(",");
		
		for(int i = 0; i < idUsuarios.length;i++) {
			despachoManager.guardarGestorDespacho(this.rellenarGestor(Long.parseLong(id.toString()), Long.parseLong(idUsuarios[i])));
		}
		
		return DEFAULT;
	}
	
	private GestorDespacho rellenarGestor(Long idDespacho, Long idUsuario) {
		GestorDespacho gestor = new GestorDespacho();
		
		gestor.setDespachoExterno(genericDao.get(DespachoExterno.class, genericDao.createFilter(FilterType.EQUALS, "id", idDespacho)));
		gestor.setUsuario(genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", idUsuario)));
		gestor.setGestorPorDefecto(false);
		gestor.setSupervisor(false);
		
		return gestor;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDespachosInstant(String idUsuario, String query, ModelMap model) {
		
		List<DespachoExterno> listaDespachos = admDespachoDao.getListByNombre(query);
		List<DespachoExterno> listaDespachosAsociados = despachoDao.getDespachosAsociadosAlUsuario(Long.parseLong(idUsuario));
		
		//Borramos los ya existentes
		listaDespachos.removeAll(listaDespachosAsociados);
		model.put("listaDespachos", listaDespachos);
		
		return JSON_LISTADO_DESPACHOS;
	}

	@RequestMapping
	public String guardaDespachoAsociados(Integer id, String listadoDespachosId, ModelMap model) {
		if(!Checks.esNulo(id) && !Checks.esNulo(listadoDespachosId)) {
			String[] arrayDespachos = listadoDespachosId.split(",");
			for(int i = 0; i< arrayDespachos.length; i++) {
				despachoManager.guardarGestorDespacho(this.rellenarGestor(Long.parseLong(arrayDespachos[i]), Long.parseLong(id.toString())));
			}
		}
		
		return DEFAULT;
	}	
}

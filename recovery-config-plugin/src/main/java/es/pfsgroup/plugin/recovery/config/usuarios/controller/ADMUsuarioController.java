package es.pfsgroup.plugin.recovery.config.usuarios.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.dao.ZonaDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.config.despachoExterno.ADMDespachoExternoManager;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMUsuarioDao;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao;

@Controller
public class ADMUsuarioController {
	
	static final String JSON_LISTADO_ZONAS = "plugin/config/usuarios/listadoZonasJSON";
	
	private static final String DEFAULT = "default";

    @Autowired
    private ADMUsuarioDao admUsuarioDao;
    
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ZonaDao zonaDao;
    
    @Autowired
    private Executor executor;
	
	/**
	 * Obtiene la lista de Contratos asociados aun asunto.
	 * 
	 * @param idAsunto
	 *            el id del asunto
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getZonasInstant(Integer idJerarquia, String query, ModelMap model) {
		
		List<DDZona> zonas = new ArrayList<DDZona>();
		if (idJerarquia == null || idJerarquia.longValue() == 0){
			zonas= new ArrayList<DDZona>(); 
		}else{
			 Set<String> codigoZonasUsuario = ((Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)).getCodigoZonas();
			    zonas= zonaDao.getZonasJerarquiaByCodDesc(idJerarquia, codigoZonasUsuario, query);
		} 
		model.put("zonas", zonas);
		return JSON_LISTADO_ZONAS;
	}
	
}

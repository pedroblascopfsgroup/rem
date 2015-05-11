package es.pfsgroup.plugin.recovery.mejoras.comite.manager;

import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.mejoras.comite.dao.MEJComiteDao;
import es.pfsgroup.plugin.recovery.mejoras.comite.dto.MEJDtoBusquedaPreAsuntosComite;
import es.pfsgroup.plugin.recovery.mejoras.comite.dto.MEJDtoSesionComite;
import es.pfsgroup.plugin.recovery.mejoras.comite.model.MEJComite;

@Service
public class MEJComiteManager {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private MEJComiteDao mejComiteDao;

	
	
	@BusinessOperation(overrides = "comiteManager.findComitesCurrentUser")
    public Set<MEJDtoSesionComite> findComitesCurrentUser() {
		
//        
//		System.out.println("Hacemos flush");
//		mejComiteDao.flush();
//		System.out.println("Hacemos clear");
//		mejComiteDao.clear();
		
		Set<MEJDtoSesionComite> dtoComites = new TreeSet<MEJDtoSesionComite>();

        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        List<MEJComite> list = mejComiteDao.findComitesValidosCurrentUser(usuario);
        for (MEJComite c : list) {
        	MEJDtoSesionComite dto = new MEJDtoSesionComite();
            dto.setComite(c);
            dtoComites.add(dto);
        }
       
        return dtoComites;
    }
	
	@BusinessOperation(value="comiteManager.getPreAsuntosComite")
	public Page getPreasuntosComite(MEJDtoBusquedaPreAsuntosComite dto){
		
		
		return  mejComiteDao.getPreAsuntosComite(dto);
	}
	
	
	
}

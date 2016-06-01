package es.pfsgroup.plugin.recovery.config.despachoExterno;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMTipoDespachoExternoDao;

@Service("admTipoDespachoExternoManager")
public class ADMTipoDespachoExternoManager {
	
	@Autowired
	private ADMTipoDespachoExternoDao tipoDespachoDao;
	
	@Autowired
	private UsuarioManager usuarioManager;

	public ADMTipoDespachoExternoManager(){}
	
	public ADMTipoDespachoExternoManager(ADMTipoDespachoExternoDao dao) {
		tipoDespachoDao = dao;
	}

	
	@BusinessOperation("admTipoDespachoExternoManager.getList")
	public List<DDTipoDespachoExterno> getList() {
		String codEntidad = usuarioManager.getUsuarioLogado().getEntidad().getCodigo();
		//Se condiciona, ya que en multientidad muestra los despachos de las dos entidades, y de esta forma filtramos ese problema
		if(codEntidad.equals("HCJ") || codEntidad.equals("HAYA")) {
			return tipoDespachoDao.getListTipoDespachoByEntidad();
		}
		else {
			return tipoDespachoDao.getList();
		}
	}

}

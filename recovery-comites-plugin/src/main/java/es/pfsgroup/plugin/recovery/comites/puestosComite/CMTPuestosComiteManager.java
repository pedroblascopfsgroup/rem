package es.pfsgroup.plugin.recovery.comites.puestosComite;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comite.model.PuestosComite;
import es.pfsgroup.plugin.recovery.comites.PluginComitesBusinessOperations;
import es.pfsgroup.plugin.recovery.comites.comite.dao.CMTComiteDao;
import es.pfsgroup.plugin.recovery.comites.comite.dao.CMTComiteOriginalDao;
import es.pfsgroup.plugin.recovery.comites.perfil.dao.CMTPerfilDao;
import es.pfsgroup.plugin.recovery.comites.puestosComite.dao.CMTPuestosComiteDao;
import es.pfsgroup.plugin.recovery.comites.puestosComite.dto.CMTDtoAltaPuestosComite;
import es.pfsgroup.plugin.recovery.comites.zona.dao.CMTZonaDao;

@Service("CMTPuestosComiteManager")
public class CMTPuestosComiteManager {
	
	@Autowired
	CMTPuestosComiteDao puestosComiteDao;
	
	@Autowired
	CMTComiteDao comiteDao;
	
	@Autowired
	CMTPerfilDao perfilDao;
	
	@Autowired
	CMTComiteOriginalDao comiteOriginalDao;
	
	@Autowired
	CMTZonaDao zonaDao;
	
	@BusinessOperation(PluginComitesBusinessOperations.PTC_MGR_GETPUESTOSCOMITE)
	public List<PuestosComite> getPuestosComite(Long idComite){
		return puestosComiteDao.getPuestosComite(idComite);
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginComitesBusinessOperations.PTC_MGR_GUARDAPUESTOCOMITE)
	public void guardaPuestoComite(CMTDtoAltaPuestosComite dto){
		PuestosComite puesto;
		if(dto.getId()==null){
			puesto=puestosComiteDao.createNewPuestoComite();
			puesto.setComite(comiteOriginalDao.get(dto.getComite()));
		}else{
			puesto=puestosComiteDao.get(dto.getId());
		}
		puesto.setPerfil(perfilDao.get(dto.getPerfil()));
		puesto.setEsRestrictivo(dto.getEsRestrictivo());
		puesto.setEsSupervisor(dto.getEsSupervisor());
		puesto.setZona(zonaDao.get(dto.getZona()));
		puestosComiteDao.saveOrUpdate(puesto);
	}
	
	@BusinessOperation(PluginComitesBusinessOperations.PTC_MGR_GET)
	public PuestosComite getPuesto(Long id){
		return puestosComiteDao.get(id);
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginComitesBusinessOperations.PTC_MGR_BORRARPUESTO)
	public void borrarPuesto(Long id){
		if (id==null){
			throw new IllegalArgumentException("Valor no válido");
		}
		if (puestosComiteDao.get(id)== null){
			throw new BusinessOperationException("No existe el puesto de comité");
		}
		puestosComiteDao.deleteById(id);
	}

}

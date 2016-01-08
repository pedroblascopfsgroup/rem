package es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.ReglasVigenciaPolitica;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglaVigenciaPolitica.dao.ITIDDTipoReglaVigenciaPoliticaDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglaVigenciaPolitica.model.ITIDDTipoReglaVigenciaPolitica;
import es.pfsgroup.plugin.recovery.itinerarios.estado.dao.ITIEstadoDao;
import es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dao.ITIReglasVigenciaPoliticaDao;
import es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dao.model.ITIReglasVigenciaPolitica;
import es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dto.ITIDtoAltaReglaVigenciaPolitica;

@Service("ITIReglasVigenciaPoliticaManager")
public class ITIReglasVigenciaPoliticaManager {
	
	@Autowired
	ITIEstadoDao estadoDao;
	
	@Autowired
	ITIReglasVigenciaPoliticaDao reglasVigenciaPoliticaDao;
	
	@Autowired
	ITIDDTipoReglaVigenciaPoliticaDao tipoReglaVigenciaPoliticaDao;
	
	
	@BusinessOperation(PluginItinerariosBusinessOperations.RVP_MGR_GETREGLAS)
	public List<ReglasVigenciaPolitica> getReglasItinerario(Long id){
		List<Estado> estadosItinerario = estadoDao.getEstadosItienario(id);
		return reglasVigenciaPoliticaDao.findByEstado(estadosItinerario);
		
	}

	@BusinessOperation(PluginItinerariosBusinessOperations.RVP_MGR_GETREGLASCONSENSOESTADO)
	public ITIReglasVigenciaPolitica getReglasConsensoEstado(Long id) {
		return reglasVigenciaPoliticaDao.getReglasConsensoEstado(id);
	}

	@BusinessOperation(PluginItinerariosBusinessOperations.RVP_MGR_GETREGLASEXCLUSIONESTADO)
	public ITIReglasVigenciaPolitica getReglasExclusionEstado(Long id) {
		return reglasVigenciaPoliticaDao.getReglasExclusionEstado(id);
	}

	
	@BusinessOperation(PluginItinerariosBusinessOperations.RVP_MGR_GETDDREGLASCONSENSO)
	public List<ITIDDTipoReglaVigenciaPolitica> getDDReglasConsenso(){
		return tipoReglaVigenciaPoliticaDao.getReglasConsenso();
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.RVP_MGR_GETDDREGLASCONSENSOCE)
	public List<ITIDDTipoReglaVigenciaPolitica> getDDReglasConsensoCE(){
		return tipoReglaVigenciaPoliticaDao.getReglasConsensoCE();
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.RVP_MGR_GETDDREGLASEXCLUSIONCE)
	public List<ITIDDTipoReglaVigenciaPolitica> getDDReglasExclusionCE(){
		return tipoReglaVigenciaPoliticaDao.getDDReglasExclusionCE();
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.RVP_MGR_GETDDREGLASEXCLUSIONRE)
	public List<ITIDDTipoReglaVigenciaPolitica> getDDReglasExclusionRE(){
		return tipoReglaVigenciaPoliticaDao.getDDReglasExclusionRE();
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.RVP_MGR_SAVE)
	public void guardaRVP(ITIDtoAltaReglaVigenciaPolitica dto){
		ITIReglasVigenciaPolitica reglaVigenciaPolitica;
		if (dto.getId()== null){
			reglaVigenciaPolitica = reglasVigenciaPoliticaDao.createNewReglaVigenciaPolitica();
			reglaVigenciaPolitica.setEstadoItinerario(estadoDao.get(dto.getEstado()));
			if(dto.getTipoReglaVigenciaPolitica()==null){
				throw new IllegalArgumentException(
				"Debe asignar un tipo de regla");
			}else{
				reglaVigenciaPolitica.setTipoReglaVigenciaPolitica(tipoReglaVigenciaPoliticaDao.get(dto.getTipoReglaVigenciaPolitica()));
			}
		}else{
			reglaVigenciaPolitica= reglasVigenciaPoliticaDao.get(dto.getId());
			if(dto.getTipoReglaVigenciaPolitica()!=null){
				reglaVigenciaPolitica.setTipoReglaVigenciaPolitica(tipoReglaVigenciaPoliticaDao.get(dto.getTipoReglaVigenciaPolitica()));
			}else{
				reglasVigenciaPoliticaDao.deleteById(dto.getId());
			}	
		}
		reglasVigenciaPoliticaDao.saveOrUpdate(reglaVigenciaPolitica);
	}
}

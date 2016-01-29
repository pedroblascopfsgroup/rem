package es.pfsgroup.plugin.recovery.comites.comite;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.comites.PluginComitesBusinessOperations;
import es.pfsgroup.plugin.recovery.comites.api.web.DynamicElementApi;
import es.pfsgroup.plugin.recovery.comites.asunto.dao.CMTAsuntoDao;
import es.pfsgroup.plugin.recovery.comites.comite.dao.CMTComiteDao;
import es.pfsgroup.plugin.recovery.comites.comite.dto.CMTDtoAltaComite;
import es.pfsgroup.plugin.recovery.comites.comite.dto.CMTDtoBusquedaComite;
import es.pfsgroup.plugin.recovery.comites.comite.model.CMTComite;
import es.pfsgroup.plugin.recovery.comites.comiti.dao.CMTComItiDao;
import es.pfsgroup.plugin.recovery.comites.comiti.model.CMTComIti;
import es.pfsgroup.plugin.recovery.comites.itinerario.dao.CMTItinerarioDao;
import es.pfsgroup.plugin.recovery.comites.itinerario.dto.CMTDtoItinerario;
import es.pfsgroup.plugin.recovery.comites.zona.dao.CMTZonaDao;

@Service("CMTComiteManager")
public class CMTComiteManager {
	
	@Autowired
	CMTComiteDao comiteDao;
	
	@Autowired
	CMTAsuntoDao asuntoDao;
	
	@Autowired
	CMTZonaDao zonaDao;
	
	@Autowired
	CMTItinerarioDao itinerarioDao;
	
	@Autowired
	CMTComItiDao comItiDao;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	
	@BusinessOperation(PluginComitesBusinessOperations.CMT_MGR_GETCOMITE)
	public CMTComite getComite(Long id){
		EventFactory.onMethodStart(this.getClass());
		return comiteDao.get(id);
	}
	
	@BusinessOperation(PluginComitesBusinessOperations.CMT_MGR_BUSCA)
	public Page buscaComites(CMTDtoBusquedaComite dto){
		EventFactory.onMethodStart(this.getClass());
		return comiteDao.findComites(dto);
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginComitesBusinessOperations.CMT_MGR_BORRA)
	public void borraComite(Long id){
		if (id == null){
			throw new IllegalArgumentException("plugin.comites.comite.borraComite.noValido");
		}
		CMTComite comite= comiteDao.get(id);
		if(comite==null){
			throw new BusinessOperationException("plugin.comites.comite.borraComite.noExiste");
		}
		checkAsuntosComite(id);
		//if (Checks.estaVacio(comite.getAsuntos())){
		//	comiteDao.deleteById(id);
		//}
		List<CMTComIti> listaComIti = comItiDao.getList();
		for (CMTComIti citi : listaComIti){
			if(citi.getComite().getId().equals(id)){
				comItiDao.deleteById(citi.getId());
			}
		}
		comiteDao.deleteById(id);
	}

	private void checkAsuntosComite(Long id) {
		List<Asunto> asuntos = getAsuntos(id);
		if(!Checks.estaVacio(asuntos)){
			throw new BusinessOperationException(
				"plugin.comites.comite.checkasuntoscomite.tieneasuntos");
		}
		
	}

	private List<Asunto> getAsuntos(Long id) {
		List<Asunto> asuntosComite = asuntoDao.getAsuntosComite(id);
		return asuntosComite;
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginComitesBusinessOperations.CMT_MGR_GUARDA)
	public void guardaComite(CMTDtoAltaComite dto){
		CMTComite comite;
		if(dto.getId()==null){
			comite = comiteDao.createNewComite();
		}else{
			comite = comiteDao.get(dto.getId());
		}
		comite.setNombre(dto.getNombre());
		comite.setAtribucionMaxima(dto.getAtribucionMaxima());
		comite.setAtribucionMinima(dto.getAtribucionMinima());
		comite.setPrioridad(dto.getPrioridad());
		comite.setMiembros(dto.getMiembros());
		comite.setMiembrosRestrict(dto.getMiembrosRestrict());
		if (Checks.esNulo(dto.getZona())){
			throw new IllegalArgumentException("Debe zonificaar el comité");
		}
		comite.setZona(zonaDao.get(dto.getZona()));
		comiteDao.saveOrUpdate(comite);
		
	}
	
	@BusinessOperation(PluginComitesBusinessOperations.CMT_MGR_LISTADTOITINERARIO)
	public List<CMTDtoItinerario> listaDtoItinerariosComite(Long idComite){
		List<Itinerario> listaItinerarios = itinerarioDao.getList();
		//List<Itinerario> itinerariosComite = comiteDao.get(idComite).getItinerarios();
		List<CMTComIti> itinerariosComite = comItiDao.getItinerariosComite(idComite);
		List<CMTDtoItinerario> listaDtoItinerarios = new ArrayList<CMTDtoItinerario>();
		for (Itinerario iti: listaItinerarios){
			CMTDtoItinerario dto = new CMTDtoItinerario();
			dto.setIdComite(idComite);
			dto.setIdItinerario(iti.getId());
			dto.setItinerario(iti.getNombre());
			dto.setTipoItinerario(iti.getdDtipoItinerario().getDescripcion());
			CMTComIti comiti= comItiDao.find(idComite, iti.getId());
			if (itinerariosComite.contains(comiti)){
				dto.setCompatible(true);
			}else{
				dto.setCompatible(false);
			}
			listaDtoItinerarios.add(dto);	
		}
		return listaDtoItinerarios;
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginComitesBusinessOperations.CMT_MGR_GUARDAITINERARIOS)
	public void guardaItinerarios(List<CMTDtoItinerario> dtoItinerarios){
		
		//CMTComite comite= comiteDao.get(dtoItinerarios.get(1).getIdComite());
		//List<Itinerario> itinerariosComite = comite.getItinerarios();
		for(CMTDtoItinerario dtoItinerario : dtoItinerarios){
			CMTComIti comIti;
			Itinerario itinerario = itinerarioDao.get(dtoItinerario.getIdItinerario());
			CMTComite comite = comiteDao.get(dtoItinerario.getIdComite());
			List<CMTComIti> itinerariosComite = comItiDao.getItinerariosComite(dtoItinerario.getIdComite());
			CMTComIti comiti= comItiDao.find(dtoItinerario.getIdComite(), dtoItinerario.getIdItinerario());
			if (itinerariosComite.contains(comiti)){
				if (!dtoItinerario.getCompatible()){
					comItiDao.deleteById(comiti.getId());
				}
			}else{
				if(dtoItinerario.getCompatible()){
					comIti = new CMTComIti();
					comIti.setComite(comite);
					comIti.setItinerario(itinerario);
					comItiDao.saveOrUpdate(comIti);
				}
			}	
		}
	}
	
	@BusinessOperation("plugin.comites.web.buttons.left")
	List<DynamicElement> getButtonConfiguracionComitesLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.comites.web.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.comites.web.buttons.right")
	List<DynamicElement> getButtonsConfiguracionComitesRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.comites.web.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

}

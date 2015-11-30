package es.pfsgroup.plugin.recovery.itinerarios.itinerario;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.politica.model.DDTipoPolitica;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.api.web.DynamicElementApi;
import es.pfsgroup.plugin.recovery.itinerarios.ddAmbitoExpediente.dao.ITIDDAmbitoExpedienteDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoItinerario.dao.ITIDDTipoItinerarioDao;
import es.pfsgroup.plugin.recovery.itinerarios.estado.dao.ITIEstadoDao;
import es.pfsgroup.plugin.recovery.itinerarios.itinerario.dao.ITIItinerarioDao;
import es.pfsgroup.plugin.recovery.itinerarios.itinerario.dto.ITIDtoAltaItinerario;
import es.pfsgroup.plugin.recovery.itinerarios.itinerario.dto.ITIDtoBusquedaItinerarios;

@Service ("ITIItinerarioManager")
public class ITIItinerarioManager {
	
	@Autowired
	ITIItinerarioDao itinerarioDao;
	
	@Autowired
	ITIDDTipoItinerarioDao tipoItinerarioDao;
	
	@Autowired
	ITIDDAmbitoExpedienteDao ambitoExpedienteDao;
	
	@Autowired
	ITIEstadoDao estadoDao;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.ITI_MGR_BUSCA)
	public Page buscaItinerarios(ITIDtoBusquedaItinerarios dto){
		EventFactory.onMethodStart(this.getClass());
		return itinerarioDao.buscaItinerarios(dto);
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.ITI_MGR_GUARDA)
	public void guardaItinerario (ITIDtoAltaItinerario dto){
		Itinerario itinerario;
		if (dto.getId()==null){
			throw new IllegalArgumentException(
				"Para crear un nuevo itinerario se tendr� que hacer como copia de uno ya existente");
		}
		else{
			itinerario = itinerarioDao.get(dto.getId());
			itinerario.setNombre(dto.getNombre());
			itinerario.setdDtipoItinerario(tipoItinerarioDao.get(dto.getdDtipoItinerario()));
			
			if(dto.getAmbitoExpediente()!= null){
				itinerario.setAmbitoExpediente(ambitoExpedienteDao.get(dto.getAmbitoExpediente()));
			}
//			else{
//				itinerario.setAmbitoExpediente(null);
//			}
			
			if(dto.getPrePolitica()!=null){
				itinerario.setPrePolitica(genericDao.get(DDTipoPolitica.class, genericDao.createFilter(FilterType.EQUALS, "id",dto.getPrePolitica())));
			}
			else{
				itinerario.setPrePolitica(null);
			}
				
			
			itinerarioDao.saveOrUpdate(itinerario);
		}
	}
	
	
	/**
	 * @param id del itinerario que se desea eliminar
	 * elimana el itinerario cuyo id coincide con el que se le pasa como par�metro
	 * 
	 */
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.ITI_MGR_BORRA)
	public void borraItinerario(Long id){
		if(id == null){
			throw new IllegalArgumentException(
					"El argumento de entrada no es valido");
		}
		if(itinerarioDao.get(id)==null){
			throw new BusinessOperationException(
					"El arquetipo que desea eliminar no existe");
		}
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		for (Estado est : estadosIti){
			estadoDao.deleteById(est.getId());
		}
		itinerarioDao.deleteById(id);
			
	}
	
	/**
	 * @param id
	 * Devuelve el objeto de tipo Itinerario cuyo id coincide con el que se le pasa como par�metro
	 */
	@BusinessOperation(PluginItinerariosBusinessOperations.ITI_MGR_GET)
	public Itinerario getItinerario(Long id){
		EventFactory.onMethodStart(this.getClass());
		return itinerarioDao.get(id); 
	}
	
	/**
	 * @param id
	 * Crea una copia del itinerario cuyo id coincide con el que se le pasa como par�metro
	 * Crear� una copia tanto de sus datos como de lo sus estados
	 */
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.ITI_MGR_COPIA)
	public void copiaItinerario(Long id){
		Itinerario original = itinerarioDao.get(id);
		
		Itinerario copia = itinerarioDao.createNewItinerario();
		copia.setNombre(original.getNombre()+"_copia");
		copia.setAmbitoExpediente(original.getAmbitoExpediente());
		copia.setdDtipoItinerario(original.getdDtipoItinerario());
		// PRODUCTO-65: cuando creamos la copia del itinerario, a�adimos que se copie tambi�n la prepol�tica
		copia.setPrePolitica(original.getPrePolitica());
		itinerarioDao.save(copia);
		
		List<Estado> estadosItinerario = estadoDao.getEstadosItienario(id);
		for(Estado e : estadosItinerario){
			Estado est = new Estado();
			est.setEstadoItinerario(e.getEstadoItinerario());
			est.setGestorPerfil(e.getGestorPerfil());
			est.setSupervisor(e.getSupervisor());
			est.setItinerario(copia);
			est.setPlazo(e.getPlazo());
			est.setTelecobro(e.getTelecobro());
			estadoDao.saveOrUpdate(est);
		}
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.ITI_MGR_PUNTO_ENGANCHE_BUTTONS_LEFT)
	List<DynamicElement> getButtonsItinerariosLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.itinerarios.web.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginItinerariosBusinessOperations.ITI_MGR_PUNTO_ENGANCHE_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsItinerariosRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.itinerarios.web.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}


}

package es.pfsgroup.plugin.recovery.itinerarios.ddAmbitoExpediente;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoReglasElevacion;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.ddAmbitoExpediente.dao.ITIDDAmbitoExpedienteDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoItinerario.dao.ITIDDTipoItinerarioDao;

@Service("ITIDDAmbitoExpedienteManager")
public class ITIDDAmbitoExpedienteManager {
	
	@Autowired
	ITIDDAmbitoExpedienteDao ambitoExpedienteDao;
	
	@Autowired
	ITIDDTipoItinerarioDao tipoItinerarioDao;
	
	@Autowired
	GenericABMDao genericDAO;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.AEX_MGR_LISTA)
	public List<DDAmbitoExpediente> listaAmbitoExpediente(){
		return ambitoExpedienteDao.getList();
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.AEX_MGR_LISTASEG)
	public List<DDAmbitoExpediente> listaAmbitosSeguimiento(){
		List<DDAmbitoExpediente> ambitosExpediente = ambitoExpedienteDao.getList();
		List<DDAmbitoExpediente> resultado = new ArrayList<DDAmbitoExpediente>();
		for(DDAmbitoExpediente aex : ambitosExpediente){
			if (aex.getCodigo().equals("PP") || aex.getCodigo().equals("PG") || aex.getCodigo().equals("PPGRA") 
				|| aex.getCodigo().equals("PSGRA") ){
				resultado.add(aex);
			}
		}
		return resultado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.AEX_MGR_LISTAREC)
	public List<DDAmbitoExpediente> listaAmbitosRecuperaciones(){
		List<DDAmbitoExpediente> ambitosExpediente = ambitoExpedienteDao.getList();
		List<DDAmbitoExpediente> resultado = new ArrayList<DDAmbitoExpediente>();
		for(DDAmbitoExpediente aex : ambitosExpediente){
			if (aex.getCodigo().equals("CP") || aex.getCodigo().equals("CG") || aex.getCodigo().equals("CPGRA") 
				|| aex.getCodigo().equals("CSGRA") ){
				resultado.add(aex);
			}
		}
		return resultado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.AEX_MGR_LISTASEGUNTIPOITI)
	public List<DDAmbitoExpediente> listaSegunTipoItinerario(Long id){	
		DDTipoItinerario tipoItinerario= tipoItinerarioDao.get(id);
		List<DDAmbitoExpediente> resultado = new ArrayList<DDAmbitoExpediente>();
		if(tipoItinerario.getCodigo().equals("REC")){
			resultado= this.listaAmbitosRecuperaciones();
			
		}else{
			resultado= this.listaAmbitosSeguimiento();
		}
		return resultado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.AEX_MGR_LISTA_BY_REGLA)
	public List<DDAmbitoExpediente> listaAmbitoExpedienteByRegla(Long idRegla){
		
		DDTipoReglasElevacion tipoRegla; 
		tipoRegla= genericDAO.get(DDTipoReglasElevacion.class, genericDAO.createFilter(FilterType.EQUALS, "id", idRegla ));
		
		if (tipoRegla!= null)
			return tipoRegla.getListAmbitos();
		else
			return null;
		
	}

}

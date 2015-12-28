package es.pfsgroup.plugin.recovery.itinerarios.gestorDespacho;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.gestorDespacho.dao.ITIGestorDespachoDao;
import es.pfsgroup.plugin.recovery.itinerarios.gestorDespacho.dto.ITIDtoGestorAUsuario;

@Service("ITIGestorDespachoManager")
public class ITIGestorDespachoManager {
	
	@Autowired
	ITIGestorDespachoDao gestorDespachoDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.GDP_MGR_GETGESTORES)
	public List<ITIDtoGestorAUsuario> getGestores(){
		List<GestorDespacho> listaGestorDespacho= gestorDespachoDao.getGestores();
		List<ITIDtoGestorAUsuario> usuarios = new ArrayList<ITIDtoGestorAUsuario>();
		for(GestorDespacho gd : listaGestorDespacho){
			ITIDtoGestorAUsuario dto = new ITIDtoGestorAUsuario();
			dto.setId(gd.getId());
			dto.setUsuario(gd.getUsuario().getApellidoNombre());
			usuarios.add(dto);
		}
		return usuarios;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.GDP_MGR_GETSUPERVISORES)
	public List<ITIDtoGestorAUsuario> getSupervisores(){
		 List<GestorDespacho> listaGestorDespacho =gestorDespachoDao.getSupervisores();
		 List<ITIDtoGestorAUsuario> usuarios = new ArrayList<ITIDtoGestorAUsuario>();
			for(GestorDespacho gd : listaGestorDespacho){
				ITIDtoGestorAUsuario dto = new ITIDtoGestorAUsuario();
				dto.setId(gd.getId());
				dto.setUsuario(gd.getUsuario().getApellidoNombre());
				usuarios.add(dto);
			}
			return usuarios;
	}

}

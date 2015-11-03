package es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.itinerario.model.DDTipoReglasElevacion;
import es.capgemini.pfs.itinerario.model.Estado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.ddAmbitoExpediente.dao.ITIDDAmbitoExpedienteDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReglasElevacion.dao.ITIDDTipoReglasElevacionDao;
import es.pfsgroup.plugin.recovery.itinerarios.estado.ITIEstadoManager;
import es.pfsgroup.plugin.recovery.itinerarios.estado.dao.ITIEstadoDao;
import es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.dao.ITIReglasElevacionDao;
import es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.dto.ITIDtoAltaReglaElevacion;
import es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.model.ITIReglasElevacion;

@Service("ITIReglasElevacionManager")
public class ITIReglasElevacionManager {

	@Autowired
	ITIEstadoManager estadoManager;
	
	@Autowired
	ITIDDAmbitoExpedienteDao ambitoExpedienteDao;
	
	@Autowired
	ITIReglasElevacionDao reglasElevacionDao;
	
	@Autowired
	ITIDDTipoReglasElevacionDao ddTipoReglasElevacionDao;
	
	@Autowired
	ITIEstadoDao estadoDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_REGLASELEVACIONITINERARIO_CE)
	public List<ITIReglasElevacion> listaReglasElevacionEstado(Long id){
		EventFactory.onMethodStart(this.getClass());
		Estado estado = estadoManager.dameEstadoCE(id);
		List<ITIReglasElevacion> reglasEstado = null;
		if (!Checks.esNulo(estado)) {
			reglasEstado = reglasElevacionDao.buscaReglasEstado(estado.getId());
		}
		EventFactory.onMethodStop(this.getClass());
		return reglasEstado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_REGLASELVACION_RE)
	public List<ITIReglasElevacion> listaReglasElevacionRE(Long idItinerario){
		Estado estado = estadoManager.dameEstadoRE(idItinerario);
		List<ITIReglasElevacion> reglasRE =null;
		if (!Checks.esNulo(estado)) {
			reglasRE =reglasElevacionDao.buscaReglasEstado(estado.getId());
		}
		return reglasRE;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_REGLASELEVACION_FP)
	public List<ITIReglasElevacion> listaReglasElevacionFP(Long idItinerario){
		Estado estado = estadoManager.dameEstadoFP(idItinerario);
		List<ITIReglasElevacion> reglasFP = null;
		if(!Checks.esNulo(estado)){
			reglasFP = reglasElevacionDao.buscaReglasEstado(estado.getId());
		}
		
		return reglasFP;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_REGLASELEVACION_DC)
	public List<ITIReglasElevacion> listaReglasElevacionDC(Long idItinerario){
		Estado estado = estadoManager.dameEstadoDC(idItinerario);
		List<ITIReglasElevacion> reglasDC = null;
		if (!Checks.esNulo(estado)) {
			reglasDC = reglasElevacionDao.buscaReglasEstado(estado.getId());
		}
		return reglasDC;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_RESTOREGLAS_CE)
	public List<DDTipoReglasElevacion> restoReglasCE(Long idItinerario){
		List<DDTipoReglasElevacion> listaTipoReglas = ddTipoReglasElevacionDao.getList();
		List<ITIReglasElevacion> listaReglasEstado = listaReglasElevacionEstado(idItinerario);
		for(ITIReglasElevacion re: listaReglasEstado){
			if (listaTipoReglas.contains(re.getDdTipoReglasElevacion())){
				listaReglasEstado.remove(re.getDdTipoReglasElevacion());
			}
				
		}
		return listaTipoReglas;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_RESTOREGLAS_FP)
	public List<DDTipoReglasElevacion> restoReglasFP(Long idItinerario){
		List<DDTipoReglasElevacion> listaTipoReglas = ddTipoReglasElevacionDao.getList();
		List<ITIReglasElevacion> listaReglasEstado = listaReglasElevacionEstado(idItinerario);
		for(ITIReglasElevacion re: listaReglasEstado){
			if (listaTipoReglas.contains(re.getDdTipoReglasElevacion())){
				listaReglasEstado.remove(re.getDdTipoReglasElevacion());
			}
				
		}
		return listaTipoReglas;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_RESTOREGLAS_RE)
	public List<DDTipoReglasElevacion> restoReglasRE(Long idItinerario){
		List<DDTipoReglasElevacion> listaTipoReglas = ddTipoReglasElevacionDao.getList();
		List<ITIReglasElevacion> listaReglasEstado = listaReglasElevacionRE(idItinerario);
		for(ITIReglasElevacion re: listaReglasEstado){
			if (listaTipoReglas.contains(re.getDdTipoReglasElevacion())){
				listaReglasEstado.remove(re.getDdTipoReglasElevacion());
			}
				
		}
		return listaTipoReglas;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_RESTOREGLAS_DC)
	public List<DDTipoReglasElevacion> restoReglasDC(Long idItinerario){
		List<DDTipoReglasElevacion> listaTipoReglas = ddTipoReglasElevacionDao.getList();
		List<ITIReglasElevacion> listaReglasEstado = listaReglasElevacionDC(idItinerario);
		for(ITIReglasElevacion re: listaReglasEstado){
			if (listaTipoReglas.contains(re.getDdTipoReglasElevacion())){
				listaReglasEstado.remove(re.getDdTipoReglasElevacion());
			}
				
		}
		return listaTipoReglas;
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_SAVE)
	public void guardaTipoRegla (ITIDtoAltaReglaElevacion dto){
		ITIReglasElevacion regla;
		if(dto.getId()== null){
			boolean existe = reglasElevacionDao.comprobarExisteRegla(dto);
			if (existe == true){
				throw new BusinessOperationException("plugin.itinerarios.reglasElevacion.reglaDuplicada");
			}else{
				regla = reglasElevacionDao.createNewReglasElevacion();
			}
		}else {
			regla= reglasElevacionDao.get(dto.getId());
		}
		DDTipoReglasElevacion tipoRegla = ddTipoReglasElevacionDao.get(dto.getDdTipoReglasElevacion());
		regla.setEstado(estadoDao.get(dto.getEstado()));
		regla.setDdTipoReglasElevacion(tipoRegla);
		if(!tipoRegla.getCodigo().equals("GESTION_ANALISIS") && Checks.esNulo(dto.getAmbitoExpediente())){
			throw new IllegalArgumentException(
					"Debe de seleccionar un �mbito para el expediente");
		}else{
			if (!Checks.esNulo(dto.getAmbitoExpediente())){
				regla.setAmbitoExpediente(ambitoExpedienteDao.get(dto.getAmbitoExpediente()));
		
			}
		}
		reglasElevacionDao.saveOrUpdate(regla);
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.TRE_MGR_REMOVE)
	public void borraReglaElevacion(Long id){
		if(id == null){
			throw new IllegalArgumentException(
					"El argumento de entrada no es valido");
		}
		if(reglasElevacionDao.get(id)==null){
			throw new BusinessOperationException(
					"La regla que desea eliminar no existe");
		}
		reglasElevacionDao.deleteById(id);
	}
}

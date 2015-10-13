package es.pfsgroup.plugin.recovery.itinerarios.estado;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;
import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.estado.dao.ITIEstadoDao;
import es.pfsgroup.plugin.recovery.itinerarios.estado.dto.ITIDtoEstado;
import es.pfsgroup.plugin.recovery.itinerarios.estadoTelecobro.dao.ITIEstadoTelecobroDao;
import es.pfsgroup.plugin.recovery.itinerarios.perfil.dao.ITIPerfilDao;
import es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.ITIReglasVigenciaPoliticaManager;
import es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dao.model.ITIReglasVigenciaPolitica;


@Service("ITIEstadoManager")
public class ITIEstadoManager {
	
	@Autowired
	ITIEstadoDao estadoDao;
	
	@Autowired
	ITIEstadoTelecobroDao estadoTelecobroDao;
	
	
	@Autowired
	ITIPerfilDao perfilDao;
	
	@Autowired
	ITIReglasVigenciaPoliticaManager reglaVigenciaPoliticaManager;
	
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETESTADO)
	public Estado getEstado(Long id){
		return estadoDao.get(id);
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETESTADOSITI)
	public List<Estado> getEstadosItinerario(Long id){
		EventFactory.onMethodStart(this.getClass());
		return estadoDao.getEstadosItienario(id);
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETDTOESTADOSITI)
	public List<ITIDtoEstado> getDtoEstadosItinerario(Long id){
		List<ITIDtoEstado> dtoEstados = new ArrayList<ITIDtoEstado>() ;
		
		List<Estado> listaEstados = estadoDao.getEstadosItienario(id) ;
		for (Estado est : listaEstados){
			ITIDtoEstado dto = new ITIDtoEstado();
			dto.setId(est.getId());
			dto.setGestorPerfil(null);
			dto.setSupervisor(null);
			dto.setPlazo(null);
			dtoEstados.add(dto);
		}
		return dtoEstados;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETTELECOBRO)
	public EstadoTelecobro getTelecobroItinerario(Long id){
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		EstadoTelecobro estadoTelecobro = null;
		
		for(Estado est: estadosIti){
			if (est.getCodigo().equals("GV") && est.getEstadoTelecobro()!=null ){
				estadoTelecobro = estadoTelecobroDao.get(est.getEstadoTelecobro().getId());
			}
		}
		return estadoTelecobro;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETTELECOBROACTIVO)
	public Boolean getTelecobroActivo (Long id){
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		Boolean siNo = false ;
		for(Estado est: estadosIti){
			if (est.getTelecobro()!=null){
				if (est.getCodigo().equals("GV") && est.getTelecobro()){
					siNo = true;
				}
			}
		}
		return siNo;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETDCAITINERARIO)
	public DecisionComiteAutomatico getDCAItinerario(Long id){
		EventFactory.onMethodStart(this.getClass());
		
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		DecisionComiteAutomatico dca = null;
		for(Estado est: estadosIti){
			if(est.getCodigo().equals("DC") && est.getDecisionComiteAutomatico()!=null){
				dca = est.getDecisionComiteAutomatico();
			}
		}
		
		EventFactory.onMethodStop(this.getClass());
		return dca;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_AUTOSINO)
	public Boolean getAutomaticoSiNo(Long id, String codigo){
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		Boolean siNo = false ;
		for(Estado est: estadosIti){
			if (est.getAutomatico()!= null){
				if (est.getCodigo().equals("codigo") && est.getAutomatico()== true){
					siNo = true;
				}
			}
		}
		return siNo;	
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_CEAUTO)
	public Boolean getAutoCE(Long idItinerario){
		List<Estado> estadosIti = estadoDao.getEstadosItienario(idItinerario);
		Boolean siNo = false ;
		for(Estado est: estadosIti){
			if (est.getAutomatico()!= null){
				if (est.getCodigo().equals("CE") && est.getAutomatico()== true){
					siNo = true;
				}
			}
		}
		return siNo;	
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_REAUTO)
	public Boolean getAutoRE(Long idItinerario){
		List<Estado> estadosIti = estadoDao.getEstadosItienario(idItinerario);
		Boolean siNo = false ;
		for(Estado est: estadosIti){
			if (est.getAutomatico()!= null){
				if (est.getCodigo().equals("RE") && est.getAutomatico()== true){
					siNo = true;
				}
			}
		}
		return siNo;	
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_DCASINO)
	public Boolean getDCASiNo (Long id){
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		Boolean siNo = false ;
		for(Estado est: estadosIti){
			if (est.getAutomatico()!= null){
				if (est.getCodigo().equals("DC") && est.getAutomatico()== true){
					siNo = true;
				}
			}
			
		}
		return siNo;
		
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_UPDATELIST)
	public void updateList(List<ITIDtoEstado> dtoEstados){
		for (ITIDtoEstado estado: dtoEstados){
			Estado est = estadoDao.get(estado.getId());
			
			if(estado.getSupervisor()!=null){
				Perfil perfil = perfilDao.get(estado.getSupervisor());
				est.setSupervisor(perfil);
			}
			if(estado.getGestorPerfil()!=null){
				Perfil perfil = perfilDao.get(estado.getGestorPerfil());
				est.setGestorPerfil(perfil);
			}
			if(estado.getPlazo()!=null){
				est.setPlazo(estado.getPlazo());
			}
			estadoDao.saveOrUpdate(est);
		}
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_DAMEESTADOPORTIPO)
	public Estado dameEstadoPorTipo(Long id, String codigo){
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		Estado estado=null;
		for(Estado est: estadosIti){
			if (est.getCodigo().equals("codigo") ){
				estado=est;
			}
		}
		return estado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_ESTADOGVITI)
	public Estado dameEstadoGV(Long id){
		//return dameEstadoPorTipo(id, "GV");
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		Estado estado=null;
		for(Estado est: estadosIti){
			if (est.getCodigo().equals("GV") ){
				estado=est;
			}
		}
		return estado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_ESTADODCITI)
	public Estado dameEstadoDC(Long id){
		//return dameEstadoPorTipo(id, "DC");
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		Estado estado=null;
		for(Estado est: estadosIti){
			if (est.getCodigo().equals("DC") ){
				estado=est;
			}
		}
		return estado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_ESTADOFPITI)
	public Estado dameEstadoFP(Long id){
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		Estado estado=null;
		for(Estado est: estadosIti){
			if (est.getCodigo().equals("FP") ){
				estado=est;
			}
		}
		return estado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_ESTADOCEITI)
	public Estado dameEstadoCE(Long id){
		//return dameEstadoPorTipo(id, "DC");
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		Estado estado=null;
		for(Estado est: estadosIti){
			if (est.getCodigo().equals("CE") ){
				estado=est;
			}
		}
		return estado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_ESTADOREITI)
	public Estado dameEstadoRE(Long id){
		//return dameEstadoPorTipo(id, "DC");
		List<Estado> estadosIti = estadoDao.getEstadosItienario(id);
		Estado estado=null;
		for(Estado est: estadosIti){
			if (est.getCodigo().equals("RE") ){
				estado=est;
			}
		}
		return estado;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETREGLASCONSENSOCE)
	public ITIReglasVigenciaPolitica getReglasConsensoCE(Long idItinerario){
		Estado estado= dameEstadoCE(idItinerario);
		ITIReglasVigenciaPolitica valor = null;
		if (!Checks.esNulo(estado)) {
			valor = reglaVigenciaPoliticaManager.getReglasConsensoEstado(estado.getId());
		}
		return valor;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETREGLASCONSENSORE)
	public ITIReglasVigenciaPolitica getReglasConsensoRE(Long idItinerario){
		Estado estado= dameEstadoRE(idItinerario);
		ITIReglasVigenciaPolitica valor = null;
		if (!Checks.esNulo(estado)) {
			valor = reglaVigenciaPoliticaManager.getReglasConsensoEstado(estado.getId());
		}
		return valor;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETREGLASEXCLUSIONCE)
	public ITIReglasVigenciaPolitica getReglasExclusionCE(Long idItinerario){
		Estado estado= dameEstadoCE(idItinerario);
		ITIReglasVigenciaPolitica valor = null;
		if (!Checks.esNulo(estado)) {
			valor = reglaVigenciaPoliticaManager.getReglasExclusionEstado(estado.getId());
		}
		return valor;
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_GETREGLASEXCLUSIONRE)
	public ITIReglasVigenciaPolitica getReglasExclusionRE(Long idItinerario){
		Estado estado= dameEstadoRE(idItinerario);
		ITIReglasVigenciaPolitica valor = null;
		if (!Checks.esNulo(estado)) {
			valor = reglaVigenciaPoliticaManager.getReglasExclusionEstado(estado.getId());
		}
		return valor;
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.EST_MGR_SETAUTOMATICO)
	public void setEstadoAutomatico(Long id){
		if(id== null){
			throw new IllegalArgumentException("El atributo de entrada no es v�lido");
		}
		if(estadoDao.get(id)== null){
			throw new BusinessOperationException("No existe el estado");
		}
		Estado est = estadoDao.get(id);
		if (est.getAutomatico()== null || !est.getAutomatico()){
			est.setAutomatico(true);
		}else{
			est.setAutomatico(false);
		}
		estadoDao.saveOrUpdate(est);
		
	}
	
	
}

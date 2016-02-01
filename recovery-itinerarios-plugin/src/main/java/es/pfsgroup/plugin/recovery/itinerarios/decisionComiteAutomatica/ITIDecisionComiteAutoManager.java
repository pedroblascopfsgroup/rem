package es.pfsgroup.plugin.recovery.itinerarios.decisionComiteAutomatica;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.itinerario.model.Estado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.comite.dao.ITIComiteDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoActuacion.dao.ITIDDTipoActuacionDao;
import es.pfsgroup.plugin.recovery.itinerarios.ddTipoReclamacion.dao.ITIDDTipoReclamacionDao;
import es.pfsgroup.plugin.recovery.itinerarios.decisionComiteAutomatica.dao.ITIDecisionComiteAutoDao;
import es.pfsgroup.plugin.recovery.itinerarios.decisionComiteAutomatica.dto.ITIDtoAltaDCA;
import es.pfsgroup.plugin.recovery.itinerarios.estado.dao.ITIEstadoDao;
import es.pfsgroup.plugin.recovery.itinerarios.gestorDespacho.dao.ITIGestorDespachoDao;
import es.pfsgroup.plugin.recovery.itinerarios.tipoProcedimiento.dao.ITITipoProcedimientoDao;

@Service("ITIDecisionComiteAutoManager")
public class ITIDecisionComiteAutoManager {
	
	@Autowired
	ITIDecisionComiteAutoDao decisionComiteAutoDao;
	
	@Autowired
	ITIGestorDespachoDao gestorDespachoDao;
	
	@Autowired
	ITIDDTipoActuacionDao ddTipoActuacionDao;
	
	@Autowired
	ITIDDTipoReclamacionDao ddTipoReclamacionDao;
	
	@Autowired
	ITITipoProcedimientoDao tipoProcedimientoDao;
	
	@Autowired
	ITIComiteDao comiteDao;
	
	@Autowired
	ITIEstadoDao estadoDao;
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.DCA_MGR_NUEVODCA)
	public void nuevoDca(ITIDtoAltaDCA dto){
		DecisionComiteAutomatico dca;
		Estado estado = estadoDao.get(dto.getEstado());
		if (!Checks.esNulo(estado)) {
			estado.setAutomatico(dto.getAutomatico());
			if(dto.getPlazoRecuperacion()> 99){
				throw new IllegalArgumentException(
						"El plazo de recuperación no puede ser superior a 99 meses");
			}
			if(dto.getPorcentajeRecuperacion()>100){
				throw new IllegalArgumentException(
						"El porcentaje de recuperación no puede ser superior a 100");
			}
			if(dto.getAutomatico()){
				if(dto.getId()== null){
					dca = decisionComiteAutoDao.createNewDca();
					dca.setGestor(gestorDespachoDao.get(dto.getGestor()));
					dca.setSupervisor(gestorDespachoDao.get(dto.getSupervisor()));
					dca.setComite(comiteDao.get(dto.getComite()));
					dca.setTipoActuacion(ddTipoActuacionDao.get(dto.getTipoActuacion()));
					dca.setTipoReclamacion(ddTipoReclamacionDao.get(dto.getTipoReclamacion()));
					dca.setTipoProcedimiento(tipoProcedimientoDao.get(dto.getTipoProcedimiento()));
					dca.setPorcentajeRecuperacion(dto.getPorcentajeRecuperacion());
					dca.setPlazoRecuperacion(dto.getPlazoRecuperacion());
					dca.setAceptacionAutomatico(dto.getAceptacionAutomatico());
					Long idDCA= decisionComiteAutoDao.save(dca);
					dca.setId(idDCA);
				}else{
					dca = decisionComiteAutoDao.get(dto.getId());
					dca.setGestor(gestorDespachoDao.get(dto.getGestor()));
					dca.setSupervisor(gestorDespachoDao.get(dto.getSupervisor()));
					dca.setComite(comiteDao.get(dto.getComite()));
					dca.setTipoActuacion(ddTipoActuacionDao.get(dto.getTipoActuacion()));
					dca.setTipoReclamacion(ddTipoReclamacionDao.get(dto.getTipoReclamacion()));
					dca.setTipoProcedimiento(tipoProcedimientoDao.get(dto.getTipoProcedimiento()));
					dca.setPorcentajeRecuperacion(dto.getPorcentajeRecuperacion());
					dca.setPlazoRecuperacion(dto.getPlazoRecuperacion());
					dca.setAceptacionAutomatico(dto.getAceptacionAutomatico());
					decisionComiteAutoDao.saveOrUpdate(dca);
				}
				estado.setDecisionComiteAutomatico(dca);
			}
		}
	}
	

}

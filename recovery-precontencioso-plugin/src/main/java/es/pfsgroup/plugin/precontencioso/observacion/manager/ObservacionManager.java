package es.pfsgroup.plugin.precontencioso.observacion.manager;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.obervacion.model.ObservacionPCO;
import es.pfsgroup.plugin.precontencioso.observacion.api.ObservacionApi;
import es.pfsgroup.plugin.precontencioso.observacion.assembler.ObservacionAssembler;
import es.pfsgroup.plugin.precontencioso.observacion.dao.ObservacionDao;
import es.pfsgroup.plugin.precontencioso.observacion.dto.ObservacionDTO;

@Service("observacionManager")
public class ObservacionManager implements ObservacionApi {
	
	@Autowired
	private ObservacionDao observacionDao;
	
	@Autowired
	private ProcedimientoPCODao procedimientoPcoDao;
	
	@Autowired
	private UsuarioDao usuarioDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Override
	public List<ObservacionDTO> getObservacionesPorIdProcedimientoPCO(Long idProcedimientoPCO) {
		
		List<ObservacionPCO> observaciones = observacionDao.getObservacionesPorIdProcedimientoPCO(idProcedimientoPCO);
		
		List<ObservacionDTO> observacionesDto = ObservacionAssembler.entityToDto(observaciones);
		return observacionesDto;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void guardarObservacion(ObservacionDTO dto) {
		ObservacionPCO observacion;
		Date fecha = new Date();
		
		dto.setFechaAnotacion(fecha);
		
		if(Checks.esNulo(dto.getId())) {
			observacion= new ObservacionPCO();
		}
		else {
			observacion = observacionDao.get(dto.getId());
			observacion.setId(dto.getId());
		}		
		
		observacion.setProcedimientoPCO(obertenerProcedimientoPCO(dto));
		observacion.setFechaAnotacion(dto.getFechaAnotacion());
		observacion.setTextoAnotacion(dto.getTextoAnotacion());
		observacion.setSecuenciaAnotacion(0);
		observacion.setUsuario(obtenerUsuario(dto));

		observacionDao.saveOrUpdate(observacion);
	}
	
	@Override
	public ObservacionPCO getObservacionPCOById(Long idObservacionPCO) {

		return observacionDao.get(idObservacionPCO);
	}
	
	@Override
	@Transactional(readOnly = false)
	public void borrarObservacion(Long idObservacion){
		try{
			genericDao.deleteById(ObservacionPCO.class, idObservacion);
	
		}catch(Exception e){
			logger.error("borrarObservacion: " + e);
		}
		
	}
	
	private ProcedimientoPCO obertenerProcedimientoPCO(ObservacionDTO dto) {

		return procedimientoPcoDao.get(dto.getIdProcedimientoPCO());
	}
	
	private Usuario obtenerUsuario(ObservacionDTO dto) {
		
		Usuario usuario = null;
		usuario = usuarioDao.get(dto.getIdUsuario());
		
		return usuario;
	}

}

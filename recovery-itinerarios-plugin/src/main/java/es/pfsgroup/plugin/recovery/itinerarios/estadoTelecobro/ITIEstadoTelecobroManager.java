package es.pfsgroup.plugin.recovery.itinerarios.estadoTelecobro;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.telecobro.model.EstadoTelecobro;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.estado.dao.ITIEstadoDao;
import es.pfsgroup.plugin.recovery.itinerarios.estadoTelecobro.dao.ITIEstadoTelecobroDao;
import es.pfsgroup.plugin.recovery.itinerarios.estadoTelecobro.dto.ITIDtoAltaTelecobro;
import es.pfsgroup.plugin.recovery.itinerarios.proveedorTelecobro.dao.ITIProveedorTelecobroDao;

@Service("ITIEstadoTelecobroManager")
public class ITIEstadoTelecobroManager {
	
	@Autowired
	ITIEstadoTelecobroDao estadoTelecobroDao;
	
	@Autowired
	ITIProveedorTelecobroDao proveedorTelecobroDao;
	
	@Autowired
	ITIEstadoDao estadoDao;
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginItinerariosBusinessOperations.TLC_MGR_GUARDA)
	public void guardaEstadoTelecobro(ITIDtoAltaTelecobro dto){
		EstadoTelecobro estadoTelecobro;
		if (!Checks.esNulo(dto.getEstado()) && !Checks.esNulo(dto.getTelecobro())) {
			Estado estadoGV = estadoDao.get(dto.getEstado());
			estadoGV.setTelecobro(dto.getTelecobro());
			if(Checks.esNulo(dto.getPlazoFinal())){
				dto.setPlazoFinal(0L);
			}
			if(Checks.esNulo(dto.getPlazoInicial())){
				dto.setPlazoInicial(0L);
			}
			if(Checks.esNulo(dto.getDiasAntelacion())){
				dto.setDiasAntelacion(0L);
			}
			if(Checks.esNulo(dto.getPlazoRespuesta())){
				dto.setPlazoRespuesta(0L);
			}
			//estadoDao.save(estadoGV);
			/*
			if (dto.getTelecobro() && dto.getId()!= null){
				estadoTelecobro= estadoTelecobroDao.get(dto.getId());
				estadoGV.setEstadoTelecobro(estadoTelecobro);
				estadoTelecobro.setProveedor(proveedorTelecobroDao.get(dto.getProveedor()));
				estadoTelecobro.setDiasAntelacion(dto.getDiasAntelacion()* 86400000);
				estadoTelecobro.setPlazoInicial(dto.getPlazoInicial()* 86400000);
				estadoTelecobro.setPlazoFinal(dto.getPlazoFinal()* 86400000);
				estadoTelecobro.setPlazoRespuesta(dto.getPlazoRespuesta()* 86400000);
				estadoTelecobro.setAutomatico(dto.getAutomatico());
				estadoTelecobroDao.saveOrUpdate(estadoTelecobro);
			} */
			if (dto.getTelecobro()){
				if(dto.getId()!= null){
					estadoTelecobro= estadoTelecobroDao.get(dto.getId());
					if(Checks.esNulo(dto.getProveedor())){
						throw new IllegalArgumentException("Debe seleccionar un proveedor de telecobro");
					}
					estadoTelecobro.setProveedor(proveedorTelecobroDao.get(dto.getProveedor()));	
					estadoTelecobro.setDiasAntelacion(dto.getDiasAntelacion()* 86400000);
					estadoTelecobro.setPlazoInicial(dto.getPlazoInicial()* 86400000);
					estadoTelecobro.setPlazoFinal(dto.getPlazoFinal()* 86400000);
					estadoTelecobro.setPlazoRespuesta(dto.getPlazoRespuesta()* 86400000);
					estadoTelecobro.setAutomatico(dto.getAutomatico());
					Long idEstadoTelecobro = estadoTelecobroDao.save(estadoTelecobro);
					estadoTelecobro.setId(idEstadoTelecobro);
				}else{
					estadoTelecobro= estadoTelecobroDao.createNewEstadoTelecobro();
					if(Checks.esNulo(dto.getProveedor())){
						throw new IllegalArgumentException("Debe seleccionar un proveedor de telecobro");
					}
					estadoTelecobro.setProveedor(proveedorTelecobroDao.get(dto.getProveedor()));	
					estadoTelecobro.setDiasAntelacion(dto.getDiasAntelacion()* 86400000);
					estadoTelecobro.setPlazoInicial(dto.getPlazoInicial()* 86400000);
					estadoTelecobro.setPlazoFinal(dto.getPlazoFinal()* 86400000);
					estadoTelecobro.setPlazoRespuesta(dto.getPlazoRespuesta()* 86400000);
					estadoTelecobro.setAutomatico(dto.getAutomatico());
					estadoTelecobroDao.saveOrUpdate(estadoTelecobro);
				}
				
				estadoGV.setEstadoTelecobro(estadoTelecobro);		
			}
		}
	}
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TLC_MGR_GET)
	public EstadoTelecobro getEstadoTelecobro(Long id){
		return estadoTelecobroDao.get(id);
	}

}

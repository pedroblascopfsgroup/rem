package es.pfsgroup.plugin.recovery.procuradores.procurador.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.procuradores.procurador.api.RelacionProcuradorSociedadProcuradoresApi;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dao.RelacionProcuradorSociedadProcuradoresDao;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.RelacionProcuradorSociedadProcuradoresDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorSociedadProcuradores;



@Service("RelacionProcuradorSociedadProcuradores")
@Transactional(readOnly = false)
public class RelacionProcuradorSociedadProcuradoresManager  implements RelacionProcuradorSociedadProcuradoresApi{

	@Autowired
	private RelacionProcuradorSociedadProcuradoresDao relacionProcuradorSociedadProcuradoresDao;


	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_SOCIEDADPROCURADORES_GUARDAR_RELACION)
	public RelacionProcuradorSociedadProcuradores guardarRelacionProcuradorSociedadProcuradores(RelacionProcuradorSociedadProcuradoresDto dto)throws BusinessOperationException {
		// TODO Auto-generated method stub
		
		RelacionProcuradorSociedadProcuradores relProSocProcs = new RelacionProcuradorSociedadProcuradores();
		
		if (Checks.esNulo(dto.getProcurador())){	
			throw new BusinessOperationException("No se ha pasado el id del procurador.");
			
		}else if (Checks.esNulo(dto.getSociedad())){
			throw new BusinessOperationException("No se ha pasado el id del procedimiento.");
			
		}else{
			
			relProSocProcs.setProcurador(dto.getProcurador());
			relProSocProcs.setSociedad(dto.getSociedad());
			relacionProcuradorSociedadProcuradoresDao.saveOrUpdate(relProSocProcs);
			
		}
		
		return relProSocProcs;
	}





	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_SOCIEDADPROCURADORES_GET_RELACION_DEL_PROCURADOR)
	public List<RelacionProcuradorSociedadProcuradores> getRelacionProcuradorSociedadProcuradoresDelProcurador(Long idProcurador) {
		// TODO Auto-generated method stub
		return relacionProcuradorSociedadProcuradoresDao.getRelacionProcuradorSociedadProcuradoresDelProcurador(idProcurador);
	}





	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_SOCIEDADPROCURADORES_GET_RELACION_DE_LA_SOCIEDAD)
	public List<RelacionProcuradorSociedadProcuradores> getRelacionProcuradorSociedadProcuradoresDeLaSociedad(Long idSociedad, String nombreProcurador) {
		// TODO Auto-generated method stub
		return relacionProcuradorSociedadProcuradoresDao.getRelacionProcuradorSociedadProcuradoresDeLaSociedad(idSociedad,nombreProcurador);
	}



	
	


}

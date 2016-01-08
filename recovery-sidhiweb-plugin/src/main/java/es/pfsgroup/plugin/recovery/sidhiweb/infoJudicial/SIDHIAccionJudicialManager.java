package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.recovery.sidhiweb.api.SIDHIAccionJudicialApi;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dao.SIDHIAccionJudicialDao;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dao.SIDHIDatEacEstadoAccionDao;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIAccionJudicialDto;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIAccionJudicial;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIDatEacEstadoAccion;

@Component
public class SIDHIAccionJudicialManager implements SIDHIAccionJudicialApi{
	
	@Autowired
	private SIDHIAccionJudicialDao sidhiAccionJudicialDao;
	
	@Autowired
	private SIDHIDatEacEstadoAccionDao sIDHIDatEacEstadoAccionDao;
	
	@BusinessOperation(SIDHIAccionJudicialApi.UPDATE_ACCIONES)
	public void updateAcciones(String tipoJuicio, Long estadoProcesal, Long subestadoProcesal, String codigoInterfaz){
		
		if ("LINDORFF_SAN".equals(codigoInterfaz)){
			codigoInterfaz = "REINTEGRA_SAN";
		}
		
		SIDHIAccionJudicialDto dto = new SIDHIAccionJudicialDto();
		
		dto.setCodInterfaz(codigoInterfaz);
		dto.setEstadoProcesal(estadoProcesal);
		dto.setSubestadoProcesal(subestadoProcesal);
		dto.setTipoJuicio(tipoJuicio);
		
		List<SIDHIAccionJudicial> listado = sidhiAccionJudicialDao.getAccionJudicial(dto);
		
		for (SIDHIAccionJudicial accionJudicial : listado)
		{
			SIDHIDatEacEstadoAccion  estadoAccion = sIDHIDatEacEstadoAccionDao.getEstadoAccionActualizada();
			accionJudicial.setEstadoAccion(estadoAccion);
			
			sidhiAccionJudicialDao.updateAccionJudicial( accionJudicial );
		}
	}
}

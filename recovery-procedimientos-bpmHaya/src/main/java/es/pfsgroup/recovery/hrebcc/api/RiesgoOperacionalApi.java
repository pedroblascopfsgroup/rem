package es.pfsgroup.recovery.hrebcc.api;


import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.model.DDRiesgoOperacional;
import es.pfsgroup.recovery.hrebcc.model.Vencidos;

public interface RiesgoOperacionalApi {

	
		
	public void actualizarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto);
	
	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_GET_RIESGO)
	public DDRiesgoOperacional obtenerRiesgoOperacionalContrato(Long cntId);
	
	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_CNT_MGR_GET_VENCIDOS)
	public Vencidos obtenerVencidosByCntId(Long cntId);
	
}

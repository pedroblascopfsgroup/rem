package es.pfsgroup.plugin.precontencioso.liquidacion.api;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;

public interface DatosLiquidacionExtraApi {
	
	List<LiquidacionDTO> agregarDatosExtra(List<LiquidacionDTO> liquidacionesDto);
	
}

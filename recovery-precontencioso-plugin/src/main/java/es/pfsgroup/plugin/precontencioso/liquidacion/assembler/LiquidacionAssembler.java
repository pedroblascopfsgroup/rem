package es.pfsgroup.plugin.precontencioso.liquidacion.assembler;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

/**
 * Clase que se encarga de ensablar liquidacionPCO entity a DTO.
 * 
 * @author jmartin
 */
public class LiquidacionAssembler {

	/**
	 * Convierte varias entidades liquidacionPCO a un listado de DTO
	 * 
	 * @param List<liquidacionesPCO> entity
	 * @return List<liquidacionDTO> DTO
	 */
	public static List<LiquidacionDTO> entityToDto(List<LiquidacionPCO> liquidaciones) {
		List<LiquidacionDTO> liquidacionesDto = new ArrayList<LiquidacionDTO>();

		for (LiquidacionPCO liquidacionPCO : liquidaciones) {
			liquidacionesDto.add(entityToDto(liquidacionPCO));
		}

		return liquidacionesDto;
	}

	/**
	 * Convierte una entidad liquidacionPCO a un DTO
	 * 
	 * @param liquidacionesPCO entity
	 * @return liquidacionDTO DTO
	 */
	public static LiquidacionDTO entityToDto (LiquidacionPCO liquidacion) {

		if (liquidacion == null) {
			return null;
		}

		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(liquidacion.getId());
		liquidacionDto.setFechaSolicitud(liquidacion.getFechaSolicitud());
		liquidacionDto.setFechaRecepcion(liquidacion.getFechaRecepcion());
		liquidacionDto.setFechaConfirmacion(liquidacion.getFechaConfirmacion());
		liquidacionDto.setFechaCierre(liquidacion.getFechaCierre());
		liquidacionDto.setCapitalVencido(liquidacion.getCapitalVencido());
		liquidacionDto.setCapitalNoVencido(liquidacion.getCapitalNoVencido());
		liquidacionDto.setInteresesDemora(liquidacion.getInteresesDemora());
		liquidacionDto.setInteresesOrdinarios(liquidacion.getInteresesOrdinarios());
		liquidacionDto.setTotal(liquidacion.getTotal());
		liquidacionDto.setSysGuid(liquidacion.getSysGuid());

		// ProcedimientoPCO
		if (liquidacion.getProcedimientoPCO() != null) {
			liquidacionDto.setIdProcedimientoPCO(liquidacion.getProcedimientoPCO().getId());
		}

		// Contrato
		if (liquidacion.getContrato() != null) {
			liquidacionDto.setIdContrato(liquidacion.getContrato().getId());
		}

		// Estado
		if (liquidacion.getEstadoLiquidacion() != null) {
			liquidacionDto.setEstadoLiquidacion(liquidacion.getEstadoLiquidacion().getDescripcion());
			liquidacionDto.setEstadoCod(liquidacion.getEstadoLiquidacion().getCodigo());
		}

		// Apoderado
		if (liquidacion.getApoderado() != null) {
			liquidacionDto.setApoderado(liquidacion.getApoderado().getNombre());
			liquidacionDto.setApoderadoId(liquidacion.getApoderado().getId());
		}

		return liquidacionDto;
	}
}

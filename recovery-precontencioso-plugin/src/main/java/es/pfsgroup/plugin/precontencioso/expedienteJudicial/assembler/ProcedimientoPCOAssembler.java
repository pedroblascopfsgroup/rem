package es.pfsgroup.plugin.precontencioso.expedienteJudicial.assembler;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.HistoricoEstadoProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

/**
 * Clase que se encarga de ensamblar ProcedimientoPCO entity a DTO.
 * 
 * @author jmartin
 */
public class ProcedimientoPCOAssembler {

	/**
	 * Convierte una entidad ProcedimientoPCO a un DTO
	 * 
	 * @param ProcedimientoPCO entity
	 * @return ProcedimientoPCODTO DTO
	 */
	public static ProcedimientoPCODTO entityToDto(ProcedimientoPCO procedimiento) {

		if (procedimiento == null) {
			return null;
		}

		ProcedimientoPCODTO procedimientoDto = new ProcedimientoPCODTO();

		procedimientoDto.setId(procedimiento.getId());
		procedimientoDto.setPreturnado(procedimiento.getPreturnado());
		procedimientoDto.setNombreExpJudicial(procedimiento.getNombreExpJudicial());
		procedimientoDto.setNumExpInterno(procedimiento.getNumExpInterno());
		procedimientoDto.setNumExpExterno(procedimiento.getNumExpExterno());
		procedimientoDto.setCntPrincipal(procedimiento.getCntPrincipal());

		// Descripcion estado de preparacion actual
		if (procedimiento.getEstadoActual() != null) {
			procedimientoDto.setEstadoActual(procedimiento.getEstadoActual().getDescripcion());
			procedimientoDto.setEstadoActualCodigo(procedimiento.getEstadoActual().getCodigo());
		}

		// Tipo de preparacion
		if (procedimiento.getTipoPreparacion() != null) {
			procedimientoDto.setTipoPreparacionDesc(procedimiento.getTipoPreparacion().getDescripcion());
		}

		// Tipo de procedimiento propuesto
		if (procedimiento.getTipoProcPropuesto() != null) {
			procedimientoDto.setTipoProcPropuestoDesc(procedimiento.getTipoProcPropuesto().getDescripcion());
		}

		// Tipo de procedimiento iniciado
		if (procedimiento.getTipoProcIniciado() != null) {
			procedimientoDto.setTipoProcIniciadoDesc(procedimiento.getTipoProcIniciado().getDescripcion());	
		}

		// Historico de estados
		List<HistoricoEstadoProcedimientoDTO> historicoEstadosDto = historicoEstadosEntityToHistoricoEstadosDto(procedimiento.getEstadosPreparacionProc());

		procedimientoDto.setEstadosPreparacionProc(historicoEstadosDto);

		return procedimientoDto;
	}

	/**
	 * Convierte de List<HistoricoEstadoProcedimientoPCO> a List<HistoricoEstadoProcedimientoDTO>
	 * 
	 * @param ProcedimientoPCO entity
	 * @return ProcedimientoPCODTO DTO
	 */
	public static List<HistoricoEstadoProcedimientoDTO> historicoEstadosEntityToHistoricoEstadosDto(List<HistoricoEstadoProcedimientoPCO> listHistoricoEstadoProcedimientoPCO) {

		if (listHistoricoEstadoProcedimientoPCO == null) {
			return null;
		}

		List<HistoricoEstadoProcedimientoDTO> historicoEstadosDto = new ArrayList<HistoricoEstadoProcedimientoDTO>();

		for (HistoricoEstadoProcedimientoPCO historicoEstadoEntity : listHistoricoEstadoProcedimientoPCO) {
			historicoEstadosDto.add(historicoEstadoEntityToHistoricoEstadoDto(historicoEstadoEntity));
		}

		return historicoEstadosDto;
	}

	/**
	 * Convierte de HistoricoEstadoProcedimientoPCO a HistoricoEstadoProcedimientoDTO
	 * 
	 * @param HistoricoEstadoProcedimientoPCO entity
	 * @return HistoricoEstadoProcedimientoDTO DTO
	 */
	public static HistoricoEstadoProcedimientoDTO historicoEstadoEntityToHistoricoEstadoDto(HistoricoEstadoProcedimientoPCO historicoEstado) {

		if (historicoEstado == null ) {
			return null;
		}

		HistoricoEstadoProcedimientoDTO historicoEstadoDto = new HistoricoEstadoProcedimientoDTO();

		historicoEstadoDto.setId(historicoEstado.getId());
		historicoEstadoDto.setFechaInicio(historicoEstado.getFechaInicio());
		historicoEstadoDto.setFechaFin(historicoEstado.getFechaFin());

		if (historicoEstado.getEstadoPreparacion() != null) {
			historicoEstadoDto.setEstado(historicoEstado.getEstadoPreparacion().getDescripcion());
		}

		return historicoEstadoDto;
	}
}

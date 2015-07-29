package es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ExpedienteJudicialApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.assembler.ProcedimientoPCOAssembler;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

@Service
public class ExpedienteJudicialManager implements ExpedienteJudicialApi {

	@Autowired
	private ProcedimientoPCODao procedimientoPcoDao;

	@Override
	public List<HistoricoEstadoProcedimientoDTO> getEstadosPorIdProcedimiento(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);

		List<HistoricoEstadoProcedimientoDTO> historicoEstadosOut = null;

		if (procedimientoPco != null) {
			historicoEstadosOut = ProcedimientoPCOAssembler.historicoEstadosEntityToHistoricoEstadosDto(procedimientoPco.getEstadosPreparacionProc());
		}

		return historicoEstadosOut;
	}

	@BusinessOperation(ExpedienteJudicialApi.BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID)
	@Override
	public ProcedimientoPCODTO getPrecontenciosoPorProcedimientoId(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);

		ProcedimientoPCODTO procedimientoDto = ProcedimientoPCOAssembler.entityToDto(procedimientoPco);

		return procedimientoDto;
	}
}

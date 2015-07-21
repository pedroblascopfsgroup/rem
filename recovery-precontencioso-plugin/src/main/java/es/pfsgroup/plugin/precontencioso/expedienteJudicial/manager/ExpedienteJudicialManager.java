package es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ExpedienteJudicialApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.HistoricoEstadoProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

@Service
public class ExpedienteJudicialManager implements ExpedienteJudicialApi {

	@Autowired
	private ProcedimientoPCODao procedimientoPcoDao;

	@Override
	public List<HistoricoEstadoProcedimientoDTO> getEstadosPorIdProcedimiento(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);

		List<HistoricoEstadoProcedimientoDTO> historicoEstadosOut = new ArrayList<HistoricoEstadoProcedimientoDTO>();

		if (procedimientoPco != null) {
			List<HistoricoEstadoProcedimientoPCO> historicoEstados = procedimientoPco.getEstadosPreparacionProc();

			for (HistoricoEstadoProcedimientoPCO historicoEstadoEntity : historicoEstados) {

				HistoricoEstadoProcedimientoDTO historicoEstadoDto = new HistoricoEstadoProcedimientoDTO();
				historicoEstadoDto.setId(historicoEstadoEntity.getId());
				historicoEstadoDto.setEstado(historicoEstadoEntity.getEstadoPreparacion().getDescripcion());
				historicoEstadoDto.setFechaInicio(historicoEstadoEntity.getFechaInicio());
				historicoEstadoDto.setFechaFin(historicoEstadoEntity.getFechaFin());
				historicoEstadosOut.add(historicoEstadoDto);
			}
		}

		return historicoEstadosOut;
	}
}

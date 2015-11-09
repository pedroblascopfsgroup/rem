package es.pfsgroup.plugin.precontencioso.procedimiento;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager.ProcedimientoPcoManager;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.HistoricoEstadoProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.AccionDesparalizarProcedimiento;

@Component
public class AccionTrasDesparalizarProcedimiento implements AccionDesparalizarProcedimiento {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ProcedimientoPcoManager procedimientoPCOManager;
	
	@Override
	public void ejecutar(Procedimiento prc) {
		
		logger.debug("Desparalizando procedimiento precontencioso");

		// Recupera el histórico de este procedimiento.
		ProcedimientoPCO procedimientoPCO =  procedimientoPCOManager.getPCOByProcedimientoId(prc.getId());

		if (procedimientoPCO==null) {
			return;
		}
		
		// Recuperar estado actual por fecha fin mas actual
		HistoricoEstadoProcedimientoPCO estadoAnterior = null;
		List<HistoricoEstadoProcedimientoPCO> historico = procedimientoPCO.getEstadosPreparacionProc();
		if (historico != null) {
			for (HistoricoEstadoProcedimientoPCO historicoEstado : historico) {
				Date fechaFinEstado = historicoEstado.getFechaFin(); 
				if (fechaFinEstado!=null &&
						!historicoEstado.getEstadoPreparacion().equals(procedimientoPCO.getEstadoActual()) &&
						(estadoAnterior==null || fechaFinEstado.after(estadoAnterior.getFechaFin()))) {
					estadoAnterior = historicoEstado;
				}
			}
		}
		
		if (estadoAnterior!=null) {
			// Cambia estado a el último en el histórico.
			procedimientoPCOManager.cambiarEstadoExpediente(prc.getId(), estadoAnterior.getEstadoPreparacion().getCodigo());
			logger.debug("Procedimiento precontencioso desparalizado!!");
		}
		
	}

}

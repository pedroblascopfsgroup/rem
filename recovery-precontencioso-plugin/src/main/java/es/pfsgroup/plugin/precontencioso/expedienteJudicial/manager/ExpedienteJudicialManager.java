package es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ExpedienteJudicialApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.assembler.ProcedimientoPCOAssembler;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.HistoricoEstadoProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Service
public class ExpedienteJudicialManager implements ExpedienteJudicialApi {

	@Autowired
	private ProcedimientoPCODao procedimientoPcoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	UtilDiccionarioApi diccionarioApi;
	
	@Override
	@Transactional(readOnly = false)
	public boolean finalizarPreparacionExpedienteJudicialPorProcedimientoId(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);
		DDEstadoPreparacionPCO estado = procedimientoPco.getEstadoActual();
		boolean finalizar = true;
		
		if(DDEstadoPreparacionPCO.ESTADO_PREPARACION.equals(estado.getCodigo()) 
				|| DDEstadoPreparacionPCO.ESTADO_SUBSANAR.equals(estado.getCodigo()) 
				|| DDEstadoPreparacionPCO.ESTADO_SUBSANAR_POR_CAMBIO.equals(estado.getCodigo())) {
			
			
			for(DocumentoPCO doc : procedimientoPco.getDocumentos()){
				if(DDEstadoDocumentoPCO.DISPONIBLE.equals(doc.getEstadoDocumento().getCodigo())) {
					if(!doc.getAdjuntado()){
						finalizar = false;
					}
				}
			}
			if(finalizar) {
				HistoricoEstadoProcedimientoPCO historico = procedimientoPco.getEstadoActualByHistorico();
				historico.setFechaFin(new Date());
				genericDao.update(HistoricoEstadoProcedimientoPCO.class, historico);
				
				HistoricoEstadoProcedimientoPCO historicoNuevoRegistro = new HistoricoEstadoProcedimientoPCO();
				historicoNuevoRegistro.setProcedimientoPCO(procedimientoPco);
				DDEstadoPreparacionPCO estadoFinalizado = (DDEstadoPreparacionPCO)diccionarioApi.dameValorDiccionarioByCod(DDEstadoPreparacionPCO.class, DDEstadoPreparacionPCO.ESTADO_FINALIZADO);
				historicoNuevoRegistro.setEstadoPreparacion(estadoFinalizado);
				historicoNuevoRegistro.setFechaInicio(new Date());
				genericDao.save(HistoricoEstadoProcedimientoPCO.class, historicoNuevoRegistro);
			}			
		}
		return finalizar;
	}

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

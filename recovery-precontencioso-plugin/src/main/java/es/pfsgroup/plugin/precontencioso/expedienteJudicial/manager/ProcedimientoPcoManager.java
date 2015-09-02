package es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.assembler.ProcedimientoPCOAssembler;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ActualizarProcedimientoPcoDtoInfo;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.HistoricoEstadoProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Service
public class ProcedimientoPcoManager implements ProcedimientoPcoApi {

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
		boolean finalizar = true;

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
			DDEstadoPreparacionPCO estadoPreparado = (DDEstadoPreparacionPCO)diccionarioApi.dameValorDiccionarioByCod(DDEstadoPreparacionPCO.class, DDEstadoPreparacionPCO.PREPARADO);
			historicoNuevoRegistro.setEstadoPreparacion(estadoPreparado);
			historicoNuevoRegistro.setFechaInicio(new Date());
			genericDao.save(HistoricoEstadoProcedimientoPCO.class, historicoNuevoRegistro);
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

	@BusinessOperation(ProcedimientoPcoApi.BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID)
	@Override
	public ProcedimientoPCODTO getPrecontenciosoPorProcedimientoId(Long idProcedimiento) {
		ProcedimientoPCO procedimientoPco = procedimientoPcoDao.getProcedimientoPcoPorIdProcedimiento(idProcedimiento);

		ProcedimientoPCODTO procedimientoDto = ProcedimientoPCOAssembler.entityToDto(procedimientoPco);

		return procedimientoDto;
	}

	@Override
	public List<ProcedimientoPCO> busquedaProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<ProcedimientoPCO> procedimientos = procedimientoPcoDao.getProcedimientosPcoPorFiltro(filtro);
		return procedimientos;
	}

	@Override
	public List<SolicitudDocumentoPCO> busquedaSolicitudesDocumentoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<LiquidacionPCO> busquedaLiquidacionesPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<LiquidacionPCO> liquidacionesPco = procedimientoPcoDao.getLiquidacionesPorFiltro(filtro);
		return liquidacionesPco;
	}

	@Override
	public List<EnvioBurofaxPCO> busquedaEnviosBurofaxPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		List<EnvioBurofaxPCO> envioBurofaxPco = procedimientoPcoDao.getEnviosBurofaxPorFiltro(filtro);
		return envioBurofaxPco;
	}
	
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_PCO_ACTUALIZAR_PROCEDIMIENTO_Y_PCO)
	public void actualizaProcedimiento(ActualizarProcedimientoPcoDtoInfo dto) {
		Procedimiento p = null;
		ProcedimientoPCO pco = null;
		if (!Checks.esNulo(dto.getId())) {
			p = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
			pco = genericDao.get(ProcedimientoPCO.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", dto.getId()));
		} else {
			throw new BusinessOperationException(
					"plugin.santander.actualizaProcedimiento.idNulo");
		}
		if (!Checks.esNulo(dto.getTipoReclamacion())) {
			Filter filtroTipoReclamacion = genericDao.createFilter(FilterType.EQUALS, "id", dto.getTipoReclamacion());
			DDTipoReclamacion reclamacion = genericDao.get(DDTipoReclamacion.class, filtroTipoReclamacion);
			p.setTipoReclamacion(reclamacion);
		}
		if (!Checks.esNulo(dto.getTipoJuzgado())) {
			Filter filtroJuzgado = genericDao.createFilter(FilterType.EQUALS, "id", dto.getTipoJuzgado());
			TipoJuzgado juzgado = genericDao.get(TipoJuzgado.class, filtroJuzgado);
			p.setJuzgado(juzgado);
		}
		if (!Checks.esNulo(dto.getPrincipal())) {
			p.setSaldoRecuperacion(dto.getPrincipal());
		}
		if (!Checks.esNulo(dto.getEstimacion())) {
			p.setPorcentajeRecuperacion(dto.getEstimacion());
		}
		if (!Checks.esNulo(dto.getPlazoRecuperacion())) {
			p.setPlazoRecuperacion(dto.getPlazoRecuperacion());
		}
		if (!Checks.esNulo(dto.getNumeroAutos())){
			p.setCodigoProcedimientoEnJuzgado(dto.getNumeroAutos());
		}
		if(!Checks.esNulo(dto.getNumExpExterno())){
			pco.setNumExpExterno(dto.getNumExpExterno());
		}

		genericDao.update(Procedimiento.class, p);
		genericDao.update(ProcedimientoPCO.class, pco);
	}
}

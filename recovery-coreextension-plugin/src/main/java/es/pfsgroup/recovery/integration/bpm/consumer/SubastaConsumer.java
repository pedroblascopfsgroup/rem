package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.bien.BienManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.manager.EXTSubastaManager;
import es.pfsgroup.plugin.recovery.coreextension.subasta.manager.LoteSubastaDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.manager.SubastaDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDMotivoSuspSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoComite;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.MEJRecursoManager;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.ext.impl.bienes.EXTBienesManager;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.payload.LoteSubastaPayload;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.SubastaPayload;

public class SubastaConsumer extends ConsumerAction<DataContainerPayload> {
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	public SubastaConsumer(Rule<DataContainerPayload> rules) {
		super(rules);
	}
	
	public SubastaConsumer(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}

	@Autowired
	private MEJRecursoManager mejRecursoManager;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private EXTSubastaManager extSubastaManager;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private BienManager bienMgr;
	
    @Autowired
    private EXTBienesManager extBienesManager;
	
	private String getSubastaGuid(SubastaPayload subastaPayload) {
		return subastaPayload.getGuid(); // String.format("%s-EXT", subastaPayload.getId());
	}

	private String getLoteSubastaGuid(LoteSubastaPayload lotePayload) {
		return lotePayload.getGuid(); //String.format("%s-EXT", lotePayload.getId());
	}
	
	private String getMEJProcedimientoGuid(ProcedimientoPayload procedimiento) {
		return procedimiento.getGuid(); //String.format("%s-EXT", procedimiento.getIdOrigen());
	}
	
	
	private SubastaDto load(SubastaPayload subastaPayload) {
		String valor;

		String subastaGuid = getSubastaGuid(subastaPayload);
		if (Checks.esNulo(subastaGuid)) {
			throw new IntegrationDataException("[INTEGRACION] No se puede procesar subasta, no tiene guid");
		}

		// comprobamos si existe antes de crear uno nuevo...
		Subasta subasta = extSubastaManager.getSubastaByGuid(subastaGuid);
		SubastaDto subastaDto = new SubastaDto();
		if (subasta == null) {
			subastaDto.setGuid(subastaGuid);
		
			String procGuid = getMEJProcedimientoGuid(subastaPayload.getProcedimiento());
			MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(procGuid);
			if (prc==null) {
				throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s asociado al recurso s no existe", procGuid)); 
			}
			subastaDto.setProcedimiento(prc);
			subastaDto.setGuid(subastaGuid);

		} else {
			subastaDto.setId(subasta.getId());
		}
	
		valor = subastaPayload.getEstadoSubasta();
		if (!Checks.esNulo(valor)) {
			DDEstadoSubasta estado = (DDEstadoSubasta)diccionarioApi.dameValorDiccionarioByCod(DDEstadoSubasta.class, valor);
			subastaDto.setEstado(estado);
		}
		
		valor = subastaPayload.getTipoSubasta();
		if (!Checks.esNulo(valor)) {
			DDTipoSubasta tipo = (DDTipoSubasta)diccionarioApi.dameValorDiccionarioByCod(DDTipoSubasta.class, valor);
			subastaDto.setTipo(tipo);
		}

		valor = subastaPayload.getResultadoComite();
		if (!Checks.esNulo(valor)) {
			DDResultadoComite resultado = (DDResultadoComite)diccionarioApi.dameValorDiccionarioByCod(DDResultadoComite.class, valor);
			subastaDto.setResultadoComite(resultado);
		}
		
		valor = subastaPayload.getMotivoSuspension();
		if (!Checks.esNulo(valor)) {
			DDMotivoSuspSubasta motivoSuspension = (DDMotivoSuspSubasta)diccionarioApi.dameValorDiccionarioByCod(DDMotivoSuspSubasta.class, valor);
			subastaDto.setMotivoSuspension(motivoSuspension);
		}

		valor = subastaPayload.getEstadoAsunto();
		if (!Checks.esNulo(valor)) {
			DDEstadoAsunto estadoAsunto = (DDEstadoAsunto)diccionarioApi.dameValorDiccionarioByCod(DDEstadoAsunto.class, valor);
			subastaDto.setEstadoAsunto(estadoAsunto);
		}
		
		subastaDto.setNumAutos(subastaPayload.getNumAutos());
		subastaDto.setFechaSolicitud(subastaPayload.getFechaSolicitud());
		subastaDto.setFechaSenyalamiento(subastaPayload.getFechaSenyalamiento());
		subastaDto.setFechaAnuncio(subastaPayload.getFechaAnuncio());
		subastaDto.setCostasLetrado(subastaPayload.getCostasLetrado());
		subastaDto.setDeudaJudicial(subastaPayload.getDeudaJudicial());
		
		// Carga los lotes de subasta
		cargaLotes(subastaDto, subastaPayload.getLotesSubasta());
		
		return subastaDto;
	}	

	
	private void cargaLotes(SubastaDto subasta, List<LoteSubastaPayload> lotes) {
		String valor;
		
		if (lotes==null) {
			return;
		}
		
		for (LoteSubastaPayload lotePayload : lotes) {
			
			String loteGuid = getLoteSubastaGuid(lotePayload);
			if (Checks.esNulo(loteGuid)) {
				throw new IntegrationDataException("[INTEGRACION] No se puede procesar subasta, un lote no tiene GUID");
			}
			
			LoteSubasta lote = extSubastaManager.getLoteSubastaByGuid(loteGuid);
			LoteSubastaDto loteDto = new LoteSubastaDto();
			if (lote == null) {
				loteDto.setGuid(loteGuid);
			} else {
				loteDto.setId(lote.getId());
			}

			valor = lotePayload.getEstado();
			if (!Checks.esNulo(valor)) {
				DDEstadoLoteSubasta estadoLote = (DDEstadoLoteSubasta)diccionarioApi.dameValorDiccionarioByCod(DDEstadoLoteSubasta.class, valor);
				loteDto.setEstado(estadoLote);
			}
			
			loteDto.setInsPujaSinPostores(lotePayload.getInsPujaSinPostores());
			loteDto.setInsPujaPostoresDesde(lotePayload.getInsPujaPostoresDesde());
			loteDto.setInsPujaPostoresHasta(lotePayload.getInsPujaPostoresHasta());
			loteDto.setInsValorSubasta(lotePayload.getInsValorSubasta());
			loteDto.setIns50DelTipoSubasta(lotePayload.getIns50DelTipoSubasta());
			loteDto.setIns60DelTipoSubasta(lotePayload.getIns60DelTipoSubasta());
			loteDto.setIns70DelTipoSubasta(lotePayload.getIns70DelTipoSubasta());
			loteDto.setObservaciones(lotePayload.getObservaciones());
			loteDto.setRiesgoConsignacion(lotePayload.getRiesgoConsignacion());
			loteDto.setDeudaJudicial(lotePayload.getDeudaJudicial());

			subasta.getLotes().add(loteDto);
			setBienes(loteDto, lotePayload);
		}
		
	}
	
	private void setBienes(LoteSubastaDto loteDto, LoteSubastaPayload lotePayload) {
		List<String> bienesRelacionados = lotePayload.getBienesRelacionados();
		List<Long> relacionados = new ArrayList<Long>();
		loteDto.setIdBienes(relacionados);
		if (bienesRelacionados!=null) {
			// Codigo interno del bien (pasamos los Ids)
			for (String bienCodigoInterno : bienesRelacionados) {
				NMBBien bien = extBienesManager.getBienByCodigoInterno(bienCodigoInterno);
				if (bien!=null) {
					relacionados.add(bien.getId());
				}
			}
		}
	}
	
	
	@Override
	protected void doAction(DataContainerPayload payLoad) {
		SubastaPayload subastaPayload = new SubastaPayload(payLoad);
		String subGUID = getSubastaGuid(subastaPayload);
		logger.info(String.format("[INTEGRACION] SUB[%s] Guardando subasta...", subGUID));
		// Datos del recurso.
		SubastaDto subastaDto = load(subastaPayload);
		extSubastaManager.guardar(subastaDto);
		logger.debug(String.format("[INTEGRACION] SUB[%s] Subasta guardada!!", subGUID));
	}

}

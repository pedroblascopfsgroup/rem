package es.pfsgroup.plugin.recovery.coreextension.subasta.manager;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.bien.BienManager;
import es.capgemini.pfs.bien.model.Bien;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.recovery.integration.Guid;

/**
 *
 */
@Service
public class EXTSubastaManager {
	
	@Autowired
	private GenericABMDao genericDao;	

	
	@Autowired
	private ProcedimientoManager procedimientoManager;

	@Autowired
	private BienManager bienManager;
	
	@Autowired
	private SubastaDao subastaDao;	
	
	public LoteSubasta getLoteSubasta(Long idLote) {
		return genericDao.get(LoteSubasta.class, genericDao.createFilter(FilterType.EQUALS, "id", idLote), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	public Subasta getSubasta(Long idSubasta) {		
		return subastaDao.get(idSubasta);
	}
	
	@Transactional(readOnly = false)
	public void guardar(SubastaDto subastaDto) {
		Subasta subasta = null;
		
		if (subastaDto.getId()==null) {
			subasta = new Subasta();
			subasta.setProcedimiento(subastaDto.getProcedimiento());
			subasta.setAsunto(subastaDto.getProcedimiento().getAsunto());
			subasta.setGuid(subastaDto.getGuid());
			
		} else {
			subasta = getSubasta(subastaDto.getId());
			
		}
		
		subasta.setEstadoSubasta(subastaDto.getEstado());
		subasta.setTipoSubasta(subastaDto.getTipo());
		subasta.setResultadoComite(subastaDto.getResultadoComite());
		subasta.setMotivoSuspension(subastaDto.getMotivoSuspension());
		subasta.setEstadoAsunto(subastaDto.getEstadoAsunto());
		subasta.setNumAutos(subasta.getProcedimiento().getCodigoProcedimientoEnJuzgado());
		subasta.setFechaSolicitud(subastaDto.getFechaSolicitud());
		subasta.setFechaSenyalamiento(subastaDto.getFechaSenyalamiento());
		subasta.setFechaAnuncio(subastaDto.getFechaAnuncio());
		subasta.setCostasLetrado(subastaDto.getCostasLetrado());
		subasta.setDeudaJudicial(subastaDto.getDeudaJudicial());
		
		genericDao.save(Subasta.class, subasta);

		for (LoteSubastaDto ls : subastaDto.getLotes()) {
			ls.setSubasta(subasta);
			guardar(ls);
		}
		
	}
	
	@Transactional(readOnly = false)
	public void guardar(LoteSubastaDto dto) {
		LoteSubasta loteSubasta = null;
		if (dto.getId()==null) {
			loteSubasta = new LoteSubasta();
			loteSubasta.setGuid(dto.getGuid());
			loteSubasta.setSubasta(dto.getSubasta());
			
		} else {
			loteSubasta = this.getLoteSubasta(dto.getId());
			
		}
		
		loteSubasta.setNumLote(dto.getNumLote());
		loteSubasta.setInsPujaSinPostores(dto.getInsPujaSinPostores());
		loteSubasta.setInsPujaPostoresDesde(dto.getInsPujaPostoresDesde());
		loteSubasta.setInsPujaPostoresHasta(dto.getInsPujaPostoresHasta());
		loteSubasta.setInsValorSubasta(dto.getInsValorSubasta());
		loteSubasta.setIns50DelTipoSubasta(dto.getIns50DelTipoSubasta());
		loteSubasta.setIns60DelTipoSubasta(dto.getIns60DelTipoSubasta());
		loteSubasta.setIns70DelTipoSubasta(dto.getIns70DelTipoSubasta());
		loteSubasta.setObservaciones(dto.getObservaciones());
		loteSubasta.setRiesgoConsignacion(dto.getRiesgoConsignacion());
		loteSubasta.setDeudaJudicial(dto.getDeudaJudicial());
		loteSubasta.setEstado(dto.getEstado());

		// Relaciones
		setBienes(loteSubasta, dto.getIdBienes());
		
		// guarda
		genericDao.save(LoteSubasta.class, loteSubasta);
	}

	
	public void setBienes(LoteSubasta lote, List<Long> bienesLote) {
		List<Bien> bienesActuales = lote.getBienes();
		List<Bien> bienesFinales = new ArrayList<Bien>();
		
		// Recupera los lotes actuales
		if (bienesActuales!=null) {
			for (Bien b : bienesActuales) {
				if (bienesLote.contains(b.getId())) {
					bienesFinales.add(b);
					bienesLote.remove(b.getId());
				}
			}
		}
		
		for (Long l : bienesLote) {
			Bien b =  bienManager.get(l);
			bienesFinales.add(b);
		}
		lote.setBienes(bienesFinales);
	}
	
	public Subasta getSubastaByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		Subasta subasta= genericDao.get(Subasta.class, filtro);
		return subasta;
	}

	public LoteSubasta getLoteSubastaByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		LoteSubasta lotesubasta = genericDao.get(LoteSubasta.class, filtro);
		return lotesubasta;
	}
	
	public Subasta prepareGuid(Subasta subasta) {
		if (Checks.esNulo(subasta.getGuid())) {
			subasta.setGuid(Guid.getNewInstance().toString());
			subastaDao.saveOrUpdate(subasta);
		}

		if (subasta.getLotesSubasta()!=null) {
			for (LoteSubasta lote : subasta.getLotesSubasta()) {
				prepareGuid(lote);
			}
		}
		
		return subasta;
	}
	
	public LoteSubasta prepareGuid(LoteSubasta lote) {
		if (Checks.esNulo(lote.getGuid())) {
			lote.setGuid(Guid.getNewInstance().toString());
			genericDao.save(LoteSubasta.class, lote);
		}
		return lote;
	}
	
}

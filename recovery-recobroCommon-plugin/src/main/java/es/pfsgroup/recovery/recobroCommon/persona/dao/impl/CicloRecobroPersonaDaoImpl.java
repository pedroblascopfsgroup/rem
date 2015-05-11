package es.pfsgroup.recovery.recobroCommon.persona.dao.impl;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.persona.dao.api.CicloRecobroPersonaDao;
import es.pfsgroup.recovery.recobroCommon.persona.dto.CicloRecobroPersonaDto;
import es.pfsgroup.recovery.recobroCommon.persona.model.CicloRecobroPersona;

/**
 * Implementación de métodos para la persistencia de los ciclos de recobro de personas
 * @author Diana
 *
 */
@Repository("CicloRecobroPersonaDao")
public class CicloRecobroPersonaDaoImpl extends AbstractEntityDao<CicloRecobroPersona, Long> implements CicloRecobroPersonaDao {

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<CicloRecobroPersona> getCiclosRecobroPersonaExpediente(
			Long idExpediente, Long idPersona) {
		HQLBuilder hb = new HQLBuilder("select crp from CicloRecobroExpediente cre join cre.ciclosRecobroPersona crp ");
		HQLBuilder.addFiltroIgualQue(hb, "cre.expediente.id", idExpediente);
		HQLBuilder.addFiltroIgualQue(hb, "crp.persona.id", idPersona);
		
		return HibernateQueryUtils.list(this, hb);	
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Page getPage(CicloRecobroPersonaDto dto) {
		Assertions.assertNotNull(dto, "CicloRecobroPersonaDto: No puede ser NULL");
		
		if (Checks.esNulo(dto.getIdCicloRecobroExp()) 
			&& Checks.esNulo(dto.getIdPersona())
				) return null;
		
		HQLBuilder hb = new HQLBuilder("select crp from CicloRecobroPersona crp");
		
		if (!Checks.esNulo(dto.getIdCicloRecobroExp())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "crp.cicloRecobroExpediente.id", dto.getIdCicloRecobroExp());			
		}
		
		if (!Checks.esNulo(dto.getIdPersona())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "crp.persona.id", dto.getIdPersona());			
		}
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<CicloRecobroPersona> getCiclosRecobroPersonaPorAgenciaSubcarteraIntervaloFechas(
			Long idSubcartera, Long idAgencia, Date fechaInicio, Date fechaFin) {
		
		if (Checks.esNulo(idSubcartera) || Checks.esNulo(idAgencia) || Checks.esNulo(fechaInicio) || Checks.esNulo(fechaFin)) return null;		
		HQLBuilder hb = new HQLBuilder("select crp from CicloRecobroExpediente cre join cre.ciclosRecobroPersona crp ");
		HQLBuilder.addFiltroIgualQue(hb, "cre.subcartera.id", idSubcartera);
		HQLBuilder.addFiltroIgualQue(hb, "cre.agencia.id", idAgencia);
		hb.appendWhere("cre.fechaAlta < '" + fechaFin +" '");
		hb.appendWhere("cre.fechaBaja is null or cre.fechaBaja between '" + fechaInicio + "' and '" + fechaFin +"'");
		return HibernateQueryUtils.list(this, hb);	
		
	}

	@Override
	public List<CicloRecobroPersona> getCiclosRecobroPersonaExpAgenciaActual(
			Long idExpediente, Long idPersona, Long idAgencia) {
		HQLBuilder hb = new HQLBuilder("select crp from CicloRecobroExpediente cre join cre.ciclosRecobroPersona crp ");
		HQLBuilder.addFiltroIgualQue(hb, "cre.expediente.id", idExpediente);
		HQLBuilder.addFiltroIgualQue(hb, "cre.agencia.id", idAgencia);
		HQLBuilder.addFiltroIgualQue(hb, "crp.persona.id", idPersona);
		
		return HibernateQueryUtils.list(this, hb);
	}
	
}

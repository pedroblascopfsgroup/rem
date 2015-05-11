package es.pfsgroup.recovery.recobroCommon.contrato.dao.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.contrato.dao.CicloRecobroContratoDao;
import es.pfsgroup.recovery.recobroCommon.contrato.dto.CicloRecobroContratoDto;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;

/**
 * Implementación de métodos para la persistencia de los ciclos de recobro de contratos
 * @author Diana
 *
 */
@Repository("CicloRecobroContrato")
public class CicloRecobroContratoDaoImpl extends AbstractEntityDao<CicloRecobroContrato, Long> implements CicloRecobroContratoDao {

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Page getPage(CicloRecobroContratoDto dto) {
		Assertions.assertNotNull(dto, "CicloRecobroContratoDto: No puede ser NULL");
		
		if (Checks.esNulo(dto.getIdCicloRecobroExp()) && Checks.esNulo(dto.getIdContrato())) return null;
		
		HQLBuilder hb = new HQLBuilder("select crc from CicloRecobroContrato crc");
		
		if (!Checks.esNulo(dto.getIdCicloRecobroExp())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "crc.cicloRecobroExpediente.id", dto.getIdCicloRecobroExp());			
		}
		
		if (!Checks.esNulo(dto.getIdContrato())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "crc.contrato.id", dto.getIdContrato());
		}
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<CicloRecobroContrato> getCiclosRecobroContratoExpediente(
			Long idExpediente, Long idContrato) {
		
		HQLBuilder hb = new HQLBuilder("select crc from CicloRecobroExpediente cre join cre.ciclosRecobroContrato crc ");
		HQLBuilder.addFiltroIgualQue(hb, "cre.expediente.id", idExpediente);
		HQLBuilder.addFiltroIgualQue(hb, "crc.contrato.id", idContrato);
		
		return HibernateQueryUtils.list(this, hb);	
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<CicloRecobroContrato> getCiclosRecobroContratoPorAgenciaSubcarteraIntervaloFechas(
			Long idSubcartera, Long idAgencia, Date fechaInicio, Date fechaFin) {
		
		if (Checks.esNulo(idSubcartera) || Checks.esNulo(idAgencia) || Checks.esNulo(fechaInicio) || Checks.esNulo(fechaFin)) return null;		
		HQLBuilder hb = new HQLBuilder("select crc from CicloRecobroExpediente cre join cre.ciclosRecobroContrato crc ");
		HQLBuilder.addFiltroIgualQue(hb, "cre.subcartera.id", idSubcartera);
		HQLBuilder.addFiltroIgualQue(hb, "cre.agencia.id", idAgencia);
		hb.appendWhere("cre.fechaAlta < '" + fechaFin +" '");
		hb.appendWhere("cre.fechaBaja is null or cre.fechaBaja between '" + fechaInicio + "' and '" + fechaFin +"'");
		return HibernateQueryUtils.list(this, hb);	
		
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<CicloRecobroContrato> getCiclosRecobroEntradasContratoPorAgenciaSubcarteraIntervaloFechas(
			Long idSubcartera, Long idAgencia, Date fechaInicio, Date fechaFin) {
		
		if (Checks.esNulo(idSubcartera) || Checks.esNulo(idAgencia) || Checks.esNulo(fechaInicio) || Checks.esNulo(fechaFin)) return null;		
		HQLBuilder hb = new HQLBuilder("select crc from CicloRecobroExpediente cre join cre.ciclosRecobroContrato crc ");
		HQLBuilder.addFiltroIgualQue(hb, "cre.subcartera.id", idSubcartera);
		HQLBuilder.addFiltroIgualQue(hb, "cre.agencia.id", idAgencia);
		hb.appendWhere("cre.fechaAlta between '" + fechaInicio + "' and '" + fechaFin +"'");
		return HibernateQueryUtils.list(this, hb);	
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<CicloRecobroContrato> getCiclosRecobroContratoExpedienteAgencia(
			Long idExpediente, Long idContrato, Long idAgencia) {
		HQLBuilder hb = new HQLBuilder("select crc from CicloRecobroExpediente cre join cre.ciclosRecobroContrato crc ");
		HQLBuilder.addFiltroIgualQue(hb, "cre.expediente.id", idExpediente);
		HQLBuilder.addFiltroIgualQue(hb, "cre.agencia.id", idAgencia);
		HQLBuilder.addFiltroIgualQue(hb, "crc.contrato.id", idContrato);
		
		return HibernateQueryUtils.list(this, hb);	
	}

}

package es.pfsgroup.recovery.recobroCommon.cartera.dao.impl;

import java.text.ParseException;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.cartera.dao.RecobroCarteraDao;
import es.pfsgroup.recovery.recobroCommon.cartera.dto.RecobroDtoCartera;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;

@Repository
public class RecobroCarteraDaoImpl extends AbstractEntityDao<RecobroCartera, Long> implements RecobroCarteraDao {

	public Page buscaCarteras(RecobroDtoCartera dto) {

		HQLBuilder hb = new HQLBuilder("select distinct car from RecobroCartera car");
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "car.nombre", dto.getNombre());
		
		if (!Checks.esNulo(dto.getIdEstado())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "car.estado.id", dto.getIdEstado());
		}		
		
		if (!Checks.esNulo(dto.getFechaAltaDesde())
				|| !Checks.esNulo(dto.getFechaAltaHasta())) {
			try {
				HQLBuilder.addFiltroBetweenSiNotNull(hb,
						"car.fechaAlta", DateFormat.toDate(dto
								.getFechaAltaDesde()), DateFormat
								.toDate(dto.getFechaAltaHasta()));
				
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		if (!Checks.esNulo(dto.getIdEsquema())){
			hb.appendWhere(" car.id"  + (!Checks.esNulo(dto.getNotInEsquema()) && dto.getNotInEsquema() ? " not " : " ") + "in (" +
					"		 select ce.cartera.id " +
					"		 from RecobroEsquema esq, RecobroCarteraEsquema ce " +
					"		 where esq.id = ce.esquema.id AND " +
					"			   esq.auditoria.borrado = 0 AND " +
					"			   ce.auditoria.borrado = 0 AND	" +
					"			   esq.id = " + dto.getIdEsquema() + ")");					
		}
		
		if (!Checks.esNulo(dto.getIdRegla())) {
			hb.appendWhere(" car.regla.id = " + dto.getIdRegla());
		}
		
		//hb.orderBy("fechaAlta", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Page buscaCarterasDisponibles(RecobroDtoCartera dto) {
		HQLBuilder hb = new HQLBuilder("select distinct car from RecobroCartera car");
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "car.nombre", dto.getNombre());
				
		hb.appendWhere("car.estado.codigo != '"+RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION+"'");
		
		if (!Checks.esNulo(dto.getFechaAltaDesde())
				|| !Checks.esNulo(dto.getFechaAltaHasta())) {
			try {
				HQLBuilder.addFiltroBetweenSiNotNull(hb,
						"car.fechaAlta", DateFormat.toDate(dto
								.getFechaAltaDesde()), DateFormat
								.toDate(dto.getFechaAltaHasta()));
				
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		if (!Checks.esNulo(dto.getIdEsquema())){
			hb.appendWhere(" car.id"  + (!Checks.esNulo(dto.getNotInEsquema()) && dto.getNotInEsquema() ? " not " : " ") + "in (" +
					"		 select ce.cartera.id " +
					"		 from RecobroEsquema esq, RecobroCarteraEsquema ce " +
					"		 where esq.id = ce.esquema.id AND " +
					"			   esq.auditoria.borrado = 0 AND " +
					"			   ce.auditoria.borrado = 0 AND	" +
					"			   esq.id = " + dto.getIdEsquema() + ")");					
		}
		
		
		//hb.orderBy("fechaAlta", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}


}

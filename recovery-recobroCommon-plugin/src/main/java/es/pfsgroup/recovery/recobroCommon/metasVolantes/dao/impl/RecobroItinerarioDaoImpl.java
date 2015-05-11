package es.pfsgroup.recovery.recobroCommon.metasVolantes.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dao.api.RecobroItinerarioDao;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoItinerario;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;

/**
 * Clase de acceso a base de datos para la clase RecobroItinerarioMetaVolante
 * @author vanesa
 *
 */
@Repository("RecobroItinerarioDao")
public class RecobroItinerarioDaoImpl extends AbstractEntityDao<RecobroItinerarioMetasVolantes, Long> implements RecobroItinerarioDao{


	public Page buscaItinerarios(RecobroDtoItinerario dto) {
		Assertions.assertNotNull(dto, "RecobroDtoItinerario: No puede ser NULL");
		HQLBuilder hb = new HQLBuilder("select distinct iti from RecobroItinerarioMetasVolantes iti");
		
		hb.appendWhere("iti.auditoria.borrado = 0");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "iti.nombre", dto.getNombre() ,true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"iti.estado.id" , dto.getIdEstado());
		
		if (!Checks.esNulo(dto.getIdEsquema())){
			hb.appendWhere("iti.id in" +
					"					(select distinct sub.itinerarioMetasVolantes.id from RecobroEsquema esq join esq.carterasEsquema car"
					+ " join car.subcarteras sub where esq.id ="+dto.getIdEsquema()+")) ");
		}
		
		//hb.orderBy("iti.fechaAlta", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	/**
	 * Metodo que devuelve los modelos en estado Disponible o bloqueado
	 * @author Sergio
	 */
	@Override
	public List<RecobroItinerarioMetasVolantes> getModelosDSPoBLQ() {
		StringBuilder hql = new StringBuilder(
				"select distinct mi from RecobroItinerarioMetasVolantes mi  ");
		hql.append(" where mi.auditoria.borrado = 0 and mi.estado.codigo in ('"
				+ RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO
				+ "','"
				+ RecobroDDEstadoComponente.RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE
				+ "')");
		List<RecobroItinerarioMetasVolantes> ret = getHibernateTemplate().find(
				hql.toString());
		return ret;
	}

}

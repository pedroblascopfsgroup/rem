package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.rem.activo.dao.ActivoCargasDao;
import es.pfsgroup.plugin.rem.model.ActivoCargas;

@Repository("activoCargasDao")
public class ActivoCargasDaoImpl extends AbstractEntityDao<ActivoCargas, Long> implements ActivoCargasDao {

	@Resource
	private PaginationManager paginationManager;

	@Override
	public Boolean esActivoConCargasNoCanceladas(Long idActivo) {

		HQLBuilder hb = new HQLBuilder(" from ActivoCargas ac join ac.cargaBien cb left join cb.situacionCargaEconomica sce");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ac.activo.id", idActivo);
		hb.appendWhere("ac.fechaCancelacionRegistral IS NULL OR (cb.fechaCancelacion IS NULL AND cb.auditoria.borrado = 0 "
				+ "AND ac.auditoria.borrado = 0 AND (NOT sce.codigo = '" + DDSituacionCarga.CANCELADA + "'))");

		List<ActivoCargas> lista = HibernateQueryUtils.list(this, hb);

		return !Checks.estaVacio(lista);
	}
	
	@Override
	public Boolean esActivoConCargasNoCanceladasRegistral(Long idActivo){
		
		HQLBuilder hb = new HQLBuilder(" from ActivoCargas ac join ac.cargaBien cb left join cb.situacionCarga sce left join ac.tipoCargaActivo tca ");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ac.activo.id", idActivo);
		hb.appendWhere("ac.fechaCancelacionRegistral IS NULL AND cb.auditoria.borrado = 0 "
				+ "AND ac.auditoria.borrado = 0 AND (NOT sce.codigo = '" + DDSituacionCarga.CANCELADA + "' OR sce.id IS NULL) AND tca.codigo = 'REG' ");

		List<ActivoCargas> lista = HibernateQueryUtils.list(this, hb);

		return !Checks.estaVacio(lista);
		
	}
	
	@Override
	public Boolean esActivoConCargasNoCanceladasEconomica(Long idActivo){
		HQLBuilder hb = new HQLBuilder(" from ActivoCargas ac join ac.cargaBien cb left join cb.situacionCargaEconomica sce left join ac.tipoCargaActivo tca ");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ac.activo.id", idActivo);
		hb.appendWhere("cb.fechaCancelacion IS NULL AND cb.auditoria.borrado = 0 "
				+ "AND ac.auditoria.borrado = 0 AND (NOT sce.codigo = '" + DDSituacionCarga.CANCELADA + "' OR sce.id IS NULL) AND tca.codigo = 'ECO'");

		List<ActivoCargas> lista = HibernateQueryUtils.list(this, hb);

		return !Checks.estaVacio(lista);
	}

}

package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Query;
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
	
	private static final String VIGENTE = "VIG";
	private static final String NOCANCELABLE = "NCN";
	private static final String ENSANEAMIENTO = "SAN";

	@Override
	public Boolean esActivoConCargasNoCanceladas(Long idActivo) {

		HQLBuilder hb = new HQLBuilder(" from ActivoCargas ac join ac.cargaBien cb left join cb.situacionCargaEconomica sce left join cb.situacionCarga sc");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ac.activo.id", idActivo);
		hb.appendWhere("cb.auditoria.borrado = 0 AND ac.auditoria.borrado = 0 AND(sce.codigo = '" + VIGENTE + "' OR sc.codigo = '" + VIGENTE + "' "
				+ "OR sce.codigo = '" + NOCANCELABLE + "' OR sc.codigo = '" + NOCANCELABLE + "' OR sce.codigo = '" + ENSANEAMIENTO + "' OR sc.codigo = '" + ENSANEAMIENTO + "'))");

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
	
	@Override
	public Boolean calcularEstadoCargaActivo(Long idActivo, String username, boolean doFlush) {
		if(doFlush){
			getHibernateTemplate().flush();
		}
		
		return this.calcularEstadoCargaActivo(idActivo, username);
	}
	
	private Boolean calcularEstadoCargaActivo(Long idActivo, String username) {
		String procedureHQL = "BEGIN SP_CALCULO_ESTADO_CARGA_ACTIVO(:idActivoParam, :usernameParam);  END;";

		Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
		callProcedureSql.setParameter("idActivoParam", idActivo);
		callProcedureSql.setParameter("usernameParam", username);

		int resultado = callProcedureSql.executeUpdate();

		return resultado == 1;
	}

}

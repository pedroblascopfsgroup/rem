package es.pfsgroup.plugin.rem.gasto.linea.detalle.dao.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.gasto.linea.detalle.dao.GastoLineaDetalleDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Repository("GastoLineaDetalleDao")
public class GastoLineaDetalleDaoImpl extends AbstractEntityDao<GastoLineaDetalle, Long> implements GastoLineaDetalleDao {

	public List<GastoLineaDetalle> getGastoLineaDetalleBySubtipoGastoAndImpuesto(List<Long> listaIds, String tipoGastoImporte){

	
		HQLBuilder hb = new HQLBuilder(" from GastoLineaDetalle gastoLinea");
		
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gastoLinea.matriculaRefacturado", tipoGastoImporte);
   			HQLBuilder.addFiltroWhereInSiNotNull(hb, "gastoLinea.gastoProveedor.id", listaIds);
   			

		return  HibernateQueryUtils.list(this, hb);
	}
	
	public List<Object[]> getListaEntidadesByGastoProveedor (GastoProveedor gpv){

		List<String> arrayIdGLD = new ArrayList<String>();
		List<GastoLineaDetalle> gastoLineaDetalleList = gpv.getGastoLineaDetalleList();
		if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()) {
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				arrayIdGLD.add(gastoLineaDetalle.getId().toString());
			}
		}
		
		String[] listaIdGLD =  arrayIdGLD.toArray(new String[0]);
		HQLBuilder hb = new HQLBuilder(" from GastoLineaDetalleEntidad gldEnt");
		hb.appendWhereIN("gldEnt.gastoLineaDetalle.id", listaIdGLD);
		

		return (List<Object[]>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}
	

	public List<Object[]> getListaEntidadesByGastoProveedorAndEntidad (GastoProveedor gpv, List<Long> arrayEntidades){

		List<String> arrayIdGLD = new ArrayList<String>();
		List<String> arrayEntidadString = new ArrayList<String>();
		List<GastoLineaDetalle> gastoLineaDetalleList = gpv.getGastoLineaDetalleList();
		if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()) {
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				arrayIdGLD.add(gastoLineaDetalle.getId().toString());
			}
		}
		for (Long arrayEntidad : arrayEntidades) {
			arrayEntidadString.add(arrayEntidad.toString());
		}
		String[] listaIdGLD =  arrayIdGLD.toArray(new String[0]);
		String[] listaEntidades = arrayEntidadString.toArray(new String[0]);
		
		HQLBuilder hb = new HQLBuilder(" from GastoLineaDetalleEntidad gldEnt");
		hb.appendWhereIN("gldEnt.gastoLineaDetalle.id", listaIdGLD);
		hb.appendWhereIN("gldEnt.entidad", listaEntidades);
		
		return (List<Object[]>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}
	
	public Double getParticipacionTotalLinea(Long idLinea) {
		HQLBuilder hb = new HQLBuilder("select SUM(participacionGasto) from GastoLineaDetalleEntidad where gastoLineaDetalle.id = " + idLinea);

		return ((Double) getHibernateTemplate().find(hb.toString()).get(0));
	}
	
	public void updateParticipacionEntidadesLineaDetalle(Long idLinea, Double participacion, String userName) {

		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("UPDATE GastoLineaDetalleEntidad "
				+ " SET auditoria.fechaModificar = sysdate"
				+ " , auditoria.usuarioModificar = :userName "
				+ " , participacionGasto = :participacion "
				+ " WHERE gastoLineaDetalle.id = :idLinea");
		
		query.setParameter("userName", userName);
		query.setParameter("idLinea", idLinea);
		query.setParameter("participacion", participacion);
		


		query.executeUpdate();

	}
	
	@Override
	public Long getNextIdGastoLineaDetalle() {

		String sql = "SELECT S_GLD_GASTOS_LINEA_DETALLE.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();

	}
	
	// FUERZA EL COMMIT.
	@Override
	public void saveGastoLineaDetalle (GastoLineaDetalle gastoLineaDetalle) {
		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try {
			session.save(gastoLineaDetalle);
			session.getTransaction().commit();
			session.close();
		} catch (Exception e) {
			logger.error("error al persistir el gasto", e);
			tx.rollback();
		}
	}

	@Override
	public void actualizarDiariosLbk(Long idGasto, String userName) {
		String procedureHQL = "BEGIN SP_ACTUALIZA_DIARIOS(:idGasto,:usernameParam); END;";

		try {
			Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
			callProcedureSql.setParameter("idGasto", idGasto);
			callProcedureSql.setParameter("usernameParam", userName);
			callProcedureSql.executeUpdate();

		} catch (Exception e) {
			logger.error("Error en el SP_ACTUALIZA_DIARIOS para el AGR_ID "+idGasto.toString(), e);
		}

	}
	@Override
	public boolean tieneListaEntidadesByGastoProveedorAndTipoEntidad (GastoProveedor gpv, String codigoEntidadGasto){
		boolean resultado = false;
		List<String> arrayIdGLD = new ArrayList<String>();		
		List<GastoLineaDetalle> gastoLineaDetalleList = gpv.getGastoLineaDetalleList();
		if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()) {
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				arrayIdGLD.add(gastoLineaDetalle.getId().toString());
			}
		}
		
		String[] listaIdGLD =  arrayIdGLD.toArray(new String[0]);
		
		String cod = "'"+codigoEntidadGasto+"'";
		HQLBuilder hb = new HQLBuilder(" from GastoLineaDetalleEntidad gldEnt");
		hb.appendWhereIN("gldEnt.gastoLineaDetalle.id", listaIdGLD);
		hb.appendWhere("gldEnt.entidadGasto.codigo = "+ cod);
		List<Object[]> resultadoLista = (List<Object[]>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		if (resultadoLista != null && !resultadoLista.isEmpty()) {
			resultado = true;
		}
		return resultado;
	}
}

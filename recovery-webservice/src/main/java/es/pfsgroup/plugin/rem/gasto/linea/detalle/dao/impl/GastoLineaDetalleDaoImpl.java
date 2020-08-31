package es.pfsgroup.plugin.rem.gasto.linea.detalle.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.gasto.linea.detalle.dao.GastoLineaDetalleDao;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

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
	
//	StringBuilder sb = new StringBuilder("update CompradorExpediente ce set ce.auditoria.borrado = 1, ce.porcionCompra= 0, ce.fechaBaja= SYSDATE,"
//			+ " ce.auditoria.usuarioBorrar = '"+ usuarioBorrar + "', ce.auditoria.fechaBorrar = SYSDATE"
//			+ " where ce.primaryKey.comprador = " + idComprador + " and ce.primaryKey.expediente= " + idExpediente);
//	this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
}

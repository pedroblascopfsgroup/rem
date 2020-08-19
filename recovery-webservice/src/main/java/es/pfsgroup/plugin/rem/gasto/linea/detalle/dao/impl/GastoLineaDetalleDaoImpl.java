package es.pfsgroup.plugin.rem.gasto.linea.detalle.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.gasto.linea.detalle.dao.GastoLineaDetalleDao;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;

@Repository("GastoLineaDetalleDao")
public class GastoLineaDetalleDaoImpl extends AbstractEntityDao<GastoLineaDetalle, Long> implements GastoLineaDetalleDao {

	public List<GastoLineaDetalle> getGastoLineaDetalleBySubtipoGastoAndImpuesto(List<Long> listaIds, Long subtipoGasto, Long tipoImpuesto, Double tipoImpositivo){

	
		HQLBuilder hb = new HQLBuilder(" from GastoLineaDetalle gastoLinea");
		
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gastoLinea.subtipoGasto.id", subtipoGasto);
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gastoLinea.tipoImpuesto.id", tipoImpuesto);
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gastoLinea.importeIndirectoTipoImpositivo", tipoImpositivo);
   			HQLBuilder.addFiltroWhereInSiNotNull(hb, "gastoLinea.gastoProveedor.id", listaIds);

		return  HibernateQueryUtils.list(this, hb);
	}
}

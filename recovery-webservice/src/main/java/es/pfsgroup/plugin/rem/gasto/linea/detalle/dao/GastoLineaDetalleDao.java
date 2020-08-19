package es.pfsgroup.plugin.rem.gasto.linea.detalle.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;

public interface GastoLineaDetalleDao extends AbstractDao<GastoLineaDetalle, Long> {

	public List<GastoLineaDetalle> getGastoLineaDetalleBySubtipoGastoAndImpuesto(List<Long> listaIds, Long subtipoGasto, Long tipoImpuesto, Double tipoImpositivo);
}

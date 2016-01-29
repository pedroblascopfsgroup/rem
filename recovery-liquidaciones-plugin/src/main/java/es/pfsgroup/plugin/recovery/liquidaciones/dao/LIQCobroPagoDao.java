package es.pfsgroup.plugin.recovery.liquidaciones.dao;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.cobropago.model.CobroPago;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;

public interface LIQCobroPagoDao extends AbstractDao<LIQCobroPago, Long>{

	/**
	 * Busca las entregas a cuenta efecuadas para und eterminado contrato a partir de la fecha de cierre
	 * @param contrato
	 * @param fechaCierre
	 * @param fechaLiquidacion
	 * @return
	 */
	public List<LIQCobroPago> findEntregasACuenta(Long contrato, Date fechaCierre, Date fechaLiquidacion);

	 /**
     * Recupera una lista de CobroPago por Id.
     * @param id long
     * @return lista de CobroPago
     */
	public List<LIQCobroPago> getByIdAsunto(Long id);

}

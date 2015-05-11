package es.pfsgroup.recovery.recobroConfig.facturacion.dao.api;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroDDTipoCobroDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroDDTipoCobro;

public interface RecobroDDTipoCobroDao extends AbstractDao<DDSubtipoCobroPago, Long> {

	/**
	 * Devuelve los tipos de cobros que están incluidos o excluidos en un modelo de facturación dependiendo de la propiedad "habilitados"
	 * @param idModeloFacturacion El id del modelo de facturación
	 * @param habilitados Si es "true" indica que están incluidos en el modelo, de lo contrario devolverá todos los tipos de cobros no incluidos 
	 * @param facturables Indica si los cobros son facturables
	 * @return
	 */
	public Page getCobrosFacturacion(RecobroDDTipoCobroDto dto);
		

}

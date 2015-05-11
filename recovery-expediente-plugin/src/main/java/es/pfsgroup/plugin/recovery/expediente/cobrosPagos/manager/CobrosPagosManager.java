package es.pfsgroup.plugin.recovery.expediente.cobrosPagos.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.api.CobrosPagosApi;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dao.CobrosPagosDao;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dto.DtoCobrosPagos;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.model.RecobroPagoContrato;

/**
 * Mánager de la entidad cobros pagos.
 * 
 * @author Oscar
 * 
 */
@Component
public class CobrosPagosManager implements CobrosPagosApi {

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	CobrosPagosDao cobrosPagosDao;

	@Override
	@BusinessOperation(BO_GET_LISTADO_COBROS_PAGOS)
	public Page getListadoCobrosPagos(DtoCobrosPagos dto) {
		
		Long cntId = cobrosPagosDao.getCntIdPaseByExpId(dto.getId());
		Contrato cnt = genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id", cntId));
		dto.setContrato(cnt);
		return cobrosPagosDao.getListadoCobrosPagos(dto);
		
	}

	@Override
	@BusinessOperation(BO_GET_DETALLE_COBRO_PAGO)
	public RecobroPagoContrato getDetalleCobroPago(DtoCobrosPagos dto) {
		
		return cobrosPagosDao.get(dto.getId());
	}

	
}

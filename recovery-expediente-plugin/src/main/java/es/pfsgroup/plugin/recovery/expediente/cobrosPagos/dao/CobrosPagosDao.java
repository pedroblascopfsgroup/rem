package es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dto.DtoCobrosPagos;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.model.RecobroPagoContrato;

public interface CobrosPagosDao extends AbstractDao<RecobroPagoContrato, Long> {

	public Page getListadoCobrosPagos(DtoCobrosPagos dto);

	@Deprecated
	public RecobroPagoContrato getDetalleCobroPago(DtoCobrosPagos dto);

	public Long getCntIdPaseByExpId(Long idExpediente);

}

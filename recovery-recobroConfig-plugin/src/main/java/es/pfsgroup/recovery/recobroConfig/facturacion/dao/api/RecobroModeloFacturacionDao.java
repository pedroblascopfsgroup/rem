package es.pfsgroup.recovery.recobroConfig.facturacion.dao.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;

public interface RecobroModeloFacturacionDao extends AbstractDao<RecobroModeloFacturacion, Long> {

	Page buscaModelosFacturacion(RecobroModeloFacturacionDto dto);

	/**
	 * Metodo que devuelve los modelos en estado Disponible o bloqueado
	 * @author Sergio
	 */
	List<RecobroModeloFacturacion> getModelosDSPoBLQ();

}

package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dto.RecobroProcesosFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacion;

public interface RecobroProcesoFacturacionDao extends AbstractDao<RecobroProcesoFacturacion, Long> {

	Page buscaProcesoFacturacion(RecobroProcesosFacturacionDto dto);

	List<RecobroProcesoFacturacion> getProcesosByState(String estado);
	
	RecobroProcesoFacturacion buscaUltimoProcesoFacturado();
	
	/**
	 * Devuelve la lista de procesos de facturación que tiene asociado ese modelo de facturación
	 * bien sea en origen o en actual
	 * @param idModelo
	 * @return
	 */
	List<RecobroProcesoFacturacion> dameProcesosFacturacionRelacionadosModelo(Long idModelo);


}

package es.pfsgroup.recovery.bankiaWeb;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.ReportAsuntoManager;
import es.capgemini.pfs.asunto.dto.DtoReportCobroPago;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;

@Component
public class ReportBankiaAsuntoManager {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
    private Executor executor;
	
	@Autowired
	private LIQCobroPagoDao liqCobroPagoDao;
	
	/**
	 * Obtiene los cobros/pagos
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de cobros/pagos
	 */
	@BusinessOperation(overrides = ReportAsuntoManager.GET_COBROS_ASUNTO_REPORT)
	public List<DtoReportCobroPago> obtenerCobros(Long idAsunto) {
		
		List<LIQCobroPago> listadoCobrosPagos = liqCobroPagoDao.getByIdAsunto(idAsunto);
		
		List<DtoReportCobroPago> listadoRetorno = new ArrayList<DtoReportCobroPago>();
		for (LIQCobroPago cobro : listadoCobrosPagos) {
			DtoReportCobroPago dto = new DtoReportCobroPago();
			dto.setFecha(cobro.getFecha());
			dto.setImporte(cobro.getImporte());
			dto.setOrigen(cobro.getOrigenCobro()!=null ? cobro.getOrigenCobro().getDescripcion() : null);
			dto.setModalidad(cobro.getModalidadCobro()!=null ? cobro.getModalidadCobro().getDescripcion() : null);
			dto.setObservaciones(cobro.getObservaciones());
			listadoRetorno.add(dto);
		}
		return listadoRetorno;
		
		
	}
	
}

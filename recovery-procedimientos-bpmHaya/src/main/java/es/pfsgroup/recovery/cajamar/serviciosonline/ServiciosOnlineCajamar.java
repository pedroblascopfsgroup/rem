package es.pfsgroup.recovery.cajamar.serviciosonline;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDAplicativoOrigen;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBPersonasBien;

@Component
public class ServiciosOnlineCajamar implements ServiciosOnlineCajamarApi {

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired(required=false)
	private SolicitarTasacionWSApi tasacionWSApi;
	
	@Autowired(required=false)
	private ConsultaDeSaldosWSApi consultaDeSaldosWSApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ContratoManager contratoManager;
	
	@Override
	public String solicitarTasacion(Long idBien, Long cuenta, String personaContacto,
			Long telefono, String observaciones) {
	
		if(tasacionWSApi == null) {
			final String errorMsg = "No encontrada implementación para el WS de solicitar tasación en Cajamar";
			logger.warn(errorMsg);
			return errorMsg;
		}

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", idBien);
		NMBBien bien = genericDao.get(NMBBien.class, filter);
		
		Filter filterAuditoria = genericDao.createFilter(FilterType.EQUALS, "borrado", false);
		filter = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien);
		List<NMBPersonasBien> personasBien = genericDao.getList(NMBPersonasBien.class, filter, filterAuditoria);
		List<NMBContratoBien> contratosBien = genericDao.getList(NMBContratoBien.class, filter, filterAuditoria);
		
		String res = tasacionWSApi.altaSolicitud(bien, personasBien, contratosBien, cuenta, personaContacto, telefono, observaciones);
		return res;
	}

	@Override
	public ResultadoConsultaSaldo consultaDeSaldos(Long cntId) {
		if(consultaDeSaldosWSApi == null) {
			String errorMsg = "No encontrada implementación para el WS de consulta de saldos en Cajamar"; 
			ResultadoConsultaSaldo resultado = new ResultadoConsultaSaldo(); 
			resultado.setError(true);
			resultado.setMensajeError(errorMsg);
			logger.warn(errorMsg);
			return resultado;
		}
		
		// Recuperamos el contrato
		Contrato cnt = contratoManager.get(cntId);
		String numContrato = cnt.getNroContrato();
		DDAplicativoOrigen aplicativo = cnt.getAplicativoOrigen();
		
		// invocamos al servicio.
		ResultadoConsultaSaldo resultado = consultaDeSaldosWSApi.consultar(numContrato, aplicativo);
		resultado.setAplicativo(aplicativo); //añadido para tener el codigo del aplicativo en el archivo ServiciosOnlineCajamarController.java
		return resultado;
	}

}

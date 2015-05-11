package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.ReportAsuntoManager;
import es.capgemini.pfs.asunto.dto.DtoReportInstrucciones;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;

@Component
public class ReportAsuntoNMBManager {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private UsuarioDao usuarioDao;

	@Resource
	Properties appProperties;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private Executor executor;

	@Autowired
	private SubastaManager subastaManager;
	 
	/**
	 * Obtiene los riesgos origen de la actuaci�n activa del asunto.
	 * 
	 * @param idAsunto
	 *            long
	 * @return lista de riesgos
	 */
	@BusinessOperation(overrides = ReportAsuntoManager.GET_INSTRUCCIONES_SUBASTA_REPORT)
	public List<DtoReportInstrucciones> obtenerInstruccionesSubastaAsunto(Long idAsunto) {
		List<DtoReportInstrucciones> instrucciones = new ArrayList<DtoReportInstrucciones>();
		List<Subasta> subastasAsunto = subastaManager.getSubastasAsunto(idAsunto);
		for(Subasta subasta : subastasAsunto) {
			List<LoteSubasta> lotesSubasta = subasta.getLotesSubasta();
			if (lotesSubasta==null) {
				continue;
			}
			for (LoteSubasta lote : lotesSubasta) {
				if (Checks.esNulo(lote.getObservaciones())) {
					continue;
				}
				DtoReportInstrucciones instruccion = new DtoReportInstrucciones();
				instruccion.setFecha(lote.getAuditoria().getFechaCrear());
				instruccion.setTexto(lote.getObservaciones());
				instrucciones.add(instruccion);	
			}
			
		}
		return instrucciones;
	}

}

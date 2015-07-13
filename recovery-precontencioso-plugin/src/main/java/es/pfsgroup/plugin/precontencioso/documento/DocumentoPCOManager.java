package es.pfsgroup.plugin.precontencioso.documento;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.plugin.precontencioso.documento.api.DocumentoPCOApi;
import es.pfsgroup.plugin.precontencioso.documento.dao.DocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;


/**
 * Servicio para los documentos de precontencioso.
 * @author amompo
 */
@Service
public class DocumentoPCOManager implements DocumentoPCOApi {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private DocumentoPCODao documentoPCODao;


    /**
     * Devolvemos todas las solicitudes de los documentos de un 
     * procedimiento de precontenciosos
     * 
     * @param idProcPCO Long
     * @return list documentosPCODTO
     */
    //@BusinessOperation(ExternaBusinessOperation.BO_PCO_SOLICITUDES_DOC_PROC)
    public List<SolicitudDocumentoPCO> getSolicitudesDocProcPCO(Long idProcPCO) {
        logger.debug("Obteniendo solicitudes doc PCO del documento" + idProcPCO);
        List<SolicitudDocumentoPCO> solicitudesPCO = new ArrayList<SolicitudDocumentoPCO>();
        List<SolicitudDocumentoPCO> solicitudes = new ArrayList<SolicitudDocumentoPCO>();
        
        // Primero obtenemos la lista de documentos de dicho procedimienot
        List<DocumentoPCO> docsPCO = new ArrayList<DocumentoPCO>();
        docsPCO = documentoPCODao.getDocumentosProc(idProcPCO);
        
        // Por cada documento obtenemos la lista de solicitudes
		for (DocumentoPCO doc : docsPCO) {
			solicitudesPCO = documentoPCODao.getSolicitudesDoc(doc.getId());
			solicitudes.addAll(solicitudesPCO);
		}
	
        return solicitudes;
    }

 }

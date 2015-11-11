package es.pfsgroup.recovery.cajamar.ws.gestordocumental;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.INPUT;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.OUTPUT;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.SMGESTIONDOCUMENTAL;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.SMGESTIONDOCUMENTALType;

import es.pfsgroup.recovery.cajamar.serviciosonline.GestorDocumentalWSApi;
import es.pfsgroup.recovery.cajamar.ws.BaseWS;
import es.pfsgroup.recovery.gestorDocumental.dto.GestorDocumentalInputDto;
import es.pfsgroup.recovery.gestorDocumental.dto.GestorDocumentalOutputDto;

public class GestorDocumentalWS extends BaseWS implements GestorDocumentalWSApi {

	private static final String WEB_SERVICE_NAME = "S_M_GESTIONDOCUMENTAL";

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getWSName() {
		return WEB_SERVICE_NAME;
	}

	@Override
	public GestorDocumentalOutputDto ejecutar(GestorDocumentalInputDto inputDto) {
		//TODO assembler DTO to INPUT
		INPUT input = new INPUT();

		SMGESTIONDOCUMENTAL service = new SMGESTIONDOCUMENTAL();
		SMGESTIONDOCUMENTALType servicePort = service.getSMGESTIONDOCUMENTALPort();
		OUTPUT output = servicePort.sMGESTIONDOCUMENTAL(input);

		//TODO assembler ouput to DTO
		GestorDocumentalOutputDto out = new GestorDocumentalOutputDto();
		return out;
	}

}
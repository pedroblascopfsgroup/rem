package es.pfsgroup.recovery.cajamar.ws.gestordocumental;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.INPUT;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.OUTPUT;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.SMGESTIONDOCUMENTAL;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.SMGESTIONDOCUMENTALType;
import org.springframework.stereotype.Component;

import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalInputDto;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalOutputDto;
import es.pfsgroup.recovery.cajamar.serviciosonline.GestorDocumentalWSApi;
import es.pfsgroup.recovery.cajamar.ws.BaseWS;

@Component
public class GestorDocumentalWS extends BaseWS implements GestorDocumentalWSApi {

	private static final String WEB_SERVICE_NAME = "S_M_GESTIONDOCUMENTAL";

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public String getWSName() {
		return WEB_SERVICE_NAME;
	}

	@Override
	public GestorDocumentalOutputDto ejecutar(GestorDocumentalInputDto inputDto) {
		
		INPUT input = GestorDocumentalInputAssembler.dtoToInput(inputDto); 

		SMGESTIONDOCUMENTAL service = new SMGESTIONDOCUMENTAL();
		SMGESTIONDOCUMENTALType servicePort = service.getSMGESTIONDOCUMENTALPort();
		OUTPUT output = servicePort.sMGESTIONDOCUMENTAL(input);

		GestorDocumentalOutputDto out = GestorDocumentalOutputAssembler.outputToDto(output);
		GestorDocumentalInputAssembler.dtoToInput(inputDto);
		return out;
	}

}
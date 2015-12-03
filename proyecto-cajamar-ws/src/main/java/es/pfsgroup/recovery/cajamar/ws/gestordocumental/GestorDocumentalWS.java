package es.pfsgroup.recovery.cajamar.ws.gestordocumental;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.INPUT;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.OUTPUT;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.SMGESTIONDOCUMENTAL;
import org.cajamar.ws.S_M_GESTIONDOCUMENTAL.SMGESTIONDOCUMENTALType;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
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

		
		logger.info("LLamando al WS...");
		SMGESTIONDOCUMENTAL service = new SMGESTIONDOCUMENTAL();
		SMGESTIONDOCUMENTALType servicePort = service.getSMGESTIONDOCUMENTALPort();
		OUTPUT output = servicePort.sMGESTIONDOCUMENTAL(input);
		logger.info("WS invocado! Valores de respuesta:");
		
		logger.info(String.format("DESC_ESTADO: %s", output.getDESCESTADO()));
		logger.info(String.format("ESTADO: %s", output.getESTADO()));
		logger.info(String.format("FICHEROBASE64: %s", output.getFICHEROBASE64()));
		logger.info(String.format("IDDOCUMENTO: %s", output.getIDDOCUMENTO()));
		logger.info(String.format("COD_ERROR: %s", output.getCODERROR()));
		logger.info(String.format("TXT_ERROR: %s", output.getTXTERROR()));

		logger.info(String.format("LB_LISTADODOCUMENTOS: %s", output.getLBLISTADODOCUMENTOS()));
		if(!Checks.esNulo(output.getLBLISTADODOCUMENTOS())) {
			logger.info(String.format("DENTRO DEL LISTADO: %s", output.getLBLISTADODOCUMENTOS()));
			int i = 0;
			for(OUTPUT.LBLISTADODOCUMENTOS.Element ele : output.getLBLISTADODOCUMENTOS().getElement()) {
				logger.info(String.format("REGISTRO_"+i+": %s", output.getLBLISTADODOCUMENTOS()));
				logger.info(String.format("TIPODOC: %s", ele.getTIPODOC()));
				logger.info(String.format("NOMBRETIPODOC: %s", ele.getNOMBRETIPODOC()));
				logger.info(String.format("DESCRIPCION: %s", ele.getDESCRIPCION()));
				logger.info(String.format("ALTAVERSION: %s", ele.getALTAVERSION()));
				logger.info(String.format("VERSION: %s", ele.getVERSION()));
				logger.info(String.format("ALTARELACION: %s", ele.getALTARELACION()));
				logger.info(String.format("ENTIDAD: %s", ele.getENTIDAD()));
				logger.info(String.format("CENTRO: %s", ele.getCENTRO()));
				logger.info(String.format("MAESTRO: %s", ele.getMAESTRO()));
				logger.info(String.format("CLAVERELACION: %s", ele.getCLAVERELACION()));
				logger.info(String.format("PERMACT: %s", ele.getPERMACT()));
				logger.info(String.format("FECHAVIG: %s", ele.getFECHAVIG()));
				
				logger.info(String.format("HIST: %s", ele.getHIST()));
				logger.info(String.format("IDDOCUMENTO: %s", ele.getIDDOCUMENTO()));
				logger.info(String.format("CONSULTABILIDAD: %s", ele.getCONSULTABILIDAD()));
				logger.info(String.format("RETENIDO: %s", ele.getRETENIDO()));
				logger.info(String.format("EXTFICHERO: %s", ele.getEXTFICHERO()));
				logger.info(String.format("ESTADOSFD: %s", ele.getESTADOSFD()));
				logger.info(String.format("REFCENTERA: %s", ele.getREFCENTERA()));
				i++;
			}			
		}
		
		GestorDocumentalOutputDto out = GestorDocumentalOutputAssembler.outputToDto(output);
		return out;
	}

}
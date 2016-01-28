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
		logger.info("LLamando al WS..."+input.getTIPOASOCIACION());

		logger.info("Parametros de entrada..."+input.getTIPOASOCIACION()+"...");
		logger.info(String.format("APLICACION_"+input.getAPLICACION()+": %s", input.getAPLICACION()));
		logger.info(String.format("CLAVEASOCIACION_"+input.getTIPOASOCIACION()+": %s", input.getCLAVEASOCIACION()));
		logger.info(String.format("CLAVEASOCIACION2_"+input.getTIPOASOCIACION()+": %s", input.getCLAVEASOCIACION2()));
		logger.info(String.format("CLAVEASOCIACION3_"+input.getTIPOASOCIACION()+": %s", input.getCLAVEASOCIACION3()));
		logger.info(String.format("DESCRIPCION_"+input.getTIPOASOCIACION()+": %s", input.getDESCRIPCION()));
		logger.info(String.format("EXTENSIONFICHERO_"+input.getTIPOASOCIACION()+": %s", input.getEXTENSIONFICHERO()));
		logger.info(String.format("FECHAVIGENCIA_"+input.getTIPOASOCIACION()+": %s", input.getFECHAVIGENCIA()));
		logger.info(String.format("FICHEROBASE64_"+input.getTIPOASOCIACION()+": %s", input.getFICHEROBASE64()));
		logger.info(String.format("LOCALIZADOR_"+input.getTIPOASOCIACION()+": %s", input.getLOCALIZADOR()));
		logger.info(String.format("OPERACION_"+input.getTIPOASOCIACION()+": %s", input.getOPERACION()));
		logger.info(String.format("ORIGEN_"+input.getTIPOASOCIACION()+": %s", input.getORIGEN()));
		logger.info(String.format("RUTA_FICHERO_REMOTO_"+input.getTIPOASOCIACION()+": %s", input.getRUTAFICHEROREMOTO()));
		logger.info(String.format("TIPOASOCIACION_"+input.getTIPOASOCIACION()+": %s", input.getTIPOASOCIACION()));
		logger.info(String.format("TIPOASOCIACION2_"+input.getTIPOASOCIACION()+": %s", input.getTIPOASOCIACION2()));
		logger.info(String.format("TIPOASOCIACION3_"+input.getTIPOASOCIACION()+": %s", input.getTIPOASOCIACION3()));
		logger.info(String.format("TIPODOCUMENTO_"+input.getTIPOASOCIACION()+": %s", input.getTIPODOCUMENTO()));
		
		SMGESTIONDOCUMENTAL service = new SMGESTIONDOCUMENTAL();
		SMGESTIONDOCUMENTALType servicePort = service.getSMGESTIONDOCUMENTALPort();
		OUTPUT output = servicePort.sMGESTIONDOCUMENTAL(input);
		logger.info("WS invocado! Valores de respuesta_"+input.getTIPOASOCIACION()+":");
		
		logger.info(String.format("DESC_ESTADO_"+input.getTIPOASOCIACION()+": %s", output.getDESCESTADO()));
		logger.info(String.format("ESTADO_"+input.getTIPOASOCIACION()+": %s", output.getESTADO()));
		logger.info(String.format("FICHEROBASE64_"+input.getTIPOASOCIACION()+": %s", output.getFICHEROBASE64()));
		logger.info(String.format("IDDOCUMENTO_"+input.getTIPOASOCIACION()+": %s", output.getIDDOCUMENTO()));
		logger.info(String.format("COD_ERROR_"+input.getTIPOASOCIACION()+": %s", output.getCODERROR()));
		logger.info(String.format("TXT_ERROR_"+input.getTIPOASOCIACION()+": %s", output.getTXTERROR()));

		logger.info(String.format("LB_LISTADODOCUMENTOS_"+input.getTIPOASOCIACION()+": %s", output.getLBLISTADODOCUMENTOS()));
		if(!Checks.esNulo(output.getLBLISTADODOCUMENTOS())) {
			logger.info(String.format("DENTRO DEL LISTADO_"+input.getTIPOASOCIACION()+": %s", output.getLBLISTADODOCUMENTOS()));
			int i = 0;
			for(OUTPUT.LBLISTADODOCUMENTOS.Element ele : output.getLBLISTADODOCUMENTOS().getElement()) {
				logger.info(String.format("REGISTRO_"+i+"_"+input.getTIPOASOCIACION()+": %s", output.getLBLISTADODOCUMENTOS()));
				logger.info(String.format("TIPODOC_"+input.getTIPOASOCIACION()+": %s", ele.getTIPODOC()));
				logger.info(String.format("NOMBRETIPODOC_"+input.getTIPOASOCIACION()+": %s", ele.getNOMBRETIPODOC()));
				logger.info(String.format("DESCRIPCION_"+input.getTIPOASOCIACION()+": %s", ele.getDESCRIPCION()));
				logger.info(String.format("ALTAVERSION_"+input.getTIPOASOCIACION()+": %s", ele.getALTAVERSION()));
				logger.info(String.format("VERSION_"+input.getTIPOASOCIACION()+": %s", ele.getVERSION()));
				logger.info(String.format("ALTARELACION_"+input.getTIPOASOCIACION()+": %s", ele.getALTARELACION()));
				logger.info(String.format("ENTIDAD_"+input.getTIPOASOCIACION()+": %s", ele.getENTIDAD()));
				logger.info(String.format("CENTRO_"+input.getTIPOASOCIACION()+": %s", ele.getCENTRO()));
				logger.info(String.format("MAESTRO_"+input.getTIPOASOCIACION()+": %s", ele.getMAESTRO()));
				logger.info(String.format("CLAVERELACION_"+input.getTIPOASOCIACION()+": %s", ele.getCLAVERELACION()));
				logger.info(String.format("PERMACT_"+input.getTIPOASOCIACION()+": %s", ele.getPERMACT()));
				logger.info(String.format("FECHAVIG_"+input.getTIPOASOCIACION()+": %s", ele.getFECHAVIG()));
				logger.info(String.format("HIST_"+input.getTIPOASOCIACION()+": %s", ele.getHIST()));
				logger.info(String.format("IDDOCUMENTO_"+input.getTIPOASOCIACION()+": %s", ele.getIDDOCUMENTO()));
				logger.info(String.format("CONSULTABILIDAD_"+input.getTIPOASOCIACION()+": %s", ele.getCONSULTABILIDAD()));
				logger.info(String.format("RETENIDO_"+input.getTIPOASOCIACION()+": %s", ele.getRETENIDO()));
				logger.info(String.format("EXTFICHERO_"+input.getTIPOASOCIACION()+": %s", ele.getEXTFICHERO()));
				logger.info(String.format("ESTADOSFD_"+input.getTIPOASOCIACION()+": %s", ele.getESTADOSFD()));
				logger.info(String.format("REFCENTERA_"+input.getTIPOASOCIACION()+": %s", ele.getREFCENTERA()));
				i++;
			}			
		}
		
		GestorDocumentalOutputDto out = GestorDocumentalOutputAssembler.outputToDto(output);
		return out;
	}

}
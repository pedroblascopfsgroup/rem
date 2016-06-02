package es.pfsgroup.recovery.cajamar.ws.gestordocumental;

import java.net.MalformedURLException;
import java.net.URL;

import javax.xml.namespace.QName;

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
		GestorDocumentalOutputDto out = null;
		
		try {
		
			String urlWSDL = getWSURL();
			String targetNamespace = getWSNamespace();
			String name = getWSName();
			
			URL wsdlLocation = new URL(urlWSDL);
			
			QName qName = new QName(targetNamespace, name);
			
			INPUT input = GestorDocumentalInputAssembler.dtoToInput(inputDto); 
			logger.info("LLamando al WS..."+input.getTIPOASOCIACION());
	
			logger.info("Parametros de entrada..."+input.getTIPOASOCIACION()+"...");
			logger.debug(String.format("APLICACION_"+input.getAPLICACION()+": %s", input.getAPLICACION()));
			logger.info(String.format("CLAVEASOCIACION_"+input.getTIPOASOCIACION()+": %s", input.getCLAVEASOCIACION()));
			logger.debug(String.format("CLAVEASOCIACION2_"+input.getTIPOASOCIACION()+": %s", input.getCLAVEASOCIACION2()));
			logger.debug(String.format("CLAVEASOCIACION3_"+input.getTIPOASOCIACION()+": %s", input.getCLAVEASOCIACION3()));
			logger.info(String.format("DESCRIPCION_"+input.getTIPOASOCIACION()+": %s", input.getDESCRIPCION()));
			logger.info(String.format("EXTENSIONFICHERO_"+input.getTIPOASOCIACION()+": %s", input.getEXTENSIONFICHERO()));
			logger.debug(String.format("FECHAVIGENCIA_"+input.getTIPOASOCIACION()+": %s", input.getFECHAVIGENCIA()));
//			logger.info(String.format("FICHEROBASE64_"+input.getTIPOASOCIACION()+": %s", input.getFICHEROBASE64()));
			logger.info(String.format("LOCALIZADOR_"+input.getTIPOASOCIACION()+": %s", input.getLOCALIZADOR()));
			logger.info(String.format("OPERACION_"+input.getTIPOASOCIACION()+": %s", input.getOPERACION()));
			logger.debug(String.format("ORIGEN_"+input.getTIPOASOCIACION()+": %s", input.getORIGEN()));
			logger.debug(String.format("RUTA_FICHERO_REMOTO_"+input.getTIPOASOCIACION()+": %s", input.getRUTAFICHEROREMOTO()));
			logger.info(String.format("TIPOASOCIACION_"+input.getTIPOASOCIACION()+": %s", input.getTIPOASOCIACION()));
			logger.debug(String.format("TIPOASOCIACION2_"+input.getTIPOASOCIACION()+": %s", input.getTIPOASOCIACION2()));
			logger.debug(String.format("TIPOASOCIACION3_"+input.getTIPOASOCIACION()+": %s", input.getTIPOASOCIACION3()));
			logger.info(String.format("TIPODOCUMENTO_"+input.getTIPOASOCIACION()+": %s", input.getTIPODOCUMENTO()));
	
			SMGESTIONDOCUMENTAL service = new SMGESTIONDOCUMENTAL(wsdlLocation, qName);
			
			SMGESTIONDOCUMENTALType servicePort = service.getSMGESTIONDOCUMENTALPort();
			OUTPUT output = servicePort.sMGESTIONDOCUMENTAL(input);
			logger.info("WS invocado! Valores de respuesta_"+input.getTIPOASOCIACION()+":");
			
			logger.info(String.format("DESC_ESTADO_"+input.getTIPOASOCIACION()+": %s", output.getDESCESTADO()));
			logger.info(String.format("ESTADO_"+input.getTIPOASOCIACION()+": %s", output.getESTADO()));
//			logger.info(String.format("FICHEROBASE64_"+input.getTIPOASOCIACION()+": %s", output.getFICHEROBASE64()));
			logger.debug(String.format("IDDOCUMENTO_"+input.getTIPOASOCIACION()+": %s", output.getIDDOCUMENTO()));
			logger.info(String.format("COD_ERROR_"+input.getTIPOASOCIACION()+": %s", output.getCODERROR()));
			logger.info(String.format("TXT_ERROR_"+input.getTIPOASOCIACION()+": %s", output.getTXTERROR()));
	
			logger.info(String.format("LB_LISTADODOCUMENTOS_"+input.getTIPOASOCIACION()+": %s", output.getLBLISTADODOCUMENTOS()));
			if(!Checks.esNulo(output.getLBLISTADODOCUMENTOS())) {
				logger.debug(String.format("DENTRO DEL LISTADO_"+input.getTIPOASOCIACION()+": %s", output.getLBLISTADODOCUMENTOS()));
				int i = 0;
				for(OUTPUT.LBLISTADODOCUMENTOS.Element ele : output.getLBLISTADODOCUMENTOS().getElement()) {
					logger.debug(String.format("REGISTRO_"+i+"_"+input.getTIPOASOCIACION()+": %s", output.getLBLISTADODOCUMENTOS()));
					logger.debug(String.format("TIPODOC_"+input.getTIPOASOCIACION()+": %s", ele.getTIPODOC()));
					logger.debug(String.format("NOMBRETIPODOC_"+input.getTIPOASOCIACION()+": %s", ele.getNOMBRETIPODOC()));
					logger.debug(String.format("DESCRIPCION_"+input.getTIPOASOCIACION()+": %s", ele.getDESCRIPCION()));
					logger.debug(String.format("ALTAVERSION_"+input.getTIPOASOCIACION()+": %s", ele.getALTAVERSION()));
					logger.debug(String.format("VERSION_"+input.getTIPOASOCIACION()+": %s", ele.getVERSION()));
					logger.debug(String.format("ALTARELACION_"+input.getTIPOASOCIACION()+": %s", ele.getALTARELACION()));
					logger.debug(String.format("ENTIDAD_"+input.getTIPOASOCIACION()+": %s", ele.getENTIDAD()));
					logger.debug(String.format("CENTRO_"+input.getTIPOASOCIACION()+": %s", ele.getCENTRO()));
					logger.debug(String.format("MAESTRO_"+input.getTIPOASOCIACION()+": %s", ele.getMAESTRO()));
					logger.debug(String.format("CLAVERELACION_"+input.getTIPOASOCIACION()+": %s", ele.getCLAVERELACION()));
					logger.debug(String.format("PERMACT_"+input.getTIPOASOCIACION()+": %s", ele.getPERMACT()));
					logger.debug(String.format("FECHAVIG_"+input.getTIPOASOCIACION()+": %s", ele.getFECHAVIG()));
					logger.debug(String.format("HIST_"+input.getTIPOASOCIACION()+": %s", ele.getHIST()));
					logger.debug(String.format("IDDOCUMENTO_"+input.getTIPOASOCIACION()+": %s", ele.getIDDOCUMENTO()));
					logger.debug(String.format("CONSULTABILIDAD_"+input.getTIPOASOCIACION()+": %s", ele.getCONSULTABILIDAD()));
					logger.debug(String.format("RETENIDO_"+input.getTIPOASOCIACION()+": %s", ele.getRETENIDO()));
					logger.debug(String.format("EXTFICHERO_"+input.getTIPOASOCIACION()+": %s", ele.getEXTFICHERO()));
					logger.debug(String.format("ESTADOSFD_"+input.getTIPOASOCIACION()+": %s", ele.getESTADOSFD()));
					logger.debug(String.format("REFCENTERA_"+input.getTIPOASOCIACION()+": %s", ele.getREFCENTERA()));
					i++;
				}			
			}
			out = GestorDocumentalOutputAssembler.outputToDto(output);

		} catch (MalformedURLException e) {
			logger.error("Error en el método al invocarServicio", e);
		}
		
		return out;
	}

}
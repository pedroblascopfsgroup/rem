package es.pfsgroup.plugin.gestordocumental.dto.documentos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;

public class RecoveryToGestorDocAssembler {

	private static final Log logger = LogFactory.getLog(RecoveryToGestorDocAssembler.class);
	
	private static final String USUARIO = "srv.rem_ot";
	private static final String PASSWORD = "Futures9";

	public static CabeceraPeticionRestClientDto getCabeceraPeticionRestClient(String numActivo, String tipoExp, String claseExp) {

		CabeceraPeticionRestClientDto cabecera = new CabeceraPeticionRestClientDto();
		cabecera.setIdExpedienteHaya(numActivo);
		cabecera.setCodTipo(tipoExp); 
		cabecera.setCodClase(claseExp);
		return cabecera;
	}

	public static DocumentosExpedienteDto getDocumentosExpedienteDto() {

		DocumentosExpedienteDto doc = new DocumentosExpedienteDto();
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setTipoConsulta(null);
		doc.setVinculoDocumento(false);
		doc.setVinculoExpediente(false);
		return doc;
	}
	
	public static BajaDocumentoDto getDescargaDocumentoDto() {
		BajaDocumentoDto login = new BajaDocumentoDto();

		login.setUsuario(USUARIO);
		login.setPassword(PASSWORD);
		
		return login;
	}
	

	public static CrearDocumentoDto getCrearDocumentoDto(WebFileItem webFileItem, String userLogin, String matricula) {
		CrearDocumentoDto doc = new CrearDocumentoDto();
		String[] arrayMatricula = matricula.split("-");
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setUsuarioOperacional(userLogin);
		doc.setDocumento(webFileItem.getFileItem().getFile());
		doc.setDescripcionDocumento(webFileItem.getFileItem().getFileName());
		doc.setGeneralDocumento(rellenarGeneralDocumento(arrayMatricula[1], arrayMatricula[2], arrayMatricula[3]));
		doc.setArchivoFisico("{}");
		
		return doc;
	}

	private static String rellenarGeneralDocumento (String serie, String tdn1, String tdn2) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
		sb.append(GestorDocumentalConstants.generalDocumento[5]).append("Bankia IPLUS").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumento[6]).append("ALTA").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumento[7]).append(serie).append(", ");
		sb.append(GestorDocumentalConstants.generalDocumento[8]).append(tdn1).append(", ");
		sb.append(GestorDocumentalConstants.generalDocumento[9]).append(tdn2);
		sb.append("}");
		return sb.toString();
	}
	
	private static String rellenarGeneralDocumentoModif() {
		StringBuilder sb = new StringBuilder();
		sb.append(GestorDocumentalConstants.generalDocumentoModif[0]).append("Número Registro").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumentoModif[1]).append("Fecha Baja Lógica").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumentoModif[2]).append("Fecha Caducidad").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumentoModif[3]).append("Fecha Expurgo").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumentoModif[4]).append("Proceso Carga").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumentoModif[5]).append("LOPD").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumentoModif[6]).append("Serie Documental").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumentoModif[7]).append("TDN1").append(", ");
		sb.append(GestorDocumentalConstants.generalDocumentoModif[8]).append("TDN2");
		return sb.toString();
	}	
	
	private static String rellenarArchivoFisico() {
		StringBuilder sb = new StringBuilder();
		sb.append(GestorDocumentalConstants.archivoFisico[0]).append("Proveedor Custodia").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[1]).append("Referencia Custodia").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[2]).append("Contenedor").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[3]).append("Lote").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[4]).append("Posición").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[5]).append("Documento Original");
		return sb.toString();
	}
	
	public static CrearVersionDto getCrearVersionDto(String login) {
		CrearVersionDto dto = new CrearVersionDto();
		
		dto.setUsuario(USUARIO);
		dto.setPassword(PASSWORD);
		dto.setUsuarioOperacional(login);
		dto.setDocumento(null);
		
		return dto;
	}
	
	
	public static CrearVersionMetadatosDto getCrearVersionMetadatosDto(String login){
		CrearVersionMetadatosDto dto = new CrearVersionMetadatosDto();
		
		dto.setUsuario(USUARIO);
		dto.setPassword(PASSWORD);
		dto.setUsuarioOperacional(login);
		dto.setGeneralDocumentoModif(rellenarGeneralDocumentoModif());
		dto.setDocumento(null);
		dto.setArchivoFisico(rellenarArchivoFisico());
		
		return dto;
	}
	
	
	public static ModificarMetadatosDto getModificarMetadatosDto(String login) {
		ModificarMetadatosDto dto = new ModificarMetadatosDto();
		
		dto.setUsuario(USUARIO);
		dto.setPassword(PASSWORD);
		dto.setUsuarioOperacional(login);
		dto.setGeneralDocumentoModif(rellenarGeneralDocumentoModif());
		dto.setArchivoFisico(rellenarArchivoFisico());
		
		return dto;
	}
	
	public static BajaDocumentoDto getBajaDocumentoDto(String login) {
		BajaDocumentoDto baja = new BajaDocumentoDto();
		
		baja.setUsuario(USUARIO);
		baja.setPassword(PASSWORD);
		baja.setUsuarioOperacional(login);
		return baja;
	}
	
}

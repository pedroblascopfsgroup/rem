package es.pfsgroup.plugin.gestordocumental.dto.documentos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;

public class RecoveryToGestorDocAssembler {

	private static final Log logger = LogFactory.getLog(RecoveryToGestorDocAssembler.class);
	
	public static CabeceraPeticionRestClientDto getCabeceraPeticionRestClient(String id, String tipoExp, String claseExp) {

		CabeceraPeticionRestClientDto cabecera = new CabeceraPeticionRestClientDto();
		cabecera.setIdExpedienteHaya(id);
		cabecera.setCodTipo(tipoExp); 
		cabecera.setCodClase(claseExp);
		return cabecera;
	}

	public static DocumentosExpedienteDto getDocumentosExpedienteDto(UsuarioPasswordDto usuario) {

		DocumentosExpedienteDto doc = new DocumentosExpedienteDto();
		doc.setUsuario(usuario.getUsuario());
		doc.setPassword(usuario.getPassword());
		doc.setTipoConsulta(null);
		doc.setVinculoDocumento(false);
		doc.setVinculoExpediente(false);
		return doc;
	}	

	public static CrearDocumentoDto getCrearDocumentoDto(WebFileItem webFileItem, UsuarioPasswordDto usuario, String matricula) {
		CrearDocumentoDto doc = new CrearDocumentoDto();
		String[] arrayMatricula = matricula.split("-");
		doc.setUsuario(usuario.getUsuario());
		doc.setPassword(usuario.getPassword());
		doc.setUsuarioOperacional(usuario.getUsuarioOperacional());
		doc.setDocumento(webFileItem.getFileItem().getFile());
		doc.setDescripcionDocumento(webFileItem.getFileItem().getFileName());
//		doc.setGeneralDocumento(rellenarGeneralDocumento(arrayMatricula[1], arrayMatricula[2], arrayMatricula[3]));
		doc.setGeneralDocumento(rellenarGeneralDocumento("01", "ESCR", "27"));
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
	
	public static CrearVersionDto getCrearVersionDto(UsuarioPasswordDto usuario, String login) {
		CrearVersionDto dto = new CrearVersionDto();
		
		dto.setUsuario(usuario.getUsuario());
		dto.setPassword(usuario.getPassword());
		dto.setUsuarioOperacional(login);
		dto.setDocumento(null);
		
		return dto;
	}
	
	
	public static CrearVersionMetadatosDto getCrearVersionMetadatosDto(UsuarioPasswordDto usuario, String login){
		CrearVersionMetadatosDto dto = new CrearVersionMetadatosDto();
		
		dto.setUsuario(usuario.getUsuario());
		dto.setPassword(usuario.getPassword());
		dto.setUsuarioOperacional(login);
		dto.setGeneralDocumentoModif(rellenarGeneralDocumentoModif());
		dto.setDocumento(null);
		dto.setArchivoFisico(rellenarArchivoFisico());
		
		return dto;
	}
	
	
	public static ModificarMetadatosDto getModificarMetadatosDto(UsuarioPasswordDto usuario, String login) {
		ModificarMetadatosDto dto = new ModificarMetadatosDto();
		
		dto.setUsuario(usuario.getUsuario());
		dto.setPassword(usuario.getPassword());
		dto.setUsuarioOperacional(login);
		dto.setGeneralDocumentoModif(rellenarGeneralDocumentoModif());
		dto.setArchivoFisico(rellenarArchivoFisico());
		
		return dto;
	}
	
	public static UsuarioPasswordDto getUsuarioPasswordDto(String usuario, String password, String usuarioOperacional) {
		UsuarioPasswordDto usuarioPass = new UsuarioPasswordDto();

		usuarioPass.setUsuario(usuario);
		usuarioPass.setPassword(password); 
		usuarioPass.setUsuarioOperacional(usuarioOperacional);
		return usuarioPass;
	}
	
}

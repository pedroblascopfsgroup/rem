package es.pfsgroup.plugin.gestorDocumental.dto.documentos;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Properties;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;

public class RecoveryToGestorDocAssembler {
	
	private static final String ALTA = "ALTA";
	private static final String PROCESO_CARGA = "WEB SERVICE REM";
	
	private static String OPWS = "srv.rem"; 
	private String USUARIO;
	private String PASSWORD;
	private final String TIPO_EXPEDIENTE="Global";

	public RecoveryToGestorDocAssembler(Properties appProperties){
		USUARIO = appProperties.getProperty("rest.client.gestor.documental.user");
		PASSWORD = appProperties.getProperty("rest.client.gestor.documental.pass");
		OPWS = appProperties.getProperty("rest.client.gestor.documental.opws");
		
		if(Checks.esNulo(OPWS)) {
			OPWS = "srv.rem"; 
		}
	}
	
	public CabeceraPeticionRestClientDto getCabeceraPeticionRestClient(String idExp, String tipoExp, String claseExp) {

		CabeceraPeticionRestClientDto cabecera = new CabeceraPeticionRestClientDto();
		cabecera.setIdExpedienteHaya(idExp);
		cabecera.setCodTipo(tipoExp); 
		cabecera.setCodClase(claseExp);
		return cabecera;
	}

	public DocumentosExpedienteDto getDocumentosExpedienteDto(String userLogin) {

		DocumentosExpedienteDto doc = new DocumentosExpedienteDto();
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setTipoConsulta(TIPO_EXPEDIENTE);//HREOS-2296
		doc.setVinculoDocumento(true);//HREOS-2296
		doc.setVinculoExpediente(false);
		
		if(!Checks.esNulo(userLogin) && userLogin.equals("REST-USER") ) {
			doc.setUsuarioOperacional(OPWS);
		} else {
			doc.setUsuarioOperacional(userLogin);
		}
		
		return doc;
	}
	
	public BajaDocumentoDto getDescargaDocumentoDto(String userLogin) {
		BajaDocumentoDto login = new BajaDocumentoDto();
		login.setUsuario(USUARIO);
		login.setPassword(PASSWORD);
		
		if(!Checks.esNulo(userLogin) && userLogin.equals("REST-USER") ) {
			login.setUsuarioOperacional(OPWS);
		} else {
			login.setUsuarioOperacional(userLogin);
		}
		
		return login;
	}
	

	public CrearDocumentoDto getCrearDocumentoDto(WebFileItem webFileItem, String userLogin, String matricula) {
		CrearDocumentoDto doc = new CrearDocumentoDto();

		String[] arrayMatricula = new String[4];
		if (matricula!=null && matricula.contains("-")) {
			arrayMatricula = matricula.split("-");
		}
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		
		if(!Checks.esNulo(userLogin) && userLogin.equals("REST-USER") ) {
			doc.setUsuarioOperacional(OPWS);
		} else {
			doc.setUsuarioOperacional(userLogin);
		}
		//TODO Rellenar el dto cuando vengan los campos del formulario relleno. Si no está relleno no añadir nada.
		doc.setDocumento(webFileItem.getFileItem().getFile());
		doc.setNombreDocumento(webFileItem.getFileItem().getFileName());
		doc.setDescripcionDocumento(webFileItem.getParameter("descripcion"));
		doc.setGeneralDocumento(rellenarGeneralDocumento(arrayMatricula[1], arrayMatricula[2], arrayMatricula[3]));
		doc.setArchivoFisico("{}");
		
		return doc;
	}

	private String rellenarGeneralDocumento (String serie, String tdn1, String tdn2) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
			sb.append(GestorDocumentalConstants.modificarMetadatos[0]).append("{");
				sb.append(GestorDocumentalConstants.modificarMetadatos[1]).append("\""+ALTA+"\"").append(",");
				sb.append(GestorDocumentalConstants.modificarMetadatos[2]).append("\""+serie+"\"").append(",");
				sb.append(GestorDocumentalConstants.modificarMetadatos[3]).append("\""+tdn1+"\"").append(",");
				sb.append(GestorDocumentalConstants.modificarMetadatos[4]).append("\""+tdn2+"\"").append(",");
				sb.append(GestorDocumentalConstants.modificarMetadatos[5]).append("\"" + PROCESO_CARGA + "\"").append("},");
				sb.append(GestorDocumentalConstants.modificarMetadatos[6]).append("{");
				sb.append(GestorDocumentalConstants.modificarMetadatos[7]).append("\"CONT\"");
			sb.append("}");
		sb.append("}");
		return sb.toString();
	}
	
	private String rellenarGeneralDocumentoModif() {
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
	
	private String rellenarArchivoFisico() {
		StringBuilder sb = new StringBuilder();
		sb.append(GestorDocumentalConstants.archivoFisico[0]).append("Proveedor Custodia").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[1]).append("Referencia Custodia").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[2]).append("Contenedor").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[3]).append("Lote").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[4]).append("Posición").append(", ");
		sb.append(GestorDocumentalConstants.archivoFisico[5]).append("Documento Original");
		return sb.toString();
	}
	
	public CrearVersionDto getCrearVersionDto(String login) {
		CrearVersionDto dto = new CrearVersionDto();
		
		dto.setUsuario(USUARIO);
		dto.setPassword(PASSWORD);
		
		if(!Checks.esNulo(login) && login.equals("REST-USER") ) {
			dto.setUsuarioOperacional(OPWS);
		} else {
			dto.setUsuarioOperacional(login);
		}
		
		dto.setDocumento(null);
		
		return dto;
	}
	
	
	public CrearVersionMetadatosDto getCrearVersionMetadatosDto(String login){
		CrearVersionMetadatosDto dto = new CrearVersionMetadatosDto();
		
		dto.setUsuario(USUARIO);
		dto.setPassword(PASSWORD);
		
		if(!Checks.esNulo(login) && login.equals("REST-USER") ) {
			dto.setUsuarioOperacional(OPWS);
		} else {
			dto.setUsuarioOperacional(login);
		}
		
		dto.setGeneralDocumentoModif(rellenarGeneralDocumentoModif());
		dto.setDocumento(null);
		dto.setArchivoFisico(rellenarArchivoFisico());
		
		return dto;
	}
	
	
	public ModificarMetadatosDto getModificarMetadatosDto(String login) {
		ModificarMetadatosDto dto = new ModificarMetadatosDto();
		
		dto.setUsuario(USUARIO);
		dto.setPassword(PASSWORD);
		
		if(!Checks.esNulo(login) && login.equals("REST-USER") ) {
			dto.setUsuarioOperacional(OPWS);
		} else {
			dto.setUsuarioOperacional(login);
		}
		
		dto.setGeneralDocumentoModif(rellenarGeneralDocumentoModif());
		dto.setArchivoFisico(rellenarArchivoFisico());
		
		return dto;
	}
	
	public BajaDocumentoDto getBajaDocumentoDto(String login) {
		BajaDocumentoDto baja = new BajaDocumentoDto();
		
		baja.setUsuario(USUARIO);
		baja.setPassword(PASSWORD);

		if(!Checks.esNulo(login) && login.equals("REST-USER") ) {
			baja.setUsuarioOperacional(OPWS);
		} else {
			baja.setUsuarioOperacional(login);
		}
		
		return baja;
	}
	
	
	public CredencialesUsuarioDto getCredencialesDto(String login) {
		CredencialesUsuarioDto credUsu = new CredencialesUsuarioDto();
		
		credUsu.setUsuario(USUARIO);
		credUsu.setPassword(PASSWORD);
		
		if(!Checks.esNulo(login) && login.equals("REST-USER") ) {
			credUsu.setUsuarioOperacional(OPWS);
		} else {
			credUsu.setUsuarioOperacional(login);
		}
		
		return credUsu;
	}
	
	public CrearContenedorDto getCrearEntidadlDto(String idEntidad, String username, String cliente, String idSistemaOrigen, String codClase) {
		CrearContenedorDto doc = new CrearContenedorDto();
		
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setCodClase(codClase);
		
		if(!Checks.esNulo(username) && username.equals("REST-USER") ) {
			doc.setUsuarioOperacional(OPWS);
		} else {
			doc.setUsuarioOperacional(username);
		}
		
		doc.setMetadata(rellenarEntidadMetadata(idEntidad, idEntidad, idSistemaOrigen, cliente));
		
		return doc;
	}
	
	private static String rellenarEntidadMetadata (String id, String idExterno, String idSistemaOrigen, String cliente) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
			sb.append(GestorDocumentalConstants.ENTIDAD).append("{");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[0]).append("\"").append(id).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[1]).append("\"").append(idExterno).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[2]).append("\"").append(idSistemaOrigen).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[3]).append("\"").append(cliente).append("\"");
			sb.append("}");
		sb.append("}");
		return sb.toString();
	}
	
	public CrearDocumentoDto getCrearDocumentoComunicacionGencatDto(WebFileItem webFileItem, String userLogin, String matricula, String fechaDocumento) {
		CrearDocumentoDto doc = new CrearDocumentoDto();
		String[] arrayMatricula = new String[4];
		if (matricula!=null && matricula.contains("-")) {
			arrayMatricula = matricula.split("-");
		}
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		
		if(!Checks.esNulo(userLogin) && userLogin.equals("REST-USER") ) {
			doc.setUsuarioOperacional(OPWS);
		} else {
			doc.setUsuarioOperacional(userLogin);
		}
		
		doc.setDocumento(webFileItem.getFileItem().getFile());
		doc.setNombreDocumento(webFileItem.getFileItem().getFileName());
		doc.setDescripcionDocumento(webFileItem.getParameter("descripcion"));
		doc.setGeneralDocumento(rellenarGeneralDocumentoComuncacionGencat(arrayMatricula[1], arrayMatricula[2], arrayMatricula[3],fechaDocumento));
		doc.setArchivoFisico("{}");
		
		return doc;
	}
	
	private String rellenarGeneralDocumentoComuncacionGencat (String serie, String tdn1, String tdn2, String fechaDocumento) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
			sb.append(GestorDocumentalConstants.metadataComunicaciones[0]).append("{");
				sb.append(GestorDocumentalConstants.metadataComunicaciones[1]).append("\""+fechaDocumento+"\"").append(",");
				sb.append(GestorDocumentalConstants.metadataComunicaciones[2]).append("\""+serie+"\"").append(",");
				sb.append(GestorDocumentalConstants.metadataComunicaciones[3]).append("\""+tdn1+"\"").append(",");
				sb.append(GestorDocumentalConstants.metadataComunicaciones[4]).append("\""+tdn2+"\"").append(",");
				sb.append(GestorDocumentalConstants.metadataComunicaciones[5]).append("\"" + PROCESO_CARGA + "\"").append("},");
				sb.append(GestorDocumentalConstants.metadataComunicaciones[6]).append("{");
				sb.append(GestorDocumentalConstants.metadataComunicaciones[7]).append("\"CONT\"");
			sb.append("}");
		sb.append("}");
		return sb.toString();
	}
	
	private String rellenarMetadatosEspecificos (DtoMetadatosEspecificos dto) {
		StringBuilder sb = new StringBuilder();
		String eliminarComas = "";
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat fromUser = new SimpleDateFormat("dd/MM/yyyy");
		try {
			
			sb.append("{");
			if(dto.getAplica() != null) {
				sb.append(GestorDocumentalConstants.metadataEspecifica[0]).append("\""+dto.getAplica()+"\"").append(",");
			}
			if(dto.getFechaEmision() != null) {
				String fechaEmision = format.format(fromUser.parse(dto.getFechaEmision()));
				sb.append(GestorDocumentalConstants.metadataEspecifica[1]).append("\""+fechaEmision+"\"").append(",");
			}
			if(dto.getFechaCaducidad()!= null) {
				String fechaCaducidad = format.format(fromUser.parse(dto.getFechaCaducidad()));
				sb.append(GestorDocumentalConstants.metadataEspecifica[2]).append("\""+fechaCaducidad+"\"").append(",");
			}
			if(dto.getFechaObtencion()!= null) {
				String fechaObtencion = format.format(fromUser.parse(dto.getFechaObtencion()));
				sb.append(GestorDocumentalConstants.metadataEspecifica[3]).append("\""+fechaObtencion+"\"").append(",");
			}
			if(dto.getFechaEtiqueta()!= null) {
				String fechaEtiqueta = format.format(fromUser.parse(dto.getFechaEtiqueta()));
				sb.append(GestorDocumentalConstants.metadataEspecifica[4]).append("\""+fechaEtiqueta+"\"").append(",");
			}
			if(dto.getRegistro()!= null) {
				sb.append(GestorDocumentalConstants.metadataEspecifica[5]).append("\""+dto.getRegistro()+"\"");
			}

			eliminarComas = sb.toString();
			if(",".equals(eliminarComas.substring(eliminarComas.length() - 1))){
				sb.deleteCharAt(eliminarComas.length()-1);
			}
			sb.append("}");
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return sb.toString();
	}
	
	public CrearDocumentoDto getCrearDocumentoDtoConFormulario(WebFileItem webFileItem, String userLogin, String matricula, DtoMetadatosEspecificos dto) {
		CrearDocumentoDto doc = new CrearDocumentoDto();

		String[] arrayMatricula = new String[4];
		if (matricula!=null && matricula.contains("-")) {
			arrayMatricula = matricula.split("-");
		}
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		
		if(!Checks.esNulo(userLogin) && userLogin.equals("REST-USER") ) {
			doc.setUsuarioOperacional(OPWS);
		} else {
			doc.setUsuarioOperacional(userLogin);
		}
		//TODO Rellenar el dto cuando vengan los campos del formulario relleno. Si no está relleno no añadir nada.
		doc.setDocumento(webFileItem.getFileItem().getFile());
		doc.setNombreDocumento(webFileItem.getFileItem().getFileName());
		doc.setDescripcionDocumento(webFileItem.getParameter("descripcion"));
		doc.setGeneralDocumento(rellenarGeneralDocumento(arrayMatricula[1], arrayMatricula[2], arrayMatricula[3]));
		doc.setMetadatatdn1(rellenarMetadatosEspecificos(dto));
		doc.setArchivoFisico("{}");
		
		return doc;
	}
}

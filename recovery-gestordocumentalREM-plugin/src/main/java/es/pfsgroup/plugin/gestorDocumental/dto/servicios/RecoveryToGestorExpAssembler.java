package es.pfsgroup.plugin.gestorDocumental.dto.servicios;

import java.util.Properties;

import es.pfsgroup.plugin.gestorDocumental.dto.documentos.UsuarioPasswordDto;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;

public class RecoveryToGestorExpAssembler {

	
	private String USUARIO;
	private String PASSWORD;

	public RecoveryToGestorExpAssembler(Properties appProperties){
		USUARIO = appProperties.getProperty("rest.client.gestor.documental.user");
		PASSWORD = appProperties.getProperty("rest.client.gestor.documental.pass");
	}
	
	public CrearPropuestaDto getCrearPropuestaDto(String idAsunto, String claseExpe, UsuarioPasswordDto usuPass) {
		CrearPropuestaDto doc = new CrearPropuestaDto();
	
		doc.setUsuario(usuPass.getUsuario());
		doc.setPassword(usuPass.getPassword());
		doc.setCodClase(claseExpe);
		doc.setDescripcionExpediente("");
		doc.setPropuestaMetadatos(rellenarPropuestaMetadatos(idAsunto));
		
		return doc;
	}

	
	private String rellenarPropuestaMetadatos (String idAsunto) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
		//sb.append(GestorDocumentalConstants.propuestaMetadatos[0]).append(idAsunto).append(",");
		//sb.append(GestorDocumentalConstants.propuestaMetadatos[11]).append("Sareb");
		sb.append("}");
		return sb.toString();
	}
	
	public CrearGastoDto getCrearGastoDto(String id, String numgasto, String idReo, String fechaGasto, String cliente,  String descripcionExpediente, String userLogin) {
		CrearGastoDto doc = new CrearGastoDto();
	
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setCodClase(GestorDocumentalConstants.CODIGO_CLASE_GASTO);
		doc.setUsuarioOperacional(userLogin);
		doc.setDescripcionExpediente(descripcionExpediente);
		doc.setGastoMetadatos(rellenarGastoMetadatos(id, numgasto, idReo, fechaGasto, cliente));
		
		return doc;
	}

	
	private static String rellenarGastoMetadatos (String id, String numGasto, String idReo, String fechaGasto, String cliente) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
			sb.append(GestorDocumentalConstants.GASTOS).append("{");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[0]).append("\"").append(id).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[1]).append("\"").append(numGasto).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[2]).append("\"").append(idReo).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[3]).append("\"").append(cliente).append("\"");
			sb.append("}");
		sb.append("}");
		return sb.toString();
	}

	public CrearExpedienteComercialDto getCrearExpedienteComercialDto(String idExpedienteComercial, String descripcionExpediente, String username, String cliente, String estadoExpediente, String idSistemaOrigen, String codClase, String tipoExpediente) {
		CrearExpedienteComercialDto doc = new CrearExpedienteComercialDto();
		
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setCodClase(codClase);
		doc.setUsuarioOperacional(username);
		doc.setDescripcionExpediente(descripcionExpediente);
		doc.setOperacionMetadatos(rellenarExpedienteComercialMetadatos(idExpedienteComercial, idExpedienteComercial, idSistemaOrigen, estadoExpediente, cliente));
		doc.setTipoClase(tipoExpediente);
		return doc;
	}
	
	private static String rellenarExpedienteComercialMetadatos (String id, String idExterno, String idSistemaOrigen, String estadoExpediente, String cliente) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
			sb.append(GestorDocumentalConstants.OPERACION).append("{");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[0]).append("\"").append(id).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[1]).append("\"").append(idExterno).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[2]).append("\"").append(idSistemaOrigen).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[3]).append("\"").append(cliente).append("\"");
			sb.append("}");
		sb.append("}");
		return sb.toString();
	}
	
	public CrearEntidadCompradorDto getCrearActivoOferta(String idIntervinienteHaya, String username, String cliente, String idSistemaOrigen, String codClase, String descripcionEntidad, String tipoActivoOferta) {
		CrearEntidadCompradorDto doc = new CrearEntidadCompradorDto();

		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setCodClase(codClase);
		doc.setUsuarioOperacional(username);
		doc.setDescripcionEntidad(descripcionEntidad);
		doc.setOperacionMetadatos(rellenarActivoOfertaMetadatos(idIntervinienteHaya, idIntervinienteHaya, idSistemaOrigen, cliente));
		doc.setTipoClase(tipoActivoOferta);
		return doc;
	}

	private static String rellenarActivoOfertaMetadatos (String id, String idExterno, String idSistemaOrigen, String cliente) {
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

	public CrearActuacionTecnicaDto getCrearActuacionTecnicaDto(String idTrabajo, String descripcionActuacion, String username, String cliente, String estadoTrabajo, String idSistemaOrigen, String codClase, String tipoTrabajo) {
		CrearActuacionTecnicaDto doc = new CrearActuacionTecnicaDto();

		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setCodClase(codClase);
		doc.setTipoClase(tipoTrabajo);
		doc.setUsuarioOperacional(username);
		doc.setDescripcionActuacion(descripcionActuacion);
		doc.setOperacionMetadatos(rellenarActuacionTecnicaMetadatos(idTrabajo, idTrabajo, idSistemaOrigen, estadoTrabajo, cliente));

		return doc;
	}

	private static String rellenarActuacionTecnicaMetadatos (String id, String idExterno, String idSistemaOrigen, String estadoTrabajo, String cliente) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
			sb.append(GestorDocumentalConstants.OPERACION).append("{");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[0]).append("\"").append(id).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[1]).append("\"").append(idExterno).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[2]).append("\"").append(idSistemaOrigen).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[3]).append("\"").append(cliente).append("\"");
			sb.append("}");
		sb.append("}");
		return sb.toString();
	}
	
	// --------------------------------------------------- JUNTAS -------------------------------------------------------------------
		
	public CrearJuntaDto getCrearJuntaDto(String idJunta, String descripcionJunta, String username, String cliente, String idSistemaOrigen, String codClase, String tipoTrabajo) {
		CrearJuntaDto doc = new CrearJuntaDto();
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setCodClase(codClase);
		doc.setTipoClase(tipoTrabajo);
		doc.setUsuarioOperacional(username);
		doc.setDescripcionJunta(descripcionJunta);
		doc.setOperacionMetadatos(rellenarJuntaMetadatos(idJunta, idJunta, idSistemaOrigen, cliente));
		return doc;
	}
	public CrearPlusvaliaDto getCrearPlusvaliaDto(String idPlusvalia, String descripcionPlusvalia,String username,String cliente,String idSistemaOrigen,String codClase,String tipoTrabajo) {
		CrearPlusvaliaDto doc = new CrearPlusvaliaDto();
		doc.setUsuario(USUARIO);
		doc.setPassword(PASSWORD);
		doc.setCodClase(codClase);
		doc.setTipoClase(tipoTrabajo);
		doc.setUsuarioOperacional(username);
		doc.setDescripcionPlusvalia(descripcionPlusvalia);
		doc.setOperacionMetadatos(rellenarPlusvaliaMetadatos(idPlusvalia, idPlusvalia, idSistemaOrigen, cliente));
		return doc;
	}
	private static String rellenarJuntaMetadatos (String id, String idExterno, String idSistemaOrigen, String cliente) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
			sb.append(GestorDocumentalConstants.OPERACION).append("{");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[0]).append("\"").append(id).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[1]).append("\"").append(idExterno).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[2]).append("\"").append(idSistemaOrigen).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[3]).append("\"").append(cliente).append("\"");
			sb.append("}");
		sb.append("}");
		return sb.toString();
	}

	private static String rellenarPlusvaliaMetadatos (String id, String idExterno, String idSistemaOrigen, String cliente) {
		StringBuilder sb = new StringBuilder();
		sb.append("{");
			sb.append(GestorDocumentalConstants.OPERACION).append("{");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[0]).append("\"").append(id).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[1]).append("\"").append(idExterno).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[2]).append("\"").append(idSistemaOrigen).append("\"").append(",");
				sb.append(GestorDocumentalConstants.metadataCrearContenedor[3]).append("\"").append(cliente).append("\"");
			sb.append("}");
		sb.append("}");
		return sb.toString();
	}
}

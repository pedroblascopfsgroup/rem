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
		sb.append(GestorDocumentalConstants.gastoMetadatos[0]).append("'"+id+"'").append(",");
		sb.append(GestorDocumentalConstants.gastoMetadatos[1]).append("'"+numGasto+"'").append(",");
		sb.append(GestorDocumentalConstants.gastoMetadatos[2]).append("'"+idReo+"'").append(",");
		sb.append(GestorDocumentalConstants.gastoMetadatos[3]).append("'"+fechaGasto+"'").append(",");
		sb.append(GestorDocumentalConstants.gastoMetadatos[4]).append("'"+cliente+"'");
		sb.append("}");
		return sb.toString();
	}
	
	
}

package es.pfsgroup.plugin.precontencioso.burofax.api;

import java.io.File;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;

public interface DocumentoBurofaxApi {

	HashMap<String, Object> obtenerMapeoVariables(EnvioBurofaxPCO envioBurofax);

	String parseoFinalBurofax(String contenidoParseadoIntermedio,
			HashMap<String, Object> mapeoVariables);

	Map<String, String> obtenerCabecera(EnvioBurofaxPCO envioBurofaxPCO, String contexto, boolean esBFA);

	InputStream obtenerPlantillaBurofax(String proyectoRecovery, boolean esBFA);

	FileItem generarDocumentoBurofax(InputStream plantillaBurofax,
			String nombreFichero, Map<String,String> cabecera, String contenidoParseadoFinal);

	File convertirAPdf(FileItem archivoBurofax, String nombreFicheroPdfSalida);

	String obtenerNombreFicheroPdf(String nombreFichero);

	String replaceVariablesGeneracionBurofax(Long idPcoBurofax, String textoBuro, DocumentoPCO doc);
	
	boolean isOperacionBFA(Contrato contrato, String contexto);
}

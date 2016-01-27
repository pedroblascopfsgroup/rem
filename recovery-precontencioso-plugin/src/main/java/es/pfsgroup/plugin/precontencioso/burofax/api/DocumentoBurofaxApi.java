package es.pfsgroup.plugin.precontencioso.burofax.api;

import java.io.File;
import java.io.InputStream;
import java.util.HashMap;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;

public interface DocumentoBurofaxApi {

	HashMap<String, Object> obtenerMapeoVariables(EnvioBurofaxPCO envioBurofax);

	String parseoFinalBurofax(String contenidoParseadoIntermedio,
			HashMap<String, Object> mapeoVariables);

	String obtenerCabecera(EnvioBurofaxPCO envioBurofaxPCO, String contexto);

	InputStream obtenerPlantillaBurofax();

	FileItem generarDocumentoBurofax(InputStream plantillaBurofax,
			String nombreFichero, String cabecera, String contenidoParseadoFinal);

	File convertirAPdf(FileItem archivoBurofax, String nombreFicheroPdfSalida);

	String obtenerNombreFicheroPdf(String nombreFichero);

	String replaceVariablesGeneracionBurofax(Long idPcoBurofax, String textoBuro);
}

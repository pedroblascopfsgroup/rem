package es.pfsgroup.plugin.precontencioso.liquidacion.api;

import es.capgemini.devon.files.FileItem;

public interface GenerarLiquidacionApi {

	public static final String DIRECTORIO_PLANTILLAS_LIQUIDACION = "directorioPlantillasLiquidacion";

	FileItem generarDocumento(Long idLiquidacion);
	
}

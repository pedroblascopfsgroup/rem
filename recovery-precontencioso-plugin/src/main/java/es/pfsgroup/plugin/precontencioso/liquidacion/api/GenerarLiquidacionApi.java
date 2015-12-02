package es.pfsgroup.plugin.precontencioso.liquidacion.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;

public interface GenerarLiquidacionApi {

	public static final String DIRECTORIO_PLANTILLAS_LIQUIDACION = "directorioPlantillasLiquidacion";

	public FileItem generarDocumento(Long idLiquidacion, Long idPlantilla);
	
	public List<DDTipoLiquidacionPCO> getPlantillasLiquidacion();
	
}

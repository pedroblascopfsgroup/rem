package es.pfsgroup.plugin.precontencioso.liquidacion.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;

public interface GenerarDocumentoApi {

	public static final String DIRECTORIO_PLANTILLAS_LIQUIDACION = "directorioPlantillasLiquidacion";

	public FileItem generarDocumento(Long idLiquidacion, Long idPlantilla);
	
	public FileItem generarCertificadoSaldo(Long idLiquidacion, Long idPlantilla, String codigoPropietaria, String localidadFirma);
	
}

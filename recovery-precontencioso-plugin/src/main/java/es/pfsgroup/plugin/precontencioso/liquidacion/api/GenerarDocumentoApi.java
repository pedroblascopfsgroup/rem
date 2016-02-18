package es.pfsgroup.plugin.precontencioso.liquidacion.api;

import es.capgemini.devon.files.FileItem;

public interface GenerarDocumentoApi {

	public static final String DIRECTORIO_PLANTILLAS_LIQUIDACION = "directorioPlantillasLiquidacion";
	public static final String DIRECTORIO_PLANTILLAS_PRECONTENCIOSO = "directorioPlantillasPrecontencioso";

	public FileItem generarDocumento(Long idLiquidacion, Long idPlantilla);
	
	public FileItem generarCertificadoSaldo(Long idLiquidacion, Long idPlantilla, String codigoPropietaria, String localidadFirma, String notario);
	
	public FileItem generarInstanciaRegistro(Long idLiquidacion, Long idPlantilla, String codigoPropietaria, String localidadFirma);

	public FileItem generarCartaNotario(Long idLiquidacion, String notario,	String localidadNotario, String adjuntosAdicionales,
			String codigoPropietaria, String centro, String localidadFirma);
	
}

package es.pfsgroup.framework.paradise.bulkUpload.dto;

public class MSVDtoResultadoSubidaFicheroMasivo {
	
	private Long idProceso;
	
	private Long idFichero;
	
	private String nombreFichero;
	

	public void setIdFichero(Long idFichero) {
		this.idFichero = idFichero;
	}

	public Long getIdFichero() {
		return idFichero;
	}

	public void setIdProceso(Long idProceso) {
		this.idProceso = idProceso;
	}

	public Long getIdProceso() {
		return idProceso;
	}

	public void setNombreFichero(String nombreFichero) {
		this.nombreFichero = nombreFichero;
	}

	public String getNombreFichero() {
		return nombreFichero;
	}
	

}

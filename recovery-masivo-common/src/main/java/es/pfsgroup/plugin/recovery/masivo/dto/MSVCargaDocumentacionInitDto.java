package es.pfsgroup.plugin.recovery.masivo.dto;

import es.pfsgroup.plugin.recovery.masivo.utils.MSVUtils;


public class MSVCargaDocumentacionInitDto {

	private String directorio;
	private String mascara;
	private String rutaBackup;
	private Boolean hacerBackup;
	private Boolean borrarArchivos;

	public String getDirectorio() {
		return directorio;
	}

	public void setDirectorio(String directorio) {
		this.directorio = (directorio.endsWith("/")) ? directorio : directorio + "/";
	}

	public String getMascara() {
		return mascara;
	}

	public void setMascara(String mascara) {		
		setMascara(mascara, "");
	}

	/**
	 * inicializa la mascara reemplazando el workingcode y la fecha
	 * @param mascara
	 * @param workingCode
	 */
	public void setMascara(String mascara, String workingCode) {		
		this.mascara = mascara.replace("|workingcode|", workingCode);
		this.mascara = this.mascara.replace("|fecha|", MSVUtils.getNow("yyyyMMdd"));
	}

	public String getRutaBackup() {
		return rutaBackup;
	}

	public void setRutaBackup(String rutaBackup) {
		this.rutaBackup = (rutaBackup.endsWith("/")) ? rutaBackup : rutaBackup + "/";
	}

	public Boolean getHacerBackup() {
		return hacerBackup;
	}

	public void setHacerBackup(Boolean hacerBackup) {
		this.hacerBackup = hacerBackup;
	}

	public Boolean getBorrarArchivos() {
		return borrarArchivos;
	}

	public void setBorrarArchivos(Boolean borrarArchivos) {
		this.borrarArchivos = borrarArchivos;
	}

}

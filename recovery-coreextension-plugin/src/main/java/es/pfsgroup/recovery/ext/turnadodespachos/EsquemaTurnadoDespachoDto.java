package es.pfsgroup.recovery.ext.turnadodespachos;


public class EsquemaTurnadoDespachoDto {

	private Long id;
	private String turnadoCodigoImporteLitigios;
	private String turnadoCodigoImporteConcursal;
    private String turnadoCodigoCalidadConcursal;
    private String turnadoCodigoCalidadLitigios;
    
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
		
	/**
	 * @return the turnadoCodigoImporteLitigios
	 */
	public String getTurnadoCodigoImporteLitigios() {
		return turnadoCodigoImporteLitigios;
	}
	/**
	 * @param turnadoCodigoImporteLitigios the turnadoCodigoImporteLitigios to set
	 */
	public void setTurnadoCodigoImporteLitigios(String turnadoCodigoImporteLitigios) {
		this.turnadoCodigoImporteLitigios = turnadoCodigoImporteLitigios;
	}
	/**
	 * @return the turnadoCodigoImporteConcursal
	 */
	public String getTurnadoCodigoImporteConcursal() {
		return turnadoCodigoImporteConcursal;
	}
	/**
	 * @param turnadoCodigoImporteConcursal the turnadoCodigoImporteConcursal to set
	 */
	public void setTurnadoCodigoImporteConcursal(
			String turnadoCodigoImporteConcursal) {
		this.turnadoCodigoImporteConcursal = turnadoCodigoImporteConcursal;
	}
	/**
	 * @return the turnadoCodigoCalidadConcursal
	 */
	public String getTurnadoCodigoCalidadConcursal() {
		return turnadoCodigoCalidadConcursal;
	}
	/**
	 * @param turnadoCodigoCalidadConcursal the turnadoCodigoCalidadConcursal to set
	 */
	public void setTurnadoCodigoCalidadConcursal(
			String turnadoCodigoCalidadConcursal) {
		this.turnadoCodigoCalidadConcursal = turnadoCodigoCalidadConcursal;
	}
	/**
	 * @return the turnadoCodigoCalidadLitigios
	 */
	public String getTurnadoCodigoCalidadLitigios() {
		return turnadoCodigoCalidadLitigios;
	}
	/**
	 * @param turnadoCodigoCalidadLitigios the turnadoCodigoCalidadLitigios to set
	 */
	public void setTurnadoCodigoCalidadLitigios(String turnadoCodigoCalidadLitigios) {
		this.turnadoCodigoCalidadLitigios = turnadoCodigoCalidadLitigios;
	}
	/**
	 * Valida el Dto para comprobar que está todo correcto.
	 * 
	 * @return
	 */
	public boolean validar() {
		return true;
	}	
}

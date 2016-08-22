package es.pfsgroup.framework.paradise.bulkUpload.dto;

public class MSVDtoAltaProceso {
	
	private Long idProceso;
	private Long idEstadoProceso;
	private Long idTipoOperacion;
	private String descripcion;
	private String codigoEstadoProceso;
	

	public void setIdTipoOperacion(Long idTipoOperacion) {
		this.idTipoOperacion = idTipoOperacion;
	}

	public Long getIdTipoOperacion() {
		return idTipoOperacion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setIdProceso(Long idProceso) {
		this.idProceso = idProceso;
	}

	public Long getIdProceso() {
		return idProceso;
	}

	public void setIdEstadoProceso(Long idEstadoProceso) {
		this.idEstadoProceso = idEstadoProceso;
	}

	public Long getIdEstadoProceso() {
		return idEstadoProceso;
	}

	public void setCodigoEstadoProceso(String codigoEstadoProceso) {
		this.codigoEstadoProceso = codigoEstadoProceso;
	}

	public String getCodigoEstadoProceso() {
		return codigoEstadoProceso;
	}

}

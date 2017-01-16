package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * DTO que gestiona los presupuestos presentados para un trabajo
 *  
 * @author Carlos Feliu
 *
 */
public class DtoRecargoProveedor extends WebDto {

	private static final long serialVersionUID = 1L;
	
	private String idRecargo;

	private Long idTrabajo;
	
	private String tipoCalculoCodigo;
	
	private String tipoCalculoDescripcion;
	
	private String tipoRecargoCodigo;
	
	private String tipoRecargoDescripcion;
	
	private Double importeCalculo;
	
	private Double importeFinal;

	public String getIdRecargo() {
		return idRecargo;
	}

	public void setIdRecargo(String idRecargo) {
		this.idRecargo = idRecargo;
	}

	public Long getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public String getTipoCalculoCodigo() {
		return tipoCalculoCodigo;
	}

	public void setTipoCalculoCodigo(String tipoCalculoCodigo) {
		this.tipoCalculoCodigo = tipoCalculoCodigo;
	}

	public String getTipoCalculoDescripcion() {
		return tipoCalculoDescripcion;
	}

	public void setTipoCalculoDescripcion(String tipoCalculoDescripcion) {
		this.tipoCalculoDescripcion = tipoCalculoDescripcion;
	}

	public String getTipoRecargoCodigo() {
		return tipoRecargoCodigo;
	}

	public void setTipoRecargoCodigo(String tipoRecargoCodigo) {
		this.tipoRecargoCodigo = tipoRecargoCodigo;
	}

	public String getTipoRecargoDescripcion() {
		return tipoRecargoDescripcion;
	}

	public void setTipoRecargoDescripcion(String tipoRecargoDescripcion) {
		this.tipoRecargoDescripcion = tipoRecargoDescripcion;
	}

	public Double getImporteCalculo() {
		return importeCalculo;
	}

	public void setImporteCalculo(Double importeCalculo) {
		this.importeCalculo = importeCalculo;
	}

	public Double getImporteFinal() {
		return importeFinal;
	}

	public void setImporteFinal(Double importeFinal) {
		this.importeFinal = importeFinal;
	}
	
	
}
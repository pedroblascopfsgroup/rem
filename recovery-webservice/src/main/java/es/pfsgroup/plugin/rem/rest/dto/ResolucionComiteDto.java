package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.sql.Date;

import javax.validation.constraints.NotNull;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class ResolucionComiteDto implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Oferta.class, message = "La ofertaHRE no existe", groups = { Insert.class, Update.class },foreingField="numOferta")
	private Long ofertaHRE;
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDComiteSancion.class, message = "El codigoComite no existe", groups = { Insert.class, Update.class })
	private String codigoComite;
	private Date fechaComite;
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDEstadoResolucion.class, message = "El codigoResolucion no existe", groups = { Insert.class, Update.class })
	private String codigoResolucion;
	@Diccionary(clase = DDEstadoResolucion.class, message = "El codigoDenegacion no existe", groups = { Insert.class, Update.class })
	private String codigoDenegacion;
	private Date fechaAnulacion;
	private Double importeContraoferta;
	
	
	
	public Long getOfertaHRE() {
		return ofertaHRE;
	}
	public void setOfertaHRE(Long ofertaHRE) {
		this.ofertaHRE = ofertaHRE;
	}
	public String getCodigoComite() {
		return codigoComite;
	}
	public void setCodigoComite(String codigoComite) {
		this.codigoComite = codigoComite;
	}
	public Date getFechaComite() {
		return fechaComite;
	}
	public void setFechaComite(Date fechaComite) {
		this.fechaComite = fechaComite;
	}
	public String getCodigoResolucion() {
		return codigoResolucion;
	}
	public void setCodigoResolucion(String codigoResolucion) {
		this.codigoResolucion = codigoResolucion;
	}
	public String getCodigoDenegacion() {
		return codigoDenegacion;
	}
	public void setCodigoDenegacion(String codigoDenegacion) {
		this.codigoDenegacion = codigoDenegacion;
	}
	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}
	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}
	public Double getImporteContraoferta() {
		return importeContraoferta;
	}
	public void setImporteContraoferta(Double importeContraoferta) {
		this.importeContraoferta = importeContraoferta;
	}

	
	
}

package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoEmailReservaDatosActivos extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private String sociedadPropietaria;
	private Long lineaFactura;
	private String fincaRegistral;
	private Double participacion;
	private String provincia;
	private String municipio;
	private String direccion;
	private String tipoCorreo;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getSociedadPropietaria() {
		return sociedadPropietaria;
	}
	public void setSociedadPropietaria(String sociedadPropietaria) {
		this.sociedadPropietaria = sociedadPropietaria;
	}
	public Long getLineaFactura() {
		return lineaFactura;
	}
	public void setLineaFactura(Long lineaFactura) {
		this.lineaFactura = lineaFactura;
	}
	public String getFincaRegistral() {
		return fincaRegistral;
	}
	public void setFincaRegistral(String fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}
	public Double getParticipacion() {
		return participacion;
	}
	public void setParticipacion(Double participacion) {
		this.participacion = participacion;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getMunicipio() {
		return municipio;
	}
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getTipoCorreo() {
		return tipoCorreo;
	}
	public void setTipoCorreo(String tipoCorreo) {
		this.tipoCorreo = tipoCorreo;
	}
	
}
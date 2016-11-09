package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoMovimientoLlave extends WebDto {
	
	private static final long serialVersionUID = 1L;
	
	private String id; //id Movimiento
	private String idLlave;
	private String numLlave;
	private String codigoTipoTenedor;
	private String descripcionTipoTenedor;
	private String codTenedor;	
	private String nomTenedor;
	private Date fechaEntrega;
	private Date fechaDevolucion;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIdLlave() {
		return idLlave;
	}
	public void setIdLlave(String idLlave) {
		this.idLlave = idLlave;
	}
	public String getNumLlave() {
		return numLlave;
	}
	public void setNumLlave(String numLlave) {
		this.numLlave = numLlave;
	}
	public String getCodigoTipoTenedor() {
		return codigoTipoTenedor;
	}
	public void setCodigoTipoTenedor(String codigoTipoTenedor) {
		this.codigoTipoTenedor = codigoTipoTenedor;
	}
	public String getDescripcionTipoTenedor() {
		return descripcionTipoTenedor;
	}
	public void setDescripcionTipoTenedor(String descripcionTipoTenedor) {
		this.descripcionTipoTenedor = descripcionTipoTenedor;
	}
	public String getCodTenedor() {
		return codTenedor;
	}
	public void setCodTenedor(String codTenedor) {
		this.codTenedor = codTenedor;
	}
	public String getNomTenedor() {
		return nomTenedor;
	}
	public void setNomTenedor(String nomTenedor) {
		this.nomTenedor = nomTenedor;
	}
	public Date getFechaEntrega() {
		return fechaEntrega;
	}
	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}
	public Date getFechaDevolucion() {
		return fechaDevolucion;
	}
	public void setFechaDevolucion(Date fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
	}

}

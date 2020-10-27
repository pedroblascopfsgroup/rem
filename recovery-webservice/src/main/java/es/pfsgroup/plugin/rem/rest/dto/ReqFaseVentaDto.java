package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class ReqFaseVentaDto implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idReq;
	private Long idActivo;
	private String fechapreciomaximo;
	private String fecharespuestaorg;
	private Double preciomaximo;
	private String fechavencimiento;
	private String usuariocrear;
	private String fechacrear;
	
	public Long getIdReq() {
		return idReq;
	}
	public void setIdReq(Long idReq) {
		this.idReq = idReq;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getFechapreciomaximo() {
		return fechapreciomaximo;
	}
	public void setFechapreciomaximo(String fechapreciomaximo) {
		this.fechapreciomaximo = fechapreciomaximo;
	}
	public String getFecharespuestaorg() {
		return fecharespuestaorg;
	}
	public void setFecharespuestaorg(String fecharespuestaorg) {
		this.fecharespuestaorg = fecharespuestaorg;
	}
	public Double getPreciomaximo() {
		return preciomaximo;
	}
	public void setPreciomaximo(Double preciomaximo) {
		this.preciomaximo = preciomaximo;
	}
	public String getFechavencimiento() {
		return fechavencimiento;
	}
	public void setFechavencimiento(String fechavencimiento) {
		this.fechavencimiento = fechavencimiento;
	}
	public String getUsuariocrear() {
		return usuariocrear;
	}
	public void setUsuariocrear(String usuariocrear) {
		this.usuariocrear = usuariocrear;
	}
	public String getFechacrear() {
		return fechacrear;
	}
	public void setFechacrear(String fechacrear) {
		this.fechacrear = fechacrear;
	}
	
}

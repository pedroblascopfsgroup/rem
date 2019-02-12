package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;

public class DtoMotivoAnulacionExpediente extends WebDto implements Comparable<DtoMotivoAnulacionExpediente>{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id;
	private String codigo;
	private String descripcion;
	private String descripcionLarga;
	private Boolean alquiler;
	private Boolean venta;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}
	public boolean getAlquiler() {
		return alquiler;
	}
	public void setAlquiler(Boolean alquiler) {
		this.alquiler = alquiler;
	}
	public Boolean getVenta() {
		return venta;
	}
	public void setVenta(Boolean venta) {
		this.venta = venta;
	}
	@Override
	public int compareTo(DtoMotivoAnulacionExpediente o) {
		
		if(!Checks.esNulo(this.getCodigo()) || !Checks.esNulo(o.getCodigo())){
			if(Checks.esNulo(this.getCodigo())){
				return -1;
			}
			else if(Checks.esNulo(o.getCodigo())){
				return 1;
			}
			return o.getCodigo().compareTo(this.getCodigo());
		}
		else{
			return o.getId().compareTo(this.getId());
		}
	}
	
}

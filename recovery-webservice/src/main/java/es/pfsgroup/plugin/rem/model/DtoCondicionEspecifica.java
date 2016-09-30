package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoCondicionEspecifica {

	private String id;
	private Long idActivo;
    private String texto;
    private Date fechaDesde;
    private Date fechaHasta;
    private String usuarioAlta;
    private String usuarioBaja;
    
    public String getId(){
    	return id;
    }
    public void setId(String id){
    	this.id = id;
    }
    public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public void setIdEntidad(Long idEntidad) {
		this.idActivo = idEntidad;
	}
	public String getTexto() {
		return texto;
	}
	public void setTexto(String texto) {
		this.texto = texto;
	}
	public Date getFechaDesde() {
		return fechaDesde;
	}
	public void setFechaDesde(Date fechaDesde) {
		this.fechaDesde = fechaDesde;
	}
	public Date getFechaHasta() {
		return fechaHasta;
	}
	public void setFechaHasta(Date fechaHasta) {
		this.fechaHasta = fechaHasta;
	}
	public String getUsuarioAlta() {
		return usuarioAlta;
	}
	public void setUsuarioAlta(String usuarioAlta) {
		this.usuarioAlta = usuarioAlta;
	}
	public String getUsuarioBaja() {
		return usuarioBaja;
	}
	public void setUsuarioBaja(String usuarioBaja) {
		this.usuarioBaja = usuarioBaja;
	}
}

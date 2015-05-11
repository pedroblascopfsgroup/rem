package es.pfsgroup.plugin.recovery.masivo.dto;

import java.util.Date;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;

public class MSVHistoricoResolucionDto {
	
	private Long id;
	private MSVDDTipoResolucion tipo;
	private Date fechaCarga;
	private Usuario usuario;
	private String numAuto;
	private String juzgado;
	private String plaza;
	private String observaciones;
	private String tipoProcedimiento;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public MSVDDTipoResolucion getTipo() {
		return tipo;
	}
	public void setTipo(MSVDDTipoResolucion tipo) {
		this.tipo = tipo;
	}
	public Date getFechaCarga() {
		return fechaCarga;
	}
	public void setFechaCarga(Date fechaCarga) {
		this.fechaCarga = fechaCarga;
	}
	public Usuario getUsuario() {
		return usuario;
	}
	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}
	public String getNumAuto() {
		return numAuto;
	}
	public void setNumAuto(String numAuto) {
		this.numAuto = numAuto;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getJuzgado() {
		return juzgado;
	}
	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}
	public String getPlaza() {
		return plaza;
	}
	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}
	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	
}

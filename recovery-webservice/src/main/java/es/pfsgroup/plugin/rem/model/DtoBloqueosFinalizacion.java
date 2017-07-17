package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoBloqueosFinalizacion extends WebDto {

	private static final long serialVersionUID = 1L;

	private String idExpediente;
	private String id;
	private String numActivo;
	private String areaBloqueoCodigo;
	private String tipoBloqueoCodigo;
	private Date fechaAlta;
	private String usuarioAlta;
	private Date fechaBaja;
	private String usuarioBaja;
	private String resultado;
	private Long idActivo;
	private String acuerdoCodigo;


	public String getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(String idExpediente) {
		this.idExpediente = idExpediente;
	}
	
	public void setIdEntidad(String idEntidad) { // Usado para el GridEditableRow.
		this.idExpediente = idEntidad;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getAreaBloqueoCodigo() {
		return areaBloqueoCodigo;
	}

	public void setAreaBloqueoCodigo(String areaBloqueoCodigo) {
		this.areaBloqueoCodigo = areaBloqueoCodigo;
	}

	public String getTipoBloqueoCodigo() {
		return tipoBloqueoCodigo;
	}

	public void setTipoBloqueoCodigo(String tipoBloqueoCodigo) {
		this.tipoBloqueoCodigo = tipoBloqueoCodigo;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public String getUsuarioAlta() {
		return usuarioAlta;
	}

	public void setUsuarioAlta(String usuarioAlta) {
		this.usuarioAlta = usuarioAlta;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public String getUsuarioBaja() {
		return usuarioBaja;
	}

	public void setUsuarioBaja(String usuarioBaja) {
		this.usuarioBaja = usuarioBaja;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getResultado() {
		return resultado;
	}

	public void setResultado(String resultado) {
		this.resultado = resultado;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getAcuerdoCodigo() {
		return acuerdoCodigo;
	}

	public void setAcuerdoCodigo(String acuerdoCodigo) {
		this.acuerdoCodigo = acuerdoCodigo;
	}
}
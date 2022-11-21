package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoHistoricoAntiguoDeudor extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idHistorico;
	private String codigoLocalizable;
	private Date fechaIlocalizable;
	private Date fechaLocalizado;
	private String motivo;
	private Date fechaCreacion;
	
	public Long getIdHistorico() {
		return idHistorico;
	}
	public void setIdHistorico(Long idHistorico) {
		this.idHistorico = idHistorico;
	}
	public String getCodigoLocalizable() {
		return codigoLocalizable;
	}
	public void setCodigoLocalizable(String codigoLocalizable) {
		this.codigoLocalizable = codigoLocalizable;
	}
	public Date getFechaIlocalizable() {
		return fechaIlocalizable;
	}
	public void setFechaIlocalizable(Date fechaIlocalizable) {
		this.fechaIlocalizable = fechaIlocalizable;
	}
	public Date getFechaLocalizado() {
		return fechaLocalizado;
	}
	public void setFechaLocalizado(Date fechaLocalizado) {
		this.fechaLocalizado = fechaLocalizado;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public Date getFechaCreacion() {
		return fechaCreacion;
	}
	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	
}
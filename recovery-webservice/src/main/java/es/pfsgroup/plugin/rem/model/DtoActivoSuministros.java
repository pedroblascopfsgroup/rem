package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el tab de activo suministros
 * @author Alberto Flores
 *
 */
public class DtoActivoSuministros extends DtoTabActivo {

	private static final long serialVersionUID = -7429602301888781560L;

	private Long idSuministro;
	private Long idActivo;
	private Long tipoSuministro; 
	private Long subtipoSuministro; 
	private Long companiaSuministro; 
	private Long domiciliado;
	private String numContrato;
	private String numCups;
	private Long periodicidad;
	private Date fechaAlta;
	private Long motivoAlta;
	private Date fechaBaja;
	private Long motivoBaja;
	private Long validado;
	
	
	public Long getIdSuministro() {
		return idSuministro;
	}
	public void setIdSuministro(Long idSuministro) {
		this.idSuministro = idSuministro;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getTipoSuministro() {
		return tipoSuministro;
	}
	public void setTipoSuministro(Long tipoSuministro) {
		this.tipoSuministro = tipoSuministro;
	}
	public Long getSubtipoSuministro() {
		return subtipoSuministro;
	}
	public void setSubtipoSuministro(Long subtipoSuministro) {
		this.subtipoSuministro = subtipoSuministro;
	}
	public Long getCompaniaSuministro() {
		return companiaSuministro;
	}
	public void setCompaniaSuministro(Long companiaSuministro) {
		this.companiaSuministro = companiaSuministro;
	}
	public Long getDomiciliado() {
		return domiciliado;
	}
	public void setDomiciliado(Long domiciliado) {
		this.domiciliado = domiciliado;
	}
	public String getNumContrato() {
		return numContrato;
	}
	public void setNumContrato(String numContrato) {
		this.numContrato = numContrato;
	}
	public String getNumCups() {
		return numCups;
	}
	public void setNumCups(String numCups) {
		this.numCups = numCups;
	}
	public Long getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(Long periodicidad) {
		this.periodicidad = periodicidad;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Long getMotivoAlta() {
		return motivoAlta;
	}
	public void setMotivoAlta(Long motivoAlta) {
		this.motivoAlta = motivoAlta;
	}
	public Date getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public Long getMotivoBaja() {
		return motivoBaja;
	}
	public void setMotivoBaja(Long motivoBaja) {
		this.motivoBaja = motivoBaja;
	}
	public Long getValidado() {
		return validado;
	}
	public void setValidado(Long validado) {
		this.validado = validado;
	}
	
	
}
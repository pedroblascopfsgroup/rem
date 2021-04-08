package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el tab de activo suministros
 * @author Alberto Flores
 *
 */
public class DtoActivoSuministros extends DtoTabActivo {

	private static final long serialVersionUID = -7429602301888781560L;

	private String idSuministro;
	private Long idActivo;
	private String tipoSuministro;
	private String tipoSuministroDescripcion;
	private String subtipoSuministro; 
	private String subtipoSuministroDescripcion; 
	private String companiaSuministro; 
	private String companiaSuministroDescripcion; 
	private String domiciliado;
	private String domiciliadoDescripcion;
	private String numContrato;
	private String numCups;
	private String periodicidad;
	private String periodicidadDescripcion;
	private Date fechaAlta;
	private String motivoAlta;
	private String motivoAltaDescripcion;
	private Date fechaBaja;
	private String motivoBaja;
	private String motivoBajaDescripcion;
	private String validado;
	private String validadoDescripcion;
	
	public String getIdSuministro() {
		return idSuministro;
	}
	public void setIdSuministro(String idSuministro) {
		this.idSuministro = idSuministro;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getTipoSuministro() {
		return tipoSuministro;
	}
	public void setTipoSuministro(String tipoSuministro) {
		this.tipoSuministro = tipoSuministro;
	}
	public String getSubtipoSuministro() {
		return subtipoSuministro;
	}
	public void setSubtipoSuministro(String subtipoSuministro) {
		this.subtipoSuministro = subtipoSuministro;
	}
	public String getCompaniaSuministro() {
		return companiaSuministro;
	}
	public void setCompaniaSuministro(String companiaSuministro) {
		this.companiaSuministro = companiaSuministro;
	}
	public String getDomiciliado() {
		return domiciliado;
	}
	public void setDomiciliado(String domiciliado) {
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
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getMotivoAlta() {
		return motivoAlta;
	}
	public void setMotivoAlta(String motivoAlta) {
		this.motivoAlta = motivoAlta;
	}
	public Date getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public String getMotivoBaja() {
		return motivoBaja;
	}
	public void setMotivoBaja(String motivoBaja) {
		this.motivoBaja = motivoBaja;
	}
	public String getValidado() {
		return validado;
	}
	public void setValidado(String validado) {
		this.validado = validado;
	}
	public String getTipoSuministroDescripcion() {
		return tipoSuministroDescripcion;
	}
	public void setTipoSuministroDescripcion(String tipoSuministroDescripcion) {
		this.tipoSuministroDescripcion = tipoSuministroDescripcion;
	}
	public String getSubtipoSuministroDescripcion() {
		return subtipoSuministroDescripcion;
	}
	public void setSubtipoSuministroDescripcion(String subtipoSuministroDescripcion) {
		this.subtipoSuministroDescripcion = subtipoSuministroDescripcion;
	}
	public String getCompaniaSuministroDescripcion() {
		return companiaSuministroDescripcion;
	}
	public void setCompaniaSuministroDescripcion(String companiaSuministroDescripcion) {
		this.companiaSuministroDescripcion = companiaSuministroDescripcion;
	}
	public String getDomiciliadoDescripcion() {
		return domiciliadoDescripcion;
	}
	public void setDomiciliadoDescripcion(String domiciliadoDescripcion) {
		this.domiciliadoDescripcion = domiciliadoDescripcion;
	}
	public String getPeriodicidadDescripcion() {
		return periodicidadDescripcion;
	}
	public void setPeriodicidadDescripcion(String periodicidadDescripcion) {
		this.periodicidadDescripcion = periodicidadDescripcion;
	}
	public String getMotivoAltaDescripcion() {
		return motivoAltaDescripcion;
	}
	public void setMotivoAltaDescripcion(String motivoAltaDescripcion) {
		this.motivoAltaDescripcion = motivoAltaDescripcion;
	}
	public String getMotivoBajaDescripcion() {
		return motivoBajaDescripcion;
	}
	public void setMotivoBajaDescripcion(String motivoBajaDescripcion) {
		this.motivoBajaDescripcion = motivoBajaDescripcion;
	}
	public String getValidadoDescripcion() {
		return validadoDescripcion;
	}
	public void setValidadoDescripcion(String validadoDescripcion) {
		this.validadoDescripcion = validadoDescripcion;
	}
	
}
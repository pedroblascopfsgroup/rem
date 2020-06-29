package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.pfsgroup.plugin.rem.model.dd.DDMotivoAltaSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoBajaSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSuministro;

/**
 * Dto para el tab de activo suministros
 * @author Alberto Flores
 *
 */
public class DtoActivoSuministros extends DtoTabActivo {

	private static final long serialVersionUID = -7429602301888781560L;

	private Long idSuministro;
	private Long idActivo;
	private DDTipoSuministro tipoSuministro; 
	private DDSubtipoSuministro subtipoSuministro; 
	private ActivoProveedor companiaSuministro; 
	private DDSinSiNo domiciliado;
	private String numContrato;
	private String numCups;
	private DDTipoPeriocidad periodicidad;
	private Date fechaAlta;
	private DDMotivoAltaSuministro motivoAlta;
	private Date fechaBaja;
	private DDMotivoBajaSuministro motivoBaja;
	private DDSinSiNo validado;
	
	
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
	public DDTipoSuministro getTipoSuministro() {
		return tipoSuministro;
	}
	public void setTipoSuministro(DDTipoSuministro tipoSuministro) {
		this.tipoSuministro = tipoSuministro;
	}
	public DDSubtipoSuministro getSubtipoSuministro() {
		return subtipoSuministro;
	}
	public void setSubtipoSuministro(DDSubtipoSuministro subtipoSuministro) {
		this.subtipoSuministro = subtipoSuministro;
	}
	public ActivoProveedor getCompaniaSuministro() {
		return companiaSuministro;
	}
	public void setCompaniaSuministro(ActivoProveedor companiaSuministro) {
		this.companiaSuministro = companiaSuministro;
	}
	public DDSinSiNo getDomiciliado() {
		return domiciliado;
	}
	public void setDomiciliado(DDSinSiNo domiciliado) {
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
	public DDTipoPeriocidad getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(DDTipoPeriocidad periodicidad) {
		this.periodicidad = periodicidad;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public DDMotivoAltaSuministro getMotivoAlta() {
		return motivoAlta;
	}
	public void setMotivoAlta(DDMotivoAltaSuministro motivoAlta) {
		this.motivoAlta = motivoAlta;
	}
	public Date getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public DDMotivoBajaSuministro getMotivoBaja() {
		return motivoBaja;
	}
	public void setMotivoBaja(DDMotivoBajaSuministro motivoBaja) {
		this.motivoBaja = motivoBaja;
	}
	public DDSinSiNo getValidado() {
		return validado;
	}
	public void setValidado(DDSinSiNo validado) {
		this.validado = validado;
	}
	
	
}
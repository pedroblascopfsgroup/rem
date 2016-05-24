package es.pfsgroup.recovery.ext.impl.asunto.dto;

import java.util.List;

import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;

public class EXTDtoBusquedaAsunto extends DtoBusquedaAsunto{

	private static final long serialVersionUID = -4205386375034721322L;

	private String comboTiposGestor;
	//UGAS-188
	private String numeroProcedimientoEnJuzgado;
	private String anyoProcedimientoEnJuzgado;
	
	private String ComboDecisionesFinalizacion;
	private String ComboTipoAsunto;
	private String comboGestion;
	private String comboPropiedades;
	private String comboErrorPreviCDD;
	private String comboErrorPostCDD;
    private String fechaEntregaDesde;
    private String fechaEntregaHasta;
    private String nombrePersonaProcedimiento;
    private String apellido1PersonaProcedimiento;
    private String apellido2PersonaProcedimiento;
    private String dniPersonaProcedimiento;
	
	private List<Long> idsUsuariosGrupos;
	
	
	
	
	public String getComboDecisionesFinalizacion() {
		return ComboDecisionesFinalizacion;
	}

	public void setComboDecisionesFinalizacion(String comboDecisionesFinalizacion) {
		ComboDecisionesFinalizacion = comboDecisionesFinalizacion;
	}

	public String getComboTipoAsunto() {
		return ComboTipoAsunto;
	}

	public void setComboTipoAsunto(String comboTipoAsunto) {
		ComboTipoAsunto = comboTipoAsunto;
	}

	public void setComboTiposGestor(String comboTiposGestor) {
		this.comboTiposGestor = comboTiposGestor;
	}

	public String getComboTiposGestor() {
		return comboTiposGestor;
	}

	public String getNumeroProcedimientoEnJuzgado() {
		return numeroProcedimientoEnJuzgado;
	}

	public void setNumeroProcedimientoEnJuzgado(
			String numeroProcedimientoEnJuzgado) {
		this.numeroProcedimientoEnJuzgado = numeroProcedimientoEnJuzgado;
	}

	public String getAnyoProcedimientoEnJuzgado() {
		return anyoProcedimientoEnJuzgado;
	}

	public void setAnyoProcedimientoEnJuzgado(String anyoProcedimientoEnJuzgado) {
		this.anyoProcedimientoEnJuzgado = anyoProcedimientoEnJuzgado;
	}

	public List<Long> getIdsUsuariosGrupos() {
		return idsUsuariosGrupos;
	}

	public void setIdsUsuariosGrupos(List<Long> idsUsuariosGrupos) {
		this.idsUsuariosGrupos = idsUsuariosGrupos;
	}

	public String getComboGestion() {
		return comboGestion;
	}

	public void setComboGestion(String comboGestion) {
		this.comboGestion = comboGestion;
	}

	public String getComboPropiedades() {
		return comboPropiedades;
	}

	public void setComboPropiedades(String comboPropiedades) {
		this.comboPropiedades = comboPropiedades;
	}

	public String getComboErrorPreviCDD() {
		return comboErrorPreviCDD;
	}

	public void setComboErrorPreviCDD(String comboErrorPreviCDD) {
		this.comboErrorPreviCDD = comboErrorPreviCDD;
	}

	public String getComboErrorPostCDD() {
		return comboErrorPostCDD;
	}

	public void setComboErrorPostCDD(String comboErrorPostCDD) {
		this.comboErrorPostCDD = comboErrorPostCDD;
	}

	public String getFechaEntregaHasta() {
		return fechaEntregaHasta;
	}

	public void setFechaEntregaHasta(String fechaEntregaHasta) {
		this.fechaEntregaHasta = fechaEntregaHasta;
	}

	public String getFechaEntregaDesde() {
		return fechaEntregaDesde;
	}

	public void setFechaEntregaDesde(String fechaEntregaDesde) {
		this.fechaEntregaDesde = fechaEntregaDesde;
	}

	
	public String getNombrePersonaProcedimiento() {
		return nombrePersonaProcedimiento;
	}

	public void setNombrePersonaProcedimiento(String nombrePersonaProcedimiento) {
		this.nombrePersonaProcedimiento = nombrePersonaProcedimiento;
	}

	public String getApellido1PersonaProcedimiento() {
		return apellido1PersonaProcedimiento;
	}

	public void setApellido1PersonaProcedimiento(
			String apellido1PersonaProcedimiento) {
		this.apellido1PersonaProcedimiento = apellido1PersonaProcedimiento;
	}

	public String getApellido2PersonaProcedimiento() {
		return apellido2PersonaProcedimiento;
	}

	public void setApellido2PersonaProcedimiento(
			String apellido2PersonaProcedimiento) {
		this.apellido2PersonaProcedimiento = apellido2PersonaProcedimiento;
	}
	
	public String getDniPersonaProcedimiento() {
		return dniPersonaProcedimiento;
	}

	public void setDniPersonaProcedimiento(String dniPersonaProcedimiento) {
		this.dniPersonaProcedimiento = dniPersonaProcedimiento;
	}

	
	
	
	

	
}

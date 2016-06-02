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
	
	/* PRODUCTO-1273
	 * Valores de la pestanya 'Letrados' 
	 */
	private String tipoDocumento;
	private String documentoCif;
	private String fechaAltaDesde;
	private String fechaAltaHasta;
    private String[] listaProvincias;
    private String clasificacionPerfil;   
    private String clasificacionConcursos;    
    private String codEstAse;   
    private String contratoVigor;    
    private String servicioIntegral;   
    private String fechaServicioIntegral;   
    private String relacionBankia;  
	private String oficinaContacto;
	private String entidadContacto;	
	private String entidadLiquidacion;
	private String oficinaLiquidacion;
	private String digconLiquidacion;
	private String cuentaLiquidacion;
	private String entidadProvisiones;
	private String oficinaProvisiones;
	private String digconProvisiones;
	private String cuentaProvisiones;
	private String entidadEntregas;
	private String oficinaEntregas;
	private String digconEntregas;
	private String cuentaEntregas;
	private String centroRecuperacion;
	private String asesoria;
	
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

	public String getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public String getDocumentoCif() {
		return documentoCif;
	}

	public void setDocumentoCif(String documentoCif) {
		this.documentoCif = documentoCif;
	}

	public String getFechaAltaDesde() {
		return fechaAltaDesde;
	}

	public void setFechaAltaDesde(String fechaAltaDesde) {
		fechaAltaDesde = fechaAltaDesde.replace("-", "/").substring(0, 10);
		this.fechaAltaDesde = fechaAltaDesde;
	}

	public String getFechaAltaHasta() {
		return fechaAltaHasta;
	}

	public void setFechaAltaHasta(String fechaAltaHasta) {
		fechaAltaHasta = fechaAltaHasta.replace("-", "/").substring(0, 10);
		this.fechaAltaHasta = fechaAltaHasta;
	}

	public String[] getListaProvincias() {
		return listaProvincias;
	}

	public void setListaProvincias(String[] listaProvincias) {
		this.listaProvincias = listaProvincias;
	}

	public String getClasificacionPerfil() {
		return clasificacionPerfil;
	}

	public void setClasificacionPerfil(String clasificacionPerfil) {
		this.clasificacionPerfil = clasificacionPerfil;
	}

	public String getClasificacionConcursos() {
		return clasificacionConcursos;
	}

	public void setClasificacionConcursos(String clasificacionConcursos) {
		if(clasificacionConcursos.equals("01")) {
			this.clasificacionConcursos = "1";
		}
		if(clasificacionConcursos.equals("02")) {
			this.clasificacionConcursos = "0";
		}
	}

	public String getCodEstAse() {
		return codEstAse;
	}

	public void setCodEstAse(String codEstAse) {
		this.codEstAse = codEstAse;
	}

	public String getContratoVigor() {
		return contratoVigor;
	}

	public void setContratoVigor(String contratoVigor) {
		this.contratoVigor = contratoVigor;
	}

	public String getServicioIntegral() {
		return servicioIntegral;
	}

	public void setServicioIntegral(String servicioIntegral) {
		this.servicioIntegral = servicioIntegral;
		if(servicioIntegral.equals("01")) {
			this.servicioIntegral = "1";
		}
		if(servicioIntegral.equals("02")) {
			this.servicioIntegral = "0";
		}
	}

	public String getFechaServicioIntegral() {
		return fechaServicioIntegral;
	}

	public void setFechaServicioIntegral(String fechaServicioIntegral) {
		this.fechaServicioIntegral = fechaServicioIntegral;
	}

	public String getRelacionBankia() {
		return relacionBankia;
	}

	public void setRelacionBankia(String relacionBankia) {
		this.relacionBankia = relacionBankia;
	}

	public String getOficinaContacto() {
		return oficinaContacto;
	}

	public void setOficinaContacto(String oficinaContacto) {
		this.oficinaContacto = oficinaContacto;
	}

	public String getEntidadContacto() {
		return entidadContacto;
	}

	public void setEntidadContacto(String entidadContacto) {
		this.entidadContacto = entidadContacto;
	}

	public String getEntidadLiquidacion() {
		return entidadLiquidacion;
	}

	public void setEntidadLiquidacion(String entidadLiquidacion) {
		this.entidadLiquidacion = entidadLiquidacion;
	}

	public String getOficinaLiquidacion() {
		return oficinaLiquidacion;
	}

	public void setOficinaLiquidacion(String oficinaLiquidacion) {
		this.oficinaLiquidacion = oficinaLiquidacion;
	}

	public String getDigconLiquidacion() {
		return digconLiquidacion;
	}

	public void setDigconLiquidacion(String digconLiquidacion) {
		this.digconLiquidacion = digconLiquidacion;
	}

	public String getCuentaLiquidacion() {
		return cuentaLiquidacion;
	}

	public void setCuentaLiquidacion(String cuentaLiquidacion) {
		this.cuentaLiquidacion = cuentaLiquidacion;
	}

	public String getEntidadProvisiones() {
		return entidadProvisiones;
	}

	public void setEntidadProvisiones(String entidadProvisiones) {
		this.entidadProvisiones = entidadProvisiones;
	}

	public String getOficinaProvisiones() {
		return oficinaProvisiones;
	}

	public void setOficinaProvisiones(String oficinaProvisiones) {
		this.oficinaProvisiones = oficinaProvisiones;
	}

	public String getDigconProvisiones() {
		return digconProvisiones;
	}

	public void setDigconProvisiones(String digconProvisiones) {
		this.digconProvisiones = digconProvisiones;
	}

	public String getCuentaProvisiones() {
		return cuentaProvisiones;
	}

	public void setCuentaProvisiones(String cuentaProvisiones) {
		this.cuentaProvisiones = cuentaProvisiones;
	}

	public String getEntidadEntregas() {
		return entidadEntregas;
	}

	public void setEntidadEntregas(String entidadEntregas) {
		this.entidadEntregas = entidadEntregas;
	}

	public String getOficinaEntregas() {
		return oficinaEntregas;
	}

	public void setOficinaEntregas(String oficinaEntregas) {
		this.oficinaEntregas = oficinaEntregas;
	}

	public String getDigconEntregas() {
		return digconEntregas;
	}

	public void setDigconEntregas(String digconEntregas) {
		this.digconEntregas = digconEntregas;
	}

	public String getCuentaEntregas() {
		return cuentaEntregas;
	}

	public void setCuentaEntregas(String cuentaEntregas) {
		this.cuentaEntregas = cuentaEntregas;
	}

	public String getCentroRecuperacion() {
		return centroRecuperacion;
	}

	public void setCentroRecuperacion(String centroRecuperacion) {
		this.centroRecuperacion = centroRecuperacion;
	}

	public String getAsesoria() {
		return asesoria;
	}

	public void setAsesoria(String asesoria) {
		if(asesoria.equals("01")) {
			this.asesoria = "1";
		}
		if(asesoria.equals("02")) {
			this.asesoria = "0";
		}
	}

}

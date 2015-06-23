package es.pfsgroup.recovery.ext.impl.asunto.dto;

import java.util.List;

import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;

public class EXTDtoBusquedaAsunto extends DtoBusquedaAsunto{

	private static final long serialVersionUID = -4205386375034721322L;

	private String comboTiposGestor;
	//UGAS-188
	private String numeroProcedimientoEnJuzgado;
	private String anyoProcedimientoEnJuzgado;
	
	private String comboGestion;
	private String comboPropiedades;
	private String comboErrorCDD;
		
	
	private List<Long> idsUsuariosGrupos;
	
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

	public String getComboErrorCDD() {
		return comboErrorCDD;
	}

	public void setComboErrorCDD(String comboErrorCDD) {
		this.comboErrorCDD = comboErrorCDD;
	}

}

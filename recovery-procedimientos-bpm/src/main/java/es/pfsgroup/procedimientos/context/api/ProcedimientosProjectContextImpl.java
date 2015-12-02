package es.pfsgroup.procedimientos.context.api;


import java.util.List;
import java.util.Set;

public class ProcedimientosProjectContextImpl implements ProcedimientosProjectContext {

	private float limiteDeudaGlobal;
	private float limiteDeudaBien;
	private String tipoSubastaSareb;
	private List<String> tiposSubasta;
	private List<String> tareasCelebracionSubasta;
	private List<String> tareasSenyalamientoSubastas;
	private List<String> camposCostas;
	private List<String> camposSuspensionSubasta;
	private String codigoCargaAnterior;
	private Set<String> procedimientosPestanyaFaseComun;
	
	@Override
	public float getLimiteDeudaGlobal() {
		return limiteDeudaGlobal;
	}
	
	public void setLimiteDeudaGlobal(float limiteDeudaGlobal) {
		this.limiteDeudaGlobal = limiteDeudaGlobal;
	}
	
	@Override
	public float getLimiteDeudaBien() {
		return limiteDeudaBien;
	}
	
	public void setLimiteDeudaBien(float limiteDeudaBien) {
		this.limiteDeudaBien = limiteDeudaBien;
	}
	
	@Override
	public String getTipoSubastaSareb() {
		return tipoSubastaSareb;
	}
	
	public void setTipoSubastaSareb(String tipoSubastaSareb) {
		this.tipoSubastaSareb = tipoSubastaSareb;
	}
	
	@Override
	public List<String> getTiposSubasta() {
		return tiposSubasta;
	}

	public void setTiposSubasta(List<String> tiposSubasta) {
		this.tiposSubasta = tiposSubasta;
	}
	
	@Override
	public List<String> getTareasCelebracionSubasta() {
		return tareasCelebracionSubasta;
	}
	
	public void setTareasCelebracionSubasta(List<String> tareasCelebracionSubasta) {
		this.tareasCelebracionSubasta = tareasCelebracionSubasta;
	}
	
	@Override
	public List<String> getTareasSenyalamientoSubastas() {
		return tareasSenyalamientoSubastas;
	}
	
	public void setTareasSenyalamientoSubastas(
			List<String> tareasSenyalamientoSubastas) {
		this.tareasSenyalamientoSubastas = tareasSenyalamientoSubastas;
	}
	
	@Override
	public List<String> getCamposCostas() {
		return camposCostas;
	}
	
	public void setCamposCostas(List<String> camposCostas) {
		this.camposCostas = camposCostas;
	}
	
	@Override
	public List<String> getCamposSuspensionSubasta() {
		return camposSuspensionSubasta;
	}
	
	public void setCamposSuspensionSubasta(List<String> camposSuspensionSubasta) {
		this.camposSuspensionSubasta = camposSuspensionSubasta;
	}
	
	@Override
	public String getCodigoCargaAnterior() {
		return codigoCargaAnterior;
	}
	
	public void setCodigoCargaAnterior(String codigoCargaAnterior) {
		this.codigoCargaAnterior = codigoCargaAnterior;
	}

	@Override
	public Set<String> getProcedimientosPestanyaFaseComun() {
		return procedimientosPestanyaFaseComun;
	}

	public void setProcedimientosPestanyaFaseComun(Set<String> procedimientosPestanyaFaseComun) {
		this.procedimientosPestanyaFaseComun = procedimientosPestanyaFaseComun;
	}

}
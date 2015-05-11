package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoPanelControlFiltros extends WebDto{

	private static final long serialVersionUID = -4941793190245334384L;
	
	private String cod;
	private String idNivel;
	private Long nivel;
	private String tipo;
	private String tipoProcedimiento;
	private String tipoTarea;
	private String letradoGestor;
	private String campanya;
    private Double minImporteFiltro;
    private Double maxImporteFiltro;
    private String rangoImporte;
    private String cartera;
    private String lote;
    private String idPlaza;
    private String idJuzgado;
	
	public String getCod() {
		return cod;
	}
	public void setCod(String cod) {
		this.cod = cod;
	}
	public String getIdNivel() {
		return idNivel;
	}
	public void setIdNivel(String idNivel) {
		this.idNivel = idNivel;
	}
	public Long getNivel() {
		return nivel;
	}
	public void setNivel(Long nivel) {
		this.nivel = nivel;
	}
	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	public String getTipoTarea() {
		return tipoTarea;
	}
	public void setTipoTarea(String tipoTarea) {
		this.tipoTarea = tipoTarea;
	}
	public String getLetradoGestor() {
		return letradoGestor;
	}
	public void setLetradoGestor(String letradoGestor) {
		this.letradoGestor = letradoGestor;
	}
	public String getCampanya() {
		return campanya;
	}
	public void setCampanya(String campanya) {
		this.campanya = campanya;
	}
	public Double getMinImporteFiltro() {
		return minImporteFiltro;
	}
	public void setMinImporteFiltro(Double minImporteFiltro) {
		this.minImporteFiltro = minImporteFiltro;
	}
	public Double getMaxImporteFiltro() {
		return maxImporteFiltro;
	}
	public void setMaxImporteFiltro(Double maxImporteFiltro) {
		this.maxImporteFiltro = maxImporteFiltro;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getTipo() {
		return tipo;
	}
	public String getRangoImporte() {
		return rangoImporte;
	}
	public void setRangoImporte(String rangoImporte) {
		this.rangoImporte = rangoImporte;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	public String getCartera() {
		return cartera;
	}
	public void setLote(String lote) {
		this.lote = lote;
	}
	public String getLote() {
		return lote;
	}
	public void setIdPlaza(String idPlaza) {
		this.idPlaza = idPlaza;
	}
	public String getIdPlaza() {
		return idPlaza;
	}
	public void setIdJuzgado(String idJuzgado) {
		this.idJuzgado = idJuzgado;
	}
	public String getIdJuzgado() {
		return idJuzgado;
	}
	
}

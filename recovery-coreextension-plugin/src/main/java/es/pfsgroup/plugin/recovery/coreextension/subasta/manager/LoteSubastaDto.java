package es.pfsgroup.plugin.recovery.coreextension.subasta.manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;

public class LoteSubastaDto {

	private Long id;
	private String guid;
	private Subasta subasta;
	private Float insPujaSinPostores;
	private Float insPujaPostoresDesde;
	private Float insPujaPostoresHasta;
	private Float insValorSubasta;
	private Float ins50DelTipoSubasta;
	private Float ins60DelTipoSubasta;
	private Float ins70DelTipoSubasta;
	private String observaciones;
	private Integer numLote;
	private Boolean riesgoConsignacion;
	private Float deudaJudicial;
	private String observacionesComite;
	private DDEstadoLoteSubasta estado;
	private Date fechaEstado;
	
	private List<Long> idBienes;

	public LoteSubastaDto() {
		idBienes = new ArrayList<Long>();
	}
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getGuid() {
		return guid;
	}
	public void setGuid(String guid) {
		this.guid = guid;
	}
	public Subasta getSubasta() {
		return subasta;
	}
	public void setSubasta(Subasta subasta) {
		this.subasta = subasta;
	}
	public Float getInsPujaSinPostores() {
		return insPujaSinPostores;
	}
	public void setInsPujaSinPostores(Float insPujaSinPostores) {
		this.insPujaSinPostores = insPujaSinPostores;
	}
	public Float getInsPujaPostoresDesde() {
		return insPujaPostoresDesde;
	}
	public void setInsPujaPostoresDesde(Float insPujaPostoresDesde) {
		this.insPujaPostoresDesde = insPujaPostoresDesde;
	}
	public Float getInsPujaPostoresHasta() {
		return insPujaPostoresHasta;
	}
	public void setInsPujaPostoresHasta(Float insPujaPostoresHasta) {
		this.insPujaPostoresHasta = insPujaPostoresHasta;
	}
	public Float getInsValorSubasta() {
		return insValorSubasta;
	}
	public void setInsValorSubasta(Float insValorSubasta) {
		this.insValorSubasta = insValorSubasta;
	}
	public Float getIns50DelTipoSubasta() {
		return ins50DelTipoSubasta;
	}
	public void setIns50DelTipoSubasta(Float ins50DelTipoSubasta) {
		this.ins50DelTipoSubasta = ins50DelTipoSubasta;
	}
	public Float getIns60DelTipoSubasta() {
		return ins60DelTipoSubasta;
	}
	public void setIns60DelTipoSubasta(Float ins60DelTipoSubasta) {
		this.ins60DelTipoSubasta = ins60DelTipoSubasta;
	}
	public Float getIns70DelTipoSubasta() {
		return ins70DelTipoSubasta;
	}
	public void setIns70DelTipoSubasta(Float ins70DelTipoSubasta) {
		this.ins70DelTipoSubasta = ins70DelTipoSubasta;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Integer getNumLote() {
		return numLote;
	}
	public void setNumLote(Integer numLote) {
		this.numLote = numLote;
	}
	public Boolean getRiesgoConsignacion() {
		return riesgoConsignacion;
	}
	public void setRiesgoConsignacion(Boolean riesgoConsignacion) {
		this.riesgoConsignacion = riesgoConsignacion;
	}
	public Float getDeudaJudicial() {
		return deudaJudicial;
	}
	public void setDeudaJudicial(Float deudaJudicial) {
		this.deudaJudicial = deudaJudicial;
	}
	public String getObservacionesComite() {
		return observacionesComite;
	}
	public void setObservacionesComite(String observacionesComite) {
		this.observacionesComite = observacionesComite;
	}
	public DDEstadoLoteSubasta getEstado() {
		return estado;
	}
	public void setEstado(DDEstadoLoteSubasta estado) {
		this.estado = estado;
	}
	public Date getFechaEstado() {
		return fechaEstado;
	}
	public void setFechaEstado(Date fechaEstado) {
		this.fechaEstado = fechaEstado;
	}
	public List<Long> getIdBienes() {
		return idBienes;
	}
	public void setIdBienes(List<Long> idBienes) {
		this.idBienes = idBienes;
	}
	
}

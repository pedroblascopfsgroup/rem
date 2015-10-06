package es.pfsgroup.plugin.recovery.coreextension.subasta.manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDMotivoSuspSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoComite;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;

public class SubastaDto {

	private Long id;
	private String guid;
	private Procedimiento procedimiento;
	private String numAutos;
	private DDEstadoSubasta estado;
	private DDTipoSubasta tipo;
	private DDResultadoComite resultadoComite;
	private DDMotivoSuspSubasta motivoSuspension;
	private DDEstadoAsunto estadoAsunto;
	private Date fechaSolicitud;
	private Date fechaSenyalamiento;
	private Date fechaAnuncio;
	private Float costasLetrado;
	private Float deudaJudicial;
	
	private List<LoteSubastaDto> lotes;

	public SubastaDto() {
		lotes = new ArrayList<LoteSubastaDto>();
	}
	
	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public String getNumAutos() {
		return numAutos;
	}

	public void setNumAutos(String numAutos) {
		this.numAutos = numAutos;
	}

	public DDEstadoSubasta getEstado() {
		return estado;
	}

	public void setEstado(DDEstadoSubasta estado) {
		this.estado = estado;
	}

	public DDTipoSubasta getTipo() {
		return tipo;
	}

	public void setTipo(DDTipoSubasta tipo) {
		this.tipo = tipo;
	}

	public List<LoteSubastaDto> getLotes() {
		return lotes;
	}

	public void setLotes(List<LoteSubastaDto> lotes) {
		this.lotes = lotes;
	}

	public DDResultadoComite getResultadoComite() {
		return resultadoComite;
	}

	public void setResultadoComite(DDResultadoComite resultadoComite) {
		this.resultadoComite = resultadoComite;
	}

	public DDMotivoSuspSubasta getMotivoSuspension() {
		return motivoSuspension;
	}

	public void setMotivoSuspension(DDMotivoSuspSubasta motivoSuspension) {
		this.motivoSuspension = motivoSuspension;
	}

	public DDEstadoAsunto getEstadoAsunto() {
		return estadoAsunto;
	}

	public void setEstadoAsunto(DDEstadoAsunto estadoAsunto) {
		this.estadoAsunto = estadoAsunto;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaSenyalamiento() {
		return fechaSenyalamiento;
	}

	public void setFechaSenyalamiento(Date fechaSenyalamiento) {
		this.fechaSenyalamiento = fechaSenyalamiento;
	}

	public Date getFechaAnuncio() {
		return fechaAnuncio;
	}

	public void setFechaAnuncio(Date fechaAnuncio) {
		this.fechaAnuncio = fechaAnuncio;
	}

	public Float getCostasLetrado() {
		return costasLetrado;
	}

	public void setCostasLetrado(Float costasLetrado) {
		this.costasLetrado = costasLetrado;
	}

	public Float getDeudaJudicial() {
		return deudaJudicial;
	}

	public void setDeudaJudicial(Float deudaJudicial) {
		this.deudaJudicial = deudaJudicial;
	}

}

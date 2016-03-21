package es.capgemini.pfs.procesosJudiciales.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;

@Entity
public class EXTTareaProcedimiento extends TareaProcedimiento implements EXTTareaProcedimientoInfo{

	private static final long serialVersionUID = 1292290602064335641L;

	@Column(name="TAP_AUTOPRORROGA")
	private Boolean autoprorroga;
	
	@Column(name="TAP_MAX_AUTOP")
	private Integer maximoAutoprorrogas;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_TGE_ID")
    private EXTDDTipoGestor tipoGestor;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_STA_ID")
	private EXTSubtipoTarea subtipoTareaNotificacion;
	
	@Column(name  = "TAP_EVITAR_REORG")
	private Boolean evitarReorganizacion;
	
	@Column(name = "TAP_BUCLE_BPM", nullable = true)
	private String expresionBucleBPM;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_TSUP_ID")
	private EXTDDTipoGestor tipoGestorSupervisor;
	

	public Boolean getEvitarReorganizacion() {
		return evitarReorganizacion;
	}

	public void setEvitarReorganizacion(Boolean evitarReorganizacion) {
		this.evitarReorganizacion = evitarReorganizacion;
	}

	@Override
	public Boolean getAutoprorroga() {
		return autoprorroga;
	}
	
	public void setAutoprorroga(Boolean autoprorroga){
		this.autoprorroga=autoprorroga;
	}
	
	public void setMaximoAutoprorrogas(Integer maximoAutoprorrogas){
		this.maximoAutoprorrogas=maximoAutoprorrogas;
	}

	@Override
	public Integer getMaximoAutoprorrogas() {
		return maximoAutoprorrogas;
	}

	public void setTipoGestor(EXTDDTipoGestor tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public EXTDDTipoGestor getTipoGestor() {
		return tipoGestor;
	}

	public void setSubtipoTareaNotificacion(EXTSubtipoTarea subtipoTareaNotificacion) {
		this.subtipoTareaNotificacion = subtipoTareaNotificacion;
	}

	public EXTSubtipoTarea getSubtipoTareaNotificacion() {
		return subtipoTareaNotificacion;
	}

    public String getExpresionBucleBPM() {
        return expresionBucleBPM;
    }

    public void setExpresionBucleBPM(String expresionBucleBPM) {
        this.expresionBucleBPM = expresionBucleBPM;
    }
    
	public EXTDDTipoGestor getTipoGestorSupervisor() {
		return tipoGestorSupervisor;
	}

	public void setTipoGestorSupervisor(EXTDDTipoGestor tipoGestorSupervisor) {
		this.tipoGestorSupervisor = tipoGestorSupervisor;
	}

}

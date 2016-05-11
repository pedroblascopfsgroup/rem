package es.pfsgroup.plugin.recovery.mejoras.procedimiento.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import org.hibernate.proxy.HibernateProxy;

import es.capgemini.pfs.actitudAptitudActuacion.model.DDMotivoNoLitigar;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

//FIXME Mover esta clase de paquete, a uno de coreextension
@Entity
@org.hibernate.annotations.Entity(dynamicUpdate=true)
public class MEJProcedimiento extends Procedimiento {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7719820312651258505L;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TIPO_PROC_ORIGINAL")
	private TipoProcedimiento tipoProcedimientoOriginal;

	@Column(name="PRC_PARALIZADO")
	private boolean estaParalizado;
	
	@Column(name="PRC_FECHA_PARALIZADO")
	private Date fechaUltimaParalizacion;
	
	@Column(name="PRC_PLAZO_PARALIZ_MILS")
	private Long plazoParalizacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MNL_ID")
    private DDMotivoNoLitigar motivoNoLitigar;
	
	@Column(name="PRC_OBS_NO_LITIGAR")
	private String observacionesNoLitigar;

	@Column(name="SYS_GUID")
	private String guid;

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

	/*@Embedded
	private Guid guid;
	
	public Guid getGuid() {
		return guid;
	}

	public void setGuid(Guid guid) {
		this.guid = guid;
	}*/
	
	public void setEstaParalizado(boolean estaParalizado) {
		this.estaParalizado = estaParalizado;
	}

	public boolean isEstaParalizado() {
		return estaParalizado;
	}

	public void setFechaUltimaParalizacion(Date fechaUltimaParalizacion) {
		this.fechaUltimaParalizacion = fechaUltimaParalizacion;
	}

	public Date getFechaUltimaParalizacion() {
		return fechaUltimaParalizacion;
	}
	@Override
	public int compareTo(Procedimiento o) {
		return this.getId().compareTo(o.getId());
	}

	public void setTipoProcedimientoOriginal(
			TipoProcedimiento tipoProcedimientoOriginal) {
		this.tipoProcedimientoOriginal = tipoProcedimientoOriginal;
	}

	public TipoProcedimiento getTipoProcedimientoOriginal() {
		return tipoProcedimientoOriginal;
	}

	/**
	 * @return the plazoParalizacion
	 */
	public Long getPlazoParalizacion() {
		return plazoParalizacion;
	}

	/**
	 * @param plazoParalizacion the plazoParalizacion to set
	 */
	public void setPlazoParalizacion(Long plazoParalizacion) {
		this.plazoParalizacion = plazoParalizacion;
	}

	public DDMotivoNoLitigar getMotivoNoLitigar() {
		return motivoNoLitigar;
	}

	public void setMotivoNoLitigar(DDMotivoNoLitigar motivoNoLitigar) {
		this.motivoNoLitigar = motivoNoLitigar;
	}

	public String getObservacionesNoLitigar() {
		return observacionesNoLitigar;
	}

	public void setObservacionesNoLitigar(String observacionesNoLitigar) {
		this.observacionesNoLitigar = observacionesNoLitigar;
	}
	
	@Transient
	public static MEJProcedimiento instanceOf(Procedimiento procedimiento) {
		MEJProcedimiento mejProcedimiento = null;
		if (procedimiento==null) return null;
	    if (procedimiento instanceof HibernateProxy) {
	        mejProcedimiento = (MEJProcedimiento) ((HibernateProxy) procedimiento).getHibernateLazyInitializer()
	                .getImplementation();
	    } else if (procedimiento instanceof MEJProcedimiento){
	    	mejProcedimiento = (MEJProcedimiento) procedimiento;
		}
		return mejProcedimiento;
	}
	
}

package es.pfsgroup.plugin.recovery.mejoras.procedimiento.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

//FIXME Mover esta clase de paquete, a uno de coreextension
@Entity
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
}

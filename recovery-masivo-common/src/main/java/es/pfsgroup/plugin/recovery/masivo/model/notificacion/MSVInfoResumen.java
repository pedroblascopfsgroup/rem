package es.pfsgroup.plugin.recovery.masivo.model.notificacion;

import java.io.Serializable;
import java.util.Date;

/**
 * Objeto que representa una fila del resumen de notificación de demandados.
 * @author manuel
 *
 */
public class MSVInfoResumen implements Serializable{

	private static final long serialVersionUID = 8753492240240005536L;

	private Long idProcedimiento;
	
	private Long idDemandado;
	
	private String nombreDemandado;
	
	private Boolean excluido;
	
	private Date fechaReqPago;
	
	private String resultadoReqPago;
	
	private Date fechaSolicitudAvDomiciliaria;
	
	private String resultadoAvDomiciliaria;
	
	private Date fechaSolicitudReqEdicto;
	
	private String resultadoReqEdicto;
	
	public String getResultadoAvDomiciliaria() {
		return resultadoAvDomiciliaria;
	}

	public void setResultadoAvDomiciliaria(String resultadoAvDomiciliaria) {
		this.resultadoAvDomiciliaria = resultadoAvDomiciliaria;
	}

	public String getResultadoReqEdicto() {
		return resultadoReqEdicto;
	}

	public void setResultadoReqEdicto(String resultadoReqEdicto) {
		this.resultadoReqEdicto = resultadoReqEdicto;
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public Long getIdDemandado() {
		return idDemandado;
	}

	public void setIdDemandado(Long idDemandado) {
		this.idDemandado = idDemandado;
	}

	public String getNombreDemandado() {
		return nombreDemandado;
	}

	public void setNombreDemandado(String nombreDemandado) {
		this.nombreDemandado = nombreDemandado;
	}
	
	public Date getFechaReqPago() {
		return fechaReqPago;
	}

	public void setFechaReqPago(Date fechaReqPago) {
		this.fechaReqPago = fechaReqPago;
	}

	public String getResultadoReqPago() {
		return resultadoReqPago;
	}

	public void setResultadoReqPago(String resultadoReqPago) {
		this.resultadoReqPago = resultadoReqPago;
	}

	public Date getFechaSolicitudAvDomiciliaria() {
		return fechaSolicitudAvDomiciliaria;
	}

	public void setFechaSolicitudAvDomiciliaria(Date fechaSolicitudAvDomiciliaria) {
		this.fechaSolicitudAvDomiciliaria = fechaSolicitudAvDomiciliaria;
	}

	public Date getFechaSolicitudReqEdicto() {
		return fechaSolicitudReqEdicto;
	}

	public void setFechaSolicitudReqEdicto(Date fechaSolicitudReqEdicto) {
		this.fechaSolicitudReqEdicto = fechaSolicitudReqEdicto;
	}

	public Boolean getExcluido() {
		return excluido;
	}

	public void setExcluido(Boolean excluido) {
		this.excluido = excluido;
	}
	
}

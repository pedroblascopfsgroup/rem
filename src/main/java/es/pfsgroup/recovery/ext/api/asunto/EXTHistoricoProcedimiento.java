package es.pfsgroup.recovery.ext.api.asunto;

import java.util.Date;

import es.capgemini.pfs.registro.model.HistoricoProcedimiento;

public class EXTHistoricoProcedimiento extends HistoricoProcedimiento{

	/**
	 * SERIALUID
	 */
	private static final long serialVersionUID = -2298239838525251207L;
	private Date fechaVencReal;
	private String subtipoTarea;
	private String descripcionTarea;
	private String codigoTarea;

	public Date getFechaVencReal() {
		return fechaVencReal;
	}

	public void setFechaVencReal(Date fechaVencReal) {
		this.fechaVencReal = fechaVencReal;
	}

	public String getSubtipoTarea() {
		return subtipoTarea;
	}

	public void setSubtipoTarea(String subtipoTarea) {
		this.subtipoTarea = subtipoTarea;
	}

	public String getDescripcionTarea() {
		return descripcionTarea;
	}

	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}

	public String getCodigoTarea() {
		return codigoTarea;
	}

	public void setCodigoTarea(String codigoTarea) {
		this.codigoTarea = codigoTarea;
	}
	
}

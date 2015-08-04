package es.pfsgroup.recovery.ext.impl.acuerdo.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;

import es.capgemini.pfs.acuerdo.model.Acuerdo;

@Entity
public class EXTAcuerdo extends Acuerdo {

	private static final long serialVersionUID = 2075119525614504409L;
	
	@Column(name="ACU_MOTIVO")
	private String motivo;
	
	@Column(name = "ACU_FECHA_LIMITE")
	private Date fechaLimite;	
	
	@Column(name = "ACU_IMPORTE_COSTAS")
	private Long importeCostas;	

	public Long getImporteCostas() {
		return importeCostas;
	}

	public void setImporteCostas(Long importeCostas) {
		this.importeCostas = importeCostas;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public Date getFechaLimite() {
		return fechaLimite;
	}

	public void setFechaLimite(Date fechaLimite) {
		this.fechaLimite = fechaLimite;
	}

	
	
}

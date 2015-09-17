package es.pfsgroup.recovery.ext.impl.acuerdo.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
public class EXTAcuerdo extends Acuerdo {

	private static final long serialVersionUID = 2075119525614504409L;
	
	@Column(name="ACU_MOTIVO")
	private String motivo;
	
	@Column(name = "ACU_FECHA_LIMITE")
	private Date fechaLimite;	
	
	@Column(name = "ACU_IMPORTE_COSTAS")
	private Long importeCostas;	
	
    @ManyToOne
    @JoinColumn(name = "ACU_USER_PROPONENTE")
	private Usuario proponente;
    
    @ManyToOne
    @JoinColumn(name = "USD_ID")
	private GestorDespacho gestorDespacho;
    
	public GestorDespacho getGestorDespacho() {
		return gestorDespacho;
	}

	public void setGestorDespacho(GestorDespacho gestorDespacho) {
		this.gestorDespacho = gestorDespacho;
	}

	public Usuario getProponente() {
		return proponente;
	}

	public void setProponente(Usuario proponente) {
		this.proponente = proponente;
	}

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

package es.pfsgroup.recovery.ext.impl.acuerdo.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import org.hibernate.proxy.HibernateProxy;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDMotivoRechazoAcuerdo;
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
    
    @ManyToOne
    @JoinColumn(name = "DD_MTR_ID")
	private DDMotivoRechazoAcuerdo motivoRechazo;
    
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

	@Column(name = "SYS_GUID")
	private String guid;
	
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

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
	public DDMotivoRechazoAcuerdo getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(DDMotivoRechazoAcuerdo motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	
	@Transient
	public static EXTAcuerdo instanceOf(Acuerdo acuerdo) {
		EXTAcuerdo extAcuerdo = null;
		if (acuerdo == null) return null;
	    if (acuerdo instanceof HibernateProxy) {
	    	extAcuerdo = (EXTAcuerdo) ((HibernateProxy) acuerdo).getHibernateLazyInitializer()
	                .getImplementation();
	    } else if (acuerdo instanceof EXTAcuerdo){
	    	extAcuerdo = (EXTAcuerdo) acuerdo;
		}
		return extAcuerdo;
	}
}

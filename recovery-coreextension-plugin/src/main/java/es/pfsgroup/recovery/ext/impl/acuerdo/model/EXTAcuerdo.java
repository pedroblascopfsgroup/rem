package es.pfsgroup.recovery.ext.impl.acuerdo.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Transient;

import org.hibernate.proxy.HibernateProxy;

import es.capgemini.pfs.acuerdo.model.Acuerdo;

@Entity
public class EXTAcuerdo extends Acuerdo {

	private static final long serialVersionUID = 2075119525614504409L;
	
	@Column(name="ACU_MOTIVO")
	private String motivo;
	
	@Column(name = "ACU_FECHA_LIMITE")
	private Date fechaLimite;	

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

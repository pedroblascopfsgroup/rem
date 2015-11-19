package es.pfsgroup.recovery.ext.impl.expediente.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Transient;

import org.hibernate.proxy.HibernateProxy;

import es.capgemini.pfs.expediente.model.Expediente;

@Entity
public class EXTExpediente extends Expediente {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5821463045610951230L;

	@Column(name = "SYS_GUID")
	private String guid;

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

	@Transient
	public static EXTExpediente instanceOf(Expediente expediente) {
		EXTExpediente extExpediente = null;
		if (expediente == null)
			return null;
		if (expediente instanceof HibernateProxy) {
			extExpediente = (EXTExpediente) ((HibernateProxy) expediente)
					.getHibernateLazyInitializer().getImplementation();
		} else if (expediente instanceof EXTExpediente) {
			extExpediente = (EXTExpediente) expediente;
		}
		return extExpediente;
	}

}

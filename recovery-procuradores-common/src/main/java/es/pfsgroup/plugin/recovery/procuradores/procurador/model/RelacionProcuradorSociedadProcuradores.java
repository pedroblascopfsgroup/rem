package es.pfsgroup.plugin.recovery.procuradores.procurador.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.model.SociedadProcuradores;


@Entity
@Table(name = "PSP_PROC_SOCI_PROCS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
//@Inheritance(strategy=InheritanceType.JOINED)
//@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RelacionProcuradorSociedadProcuradores  implements Serializable {


	private static final long serialVersionUID = -5197160946795429731L;

	@Id
	@Column(name = "PR_SOC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "relPSPGenerator")
	@SequenceGenerator(name = "relPSPGenerator", sequenceName = "S_PSP_PROC_SOCI_PROCS")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "PRO_ID")	
	private Procurador procurador;
	
	@ManyToOne
	@JoinColumn(name = "SOC_PRO_ID")
	private SociedadProcuradores sociedad;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Procurador getProcurador() {
		return procurador;
	}

	public void setProcurador(Procurador procurador) {
		this.procurador = procurador;
	}
	
	public SociedadProcuradores getSociedad() {
		return sociedad;
	}

	public void setSociedad(SociedadProcuradores sociedad) {
		this.sociedad = sociedad;
	}



	
}


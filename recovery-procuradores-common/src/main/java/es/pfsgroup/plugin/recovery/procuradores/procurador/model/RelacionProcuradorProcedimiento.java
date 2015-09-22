package es.pfsgroup.plugin.recovery.procuradores.procurador.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Procedimiento;


@Entity
@Table(name = "PPR_PROCURADOR_PROCEDIMIENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
//@Inheritance(strategy=InheritanceType.JOINED)
//@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RelacionProcuradorProcedimiento  implements Serializable {


	private static final long serialVersionUID = -5197160946795429731L;

	@Id
	@Column(name = "PPR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "relPPRGenerator")
	@SequenceGenerator(name = "relPPRGenerator", sequenceName = "S_PPR_PROCURADOR_PROCEDIMIENTO")
	private Long procuradorProcedimiento;

	@ManyToOne
	@JoinColumn(name = "PRO_ID")	
	private Procurador procurador;
	
	@OneToOne
	@JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;


	public Procurador getProcurador() {
		return procurador;
	}

	public void setProcurador(Procurador procurador) {
		this.procurador = procurador;
	}
	
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Long getProcuradorProcedimiento() {
		return procuradorProcedimiento;
	}

	public void setProcuradorProcedimiento(Long procuradorProcedimiento) {
		this.procuradorProcedimiento = procuradorProcedimiento;
	}

	
}


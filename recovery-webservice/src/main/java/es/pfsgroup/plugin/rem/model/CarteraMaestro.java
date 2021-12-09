package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "CAM_CARTERA_MAESTRO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CarteraMaestro implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "CAM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CarteraMaestroGenerator")
    @SequenceGenerator(name = "CarteraMaestroGenerator", sequenceName = "S_CAM_CARTERA_MAESTRO")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SCR_ID")
    private DDSubcartera subcartera;

    @Column(name = "DE_CARTERA")
    private String deCartera;

    @Version
    private Long version;

    @Embedded
    private Auditoria auditoria;

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDSubcartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}

	public String getDeCartera() {
		return deCartera;
	}

	public void setDeCartera(String deCartera) {
		this.deCartera = deCartera;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}

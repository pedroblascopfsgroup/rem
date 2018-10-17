package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

@Entity
@Table(name = "MGD_MAPEO_GESTOR_DOC", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class MapeoGestorDocumental implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "MGD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MapeoGestorDocumentalGenerator")
    @SequenceGenerator(name = "MapeoGestorDocumentalGenerator", sequenceName = "S_MGD_MAPEO_GESTOR_DOC")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
	private DDCartera cartera;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SCR_ID")
	private DDSubcartera subcartera;
    
    @Column(name = "CLIENTE_GD")
    private String clienteGestorDocumental;

    @Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

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

	public String getClienteGestorDocumental() {
		return clienteGestorDocumental;
	}

	public void setClienteGestorDocumental(String clienteGestorDocumental) {
		this.clienteGestorDocumental = clienteGestorDocumental;
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
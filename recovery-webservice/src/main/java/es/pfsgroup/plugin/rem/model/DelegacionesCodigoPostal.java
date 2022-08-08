package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.pfsgroup.plugin.rem.model.dd.DDCodigoPostal;
import es.pfsgroup.plugin.rem.model.dd.DDIdioma;



/**
 * clase modelo de DCP_DELEGACIONES_CODIGO_POSTAL.
 *
 */
@Entity
@Table(name = "DCP_DELEGACIONES_CODIGO_POSTAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DelegacionesCodigoPostal implements Serializable,Auditable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "DCP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DelegacionesCodigoPostalGenerator")
    @SequenceGenerator(name = "DelegacionesCodigoPostalGenerator", sequenceName = "S_DCP_DELEGACIONES_CODIGO_POSTAL")
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "DD_CDP_ID")
    private DDCodigoPostal codigoPostal;
    
    @ManyToOne
    @JoinColumn(name = "PRD_ID")
    private ActivoProveedorDireccion direccion;

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

	public DDCodigoPostal getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(DDCodigoPostal codigoPostal) {
		this.codigoPostal = codigoPostal;
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

	public ActivoProveedorDireccion getDireccion() {
		return direccion;
	}

	public void setDireccion(ActivoProveedorDireccion direccion) {
		this.direccion = direccion;
	}

}

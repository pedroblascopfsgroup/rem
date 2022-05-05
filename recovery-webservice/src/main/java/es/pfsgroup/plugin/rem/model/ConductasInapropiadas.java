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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCategoriaConductaInapropiada;

/**
 * Modelo que gestiona las conducta inapropiadas de proveedor
 * 
 * @author Ivan Repiso
 *
 */
@Entity
@Table(name = "PVE_COI_CONDUCTAS_INAPROPIADAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ConductasInapropiadas implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "COI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ConductasInapropiadasGenerator")
	@SequenceGenerator(name = "ConductasInapropiadasGenerator", sequenceName = "S_PVE_COI_CONDUCTAS_INAPROPIADAS")
	private Long id;
	  
	@JoinColumn(name = "COI_PVE")  
    @ManyToOne(fetch = FetchType.LAZY)
	private ActivoProveedor proveedor;
	
	@JoinColumn(name = "DD_CCI_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
	private DDCategoriaConductaInapropiada categoriaConducta;
	
	@JoinColumn(name = "COI_DELEGACION")  
    @ManyToOne(fetch = FetchType.LAZY)
	private ActivoProveedorDireccion delegacion;
	 
	@Column(name = "COI_COMENTARIOS")   
	private String comentarios;
	
	@JoinColumn(name = "COI_ADJUNTO")  
    @ManyToOne(fetch = FetchType.LAZY)
	private ActivoAdjuntoProveedor adjunto;
	    
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

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public DDCategoriaConductaInapropiada getCategoriaConducta() {
		return categoriaConducta;
	}

	public void setCategoriaConducta(DDCategoriaConductaInapropiada categoriaConducta) {
		this.categoriaConducta = categoriaConducta;
	}

	public ActivoProveedorDireccion getDelegacion() {
		return delegacion;
	}

	public void setDelegacion(ActivoProveedorDireccion delegacion) {
		this.delegacion = delegacion;
	}

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}

	public ActivoAdjuntoProveedor getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(ActivoAdjuntoProveedor adjunto) {
		this.adjunto = adjunto;
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

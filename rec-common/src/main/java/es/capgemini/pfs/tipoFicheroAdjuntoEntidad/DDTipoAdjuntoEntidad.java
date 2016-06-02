package es.capgemini.pfs.tipoFicheroAdjuntoEntidad;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;


@Entity
@Table(name = "DD_TAE_TIPO_ADJUNTO_ENTIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoAdjuntoEntidad implements Dictionary, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -557719714246495010L;

	@Id
    @Column(name = "DD_TAE_ID")
    private Long id;

    @Column(name = "DD_TAE_CODIGO")
    private String codigo;

    @Column(name = "DD_TAE_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TAE_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "TAE_EIN", joinColumns = { @JoinColumn(name = "DD_TAE_ID", unique = true) }, inverseJoinColumns = { @JoinColumn(name = "DD_EIN_ID") })
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<DDTipoEntidad> tiposEntidad;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public List<DDTipoEntidad> getTiposEntidad() {
		return tiposEntidad;
	}

	public void setTiposEntidad(List<DDTipoEntidad> tiposEntidad) {
		this.tiposEntidad = tiposEntidad;
	}

}

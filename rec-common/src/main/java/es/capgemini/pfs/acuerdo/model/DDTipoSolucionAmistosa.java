package es.capgemini.pfs.acuerdo.model;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Entidad AnalisisCapacidadPago.
 *
 * @author jpbosnjak /marruiz
 *
 */
@Entity
@Table(name = "DD_TSA_TIPO_SOLUC_AMISTO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoSolucionAmistosa implements Dictionary, Auditable  {

	private static final long serialVersionUID = -5000987797957822994L;

	@Id
	@Column(name = "DD_TSA_ID")
	private Long id;

	@Column(name = "DD_TSA_CODIGO")
	private String codigo;

	@Column(name = "DD_TSA_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_TSA_DESCRIPCION_LARGA")
	private String descripcionLarga;

    @OneToMany(mappedBy = "ddTipoSolucionAmistosa", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TSA_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<DDSubtipoSolucionAmistosaAcuerdo> ddSubtiposSolucionAmistosaAcuerdo;

    @Column(name = "DD_TSA_ACTIVO")
    private boolean activo;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the codigo
	 */
	public String getCodigo() {
		return codigo;
	}

	/**
	 * @param codigo
	 *            the codigo to set
	 */
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	/**
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}

	/**
	 * @param descripcion
	 *            the descripcion to set
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	/**
	 * @return the descripcionLarga
	 */
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	/**
	 * @param descripcionLarga
	 *            the descripcionLarga to set
	 */
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	/**
	 * @return the auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * @param auditoria
	 *            the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version
	 *            the version to set
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

    /**
     * @return the activo
     */
    public boolean isActivo() {
        return activo;
    }

    /**
     * @param activo the activo to set
     */
    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    /**
     * @return the ddSubtiposSolucionAmistosaAcuerdo
     */
    public List<DDSubtipoSolucionAmistosaAcuerdo> getDdSubtiposSolucionAmistosaAcuerdo() {
        return ddSubtiposSolucionAmistosaAcuerdo;
    }

    /**
     * @param ddSubtiposSolucionAmistosaAcuerdo the ddSubtiposSolucionAmistosaAcuerdo to set
     */
    public void setDdSubtiposSolucionAmistosaAcuerdo(List<DDSubtipoSolucionAmistosaAcuerdo> ddSubtiposSolucionAmistosaAcuerdo) {
        this.ddSubtiposSolucionAmistosaAcuerdo = ddSubtiposSolucionAmistosaAcuerdo;
    }
}

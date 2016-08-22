package es.pfsgroup.framework.paradise.bulkUpload.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;


/**
 * Clase que modela el diccionario de tipos de juicio.
 * @author manuel
 *
 */
@Entity
@Table(name = "DD_TJ_TIPO_JUICIO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVDDTipoJuicio implements Serializable, Auditable{

	private static final long serialVersionUID = -4918480199449262484L;
	
	@Id
    @Column(name = "DD_TJ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDDTipoJuicioGenerator")
    @SequenceGenerator(name = "MSVDDTipoJuicioGenerator", sequenceName = "S_DD_TJ_TIPO_JUICIO")
    private Long id;

    @Column(name = "DD_TJ_CODIGO")
    private String codigo;

    @Column(name = "DD_TJ_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TJ_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @ManyToOne
    @JoinColumn(name = "DD_TPO_ID")
    private TipoProcedimiento tipoProcedimiento;
    
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
    
    public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	

}

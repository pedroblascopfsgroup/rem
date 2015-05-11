package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.DDTipoProdBancarioInfo;

@Entity
@Table(name = "DD_TPB_TIPO_PROD_BANCARIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DDTipoProdBancario implements  Serializable, Auditable, DDTipoProdBancarioInfo {

	private static final long serialVersionUID = -4497097910086775262L;

	@Id
    @Column(name = "DD_TPB_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TipoProdBancarioGenerator")
    @SequenceGenerator(name = "TipoProdBancarioGenerator", sequenceName = "S_DD_TPB_TIPO_PROD_BANCARIO")
    private Long id;

    @Column(name = "DD_TPB_CODIGO")
    private String codigo;   
    
    @Column(name = "DD_TPB_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "DD_TPB_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Embedded
    private Auditoria auditoria;

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

}

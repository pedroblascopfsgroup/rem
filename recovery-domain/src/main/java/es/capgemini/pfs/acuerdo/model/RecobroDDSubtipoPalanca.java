package es.capgemini.pfs.acuerdo.model;

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
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "RCF_STP_SUBTIPO_PALANCA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroDDSubtipoPalanca implements Auditable, Dictionary{
	
	private static final long serialVersionUID = -4807464097772185758L;

	@Id
    @Column(name = "RCF_STP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SubtipoPalancaGenerator")
	@SequenceGenerator(name = "SubtipoPalancaGenerator", sequenceName = "S_RCF_STP_SUBTIPO_PALANCA")
    private Long id;

	@ManyToOne
	@JoinColumn(name = "RCF_TPP_ID", nullable = true)
	private RecobroDDTipoPalanca tipoPalanca;
	
    @Column(name = "RCF_STP_CODIGO")
    private String codigo;

    @Column(name = "RCF_STP_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "RCF_STP_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Version
    private Integer version;

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

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga){
		this.descripcionLarga=descripcionLarga;
	}

	public RecobroDDTipoPalanca getTipoPalanca() {
		return tipoPalanca;
	}

	public void setTipoPalanca(RecobroDDTipoPalanca tipoPalanca) {
		this.tipoPalanca = tipoPalanca;
	}
    
}

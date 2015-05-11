package es.pfsgroup.plugin.recovery.masivo.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_ECR_ESPERAR_CONTINUAR", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVDDEsperarContinuar implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
    public static final String ESPERAR = "01";
    public static final String CONTINUAR = "02";

    @Id
    @Column(name = "DD_ECR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDDEsperarContinuarGenerator")
    @SequenceGenerator(name = "MSVDDEsperarContinuarGenerator", sequenceName = "S_DD_ECR_ESPERAR_CONTINUAR")
    private Long id;

    @Column(name = "DD_ECR_CODIGO")
    private String codigo;

    @Column(name = "DD_ECR_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_ECR_DESCRIPCION_LARGA")
    private String descripcionLarga;

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

	

}

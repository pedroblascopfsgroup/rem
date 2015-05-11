package es.capgemini.pfs.multigestor.model;

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
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_SUP_SUPERVISORES", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class EXTDDSupervisores implements Dictionary, Auditable{
	
	private static final long serialVersionUID = -2158549405216877142L;

	@Id
    @Column(name = "DD_SUP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTDDSupervisoresGenerator")
    @SequenceGenerator(name = "EXTDDSupervisoresGenerator", sequenceName = "S_DD_SUP_SUPERVISORES")
    private Long id;
	
	@Column(name = "DD_SUP_CODIGO")
	private String codigo;
	
	@Column(name = "DD_SUP_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "DD_SUP_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_TGE_SUP")
	private EXTDDTipoGestor supervisor;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_TGE_GES")
	private EXTDDTipoGestor gestorSupervisado;
	
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

	public void setSupervisor(EXTDDTipoGestor supervisor) {
		this.supervisor = supervisor;
	}

	public EXTDDTipoGestor getSupervisor() {
		return supervisor;
	}

	public void setGestorSupervisado(EXTDDTipoGestor gestorSupervisado) {
		this.gestorSupervisado = gestorSupervisado;
	}

	public EXTDDTipoGestor getGestorSupervisado() {
		return gestorSupervisado;
	}
	

}

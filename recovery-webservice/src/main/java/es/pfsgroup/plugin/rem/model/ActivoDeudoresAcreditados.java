package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumento;

@Entity
@Table(name = "ACT_DEU_DEUDOR_ACREDITADO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoDeudoresAcreditados implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "ACT_DEU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoDeudorAcreditadoGenerator")
    @SequenceGenerator(name = "ActivoDeudorAcreditadoGenerator", sequenceName = "S_ACT_DEU_DEUDOR_ACREDITADO")
    private Long id;
	
//	@ManyToOne(fetch = FetchType.LAZY)
//	@JoinColumn(name="ACT_ID",nullable = false)
//	private Activo idActivo;
	
//	@ManyToOne(fetch = FetchType.LAZY)
//	@JoinColumn(name = "DD_TDI_ID")
//	private DDTipoDocumento tipoDocIdentificativoDesc;
	
//	@ManyToOne(fetch = FetchType.LAZY)
//	@JoinColumn(name = "USU_ID")
//	private Usuario gestorAlta;
//	
//	@ManyToOne(fetch = FetchType.LAZY)
//	@JoinColumn(name = "COM_ID")
//	private Comprador comprador;
	
	@Column(name = "DEU_NUM_DOC")
    private String docIdentificativo;
	
	@Column(name = "DEU_NOMBRE")
    private String nombre;
    
    @Column(name = "DEU_APELLIDO1")
    private String apellido1;
    
    @Column(name = "DEU_APELLIDO2")
    private String apellido2;
    
    @Column(name = "DEU_FECHA_ALTA")
    private Date fechaAlta;
    
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

//	public Activo getIdActivo() {
//		return idActivo;
//	}
//
//	public void setIdActivo(Activo idActivo) {
//		this.idActivo = idActivo;
//	}

//	public DDTipoDocumento getTipoDocIdentificativoDesc() {
//		return tipoDocIdentificativoDesc;
//	}
//
//	public void setTipoDocIdentificativoDesc(DDTipoDocumento tipoDocIdentificativoDesc) {
//		this.tipoDocIdentificativoDesc = tipoDocIdentificativoDesc;
//	}
//
//	public Usuario getGestorAlta() {
//		return gestorAlta;
//	}
//
//	public void setGestorAlta(Usuario gestorAlta) {
//		this.gestorAlta = gestorAlta;
//	}
//
//	public Comprador getComprador() {
//		return comprador;
//	}
//
//	public void setComprador(Comprador comprador) {
//		this.comprador = comprador;
//	}

	public String getDocIdentificativo() {
		return docIdentificativo;
	}

	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellido1() {
		return apellido1;
	}

	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}

	public String getApellido2() {
		return apellido2;
	}

	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	
}

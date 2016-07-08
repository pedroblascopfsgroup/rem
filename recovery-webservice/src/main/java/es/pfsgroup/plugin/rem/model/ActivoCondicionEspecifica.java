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

/**
 * Modelo que gestiona las condiciones específicas de los activos.
 * 
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "ACT_COE_CONDICION_ESPECIFICA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCondicionEspecifica implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "COE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCondicionEspecificaGenerator")
    @SequenceGenerator(name = "ActivoCondicionEspecificaGenerator", sequenceName = "S_ACT_COE_CONDICION_ESPECIFICA")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo; 
	 
	@Column(name = "COE_TEXTO")
	private String texto;
	
	@Column(name = "COE_FECHA_DESDE")
	private Date fechaDesde;
	
	@Column(name = "COE_FECHA_HASTA")
	private Date fechaHasta;
	
	@ManyToOne
	@JoinColumn(name = "COE_USUARIO_ALTA")
	private Usuario usuarioAlta;
	
	@ManyToOne
	@JoinColumn(name = "COE_USUARIO_BAJA")
	private Usuario usuarioBaja;
		
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public String getTexto() {
		return texto;
	}

	public void setTexto(String texto) {
		this.texto = texto;
	}

	public Date getFechaDesde() {
		return fechaDesde;
	}

	public void setFechaDesde(Date fechaDesde) {
		this.fechaDesde = fechaDesde;
	}

	public Date getFechaHasta() {
		return fechaHasta;
	}

	public void setFechaHasta(Date fechaHasta) {
		this.fechaHasta = fechaHasta;
	}

	public Usuario getUsuarioAlta() {
		return usuarioAlta;
	}

	public void setUsuarioAlta(Usuario usuarioAlta) {
		this.usuarioAlta = usuarioAlta;
	}

	public Usuario getUsuarioBaja() {
		return usuarioBaja;
	}

	public void setUsuarioBaja(Usuario usuarioBaja) {
		this.usuarioBaja = usuarioBaja;
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

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}

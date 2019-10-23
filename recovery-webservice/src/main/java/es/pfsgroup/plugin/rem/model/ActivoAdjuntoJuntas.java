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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocJuntas;

/**
 * 
 * HREOS-7359
 * 
 * Modelo que gestiona la informacion de Juntas de un activo
 *  
 * @author Alfonso Rodriguez Verdera
 *
 */


@Entity
@Table(name = "ACT_ADN_ADJUNTO_JUNTAS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoAdjuntoJuntas implements Serializable, Auditable {

	private static final long serialVersionUID = 750359188915093506L;

	@Id
	@Column(name = "ADN_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAdjuntoJuntasGenerator")
	@SequenceGenerator(name = "ActivoAdjuntoJuntasGenerator", sequenceName = "S_ACT_ADN_ADJUNTO_JUNTAS")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "JCM_ID")
	private ActivoJuntaPropietarios activoJuntaPropietario;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TDJ_ID")
	private DDTipoDocJuntas tipoDocumento;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ADJ_ID")
	private Adjunto idAdj;

	@Column(name = "ADN_NOMBRE")
	private String nombreAdn;

	@Column(name = "ADN_CONTENT_TYPE")
	private String tipoContenido;

	@Column(name = "ADN_FECHA_DOCUMENTO")
	private Date fechaAltaJunta;

	@Column(name = "ADN_LENGTH")
	private Long tamanyo;

	@Column(name = "ADN_DESCRIPCION")
	private String descripcion;

	@Column(name = "ADN_ID_DOCUMENTO_REST")
	private Long documento_Rest;

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

	public ActivoJuntaPropietarios getActivoJuntaPropietario() {
		return activoJuntaPropietario;
	}

	public void setActivoJuntaPropietario(ActivoJuntaPropietarios activoJuntaPropietario) {
		this.activoJuntaPropietario = activoJuntaPropietario;
	}

	public DDTipoDocJuntas getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(DDTipoDocJuntas tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public Adjunto getIdAdj() {
		return idAdj;
	}

	public void setIdAdj(Adjunto idAdj) {
		this.idAdj = idAdj;
	}

	public String getNombreAdn() {
		return nombreAdn;
	}

	public void setNombreAdn(String nombreAdn) {
		this.nombreAdn = nombreAdn;
	}

	public String getTipoContenido() {
		return tipoContenido;
	}

	public void setTipoContenido(String tipoContenido) {
		this.tipoContenido = tipoContenido;
	}

	public Date getFechaAltaJunta() {
		return fechaAltaJunta;
	}

	public void setFechaAltaJunta(Date fechaAltaJunta) {
		this.fechaAltaJunta = fechaAltaJunta;
	}

	public Long getTamnyo() {
		return tamanyo;
	}

	public void setTamanyo(Long tamanyo) {
		this.tamanyo = tamanyo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Long getDocumento_Rest() {
		return documento_Rest;
	}

	public void setDocumento_Rest(Long documento_Rest) {
		this.documento_Rest = documento_Rest;
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

package es.pfsgroup.plugin.rem.model.dd;

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

/**
 * Modelo que gestiona el diccionario de motivo de ocultación para la publicación de un activo.
 */
@Entity
@Table(name = "DD_MTO_MOTIVOS_OCULTACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DDMotivosOcultacion implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;

	public static final String CODIGO_NO_PUBLICABLE = "01";
	public static final String CODIGO_NO_COMERCIALZIABLE = "02";
	public static final String CODIGO_ALQUILADO = "03";
	public static final String CODIGO_REVISION_ADECUACION = "04";
	public static final String CODIGO_NO_ADECUADO = "05";
	public static final String CODIGO_REVISION_PUBLICACION = "06";
	public static final String CODIGO_RESERVADO = "07";
	public static final String CODIGO_SALIDA_PERIMETRO = "08";
	public static final String CODIGO_REVISION_ADMISION = "09";
	public static final String CODIGO_REVISION_TECNICA = "10";
	public static final String CODIGO_REVISION_EN_CURSO = "11";
	public static final String CODIGO_OTROS = "12";
	public static final String CODIGO_VENDIDO = "13";
	public static final String CODIGO_SIN_PRECIO = "14";
	public static final String CODIGO_OFERTA_EXPRESS = "15";

	@Id
	@Column(name = "DD_MTO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivosOcultacionGenerator")
	@SequenceGenerator(name = "DDMotivosOcultacionGenerator", sequenceName = "S_DD_MTO_MOTIVOS_OCULTACION")
	private Long id;

	@Column(name = "DD_MTO_CODIGO")
	private String codigo;

	@Column(name = "DD_MTO_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_MTO_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCO_ID")
    private DDTipoComercializacion tipoComercializacion;
	
	@Column(name = "DD_MTO_MANUAL")
	private Boolean esMotivoManual;

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

	public DDTipoComercializacion getTipoComercializacion() {
		return tipoComercializacion;
	}

	public void setTipoComercializacion(DDTipoComercializacion tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}

	public Boolean getEsMotivoManual() {
		return esMotivoManual;
	}

	public void setEsMotivoManual(Boolean esMotivoManual) {
		this.esMotivoManual = esMotivoManual;
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

}
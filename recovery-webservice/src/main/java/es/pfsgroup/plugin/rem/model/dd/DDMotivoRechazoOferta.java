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
 * Modelo que gestiona el diccionario de motivos de anulacion de un expediente comercial
 * 
 * @author Bender
 *
 */
@Entity
@Table(name = "DD_MRO_MOTIVO_RECHAZO_OFERTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivoRechazoOferta implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_DECISION_COMITE = "18";
	public static final String CODIGO_PBC_DENEGADO = "902";
	public static final String CODIGO_ACTIVO_VENDIDO = "705";
	public static final String CODIGO_OTROS = "20";
	public static final String CODIGO_PENDIENTE_RECOMENDACION_INTERNA = "916";

	@Id
	@Column(name = "DD_MRO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoRechazoOfertaGenerator")
	@SequenceGenerator(name = "DDMotivoRechazoOfertaGenerator", sequenceName = "S_DD_MRO_MOTIVO_RECHAZO_OFERTA")
	private Long id;
	
	@JoinColumn(name = "DD_TRO_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
	private DDTipoRechazoOferta tipoRechazo;
	    
	@Column(name = "DD_MRO_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MRO_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MRO_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_MRO_VENTA")   
	private Boolean venta;

	@Column(name = "DD_MRO_ALQUILER")   
	private Boolean alquiler;
	
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
	
	public DDTipoRechazoOferta getTipoRechazo() {
		return tipoRechazo;
	}

	public void setTipoRechazo(DDTipoRechazoOferta tipoRechazo) {
		this.tipoRechazo = tipoRechazo;
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
	
	public Boolean getVenta() {
		return venta;
	}

	public void setVenta(Boolean venta) {
		this.venta = venta;
	}
	
	public Boolean getAlquiler() {
		return alquiler;
	}

	public void setAlquiler(Boolean alquiler) {
		this.alquiler = alquiler;
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
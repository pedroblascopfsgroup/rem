package es.pfsgroup.plugin.rem.model.dd;

import java.io.Serializable;

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
@Table(name = "DD_TPE_TRIB_PROP_CLI_EX_IVA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTributacionPropuestaClienteExentoIva implements Auditable, Serializable {
	
		
	private static final long serialVersionUID = 1L;

	public static final String CODIGO_IVA_REPERCUTIDO="30";
	public static final String CODIGO_IGIC_REPERCUTIDO="33";
	public static final String CODIGO_IVA_REPERCUTIDO_ALQ_CON_RETENCION="2H";
	public static final String CODIGO_IVA_REPERCUTIDO_ALQ_SIN_RETENCION="2J";
	public static final String CODIGO_IVA_REPERCUTIDO_VENTAS_7="HA";
	public static final String CODIGO_IVA_REPERCUTIDO_VENTAS_0="R0";
	public static final String CODIGO_IVA_REPERCUTIDO_ALQUILERES_VIVIENDAS="R2";
	public static final String CODIGO_IVA_REPERCUTIDO_VENTAS_4="R1";
	public static final String CODIGO_IVA_REPERCUTIDO_ALQUILERES_4="R3";
	public static final String CODIGO_IVA_REPERCUTIDO_VENTAS_10="R8";
	public static final String CODIGO_IVA_REPERCUTIDO_ALQUILERES_10="R4";
	public static final String CODIGO_IVA_REPERCUTIDO_VENTAS_21="R9";
	public static final String CODIGO_IVA_REPERCUTIDO_PRESTACION_SERVICIOS="R5";
	public static final String CODIGO_IVA_REPERCUTIDO_VENTAS_4_MELILLA="RH";
	public static final String CODIGO_IVA_REPERCUTIDO_ALQUILERES_4_MELILLA="RI";
	public static final String CODIGO_IVA_REPERCUTIDO_VENTAS_7_0="RM";
	public static final String CODIGO_IVA_REPERCUTIDO_ALQUILERES_7_0="RN";
	public static final String CODIGO_IVA_REPERCUTIDO_VENTAS_6_5="RP";
	public static final String CODIGO_IGIC_REPERCUTIDO_ALQU_0="RS";
	public static final String CODIGO_IGIC_REPERCUTIDO_CEUTA_6="RV";
	public static final String CODIGO_SIN_EFECTO_FISCAL="RX";
	public static final String CODIGO_IPSI_REPERC_0_ITP="RY";
	public static final String CODIGO_NO_SUJETO_IVA="RZ";
	public static final String CODIGO_IGIC_REPERC_0_ITP_VENTAS="WA";
	
	@Id
	@Column(name = "DD_TPE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTributPropCliExentoIvaGenerator")
	@SequenceGenerator(name = "DDTributPropCliExentoIvaGenerator", sequenceName = "S_DD_TPE_TRIB_PROP_CLI_EX_IVA")
	private Long id;
	 
	@Column(name = "DD_TPE_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPE_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
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

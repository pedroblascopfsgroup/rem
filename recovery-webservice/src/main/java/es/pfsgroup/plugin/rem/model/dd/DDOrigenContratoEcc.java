package es.pfsgroup.plugin.rem.model.dd;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de tipos de origen de contrato de ECC.
 * 
 * @author Alejandro Valverde
 *
 */
@Entity
@Table(name = "DD_OCN_ORIGEN_CONTRATO_ECC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDOrigenContratoEcc implements Auditable, Dictionary {
		
	public static final String CODIGO_COMERCIAL = "01";
	public static final String CODIGO_SUBROGACION = "02";
	public static final String CODIGO_ANTIGUO_DEUDOR = "03";
	public static final String CODIGO_CONVENIO_AAPP = "04";
	public static final String CODIGO_COLABORACION_AYUNTAMIENTO = "05";
	public static final String CODIGO_OCUPACIONAL_TERCEROS = "06";
	public static final String CODIGO_PROGRAMA_CENTRALIZADO = "07";
	public static final String CODIGO_FSV_FONDO_SOCIAL_VIVIENDA = "08";
	public static final String CODIGO_FSV_CONVENIO_AAPP = "09";
	
	public static final String CODIGO_C4C_COMERCIAL = "101";
	public static final String CODIGO_C4C_SUBROGACION = "111";
	public static final String CODIGO_C4C_ANTIGUO_DEUDOR = "121";
	public static final String CODIGO_C4C_CONVENIO_AAPP = "131";
	public static final String CODIGO_C4C_COLABORACION_AYUNTAMIENTO = "141";
	public static final String CODIGO_C4C_OCUPACIONAL_TERCEROS = "151";
	public static final String CODIGO_C4C_PROGRAMA_CENTRALIZADO = "161";
	public static final String CODIGO_C4C_FSV_FONDO_SOCIAL_VIVIENDA = "171";
	public static final String CODIGO_C4C_FSV_CONVENIO_AAPP = "181";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_OCN_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDOrigenContratoEccGenerator")
	@SequenceGenerator(name = "DDOrigenContratoEccGenerator", sequenceName = "S_DD_OCN_ORIGEN_CONTRATO_ECC")
	private Long id;
	    
	@Column(name = "DD_OCN_CODIGO")   
	private String codigo;
    
	@Column(name = "DD_OCN_CODIGO_C4C")   
	private String codigoC4C;
	 
	@Column(name = "DD_OCN_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_OCN_DESCRIPCION_LARGA")   
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

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}

}
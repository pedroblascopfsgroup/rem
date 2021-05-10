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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de los subtipos de activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_SAC_SUBTIPO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoActivo implements Auditable, Dictionary {
	
	public static final String CODIGO_SUBTIPO_NO_URBAN_RUSTICO = "01";
	public static final String CODIGO_SUBTIPO_URBANIZABLE_NO_PROGRAMADO = "02";
	public static final String CODIGO_SUBTIPO_URBANIZABLE_PROGRAMADO = "03";
	public static final String CODIGO_SUBTIPO_URBANO_SOLAR = "04";
	public static final String CODIGO_SUBTIPO_UNIFAMILIAR_AISLADA = "05";
	public static final String CODIGO_SUBTIPO_UNIFAMILIAR_ADOSADA = "06";
	public static final String CODIGO_SUBTIPO_UNIFAMILIAR_PAREADA = "07";
	public static final String CODIGO_SUBTIPO_UNIFAMILIAR_CASA_DE_PUEBLO = "08";
	public static final String CODIGO_SUBTIPO_PISO = "09";
	public static final String CODIGO_SUBTIPO_PISO_DUPLEX = "10";
	public static final String CODIGO_SUBTIPO_ATICO = "11";
	public static final String CODIGO_SUBTIPO_ESTUDIO_O_LOFT = "12";
	public static final String COD_LOCAL_COMERCIAL ="13";
	public static final String CODIGO_SUBTIPO_OFICINA = "14";
	public static final String CODIGO_SUBTIPO_ALMACEN = "15";
	public static final String CODIGO_SUBTIPO_HOTEL = "16";
	public static final String CODIGO_SUBTIPO_NAVE_AISLADA = "17";
	public static final String CODIGO_SUBTIPO_NAVE_ADOSADA = "18";
	public static final String CODIGO_SUBTIPO_APARCAMIENTO= "19";
	public static final String CODIGO_SUBTIPO_HOTEL_O_APARTAMENTOS_TURISTICOS = "20";
	public static final String CODIGO_EN_CONSTRUCCION = "23";
	public static final String COD_GARAJE ="24";
	public static final String COD_TRASTERO ="25";
	public static final String CODIGO_SUBTIPO_LOCAL_COMERCIAL = "13";
	public static final String CODIGO_SUBTIPO_APARTAMENTO_TURISTICO = "40";
	public static final String CODIGO_SUBTIPO_HOSTELERO = "41";
	public static final String CODIGO_SUBTIPO_SUELO_URBANO_NO_CONSOLIDADO = "42";
	public static final String CODIGO_SUBTIPO_RESIDENCIAL_VIVIENDAS_LOCALES_TRASTEROS_GARAJES= "43";
	public static final String CODIGO_SUBTIPO_OFICINA_EDIFICIO_COMPLETO = "21";


	/**
	 * 
	 */
	private static final long serialVersionUID = -8653244063687370245L;

	@Id
	@Column(name = "DD_SAC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoActivoGenerator")
	@SequenceGenerator(name = "DDSubtipoActivoGenerator", sequenceName = "S_DD_SAC_SUBTIPO_ACTIVO")
	private Long id;
	  
	@JoinColumn(name = "DD_TPA_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
	private DDTipoActivo tipoActivo;
	
	@Column(name = "DD_SAC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SAC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SAC_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_SAC_EN_BBVA")   
	private boolean enBbva;
	    
	@Transient
	private String codigoTipoActivo;
	
	    
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
	
	public String getCodigo() {
		return codigo;
	}
	
	public void setCodigo(String codigo) {
		this.codigo = codigo;
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

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getCodigoTipoActivo() {
		return tipoActivo.getCodigo();
	}

	public void setCodigoTipoActivo(String codigoTipoActivo) {
		this.codigoTipoActivo = tipoActivo.getCodigo();
	}

	public boolean isEnBbva() {
		return enBbva;
	}

	public void setEnBbva(boolean enBbva) {
		this.enBbva = enBbva;
	}



}

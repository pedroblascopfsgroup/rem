package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
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
 * Modelo que gestiona el diccionario de subtipos de trabajo.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_STR_SUBTIPO_TRABAJO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoTrabajo implements Auditable, Dictionary {
	
    public static final String CODIGO_INFORME_COMERCIAL = "08";
    public static final String CODIGO_DECRETO_ADJUDICACION = "09";
    public static final String CODIGO_ESCRITURA_PUBLICA = "10";
    public static final String CODIGO_DILIGENCIA_TOMA_POSESION = "11";
    public static final String CODIGO_NOTA_SIMPLE_SIN_CARGAS = "12";
    public static final String CODIGO_NOTA_SIMPLE_ACTUALIZADA = "13";
    public static final String CODIGO_TASACION_ADJUDICACION = "14";
    public static final String CODIGO_VPO_AUTORIZACION_VENTA = "15";
    public static final String CODIGO_VPO_NOTIFICACION_ADJUDICACION = "16";
    public static final String CODIGO_VPO_SOLICITUD_DEVOLUCION = "17";
    public static final String CODIGO_CEE = "18";
    public static final String CODIGO_LPO = "19";
    public static final String CODIGO_CEDULA_HABITABILIDAD = "20";
    public static final String CODIGO_CFO = "21";
    public static final String CODIGO_BOLETIN_AGUA = "22";
    public static final String CODIGO_BOLETIN_ELECTRICIDAD = "23";
    public static final String CODIGO_BOLETIN_GAS = "24";
    public static final String CODIGO_OBTENCION_CERTIFICADOS = "25";
    public static final String CODIGO_AT_VERIFICACION_AVERIAS = "36";
    public static final String CODIGO_INFORMES = "14";
    public static final String CODIGO_AT_TAPIADO = "27";
    public static final String CODIGO_AT_OBRA_MENOR_NO_TARIFICADA = "38";
    public static final String CODIGO_AT_CONTROL_ACTUACIONES = "39";
    public static final String CODIGO_AT_COLOCACION_PUERTAS = "40";
    public static final String CODIGO_AT_MOBILIARIO = "41";

    public static final String CODIGO_ACTUALIZACION_PRECIOS = "42";
    public static final String CODIGO_ACTUALIZACION_PRECIOS_DESCUENTO = "43";
    public static final String CODIGO_TRAMITAR_PROPUESTA_PRECIOS = "44";
    public static final String CODIGO_TRAMITAR_PROPUESTA_DESCUENTO = "45";							
    public static final String CODIGO_PRECIOS_BLOQUEAR_ACTIVOS = "46";
    public static final String CODIGO_PRECIOS_DESBLOQUEAR_ACTIVOS = "47";
    
    public static final String CODIGO_SANCION_OFERTA = "55";

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_STR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoTrabajoGenerator")
	@SequenceGenerator(name = "DDSubtipoTrabajoGenerator", sequenceName = "S_DD_STR_SUBTIPO_TRABAJO")
	private Long id;
	
	@JoinColumn(name = "DD_TTR_ID")  
	@OneToOne
	private DDTipoTrabajo tipoTrabajo;
	    
	@Column(name = "DD_STR_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_STR_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_STR_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Transient
	private String codigoTipoTrabajo;
	    
	
	    
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

	public DDTipoTrabajo getTipoTrabajo() {
		return tipoTrabajo;
	}

	public void setTipoTrabajo(DDTipoTrabajo tipoTrabajo) {
		this.tipoTrabajo = tipoTrabajo;
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
	
	public String getCodigoTipoTrabajo() {
		return tipoTrabajo.getCodigo();
	}
	public void setCodigoTipoTrabajo(String codigoTipoTrabajo) {
		this.codigoTipoTrabajo = tipoTrabajo.getCodigo();
	}

}




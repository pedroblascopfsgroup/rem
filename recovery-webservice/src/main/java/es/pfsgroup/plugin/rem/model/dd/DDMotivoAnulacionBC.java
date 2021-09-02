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


@Entity
@Table(name = "DD_MAB_MOTIV_APLAZA_BC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivoAnulacionBC implements Auditable, Dictionary {
	
	public static final String CODIGO_FINANCIACION_EN_CURSO= "01";
	public static final String CODIGO_COMUNICACION_API_PENDIENTE= "02";
	public static final String CODIGO_PROBLEMAS_JURIDICOS= "03";
	public static final String CODIGO_PROBLEMAS_TECNICOS_DOC_PDTE= "04";
	public static final String CODIGO_CAMBIOS_CONTRATO= "05";
	public static final String CODIGO_TRAMITACION_VPO= "06";
	public static final String CODIGO_MOTIVOS_PERSONALES_COMPRADOR= "07";
	public static final String CODIGO_CEDULA_HABITALIDAD= "08";
	public static final String CODIGO_ANULACION_VENTA_CURSO= "09";
	public static final String CODIGO_FECHA_FIRMA_CURSO= "10";
	public static final String CODIGO_CARGAS= "11";
	public static final String CODIGO_LINDEROS= "12";
	public static final String CODIGO_CATASTRO= "13";
	public static final String CODIGO_FUSION= "14";
	public static final String CODIGO_DL_115= "15";
	public static final String CODIGO_CEE= "16";
	public static final String CODIGO_PENDIENTE_PBC= "17";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_MAB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotAnulacionBcGenerator")
	@SequenceGenerator(name = "DDMotAnulacionBcGenerator", sequenceName = "S_DD_MAB_MOTIV_APLAZA_BC")
	private Long id;
	    
	@Column(name = "DD_MAB_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MAB_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MAB_DESCRIPCION_LARGA")   
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
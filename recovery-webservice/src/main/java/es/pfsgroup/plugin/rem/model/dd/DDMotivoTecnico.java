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
 * Modelo que gestiona el diccionario del motivo técnico
 * 
 * @author Adrián Molina
 *
 */
@Entity
@Table(name = "DD_MTC_MOTIVO_TECNICO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivoTecnico implements Auditable, Dictionary {
	
	
	public static final String COD_CAMBIO_MASIVO_INCOHERENTE ="00";
	public static final String COD_RESERVA_PREVIA ="01";
	public static final String COD_PREV_PASE_A_FUNCIONAL ="02";
	public static final String COD_VENTA_CARTERA ="03";
	public static final String COD_DECISION_INTERNA_CAJAMAR ="04";
	public static final String COD_FIRMA_CONTRATO_EXCLUSIVIDAD ="09";
	public static final String COD_PENDIENTE_PRECIO ="17";
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 2307957295534774606L;

	@Id
	@Column(name = "DD_MTC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoTecnicoGenerator")
	@SequenceGenerator(name = "DDMotivoTecnicoGenerator", sequenceName = "S_DD_MTC_MOTIVO_TECNICO")
	private Long id;
	
	@Column(name = "DD_MTC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MTC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MTC_DESCRIPCION_LARGA")   
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

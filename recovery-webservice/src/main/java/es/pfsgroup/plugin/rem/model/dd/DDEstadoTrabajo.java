

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
 * Modelo que gestiona el diccionario de estados de los trabajos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_EST_ESTADO_TRABAJO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoTrabajo implements Auditable, Dictionary {
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
    public static final String ESTADO_SOLICITADO = "01";
	public static final String ESTADO_ANULADO = "02";
	public static final String ESTADO_RECHAZADO = "03";
	public static final String ESTADO_EN_TRAMITE = "04";
	public static final String ESTADO_PENDIENTE_PAGO = "05";
	public static final String ESTADO_PAGADO = "06";
	public static final String ESTADO_IMPOSIBLE_OBTENCION = "07";
	public static final String ESTADO_FALLIDO = "08";
	public static final String ESTADO_CEE_PENDIENTE_ETIQUETA = "09";
	public static final String ESTADO_FINALIZADO_PENDIENTE_VALIDACION = "10";
	

	@Id
	@Column(name = "DD_EST_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoTrabajoGenerator")
	@SequenceGenerator(name = "DDEstadoTrabajoGenerator", sequenceName = "S_DD_EST_ESTADO_TRABAJO")
	private Long id;
	    
	@Column(name = "DD_EST_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_EST_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_EST_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name="DD_EST_ESTADO_CONTABLE")
	private boolean estadoContable;	    
	
	    
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

	public boolean getEstadoContable() {
		return estadoContable;
	}

	public void setEstadoContable(boolean estadoContable) {
		this.estadoContable = estadoContable;
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

}




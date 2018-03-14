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
 * Modelo que gestiona el diccionario del salto de tareas de un expediente comercial
 * 
 * @author Isidro Sotoca
 *
 */
@Entity
@Table(name = "DD_TDS_TAREA_DESTINO_SALTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTareaDestinoSalto implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_DEFINICION_OFERTA = "01";
	public static final String CODIGO_FIRMA_PROPIETARIO = "02";
	public static final String CODIGO_CIERRE_ECONOMICO = "03";
	public static final String CODIGO_RESOLUCION_COMITE = "04";
	public static final String CODIGO_RESPUESTA_OFERTANTE = "05";
	public static final String CODIGO_INSTRUCCIONES_RESERVA = "06";
	public static final String CODIGO_OBTENCION_CONTRATO_RESERVA = "07";
	public static final String CODIGO_RESULTADO_PBC = "08";
	public static final String CODIGO_POSICIONAMIENTO_Y_FIRMAS = "09";
	public static final String CODIGO_RATIFICACION_COMITE = "10";
	
	@Id
	@Column(name = "DD_TDS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTareaDestinoSaltoGenerator")
	@SequenceGenerator(name = "DDTareaDestinoSaltoGenerator", sequenceName = "S_DD_TDS_TAREA_DESTINO_SALTO")
	private Long id;
	    
	@Column(name = "DD_TDS_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TDS_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TDS_DESCRIPCION_LARGA")   
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

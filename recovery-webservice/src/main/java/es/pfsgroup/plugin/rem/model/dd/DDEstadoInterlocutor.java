package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * Modelo que gestiona el diccionario de EstadoInterlocutor
 *
 * 
 * @author Jesus Jativa
 *
 */
@Entity
@Table(name = "DD_EIC_ESTADO_INTERLOCUTOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoInterlocutor implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;

	public static final String CODIGO_ACTIVO = "10";
	public static final String CODIGO_INACTIVO = "20";
	public static final String CODIGO_SOLICITUD_ALTA = "30";
	public static final String CODIGO_SOLICITUD_BAJA = "40";
	public static final String CODIGO_SOLICITUD_CAMBIO_PORCENTAJE_COMPRA = "50";
	

	@Id
	@Column(name = "DD_EIC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoInterlocutor")
	@SequenceGenerator(name = "DDEstadoInterlocutor", sequenceName = "S_DD_EIC_ESTADO_INTERLOCUTOR")
	private Long id;

	@Column(name = "DD_EIC_CODIGO")
	private String codigo;

	@Column(name = "DD_EIC_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_EIC_DESCRIPCION_LARGA")
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

	public static boolean isSolicitudBaja(DDEstadoInterlocutor eic) {
		boolean is = false;
		
		if(eic != null && CODIGO_SOLICITUD_BAJA.equals(eic.getCodigo())) {
			is = true;
		}
		return is;
	}
	
	public static boolean isBaja(DDEstadoInterlocutor eic) {
		boolean is = false;
		
		if(eic != null && CODIGO_INACTIVO.equals(eic.getCodigo())) {
			is = true;
		}
		return is;
	}
}
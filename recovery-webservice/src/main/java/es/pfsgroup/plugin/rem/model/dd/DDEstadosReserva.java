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
 * Modelo que gestiona el diccionario de los tipos de estado de una reserva
 * 
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "DD_ERE_ESTADOS_RESERVA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadosReserva implements Auditable, Dictionary {
	

	public static final String CODIGO_PENDIENTE_FIRMA = "01";
	public static final String CODIGO_FIRMADA = "02";
	public static final String CODIGO_RESUELTA = "03";
	public static final String CODIGO_ANULADA = "04";
	public static final String CODIGO_PENDIENTE_DEVOLUCION = "05";
	public static final String CODIGO_RESUELTA_DEVUELTA = "06";
	public static final String CODIGO_RESUELTA_POSIBLE_REINTEGRO = "07";
	public static final String CODIGO_RESUELTA_REINTEGRADA = "08";
	/**
	 * 
	 */
	private static final long serialVersionUID = 2307957295534774606L;

	@Id
	@Column(name = "DD_ERE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadosReservaGenerator")
	@SequenceGenerator(name = "DDEstadosReservaGenerator", sequenceName = "S_DD_ERE_ESTADOS_RESERVA")
	private Long id;
	
	@Column(name = "DD_ERE_CODIGO")   
	private String codigo;
	
	@Column(name = "DD_ERE_CODIGO_C4C")   
	private String codigoC4C;
	 
	@Column(name = "DD_ERE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_ERE_DESCRIPCION_LARGA")   
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

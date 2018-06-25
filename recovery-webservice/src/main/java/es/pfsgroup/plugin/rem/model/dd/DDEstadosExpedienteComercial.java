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
 * Modelo que gestiona el diccionario de estados de un expediente comercial.
 * 
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "DD_EEC_EST_EXP_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadosExpedienteComercial implements Auditable, Dictionary {
	
	private static final long serialVersionUID = -5820108531500198730L;
	
	public final static String EN_TRAMITACION = "01";
	public final static String ANULADO = "02";
	public final static String FIRMADO = "03";
	public final static String CONTRAOFERTADO = "04";
	public final static String BLOQUEO_ADM = "05";
	public final static String RESERVADO = "06";
	public final static String POSICIONADO = "07";
	public final static String VENDIDO = "08";
	public final static String RESUELTO = "09";
	public final static String PTE_SANCION = "10";
	public final static String APROBADO = "11";
	public final static String DENEGADO = "12";
	public final static String DOBLE_FIRMA = "13";
	public final static String RPTA_OFERTANTE = "14";
	public final static String ALQUILADO = "15";
	public final static String EN_DEVOLUCION = "16";
	public final static String ANULADO_PDTE_DEVOLUCION = "17";

	@Id
	@Column(name = "DD_EEC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadosExpedienteGenerator")
	@SequenceGenerator(name = "DDEstadosExpedienteGenerator", sequenceName = "S_DD_EEC_EST_EXP_COMERCIAL")
	private Long id;
	    
	@Column(name = "DD_EEC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_EEC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_EEC_DESCRIPCION_LARGA")   
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
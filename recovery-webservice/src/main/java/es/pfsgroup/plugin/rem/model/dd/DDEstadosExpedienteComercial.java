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
	
	public static final String ALQUILER = "0";
	public static final String VENTA = "1";
	public static final String EN_TRAMITACION = "01";
	public static final String ANULADO = "02";
	public static final String FIRMADO = "03";
	public static final String CONTRAOFERTADO = "04";
	public static final String BLOQUEO_ADM = "05";
	public static final String RESERVADO = "06";
	public static final String POSICIONADO = "07";
	public static final String VENDIDO = "08";
	public static final String RESUELTO = "09";
	public static final String PTE_SANCION = "10";
	public static final String APROBADO = "11";
	public static final String DENEGADO = "12";
	public static final String DOBLE_FIRMA = "13";
	public static final String RPTA_OFERTANTE = "14";
	public static final String ALQUILADO = "15";
	public static final String EN_DEVOLUCION = "16";
	public static final String ANULADO_PDTE_DEVOLUCION = "17";
	public static final String PTE_SCORING = "18";
	public static final String PTE_SEGURO_RENTAS = "19";
	public static final String PTE_ELEVAR_SANCION = "20";
	public static final String ELEVAR_A_SANCION = "21";
	public static final String PTE_SANCION_COMITE = "23";
	public static final String PTE_PBC = "24";
	public static final String PTE_POSICIONAMIENTO = "25";
	public static final String PTE_FIRMA = "27";
	public static final String PTE_CIERRE = "28";

	public static final String ANALISIS_PM = "30";
	public static final String PTE_SANCION_CES = "31";
	public static final String DENEGADA_OFERTA_PM = "32";
	public static final String CONTRAOFERTADO_PM = "33";
	public static final String PTE_RESOLUCION_CES = "34";
	public static final String DENEGADA_OFERTANTE_PM = "35";
	public static final String APROBADO_CES_PTE_PRO_MANZANA = "36";
	public static final String DENEGADA_OFERTA_CES = "37";
	public static final String CONTRAOFERTADO_CES = "38";
	public static final String RESERVADO_PTE_PRO_MANZANA = "39";
	public static final String APROBADO_PTE_PRO_MANZANA = "40";
	public static final String DENEGADO_PRO_MANZANA = "41";
	public static final String CONTRAOFERTA_DENEGADA = "29";
	public static final String PTE_CONTRASTE_LISTAS = "42";
	public static final String PDTE_RESPUESTA_OFERTANTE_CES = "43";

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
	
	@Column(name = "DD_EEC_VENTA")   
	private Boolean estadoVenta;
	
	@Column(name = "DD_EEC_ALQUILER")   
	private Boolean estadoAlquiler;

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
	
	public Boolean getEstadoVenta() {
		return estadoVenta;
	}

	public void setEstadoVenta(Boolean estadoVenta) {
		this.estadoVenta = estadoVenta;
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

	public Boolean isEstadoAlquiler() {
		return estadoAlquiler;
	}

	public void setEstadoAlquiler(Boolean estadoAlquiler) {
		this.estadoAlquiler = estadoAlquiler;
	}

}
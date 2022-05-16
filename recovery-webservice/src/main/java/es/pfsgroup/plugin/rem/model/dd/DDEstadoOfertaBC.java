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
 * Modelo que gestiona el diccionario de estados de una oferta de BC.
 * 
 * @author IRF
 *
 */
@Entity
@Table(name = "DD_EOB_ESTADO_OFERTA_BC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoOfertaBC implements Auditable, Dictionary {
	
	public static final String CODIGO_C4C_TRAMITE_PDTE_TITULARES_SECUNDARIOS= "500";
	public static final String CODIGO_C4C_TRAMITE_PDTE_DOCUMENTACION= "510";
	public static final String CODIGO_C4C_TRAMITE_PDTE_PAGO_DEPOSITO= "520";
	public static final String CODIGO_C4C_TRAMITE_PDTE_TRAMITACION= "530";
	public static final String CODIGO_C4C_TRAMITE_CONGELADA= "540";
	public static final String CODIGO_C4C_CANCELADA= "20";
	public static final String CODIGO_C4C_SOLICITAR_DEVOLUCION_RESERVA_ARRAS= "290";
	
	public static final String CODIGO_TRAMITE_PDTE_TITULARES_SECUNDARIOS= "04";
	public static final String CODIGO_TRAMITE_PDTE_DOCUMENTACION= "05";
	public static final String CODIGO_TRAMITE_PDTE_PAGO_DEPOSITO= "06";
	public static final String CODIGO_TRAMITE_PDTE_TRAMITACION= "07";
	public static final String CODIGO_TRAMITE_CONGELADA= "08";
	public static final String CODIGO_SOLICITAR_DEVOLUCION_RESERVA_ARRAS= "09";
	public static final String CODIGO_CANCELADA= "10";

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_EOB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoOfertaBCGenerator")
	@SequenceGenerator(name = "DDEstadoOfertaBCGenerator", sequenceName = "S_DD_EOB_ESTADO_OFERTA_BC")
	private Long id;
	    
	@Column(name = "DD_EOB_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_EOB_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_EOB_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_EOB_CODIGO_C4C")   
	private String codigoC4c;
	
	@Column(name = "DD_EOB_FLAG_ALQUILER")   
	private Boolean flagAlquiler;
	
	@Column(name = "DD_EOB_FLAG_VENTA")   
	private Boolean flagVenta;

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
	
	public String getCodigoC4c() {
		return codigoC4c;
	}

	public void setCodigoC4c(String codigoC4c) {
		this.codigoC4c = codigoC4c;
	}

	public Boolean getFlagAlquiler() {
		return flagAlquiler;
	}

	public void setFlagAlquiler(Boolean flagAlquiler) {
		this.flagAlquiler = flagAlquiler;
	}

	public Boolean getFlagVenta() {
		return flagVenta;
	}

	public void setFlagVenta(Boolean flagVenta) {
		this.flagVenta = flagVenta;
	}
	
	public static boolean isEnTramitePdteTitularesSecundarios(DDEstadoOfertaBC dd) {
		boolean is = false;
		if(dd != null && CODIGO_C4C_TRAMITE_PDTE_TITULARES_SECUNDARIOS.equals(dd.getCodigo())) {
			is = true;
		}
		return is;
	}
	
	public static boolean isEnTramitePdteDocumentacion(DDEstadoOfertaBC dd) {
		boolean is = false;
		if(dd != null && CODIGO_C4C_TRAMITE_PDTE_DOCUMENTACION.equals(dd.getCodigo())) {
			is = true;
		}
		return is;
	}
	
	public static boolean isEnTramitePdtePagoDeposito(DDEstadoOfertaBC dd) {
		boolean is = false;
		if(dd != null && CODIGO_C4C_TRAMITE_PDTE_PAGO_DEPOSITO.equals(dd.getCodigo())) {
			is = true;
		}
		return is;
	}
	
	public static boolean isEnTramitePdteTramitacion(DDEstadoOfertaBC dd) {
		boolean is = false;
		if(dd != null && CODIGO_C4C_TRAMITE_PDTE_TRAMITACION.equals(dd.getCodigo())) {
			is = true;
		}
		return is;
	}
	
	public static boolean isEnTramiteCongelada(DDEstadoOfertaBC dd) {
		boolean is = false;
		if(dd != null && CODIGO_C4C_TRAMITE_CONGELADA.equals(dd.getCodigo())) {
			is = true;
		}
		return is;
	}

}
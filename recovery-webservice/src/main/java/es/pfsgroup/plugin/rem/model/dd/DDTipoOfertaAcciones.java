package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * Modelo que gestiona el diccionario de Tipos de acciones de una oferta.
 * 
 * @author Cristian Montoya
 *
 */
@Entity
@Table(name = "DD_OAC_OFERTA_ACCIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoOfertaAcciones implements Auditable, Dictionary {
		
	public static final String CODIGO_APROBACION_COMERCIAL = "001";
	public static final String CODIGO_RECHAZO_COMERCIAL = "002";
	public static final String CODIGO_COMUNICAR_CONTRAOFERTA_CLIENTE = "003";
	public static final String CODIGO_RESULTADO_SCORING_PBC = "004";
	public static final String CODIGO_ARRAS_APROBADAS = "005";
	public static final String CODIGO_ARRAS_RECHAZADAS = "006";
	public static final String CODIGO_ARRAS_PDTE_DOCUMENTACION = "007";
	public static final String CODIGO_INGRESO_FINAL_APROBADO = "008";
	public static final String CODIGO_INGRESO_FINAL_RECHAZADO = "009";
	public static final String CODIGO_INGRESO_FINAL_PDTE_DOCUMENTACION = "010";
	public static final String CODIGO_BLOQUEO_SCREENING = "011";
	public static final String CODIGO_DESBLOQUEO_SCREENING = "012";
	public static final String CODIGO_FIRMA_DE_ARRAS_APROBADAS = "013";
	public static final String CODIGO_FIRMA_DE_ARRAS_RECHAZADAS = "014";
	public static final String CODIGO_FIRMA_DE_CONTRATO_APROBADO = "015";
	public static final String CODIGO_FIRMA_DE_CONTRATO_RECHAZADO = "016";
	public static final String CODIGO_ARRAS_Y_RESERVA_NO_DEVUELTAS = "017";
	public static final String CODIGO_ARRAS_DEVUELTAS_RESERVA_NO_DEVUELTA = "018";
	public static final String CODIGO_ARRAS_NO_DEVUELTAS_RESERVA_DEVUELTA = "019";
	public static final String CODIGO_ARRAS_Y_RESERVA_DEVUELTAS = "020";
	public static final String CODIGO_RESERVA_CONTABILIZADA = "021";
	public static final String CODIGO_ARRAS_CONTABILIZADAS = "022";
	public static final String CODIGO_VENTA_CONTABILIZADA = "023";
	public static final String CODIGO_PLUSVALIA_CONTABILIZADA = "024";
	public static final String CODIGO_PENDIENTE_SCORING = "037";
	public static final String CODIGO_PDTE_ANALISIS_TECNICO = "038";
	public static final String CODIGO_PENDIENTE_NEGOCIACION = "039";
	public static final String CODIGO_PDTE_CL_ROD = "040";
	public static final String CODIGO_RECHAZO_PBC = "041";
	public static final String ACCION_DEVOLVER_RESERVA = "029";
	public static final String ACCION_INCAUTAR_RESERVA = "030";
	public static final String ACCION_RESERVA_CONTABILIZADA = "021";
	public static final String ACCION_DEVOL_RESERVA_CONT = "033";
	public static final String ACCION_INCAUTACION_RESERVA_CONT = "035";
	public static final String CODIGO_BLOQUEO_SCORING = "042";
	public static final String CODIGO_DESBLOQUEO_SCORING = "043";
	public static final String ACCION_TAREA_DATOS_PBC = "996";
	public static final String ACCION_SOLICITUD_DOC_MINIMA = "997";
	public static final String ACCION_CONFIRMACION_REP_OFERTAS = "998";
	public static final String ACCION_CONFIRMACION_REP_INTERVINIENTE = "999";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_OAC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoOfertaAccionesGenerator")
	@SequenceGenerator(name = "DDTipoOfertaAccionesGenerator", sequenceName = "S_DD_OAC_OFERTA_ACCIONES")
	private Long id;
	    
	@Column(name = "DD_OAC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_OAC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_OAC_DESCRIPCION_LARGA")   
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
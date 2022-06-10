package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;

@Entity
@Table(name = "DD_SFP_SUBFASE_PUBLICACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubfasePublicacion implements Auditable, Dictionary {
	

	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_CALIDAD_PENDIENTE = "01";
	public static final String CODIGO_PENDIENTE_ACTUACIONES_PREVIAS = "02";
	public static final String CODIGO_PENDIENTE_ANALISIS = "03";
	public static final String CODIGO_ACTUACIONES_PENDIENTES_EDIFICACION = "04";
	public static final String CODIGO_EN_ANALISIS = "05";
	public static final String CODIGO_EN_ADECUACION = "06";
	public static final String CODIGO_ACTUACIONES_GESTION_DE_ACTIVOS = "07";
	public static final String CODIGO_PENDIENTE_DE_LLAVES = "08";
	public static final String CODIGO_PENDIENTE_DE_INFORMACION = "09";
	public static final String CODIGO_PENDIENTE_DE_PRECIOS = "10";
	public static final String CODIGO_INCIDENCIAS_DE_PUBLICACION = "11";
	public static final String CODIGO_SIN_VALOR = "12";
	public static final String CODIGO_ILOCALIZABLE = "13";
	public static final String CODIGO_EXCLUIDO_PUBLICACION_ESTRATEGICA_DEL_CLIENTE = "14";
	public static final String CODIGO_REQUERIMIENTO_LEGAL_O_ADMINISTRATIVO = "15";
	public static final String CODIGO_ARRAS_RESERVADO = "16";
	public static final String CODIGO_VENTA_MAYORISTA = "17";
	public static final String CODIGO_VINCULACIONES_COMERCIALES = "18";
	public static final String CODIGO_CALIDAD_COMPROBADA = "19";
	public static final String CODIGO_SIN_INCIDENCIAS = "20";
	public static final String CODIGO_TRAMITE_ADMINISTRATIVO = "21";
	public static final String CODIGO_PENDIENTE_CEE = "22";
	public static final String CODIGO_PENDIENTE_CEDULA = "23";
	public static final String CODIGO_PENDIENTE_REPARACIONES = "24";
	public static final String CODIGO_DEVUELTO = "25";
	public static final String CODIGO_CLASIFICADO = "26";
	public static final String CODIGO_GESTION_APIS = "28";


	@Id
	@Column(name = "DD_SFP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubfasePublicacionGenerator")
	@SequenceGenerator(name = "DDSubfasePublicacionGenerator", sequenceName = "S_DD_SFP_SUBFASE_PUBLICACION")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_FSP_ID")
	private DDFasePublicacion fasePublicacion;
	
	@Column(name = "DD_SFP_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SFP_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SFP_DESCRIPCION_LARGA")   
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
	
	public DDFasePublicacion getFasePublicacion() {
		return fasePublicacion;
	}

	public void setFasePublicacion(DDFasePublicacion fasePublicacion) {
		this.fasePublicacion = fasePublicacion;
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

	public static boolean isHistoricoFasesExcPubEstrategiaCl(DDSubfasePublicacion subfasePublicacion) {
		boolean isExclPubEstrCl = false;
		
		if(subfasePublicacion != null && CODIGO_EXCLUIDO_PUBLICACION_ESTRATEGICA_DEL_CLIENTE.equals(subfasePublicacion.getCodigo())) {
			isExclPubEstrCl = true;
		}
		
		return isExclPubEstrCl;
	}
	
	public static boolean isHistoricoFasesReqLegAdm(DDSubfasePublicacion subfasePublicacion) {
		boolean isReqLegAdm = false;
		
		if(subfasePublicacion != null && CODIGO_REQUERIMIENTO_LEGAL_O_ADMINISTRATIVO.equals(subfasePublicacion.getCodigo())) {
			isReqLegAdm = true;
		}
		
		return isReqLegAdm;
	}

	
	public static boolean isHistoricoFasesSinValor(DDSubfasePublicacion subfasePublicacion) {
		boolean isSinValor = false;
		
		if(subfasePublicacion != null && CODIGO_SIN_VALOR.equals(subfasePublicacion.getCodigo())) {
			isSinValor = true;
		}
		
		return isSinValor;
	}
	
	public static boolean isHistoricoFasesGestionApi(DDSubfasePublicacion subfasePublicacion) {
		boolean isGestionApi = false;
		
		if(subfasePublicacion != null && CODIGO_GESTION_APIS.equals(subfasePublicacion.getCodigo())) {
			isGestionApi = true;
		}
		
		return isGestionApi;
	}
	
	public static boolean isHistoricoFasesPendienteInformacion(DDSubfasePublicacion subfasePublicacion) {
		boolean isGestionApi = false;
		
		if(subfasePublicacion != null && CODIGO_PENDIENTE_DE_INFORMACION.equals(subfasePublicacion.getCodigo())) {
			isGestionApi = true;
		}
		
		return isGestionApi;
	}
	
}
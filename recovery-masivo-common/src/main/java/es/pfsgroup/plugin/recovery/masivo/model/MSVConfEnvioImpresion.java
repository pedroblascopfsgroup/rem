package es.pfsgroup.plugin.recovery.masivo.model;

import java.io.Serializable;

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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;


@Entity
@Table(name = "CEI_CONF_ENVIO_IMPRESION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause="borrado = 0")public class MSVConfEnvioImpresion  implements Serializable, Auditable  {

	private static final long serialVersionUID = -3564789261685852742L;
	
	public static final String MONITORIO = "Monitorio";
	public static final String ETJ = "ETJ";

	public static final String PACK_MONITORIO = "Demanda Monitorio";
	public static final String PACK_ETJ = "Demanda ETJ";

	@Id
	@Column(name = "CEI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVConfEnvioImpresionGenerator")
	@SequenceGenerator(name = "MSVConfEnvioImpresionGenerator", sequenceName = "S_CEI_CONF_ENVIO_IMPRESION")
	private Long id;

	@Embedded
	private Auditoria auditoria;

	//Código de pack de impresión. 
	// Posibles valores: PACK_MONITORIO = "Demanda Monitorio" y PACK_ETJ = "Demanda ETJ"
	@Column(name = "CEI_PACK_IMPRESION")
	private String packImpresion;
	
	//Tipo de documento.
    @JoinColumn(name = "DD_TFA_ID")
	@ManyToOne
	private DDTipoFicheroAdjunto tipoDocumento;
    
    //Nº de orden en el bloque
	@Column(name = "CEI_NUM_ORDEN")
    private Integer numOrden;
	
    //Repetir por demandado
	@Column(name = "CEI_REPETIR_DEMANDADO")
    private Boolean repetirDemandado;
	
    //Nº de copias adicionales del documento
	@Column(name = "CEI_NUM_COPIAS_ADIC")
    private Integer numCopiasAdicionales;

    //Repetir por demandado
	@Column(name = "CEI_INCLUIR_PLAZA")
    private Boolean incluirPlaza;
	
    //Imprimir todos los adjuntos del tipo de documento que se encuentren
	@Column(name = "CEI_IMPRIMIR_TODOS")
    private Boolean imprimirTodos;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public String getPackImpresion() {
		return packImpresion;
	}

	public void setPackImpresion(String packImpresion) {
		this.packImpresion = packImpresion;
	}

	public DDTipoFicheroAdjunto getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(DDTipoFicheroAdjunto tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public Integer getNumOrden() {
		return numOrden;
	}

	public void setNumOrden(Integer numOrden) {
		this.numOrden = numOrden;
	}

	public Boolean getRepetirDemandado() {
		return repetirDemandado;
	}

	public void setRepetirDemandado(Boolean repetirDemandado) {
		this.repetirDemandado = repetirDemandado;
	}

	public Integer getNumCopiasAdicionales() {
		return numCopiasAdicionales;
	}

	public void setNumCopiasAdicionales(Integer numCopiasAdicionales) {
		this.numCopiasAdicionales = numCopiasAdicionales;
	}
	
	public Boolean getIncluirPlaza() {
		return incluirPlaza;
	}

	public void setIncluirPlaza(Boolean incluirPlaza) {
		this.incluirPlaza = incluirPlaza;
	}

	public Boolean getImprimirTodos() {
		return imprimirTodos;
	}

	public void setImprimirTodos(Boolean imprimirTodos) {
		this.imprimirTodos = imprimirTodos;
	}
	
}

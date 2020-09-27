package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGastoAsociado;




/**
 * Modelo que gestiona los adjuntos de gastos asociados
 *  
 * @author Javier Urban
 *
 */


@Entity
@Table(name = "ADG_ADJUNTO_GASTO_ASOCIADO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class AdjuntoGastoAsociado implements Serializable, Auditable{


private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "ADG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntoGastoAsociadoGenerator")
    @SequenceGenerator(name = "AdjuntoGastoAsociadoGenerator", sequenceName = "S_ADG_ADJUNTO_GASTO_ASOCIADO")
    private Long id;
	
	@OneToOne
    @JoinColumn(name = "GAA_ID")
    private GastoAsociadoAdquisicion gastoAsociadoAdquisicion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_TPG_ID")
	private DDTipoDocumentoGastoAsociado tipoDocumentoGastoAsociado;
	
	@OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ADJ_ID")
    private Adjunto adjunto;
	
	@Column(name="ADG_NOMBRE")
	private String nombreAdjuntoGastoAsociado;
		
	@Column(name="ADG_CONTENT_TYPE")
	private String tipoContenidoDocumento;
	
	@Column(name="ADG_LENGTH")
	private Long tamanyoDocumento;
		
	@Column(name = "ADG_DESCRIPCION")
	private String descripcionDocumento;
	
	@Column(name = "ADG_FECHA_DOCUMENTO")
	private Date fechaSubidaDocumento;
	
	@Column(name = "ADG_ID_DOCUMENTO_REST")
	private Long identificadorGestorDocumental;

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

	public GastoAsociadoAdquisicion getGastoAsociadoAdquisicion() {
		return gastoAsociadoAdquisicion;
	}

	public void setGastoAsociadoAdquisicion(GastoAsociadoAdquisicion gastoAsociadoAdquisicion) {
		this.gastoAsociadoAdquisicion = gastoAsociadoAdquisicion;
	}

	public DDTipoDocumentoGastoAsociado getTipoDocumentoGastoAsociado() {
		return tipoDocumentoGastoAsociado;
	}

	public void setTipoDocumentoGastoAsociado(DDTipoDocumentoGastoAsociado tipoDocumentoGastoAsociado) {
		this.tipoDocumentoGastoAsociado = tipoDocumentoGastoAsociado;
	}

	public Adjunto getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(Adjunto adjunto) {
		this.adjunto = adjunto;
	}

	public String getNombreAdjuntoGastoAsociado() {
		return nombreAdjuntoGastoAsociado;
	}

	public void setNombreAdjuntoGastoAsociado(String nombreAdjuntoGastoAsociado) {
		this.nombreAdjuntoGastoAsociado = nombreAdjuntoGastoAsociado;
	}

	public String getTipoContenidoDocumento() {
		return tipoContenidoDocumento;
	}

	public void setTipoContenidoDocumento(String tipoContenidoDocumento) {
		this.tipoContenidoDocumento = tipoContenidoDocumento;
	}

	public Long getTamanyoDocumento() {
		return tamanyoDocumento;
	}

	public void setTamanyoDocumento(Long tamanyoDocumento) {
		this.tamanyoDocumento = tamanyoDocumento;
	}

	public String getDescripcionDocumento() {
		return descripcionDocumento;
	}

	public void setDescripcionDocumento(String descripcionDocumento) {
		this.descripcionDocumento = descripcionDocumento;
	}

	public Date getFechaSubidaDocumento() {
		return fechaSubidaDocumento;
	}

	public void setFechaSubidaDocumento(Date fechaSubidaDocumento) {
		this.fechaSubidaDocumento = fechaSubidaDocumento;
	}

	public Long getIdentificadorGestorDocumental() {
		return identificadorGestorDocumental;
	}

	public void setIdentificadorGestorDocumental(Long identificadorGestorDocumental) {
		this.identificadorGestorDocumental = identificadorGestorDocumental;
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

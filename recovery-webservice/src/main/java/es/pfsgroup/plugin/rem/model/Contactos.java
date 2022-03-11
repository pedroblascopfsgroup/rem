package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDListaEstado;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoFinalizacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;
import es.pfsgroup.plugin.rem.model.dd.DDValoresProcedencia;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * Modelo que gestiona los activos.
 */
@Entity
@Table(name = "CON_CONTACTOS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Contactos implements Serializable, Auditable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CON_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ContactosGenerator")
    @SequenceGenerator(name = "ContactosGenerator", sequenceName = "S_CON_CONTACTOS")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;

	@Column(name = "CON_OPORTUNIDAD_ID")
	private String oportunidad;

	@Column(name = "CON_TIPO_DOCUMENTO")
	private String tipoDocumento;

	@Column(name = "CON_OFICINA_CXB")
	private String oficinaCxb;

	@Column(name = "CON_CUENTA_SVH")
	private String cuentaSvh;

	@Column(name = "CON_API")
	private String api;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LES_ID")
	private DDListaEstado estado;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MOF_ID")
	private DDMotivoFinalizacion motivoFinalizacion;

	@Column(name = "CON_FECHA_ESTADO")
	private Date fechaEstado;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_VPR_ID")
	private DDValoresProcedencia valorProcedencia;

	@Column(name = "CON_FECHA_APERTURA")
	private Date fechaApertura;

	@Column(name = "CON_FECHA_PREV_FIN")
	private Date fechaPrevFin;

	@Column(name = "CON_BC_ID")
	private String idHayaBC;

	@Column(name = "CON_UNIDAD_REGIS")
	private String unidadRegis;

	@Column(name = "CON_DESC_PROCESO")
	private String descProceso;
    
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

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public String getOportunidad() {
		return oportunidad;
	}

	public void setOportunidad(String oportunidad) {
		this.oportunidad = oportunidad;
	}

	public String getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public String getOficinaCxb() {
		return oficinaCxb;
	}

	public void setOficinaCxb(String oficinaCxb) {
		this.oficinaCxb = oficinaCxb;
	}

	public String getCuentaSvh() {
		return cuentaSvh;
	}

	public void setCuentaSvh(String cuentaSvh) {
		this.cuentaSvh = cuentaSvh;
	}

	public String getApi() {
		return api;
	}

	public void setApi(String api) {
		this.api = api;
	}

	public DDListaEstado getEstado() {
		return estado;
	}

	public void setEstado(DDListaEstado estado) {
		this.estado = estado;
	}

	public DDMotivoFinalizacion getMotivoFinalizacion() {
		return motivoFinalizacion;
	}

	public void setMotivoFinalizacion(DDMotivoFinalizacion motivoFinalizacion) {
		this.motivoFinalizacion = motivoFinalizacion;
	}

	public Date getFechaEstado() {
		return fechaEstado;
	}

	public void setFechaEstado(Date fechaEstado) {
		this.fechaEstado = fechaEstado;
	}

	public DDValoresProcedencia getValorProcedencia() {
		return valorProcedencia;
	}

	public void setValorProcedencia(DDValoresProcedencia valorProcedencia) {
		this.valorProcedencia = valorProcedencia;
	}

	public Date getFechaApertura() {
		return fechaApertura;
	}

	public void setFechaApertura(Date fechaApertura) {
		this.fechaApertura = fechaApertura;
	}

	public Date getFechaPrevFin() {
		return fechaPrevFin;
	}

	public void setFechaPrevFin(Date fechaPrevFin) {
		this.fechaPrevFin = fechaPrevFin;
	}

	public String getIdHayaBC() {
		return idHayaBC;
	}

	public void setIdHayaBC(String idHayaBC) {
		this.idHayaBC = idHayaBC;
	}

	public String getUnidadRegis() {
		return unidadRegis;
	}

	public void setUnidadRegis(String unidadRegis) {
		this.unidadRegis = unidadRegis;
	}

	public String getDescProceso() {
		return descProceso;
	}

	public void setDescProceso(String descProceso) {
		this.descProceso = descProceso;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
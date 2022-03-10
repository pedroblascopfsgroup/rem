package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDPromociones;
import es.pfsgroup.plugin.rem.model.dd.DDSubpartidasEdificacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;


@Entity
@Table(name = "GLD_GASTOS_LINEA_DETALLE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastoLineaDetalle implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "GLD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoLineaDetalleGenerator")
	@SequenceGenerator(name = "GastoLineaDetalleGenerator", sequenceName = "S_GLD_GASTOS_LINEA_DETALLE")
	private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
	private GastoProveedor gastoProveedor;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
	private DDSubtipoGasto subtipoGasto;
	
	@Column(name="GLD_PRINCIPAL_SUJETO")
    private Double principalSujeto;
	
	@Column(name="GLD_PRINCIPAL_NO_SUJETO")
    private Double principalNoSujeto;

	@Column(name="GLD_RECARGO")
    private Double recargo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TRG_ID")
	private DDTipoRecargoGasto tipoRecargoGasto;
	
	@Column(name="GLD_INTERES_DEMORA")
	private Double interesDemora;
	
	@Column(name="GLD_COSTAS")
	private Double costas;
	
	@Column(name="GLD_OTROS_INCREMENTOS")
	private Double otrosIncrementos;
	
	@Column(name="GLD_PROV_SUPLIDOS")
	private Double provSuplidos;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIT_ID")
	private DDTiposImpuesto tipoImpuesto;
	
	@Column(name="GLD_IMP_IND_EXENTO")
	private Boolean esImporteIndirectoExento;
	
	@Column(name="GLD_IMP_IND_RENUNCIA_EXENCION")
	private Boolean esImporteIndirectoRenunciaExento;
	
	@Column(name="GLD_IMP_IND_TIPO_IMPOSITIVO")
	private Double importeIndirectoTipoImpositivo;
	
	@Column(name="GLD_IMP_IND_CUOTA")
	private Double importeIndirectoCuota;
	
	@Column(name="GLD_IMPORTE_TOTAL")
	private Double importeTotal;
	
	@Column(name="GLD_CCC_BASE")
	private String cccBase;
	
	@Column(name="GLD_CPP_BASE")
	private String cppBase;
	
	@Column(name="GLD_CCC_ESP")
	private String cccEsp;
	
	@Column(name="GLD_CPP_ESP")
	private String cppEsp;
	
	@Column(name="GLD_CCC_TASAS")
	private String cccTasas;
	
	@Column(name="GLD_CPP_TASAS")
	private String cppTasas;
	
	@Column(name="GLD_CCC_RECARGO")
	private String cccRecargo;
	
	@Column(name="GLD_CPP_RECARGO")
	private String cppRecargo;
	
	@Column(name="GLD_CCC_INTERESES")
	private String cccIntereses;
	
	@Column(name="GLD_CPP_INTERESES")
	private String cppIntereses;
	
	@Column(name="GLD_SUBCUENTA_BASE")
	private String subcuentaBase;
	
	@Column(name="GLD_APARTADO_BASE")
	private String apartadoBase;
	
	@Column(name="GLD_CAPITULO_BASE")
	private String capituloBase;
	
	@Column(name="GLD_SUBCUENTA_RECARGO")
	private String subcuentaRecargo;
	
	@Column(name="GLD_APARTADO_RECARGO")
	private String apartadoRecargo;
	
	@Column(name="GLD_CAPITULO_RECARGO")
	private String capituloRecargo;
	
	@Column(name="GLD_SUBCUENTA_TASA")
	private String subcuentaTasa;
	
	@Column(name="GLD_APARTADO_TASA")
	private String apartadoTasa;
	
	@Column(name="GLD_CAPITULO_TASA")
	private String capituloTasa;
	
	@Column(name="GLD_SUBCUENTA_INTERESES")
	private String subcuentaIntereses;
	
	@Column(name="GLD_APARTADO_INTERESES")
	private String apartadoIntereses;
	
	@Column(name="GLD_CAPITULO_INTERESES")
	private String capituloIntereses;
	
    @OneToMany(mappedBy = "gastoLineaDetalle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "GLD_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<GastoLineaDetalleEntidad> gastoLineaEntidadList;    
    
    @OneToMany(mappedBy = "gastoLineaDetalle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "GLD_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<GastoLineaDetalleTrabajo> gastoLineaTrabajoList;    
    
	@Column(name="GLD_MATRICULA_REF")
    private String matriculaRefacturado;
	
	@Column(name="GLD_LINEA_SIN_ACTIVOS")
    private Boolean lineaSinActivos;
	
	@Column(name="GRUPO")
    private String grupo;
	
	@Column(name="TIPO")
    private String tipo;
	
	@Column(name="SUBTIPO")
    private String subtipo;
	
	@Column(name="PRIM_TOMA_POSESION")
    private Boolean primeraPosesion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SED_ID")
	private DDSubpartidasEdificacion subpartidasEdificacion;
	
	@Column(name = "ELEMENTO_PEP")
	private String elementoPep;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRO_ID")
	private DDPromociones promocion;
	
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

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public Double getPrincipalSujeto() {
		return principalSujeto;
	}

	public void setPrincipalSujeto(Double principalSujeto) {
		this.principalSujeto = principalSujeto;
	}

	public Double getPrincipalNoSujeto() {
		return principalNoSujeto;
	}

	public void setPrincipalNoSujeto(Double principalNoSujeto) {
		this.principalNoSujeto = principalNoSujeto;
	}

	public Double getRecargo() {
		return recargo;
	}

	public void setRecargo(Double recargo) {
		this.recargo = recargo;
	}

	public DDTipoRecargoGasto getTipoRecargoGasto() {
		return tipoRecargoGasto;
	}

	public void setTipoRecargoGasto(DDTipoRecargoGasto tipoRecargoGasto) {
		this.tipoRecargoGasto = tipoRecargoGasto;
	}

	public Double getInteresDemora() {
		return interesDemora;
	}

	public void setInteresDemora(Double interesDemora) {
		this.interesDemora = interesDemora;
	}

	public Double getCostas() {
		return costas;
	}

	public void setCostas(Double costas) {
		this.costas = costas;
	}

	public Double getOtrosIncrementos() {
		return otrosIncrementos;
	}

	public void setOtrosIncrementos(Double otrosIncrementos) {
		this.otrosIncrementos = otrosIncrementos;
	}

	public Double getProvSuplidos() {
		return provSuplidos;
	}

	public void setProvSuplidos(Double provSuplidos) {
		this.provSuplidos = provSuplidos;
	}

	public DDTiposImpuesto getTipoImpuesto() {
		return tipoImpuesto;
	}

	public void setTipoImpuesto(DDTiposImpuesto tipoImpuesto) {
		this.tipoImpuesto = tipoImpuesto;
	}

	public Boolean getEsImporteIndirectoExento() {
		return esImporteIndirectoExento;
	}

	public void setEsImporteIndirectoExento(Boolean esImporteIndirectoExento) {
		this.esImporteIndirectoExento = esImporteIndirectoExento;
	}

	public Boolean getEsImporteIndirectoRenunciaExento() {
		return esImporteIndirectoRenunciaExento;
	}

	public void setEsImporteIndirectoRenunciaExento(Boolean esImporteIndirectoRenunciaExento) {
		this.esImporteIndirectoRenunciaExento = esImporteIndirectoRenunciaExento;
	}

	public Double getImporteIndirectoTipoImpositivo() {
		return importeIndirectoTipoImpositivo;
	}

	public void setImporteIndirectoTipoImpositivo(Double importeIndirectoTipoImpositivo) {
		this.importeIndirectoTipoImpositivo = importeIndirectoTipoImpositivo;
	}

	public Double getImporteIndirectoCuota() {
		return importeIndirectoCuota;
	}

	public void setImporteIndirectoCuota(Double importeIndirectoCuota) {
		this.importeIndirectoCuota = importeIndirectoCuota;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public String getCccBase() {
		return cccBase;
	}

	public void setCccBase(String cccBase) {
		this.cccBase = cccBase;
	}

	public String getCppBase() {
		return cppBase;
	}

	public void setCppBase(String cppBase) {
		this.cppBase = cppBase;
	}

	public String getCccEsp() {
		return cccEsp;
	}

	public void setCccEsp(String cccEsp) {
		this.cccEsp = cccEsp;
	}

	public String getCppEsp() {
		return cppEsp;
	}

	public void setCppEsp(String cppEsp) {
		this.cppEsp = cppEsp;
	}

	public String getCccTasas() {
		return cccTasas;
	}

	public void setCccTasas(String cccTasas) {
		this.cccTasas = cccTasas;
	}

	public String getCppTasas() {
		return cppTasas;
	}

	public void setCppTasas(String cppTasas) {
		this.cppTasas = cppTasas;
	}

	public String getCccRecargo() {
		return cccRecargo;
	}

	public void setCccRecargo(String cccRecargo) {
		this.cccRecargo = cccRecargo;
	}

	public String getCppRecargo() {
		return cppRecargo;
	}

	public void setCppRecargo(String cppRecargo) {
		this.cppRecargo = cppRecargo;
	}

	public String getCccIntereses() {
		return cccIntereses;
	}

	public void setCccIntereses(String cccIntereses) {
		this.cccIntereses = cccIntereses;
	}

	public String getCppIntereses() {
		return cppIntereses;
	}

	public void setCppIntereses(String cppIntereses) {
		this.cppIntereses = cppIntereses;
	}
	

	public String getSubcuentaBase() {
		return subcuentaBase;
	}

	public void setSubcuentaBase(String subcuentaBase) {
		this.subcuentaBase = subcuentaBase;
	}

	public String getApartadoBase() {
		return apartadoBase;
	}

	public void setApartadoBase(String apartadoBase) {
		this.apartadoBase = apartadoBase;
	}

	public String getCapituloBase() {
		return capituloBase;
	}

	public void setCapituloBase(String capituloBase) {
		this.capituloBase = capituloBase;
	}

	public String getSubcuentaRecargo() {
		return subcuentaRecargo;
	}

	public void setSubcuentaRecargo(String subcuentaRecargo) {
		this.subcuentaRecargo = subcuentaRecargo;
	}

	public String getApartadoRecargo() {
		return apartadoRecargo;
	}

	public void setApartadoRecargo(String apartadoRecargo) {
		this.apartadoRecargo = apartadoRecargo;
	}

	public String getCapituloRecargo() {
		return capituloRecargo;
	}

	public void setCapituloRecargo(String capituloRecargo) {
		this.capituloRecargo = capituloRecargo;
	}

	public String getSubcuentaTasa() {
		return subcuentaTasa;
	}

	public void setSubcuentaTasa(String subcuentaTasa) {
		this.subcuentaTasa = subcuentaTasa;
	}

	public String getApartadoTasa() {
		return apartadoTasa;
	}

	public void setApartadoTasa(String apartadoTasa) {
		this.apartadoTasa = apartadoTasa;
	}

	public String getCapituloTasa() {
		return capituloTasa;
	}

	public void setCapituloTasa(String capituloTasa) {
		this.capituloTasa = capituloTasa;
	}

	public String getSubcuentaIntereses() {
		return subcuentaIntereses;
	}

	public void setSubcuentaIntereses(String subcuentaIntereses) {
		this.subcuentaIntereses = subcuentaIntereses;
	}

	public String getApartadoIntereses() {
		return apartadoIntereses;
	}

	public void setApartadoIntereses(String apartadoIntereses) {
		this.apartadoIntereses = apartadoIntereses;
	}

	public String getCapituloIntereses() {
		return capituloIntereses;
	}

	public void setCapituloIntereses(String capituloIntereses) {
		this.capituloIntereses = capituloIntereses;
	}

	public List<GastoLineaDetalleEntidad> getGastoLineaEntidadList() {
		return gastoLineaEntidadList;
	}

	public void setGastoLineaEntidadList(List<GastoLineaDetalleEntidad> gastoLineaEntidadList) {
		this.gastoLineaEntidadList = gastoLineaEntidadList;
	}

	public List<GastoLineaDetalleTrabajo> getGastoLineaTrabajoList() {
		return gastoLineaTrabajoList;
	}

	public void setGastoLineaTrabajoList(List<GastoLineaDetalleTrabajo> gastoLineaTrabajoList) {
		this.gastoLineaTrabajoList = gastoLineaTrabajoList;
	}
	
	public String getMatriculaRefacturado() {
		return matriculaRefacturado;
	}

	public void setMatriculaRefacturado(String matriculaRefacturado) {
		this.matriculaRefacturado = matriculaRefacturado;
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

	public Boolean getLineaSinActivos() {
		return lineaSinActivos;
	}

	public void setLineaSinActivos(Boolean lineaSinActivos) {
		this.lineaSinActivos = lineaSinActivos;
	}
	
	public boolean esAutorizadoSinActivos() {
		if(lineaSinActivos != null)
			return this.lineaSinActivos;
		return false;
	}

	public String getGrupo() {
		return grupo;
	}

	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getSubtipo() {
		return subtipo;
	}

	public void setSubtipo(String subtipo) {
		this.subtipo = subtipo;
	}

	public String getElementoPep() {
		return elementoPep;
	}

	public void setElementoPep(String elementoPep) {
		this.elementoPep = elementoPep;
	}

	public Boolean getPrimeraPosesion() {
		return primeraPosesion;
	}

	public void setPrimeraPosesion(Boolean primeraPosesion) {
		this.primeraPosesion = primeraPosesion;
	}

	public DDSubpartidasEdificacion getSubpartidasEdificacion() {
		return subpartidasEdificacion;
	}

	public void setSubpartidasEdificacion(DDSubpartidasEdificacion subpartidasEdificacion) {
		this.subpartidasEdificacion = subpartidasEdificacion;
	}

	public DDPromociones getPromocion() {
		return promocion;
	}

	public void setPromocion(DDPromociones promocion) {
		this.promocion = promocion;
	}
	
}

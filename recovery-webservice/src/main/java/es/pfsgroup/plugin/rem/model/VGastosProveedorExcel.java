package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import es.pfsgroup.commons.utils.Checks;


@Entity
@Table(name = "VI_BUSQUEDA_GASTOS_PROVEEDOR_E", schema = "${entity.schema}")
public class VGastosProveedorExcel implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="ID_VISTA")
	private String idVista;
	
	@Column(name= "GPV_ID")
	private String id;
	
	@Column(name = "GPV_REF_EMISOR")
	private String numFactura;
	
	@Column(name = "DD_TGA_DESCRIPCION")
	private String tipoDescripcion;
	
	@Column(name = "DD_TGA_CODIGO")
	private String tipoCodigo;
	
	@Column(name = "DD_STG_DESCRIPCION")
	private String subtipoDescripcion;
	
	@Column(name = "DD_STG_CODIGO")
	private String subtipoCodigo;
	
	@Column(name = "GPV_CONCEPTO")
	private String concepto;
	
	@Column(name = "GPV_FECHA_EMISION")
	private Date fechaEmision;
	
	@Column(name = "DD_TPE_DESCRIPCION")
	private String periodicidadDescripcion;
	
	@Column(name = "DD_TPE_CODIGO")
	private String periodicidadCodigo;
	
	@Column(name = "PVE_COD_REM")
	private String codigoProveedorRem;
	
	@Column(name = "GDE_IMPORTE_TOTAL")
	private Double importeTotal;
	
	@Column(name = "GDE_FECHA_PAGO")
	private Date fechaPago;
	
	@Column(name = "GDE_FECHA_TOPE_PAGO")
	private Date fechaTopePago;
	
	@Column(name = "GPV_NUM_GASTO_HAYA")
	private Long numGastoHaya;
	
	@Column(name="PRG_ID")
	private Long idProvision;
	
	@Column(name = "DD_EGA_CODIGO")
	private String estadoGastoCodigo;
	
	@Column(name = "DD_EGA_DESCRIPCION")
	private String estadoGastoDescripcion;
	
	@Column(name = "GPV_NUM_GASTO_GESTORIA")
	private Long numGastoGestoria;
	
	@Column(name = "GPV_CUBRE_SEGURO")
	private Boolean cubreSeguro;
		
	@Column(name = "PVE_DOCIDENTIF")
	private String nifProveedor;
	
	@Column(name = "PVE_NOMBRE")
	private String nombreProveedor;
	
	@Column(name="DD_CRA_CODIGO")
	private String entidadPropietariaCodigo;
	
	@Column(name="DD_CRA_DESCRIPCION")
	private String entidadPropietariaDescripcion;
	
	@Column(name="DD_SCR_CODIGO")
	private String subentidadPropietariaCodigo;
	
	@Column(name="DD_SCR_DESCRIPCION")
	private String subentidadPropietariaDescripcion;

	@Column(name="PVE_ID_GESTORIA")
	private String idGestoria;
	
	@Column(name="PVE_NOMBRE_GESTORIA")
	private String nombreGestoria;
	
	@Column(name="PRO_NOMBRE")
	private String nombrePropietario;
	
	@Column(name="PRO_DOCIDENTIF")
	private String docIdentifPropietario;
	
	@Column(name="SUJETO_IMPUESTO_INDIRECTO")
	private Boolean sujetoImpuestoIndirecto;
	
	@Column(name = "FECHA_AUTORIZACION")
	private Date fechaAutorizacion;
	
	@Column(name="GGE_MOTIVO_RECHAZO_PROP")
	private String motivoRechazoProp;
	
	@Column(name="PTDA_PRESUPUESTARIA")
	private String ptdaPresupuestaria;
		
	@Column(name="CONCEPTO_CONTABLE")
	private String conceptoContable;
	
	@Column(name="PROVISION_FONDOS")
	private String provisionFondos;
	
	@Column(name = "ID_LINEA")
	private Long idLinea;
	
	@Column(name="CC_TASAS")
	private String cuentaContableTasas;
	
	@Column(name="PP_TASAS")
	private String ptdaPresupuestariaTasas;
	
	@Column(name="CC_RECARGO")
	private String cuentaContableRecargo;
	
	@Column(name="PP_RECARGO")
	private String ptdaPresupuestariaRecargo;
	
	@Column(name="CC_INTERESES")
	private String cuentaContableIntereses;
	
	@Column(name="PP_INTERESES")
	private String ptdaPresupuestariaIntereses;
	
	@Column(name="SC_BASE")
	private String subcuentaContableBase;
	
	@Column(name="APDO_BASE")
	private String apartadoBase;
	
	@Column(name="CAP_BASE")
	private String capituloBase;
	
	@Column(name="SC_RECARGO")
	private String subcuentaContableRecargo;
	
	@Column(name="APDO_RECARGO")
	private String apartadoRecargo;
	
	@Column(name="CAP_RECARGO")
	private String capituloRecargo;
	
	@Column(name="SC_TASA")
	private String subcuentaContableTasa;
	
	@Column(name="APDO_TASA")
	private String apartadoTasa;
	
	@Column(name="CAP_TASA")
	private String capituloTasa;
	
	@Column(name="SC_INTERESES")
	private String subcuentaContableIntereses;
	
	@Column(name="APDO_INTERESES")
	private String apartadoIntereses;
	
	@Column(name="CAP_INTERESES")
	private String capituloIntereses;
	
	@Column(name = "ELEMENTO")
	private String elemento;
	
	@Column(name = "IMP_PRINCIPAL_SUJETO")
	private Double impPrincipalSujeto;
	
	@Column(name = "IMP_PRINCIPAL_NO_SUJETO")
	private Double impPrincipalNoSujeto;
	
	@Column(name = "IMP_RECARGO")
	private Double impRecargo;
	
	@Column(name = "IMP_INTERES_DEMORA")
	private Double impDemora;
	
	@Column(name = "IMP_COSTES_TASAS")
	private Double impTasas;
	
	@Column(name="DD_TPR_ID")
	private String idTipoProv;

	@Column(name="DD_EAH_ID")
	private String idEstAutHaya;
	
	@Column(name="DD_EAP_ID")
	private String idEstAutProp;
	
	@Column(name = "FECHA_CREACION")
	private Date fechaCrear;

	@Column(name = "PARTICIPACION_GASTO")
	private Double participacionGasto;

	@Column(name = "GIC_FECHA_DEVENGO_ESPECIAL")
	private Date fechaDevengoEspecial;

	@Column(name = "GDE_IRPF_TIPO_IMPOSITIVO")
	private Double irpfTipoImpositivo;

	@Column(name = "GDE_IRPF_CUOTA")
	private Double irpfCuota;
	
	@Column(name = "ID_ACTIVO_CAIXA")
	private Long idActivoCaixa;
	
	
	@Transient
	private boolean esGastoAgrupado; 
	
	@Transient
	private Double importeTotalAgrupacion;
	

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNumFactura() {
		return numFactura;
	}

	public void setNumFactura(String numFactura) {
		this.numFactura = numFactura;
	}

	public String getConcepto() {
		return concepto;
	}

	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}

	public String getNifProveedor() {
		return nifProveedor;
	}

	public void setNifProveedor(String nifProveedor) {
		this.nifProveedor = nifProveedor;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public String getCodigoProveedorRem() {
		return codigoProveedorRem;
	}

	public void setCodigoProveedorRem(String codigoProveedorRem) {
		this.codigoProveedorRem = codigoProveedorRem;
	}

	public Date getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}

	public Date getFechaTopePago() {
		return fechaTopePago;
	}

	public void setFechaTopePago(Date fechaTopePago) {
		this.fechaTopePago = fechaTopePago;
	}

	public Long getNumGastoHaya() {
		return numGastoHaya;
	}

	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}

	public Long getIdProvision() {
		return idProvision;
	}

	public void setIdProvision(Long idProvision) {
		this.idProvision = idProvision;
	}

	public String getTipoDescripcion() {
		return tipoDescripcion;
	}

	public void setTipoDescripcion(String tipoDescripcion) {
		this.tipoDescripcion = tipoDescripcion;
	}

	public String getTipoCodigo() {
		return tipoCodigo;
	}

	public void setTipoCodigo(String tipoCodigo) {
		this.tipoCodigo = tipoCodigo;
	}

	public String getSubtipoDescripcion() {
		return subtipoDescripcion;
	}

	public void setSubtipoDescripcion(String subtipoDescripcion) {
		this.subtipoDescripcion = subtipoDescripcion;
	}

	public String getSubtipoCodigo() {
		return subtipoCodigo;
	}

	public void setSubtipoCodigo(String subtipoCodigo) {
		this.subtipoCodigo = subtipoCodigo;
	}

	public String getPeriodicidadDescripcion() {
		return periodicidadDescripcion;
	}

	public void setPeriodicidadDescripcion(String periodicidadDescripcion) {
		this.periodicidadDescripcion = periodicidadDescripcion;
	}

	public String getPeriodicidadCodigo() {
		return periodicidadCodigo;
	}

	public void setPeriodicidadCodigo(String periodicidadCodigo) {
		this.periodicidadCodigo = periodicidadCodigo;
	}

	public String getEstadoGastoCodigo() {
		return estadoGastoCodigo;
	}

	public void setEstadoGastoCodigo(String estadoGastoCodigo) {
		this.estadoGastoCodigo = estadoGastoCodigo;
	}

	public String getEstadoGastoDescripcion() {
		return estadoGastoDescripcion;
	}

	public void setEstadoGastoDescripcion(String estadoGastoDescripcion) {
		this.estadoGastoDescripcion = estadoGastoDescripcion;
	}

	public Long getNumGastoGestoria() {
		return numGastoGestoria;
	}

	public void setNumGastoGestoria(Long numGastoGestoria) {
		this.numGastoGestoria = numGastoGestoria;
	}

	public Boolean getCubreSeguro() {
		return cubreSeguro;
	}

	public void setCubreSeguro(Boolean cubreSeguro) {
		this.cubreSeguro = cubreSeguro;
	}

	public String getNombreProveedor() {
		return nombreProveedor;
	}

	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}

	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}

	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}

	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}

	public void setEntidadPropietariaDescripcion(
			String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}

	public String getSubentidadPropietariaCodigo() {
		return subentidadPropietariaCodigo;
	}

	public void setSubentidadPropietariaCodigo(String subentidadPropietariaCodigo) {
		this.subentidadPropietariaCodigo = subentidadPropietariaCodigo;
	}

	public String getSubentidadPropietariaDescripcion() {
		return subentidadPropietariaDescripcion;
	}

	public void setSubentidadPropietariaDescripcion(String subentidadPropietariaDescripcion) {
		this.subentidadPropietariaDescripcion = subentidadPropietariaDescripcion;
	}

	public String getIdGestoria() {
		return idGestoria;
	}

	public void setIdGestoria(String idGestoria) {
		this.idGestoria = idGestoria;
	}

	public String getNombrePropietario() {
		return nombrePropietario;
	}

	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}

	public String getDocIdentifPropietario() {
		return docIdentifPropietario;
	}

	public void setDocIdentifPropietario(String docIdentifPropietario) {
		this.docIdentifPropietario = docIdentifPropietario;
	}

	public boolean getEsGastoAgrupado() {
		return !Checks.esNulo(this.idProvision);
	}

	public void setEsGastoAgrupado(boolean esGastoAgrupado) {
		this.esGastoAgrupado = esGastoAgrupado;
	}

	public Double getImporteTotalAgrupacion() {
		return importeTotalAgrupacion;
	}

	public void setImporteTotalAgrupacion(Double importeTotalAgrupacion) {
		this.importeTotalAgrupacion = importeTotalAgrupacion;
	}

	public String getNombreGestoria() {
		return nombreGestoria;
	}

	public void setNombreGestoria(String nombreGestoria) {
		this.nombreGestoria = nombreGestoria;
	}

	public Boolean getSujetoImpuestoIndirecto() {
		return sujetoImpuestoIndirecto;
	}

	public void setSujetoImpuestoIndirecto(Boolean sujetoImpuestoIndirecto) {
		this.sujetoImpuestoIndirecto = sujetoImpuestoIndirecto;
	}

	public Date getFechaAutorizacion() {
		return fechaAutorizacion;
	}

	public void setFechaAutorizacion(Date fechaAutorizacion) {
		this.fechaAutorizacion = fechaAutorizacion;
	}
	
	public String getIdActivo() {
		return idVista;
	}
	
	public void setIdActivo(String idVista) {
		this.idVista = idVista;
	}

	public String getMotivoRechazoProp() {
		return motivoRechazoProp;
	}

	public void setMotivoRechazoProp(String motivoRechazoProp) {
		this.motivoRechazoProp = motivoRechazoProp;
	}

	public String getPtdaPresupuestaria() {
		return ptdaPresupuestaria;
	}

	public void setPtdaPresupuestaria(String ptdaPresupuestaria) {
		this.ptdaPresupuestaria = ptdaPresupuestaria;
	}

	public String getConceptoContable() {
		return conceptoContable;
	}

	public void setConceptoContable(String conceptoContable) {
		this.conceptoContable = conceptoContable;
	}

	public String getProvisionFondos() {
		return provisionFondos;
	}

	public void setProvisionFondos(String provisionFondos) {
		this.provisionFondos = provisionFondos;
	}

	public String getIdVista() {
		return idVista;
	}

	public void setIdVista(String idVista) {
		this.idVista = idVista;
	}

	public Long getIdLinea() {
		return idLinea;
	}

	public void setIdLinea(Long idLinea) {
		this.idLinea = idLinea;
	}

	public String getCuentaContableTasas() {
		return cuentaContableTasas;
	}

	public void setCuentaContableTasas(String cuentaContableTasas) {
		this.cuentaContableTasas = cuentaContableTasas;
	}

	public String getPtdaPresupuestariaTasas() {
		return ptdaPresupuestariaTasas;
	}

	public void setPtdaPresupuestariaTasas(String ptdaPresupuestariaTasas) {
		this.ptdaPresupuestariaTasas = ptdaPresupuestariaTasas;
	}

	public String getCuentaContableRecargo() {
		return cuentaContableRecargo;
	}

	public void setCuentaContableRecargo(String cuentaContableRecargo) {
		this.cuentaContableRecargo = cuentaContableRecargo;
	}

	public String getPtdaPresupuestariaRecargo() {
		return ptdaPresupuestariaRecargo;
	}

	public void setPtdaPresupuestariaRecargo(String ptdaPresupuestariaRecargo) {
		this.ptdaPresupuestariaRecargo = ptdaPresupuestariaRecargo;
	}

	public String getCuentaContableIntereses() {
		return cuentaContableIntereses;
	}

	public void setCuentaContableIntereses(String cuentaContableIntereses) {
		this.cuentaContableIntereses = cuentaContableIntereses;
	}

	public String getPtdaPresupuestariaIntereses() {
		return ptdaPresupuestariaIntereses;
	}

	public void setPtdaPresupuestariaIntereses(String ptdaPresupuestariaIntereses) {
		this.ptdaPresupuestariaIntereses = ptdaPresupuestariaIntereses;
	}

	public String getSubcuentaContableBase() {
		return subcuentaContableBase;
	}

	public void setSubcuentaContableBase(String subcuentaContableBase) {
		this.subcuentaContableBase = subcuentaContableBase;
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

	public String getSubcuentaContableRecargo() {
		return subcuentaContableRecargo;
	}

	public void setSubcuentaContableRecargo(String subcuentaContableRecargo) {
		this.subcuentaContableRecargo = subcuentaContableRecargo;
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

	public String getSubcuentaContableTasa() {
		return subcuentaContableTasa;
	}

	public void setSubcuentaContableTasa(String subcuentaContableTasa) {
		this.subcuentaContableTasa = subcuentaContableTasa;
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

	public String getSubcuentaContableIntereses() {
		return subcuentaContableIntereses;
	}

	public void setSubcuentaContableIntereses(String subcuentaContableIntereses) {
		this.subcuentaContableIntereses = subcuentaContableIntereses;
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

	public String getElemento() {
		return elemento;
	}

	public void setElemento(String elemento) {
		this.elemento = elemento;
	}

	public Double getImpPrincipalSujeto() {
		return impPrincipalSujeto;
	}

	public void setImpPrincipalSujeto(Double impPrincipalSujeto) {
		this.impPrincipalSujeto = impPrincipalSujeto;
	}

	public Double getImpPrincipalNoSujeto() {
		return impPrincipalNoSujeto;
	}

	public void setImpPrincipalNoSujeto(Double impPrincipalNoSujeto) {
		this.impPrincipalNoSujeto = impPrincipalNoSujeto;
	}

	public Double getImpRecargo() {
		return impRecargo;
	}

	public void setImpRecargo(Double impRecargo) {
		this.impRecargo = impRecargo;
	}

	public Double getImpDemora() {
		return impDemora;
	}

	public void setImpDemora(Double impDemora) {
		this.impDemora = impDemora;
	}

	public Double getImpTasas() {
		return impTasas;
	}

	public void setImpTasas(Double impTasas) {
		this.impTasas = impTasas;
	}

	public String getIdTipoProv() {
		return idTipoProv;
	}

	public void setIdTipoProv(String idTipoProv) {
		this.idTipoProv = idTipoProv;
	}

	public String getIdEstAutHaya() {
		return idEstAutHaya;
	}

	public void setIdEstAutHaya(String idEstAutHaya) {
		this.idEstAutHaya = idEstAutHaya;
	}

	public String getIdEstAutProp() {
		return idEstAutProp;
	}

	public void setIdEstAutProp(String idEstAutProp) {
		this.idEstAutProp = idEstAutProp;
	}

	public Date getFechaCrear() {
		return fechaCrear;
	}

	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}

	public Double getParticipacionGasto() {
		return participacionGasto;
	}

	public void setParticipacionGasto(Double participacionGasto) {
		this.participacionGasto = participacionGasto;
	}

	public Date getFechaDevengoEspecial() {
		return fechaDevengoEspecial;
	}

	public void setFechaDevengoEspecial(Date fechaDevengoEspecial) {
		this.fechaDevengoEspecial = fechaDevengoEspecial;
	}

	public Double getIrpfTipoImpositivo() {
		return irpfTipoImpositivo;
	}

	public void setIrpfTipoImpositivo(Double irpfTipoImpositivo) {
		this.irpfTipoImpositivo = irpfTipoImpositivo;
	}

	public Double getIrpfCuota() {
		return irpfCuota;
	}

	public void setIrpfCuota(Double irpfCuota) {
		this.irpfCuota = irpfCuota;
	}

	public Long getIdActivoCaixa() {
		return idActivoCaixa;
	}

	public void setIdActivoCaixa(Long idActivoCaixa) {
		this.idActivoCaixa = idActivoCaixa;
	}

	
}
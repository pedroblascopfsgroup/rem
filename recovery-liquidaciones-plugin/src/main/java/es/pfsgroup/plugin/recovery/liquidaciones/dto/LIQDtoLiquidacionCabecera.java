package es.pfsgroup.plugin.recovery.liquidaciones.dto;

import java.math.BigDecimal;
import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la b�squeda de clientes.
 */
public class LIQDtoLiquidacionCabecera extends WebDto {

    private static final long serialVersionUID = 1L;
    
    private Date fechaLiquidacion;
    private String acuerdo = null;
    private String autos;
    private String nombre;
    private String dni;
    private BigDecimal totalDeuda = null;
    
    private String usuarioLogado;
    private String numCuenta;
    private BigDecimal capital;
    private Date fechaVencimiento;
    private BigDecimal interes;
    private String tipoIntDemora;
    private BigDecimal principalCertif;
    private BigDecimal intCertif;
    private BigDecimal demCertif;
    private String tipoProc;
    private String juzgado;
    private String abogado;
    private String procurador;
    
    
	public Date getFechaLiquidacion() {
		return fechaLiquidacion;
	}
	public void setFechaLiquidacion(Date fechaLiquidacion) {
		this.fechaLiquidacion = fechaLiquidacion;
	}
	public String getAcuerdo() {
		return acuerdo;
	}
	public void setAcuerdo(String acuerdo) {
		this.acuerdo = acuerdo;
	}
	public String getAutos() {
		return autos;
	}
	public void setAutos(String autos) {
		this.autos = autos;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDni() {
		return dni;
	}
	public void setDni(String dni) {
		this.dni = dni;
	}
	public void setTotalDeuda(BigDecimal totalDeuda) {
		this.totalDeuda = totalDeuda;
	}
	public BigDecimal getTotalDeuda() {
		return totalDeuda;
	}
	public String getUsuarioLogado() {
		return usuarioLogado;
	}
	public void setUsuarioLogado(String usuarioLogado) {
		this.usuarioLogado = usuarioLogado;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}
	public BigDecimal getCapital() {
		return capital;
	}
	public void setCapital(BigDecimal capital) {
		this.capital = capital;
	}
	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public BigDecimal getInteres() {
		return interes;
	}
	public void setInteres(BigDecimal interes) {
		this.interes = interes;
	}
	public String getTipoIntDemora() {
		return tipoIntDemora;
	}
	public void setTipoIntDemora(String tipoIntDemora) {
		this.tipoIntDemora = tipoIntDemora;
	}
	public BigDecimal getPrincipalCertif() {
		return principalCertif;
	}
	public void setPrincipalCertif(BigDecimal principalCertif) {
		this.principalCertif = principalCertif;
	}
	public BigDecimal getIntCertif() {
		return intCertif;
	}
	public void setIntCertif(BigDecimal intCertif) {
		this.intCertif = intCertif;
	}
	public BigDecimal getDemCertif() {
		return demCertif;
	}
	public void setDemCertif(BigDecimal demCertif) {
		this.demCertif = demCertif;
	}
	public String getTipoProc() {
		return tipoProc;
	}
	public void setTipoProc(String tipoProc) {
		this.tipoProc = tipoProc;
	}
	public String getJuzgado() {
		return juzgado;
	}
	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}
	public String getAbogado() {
		return abogado;
	}
	public void setAbogado(String abogado) {
		this.abogado = abogado;
	}
	public String getProcurador() {
		return procurador;
	}
	public void setProcurador(String procurador) {
		this.procurador = procurador;
	}    
}

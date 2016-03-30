package es.pfsgroup.plugin.liquidaciones.avanzado.dto;

import java.math.BigDecimal;
import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class LIQDtoLiquidacionCabecera extends WebDto {

    private static final long serialVersionUID = 1L;
    
    private Date fechaCalculo;
    
    private String numCuenta;
    private String nombre;
    private String dni;
    
    private BigDecimal capital;
    private Date fechaVencimiento;
    private BigDecimal interes;
    private Float tipoIntDemora;
    
    private Date fechaCertifDeuda;
    private BigDecimal principalCertif;
    private BigDecimal intCertif;
    private BigDecimal demCertif;
    
    private String tipoProc;
    private String autos;    
    private String juzgado;
    private String abogado;
    private String procurador;
    
	public Date getFechaCalculo() {
		return fechaCalculo;
	}
	public void setFechaCalculo(Date fechaCalculo) {
		this.fechaCalculo = fechaCalculo;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
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
	public Float getTipoIntDemora() {
		return tipoIntDemora;
	}
	public void setTipoIntDemora(Float tipoIntDemora) {
		this.tipoIntDemora = tipoIntDemora;
	}
	public Date getFechaCertifDeuda() {
		return fechaCertifDeuda;
	}
	public void setFechaCertifDeuda(Date fechaCertifDeuda) {
		this.fechaCertifDeuda = fechaCertifDeuda;
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
	public String getAutos() {
		return autos;
	}
	public void setAutos(String autos) {
		this.autos = autos;
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
    
    /*private Date fechaLiquidacion;
    private String acuerdo = null;
    private BigDecimal totalDeuda = null;*/
}

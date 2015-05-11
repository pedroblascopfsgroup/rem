package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.springframework.beans.factory.annotation.Configurable;

import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;

@Configurable
@Entity
@Table(name="VINFSUBASTALETRADO", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class InformeSubastaLetradoBean extends InformeSubastaCommon implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}
	
	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}
	
	public SubastaApi getSubastaApi() {
		return subastaApi;
	}

	public void setSubastaApi(SubastaApi subastaApi) {
		this.subastaApi = subastaApi;
	}	
	
	//Long idAsunto;
	@Id
	@Column(name = "SUB_ID")
	private Long idSubasta;
	
	@Column(name="NUMERO_AUTO")
	private String nAuto;
	
	@Column(name="NUMERO_JUZ")
	private String nJuzgado;
	
	@Column(name="PROV_JUZ")
	private String pJuzgado;
	
	@Column(name="NUM_OPERACION")
	private String nOperacion;
	
	@Column(name="CENTRO")
	private String centro;
	
	@Column(name="TITULAR")
	private String titular;
	
	@Column(name="FIADORES")
	private Boolean fiadores;
	
	@Column(name="TPO_PROCEDI")
	private String tpoProcedi;
	
	@Column(name="LETRADO")
	private String letrado;
	
	@Column(name="PROCURADOR")
	private String procurador;
	
	@Column(name="FDEMANDA")
	private Date fDemanda;
	
	@Column(name="FSUBASTA")
	private Date fSubasta;
	
	@Column(name="TPO_SUBASTA")
	private BigDecimal tpoSubasta;
	
	@Column(name="PRINCIPAL_DEMANDA")
	private BigDecimal pDemanda;
	
	@Column(name="INT_MORATORIOS")
	private String iMoratorios;
	
	@Column(name="MINUTA_LETRADO")
	private String mLetrado;
	
	@Column(name="MINUTA_PROCURADOR")
	private String mProcurador;
	
	@Column(name="ENTREGAS_CUENTA")
	private BigDecimal entregasCuenta;
	
	@Column(name="COMENTARIOS")
	private String comentarios;
	
	@Column(name="CERTCARGAS")
	private Boolean certCargas;
	
	@Column(name="EDICTO")
	private Boolean edicto;
	
	@Column(name="AVALUO")
	private Boolean avaluo;
	
	@OneToMany(cascade=CascadeType.ALL)
	@JoinColumn(name="SUB_ID")
	private List<InformeSubastaLetradoOperacionesBean> operaciones;
	
	@OneToMany(cascade=CascadeType.ALL)
	@JoinColumn(name="SUB_ID")
	private List<InformeSubastaLetradoBienesBean> bienes;
	
	public List<Object> create() {
		System.out.println("[INFO] - START - informeSubastaLetrado");
		
		return Arrays.asList((Object) this);
	}
	
	public Long getIdSubasta() {
		return idSubasta;
	}

	public void setIdSubasta(Long idSubasta) {
		this.idSubasta = idSubasta;
	}

	public String getnAuto() {
		return Conversiones.delSeparadoresSobrantes(nAuto, "/");
	}

	public void setnAuto(String nAuto) {
		this.nAuto = nAuto;
	}

	public String getnJuzgado() {
		return nJuzgado;
	}

	public void setnJuzgado(String nJuzgado) {
		this.nJuzgado = nJuzgado;
	}

	public String getpJuzgado() {
		return pJuzgado;
	}

	public void setpJuzgado(String pJuzgado) {
		this.pJuzgado = pJuzgado;
	}

	public String getnOperacion() {
		return nOperacion;
	}

	public void setnOperacion(String nOperacion) {
		this.nOperacion = nOperacion;
	}

	public String getCentro() {
		return centro;
	}

	public void setCentro(String centro) {
		this.centro = centro;
	}

	public String getTitular() {
		return titular;
	}

	public void setTitular(String titular) {
		this.titular = titular;
	}

	public Boolean getFiadores() {
		return fiadores;
	}

	public void setFiadores(Boolean fiadores) {
		this.fiadores = fiadores;
	}

	public String getTpoProcedi() {
		return tpoProcedi;
	}

	public void setTpoProcedi(String tpoProcedi) {
		this.tpoProcedi = tpoProcedi;
	}

	public String getLetrado() {
		return letrado;
	}

	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}

	public String getProcurador() {
		return procurador;
	}

	public void setProcurador(String procurador) {
		this.procurador = procurador;
	}

	public Date getfDemanda() {
		return fDemanda;
	}

	public void setfDemanda(Date fDemanda) {
		this.fDemanda = fDemanda;
	}

	public Date getfSubasta() {
		return fSubasta;
	}

	public void setfSubasta(Date fSubasta) {
		this.fSubasta = fSubasta;
	}

	public BigDecimal getTpoSubasta() {
		return tpoSubasta;
	}

	public void setTpoSubasta(BigDecimal tpoSubasta) {
		this.tpoSubasta = tpoSubasta;
	}

	public BigDecimal getpDemanda() {
		return pDemanda;
	}

	public void setpDemanda(BigDecimal pDemanda) {
		this.pDemanda = pDemanda;
	}

	public BigDecimal getIntMoratorios() {
		BigDecimal bdMoratorios = null;
		try {
			bdMoratorios = new BigDecimal(this.iMoratorios.replace(".", ","));
		} catch (Exception e) {
			try {
				bdMoratorios = new BigDecimal(this.iMoratorios.replace(",","."));
			} catch (Exception e2) {}
		}
		
		return bdMoratorios;
	}

	public void setIntMoratorios(BigDecimal intMoratorios) {
		this.iMoratorios = intMoratorios.toString();
	}

	public BigDecimal getMinutaLetrado() {
		BigDecimal bdMinutaLetrado = null;
		try {
			bdMinutaLetrado = new BigDecimal(this.mLetrado.replace(".", ","));
		} catch (Exception e) {
			try {
				bdMinutaLetrado = new BigDecimal(this.mLetrado.replace(",","."));
			} catch (Exception e2){}
		}
		return bdMinutaLetrado;
	}

	public void setMinutaLetrado(BigDecimal minutaLetrado) {
		this.mLetrado = minutaLetrado.toString();
	}

	public BigDecimal getMinutaProcurador() {
		BigDecimal bdMinutaProcurador = null;
		try {
			bdMinutaProcurador = new BigDecimal(this.mProcurador.replace(",","."));
		} catch (Exception e) {
			try {
				bdMinutaProcurador = new BigDecimal(this.mProcurador.replace(".", ","));
			} catch (Exception e2) {}
		}
		return bdMinutaProcurador;
	}

	public void setMinutaProcurador(BigDecimal minutaProcurador) {
		this.mProcurador = minutaProcurador.toString();
	}

	public BigDecimal getEntregasCuenta() {
		return entregasCuenta;
	}

	public void setEntregasCuenta(BigDecimal entregasCuenta) {
		this.entregasCuenta = entregasCuenta;
	}

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}

	public Boolean getCertCargas() {
		return certCargas;
	}

	public void setCertCargas(Boolean certCargas) {
		this.certCargas = certCargas;
	}

	public Boolean getEdicto() {
		return edicto;
	}

	public void setEdicto(Boolean edicto) {
		this.edicto = edicto;
	}

	public Boolean getAvaluo() {
		return avaluo;
	}

	public void setAvaluo(Boolean avaluo) {
		this.avaluo = avaluo;
	}

	public List<InformeSubastaLetradoOperacionesBean> getOperaciones() {
		return operaciones;
	}

	public void setOperaciones(
			List<InformeSubastaLetradoOperacionesBean> operaciones) {
		this.operaciones = operaciones;
	}

	public List<InformeSubastaLetradoBienesBean> getBienes() {
		return bienes;
	}

	public void setBienes(List<InformeSubastaLetradoBienesBean> bienes) {
		this.bienes = bienes;
	}

	public String getiMoratorios() {
		return iMoratorios;
	}

	public void setiMoratorios(String iMoratorios) {
		this.iMoratorios = iMoratorios;
	}

	public String getmLetrado() {
		return mLetrado;
	}

	public void setmLetrado(String mLetrado) {
		this.mLetrado = mLetrado;
	}

	public String getmProcurador() {
		return mProcurador;
	}

	public void setmProcurador(String mProcurador) {
		this.mProcurador = mProcurador;
	}

	
}

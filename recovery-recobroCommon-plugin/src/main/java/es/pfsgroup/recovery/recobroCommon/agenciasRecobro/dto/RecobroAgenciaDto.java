package es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroAgenciaDto extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5742135410450445430L;
	
	private Long id;
	
	private String codigo;
	
	private String nombre;
	
	private String nif;
	
	private String contactoNombre;
	
	private String contactoApe1;
	
	private String contactoApe2;
	
	private String contactoMail;
	
	private String contactoTelf;
	
	private String denominacionFiscal;
	
	private String codigoTipoVia;

	private String nombreVia;
	
	private String numero;
	
	private String codigoProvincia;
	
	private String codigoPoblacion;
	
	private String codigoMunicipio;
	
	private String codigoPais;
	
	private Long idEsquema;
	
	private Long usuario;
	
	private Long despacho;

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

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}

	public String getContactoNombre() {
		return contactoNombre;
	}

	public void setContactoNombre(String contactoNombre) {
		this.contactoNombre = contactoNombre;
	}

	public String getContactoApe1() {
		return contactoApe1;
	}

	public void setContactoApe1(String contactoApe1) {
		this.contactoApe1 = contactoApe1;
	}

	public String getContactoApe2() {
		return contactoApe2;
	}

	public void setContactoApe2(String contactoApe2) {
		this.contactoApe2 = contactoApe2;
	}

	public String getContactoMail() {
		return contactoMail;
	}

	public void setContactoMail(String contactoMail) {
		this.contactoMail = contactoMail;
	}

	public String getContactoTelf() {
		return contactoTelf;
	}

	public void setContactoTelf(String contactoTelf) {
		this.contactoTelf = contactoTelf;
	}

	public String getDenominacionFiscal() {
		return denominacionFiscal;
	}

	public void setDenominacionFiscal(String denominacionFiscal) {
		this.denominacionFiscal = denominacionFiscal;
	}

	public String getCodigoTipoVia() {
		return codigoTipoVia;
	}

	public void setCodigoTipoVia(String codigoTipoVia) {
		this.codigoTipoVia = codigoTipoVia;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}

	public String getNumero() {
		return numero;
	}

	public void setNumero(String numero) {
		this.numero = numero;
	}

	public String getCodigoProvincia() {
		return codigoProvincia;
	}

	public void setCodigoProvincia(String codigoProvincia) {
		this.codigoProvincia = codigoProvincia;
	}

	public String getCodigoPoblacion() {
		return codigoPoblacion;
	}

	public void setCodigoPoblacion(String codigoPoblacion) {
		this.codigoPoblacion = codigoPoblacion;
	}

	public String getCodigoMunicipio() {
		return codigoMunicipio;
	}

	public void setCodigoMunicipio(String codigoMunicipio) {
		this.codigoMunicipio = codigoMunicipio;
	}

	public String getCodigoPais() {
		return codigoPais;
	}

	public void setCodigoPais(String codigoPais) {
		this.codigoPais = codigoPais;
	}

	public Long getIdEsquema() {
		return idEsquema;
	}

	public void setIdEsquema(Long idEsquema) {
		this.idEsquema = idEsquema;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Long getUsuario() {
		return usuario;
	}

	public void setUsuario(Long usuario) {
		this.usuario = usuario;
	}
	
	public Long getDespacho() {
		return despacho;
	}

	public void setDespacho(Long despacho) {
		this.despacho = despacho;
	}
	
}

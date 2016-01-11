package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes;

import java.math.BigDecimal;
import es.capgemini.devon.dto.WebDto;

public class DtoNMBBien extends WebDto {

    /**
     * serial.
     */
    private static final long serialVersionUID = -6637787116506547314L;
    
    /* Datos principales */
    private Long id;
    private String tipoBien; 
    private BigDecimal valorActual;
    private Float importeCargas;
    private String descripcionBien;
    private String fechaVerificacion;
    private Float participacionNMB;
    private String situacionPosesoria;
	private String viviendaHabitual;
	private Float tipoSubasta;
	private String numeroActivo ;
	private String licenciaPrimeraOcupacion;
	private String primeraTransmision ;
	private String contratoAlquiler;
	private String transmitentePromotor;
	private String arrendadoSinOpcCompra;
	private String usoPromotorMayorDosAnyos;
	
    
	/* campos propios de Bien */
	private Float bieSuperficie;	
	private Integer participacion;
	private String referenciaCatastral;
    private String datosRegistrales;
    private String biePoblacion;
    
    /* Datos registrales */
    private String referenciaCatastralBien;   
	
    private Float superficie;
	
    private Float superficieConstruida;
	
	private String tomo;
	
	private String libro;
	
	private String folio;

	private String inscripcion;
	
	private String fechaInscripcion;
	
	private String numRegistro;
	
	private String municipoLibro;
	
	private String codigoRegistro;
	
	private String municipioRegistro;
	
	private String provinciaRegistro;
    
	/* Datos Localizacion */
	private String provincia;
	
	private String poblacion;
	
    private String direccion;
	
    private String codPostal;
	
    private String numFinca;
    
    private String tipoVia;
    
    private String nombreVia;
    
    private String numeroDomicilio;
    
    private String portal;
    
    private String bloque;
    
    private String escalera;
    
    private String piso;
    
    private String puerta;
    
    private String barrio;
    
    private String pais;
    
    private String localidad;
    
    private String unidadPoblacional;
	
    /* Datos Valoracion */
    private String fechaValorSubjetivo;
	
    private Float importeValorSubjetivo;
	
    private String fechaValorApreciacion;
	
    private Float importeValorApreciacion;
	
    private String fechaValorTasacion;
	
    private Float importeValorTasacion;

    private boolean solvenciaNoEncontrada;
    private boolean obraEnCurso;
    private boolean dueDilligence;
    private String fechaDueD;
    private String fechaSolicitudDueD;
    private String tributacion;
    
    private String observaciones;
    
    private Float  valorTasacionExterna;
    private String fechaTasacionExterna;
    private String tasadora            ;
    private String fechaSolicitudTasacion;
    private String respuestaConsulta;
    
    private Float porcentajeImpuestoCompra;
    private String impuestoCompra;
    private String tipoImposicionCompra;
    private String tributacionVenta;
    private String tipoImposicionVenta;
    private String inversionPorRenuncia;
    
    
    /* Datos Adicionales */
    
    private String nomEmpresa;
    private String cifEmpresa;
    private String codIAE;
    private String desIAE;
    private String tipoProdBancario;
   	private String tipoInmueble;
   	private Float valoracion;
   	private String entidad;
   	private String numCuenta;
   	private String matricula;
   	private String bastidor;
   	private String modelo;
   	private String marca;
   	private String fechaMatricula;
   	
   /* public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        /*if (bien.getParticipacion() == null) {
            messageContext.addMessage(new MessageBuilder().code("bienes.error.participacionnula").error().source("").defaultText(
                    "**Ingrese el porcentaje de 'Participaci�n'.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        final int participacion = 100;
        if (bien.getParticipacion() != null){
	        if (bien.getParticipacion() != null && (bien.getParticipacion() < 1 || bien.getParticipacion() > participacion)) {
	            messageContext.addMessage(new MessageBuilder().code("bienes.error.participacion").error().source("").defaultText(
	                    "**El porcentaje en 'Participaci�n' debe ser entre 1 y 100.").build());
	            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
	        }
	        addValidation(bien, messageContext, "bien").addValidation(this, messageContext).validate();
        }
    }    */
   	
   	
   	
    
    public String getReferenciaCatastralBien() {
		return referenciaCatastralBien;
	}

	public Float getTipoSubasta() {
		return tipoSubasta;
	}

	public void setTipoSubasta(Float tipoSubasta) {
		this.tipoSubasta = tipoSubasta;
	}

	public String getSituacionPosesoria() {
		return situacionPosesoria;
	}

	public void setSituacionPosesoria(String situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
	}

	public String getViviendaHabitual() {
		return viviendaHabitual;
	}

	public void setViviendaHabitual(String viviendaHabitual) {
		this.viviendaHabitual = viviendaHabitual;
	}

	public Float getValorTasacionExterna() {
		return valorTasacionExterna;
	}

	public void setValorTasacionExterna(Float valorTasacionExterna) {
		this.valorTasacionExterna = valorTasacionExterna;
	}

	public String getNumeroActivo() {
		return numeroActivo;
	}

	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}

	public String getLicenciaPrimeraOcupacion() {
		return licenciaPrimeraOcupacion;
	}

	public void setLicenciaPrimeraOcupacion(String licenciaPrimeraOcupacion) {
		this.licenciaPrimeraOcupacion = licenciaPrimeraOcupacion;
	}

	public String getPrimeraTransmision() {
		return primeraTransmision;
	}

	public void setPrimeraTransmision(String primeraTransmision) {
		this.primeraTransmision = primeraTransmision;
	}

	public String getContratoAlquiler() {
		return contratoAlquiler;
	}

	public void setContratoAlquiler(String contratoAlquiler) {
		this.contratoAlquiler = contratoAlquiler;
	}

	public String getFechaTasacionExterna() {
		return fechaTasacionExterna;
	}

	public void setFechaTasacionExterna(String fechaTasacionExterna) {
		this.fechaTasacionExterna = fechaTasacionExterna;
	}

	public String getTasadora() {
		return tasadora;
	}

	public void setTasadora(String tasadora) {
		this.tasadora = tasadora;
	}

	public String getFechaSolicitudTasacion() {
		return fechaSolicitudTasacion;
	}

	public void setFechaSolicitudTasacion(String fechaSolicitudTasacion) {
		this.fechaSolicitudTasacion = fechaSolicitudTasacion;
	}

	public String getRespuestaConsulta() {
		return respuestaConsulta;
	}

	public void setRespuestaConsulta(String respuestaConsulta) {
		this.respuestaConsulta = respuestaConsulta;
	}

	public void setReferenciaCatastralBien(String referenciaCatastralBien) {
		this.referenciaCatastralBien = referenciaCatastralBien;
	}

	public Float getSuperficie() {
		return superficie;
	}

	public void setSuperficie(Float superficie) {
		this.superficie = superficie;
	}

	public Float getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Float superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}

	public String getTomo() {
		return tomo;
	}

	public void setTomo(String tomo) {
		this.tomo = tomo;
	}

	public String getLibro() {
		return libro;
	}

	public void setLibro(String libro) {
		this.libro = libro;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getInscripcion() {
		return inscripcion;
	}

	public void setInscripcion(String inscripcion) {
		this.inscripcion = inscripcion;
	}

	public String getFechaInscripcion() {
		return fechaInscripcion;
	}

	public void setFechaInscripcion(String fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}

	public String getNumRegistro() {
		return numRegistro;
	}

	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}

	public String getMunicipoLibro() {
		return municipoLibro;
	}

	public void setMunicipoLibro(String municipoLibro) {
		this.municipoLibro = municipoLibro;
	}

	public String getCodigoRegistro() {
		return codigoRegistro;
	}

	public void setCodigoRegistro(String codigoRegistro) {
		this.codigoRegistro = codigoRegistro;
	}

	public String getMunicipioRegistro() {
		return municipioRegistro;
	}

	public void setMunicipioRegistro(String municipioRegistro) {
		this.municipioRegistro = municipioRegistro;
	}

	public String getProvinciaRegistro() {
		return provinciaRegistro;
	}

	public void setProvinciaRegistro(String provinciaRegistro) {
		this.provinciaRegistro = provinciaRegistro;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getPoblacion() {
		return poblacion;
	}

	public void setPoblacion(String poblacion) {
		this.poblacion = poblacion;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public String getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(String tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}
	
	public String getNumeroDomicilio() {
		return numeroDomicilio;
	}

	public void setNumeroDomicilio(String numeroDomicilio) {
		this.numeroDomicilio = numeroDomicilio;
	}

	public String getPortal() {
		return portal;
	}

	public void setPortal(String portal) {
		this.portal = portal;
	}

	public String getBloque() {
		return bloque;
	}

	public void setBloque(String bloque) {
		this.bloque = bloque;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getPiso() {
		return piso;
	}

	public void setPiso(String piso) {
		this.piso = piso;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public String getBarrio() {
		return barrio;
	}

	public void setBarrio(String barrio) {
		this.barrio = barrio;
	}

	public String getPais() {
		return pais;
	}

	public void setPais(String pais) {
		this.pais = pais;
	}

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}

	public String getFechaValorSubjetivo() {
		return fechaValorSubjetivo;
	}

	public void setFechaValorSubjetivo(String fechaValorSubjetivo) {
		this.fechaValorSubjetivo = fechaValorSubjetivo;
	}

	public Float getImporteValorSubjetivo() {
		return importeValorSubjetivo;
	}

	public void setImporteValorSubjetivo(Float importeValorSubjetivo) {
		this.importeValorSubjetivo = importeValorSubjetivo;
	}

	public String getFechaValorApreciacion() {
		return fechaValorApreciacion;
	}

	public void setFechaValorApreciacion(String fechaValorApreciacion) {
		this.fechaValorApreciacion = fechaValorApreciacion;
	}

	public Float getImporteValorApreciacion() {
		return importeValorApreciacion;
	}

	public void setImporteValorApreciacion(Float importeValorApreciacion) {
		this.importeValorApreciacion = importeValorApreciacion;
	}

	public String getFechaValorTasacion() {
		return fechaValorTasacion;
	}

	public void setFechaValorTasacion(String fechaValorTasacion) {
		this.fechaValorTasacion = fechaValorTasacion;
	}

	public Float getImporteValorTasacion() {
		return importeValorTasacion;
	}

	public void setImporteValorTasacion(Float importeValorTasacion) {
		this.importeValorTasacion = importeValorTasacion;
	}

	public String getTipoBien() {
		return tipoBien;
	}

	public void setTipoBien(String tipoBien) {
		this.tipoBien = tipoBien;
	}

	public BigDecimal getValorActual() {
		return valorActual;
	}

	public void setValorActual(BigDecimal valorActual) {
		this.valorActual = valorActual;
	}

	public Float getImporteCargas() {
		return importeCargas;
	}

	public void setImporteCargas(Float importeCargas) {
		this.importeCargas = importeCargas;
	}

	public String getBiePoblacion() {
		return biePoblacion;
	}

	public void setBiePoblacion(String biePoblacion) {
		this.biePoblacion = biePoblacion;
	}

	public String getDescripcionBien() {
		return descripcionBien;
	}

	public void setDescripcionBien(String descripcionBien) {
		this.descripcionBien = descripcionBien;
	}

	public String getFechaVerificacion() {
		return fechaVerificacion;
	}

	public void setFechaVerificacion(String fechaVerificacion) {
		this.fechaVerificacion = fechaVerificacion;
	}

	public Float getBieSuperficie() {
		return bieSuperficie;
	}

	public void setBieSuperficie(Float bieSuperficie) {
		this.bieSuperficie = bieSuperficie;
	}

	public Integer getParticipacion() {
		return participacion;
	}

	public void setParticipacion(Integer participacion) {
		this.participacion = participacion;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}

	public String getDatosRegistrales() {
		return datosRegistrales;
	}

	public void setDatosRegistrales(String datosRegistrales) {
		this.datosRegistrales = datosRegistrales;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param participacionNMB the participacionNMB to set
	 */
	public void setParticipacionNMB(Float participacionNMB) {
		this.participacionNMB = participacionNMB;
	}

	/**
	 * @return the participacionNMB
	 */
	public Float getParticipacionNMB() {
		return participacionNMB;
	}

	public void setSolvenciaNoEncontrada(boolean solvenciaNoEncontrada) {
		this.solvenciaNoEncontrada = solvenciaNoEncontrada;
	}

	public boolean isSolvenciaNoEncontrada() {
		return solvenciaNoEncontrada;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getNomEmpresa() {
		return nomEmpresa;
	}

	public void setNomEmpresa(String nomEmpresa) {
		this.nomEmpresa = nomEmpresa;
	}

	public String getCifEmpresa() {
		return cifEmpresa;
	}

	public void setCifEmpresa(String cifEmpresa) {
		this.cifEmpresa = cifEmpresa;
	}

	public String getCodIAE() {
		return codIAE;
	}

	public void setCodIAE(String codIAE) {
		this.codIAE = codIAE;
	}

	public String getDesIAE() {
		return desIAE;
	}

	public void setDesIAE(String desIAE) {
		this.desIAE = desIAE;
	}

	public String getTipoProdBancario() {
		return tipoProdBancario;
	}

	public void setTipoProdBancario(String tipoProdBancario) {
		this.tipoProdBancario = tipoProdBancario;
	}

	public String getTipoInmueble() {
		return tipoInmueble;
	}

	public void setTipoInmueble(String tipoInmueble) {
		this.tipoInmueble = tipoInmueble;
	}

	public Float getValoracion() {
		return valoracion;
	}

	public void setValoracion(Float valoracion) {
		this.valoracion = valoracion;
	}

	public String getEntidad() {
		return entidad;
	}

	public void setEntidad(String entidad) {
		this.entidad = entidad;
	}

	public String getNumCuenta() {
		return numCuenta;
	}

	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public String getBastidor() {
		return bastidor;
	}

	public void setBastidor(String bastidor) {
		this.bastidor = bastidor;
	}

	public String getModelo() {
		return modelo;
	}

	public void setModelo(String modelo) {
		this.modelo = modelo;
	}

	public String getMarca() {
		return marca;
	}

	public void setMarca(String marca) {
		this.marca = marca;
	}

	public String getFechaMatricula() {
		return fechaMatricula;
	}

	public void setFechaMatricula(String fechaMatricula) {
		this.fechaMatricula = fechaMatricula;
	}

	public boolean isObraEnCurso() {
		return obraEnCurso;
	}

	public void setObraEnCurso(boolean obraEnCurso) {
		this.obraEnCurso = obraEnCurso;
	}
    

	public String getTransmitentePromotor() {
		return transmitentePromotor;
	}

	public void setTransmitentePromotor(String transmitentePromotor) {
		this.transmitentePromotor = transmitentePromotor;
	}

	public String getArrendadoSinOpcCompra() {
		return arrendadoSinOpcCompra;
	}

	public void setArrendadoSinOpcCompra(String arrendadoSinOpcCompra) {
		this.arrendadoSinOpcCompra = arrendadoSinOpcCompra;
	}

	public String getUsoPromotorMayorDosAnyos() {
		return usoPromotorMayorDosAnyos;
	}

	public void setUsoPromotorMayorDosAnyos(String usoPromotorMayorDosAnyos) {
		this.usoPromotorMayorDosAnyos = usoPromotorMayorDosAnyos;
	}

	public boolean isDueDilligence() {
		return dueDilligence;
	}

	public void setDueDilligence(boolean dueDilligence) {
		this.dueDilligence = dueDilligence;
	}

	public String getFechaDueD() {
		return fechaDueD;
	}

	public void setFechaDueD(String fechaDueD) {
		this.fechaDueD = fechaDueD;
	}

	public String getFechaSolicitudDueD() {
		return fechaSolicitudDueD;
	}

	public void setFechaSolicitudDueD(String fechaSolicitudDueD) {
		this.fechaSolicitudDueD = fechaSolicitudDueD;
	}

	public String getTributacion() {
		return tributacion;
	}

	public void setTributacion(String tributacion) {
		this.tributacion = tributacion;
	}

	public String getLocalidad() {
		return localidad;
	}

	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}

	public String getUnidadPoblacional() {
		return unidadPoblacional;
	}

	public void setUnidadPoblacional(String unidadPoblacional) {
		this.unidadPoblacional = unidadPoblacional;
	}

	public Float getPorcentajeImpuestoCompra() {
		return porcentajeImpuestoCompra;
	}

	public void setPorcentajeImpuestoCompra(Float porcentajeImpuestoCompra) {
		this.porcentajeImpuestoCompra = porcentajeImpuestoCompra;
	}

	public String getImpuestoCompra() {
		return impuestoCompra;
	}

	public void setImpuestoCompra(String impuestoCompra) {
		this.impuestoCompra = impuestoCompra;
	}

	public String getTipoImposicionCompra() {
		return tipoImposicionCompra;
	}

	public void setTipoImposicionCompra(String tipoImposicionCompra) {
		this.tipoImposicionCompra = tipoImposicionCompra;
	}

	public String getTributacionVenta() {
		return tributacionVenta;
	}

	public void setTributacionVenta(String tributacionVenta) {
		this.tributacionVenta = tributacionVenta;
	}

	public String getTipoImposicionVenta() {
		return tipoImposicionVenta;
	}

	public void setTipoImposicionVenta(String tipoImposicionVenta) {
		this.tipoImposicionVenta = tipoImposicionVenta;
	}

	public String getInversionPorRenuncia() {
		return inversionPorRenuncia;
	}

	public void setInversionPorRenuncia(String inversionPorRenuncia) {
		this.inversionPorRenuncia = inversionPorRenuncia;
	}
	

}
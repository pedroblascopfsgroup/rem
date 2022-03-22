package es.pfsgroup.plugin.rem.restclient.caixabc;


public class ReplicarOfertaDto {
    private Long numeroOferta;
    private String estadoExpedienteBcCodigoBC;
    private String estadoScoringAlquilerCodigoBC;
    private String fechaPropuesta;
    private String estadoArras;
    private String codEstadoAlquiler;
    private String codRespuestaComprador;
    private CexDto compradorEditado;
    private String sancionCLROD;
    private String fechaFirma;
    private String fechaEnvio;
    private String codResultadoScoringBc;
    private String ratingScoringServicerC4c;
    private String fechaScoringBc;
    private String fechaEscritura;

    public Long getNumeroOferta() {
        return numeroOferta;
    }

    public void setNumeroOferta(Long numeroOferta) {
        this.numeroOferta = numeroOferta;
    }

    public String getEstadoExpedienteBcCodigoBC() {
        return estadoExpedienteBcCodigoBC;
    }

    public void setEstadoExpedienteBcCodigoBC(String estadoExpedienteBcCodigoBC) {
        this.estadoExpedienteBcCodigoBC = estadoExpedienteBcCodigoBC;
    }

    public String getEstadoScoringAlquilerCodigoBC() {
        return estadoScoringAlquilerCodigoBC;
    }

    public void setEstadoScoringAlquilerCodigoBC(String estadoScoringAlquilerCodigoBC) {
        this.estadoScoringAlquilerCodigoBC = estadoScoringAlquilerCodigoBC;
    }

    public String getFechaPropuesta() {
        return fechaPropuesta;
    }

    public void setFechaPropuesta(String fechaPropuesta) {
        this.fechaPropuesta = fechaPropuesta;
    }

    public String getEstadoArras() {
        return estadoArras;
    }

    public void setEstadoArras(String estadoArras) {
        this.estadoArras = estadoArras;
    }

    public String getCodEstadoAlquiler() {
        return codEstadoAlquiler;
    }

    public void setCodEstadoAlquiler(String codEstadoAlquiler) {
        this.codEstadoAlquiler = codEstadoAlquiler;
    }

	public String getCodRespuestaComprador() {
		return codRespuestaComprador;
	}

	public void setCodRespuestaComprador(String codRespuestaComprador) {
		this.codRespuestaComprador = codRespuestaComprador;
	}

    public CexDto getCompradorEditado() {
        return compradorEditado;
    }

    public void setCompradorEditado(CexDto compradorEditado) {
        this.compradorEditado = compradorEditado;
    }

	public String getSancionCLROD() {
		return sancionCLROD;
	}

	public void setSancionCLROD(String sancionCLROD) {
		this.sancionCLROD = sancionCLROD;
	}

	public String getFechaFirma() {
		return fechaFirma;
	}

	public void setFechaFirma(String fechaFirma) {
		this.fechaFirma = fechaFirma;
	}

	public String getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(String fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public String getCodResultadoScoringBc() {
		return codResultadoScoringBc;
	}

	public void setCodResultadoScoringBc(String codResultadoScoringBc) {
		this.codResultadoScoringBc = codResultadoScoringBc;
	}

	public String getRatingScoringServicerC4c() {
		return ratingScoringServicerC4c;
	}

	public void setRatingScoringServicerC4c(String ratingScoringServicerC4c) {
		this.ratingScoringServicerC4c = ratingScoringServicerC4c;
	}

	public String getFechaScoringBc() {
		return fechaScoringBc;
	}

	public void setFechaScoringBc(String fechaScoringBc) {
		this.fechaScoringBc = fechaScoringBc;
	}

    public String getFechaEscritura() {
        return fechaEscritura;
    }

    public void setFechaEscritura(String fechaEscritura) {
        this.fechaEscritura = fechaEscritura;
    }
}

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
}

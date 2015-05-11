package es.capgemini.pfs.mapaGlobalOficina.dto;

/**
 * Dto para cargar los datos traidos de la BBDD agrupados para exportar a un CSV.
 * @author aesteban
 *
 */
public class DtoExportRow {

    private String descripcion;
    private String descripcionSecundaria;
    private Long numeroClientes;
    private Long numeroContratos;
    private Double saldoVencido;
    private Double saldoTotal;

    // Esta propiedad es usada en el export a PDF, en el export a CSV hecho
    // anteriormente se calcula a parte y se incluye en el archivo directamente,
    // habría que refactorizar, pero por ahora sigue así
    private Double porcenNumeroClientes;
    private Double porcenNumeroContratos;
    private Double porcenSaldoVencido;
    private Double porcenSaldoTotal;


    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the descripcionSecundaria
     */
    public String getDescripcionSecundaria() {
        return descripcionSecundaria;
    }

    /**
     * @param descripcionSecundaria the descripcionSecundaria to set
     */
    public void setDescripcionSecundaria(String descripcionSecundaria) {
        this.descripcionSecundaria = descripcionSecundaria;
    }

    /**
     * @return the numeroClientes
     */
    public Long getNumeroClientes() {
        return numeroClientes;
    }

    /**
     * @param numeroClientes the numeroClientes to set
     */
    public void setNumeroClientes(Long numeroClientes) {
        this.numeroClientes = numeroClientes;
    }

    /**
     * @return the numeroContratos
     */
    public Long getNumeroContratos() {
        return numeroContratos;
    }

    /**
     * @param numeroContratos the numeroContratos to set
     */
    public void setNumeroContratos(Long numeroContratos) {
        this.numeroContratos = numeroContratos;
    }

    /**
     * @return the saldoVencido
     */
    public Double getSaldoVencido() {
        return saldoVencido;
    }

    /**
     * @return the saldoVencido
     */
    public Double getSaldoVencidoAbs() {
        return Math.abs(saldoVencido);
    }
    /**
     * @param saldoVencido the saldoVencido to set
     */
    public void setSaldoVencido(Double saldoVencido) {
        this.saldoVencido = saldoVencido;
    }

    /**
     * @return the saldoTotal
     */
    public Double getSaldoTotal() {
        return saldoTotal;
    }

    /**
     * @return the saldoTotal
     */
    public Double getSaldoTotalAbs() {
        return Math.abs(saldoTotal);
    }
    /**
     * @param saldoTotal the saldoTotal to set
     */
    public void setSaldoTotal(Double saldoTotal) {
        this.saldoTotal = saldoTotal;
    }

	/**
	 * @return the porcenNumeroClientes
	 */
	public Double getPorcenNumeroClientes() {
		return porcenNumeroClientes;
	}

	/**
	 * @param porcenNumeroClientes the porcenNumeroClientes to set
	 */
	public void setPorcenNumeroClientes(Double porcenNumeroClientes) {
		this.porcenNumeroClientes = porcenNumeroClientes;
	}

	/**
	 * @return the porcenNumeroContratos
	 */
	public Double getPorcenNumeroContratos() {
		return porcenNumeroContratos;
	}

	/**
	 * @param porcenNumeroContratos the porcenNumeroContratos to set
	 */
	public void setPorcenNumeroContratos(Double porcenNumeroContratos) {
		this.porcenNumeroContratos = porcenNumeroContratos;
	}

	/**
	 * @return the porcenSaldoVencido
	 */
	public Double getPorcenSaldoVencido() {
		return porcenSaldoVencido;
	}

	/**
	 * @param porcenSaldoVencido the porcenSaldoVencido to set
	 */
	public void setPorcenSaldoVencido(Double porcenSaldoVencido) {
		this.porcenSaldoVencido = porcenSaldoVencido;
	}

	/**
	 * @return the porcenSaldoTotal
	 */
	public Double getPorcenSaldoTotal() {
		return porcenSaldoTotal;
	}

	/**
	 * @param porcenSaldoTotal the porcenSaldoTotal to set
	 */
	public void setPorcenSaldoTotal(Double porcenSaldoTotal) {
		this.porcenSaldoTotal = porcenSaldoTotal;
	}
}

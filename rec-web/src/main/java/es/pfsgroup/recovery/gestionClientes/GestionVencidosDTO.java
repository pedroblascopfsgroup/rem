package es.pfsgroup.recovery.gestionClientes;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.generic.dto.WebBeanDTO;

public class GestionVencidosDTO extends WebBeanDTO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private BigDecimal id;
	private String descripcion;
	private String nombre;
	private String apellido1;
	private String apellido2;
	private String apellidos;
	private BigDecimal codClienteEntidad;
	private String docId;
	private String telefono1;
	private String descripcionSegmento;
	private String descripcionSegmentoEntidad;
	private BigDecimal numContratos;
	private BigDecimal deudaIrregular;
	private BigDecimal riesgoDirectoDanyado;
	private String descripcionEstadoFinanciero;
	private BigDecimal riesgoAutorizado;
	private BigDecimal riesgoDispuesto;
	private String domicilio;
	private String localidad;
	private String situacion;
	private BigDecimal riesgoTotal;
	private BigDecimal diasVencidos;
	private BigDecimal riesgoTotalDirecto;
	private Date fechaDato;
	private String dispuestoVencido;
	private String dispuestoNoVencido;
	private String relacionExpediente;
	private BigDecimal codigoOficina;
    private String nombreOficina;
    private String nombreArquetipo;
    private String tipoItinerario;
    private Date fechaUmbral;
    private BigDecimal importeUmbral;
    private BigDecimal riesgoDirecto;
    private Date fechaCreacion;
    private String codigoItinerario;
    private BigDecimal plazoCarencia;
    private BigDecimal plazoVencidos;
    
	/**
	 * @return the id
	 */
	public BigDecimal getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(BigDecimal id) {
		this.id = id;
	}

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
	 * @return the nombre
	 */
	public String getNombre() {
		return nombre;
	}

	/**
	 * @param nombre the nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	/**
	 * @return the apellido1
	 */
	public String getApellido1() {
		return apellido1;
	}

	/**
	 * @param apellido1 the apellido1 to set
	 */
	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}

	/**
	 * @return the apellido2
	 */
	public String getApellido2() {
		return apellido2;
	}

	/**
	 * @param apellido2 the apellido2 to set
	 */
	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}

	/**
	 * @return the codClienteEntidad
	 */
	public BigDecimal getCodClienteEntidad() {
		return codClienteEntidad;
	}

	/**
	 * @param codClienteEntidad the codClienteEntidad to set
	 */
	public void setCodClienteEntidad(BigDecimal codClienteEntidad) {
		this.codClienteEntidad = codClienteEntidad;
	}

	/**
	 * @return the docId
	 */
	public String getDocId() {
		return docId;
	}

	/**
	 * @param docId the docId to set
	 */
	public void setDocId(String docId) {
		this.docId = docId;
	}

	/**
	 * @return the telefono1
	 */
	public String getTelefono1() {
		return telefono1;
	}

	/**
	 * @param telefono1 the telefono1 to set
	 */
	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}

	/**
	 * @return the descripcionSegmento
	 */
	public String getDescripcionSegmento() {
		return descripcionSegmento;
	}

	/**
	 * @param descripcionSegmento the descripcionSegmento to set
	 */
	public void setDescripcionSegmento(String descripcionSegmento) {
		this.descripcionSegmento = descripcionSegmento;
	}

	/**
	 * @return the descripcionSegmentoEntidad
	 */
	public String getDescripcionSegmentoEntidad() {
		return descripcionSegmentoEntidad;
	}

	/**
	 * @param descripcionSegmentoEntidad the descripcionSegmentoEntidad to set
	 */
	public void setDescripcionSegmentoEntidad(String descripcionSegmentoEntidad) {
		this.descripcionSegmentoEntidad = descripcionSegmentoEntidad;
	}

	/**
	 * @return the numContratos
	 */
	public BigDecimal getNumContratos() {
		return numContratos;
	}

	/**
	 * @param numContratos the numContratos to set
	 */
	public void setNumContratos(BigDecimal numContratos) {
		this.numContratos = numContratos;
	}

	/**
	 * @return the deudaIrregular
	 */
	public BigDecimal getDeudaIrregular() {
		return deudaIrregular;
	}

	/**
	 * @param deudaIrregular the deudaIrregular to set
	 */
	public void setDeudaIrregular(BigDecimal deudaIrregular) {
		this.deudaIrregular = deudaIrregular;
	}
	
	/**
	 * obtiene el apellido y el nombre.
	 * 
	 * @return apellido nombre
	 */
	public String getApellidoNombre() {
		String r = "";
		if (apellido1 != null && apellido1.trim().length() > 0) {
			r += apellido1.trim() + " ";
		}
		if (apellido2 != null && apellido2.trim().length() > 0) {
			r += apellido2.trim();
		}
		if (r.trim().length() > 0) {
			r += ", ";
		}
		if (nombre != null && nombre.trim().length() > 0) {
			r += nombre.trim();
		}
		return r;
	}

	/**
	 * @return the riesgoDirectoDanyado
	 */
	public BigDecimal getRiesgoDirectoDanyado() {
		return riesgoDirectoDanyado;
	}

	/**
	 * @param riesgoDirectoDanyado the riesgoDirectoDanyado to set
	 */
	public void setRiesgoDirectoDanyado(BigDecimal riesgoDirectoDanyado) {
		this.riesgoDirectoDanyado = riesgoDirectoDanyado;
	}

	/**
	 * @return the descripcionEstadoFinanciero
	 */
	public String getDescripcionEstadoFinanciero() {
		return descripcionEstadoFinanciero;
	}

	/**
	 * @param descripcionEstadoFinanciero the descripcionEstadoFinanciero to set
	 */
	public void setDescripcionEstadoFinanciero(
			String descripcionEstadoFinanciero) {
		this.descripcionEstadoFinanciero = descripcionEstadoFinanciero;
	}

	/**
	 * @return the riesgoAutorizado
	 */
	public BigDecimal getRiesgoAutorizado() {
		return riesgoAutorizado;
	}

	/**
	 * @param riesgoAutorizado the riesgoAutorizado to set
	 */
	public void setRiesgoAutorizado(BigDecimal riesgoAutorizado) {
		this.riesgoAutorizado = riesgoAutorizado;
	}

	/**
	 * @return the riesgoDispuesto
	 */
	public BigDecimal getRiesgoDispuesto() {
		return riesgoDispuesto;
	}

	/**
	 * @param riesgoDispuesto the riesgoDispuesto to set
	 */
	public void setRiesgoDispuesto(BigDecimal riesgoDispuesto) {
		this.riesgoDispuesto = riesgoDispuesto;
	}

	/**
	 * @return the domicilio
	 */
	public String getDomicilio() {
		return domicilio;
	}

	/**
	 * @param domicilio the domicilio to set
	 */
	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}

	/**
	 * @return the localidad
	 */
	public String getLocalidad() {
		return localidad;
	}

	/**
	 * @param localidad the localidad to set
	 */
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}

	/**
	 * @return the situacion
	 */
	public String getSituacion() {
		return situacion;
	}

	/**
	 * @param situacion the situacion to set
	 */
	public void setSituacion(String situacion) {
		this.situacion = situacion;
	}

	/**
	 * @return the riesgoTotal
	 */
	public BigDecimal getRiesgoTotal() {
		return riesgoTotal;
	}

	/**
	 * @param riesgoTotal the riesgoTotal to set
	 */
	public void setRiesgoTotal(BigDecimal riesgoTotal) {
		this.riesgoTotal = riesgoTotal;
	}

	/**
	 * @return the diasVencidos
	 */
	public BigDecimal getDiasVencidos() {
		return diasVencidos;
	}

	/**
	 * @param diasVencidos the diasVencidos to set
	 */
	public void setDiasVencidos(BigDecimal diasVencidos) {
		this.diasVencidos = diasVencidos;
	}

	/**
	 * @return the riesgoTotalDirecto
	 */
	public BigDecimal getRiesgoTotalDirecto() {
		return riesgoTotalDirecto;
	}

	/**
	 * @param riesgoTotalDirecto the riesgoTotalDirecto to set
	 */
	public void setRiesgoTotalDirecto(BigDecimal riesgoTotalDirecto) {
		this.riesgoTotalDirecto = riesgoTotalDirecto;
	}

	/**
	 * @return the fechaDato
	 */
	public Date getFechaDato() {
		return fechaDato;
	}

	/**
	 * @param fechaDato the fechaDato to set
	 */
	public void setFechaDato(Date fechaDato) {
		this.fechaDato = fechaDato;
	}

	/**
	 * @return the dispuestoVencido
	 */
	public String getDispuestoVencido() {
		return dispuestoVencido;
	}

	/**
	 * @param dispuestoVencido the dispuestoVencido to set
	 */
	public void setDispuestoVencido(String dispuestoVencido) {
		this.dispuestoVencido = dispuestoVencido;
	}

	/**
	 * @return the dispuestoNoVencido
	 */
	public String getDispuestoNoVencido() {
		return dispuestoNoVencido;
	}

	/**
	 * @param dispuestoNoVencido the dispuestoNoVencido to set
	 */
	public void setDispuestoNoVencido(String dispuestoNoVencido) {
		this.dispuestoNoVencido = dispuestoNoVencido;
	}

	/**
	 * @return the relacionExpediente
	 */
	public String getRelacionExpediente() {
		return relacionExpediente;
	}

	/**
	 * @param relacionExpediente the relacionExpediente to set
	 */
	public void setRelacionExpediente(String relacionExpediente) {
		this.relacionExpediente = relacionExpediente;
	}

	/**
	 * @return the codigoOficina
	 */
	public BigDecimal getCodigoOficina() {
		return codigoOficina;
	}

	/**
	 * @param codigoOficina the codigoOficina to set
	 */
	public void setCodigoOficina(BigDecimal codigoOficina) {
		this.codigoOficina = codigoOficina;
	}

	/**
	 * @return the nombreOficina
	 */
	public String getNombreOficina() {
		return nombreOficina;
	}

	/**
	 * @param nombreOficina the nombreOficina to set
	 */
	public void setNombreOficina(String nombreOficina) {
		this.nombreOficina = nombreOficina;
	}

	/**
	 * @return the nombreArquetipo
	 */
	public String getNombreArquetipo() {
		return nombreArquetipo;
	}

	/**
	 * @param nombreArquetipo the nombreArquetipo to set
	 */
	public void setNombreArquetipo(String nombreArquetipo) {
		this.nombreArquetipo = nombreArquetipo;
	}

	/**
	 * @return the tipoItinerario
	 */
	public String getTipoItinerario() {
		return tipoItinerario;
	}

	/**
	 * @param tipoItinerario the tipoItinerario to set
	 */
	public void setTipoItinerario(String tipoItinerario) {
		this.tipoItinerario = tipoItinerario;
	}

	/**
	 * @return the fechaUmbral
	 */
	public Date getFechaUmbral() {
		return fechaUmbral;
	}

	/**
	 * @param fechaUmbral the fechaUmbral to set
	 */
	public void setFechaUmbral(Date fechaUmbral) {
		this.fechaUmbral = fechaUmbral;
	}

	/**
	 * @return the importeUmbral
	 */
	public BigDecimal getImporteUmbral() {
		return importeUmbral;
	}

	/**
	 * @param importeUmbral the importeUmbral to set
	 */
	public void setImporteUmbral(BigDecimal importeUmbral) {
		this.importeUmbral = importeUmbral;
	}

	/**
	 * @return the riesgoDirecto
	 */
	public BigDecimal getRiesgoDirecto() {
		return riesgoDirecto;
	}

	/**
	 * @param riesgoDirecto the riesgoDirecto to set
	 */
	public void setRiesgoDirecto(BigDecimal riesgoDirecto) {
		this.riesgoDirecto = riesgoDirecto;
	}

	/**
	 * @return the fechaCreacion
	 */
	public Date getFechaCreacion() {
		return fechaCreacion;
	}

	/**
	 * @param fechaCreacion the fechaCreacion to set
	 */
	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}

	/**
	 * @return the codigoItinerario
	 */
	public String getCodigoItinerario() {
		return codigoItinerario;
	}

	/**
	 * @param codigoItinerario the codigoItinerario to set
	 */
	public void setCodigoItinerario(String codigoItinerario) {
		this.codigoItinerario = codigoItinerario;
	}

	/**
	 * @return the plazoCarencia
	 */
	public BigDecimal getPlazoCarencia() {
		return plazoCarencia;
	}

	/**
	 * @param plazoCarencia the plazoCarencia to set
	 */
	public void setPlazoCarencia(BigDecimal plazoCarencia) {
		this.plazoCarencia = plazoCarencia;
	}

	/**
	 * @return the plazoVencidos
	 */
	public BigDecimal getPlazoVencidos() {
		return plazoVencidos;
	}

	/**
	 * @param plazoVencidos the plazoVencidos to set
	 */
	public void setPlazoVencidos(BigDecimal plazoVencidos) {
		this.plazoVencidos = plazoVencidos;
	}

	/**
     * Indica si este cliente está bajo el umbral para crear el expediente.
     * @return un boolean
     */
    public boolean getBajoUmbral() {
        return ((fechaUmbral != null) && (fechaUmbral.getTime() > System.currentTimeMillis()) && (importeUmbral.compareTo(riesgoDirecto) > 0));
    }
    
    /**
     * Retorna la cantidad de dias para que el cliente cambie de estado.
     * @return int
     */
    public int getDiasParaCambioEstado() {
        return Double.valueOf(Math.floor(getTiempoParaCambioEstado() / APPConstants.MILISEGUNDOS_DIA)).intValue();
    }
    
    /**
     * Retorna la cantidad de dias para que el cliente cambie de estado.
     * @return int
     */
    public Long getTiempoParaCambioEstado() {

    	Long plazo = getPlazoParaPase();
        Long fechaCliente = fechaCreacion.getTime();

        Long fechaCaducidad = fechaCliente + plazo;
        Long fechaActual = System.currentTimeMillis();

        return fechaCaducidad - fechaActual;
    }
    
    /**
     * Retorna el estado actual del cliente.
     * @return Estado
     */
    public Long getPlazoParaPase() {
        Long plazo = 0L;
        if (DDEstadoItinerario.ESTADO_GESTION_VENCIDOS.equals(codigoItinerario)) {
        	if (Checks.esNulo(plazoCarencia)
        		|| Checks.esNulo(plazoVencidos))
        		return 0L;
        		
            plazo = plazoCarencia.longValue() + plazoVencidos.longValue();
        } 
        else if (DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA.equals(codigoItinerario)) {
        	if (Checks.esNulo(plazoCarencia))
        		return 0L;
        	
            plazo = plazoCarencia.longValue();
        }
        
        return plazo;
    }

	/**
	 * @return the apellidos
	 */
	public String getApellidos() {
		return apellidos;
	}

	/**
	 * @param apellidos the apellidos to set
	 */
	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}
}

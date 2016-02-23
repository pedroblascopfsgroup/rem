package es.capgemini.pfs.contrato.dto;

import java.util.Iterator;
import java.util.Set;
import java.util.StringTokenizer;

import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase que contiene los par�metros utilizados para realizar una b�squeda de contratos.
 */
public class BusquedaContratosDto extends PaginationParamsImpl {

    /**
     *
     */
    private static final long serialVersionUID = -2045964783136267736L;

    private Long id;

    private String nroContrato;
    
    private String codRecibo;
    
    private String codEfecto;
    
    private String codDisposicion;

    private String descripcion;

    private String nombre;

    private String apellido1;

    private String apellido2;

    private String documento;

    private String stringEstadosContrato;

    private Set<String> estadosContrato;

    private Set<String> estadosFinancieros;

    private String descripcionExpediente;

    private String nombreAsunto;

    private String maxVolTotalRiesgo;

    private String minVolTotalRiesgo;

    private String maxVolRiesgoVencido;

    private String minVolRiesgoVencido;

    private String minDiasVencidos;

    private String maxDiasVencidos;

    private Set<String> codigosZona;

    private String codigoZona;

    private String jerarquia;
    
    private String codigoZonaAdm;
    
    private Set<String> codigosZonaAdm;
    
    private String jerarquiaAdm;

    private String busquedaOrInclusion;

    private Boolean tieneRiesgo;

    private String tiposProducto;

    private String tiposProductoEntidad;
    
    private String motivoGestionHRE;

    /**
     * @return boolean: <code>true</code> si alguno de los siguientes campos existe:
     * <li>nombre</li>
     * <li>apellido1</li>
     * <li>apellido2</li>
     * <li>documento</li>
     * <li>descripcionExpediente</li>
     * <li>descripcionCliente</li>
     */
    public boolean existenCamposNombresCargados() {
        return ((getNombre() != null && getNombre().trim().length() > 0)
                || (getApellido1() != null && getApellido1().trim().length() > 0)
                || (getApellido2() != null && getApellido2().trim().length() > 0)
                || (getDocumento() != null && getDocumento().trim().length() > 0) || (getDescripcionExpediente() != null && getDescripcionExpediente()
                .trim().length() > 0));
    }

    /**
     * @return boolean: <code>true</code> si alguno de los siguientes campos existe:
     * <li>minVolRiesgoVencido</li>
     * <li>maxVolRiesgoVencido</li>
     * <li>minVolTotalRiesgo</li>
     * <li>maxVolTotalRiesgo</li>
     * <li>minDiasVencidos</li>
     * <li>maxDiasVencidos</li>
     * <li>tieneRiesgo</li>
     */
    public boolean existenCamposMinMaxCargados() {
        return ( !Checks.esNulo(getMaxVolRiesgoVencido())  || !Checks.esNulo(getMinVolRiesgoVencido()) || !Checks.esNulo(getMaxVolTotalRiesgo()) 
                || !Checks.esNulo(getMinVolTotalRiesgo()) || !Checks.esNulo(getMaxDiasVencidos()) || !Checks.esNulo(getMinDiasVencidos()) || !Checks.esNulo(getTieneRiesgo()));
    }

    /**
     * @return boolean: <code>true</code> si la b�squeda es para una inclusi�n de contratos
     */
    public boolean isInclusion() {
        return (getBusquedaOrInclusion() != null && getBusquedaOrInclusion().equals("inclusion"));
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the nroContrato
     */
    public String getNroContrato() {
        return nroContrato;
    }

    /**
     * @param nroContrato the nroContrato to set
     */
    public void setNroContrato(String nroContrato) {
        this.nroContrato = nroContrato;
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
     * @return the apellido
     */
    public String getApellido1() {
        return apellido1;
    }

    /**
     * @param apellido1 the apellido to set.
     */
    public void setApellido1(String apellido1) {
        this.apellido1 = apellido1;
    }

    /**
     * @return the apellido
     */
    public String getApellido2() {
        return apellido2;
    }

    /**
     * @param apellido2 the apellido to set.
     */
    public void setApellido2(String apellido2) {
        this.apellido2 = apellido2;
    }

    /**
     * @return the documento
     */
    public String getDocumento() {
        return documento;
    }

    /**
     * @param documento the documento to set
     */
    public void setDocumento(String documento) {
        this.documento = documento;
    }

    /**
     * @return the estadosContrato
     */
    public Set<String> getEstadosContrato() {
        if (estadosContrato != null && estadosContrato.size() > 0) {
            Iterator<String> it = estadosContrato.iterator();
            if (it.next().trim().length() > 0) { return estadosContrato; }
        }
        return null;
    }

    /**
     * @param estadosContrato the estadosContrato to set
     */
    public void setEstadosContrato(Set<String> estadosContrato) {
        this.estadosContrato = estadosContrato;
    }

    /**
     * @return the estadosFinancieros
     */
    public Set<String> getEstadosFinancieros() {
        if (estadosFinancieros != null && estadosFinancieros.size() > 0) {
            Iterator<String> it = estadosFinancieros.iterator();
            if (it.next().trim().length() > 0) { return estadosFinancieros; }
        }
        return null;

    }

    /**
     * @param estadosFinancieros the estadosFinancieros to set
     */
    public void setEstadosFinancieros(Set<String> estadosFinancieros) {
        this.estadosFinancieros = estadosFinancieros;
    }

    /**
     * @return the descripcionExpediente
     */
    public String getDescripcionExpediente() {
        return descripcionExpediente;
    }

    /**
     * @param descripcionExpediente the descripcionExpediente to set
     */
    public void setDescripcionExpediente(String descripcionExpediente) {
        this.descripcionExpediente = descripcionExpediente;
    }

    /**
     * @return the nombreAsunto
     */
    public String getNombreAsunto() {
        return nombreAsunto;
    }

    /**
     * @param nombreAsunto the nombreAsunto to set
     */
    public void setNombreAsunto(String nombreAsunto) {
        this.nombreAsunto = nombreAsunto;
    }

    /**
     * @return the maxVolTotalRiesgo
     */
    public String getMaxVolTotalRiesgo() {
        return maxVolTotalRiesgo;
    }

    /**
     * @param maxVolTotalRiesgo the maxVolTotalRiesgo to set
     */
    public void setMaxVolTotalRiesgo(String maxVolTotalRiesgo) {
        this.maxVolTotalRiesgo = maxVolTotalRiesgo;
    }

    /**
     * @return the minVolTotalRiesgo
     */
    public String getMinVolTotalRiesgo() {
        return minVolTotalRiesgo;
    }

    /**
     * @param minVolTotalRiesgo the minVolTotalRiesgo to set
     */
    public void setMinVolTotalRiesgo(String minVolTotalRiesgo) {
        this.minVolTotalRiesgo = minVolTotalRiesgo;
    }

    /**
     * @return the maxVolRiesgoVencido
     */
    public String getMaxVolRiesgoVencido() {
        return maxVolRiesgoVencido;
    }

    /**
     * @param maxVolRiesgoVencido the maxVolRiesgoVencido to set
     */
    public void setMaxVolRiesgoVencido(String maxVolRiesgoVencido) {
        this.maxVolRiesgoVencido = maxVolRiesgoVencido;
    }

    /**
     * @return the minVolRiesgoVencido
     */
    public String getMinVolRiesgoVencido() {
        return minVolRiesgoVencido;
    }

    /**
     * @param minVolRiesgoVencido the minVolRiesgoVencido to set
     */
    public void setMinVolRiesgoVencido(String minVolRiesgoVencido) {
        this.minVolRiesgoVencido = minVolRiesgoVencido;
    }

    /**
     * @return the minDiasVencidos
     */
    public String getMinDiasVencidos() {
        return minDiasVencidos;
    }

    /**
     * @param minDiasVencidos the minDiasVencidos to set
     */
    public void setMinDiasVencidos(String minDiasVencidos) {
        this.minDiasVencidos = minDiasVencidos;
    }

    /**
     * @return the maxDiasVencidos
     */
    public String getMaxDiasVencidos() {
        return maxDiasVencidos;
    }

    /**
     * @param maxDiasVencidos the maxDiasVencidos to set
     */
    public void setMaxDiasVencidos(String maxDiasVencidos) {
        this.maxDiasVencidos = maxDiasVencidos;
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
     * @return the codigosZona
     */
    public Set<String> getCodigosZona() {
        return codigosZona;
    }

    /**
     * @param codigosZona the codigosZona to set
     */
    public void setCodigosZona(Set<String> codigosZona) {
        this.codigosZona = codigosZona;
    }

    /**
     * @return the jerarquia
     */
    public String getJerarquia() {
        return jerarquia;
    }

    /**
     * @param jerarquia the jerarquia to set
     */
    public void setJerarquia(String jerarquia) {
        this.jerarquia = jerarquia;
    }

    /**
     * @return the busquedaOrInclusion
     */
    public String getBusquedaOrInclusion() {
        return busquedaOrInclusion;
    }

    /**
     * @param busquedaOrInclusion the busquedaOrInclusion to set
     */
    public void setBusquedaOrInclusion(String busquedaOrInclusion) {
        this.busquedaOrInclusion = busquedaOrInclusion;
    }

    /**
     * @return the tieneRiesgo
     */
    public Boolean getTieneRiesgo() {
        return tieneRiesgo;
    }

    /**
     * @param tieneRiesgo the tieneRiesgo to set
     */
    public void setTieneRiesgo(Boolean tieneRiesgo) {
        this.tieneRiesgo = tieneRiesgo;
    }

    /**
     * @return String: los tipos de productos separados por coma, pero entrecomillados cada elemento
     */
    public String getTiposProducto() {
        if (tiposProducto != null && !tiposProducto.equals("") && tiposProducto.lastIndexOf("'") == -1) {
            String list = "";
            StringTokenizer tokensTipos = new StringTokenizer(tiposProducto, ",");
            while (tokensTipos.hasMoreTokens()) {
                if (!list.equals("")) {
                    list += ",";
                }
                list += "'" + tokensTipos.nextElement() + "'";
            }
            tiposProducto = list;
        }
        return tiposProducto;
    }

    /**
     * @param tiposProducto the tiposProducto to set
     */
    public void setTiposProducto(String tiposProducto) {
        this.tiposProducto = tiposProducto;
    }

    /**
     * @return String: los tipos de productos entidad separados por coma, pero entrecomillados cada elemento
     */
    public String getTiposProductoEntidad() {
        if (tiposProductoEntidad != null && !tiposProductoEntidad.equals("") && tiposProductoEntidad.lastIndexOf("'") == -1) {
            String list = "";
            StringTokenizer tokensTipos = new StringTokenizer(tiposProductoEntidad, ",");
            while (tokensTipos.hasMoreTokens()) {
                if (!list.equals("")) {
                    list += ",";
                }
                list += "'" + tokensTipos.nextElement() + "'";
            }
            tiposProductoEntidad = list;
        }
        return tiposProductoEntidad;
    }

    /**
     * @param tiposProductoEntidad the tiposProductoEntidad to set
     */
    public void setTiposProductoEntidad(String tiposProductoEntidad) {
        this.tiposProductoEntidad = tiposProductoEntidad;
    }

    /**
     * @param codigoZona the codigoZona to set
     */
    public void setCodigoZona(String codigoZona) {
        this.codigoZona = codigoZona;
    }

    /**
     * @return the codigoZona
     */
    public String getCodigoZona() {
        return codigoZona;
    }

    /**
     * @param stringEstadosContrato the stringEstadosContrato to set
     */
    public void setStringEstadosContrato(String stringEstadosContrato) {
        this.stringEstadosContrato = stringEstadosContrato;
    }

    /**
     * @return the stringEstadosContrato
     */
    public String getStringEstadosContrato() {
        return stringEstadosContrato;
    }

	public String getCodRecibo() {
		return codRecibo;
	}

	public void setCodRecibo(String codRecibo) {
		this.codRecibo = codRecibo;
	}

	public String getCodEfecto() {
		return codEfecto;
	}

	public void setCodEfecto(String codEfecto) {
		this.codEfecto = codEfecto;
	}

	public String getCodDisposicion() {
		return codDisposicion;
	}

	public void setCodDisposicion(String codDisposicion) {
		this.codDisposicion = codDisposicion;
	}


	public String getJerarquiaAdm() {
		return jerarquiaAdm;
	}

	public void setJerarquiaAdm(String jerarquiaAdm) {
		this.jerarquiaAdm = jerarquiaAdm;
	}

	public String getCodigoZonaAdm() {
		return codigoZonaAdm;
	}

	public void setCodigoZonaAdm(String codigoZonaAdm) {
		this.codigoZonaAdm = codigoZonaAdm;
	}

	public Set<String> getCodigosZonaAdm() {
		return codigosZonaAdm;
	}

	public void setCodigosZonaAdm(Set<String> codigosZonaAdm) {
		this.codigosZonaAdm = codigosZonaAdm;
	}
	
	public String getMotivoGestionHRE() {
		return motivoGestionHRE;
	}
	
	public void setMotivoGestionHRE(String motivoGestionHRE) {
		this.motivoGestionHRE = motivoGestionHRE;
	}
}

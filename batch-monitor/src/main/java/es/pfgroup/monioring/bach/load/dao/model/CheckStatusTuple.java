package es.pfgroup.monioring.bach.load.dao.model;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Registro de la tabla de estado del batch.
 * 
 * @author bruno
 * 
 */
public class CheckStatusTuple {
    
    
    public static final String CODIGO_ESTADO_RUNNING = "STARTED";
    public static final String CODIGO_ESTADO_COMPLETED = "COMPLETED";
    
    public static final String CODIGO_SALIDA_COMPLETED = "COMPLETED";
    public static final String CODIGO_SALIDA_FAILED = "FAILED";
    public static final String CODIGO_SALIDA_NOOP = "NOOP";

    public static final String COLUMN_ENTIDAD = "ENTIDAD";
    public static final String COLUMN_NOMBRE_JOB = "NOMBRE_JOB";
    public static final String COLUMN_INICIO = "COMIENZA";
    public static final String COLUMN_FIN = "FINALIZA";
    public static final String COLUMN_CODIGO_ESTADO = "ESTADO";
    public static final String COLUMN_CODIGO_SALIDA = "CODIGO_SALIDA";
    
    public static final String PASAJE_PRODUCCION_MARK = "PasajeProduccionJob";
	
   
    

    
    

    /**
     * Crea un objeto de modelo a partir de un ResultSet de base de datos.
     * 
     * @param resultSet
     * @return
     * @throws SQLException
     */
    public static CheckStatusTuple createFromResultSet(ResultSet resultSet) throws SQLException {
        Date myFin = resultSet.getDate(COLUMN_FIN);
        String myNombreJob = resultSet.getString(COLUMN_NOMBRE_JOB);
        String myCodigoEstado = resultSet.getString(COLUMN_CODIGO_ESTADO);
        String myCodigoSalida = resultSet.getString(COLUMN_CODIGO_SALIDA);
        Integer myEntidad = resultSet.getInt(COLUMN_ENTIDAD);
        Date myInicio = resultSet.getDate(COLUMN_INICIO);
        return new CheckStatusTuple(myEntidad, myNombreJob, myInicio, myFin, myCodigoEstado, myCodigoSalida);
    }

    private final Integer entidad;
    private final String nombreJob;
    private final Date inicio;
    private final Date fin;
    private final String codigoEstado;
    private final String codigoSalida;

    public Integer getEntidad() {
        return this.entidad;
    }

    public String getNombreJob() {
        return this.nombreJob;
    }

    public Date getInicio() {
        return this.inicio;
    }

    public Date getFin() {
        return this.fin;
    }

    /**
     * @return the codigoEstado
     */
    public String getCodigoEstado() {
        return codigoEstado;
    }

    public String getCodigoSalida() {
        return this.codigoSalida;
    }

    private CheckStatusTuple(final Integer entidad, final String nombreJob, final Date inicio, final Date fin, final String codigoEstado, final String codigoSalida) {
        super();
        this.entidad = entidad;
        this.nombreJob = nombreJob;
        this.inicio = inicio;
        this.fin = fin;
        this.codigoEstado = codigoEstado;
        this.codigoSalida = codigoSalida;
    }

}

package es.pfgroup.monioring.bach.test.load.dao.model.CheckStatusTuple;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.pfgroup.monioring.bach.load.dao.model.CheckStatusTuple;

/**
 * Testing del método factoría que crea un objeto del modelo a partir de un ResultSet.
 * @author bruno
 *
 */
public class CreateFromResultSetTest {
    
    private Integer entidad;
    private String nombreJob;
    private Date fechaHoraInicio;
    private Date fechaHoraFin;
    private String codigoSalida;
    private String estado;
    
    @Before
    public void before(){
        Random random = new Random();
        entidad = random.nextInt();
        nombreJob = RandomStringUtils.random(100);
        fechaHoraInicio = new Date(random.nextLong());
        fechaHoraFin = new Date(random.nextLong());
        codigoSalida = RandomStringUtils.random(10);
        estado = RandomStringUtils.random(10);
    }
    
    @After
    public void after(){
        entidad = null;
        nombreJob = null;
        fechaHoraInicio = null;
        fechaHoraFin = null;
        codigoSalida = null;
        estado = null;
    }

    @Test
    public void testCreateObject(){
        
        ResultSet resultset = mock(ResultSet.class);
     
        try {
            when(resultset.getInt(CheckStatusTuple.COLUMN_ENTIDAD)).thenReturn(entidad);
            when(resultset.getString(CheckStatusTuple.COLUMN_NOMBRE_JOB)).thenReturn(nombreJob);
            when(resultset.getDate(CheckStatusTuple.COLUMN_INICIO)).thenReturn(fechaHoraInicio);
            when(resultset.getDate(CheckStatusTuple.COLUMN_FIN)).thenReturn(fechaHoraFin);
            when(resultset.getString(CheckStatusTuple.COLUMN_CODIGO_SALIDA)).thenReturn(codigoSalida);
            when(resultset.getString(CheckStatusTuple.COLUMN_CODIGO_ESTADO)).thenReturn(estado);
            
            CheckStatusTuple object = CheckStatusTuple.createFromResultSet(resultset);
            
            assertEquals(entidad, object.getEntidad());
            assertEquals(nombreJob, object.getNombreJob());
            assertEquals(fechaHoraInicio, object.getInicio());
            assertEquals(fechaHoraFin, object.getFin());
            assertEquals(codigoSalida, object.getCodigoSalida());
            assertEquals(estado, object.getCodigoEstado());
        } catch (SQLException e) {
            // No se va a producir, es un mock
        }
        
        
    }

}

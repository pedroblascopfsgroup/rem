package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.Trabajo;


@Component
public class MSVActualizaTrabajosCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int NUM_TRABAJO = 0;
	private static final int CODIGO_PROVEEDOR = 1;
	private static final int USUARIO_CONTACTO = 2;
	private static final int RESPONSABLE_TRABAJO = 3;
	private static final int GESTOR_ACTIVO = 4;
	private static final int SUPERVISOR_ACTIVO = 5;
	
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_TRABAJOS;
	}
	@Autowired
	private TrabajoApi trabajoApi;
	

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		Trabajo trabajo = trabajoApi.getTrabajoByNumeroTrabajo(Long.parseLong(exc.dameCelda(fila, NUM_TRABAJO)));
		
		Usuario usuarioResponsable = getUsuarioByUsername(exc.dameCelda(fila, RESPONSABLE_TRABAJO));
		
		Usuario gestorActivo = getUsuarioByUsername(exc.dameCelda(fila, GESTOR_ACTIVO));
		
		Usuario supervisorActivo = getUsuarioByUsername(exc.dameCelda(fila, SUPERVISOR_ACTIVO));
		
		Usuario usuarioContacto = getUsuarioByUsername(exc.dameCelda(fila, USUARIO_CONTACTO));
		
		String codProveedor = exc.dameCelda(fila, CODIGO_PROVEEDOR);
		
		
		if (usuarioResponsable != null )
		    trabajo.setUsuarioResponsableTrabajo(usuarioResponsable);
		if (gestorActivo != null)
		    trabajo.setUsuarioGestorActivoResponsable(gestorActivo);
		if (supervisorActivo != null)
		    trabajo.setSupervisorActivoResponsable(supervisorActivo);
		if (usuarioResponsable != null && codProveedor.length() > 0) {
		    ActivoProveedorContacto activoProveedorContacto = getProveedorByCodigoAndUser(codProveedor, trabajo, usuarioContacto);
		    trabajo.setProveedorContacto(activoProveedorContacto);
		}
		
		genericDao.save(Trabajo.class, trabajo);
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

	private Usuario getUsuarioByUsername(String userName) {
	    if ( userName == null || userName.length() == 0) {
	        return null;
	    }else {
	        return genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", userName));
	    }
	}
	private ActivoProveedorContacto getProveedorByCodigoAndUser(String codProveedor, Trabajo trabajo, Usuario usuario) {
	    ActivoProveedorContacto resp = null;
        if (codProveedor != null && codProveedor.length() >0
	        && trabajo.getProveedorContacto() != null 
	        && trabajo.getProveedorContacto().getId() != null
	        && usuario != null){
            Filter f1  = genericDao.createFilter(FilterType.EQUALS, "id", trabajo.getProveedorContacto().getId());
            Filter f2 =  genericDao.createFilter(FilterType.EQUALS, "usuario", usuario);
            resp = genericDao.get(ActivoProveedorContacto.class, f1, f2); 
        }
	       
	    return resp;
	}
}

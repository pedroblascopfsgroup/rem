package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Arrays;
import java.util.Date;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionDao;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionHistoricoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;

@Component
public class MSVActualizadorOcultarActivosVenta extends AbstractMSVActualizador implements MSVLiberator{
	
	@Resource
	private MessageService messageServices;
	
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	ActivoApi activoApi;
	
	@Autowired 
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoPublicacionDao activoPublicacionDao;
	
	@Autowired
	private ActivoPublicacionHistoricoDao activoPublicacionHistoricoDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_OCULTACION_VENTA;
	}
	
	// Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int FILA_CABECERA = 2;
		static final int DATOS_PRIMERA_FILA = 3;
		
		static final int NUM_ACTIVO_HAYA = 0;
		static final int MOTIVO_OCULTACION = 1;
		static final int DESCRIPCION_MOTIVO = 2;
	}
	
	/**
	 * Este método coge los datos de publicación actuales del activo y los copia en el histórico.
	 * Añade la fecha de fin para el tipo de comercialización en la cual se encuentre el activo.
	 *
	 * @param activoPublicacion: registro de publicación actual del activo.
	 * @return Devuelve True si el proceso ha sido satisfactorio, False si no lo ha sido.
	 */
	private Boolean registrarHistoricoPublicacion(ActivoPublicacion activoPublicacion) {
		ActivoPublicacionHistorico activoPublicacionHistorico = new ActivoPublicacionHistorico();

		try {
			beanUtilNotNull.copyProperties(activoPublicacionHistorico, activoPublicacion);
			if(Arrays.asList(DDTipoComercializacion.CODIGOS_VENTA).contains(activoPublicacion.getTipoComercializacion().getCodigo())) {
				activoPublicacionHistorico.setFechaFinVenta(new Date());
			} else if(Arrays.asList(DDTipoComercializacion.CODIGOS_ALQUILER).contains(activoPublicacion.getTipoComercializacion().getCodigo())) {
				activoPublicacionHistorico.setFechaFinAlquiler(new Date());
			}
		} catch (IllegalAccessException e) {
			logger.error("Error al registrar en el historico el estado actual de publicacion, error: ", e);
			return false;
		} catch (InvocationTargetException e) {
			logger.error("Error al registrar en el historico el estado actual de publicacion, error: ", e);
			return false;
		}
		activoPublicacionHistoricoDao.save(activoPublicacionHistorico);

		return true;
	}
	
	private Boolean publicarActivoProcedure(Long idActivo, String username) throws JsonViewerException{
		if(activoDao.publicarActivoSinHistorico(idActivo, username)) {
			logger.info(messageServices.getMessage("activo.publicacion.OK.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
			return true;
		} else {
			logger.error(messageServices.getMessage("activo.publicacion.error.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
			throw new JsonViewerException(messageServices.getMessage("activo.publicacion.error.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
		}
	}

	@Override
	@Transactional(readOnly = false)
	public void procesaFila(MSVHojaExcel exc, int fila) throws IOException, ParseException, JsonViewerException, SQLException {
		Long numActivo = Long.parseLong(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_HAYA),10);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
		Activo act = genericDao.get(Activo.class, filtro);
		
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(act.getId());
		if(this.registrarHistoricoPublicacion(activoPublicacion)) {
			activoPublicacion.setCheckOcultarVenta(true);
			activoPublicacionDao.save(activoPublicacion);
			this.publicarActivoProcedure(activoPublicacion.getActivo().getId(), genericAdapter.getUsuarioLogado().getNombre());
		}
	}	
}

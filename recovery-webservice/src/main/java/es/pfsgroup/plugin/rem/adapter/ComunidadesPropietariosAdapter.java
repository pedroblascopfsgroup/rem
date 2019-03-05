package es.pfsgroup.plugin.rem.adapter;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberatorsFactory;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.*;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaAceptacionYRechazo;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoComunidadPropietarios;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionActivo;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidatorFactoryApi;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Service
public class ComunidadesPropietariosAdapter {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private MSVFicheroDao ficheroDao;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private ActivoManager activoManager;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;

	@Autowired
	protected JBPMProcessManagerApi jbpmProcessManagerApi;

	@Autowired
	protected TipoProcedimientoManager tipoProcedimiento;

	@Autowired
	private ProveedoresApi proveedoresApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private List<AgrupacionAvisadorApi> avisadores;

	@Autowired
	private MSVLiberatorsFactory factoriaLiberators;

	@Autowired
	private AgrupacionValidatorFactoryApi agrupacionValidatorFactory;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private NotificationOfertaManager notificationOfertaManager;

	@Resource
	private MessageService messageServices;

	@Autowired
	private NotificatorServiceSancionOfertaAceptacionYRechazo notificatorServiceSancionOfertaAceptacionYRechazo;

	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ProcessAdapter processAdapter;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;

	private final Log logger = LogFactory.getLog(getClass());


	@Transactional(readOnly = false)
	public void updateComunidad(Long idActivo, String idComunidadPropietarios,  String situacion, String fechaEnvioCarta)
			throws JsonViewerException {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", idActivo);
		Activo activo = genericDao.get(Activo.class, filter);
		ActivoComunidadPropietarios  activoComunidadPropietarios = new ActivoComunidadPropietarios();

		try {
			if (Checks.esNulo(activo)) {
				throw new JsonViewerException("El activo no existe");
			}
			
			DDSituacionActivo ddSituacionActivo = genericDao.get(DDSituacionActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", situacion));
			
			if (!Checks.esNulo(ddSituacionActivo)  ) {
				
				 activoComunidadPropietarios = genericDao.get(ActivoComunidadPropietarios.class, genericDao.createFilter(FilterType.EQUALS,"id",activo.getComunidadPropietarios().getId()),
						genericDao.createFilter(FilterType.EQUALS,"codigoComPropUvem", idComunidadPropietarios));
			} 
			
			if (!Checks.esNulo(activoComunidadPropietarios)) 
			{
				activoComunidadPropietarios.setSituacion(ddSituacionActivo);
			    Date date1=new SimpleDateFormat("dd/MM/yyyy").parse(fechaEnvioCarta);  

				activoComunidadPropietarios.setFechaEnvioCarta(date1);
			}

			genericDao.save(ActivoComunidadPropietarios.class, activoComunidadPropietarios);

		} catch (JsonViewerException jve) {
			throw jve;
		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		}
	}
}
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
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
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
public class ImpuestosAdapter {

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
	private static final String valorSi= "1";
	private static final String valorNo= "0";
	

	@Transactional(readOnly = false)
	public void updateImpuesto(Long idActivo,String catastro,String fechaSolicitud901,String valorContruccion, String valorSuelo, String resultado,String observaciones) throws JsonViewerException {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", idActivo);
		Activo activo = genericDao.get(Activo.class, filter);
		List<ActivoCatastro>  lista;
		Date date1 = null;
		try {
			if (Checks.esNulo(activo)) {
				throw new JsonViewerException("El activo no existe");
			}
			
			lista = genericDao.getList(ActivoCatastro.class, genericDao.createFilter(FilterType.EQUALS,"activo",activo),genericDao.createFilter(FilterType.EQUALS,"refCatastral",catastro));
			
			
			if (!Checks.estaVacio(lista)) {

				if (!Checks.esNulo(fechaSolicitud901)) {
					date1 = new SimpleDateFormat("dd/MM/yyyy").parse(fechaSolicitud901);  	
				}
			    
			    Double valConstruccion = !Checks.esNulo(valorContruccion)
							? Double.parseDouble(valorContruccion) : null;
				Double valSuelo = !Checks.esNulo(valorSuelo)
							? Double.parseDouble(valorSuelo) : null;
							
			    for (ActivoCatastro actCat : lista) {
			    	if (!Checks.esNulo(date1)) {
			    		actCat.setFechaSolicitud901(date1);		
			    	}					
					actCat.setValorCatastralConst(valConstruccion);
					actCat.setValorCatastralSuelo(valSuelo);
					actCat.setObservaciones(observaciones);
					if (resultado.contains("S") ||resultado.contains("s")  )
						actCat.setResultado(valorSi);
					else
						actCat.setResultado(valorNo);
					genericDao.save(ActivoCatastro.class, actCat);
			    }
			}

		} catch (JsonViewerException jve) {
			throw jve;
		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		}
	}
}
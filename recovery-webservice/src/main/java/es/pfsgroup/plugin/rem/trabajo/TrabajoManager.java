package es.pfsgroup.plugin.rem.trabajo;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.impl.MSVProcesoManager;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.activotrabajo.dao.ActivoTrabajoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.gestor.GestorActivoManager;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo.ActivoTrabajoPk;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.AdjuntoTrabajo;
import es.pfsgroup.plugin.rem.model.ConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.DtoActivoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoGestionEconomicaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoPresupuestoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoPresupuestosTrabajo;
import es.pfsgroup.plugin.rem.model.DtoProvisionSuplido;
import es.pfsgroup.plugin.rem.model.DtoRecargoProveedor;
import es.pfsgroup.plugin.rem.model.DtoTarifaTrabajo;
import es.pfsgroup.plugin.rem.model.PresupuestoTrabajo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.TrabajoConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.TrabajoFoto;
import es.pfsgroup.plugin.rem.model.TrabajoObservacion;
import es.pfsgroup.plugin.rem.model.TrabajoProvisionSuplido;
import es.pfsgroup.plugin.rem.model.TrabajoRecargosProveedor;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacionTrabajo;
import es.pfsgroup.plugin.rem.model.VProveedores;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresupuesto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdelanto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.tareasactivo.TareaActivoManager;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;


@Service("trabajoManager")
public class TrabajoManager extends BusinessOperationOverrider<TrabajoApi> implements TrabajoApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	SimpleDateFormat groovyft = new SimpleDateFormat("yyyy-MM-dd");
	
	protected static final Log logger = LogFactory.getLog(TrabajoManager.class);
	
	public final String PESTANA_FICHA = "ficha";
	public final String PESTANA_GESTION_ECONOMICA = "gestionEconomica";

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoAgrupacionDao activoAgrupacionDao;
	
	@Autowired
	private TrabajoDao trabajoDao;
	
	@Autowired
	private ActivoTrabajoDao activoTrabajoDao;
	
	@Autowired
	private ActivoTramiteDao activoTramiteDao;

	@Autowired
	private GestorActivoManager gestorActivoManager;
	
    @Autowired
    protected JBPMActivoTramiteManager jbpmActivoTramiteManager;
	
    @Autowired
    protected TipoProcedimientoManager tipoProcedimientoManager;

    @Autowired
    protected TareaActivoManager tareaActivoManager;
    
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private MSVProcesoManager procesoManager;
		
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
    private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	public String managerName() {
		return "trabajoManager";
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.findAll")
	public Page findAll(DtoTrabajoFilter dto, Usuario usuarioLogado) {
		
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if(!Checks.esNulo(usuarioCartera))
			dto.setCartera(usuarioCartera.getCartera().getCodigo());
		
		return trabajoDao.findAll(dto, usuarioLogado);
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.getTrabajoById")
	public Object getTrabajoById(Long id, String pestana) {
		
		Trabajo trabajo = findOne(id);		
		Object dto = null;

		try {
			
			if(PESTANA_FICHA.equals(pestana)){
				dto = trabajoToDtoFichaTrabajo(trabajo);
			}
			else if (PESTANA_GESTION_ECONOMICA.equals(pestana))
			{
				//Dto de gestión económica
				dto = trabajoToDtoGestionEconomicaTrabajo(trabajo);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}	

	@Override
	@BusinessOperation(overrides = "trabajoManager.getTrabajoByTareaExterna")
	public Trabajo getTrabajoByTareaExterna(TareaExterna tarea){
		TareaActivo tareaActivo = tareaActivoManager.getByIdTareaExterna(tarea.getId());
		return tareaActivo.getTramite().getTrabajo();
	}

	
	@Override
	@BusinessOperation(overrides = "trabajoManager.findOne")
	public Trabajo findOne(Long id) {
		
		return trabajoDao.get(id);		

	}	

	
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.saveFichaTrabajo")
	@Transactional
	public boolean saveFichaTrabajo(DtoFichaTrabajo dtoTrabajo, Long id) {

		Trabajo trabajo = trabajoDao.get(id);	
		
		try {

			//Si estado trabajo = EMITIDO PENDIENTE PAGO y se ha rellenado "fecha pago", estado trabajo = PAGADO
			//Este cambio de estado se produce en la tarea "Cierre Económico" de los trámites pero es necesario
			// controlar también si la fecha pago se informa y no hay que cerrar ningún trámite
			if (!Checks.esNulo(trabajo.getFechaPago())
					&& trabajo.getEstado().getCodigo().equals(DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO)){
				dtoTrabajo.setEstadoCodigo(DDEstadoTrabajo.ESTADO_PAGADO);
			}
			
			dtoToTrabajo(dtoTrabajo, trabajo);
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		trabajoDao.saveOrUpdate(trabajo);

		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.saveGestionEconomicaTrabajo")
	@Transactional
	public boolean saveGestionEconomicaTrabajo(DtoGestionEconomicaTrabajo dtoGestionEconomica, Long id) {

		Trabajo trabajo = trabajoDao.get(id);	
		
		try {
			
			dtoGestionEconomicaToTrabajo(dtoGestionEconomica, trabajo);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		actualizarImporteTotalTrabajo(trabajo.getId());
		trabajoDao.saveOrUpdate(trabajo);

		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.actualizarImporteTotalTrabajo")
	@Transactional
	public Trabajo actualizarImporteTotalTrabajo(Long idTrabajo) {

		Double importeA = new Double("0.0");
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", idTrabajo);
		
		Trabajo trabajo = findOne(idTrabajo);
		
		if (!Checks.esNulo(trabajo.getEsTarificado()) && trabajo.getEsTarificado())
		{
			List<TrabajoConfiguracionTarifa> cfgTarifas = (List<TrabajoConfiguracionTarifa>) genericDao.getList(TrabajoConfiguracionTarifa.class, filtro);
	
			for(TrabajoConfiguracionTarifa tarifa: cfgTarifas) {
				
				if(!tarifa.getAuditoria().isBorrado() && !Checks.esNulo(tarifa.getPrecioUnitario()) && !Checks.esNulo(tarifa.getMedicion())){
					importeA += tarifa.getPrecioUnitario() * tarifa.getMedicion();
				}
			}
		}
		else if (!Checks.esNulo(trabajo.getEsTarificado()) && !trabajo.getEsTarificado())
		{
			List<PresupuestoTrabajo> presupuestos = (List<PresupuestoTrabajo>) genericDao.getList(PresupuestoTrabajo.class, filtro);

			for(PresupuestoTrabajo presupuesto: presupuestos) {		
				if(!presupuesto.getAuditoria().isBorrado() && !Checks.esNulo(presupuesto.getImporte()) && presupuesto.getEstadoPresupuesto()!=null && "02".equalsIgnoreCase(presupuesto.getEstadoPresupuesto().getCodigo())){
					importeA += presupuesto.getImporte();
				}
			}
		}
		
		Double importeB = trabajo.getImportePenalizacionTotal();			
		
		Double importeC = new Double("0.0");
		if(!Checks.estaVacio(trabajo.getRecargosProveedor())) {
			
			for(TrabajoRecargosProveedor recargo: trabajo.getRecargosProveedor()) {	
				
				if(!recargo.getAuditoria().isBorrado()) {
					if(DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(recargo.getTipoCalculo().getCodigo())) {	
						if(!Checks.esNulo(recargo.getImporteCalculo())) {
							recargo.setImporteFinal(importeA * recargo.getImporteCalculo() / 100);	
						}
					} else if (DDTipoCalculo.TIPO_CALCULO_IMPORTE_FIJO.equals(recargo.getTipoCalculo().getCodigo())) {
						recargo.setImporteFinal(recargo.getImporteCalculo());
					}
					
					genericDao.save(TrabajoRecargosProveedor.class, recargo);
									
					if(!Checks.esNulo(recargo.getImporteFinal())){
						importeC += recargo.getImporteFinal();
					}
				}
			}
					
		}		
		
		Double importeTotal = importeA - importeB + importeC;
		
		trabajo.setImporteTotal(importeTotal);
		
		genericDao.save(Trabajo.class, trabajo);
		
		return trabajo;

	}
	
	@Override
	@Transactional
	public Long create(DDSubtipoTrabajo subtipoTrabajo, List<Activo> listaActivos) {
		Trabajo trabajo = new Trabajo();

		try {
			trabajo.setFechaSolicitud(new Date());
			trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());
			trabajo.setSolicitante(genericAdapter.getUsuarioLogado());
			
			trabajo.setTipoTrabajo(subtipoTrabajo.getTipoTrabajo());
			trabajo.setSubtipoTrabajo(subtipoTrabajo);		
			
			//Estado trabajo: En tramite y con fecha solicitud
			trabajo.setEstado((DDEstadoTrabajo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoTrabajo.class, DDEstadoTrabajo.ESTADO_EN_TRAMITE));
			trabajo.setFechaSolicitud(new Date());
			
			//TODO: Evaluar correctamente quienes son gestores de activo en trabajos multiactivo
			//
			// Si el trabajo es creado por el tipo de gestor que debe gestionarlo,
			// tendra fecha APROBACION. Se evalua el gestor solo del 1er activo
			//
			//Para modulo precios:
			if(DDTipoTrabajo.CODIGO_PRECIOS.equals(trabajo.getTipoTrabajo().getCodigo())){
				if(gestorActivoManager.isGestorPreciosOMarketing(listaActivos.get(0), genericAdapter.getUsuarioLogado())){
					trabajo.setFechaAprobacion(new Date());
				}
			}

			//TODO: Pendiente de definir como sacar el % de participación.
			String participacion = String.valueOf(100/listaActivos.size());
			
			// Se crea la relacion de activos - trabajos, utilizando la lista de activos de entrada
			for(Activo activo: listaActivos){
				ActivoTrabajo activoTrabajo = createActivoTrabajo(activo, trabajo, participacion);
				trabajo.getActivosTrabajo().add(activoTrabajo);
			}
			
			trabajoDao.saveOrUpdate(trabajo);
			
			
			// Crea el trámite relacionado con el nuevo trabajo generado --------------------
			createTramiteTrabajo(trabajo);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.error("[ERROR] - Crear trabajo multiactivo: ".concat(e.getMessage()));
		}
		
		return trabajo.getId();
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.create")
	@Transactional
	public Long create(DtoFichaTrabajo dtoTrabajo) {
		Trabajo trabajo = new Trabajo();
		
		if(!Checks.esNulo(dtoTrabajo.getIdProceso())){
				//TODO: Llegados a este punto tenemos que crear un trabajo del listado de activos
				trabajo = crearTrabajoPorSubidaActivos(dtoTrabajo);
				createTramiteTrabajo(trabajo);
			}else{
				if(dtoTrabajo.getIdActivo()!=null) {
					Activo activo = activoDao.get(dtoTrabajo.getIdActivo());
					dtoTrabajo.setParticipacion("100");
					trabajo = crearTrabajoPorActivo(activo, dtoTrabajo);
					createTramiteTrabajo(trabajo);
					
				} else if(!dtoTrabajo.getEsSolicitudConjunta()) {
					List<Trabajo> trabajos = crearTrabajoPorActivoAgrupacion(dtoTrabajo);
					
					for(Trabajo trabajoActivoAgrupacion: trabajos) {
						createTramiteTrabajo(trabajoActivoAgrupacion);
					}
					
				} else {
					trabajo = crearTrabajoPorAgrupacion(dtoTrabajo);
					//TODO Tramite del trabajo de una Agrupación
						createTramiteTrabajo(trabajo);
			}
			
		}

		return trabajo.getId();
	}

	private List<Trabajo> crearTrabajoPorActivoAgrupacion(DtoFichaTrabajo dtoTrabajo) {
		List<Trabajo> trabajos = new ArrayList<Trabajo>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "agrId", Long.valueOf(dtoTrabajo.getIdAgrupacion()));
		List<VActivosAgrupacionTrabajo> activos = genericDao.getList(VActivosAgrupacionTrabajo.class, filtro);
		
		for(VActivosAgrupacionTrabajo activoAgrupacion: activos) {			
			Activo activo = activoDao.get(Long.valueOf(activoAgrupacion.getActivoId())); 
			dtoTrabajo.setParticipacion("100");
			Trabajo trabajo = crearTrabajoPorActivo(activo, dtoTrabajo);
			trabajos.add(trabajo);
		}
		
		return trabajos;
		
	}

	private Trabajo crearTrabajoPorAgrupacion(DtoFichaTrabajo dtoTrabajo) {
		
		ActivoAgrupacion  agrupacion = activoAgrupacionDao.get(dtoTrabajo.getIdAgrupacion());
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "agrId", Long.valueOf(dtoTrabajo.getIdAgrupacion()));
		List<VActivosAgrupacionTrabajo> activos = genericDao.getList(VActivosAgrupacionTrabajo.class, filtro);
		
		Trabajo trabajo = new Trabajo();		
		
		try {	
			
			dtoToTrabajo(dtoTrabajo, trabajo);
			
			trabajo.setFechaSolicitud(new Date());
			trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());			
			trabajo.setAgrupacion(agrupacion);
			trabajo.setSolicitante(genericAdapter.getUsuarioLogado());			
			
			Boolean isFirstLoop = true;
			for(VActivosAgrupacionTrabajo activoAgrupacion: activos) {			
				Activo activo = activoDao.get(Long.valueOf(activoAgrupacion.getActivoId())); 
				//En la tabla de activo-agrupación no aparece ningún valor para los importes netos contables
				//Double participacion = (Double) (!(Double.isNaN((activoAgrupacion.getImporteNetoContable()/activoAgrupacion.getSumaAgrupacionNetoContable() * 100))) ? (activoAgrupacion.getImporteNetoContable()/activoAgrupacion.getSumaAgrupacionNetoContable() * 100) : 0.0D);
				dtoTrabajo.setParticipacion(getParticipacion(activoAgrupacion));
				//dtoTrabajo.setParticipacion(Double.toString(activoAgrupacion.getImporteNetoContable()/activoAgrupacion.getSumaAgrupacionNetoContable() * 100));
				
				//FIXME: Datos del trabajo que se definen por un activo, en agrupación de activos están tomándose del primer activo del grupo.
				// Es necesario revisar la forma de definir estos datos del trabajo con "Agrupación activos Conjunta" --> "Trabajo"
				if(isFirstLoop){
					trabajo.setEstado(getEstadoNuevoTrabajo(dtoTrabajo, activo));
					trabajo.setActivo(activo); //En caso de ser un trabajo por agrupación, metemos el primer activo para sacar los datos comunes en el listado
					//El estado del trabajo se define solo por el primer activo del grupo

					// El gestor de activo se salta tareas de estos trámites y por tanto es necesario settear algunos datos
					// al crear el trabajo.
					if (gestorActivoManager.isGestorActivo(activo, genericAdapter.getUsuarioLogado())){
						if(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
								|| DDTipoTrabajo.CODIGO_TASACION.equals(trabajo.getTipoTrabajo().getCodigo())
								|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS.equals(trabajo.getSubtipoTrabajo().getCodigo())){
							trabajo.setFechaAprobacion(new Date());
						}
					}
					
					//El trámite de cédula queda aprobado al crearlo, sea o no sea gestor activo quien lo crea
					if(DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD.equals(trabajo.getSubtipoTrabajo().getCodigo())){
						trabajo.setFechaAprobacion(new Date());
					}
					
				}
				
				ActivoTrabajo activoTrabajo = createActivoTrabajo(activo, trabajo, dtoTrabajo.getParticipacion());			
				trabajo.getActivosTrabajo().add(activoTrabajo);
				isFirstLoop = false;
			}

			if(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo()))
				trabajo.setEsTarificado(true);
			
			
			trabajoDao.saveOrUpdate(trabajo);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return trabajo;
		
	}

	private List<Activo> getListaActivosProceso(Long idProceso){
			
			List<Activo> listaActivos = new ArrayList<Activo>();
			MSVDocumentoMasivo documento = procesoManager.getMSVDocumento(idProceso);
			MSVHojaExcel exc = excelParser.getExcel(documento.getContenidoFichero().getFile());
			
			
			try {
				for(int i = 1; i < exc.getNumeroFilas(); i++){
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numActivo", Long.parseLong(exc.dameCelda(i,0)));
					Activo activo = genericDao.get(Activo.class, filtro);
					listaActivos.add(activo);
				}
			} catch (NumberFormatException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return listaActivos;
		}
	
	@Transactional(readOnly = false)
	private void ficheroMasivoToTrabajo(Long idProceso, Trabajo trabajo){
		MSVDocumentoMasivo documento = procesoManager.getMSVDocumento(idProceso);
		FileItem fileItem = documento.getContenidoFichero();
		fileItem.setFileName(documento.getNombre());
		//fileItem.setLength(); //TODO: Hay que meter el tamaño del fichero
		//fileItem.setContentType(); //TODO: Hay que meter el tipo del fichero
		WebFileItem webFileItem = new WebFileItem();
		webFileItem.setFileItem(fileItem);
		Map<String,String> mapaParametros = new HashMap<String,String>();
		mapaParametros.put("idEntidad", trabajo.getId().toString());
		mapaParametros.put("tipo", "01"); //TODO: He puesto informe comercial pero hay que crear un tipo nuevo
		mapaParametros.put("descripcion", "Listado de activos");
		webFileItem.setParameters(mapaParametros);

		List<AdjuntoTrabajo> adjuntosTrabajo = new ArrayList<AdjuntoTrabajo>();
		trabajo.setAdjuntos(adjuntosTrabajo);
		trabajoDao.saveOrUpdate(trabajo);
		try {
			upload(webFileItem);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//		
//		
//		List<AdjuntoTrabajo> adjuntosTrabajo = new ArrayList<AdjuntoTrabajo>();
//		AdjuntoTrabajo adjuntoMasivo = new AdjuntoTrabajo(fileItem);
//		adjuntosTrabajo.add(adjuntoMasivo);
//		trabajo.setAdjuntos(adjuntosTrabajo);
//		trabajoDao.saveOrUpdate(trabajo);
	}
		
	private Trabajo crearTrabajoPorSubidaActivos(DtoFichaTrabajo dtoTrabajo){
			
		List<Activo> listaActivos = getListaActivosProceso(dtoTrabajo.getIdProceso());
			
			Trabajo trabajo = new Trabajo();
			try {
				dtoToTrabajo(dtoTrabajo,trabajo);
				trabajo.setFechaSolicitud(new Date());
				trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());
				trabajo.setSolicitante(genericAdapter.getUsuarioLogado());
				
				Boolean isFirstLoop = true;
				for(Activo activo: listaActivos){
					dtoTrabajo.setParticipacion("100");//TODO: Pendiente de definir como sacar el % de participación.
					if(isFirstLoop){
						trabajo.setEstado(getEstadoNuevoTrabajo(dtoTrabajo,activo));
						
						// El gestor de activo se salta tareas de estos trámites y por tanto es necesario settear algunos datos
						// al crear el trabajo.
						if(gestorActivoManager.isGestorActivo(activo, genericAdapter.getUsuarioLogado())){
							if(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
									|| DDTipoTrabajo.CODIGO_TASACION.equals(trabajo.getTipoTrabajo().getCodigo())
									|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS.equals(trabajo.getSubtipoTrabajo().getCodigo())){
								trabajo.setFechaAprobacion(new Date());
							}
						}
						
						//El trámite de cédula queda aprobado al crearlo, sea o no sea gestor activo quien lo crea
						if(DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD.equals(trabajo.getSubtipoTrabajo().getCodigo())){
							trabajo.setFechaAprobacion(new Date());
						}
					}
					
					ActivoTrabajo activoTrabajo = createActivoTrabajo(activo,trabajo,dtoTrabajo.getParticipacion());
					trabajo.getActivosTrabajo().add(activoTrabajo);
					isFirstLoop = false;
				}
				
				if(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo()))
					trabajo.setEsTarificado(true);
				
				trabajoDao.saveOrUpdate(trabajo);
				
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			ficheroMasivoToTrabajo(dtoTrabajo.getIdProceso(), trabajo);

			return trabajo;
	}
		
	private Trabajo crearTrabajoPorActivo(Activo activo, DtoFichaTrabajo dtoTrabajo) {
		
		Trabajo trabajo = new Trabajo();		
		
		try {	
			
			dtoToTrabajo(dtoTrabajo, trabajo);
			
			trabajo.setFechaSolicitud(new Date());
			trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());			
			trabajo.setActivo(activo);
			trabajo.setSolicitante(genericAdapter.getUsuarioLogado());			
			trabajo.setEstado(getEstadoNuevoTrabajo(dtoTrabajo, activo));
			
			ActivoTrabajo activoTrabajo = createActivoTrabajo(activo, trabajo, dtoTrabajo.getParticipacion());			
			trabajo.getActivosTrabajo().add(activoTrabajo);
			
			if(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo()))
				trabajo.setEsTarificado(true);
			
			// El gestor de activo se salta tareas de estos trámites y por tanto es necesario settear algunos datos
			// al crear el trabajo.
			if (gestorActivoManager.isGestorActivo(activo, genericAdapter.getUsuarioLogado())){
				if(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
						|| DDTipoTrabajo.CODIGO_TASACION.equals(trabajo.getTipoTrabajo().getCodigo())
						|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS.equals(trabajo.getSubtipoTrabajo().getCodigo())){
					trabajo.setFechaAprobacion(new Date());
				}
			}			
			
			//El trámite de cédula queda aprobado al crearlo, sea o no sea gestor activo quien lo crea
			if(DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD.equals(trabajo.getSubtipoTrabajo().getCodigo())){
				trabajo.setFechaAprobacion(new Date());
			}
			
			
			trabajoDao.saveOrUpdate(trabajo);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return trabajo;
		
	}
	
	
	
	private DDEstadoTrabajo getEstadoNuevoTrabajo(DtoFichaTrabajo dtoTrabajo, Activo activo){
		/* Estados del trabajo - Al crear un trabajo:
		 * Si es trámite "Cedula": EN TRAMITE
		 * Si es gestor activo (algunos trámites): EN TRAMITE
		 * El resto de casos: SOLICITADO
		 */
		Filter filtroSolicitado = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_SOLICITADO);
		Filter filtroEnTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_EN_TRAMITE);
		
		//Por defecto: Solicitado
		DDEstadoTrabajo estadoTrabajo = (DDEstadoTrabajo) genericDao.get(DDEstadoTrabajo.class, filtroSolicitado);
		if(dtoTrabajo.getSubtipoTrabajoCodigo().equals(DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD)){
			//Cedula: En trámite
			estadoTrabajo = (DDEstadoTrabajo) genericDao.get(DDEstadoTrabajo.class, filtroEnTramite);
		} else {
			if(gestorActivoManager.isGestorActivo(activo, genericAdapter.getUsuarioLogado())
					&& (dtoTrabajo.getTipoTrabajoCodigo().equals(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL)
							|| dtoTrabajo.getTipoTrabajoCodigo().equals(DDTipoTrabajo.CODIGO_TASACION)
							|| dtoTrabajo.getSubtipoTrabajoCodigo().equals(DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS))
					){
				//Es gestor activo + Obtención documental(menos Cédula) o Tasación: En Trámite
				estadoTrabajo = (DDEstadoTrabajo) genericDao.get(DDEstadoTrabajo.class, filtroEnTramite);
			}
		}
		
		return estadoTrabajo;
	}

	private ActivoTrabajo createActivoTrabajo(Activo activo, Trabajo trabajo, String participacion) {
		ActivoTrabajoPk pk = new ActivoTrabajoPk();
		ActivoTrabajo activoTrabajo = new ActivoTrabajo();
		pk.setActivo(activo);
		pk.setTrabajo(trabajo);
		
		activoTrabajo.setPrimaryKey(pk);
		activoTrabajo.setParticipacion(new Float(participacion));
		return activoTrabajo;
	}
	
	private void dtoToTrabajo(DtoFichaTrabajo dtoTrabajo, Trabajo trabajo) throws IllegalAccessException, InvocationTargetException {
		beanUtilNotNull.copyProperties(trabajo, dtoTrabajo);
		
		if(Checks.esNulo(dtoTrabajo.getUrgente())) trabajo.setUrgente(false);
		
		if(Checks.esNulo(dtoTrabajo.getRiesgoInminenteTerceros())) trabajo.setRiesgoInminenteTerceros(false);
		
		if(Checks.esNulo(dtoTrabajo.getCubreSeguro())) trabajo.setCubreSeguro(false);
			
		if(dtoTrabajo.getEstadoCodigo()!=null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTrabajo.getEstadoCodigo());
			DDEstadoTrabajo estadoTrabajo = (DDEstadoTrabajo) genericDao.get(DDEstadoTrabajo.class, filtro);
			
			trabajo.setEstado(estadoTrabajo);
		}
		
		if(dtoTrabajo.getTipoCalidadCodigo()!=null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTrabajo.getTipoCalidadCodigo());
			DDTipoCalidad tipoCalidad = (DDTipoCalidad) genericDao.get(DDTipoCalidad.class, filtro);
			
			trabajo.setTipoCalidad(tipoCalidad);
		}
		
		if(dtoTrabajo.getTipoTrabajoCodigo()!=null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTrabajo.getTipoTrabajoCodigo());
			DDTipoTrabajo tipoTrabajo = (DDTipoTrabajo) genericDao.get(DDTipoTrabajo.class, filtro);
			
			trabajo.setTipoTrabajo(tipoTrabajo);
		}
		
		if(dtoTrabajo.getSubtipoTrabajoCodigo()!=null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoTrabajo.getSubtipoTrabajoCodigo());
			DDSubtipoTrabajo subtipoTrabajo = (DDSubtipoTrabajo) genericDao.get(DDSubtipoTrabajo.class, filtro);
			
			trabajo.setSubtipoTrabajo(subtipoTrabajo);
		}
	}
	
	private void dtoGestionEconomicaToTrabajo(DtoGestionEconomicaTrabajo dtoGestionEconomica, Trabajo trabajo) throws IllegalAccessException, InvocationTargetException {
		
		BeanUtilNotNull beanUtils = new BeanUtilNotNull();		
		beanUtils.copyProperties(trabajo, dtoGestionEconomica);
		//A través del combo de proveedor se seteará el PVC_ID (contacto de proveedor) del trabajo
		//De momento, el primer contacto del array de contactos relacionadois
		if (dtoGestionEconomica.getIdProveedor()!=null)
		{
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", dtoGestionEconomica.getIdProveedor());
			List<ActivoProveedorContacto> contactosProveedor = (List<ActivoProveedorContacto>) genericDao.getList(ActivoProveedorContacto.class, filtro);
			if (!Checks.estaVacio(contactosProveedor))
			{
				trabajo.setProveedorContacto(contactosProveedor.get(0));
			}
		}
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.createTramiteTrabajo")
	public ActivoTramite createTramiteTrabajo(Trabajo trabajo){
		TipoProcedimiento tipoTramite = new TipoProcedimiento();
		
		// TODO Dani: Cuando estén implementados el resto de trámites habría que crear un mapa para los distintos tipos de trámites por cada tipo de trabajo.
		if(trabajo.getTipoTrabajo().getCodigo().equals(DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL)){ // Obtención documental
			if(trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_CEE))//CEE
				tipoTramite = tipoProcedimientoManager.getByCodigo("T003"); //Trámite de obtención documental CEE
			else
				if(trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD))
					tipoTramite = tipoProcedimientoManager.getByCodigo("T008"); //Trámite de obtención de cédula
				else
					if(trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_INFORMES))
						tipoTramite = tipoProcedimientoManager.getByCodigo("T006");//Trámite de informes
					else
						tipoTramite = tipoProcedimientoManager.getByCodigo("T002"); //Trámite de obtención documental
		}
		if(trabajo.getTipoTrabajo().getCodigo().equals(DDTipoTrabajo.CODIGO_TASACION)){ // Tasación
			tipoTramite = tipoProcedimientoManager.getByCodigo("T005"); //Trámite de tasación
		}
		if(trabajo.getTipoTrabajo().getCodigo().equals(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA)){ // Actuación técnica
			if(trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS))
				tipoTramite = tipoProcedimientoManager.getByCodigo("T006"); //Sólo en verificación de averias
			else
				tipoTramite = tipoProcedimientoManager.getByCodigo("T004");
		}
		
		// Tramites [FASE 2] -----------------------
		//
		// Modulo de Precios
		if(trabajo.getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_PRECIOS)){ // Propuesta de precios
			tipoTramite = tipoProcedimientoManager.getByCodigo("T009");
		}
		
		ActivoTramite tramite = jbpmActivoTramiteManager.createActivoTramiteTrabajo(tipoTramite, /*trabajo.getActivo(),*/trabajo);
		
		jbpmActivoTramiteManager.lanzaBPMAsociadoATramite(tramite.getId());
		return tramite;
	}
	
	
	private DtoFichaTrabajo trabajoToDtoFichaTrabajo(Trabajo trabajo) throws IllegalAccessException, InvocationTargetException {
		
		DtoFichaTrabajo dtoTrabajo = new DtoFichaTrabajo();
		
		beanUtilNotNull.copyProperties(dtoTrabajo, trabajo);
		
		Activo activo = trabajo.getActivo();
		
		if(!Checks.esNulo(activo)) {
			
			if (!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
				dtoTrabajo.setNombreMediador(activo.getInfoComercial().getMediadorInforme().getNombre());
			}
			
			dtoTrabajo.setCartera(activo.getCartera().getDescripcion());
			dtoTrabajo.setPropietario(activo.getFullNamePropietario());
			dtoTrabajo.setIdActivo(activo.getId());
		}
		
		if(trabajo.getProveedorContacto()!=null && trabajo.getProveedorContacto().getProveedor() != null) dtoTrabajo.setNombreProveedor(trabajo.getProveedorContacto().getProveedor().getNombreComercial());		
		
		if(trabajo.getTipoTrabajo()!=null) dtoTrabajo.setTipoTrabajoDescripcion(trabajo.getTipoTrabajo().getDescripcion());
		
		if(trabajo.getSubtipoTrabajo()!=null) dtoTrabajo.setSubtipoTrabajoDescripcion(trabajo.getSubtipoTrabajo().getDescripcion());
		
		if(trabajo.getEstado()!=null) {
			dtoTrabajo.setEstadoCodigo(trabajo.getEstado().getCodigo());
			dtoTrabajo.setEstadoDescripcion(trabajo.getEstado().getDescripcion());
		}
		
		if(trabajo.getTipoCalidad()!=null) dtoTrabajo.setTipoCalidadCodigo(trabajo.getTipoCalidad().getCodigo());
		
		if(trabajo.getSolicitante()!=null)
		{
			dtoTrabajo.setSolicitante(trabajo.getSolicitante().getApellidoNombre());
		}
		else
		{
			if (trabajo.getMediador()!=null)
			{
				dtoTrabajo.setSolicitante(trabajo.getMediador().getNombre());
			}
		}
		
		dtoTrabajo.setHoraConcreta(trabajo.getFechaHoraConcreta());
		dtoTrabajo.setFechaConcreta(trabajo.getFechaHoraConcreta());			

		if(trabajo.getAgrupacion()!=null) {
			dtoTrabajo.setNumAgrupacion(trabajo.getAgrupacion().getNumAgrupRem());
			dtoTrabajo.setIdAgrupacion(trabajo.getAgrupacion().getId());
			dtoTrabajo.setNumActivosAgrupacion(trabajo.getAgrupacion().getActivos().size());
			dtoTrabajo.setTipoAgrupacionDescripcion(trabajo.getAgrupacion().getTipoAgrupacion().getDescripcion());
		}
		
		return dtoTrabajo;
		
	}
	

	private DtoGestionEconomicaTrabajo trabajoToDtoGestionEconomicaTrabajo(Trabajo trabajo) throws IllegalAccessException, InvocationTargetException {
		
		DtoGestionEconomicaTrabajo dtoTrabajo = new DtoGestionEconomicaTrabajo();
		
		beanUtilNotNull.copyProperties(dtoTrabajo, trabajo);
		beanUtilNotNull.copyProperty(dtoTrabajo.getNumTrabajo(), "numTrabajo", trabajo.getNumTrabajo());
		if(trabajo.getImporteTotal()!=null)
		{
			BeanUtils.copyProperty(dtoTrabajo.getImporteTotal(), "importeTotal", trabajo.getImporteTotal());
		}
		
		dtoTrabajo.setIdTrabajo(trabajo.getId());
		
		if(trabajo.getTipoTrabajo()!=null)
		{
			dtoTrabajo.setTipoTrabajoCodigo(trabajo.getTipoTrabajo().getCodigo());
			dtoTrabajo.setTipoTrabajoDescripcion(trabajo.getTipoTrabajo().getDescripcion());
		}
		if(trabajo.getSubtipoTrabajo()!=null)
		{
			dtoTrabajo.setSubtipoTrabajoCodigo(trabajo.getSubtipoTrabajo().getCodigo());
			dtoTrabajo.setSubtipoTrabajoDescripcion(trabajo.getSubtipoTrabajo().getDescripcion());
		}
		//FIXME Considerar si al final se sacará cartera también cuando el trabajo
		//esté relacionado directamente con la agrupación (de momento no)
		if(trabajo.getActivo()!=null && trabajo.getActivo().getCartera()!=null)
		{
			dtoTrabajo.setCarteraCodigo(trabajo.getActivo().getCartera().getCodigo());
		}
		
		dtoTrabajo.setDiasRetrasoOrigen(trabajo.getDiasRetrasoOrigen());
		
		dtoTrabajo.setDiasRetrasoMesCurso(trabajo.getDiasRetrasoMesCurso());
		
		
		if (trabajo.getProveedorContacto()!=null)
		{
			if (trabajo.getProveedorContacto().getProveedor()!=null)
			{
				dtoTrabajo.setIdProveedor(trabajo.getProveedorContacto().getProveedor().getId());	
			}
			if (trabajo.getProveedorContacto().getUsuario() != null)
			{
				dtoTrabajo.setUsuarioProveedorContacto(trabajo.getProveedorContacto().getUsuario().getApellidoNombre());
			}
			dtoTrabajo.setEmailProveedorContacto(trabajo.getProveedorContacto().getEmail());
			dtoTrabajo.setTelefonoProveedorContacto(trabajo.getProveedorContacto().getTelefono1());
		}
		
		return dtoTrabajo;
		
	}
	
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.deleteAdjunto")
	@Transactional(readOnly = false)
    public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		
		Trabajo trabajo = trabajoDao.get(dtoAdjunto.getIdTrabajo());
		AdjuntoTrabajo adjunto = trabajo.getAdjunto(dtoAdjunto.getId());
		
	    if (adjunto == null) { return false; }
	    trabajo.getAdjuntos().remove(adjunto);
	    trabajoDao.save(trabajo);
	    
	    return true;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.createTarifaTrabajo")
	@Transactional(readOnly = false)
	public boolean createTarifaTrabajo(DtoTarifaTrabajo tarifaDto, Long idTrabajo)
	{
		Trabajo trabajo = trabajoDao.get(idTrabajo);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", tarifaDto.getIdConfigTarifa());
		ConfiguracionTarifa cfgTarifa = (ConfiguracionTarifa) genericDao.get(ConfiguracionTarifa.class, filtro);
		
		try {
			TrabajoConfiguracionTarifa traCfgTarifa = new TrabajoConfiguracionTarifa();
			traCfgTarifa.setConfigTarifa(cfgTarifa);
			traCfgTarifa.setTrabajo(trabajo);
			if (tarifaDto.getMedicion() != null && !tarifaDto.getMedicion().isEmpty())
			{
				traCfgTarifa.setMedicion(Float.valueOf(tarifaDto.getMedicion()));
			}
			if (tarifaDto.getPrecioUnitario() != null && !tarifaDto.getPrecioUnitario().isEmpty())
			{
				traCfgTarifa.setPrecioUnitario(Float.valueOf(tarifaDto.getPrecioUnitario()));
			}
			genericDao.save(TrabajoConfiguracionTarifa.class, traCfgTarifa);
			actualizarImporteTotalTrabajo(idTrabajo);
			//Luego en el callback hacer que se refresque automáticamente el grid
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.createPresupuestoTrabajo")
	@Transactional(readOnly = false)
	public boolean createPresupuestoTrabajo(DtoPresupuestosTrabajo presupuestoDto, Long idTrabajo)
	{
		Trabajo trabajo = trabajoDao.get(idTrabajo);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", presupuestoDto.getIdProveedor());
		ActivoProveedor proveedor = (ActivoProveedor) genericDao.get(ActivoProveedor.class, filtro);
		
		try {
			PresupuestoTrabajo presupuesto = new PresupuestoTrabajo();
			presupuesto.setTrabajo(trabajo);
			presupuesto.setProveedor(proveedor);
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", "03"); //Estado inicial del presupuesto: en estudio
			DDEstadoPresupuesto estadoPresupuesto = (DDEstadoPresupuesto) genericDao.get(DDEstadoPresupuesto.class, filtro2);
			presupuesto.setEstadoPresupuesto(estadoPresupuesto);
			beanUtilNotNull.copyProperties(presupuesto, presupuestoDto);
			genericDao.save(PresupuestoTrabajo.class, presupuesto);
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.savePresupuestoTrabajo")
	@Transactional(readOnly = false)
	public boolean savePresupuestoTrabajo(DtoPresupuestosTrabajo presupuestoDto)
	{

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(presupuestoDto.getId()));
		PresupuestoTrabajo presupuestoTrabajo = genericDao.get(PresupuestoTrabajo.class, filtro);
		Trabajo trabajo = findOne(presupuestoTrabajo.getTrabajo().getId());
		
		try {
			beanUtilNotNull.copyProperties(presupuestoTrabajo, presupuestoDto);
			if (presupuestoDto.getIdProveedor()!=null)
			{
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "id", presupuestoDto.getIdProveedor());
				ActivoProveedor proveedor = (ActivoProveedor) genericDao.get(ActivoProveedor.class, filtro2);
				presupuestoTrabajo.setProveedor(proveedor);
			}
					
			if (presupuestoDto.getEstadoPresupuestoCodigo()!=null)
			{
				Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "codigo", presupuestoDto.getEstadoPresupuestoCodigo());
				DDEstadoPresupuesto estadoPresupuesto = (DDEstadoPresupuesto) genericDao.get(DDEstadoPresupuesto.class, filtro3);
				presupuestoTrabajo.setEstadoPresupuesto(estadoPresupuesto);
				//Si el nuevo estado del presupuesto es autorizado, el resto de presupuestos para ese trabajo pasa a ser rechazado
				//Sacar lista de todos los presupuestos menos el que acabamos de modificar y cambiar atributo
				if ("02".equalsIgnoreCase(estadoPresupuesto.getCodigo()))
				{
					Filter filtroPresupuestos = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", presupuestoTrabajo.getTrabajo().getId());
					List<PresupuestoTrabajo> listaPresup = genericDao.getList(PresupuestoTrabajo.class, filtroPresupuestos);
					
					// Buscamos el proveedor y lo asignamos al trabajo
					filtro = genericDao.createFilter(FilterType.EQUALS, "id", presupuestoTrabajo.getProveedor().getId());
					ActivoProveedorContacto activoProveedor = genericDao.get(ActivoProveedorContacto.class, filtro);
					trabajo.setProveedorContacto(activoProveedor);

					for (PresupuestoTrabajo presup: listaPresup) {
						if (presup.getId()!=presupuestoTrabajo.getId())
						{
							Filter filtroRechazado = genericDao.createFilter(FilterType.EQUALS, "codigo", "01"); //Estado rechazado
							DDEstadoPresupuesto estadoPresupuestoRechazado = (DDEstadoPresupuesto) genericDao.get(DDEstadoPresupuesto.class, filtroRechazado);			
							presup.setEstadoPresupuesto(estadoPresupuestoRechazado);
							genericDao.save(PresupuestoTrabajo.class, presup);
						}
					}
				}
			}
			genericDao.save(PresupuestoTrabajo.class, presupuestoTrabajo);
			
			actualizarImporteTotalTrabajo(trabajo.getId());
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.saveTarifaTrabajo")
	@Transactional(readOnly = false)
	public boolean saveTarifaTrabajo(DtoTarifaTrabajo tarifaDto)
	{
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(tarifaDto.getId()));
		TrabajoConfiguracionTarifa tarifaTrabajo = genericDao.get(TrabajoConfiguracionTarifa.class, filtro);
		
		try {
			
			beanUtilNotNull.copyProperties(tarifaTrabajo, tarifaDto);			
			genericDao.save(TrabajoConfiguracionTarifa.class, tarifaTrabajo);
			actualizarImporteTotalTrabajo(tarifaTrabajo.getTrabajo().getId());			
			
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.deletePresupuestoTrabajo")
	@Transactional(readOnly = false)
	public boolean deletePresupuestoTrabajo(Long id)
	{
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(id));			
			
			PresupuestoTrabajo presupuesto = genericDao.get(PresupuestoTrabajo.class, filtro);
			Trabajo trabajo = presupuesto.getTrabajo();
			
			genericDao.deleteById(PresupuestoTrabajo.class, id);

			actualizarImporteTotalTrabajo(trabajo.getId());
			trabajoDao.save(trabajo);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} 

		
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.deleteTarifaTrabajo")
	@Transactional(readOnly = false)
	public boolean deleteTarifaTrabajo(Long id)
	{
		try {
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(id));			
			
			TrabajoConfiguracionTarifa tarifa = genericDao.get(TrabajoConfiguracionTarifa.class, filtro);
			Trabajo trabajo = tarifa.getTrabajo();
			
			genericDao.deleteById(TrabajoConfiguracionTarifa.class, id);

			actualizarImporteTotalTrabajo(trabajo.getId());
			trabajoDao.save(trabajo);

			
		} catch (Exception e) {
			e.printStackTrace();
		} 

		
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem fileItem) throws Exception {

			//Subida de adjunto al Trabajo
			Trabajo trabajo = trabajoDao.get(Long.parseLong(fileItem.getParameter("idEntidad")));
			
			Adjunto adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
			
			AdjuntoTrabajo adjuntoTrabajo = new AdjuntoTrabajo();
			adjuntoTrabajo.setAdjunto(adj);
			
			adjuntoTrabajo.setTrabajo(trabajo);
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
			DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class, filtro);
			adjuntoTrabajo.setTipoDocumentoActivo(tipoDocumento);
			
			adjuntoTrabajo.setContentType(fileItem.getFileItem().getContentType());
			
			adjuntoTrabajo.setTamanyo(fileItem.getFileItem().getLength());
			
			adjuntoTrabajo.setNombre(fileItem.getFileItem().getFileName());

			adjuntoTrabajo.setDescripcion(fileItem.getParameter("descripcion"));			
			
			adjuntoTrabajo.setFechaDocumento(new Date());

			Auditoria.save(adjuntoTrabajo);
	        
			trabajo.getAdjuntos().add(adjuntoTrabajo);		
				
			trabajoDao.save(trabajo);
			

			//Copia de adjunto al Activo
			ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();

			adjuntoActivo.setAdjunto(adj);
			adjuntoActivo.setActivo(trabajo.getActivo());
			adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);
			adjuntoActivo.setContentType(fileItem.getFileItem().getContentType());
			adjuntoActivo.setTamanyo(fileItem.getFileItem().getLength());
			adjuntoActivo.setNombre(fileItem.getFileItem().getFileName());
			adjuntoActivo.setDescripcion(fileItem.getParameter("descripcion"));			
			adjuntoActivo.setFechaDocumento(new Date());
			Auditoria.save(adjuntoActivo);
			trabajo.getActivo().getAdjuntos().add(adjuntoActivo);
	        
		return null;

	}
	
	@Override
    @BusinessOperationDefinition("trabajoManager.getFileItemAdjunto")
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto) {
		
		Trabajo trabajo = trabajoDao.get(dtoAdjunto.getIdTrabajo());
		AdjuntoTrabajo adjuntoTrabajo = trabajo.getAdjunto(dtoAdjunto.getId());
		
		FileItem fileItem = adjuntoTrabajo.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoTrabajo.getContentType());
		fileItem.setFileName(adjuntoTrabajo.getNombre());
		
		return adjuntoTrabajo.getAdjunto().getFileItem();
	}
	
	@Override
    @BusinessOperationDefinition("trabajoManager.getAdjuntosTrabajo")
	public List<DtoAdjunto> getAdjuntos(Long id) {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		
		try{
			
			Trabajo trabajo = trabajoDao.get(id);


			for (AdjuntoTrabajo adjunto : trabajo.getAdjuntos()) {
				DtoAdjunto dto = new DtoAdjunto();
				
				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdTrabajo(trabajo.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoActivo().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());				
				
				listaAdjuntos.add(dto);
				
			}
		
		}catch(Exception ex){
			ex.printStackTrace();
		}

		return listaAdjuntos;
	}

	@Override
	public Page getListActivos(DtoActivosTrabajoFilter dto) {		
			
		return trabajoDao.getListActivosTrabajo(dto);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getObservaciones(DtoTrabajoFilter dto) {
		
		Page page = trabajoDao.getObservaciones(dto);
		
		List<TrabajoObservacion> lista = (List<TrabajoObservacion>) page.getResults();
		List<DtoObservacion> observaciones = new ArrayList<DtoObservacion>();
		
		for (TrabajoObservacion observacion: lista) {
			
			DtoObservacion dtoObservacion = observacionToDto(observacion);
			observaciones.add(dtoObservacion);
		}
		
		return new DtoPage(observaciones, page.getTotalCount());
		
	}
	
	@Transactional(readOnly = false)
	public boolean saveObservacion(DtoObservacion dtoObservacion) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		TrabajoObservacion observacion = genericDao.get(TrabajoObservacion.class, filtro);
		
		try {
			
			beanUtilNotNull.copyProperties(observacion, dtoObservacion);			
			genericDao.save(TrabajoObservacion.class, observacion);
			
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean createObservacion(DtoObservacion dtoObservacion, Long idTrabajo) {
		
		TrabajoObservacion observacion = new TrabajoObservacion();
		Trabajo trabajo = findOne(idTrabajo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		try {
			
			//beanUtilNotNull.copyProperties(activoObservacion, dtoObservacion);
			observacion.setObservacion(dtoObservacion.getObservacion());
			observacion.setFecha(new Date());
			observacion.setUsuario(usuarioLogado);
			observacion.setTrabajo(trabajo);
			
			genericDao.save(TrabajoObservacion.class, observacion);

			
		} catch (Exception e) {
			e.printStackTrace();
		} 

		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean deleteObservacion(Long idObservacion) {
		
		try {
			
			genericDao.deleteById(TrabajoObservacion.class, idObservacion);
			
		} catch (Exception e) {
			e.printStackTrace();
		} 

		return true;
		
	}

	private DtoObservacion observacionToDto(TrabajoObservacion observacion) {
		
		DtoObservacion observacionDto = new DtoObservacion();
		
		try {
			
			String nombreCompleto = observacion.getUsuario().getNombre();
			Long idUsuario = observacion.getUsuario().getId();
			
			if (observacion.getUsuario().getApellido1() != null) {
				
				nombreCompleto += observacion.getUsuario().getApellido1();
				
				if (observacion.getUsuario().getApellido2() != null) {
					nombreCompleto += observacion.getUsuario().getApellido2();
				}
				
			}
			
			if(!Checks.esNulo(observacion.getAuditoria().getFechaModificar())){
				observacionDto.setFechaModificacion(observacion.getAuditoria().getFechaModificar());				
			}

			BeanUtils.copyProperties(observacionDto, observacion);
			observacionDto.setNombreCompleto(nombreCompleto);
			observacionDto.setIdUsuario(idUsuario);
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return observacionDto;
	}

	private DtoConfiguracionTarifa tarifaToDto(ConfiguracionTarifa tarifa) {
		
		DtoConfiguracionTarifa tarifaDto = new DtoConfiguracionTarifa();
		
		try {
			BeanUtils.copyProperties(tarifaDto, tarifa);
			
			if (tarifa.getTipoTarifa()!=null)
			{
				tarifaDto.setCodigoTarifa(tarifa.getTipoTarifa().getCodigo());
				tarifaDto.setDescripcion(tarifa.getTipoTarifa().getDescripcion());
			}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return tarifaDto;
	}
	
	private DtoTarifaTrabajo tarifaAplicadaToDto(TrabajoConfiguracionTarifa tarifaAplicada) {
		
		DtoTarifaTrabajo tarifaDto = new DtoTarifaTrabajo();
		
		try {
			BeanUtils.copyProperties(tarifaDto, tarifaAplicada);
			if (tarifaAplicada.getConfigTarifa()!=null)
			{
				BeanUtils.copyProperties(tarifaDto, tarifaAplicada.getConfigTarifa());
				//Sobreescribir la ID (con el copyProperties se adopta la de la entidad ConfiguracionTarifa)
				BeanUtils.copyProperty(tarifaDto, "id", tarifaAplicada.getId());
				//Sobreescribir el precioUnitario que viene de ConfiguracionTarifa si vienen datos nuevos
				if (tarifaAplicada.getPrecioUnitario() != null)
				{
					BeanUtils.copyProperty(tarifaDto, "precioUnitario", tarifaAplicada.getPrecioUnitario());
				}
				if (tarifaAplicada.getConfigTarifa().getTipoTarifa()!=null)
				{
					tarifaDto.setCodigoTarifa(tarifaAplicada.getConfigTarifa().getTipoTarifa().getCodigo());
					tarifaDto.setDescripcion(tarifaAplicada.getConfigTarifa().getTipoTarifa().getDescripcion());
				}
				
				if (tarifaAplicada.getConfigTarifa().getSubtipoTrabajo()!=null)
				{
					tarifaDto.setSubtipoTrabajoCodigo(tarifaAplicada.getConfigTarifa().getSubtipoTrabajo().getCodigo());
					tarifaDto.setSubtipoTrabajoDescripcion(tarifaAplicada.getConfigTarifa().getSubtipoTrabajo().getDescripcion());
				}
			}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return tarifaDto;
	}
	
private DtoPresupuestosTrabajo presupuestoTrabajoToDto(PresupuestoTrabajo presupuesto) {
		
	DtoPresupuestosTrabajo presupuestoDto = new DtoPresupuestosTrabajo();
		
		try {
			BeanUtils.copyProperties(presupuestoDto, presupuesto);
			if (presupuesto.getTrabajo()!= null)
			{
				BeanUtils.copyProperty(presupuestoDto, "idTrabajo", presupuesto.getTrabajo().getId());
				if (presupuesto.getTrabajo().getTipoTrabajo()!=null)
				{
					BeanUtils.copyProperty(presupuestoDto, "tipoTrabajoDescripcion", presupuesto.getTrabajo().getTipoTrabajo().getDescripcion());
				}
				if (presupuesto.getTrabajo().getSubtipoTrabajo()!=null)
				{
					BeanUtils.copyProperty(presupuestoDto, "subtipoTrabajoDescripcion", presupuesto.getTrabajo().getSubtipoTrabajo().getDescripcion());
					
				}
			}
			if (presupuesto.getProveedor()!= null)
			{
				BeanUtils.copyProperty(presupuestoDto, "idProveedor", presupuesto.getProveedor().getId());
				BeanUtils.copyProperty(presupuestoDto, "proveedorDescripcion", presupuesto.getProveedor().getNombre());
			}	
			if (presupuesto.getEstadoPresupuesto()!= null)
			{
				BeanUtils.copyProperty(presupuestoDto, "estadoPresupuestoCodigo", presupuesto.getEstadoPresupuesto().getCodigo());
				BeanUtils.copyProperty(presupuestoDto, "estadoPresupuestoDescripcion", presupuesto.getEstadoPresupuesto().getDescripcion());
			}			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return presupuestoDto;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveActivoTrabajo(DtoActivoTrabajo dtoActivoTrabajo) {
		ActivoTrabajo activoTrabajo = activoTrabajoDao.findOne( Long.valueOf(dtoActivoTrabajo.getIdActivo()),  Long.valueOf(dtoActivoTrabajo.getIdTrabajo()));

		activoTrabajo.setParticipacion(Float.valueOf(dtoActivoTrabajo.getParticipacion()));			
		genericDao.update(ActivoTrabajo.class, activoTrabajo);
		
		return true;
		
	}

	@Override
	public Page getListActivosAgrupacion(DtoAgrupacionFilter filtro, Long id) {
		
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		filtro.setAgrupacionId(String.valueOf(id));
		
		return trabajoDao.getListActivosAgrupacion(filtro, usuarioLogado);
	}
	
	@Override
	public DtoPage getSeleccionTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, String cartera, String tipoTrabajo, String subtipoTrabajo) {
		
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		filtro.setCarteraCodigo(cartera);
		filtro.setTipoTrabajoCodigo(tipoTrabajo);
		filtro.setSubtipoTrabajoCodigo(subtipoTrabajo);
		Page page = trabajoDao.getSeleccionTarifasTrabajo(filtro, usuarioLogado);
		
		List<ConfiguracionTarifa> lista = (List<ConfiguracionTarifa>) page.getResults();
		List<DtoConfiguracionTarifa> tarifas = new ArrayList<DtoConfiguracionTarifa>();
		
		for (ConfiguracionTarifa configuracion: lista) {
			
			DtoConfiguracionTarifa dtoConfiguracionTarifa = tarifaToDto(configuracion);
			tarifas.add(dtoConfiguracionTarifa);
		}
		
		return new DtoPage(tarifas, page.getTotalCount());
	}
	
	@Override
	public DtoPage getTarifasTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo) {
		
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		filtro.setIdTrabajo(idTrabajo);
		Page page = trabajoDao.getTarifasTrabajo(filtro, usuarioLogado);
		
		List<TrabajoConfiguracionTarifa> lista = (List<TrabajoConfiguracionTarifa>) page.getResults();
		List<DtoTarifaTrabajo> tarifas = new ArrayList<DtoTarifaTrabajo>();
		
		for (TrabajoConfiguracionTarifa trabajoTarifa: lista) {
			
			DtoTarifaTrabajo dtoTarifaTrabajo = tarifaAplicadaToDto(trabajoTarifa);
			tarifas.add(dtoTarifaTrabajo);
		}
		
		return new DtoPage(tarifas, page.getTotalCount());
	}
	
	@Override
	public DtoPage getPresupuestosTrabajo(DtoGestionEconomicaTrabajo filtro, Long idTrabajo) {
		
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		filtro.setIdTrabajo(idTrabajo);
		Page page = trabajoDao.getPresupuestosTrabajo(filtro, usuarioLogado);
		
		List<PresupuestoTrabajo> lista = (List<PresupuestoTrabajo>) page.getResults();
		List<DtoPresupuestosTrabajo> presupuestos = new ArrayList<DtoPresupuestosTrabajo>();
		
		for (PresupuestoTrabajo presupuesto: lista) {
			
			DtoPresupuestosTrabajo presupuestoDto = presupuestoTrabajoToDto(presupuesto);
			presupuestos.add(presupuestoDto);
		}
		
		return new DtoPage(presupuestos, page.getTotalCount());
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.existePresupuestoTrabajo")
	public Boolean existePresupuestoTrabajo(TareaExterna tarea){
		String PRESUPUESTO_AUTORIZADO = "02";
		
		Boolean hayPresupuestoAutorizado = false;
		
		Trabajo trabajo = getTrabajoByTareaExterna(tarea);
		
		Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
		List<PresupuestoTrabajo> presupuestosTrabajo = genericDao.getList(PresupuestoTrabajo.class, filtroTrabajo);
		
		for (PresupuestoTrabajo presupuestoTrabajo : presupuestosTrabajo){
			if (PRESUPUESTO_AUTORIZADO.equals(presupuestoTrabajo.getEstadoPresupuesto().getCodigo()) ){
				hayPresupuestoAutorizado = true;
			}
		}
		
		return hayPresupuestoAutorizado;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.existeTarifaTrabajo")
	public Boolean existeTarifaTrabajo(TareaExterna tarea){

		Trabajo trabajo = getTrabajoByTareaExterna(tarea);
		
		Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
		List<TrabajoConfiguracionTarifa> tarifasTrabajo = genericDao.getList(TrabajoConfiguracionTarifa.class, filtroTrabajo);
		
		return !tarifasTrabajo.isEmpty();
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.getPresupuestoById")
	public DtoPresupuestoTrabajo getPresupuestoById(Long id)
	{
		DtoPresupuestoTrabajo dtoPresupuesto = new DtoPresupuestoTrabajo();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		PresupuestoTrabajo presupuestoSeleccionado = (PresupuestoTrabajo) genericDao.get(PresupuestoTrabajo.class, filtro);
		
		try {
			beanUtilNotNull.copyProperties(dtoPresupuesto, presupuestoSeleccionado);
			if (presupuestoSeleccionado.getTrabajo()!=null)
			{
				beanUtilNotNull.copyProperty(dtoPresupuesto, "tipoTrabajoDescripcion", presupuestoSeleccionado.getTrabajo().getTipoTrabajo().getDescripcion());
				beanUtilNotNull.copyProperty(dtoPresupuesto, "subtipoTrabajoDescripcion", presupuestoSeleccionado.getTrabajo().getSubtipoTrabajo().getDescripcion());
			}
			if (presupuestoSeleccionado.getEstadoPresupuesto()!=null)
			{
				beanUtilNotNull.copyProperty(dtoPresupuesto, "estadoPresupuestoDescripcion", presupuestoSeleccionado.getEstadoPresupuesto().getDescripcion()); 
			}
			if (presupuestoSeleccionado.getProveedor()!=null)
			{
				
				beanUtilNotNull.copyProperty(dtoPresupuesto, "nombreProveedor", presupuestoSeleccionado.getProveedor().getNombre()); 
				beanUtilNotNull.copyProperty(dtoPresupuesto, "emailProveedor", presupuestoSeleccionado.getProveedor().getEmail()); 
				beanUtilNotNull.copyProperty(dtoPresupuesto, "telefonoProveedor", presupuestoSeleccionado.getProveedor().getTelefono1()); 
				//El usuario actualmente no está conectado con el proveedor, así que no podemos hacer su copyProperty
			}
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return dtoPresupuesto;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.existeProveedorTrabajo")
	public Boolean existeProveedorTrabajo(TareaExterna tarea){

		Trabajo trabajo = getTrabajoByTareaExterna(tarea);
		
		return !Checks.esNulo(trabajo.getProveedorContacto());
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.uploadFoto")
	@Transactional(readOnly = false)
	public String uploadFoto(WebFileItem fileItem) {
			
			Trabajo trabajo = findOne(Long.parseLong(fileItem.getParameter("idEntidad")));
						
			TrabajoFoto trabajoFoto = new TrabajoFoto(fileItem.getFileItem());
			
			trabajoFoto.setTrabajo(trabajo);
						
			trabajoFoto.setTamanyo(fileItem.getFileItem().getLength());
			
			trabajoFoto.setNombre(fileItem.getFileItem().getFileName());

			trabajoFoto.setDescripcion(fileItem.getParameter("descripcion"));
			
			trabajoFoto.setSolicitanteProveedor(Boolean.valueOf(fileItem.getParameter("solicitanteProveedor")));
			
			trabajoFoto.setFechaDocumento(new Date());

			Integer orden = trabajoDao.getMaxOrdenFotoById(Long.parseLong(fileItem.getParameter("idEntidad")));
			orden++;
			
			trabajoFoto.setOrden(orden);

			Auditoria.save(trabajoFoto);
	        
			trabajo.getFotos().add(trabajoFoto);		
				
			trabajoDao.save(trabajo);
					
		return "success";

	}
	
	
	@Override
	@BusinessOperationDefinition("trabajoManager.getComboProveedor")
	public List<VProveedores> getComboProveedor(Long idTrabajo) {
		
		Trabajo trabajo = findOne(idTrabajo);		
		Long idCartera = trabajo.getActivo().getCartera().getId();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idCartera", idCartera);

		return (List<VProveedores>) genericDao.getList(VProveedores.class, filtro);
		
	}
	
	@Override
	@BusinessOperationDefinition("trabajoManager.getRecargosProveedor")
	public List<DtoRecargoProveedor> getRecargosProveedor(Long idTrabajo) {
		
		Trabajo trabajo = findOne(idTrabajo);
		List<DtoRecargoProveedor> recargos = new ArrayList<DtoRecargoProveedor>();
		
		
		for (TrabajoRecargosProveedor recargo : trabajo.getRecargosProveedor()) {
			DtoRecargoProveedor dtoRecargo = new DtoRecargoProveedor();
			
			try {
				dtoRecargo.setIdRecargo(String.valueOf(recargo.getId()));
				beanUtilNotNull.copyProperties(dtoRecargo, recargo);				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			dtoRecargo.setTipoCalculoCodigo(recargo.getTipoCalculo().getCodigo());
			dtoRecargo.setTipoCalculoDescripcion(recargo.getTipoCalculo().getCodigo());
			dtoRecargo.setTipoRecargoCodigo(recargo.getTipoRecargo().getCodigo());
			dtoRecargo.setTipoRecargoDescripcion(recargo.getTipoRecargo().getDescripcion());
			
			recargos.add(dtoRecargo);
		}
		
		return recargos;
		
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.createRecargoProveedor")
	@Transactional(readOnly = false)
	public boolean createRecargoProveedor(DtoRecargoProveedor recargoDto, Long idTrabajo)
	{
		Trabajo trabajo = trabajoDao.get(idTrabajo);
		
		try {
			TrabajoRecargosProveedor recargo = new TrabajoRecargosProveedor();
			recargo.setTrabajo(trabajo);
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", recargoDto.getTipoCalculoCodigo());
			DDTipoCalculo tipoCalculo = (DDTipoCalculo) genericDao.get(DDTipoCalculo.class, filtro);
			recargo.setTipoCalculo(tipoCalculo);
			
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", recargoDto.getTipoRecargoCodigo());
			DDTipoRecargoProveedor tipoRecargo = (DDTipoRecargoProveedor) genericDao.get(DDTipoRecargoProveedor.class, filtro);
			recargo.setTipoRecargo(tipoRecargo);
			beanUtilNotNull.copyProperties(recargo, recargoDto);			
			trabajo.getRecargosProveedor().add(recargo);
			
			genericDao.save(TrabajoRecargosProveedor.class, recargo);			

			actualizarImporteTotalTrabajo(idTrabajo);

		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "trabajoManager.saveRecargoProveedor")
	@Transactional(readOnly = false)
	public boolean saveRecargoProveedor(DtoRecargoProveedor recargoDto) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(recargoDto.getIdRecargo()));
		TrabajoRecargosProveedor recargo = genericDao.get(TrabajoRecargosProveedor.class, filtro);
		
		try {
			
			beanUtilNotNull.copyProperties(recargo, recargoDto);
			
			if(!Checks.esNulo(recargoDto.getTipoCalculoCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", recargoDto.getTipoCalculoCodigo());
				DDTipoCalculo tipoCalculo = (DDTipoCalculo) genericDao.get(DDTipoCalculo.class, filtro);
				recargo.setTipoCalculo(tipoCalculo);
			}
			
			if(!Checks.esNulo(recargoDto.getTipoRecargoCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", recargoDto.getTipoRecargoCodigo());
				DDTipoRecargoProveedor tipoRecargo = (DDTipoRecargoProveedor) genericDao.get(DDTipoRecargoProveedor.class, filtro);
				recargo.setTipoRecargo(tipoRecargo);
			}			
			genericDao.save(TrabajoRecargosProveedor.class, recargo);			

			actualizarImporteTotalTrabajo(recargo.getTrabajo().getId());
			
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		
		return true;
	}

	@Override
	@BusinessOperation(overrides = "trabajoManager.deleteRecargoProveedor")
	@Transactional(readOnly = false)
	public boolean deleteRecargoProveedor(Long id) {
	
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(id));
			TrabajoRecargosProveedor recargo = genericDao.get(TrabajoRecargosProveedor.class, filtro);		
			Long idTrabajo =  recargo.getTrabajo().getId();	
			genericDao.deleteById(TrabajoRecargosProveedor.class, id);
			
			actualizarImporteTotalTrabajo(idTrabajo);
	
			
		} catch (Exception e) {			
			e.printStackTrace();
			return false;
		} 
		
		return true;
	}

	@Override
	public List<DtoProvisionSuplido> getProvisionSuplidos(Long idTrabajo) {

		Trabajo trabajo = findOne(idTrabajo);
		List<DtoProvisionSuplido> provisionesSuplidos = new ArrayList<DtoProvisionSuplido>();
		
		
		for (TrabajoProvisionSuplido provisionSuplido : trabajo.getProvisionSuplido()) {
			DtoProvisionSuplido dtoProvisionSuplido = new DtoProvisionSuplido();
			
			try {
				
				dtoProvisionSuplido.setIdProvisionSuplido(String.valueOf(provisionSuplido.getId()));
				beanUtilNotNull.copyProperties(dtoProvisionSuplido, provisionSuplido);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			dtoProvisionSuplido.setTipoCodigo(provisionSuplido.getTipoAdelanto().getCodigo());
			dtoProvisionSuplido.setTipoDescripcion(provisionSuplido.getTipoAdelanto().getDescripcion());
			
			provisionesSuplidos.add(dtoProvisionSuplido);
		}
		
		return provisionesSuplidos;
		
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createProvisionSuplido(DtoProvisionSuplido provisionSuplidoDto, Long idTrabajo) {
		
		Trabajo trabajo = trabajoDao.get(idTrabajo);
		
		try {
			TrabajoProvisionSuplido provisionSuplido = new TrabajoProvisionSuplido();
			provisionSuplido.setTrabajo(trabajo);
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", provisionSuplidoDto.getTipoCodigo());
			DDTipoAdelanto tipoAdelanto = (DDTipoAdelanto) genericDao.get(DDTipoAdelanto.class, filtro);
			provisionSuplido.setTipoAdelanto(tipoAdelanto);

			beanUtilNotNull.copyProperties(provisionSuplido, provisionSuplidoDto);
			
			genericDao.save(TrabajoProvisionSuplido.class, provisionSuplido);			

			actualizarImporteTotalTrabajo(idTrabajo);

		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveProvisionSuplido(DtoProvisionSuplido provisionSuplidoDto) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(provisionSuplidoDto.getIdProvisionSuplido()));
		TrabajoProvisionSuplido provisionSuplido = genericDao.get(TrabajoProvisionSuplido.class, filtro);
		
		try {
			
			beanUtilNotNull.copyProperties(provisionSuplido, provisionSuplidoDto);
			
			if(!Checks.esNulo(provisionSuplidoDto.getTipoCodigo())) {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", provisionSuplidoDto.getTipoCodigo());
				DDTipoAdelanto tipoAdelanto = (DDTipoAdelanto) genericDao.get(DDTipoAdelanto.class, filtro);
				provisionSuplido.setTipoAdelanto(tipoAdelanto);
			}			
						
			genericDao.save(TrabajoProvisionSuplido.class, provisionSuplido);			
			
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteProvisionSuplido(Long id) {
		try {		
			genericDao.deleteById(TrabajoProvisionSuplido.class, id);
			
		} catch (Exception e) {			
			e.printStackTrace();
			return false;
		} 
		
		return true;
	}
	
	@Override
	public Boolean comprobarExisteAdjuntoTrabajo(Long idTrabajo, String codigoDocumento){

		Filter idTrabajoFilter = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", idTrabajo);
		Filter codigoDocumentoFilter = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo", codigoDocumento);

		//AdjuntoTrabajo adjuntoTrabajo = (AdjuntoTrabajo) genericDao.get(AdjuntoTrabajo.class, idTrabajoFilter, codigoDocumentoFilter);
		List<AdjuntoTrabajo> adjuntosTrabajo = genericDao.getList(AdjuntoTrabajo.class, idTrabajoFilter, codigoDocumentoFilter);

		if (!Checks.estaVacio(adjuntosTrabajo)){
			return true;
		} else {
			return false;
		}
	}


   @Override
   public String hoyDateServer(){
	   return groovyft.format(new Date());
   }
   
   @Override
   public String diffDate(String date1, String date2){
		Long datef1 = Long.valueOf(date1.replace("-", ""));
		Long datef2 = Long.valueOf(date2.replace("-", ""));
		if (datef1.equals(datef2)){
			return "IGUAL";
		} else if (datef1 > datef2){
			return "MAYOR";
		} else {
			return "MENOR";
		}
   }

   @Override
   public String getFechaSolicitudTrabajo(TareaExterna tareaExterna){
	   if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
			   || Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaSolicitud()))
		   return null;
	   else
		   return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaSolicitud());
   }
   
   @Override
   public String getFechaAprobacionTrabajo(TareaExterna tareaExterna){
	   if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
			   || Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaAprobacion()) )		   
		   return null;
	   else
		   return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaAprobacion());
   }
   
   @Override
   public String getFechaRechazoTrabajo(TareaExterna tareaExterna){
	   if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
			   || Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaRechazo()))
		   return null;
	   else
		   return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaRechazo());
   }
   
   @Override
   public String getFechaEleccionProveedorTrabajo(TareaExterna tareaExterna){
	   if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
			   || Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaEleccionProveedor()))
		   return null;
	   else
		   return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaEleccionProveedor());
   }
   
   @Override
   public String getFechaEjecutadoTrabajo(TareaExterna tareaExterna){
	   if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
			   || Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaEjecucionReal()))
		   return null;
	   else
		   return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaEjecucionReal());
   }
   
   @Override
   public String getFechaValidacionTrabajo(TareaExterna tareaExterna){
	   if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
			   || Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaValidacion()))
		   return null;
	   else
		   return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaValidacion());
   }
   
   @Override
   public String getFechaAnulacionTrabajo(TareaExterna tareaExterna){
	   if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
			   || Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaAnulacion()))
		   return null;
	   else
		   return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaAnulacion());
   }
   
   @Override
   public String getFechaCierreEcoTrabajo(TareaExterna tareaExterna){
	   if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
			   || Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaCierreEconomico()))
		   return null;
	   else
		   return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaCierreEconomico());
   }
   
   @Override
   public String getFechaPagoTrabajo(TareaExterna tareaExterna){
	   if (Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo())
			   || Checks.esNulo(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaPago()))
		   return null;
	   else
		   return groovyft.format(tareaActivoManager.getByIdTareaExterna(tareaExterna.getId()).getTramite().getTrabajo().getFechaPago());
   }
   
   
   
   private String getParticipacion(VActivosAgrupacionTrabajo activoAgrupacion){
		Double participacion = (Double) (!(Double.isNaN((activoAgrupacion.getImporteNetoContable()/activoAgrupacion.getSumaAgrupacionNetoContable() * 100))) ? (activoAgrupacion.getImporteNetoContable()/activoAgrupacion.getSumaAgrupacionNetoContable() * 100) : 0.0D);
		return Double.toString(participacion);
   }
 

}
package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.impl;


import java.io.File;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.logging.Logger;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.recovery.recobroCommon.contrato.dao.CicloRecobroContratoDao;
import es.pfsgroup.recovery.recobroCommon.core.manager.api.DiccionarioApi;
import es.pfsgroup.recovery.recobroCommon.core.model.RecobroAdjuntos;
import es.pfsgroup.recovery.recobroCommon.facturacion.manager.api.RecobroModeloFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api.RecobroAdjuntosDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api.RecobroProcesoFacturacionDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dto.RecobroProcesosFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api.RecobroProcesosFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroCobroPreprocesado;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroDDEstadoProcesoFacturable;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroDetalleFacturacion;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacion;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.serder.EditModelosFacturacionSubcarterasItem;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.serder.SubCarteraItem;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonProcesosFacturacionConstants;

@Service
public class RecobroProcesosFacturacionManager implements RecobroProcesosFacturacionApi{
	
	@Autowired
	private RecobroProcesoFacturacionDao recobroProcesoFacturacionDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private CicloRecobroContratoDao cicloRecobroContratoDao;
	
	@Autowired
	private RecobroAdjuntosDao recobroAdjuntosDao;
	
	@Resource
	private Properties appProperties;
	
	private AbstractMessageSource ms = MessageUtils.getMessageSource();
	
	/**
	 * @{inhericDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOFACTURACION_ULTIMAFECHA_BO)
	public String buscaUltimoPeriodoFacturado() {
		RecobroProcesoFacturacion ultimoProceso = recobroProcesoFacturacionDao.buscaUltimoProcesoFacturado();
		String ultimoPeriodo="";
		if (Checks.esNulo(ultimoProceso)){
			ultimoPeriodo ="No se ha liberado ningún proceso de Facturación";
		} else {
			ultimoPeriodo = "Desde "+ new SimpleDateFormat("dd/MM/yyyy").format(ultimoProceso.getFechaDesde())  +" hasta "+ new SimpleDateFormat("dd/MM/yyyy").format(ultimoProceso.getFechaHasta());
		}
		return ultimoPeriodo;
	}

	/**
	 * @{inhericDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_BUSCARPROCESOS_BO)
	public Page buscarProcesos(RecobroProcesosFacturacionDto dto) {
		return recobroProcesoFacturacionDao.buscaProcesoFacturacion(dto);
	}
	
	/**
	 * @{inhericDoc
	 */
	@Override
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_GETPROCESOSBYSTATE_BO)
	public List<RecobroProcesoFacturacion> getProcesosByState(String estado) {
		return recobroProcesoFacturacionDao.getProcesosByState(estado);
	}
	
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_CANCELARPROCESO_BO)
	@Override
	@Transactional(readOnly=false)
	public void cancelarProcesoFacturacion(Long idProceso) {
		AbstractMessageSource ms = MessageUtils.getMessageSource();
		
		RecobroProcesoFacturacion procesoFacturacion = recobroProcesoFacturacionDao.get(idProceso);
		if (!Checks.esNulo(procesoFacturacion)) {
			//Si esta cancelado no se puede volver a cancelar
			if (RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_CANCELADO.equals(procesoFacturacion.getEstadoProcesoFacturable().getCodigo())) {
				throw new BusinessOperationException(ms.getMessage("plugin.recobroCommon.recobroProcesosFacturacionManager.cancelarProcesoFacturacion.procCancelado", new Object[] {}, "**No se puede anular un proceso de facturación cancelado previamente", MessageUtils.DEFAULT_LOCALE));
			}
			//Si esta liberado no se puede eliminar, se cambia el estado a cancelado
			if (RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_LIBERADO.equals(procesoFacturacion.getEstadoProcesoFacturable().getCodigo())) {
				RecobroDDEstadoProcesoFacturable estadoProcesoFacturable = (RecobroDDEstadoProcesoFacturable) proxyFactory.proxy(DiccionarioApi.class).
						dameValorDiccionarioByCod(RecobroDDEstadoProcesoFacturable.class, RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_CANCELADO);
				procesoFacturacion.setEstadoProcesoFacturable(estadoProcesoFacturable);
				procesoFacturacion.setFechaCancelacion(new Date());
				procesoFacturacion.setUsuarioCancelacion(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado());
				recobroProcesoFacturacionDao.saveOrUpdate(procesoFacturacion);
			} else {
				//Si no es ninguno de los otros casos se puede borrar
				recobroProcesoFacturacionDao.delete(procesoFacturacion);
			}
		}
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOFACTURACION_GET_BO)
	public RecobroProcesoFacturacion getProcesoFacturacion(
			Long idProcesoFacturacion) {
		return recobroProcesoFacturacionDao.get(idProcesoFacturacion);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_SAVE_PROCESO_BO)
	@Transactional(readOnly=false)
	public void saveProcesoFacturacion(RecobroProcesosFacturacionDto dto) {
		if (!existenProcesosPtes()){
			RecobroProcesoFacturacion proceso = new RecobroProcesoFacturacion();
			proceso.setNombre(dto.getNombre());
			try {
				proceso.setFechaDesde(DateFormat.toDate(dto.getFechaDesde()));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			try {
				proceso.setFechaHasta(DateFormat.toDate(dto.getFechaHasta()));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			proceso.setUsuarioCreacion(usuarioLogado);
			proceso.setFechaCreacion(new Date());
			RecobroDDEstadoProcesoFacturable estadoProcesoFacturable = (RecobroDDEstadoProcesoFacturable) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoProcesoFacturable.class, RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE);
			proceso.setEstadoProcesoFacturable(estadoProcesoFacturable);
			recobroProcesoFacturacionDao.saveOrUpdate(proceso);
		} else {
			throw new BusinessOperationException(ms.getMessage("plugin.recobroConfig.procesoFacturacionManager.validaProcesosPendientes.error", new Object[] {}, "**No es posible crear una nueva facturación mientras haya otra en estado 'Pendiente'", MessageUtils.DEFAULT_LOCALE));
		}
		
	}

	

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_CAMBIA_ESTADO_PROCESO_BO)
	@Transactional(readOnly=false)
	public void cambiaEstadoProcesoFacturacion(Long id, String codigoEstado) {
		this.cambiaEstadoProcesoFacturacion(id, codigoEstado, null);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@Transactional(readOnly=false)
	public void cambiaEstadoProcesoFacturacion(Long id, String codigoEstado, String errorBatch) {
		
		RecobroProcesoFacturacion proceso = this.getProcesoFacturacion(id);
		if (proceso.getEstadoProcesoFacturable().getCodigo()!=codigoEstado){
			RecobroDDEstadoProcesoFacturable estado = (RecobroDDEstadoProcesoFacturable) proxyFactory.proxy(DiccionarioApi.class).dameValorDiccionarioByCod(RecobroDDEstadoProcesoFacturable.class, codigoEstado);
			if (!Checks.esNulo(estado)){
				String errores =compruebaCambioEstadoValido(proceso, estado);
				if (Checks.esNulo(errores)){
					proceso.setEstadoProcesoFacturable(estado);
					proceso.setErrorBatch(errorBatch);
					/* Si se pasa a pendiente hay que eliminar su relación con el adjunto */
					if (estado.getCodigo().equals(RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE)) {
						//RecobroAdjuntos factura = proceso.getFichero();
						//Borramos la relación
						proceso.setFichero(null);
						// Borramos el adjunto
						//if (!Checks.esNulo(factura)) { 
							
							//recobroAdjuntosDao.deleteById(factura.getId());
							
							
							/*Auditoria audit = factura.getAuditoria();
							audit.setBorrado(true);
							audit.setFechaBorrar(new Date());
							audit.setUsuarioBorrar("PRUEBA");
							
							factura.setAuditoria(audit);
							recobroAdjuntosDao.saveOrUpdate(factura);*/
						//}

					}
					
					if (estado.getCodigo().equals(RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_LIBERADO) || estado.getCodigo().equals(RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_CANCELADO)) { 
						Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
						//Actualizar fechas de cambios y el usuario que realiza el cambio
						if (estado.getCodigo().equals(RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_LIBERADO)) {
							proceso.setFechaLiberacion(new Date());
							proceso.setUsuarioLiberacion(usuarioLogado);
						}
						
						if (estado.getCodigo().equals(RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_CANCELADO)) {
							proceso.setFechaCancelacion(new Date());
							proceso.setUsuarioCancelacion(usuarioLogado);
						}
					}
					
					recobroProcesoFacturacionDao.save(proceso);
				} else {
					throw new BusinessOperationException(errores);
				}
				
			}
		}
		
		
		
		
	}

	private String compruebaCambioEstadoValido(RecobroProcesoFacturacion proceso,
			RecobroDDEstadoProcesoFacturable estado) {
		if (RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_LIBERADO.equals(estado.getCodigo())) {
			RecobroProcesosFacturacionDto dtoFechasInicio = new RecobroProcesosFacturacionDto();
			dtoFechasInicio.setEstadoProcesoFacturable(RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_LIBERADO);
			String fechaHasta = new SimpleDateFormat("yyyy-MM-dd").format(proceso.getFechaHasta());
			String fechaDesde = new SimpleDateFormat("yyyy-MM-dd").format(proceso.getFechaDesde());
			dtoFechasInicio.setFechaInicioHasta(fechaHasta);
			dtoFechasInicio.setFechaInicioDesde(fechaDesde);
			Page procesosInicio = recobroProcesoFacturacionDao.buscaProcesoFacturacion(dtoFechasInicio);

			if (procesosInicio.getTotalCount()>0){
				return ms.getMessage("plugin.recobroConfig.procesoFacturacionManager.validaCambioLiberar.fechasCoincidentes", new Object[] {}, "**Existen procesos de facturación liberados para esas fechas", MessageUtils.DEFAULT_LOCALE);
			}
			
			RecobroProcesosFacturacionDto dtoFechasFin = new RecobroProcesosFacturacionDto();
			dtoFechasFin.setEstadoProcesoFacturable(RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_LIBERADO);
			dtoFechasFin.setFechaFinHasta(fechaHasta);
			dtoFechasFin.setFechaFinDesde(fechaDesde);
			Page procesosFin = recobroProcesoFacturacionDao.buscaProcesoFacturacion(dtoFechasFin);

			if (procesosFin.getTotalCount()>0){
				return ms.getMessage("plugin.recobroConfig.procesoFacturacionManager.validaCambioLiberar.fechasCoincidentes", new Object[] {}, "**Existen procesos de facturación liberados para esas fechas", MessageUtils.DEFAULT_LOCALE);
			}
			
		}
		
		if (RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE.equals(estado.getCodigo())) {
			List<RecobroProcesoFacturacion> procesosPendientes =recobroProcesoFacturacionDao.getProcesosByState(estado.getCodigo());
			
			if (procesosPendientes.size()>0) {
				return ms.getMessage("plugin.recobroConfig.procesoFacturacionManager.validaCambioPendiente.otrosPendientes", new Object[] {}, "**Ya existen otros procesos marcados como pendientes", MessageUtils.DEFAULT_LOCALE);
			}
		}
		return null;
		
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_BORRARDETALLE_BO)
	@Transactional(readOnly=false)
	public void borrarDetalleFacturacion(Long idDetalleFacturacion) {
		if (!Checks.esNulo(idDetalleFacturacion)){
			genericDao.deleteById(RecobroDetalleFacturacion.class, idDetalleFacturacion);
		}
		
	}
	
	

	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_GENERAREXCEL_PROCESOS_BO)
	@Transactional(readOnly=false)
	public FileItem generarExcelProcesosFacturacion(Long idProcesoFacturacion) {
		
		return this.generarExcelProcesosFacturacionGenerico(idProcesoFacturacion, false);
	}
	
	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_GENERAREXCELREDUCIDO_PROCESOS_BO)
	@Transactional(readOnly=false)
	public FileItem generarExcelProcesosFacturacionReducido(Long idProcesoFacturacion) {
		
		return this.generarExcelProcesosFacturacionGenerico(idProcesoFacturacion, true);
	}
	
	
	private FileItem generarExcelProcesosFacturacionGenerico(Long idProcesoFacturacion, Boolean reducido) {
		
		RecobroProcesoFacturacion procesoFacturacion = recobroProcesoFacturacionDao.get(idProcesoFacturacion);
		
		if (!Checks.esNulo(procesoFacturacion)) {
			//Si ya se ha generado el fichero se devuelve el persistido en la bd			
			if (!reducido && !Checks.esNulo(procesoFacturacion.getFichero())) {				
				return procesoFacturacion.getFichero().getFileItem();
			} 
			//Si ya se ha generado el fichero reducido se devuelve el persistido en la bd
			else if(reducido && !Checks.esNulo(procesoFacturacion.getFicheroReducido())) {				
				return procesoFacturacion.getFicheroReducido().getFileItem();
			}
		
			
			List<String> cabeceras = new ArrayList<String>();
			cabeceras.add("SubCartera");
			cabeceras.add("Total cobros");
			cabeceras.add("Total a pagar subcartera");
			
			cabeceras.add("Agencia");
			cabeceras.add("Total cobros Agencia");
			cabeceras.add("Total a pagar agencia");
			
			cabeceras.add("Nº Expediente");
			cabeceras.add("Contrato");
			cabeceras.add("Fecha de inicio episodio irregular");
			cabeceras.add("Aplicativo origen");
			cabeceras.add("Expediente");
			cabeceras.add("Identificador de cobro");
			cabeceras.add("Fecha cobro");
			cabeceras.add("Fecha valor cobro");
			
			cabeceras.add("Aplicativo origen");
			cabeceras.add("Importe cobro");
			cabeceras.add("Importe concepto facturable");
			cabeceras.add("Importe real facturable");
			cabeceras.add("Porcentaje");
			cabeceras.add("Importe a pagar");
			
			cabeceras.add("Origen cobro");
			cabeceras.add("Concepto cobro");
			
			List<List<String>> listaValores = new ArrayList<List<String>>();
			
			Locale currentLocale = new Locale("ES");
			NumberFormat numberFormat = NumberFormat.getNumberInstance(currentLocale);
			SimpleDateFormat dateFormat = (SimpleDateFormat)SimpleDateFormat.getDateInstance(SimpleDateFormat.SHORT, currentLocale);

			Float importeCobro = null;
			
			for (RecobroProcesoFacturacionSubcartera subCartera : procesoFacturacion.getProcesoSubcarteras()) {
				for (RecobroDetalleFacturacion detalle : subCartera.getDetallesFacturacion()) {

					List<String> filaValores = new ArrayList<String>();
			
					filaValores.add(subCartera.getSubCartera().getNombre());
					filaValores.add(numberFormat.format(subCartera.getTotalImporteCobros()));
					filaValores.add(numberFormat.format(subCartera.getTotalImporteFacturable()));
					
					filaValores.add(detalle.getAgencia().getNombre());
					filaValores.add(numberFormat.format(subCartera.getTotalCobrosAgencia(detalle.getAgencia().getId())));
					filaValores.add(numberFormat.format(subCartera.getTotalImporteCobrosAgencia(detalle.getAgencia().getId())));
					
					filaValores.add(detalle.getExpediente().getId().toString());
					filaValores.add(detalle.getContrato().getCodigoContrato());
					
					Date fechaInicioEpisodio =null; 
					
					RecobroCobroPreprocesado cobroPreprocesado = detalle.getCobroPagoPreprocesado();
					if (cobroPreprocesado != null){
						if (cobroPreprocesado.getFechaInicioEpisodioIrregular() != null){
							fechaInicioEpisodio = cobroPreprocesado.getFechaInicioEpisodioIrregular();
						}else{
							fechaInicioEpisodio = cobroPreprocesado.getFechaPosicionVencida();
						}
					}
					
					if (fechaInicioEpisodio!=null)
						filaValores.add(dateFormat.format(fechaInicioEpisodio));
					else
						filaValores.add("");
					
					filaValores.add(detalle.getCobroPago().getContrato().getAplicativoOrigen().getDescripcion());
					
					filaValores.add(detalle.getExpediente().getDescripcion());
					filaValores.add(detalle.getCobroPago().getCodigoCobro());
					filaValores.add(dateFormat.format(detalle.getFechaCobro()));
					filaValores.add(dateFormat.format(detalle.getCobroPago().getFechaValor()));
					
					filaValores.add(detalle.getCobroPago().getOrigenCobro().getDescripcion());
					
					importeCobro = detalle.getCobroPago().getImporte();
					if (importeCobro == null){
						importeCobro = 0.0F;
					}
					filaValores.add(numberFormat.format(importeCobro.doubleValue()));
					filaValores.add(numberFormat.format(detalle.getImporteConceptoFacturable().doubleValue()));
					filaValores.add(numberFormat.format(detalle.getImporteRealFacturable().doubleValue()));
					filaValores.add(numberFormat.format(detalle.getPorcentaje().doubleValue()));
					filaValores.add(numberFormat.format(detalle.getImporteAPagar().doubleValue()));
					
					filaValores.add(detalle.getCobroPago().getSubTipo().getDescripcion());
					filaValores.add(detalle.getTarifaCobro().getTipoTarifa().getDescripcion());
					
					if(reducido){
						if(detalle.getImporteAPagar() != 0){
							listaValores.add(filaValores);
						}
					}
					else{
						listaValores.add(filaValores);
					}
				}
			}
			
			HojaExcel excel = new HojaExcel();
			String rutaFicheroResultados = !Checks.esNulo(appProperties.getProperty("procesoFacturacion.rutaExcelDetalles")) ? 
							appProperties.getProperty("procesoFacturacion.rutaExcelDetalles") : "tmp" + File.separator;
			
			makeDir(rutaFicheroResultados);
			String nombreFicheroResultados = "procFactu_" +	procesoFacturacion.getId();
			if(reducido){
				nombreFicheroResultados+="_reducido";
			}
			nombreFicheroResultados += ".xls";	
			excel.crearNuevoExcel(rutaFicheroResultados + nombreFicheroResultados, cabeceras, listaValores,false, 50000);

			FileItem excelFileItem = new FileItem(excel.getFile());
			excelFileItem.setFileName(nombreFicheroResultados);
			excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
			excelFileItem.setLength(excel.getFile().length());
			
			if (!Checks.esNulo(excelFileItem)) {
				RecobroAdjuntos recobroAdjuntos = new RecobroAdjuntos(excelFileItem);
				recobroAdjuntos.setTipo(RecobroAdjuntos.TIPO_PROCESOS_FACTURACION);
				genericDao.save(RecobroAdjuntos.class, recobroAdjuntos);
				if(reducido){
					procesoFacturacion.setFicheroReducido(recobroAdjuntos);
				}
				else{
					procesoFacturacion.setFichero(recobroAdjuntos);
				}
				recobroProcesoFacturacionDao.saveOrUpdate(procesoFacturacion);
			}
			return excelFileItem;
		}
		
		return null;
	}
	
    private boolean makeDir(String rutaFicheros) {
    	
    	boolean ok = true;

    	//Comprobar si existe el directorio, si no crearlo
		File directorio = new File(rutaFicheros);
		if (!directorio.exists()) {
			ok = directorio.mkdirs();
		}
		
		return ok;
    }
    
    
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_GUARDARMODELOS)
	@Transactional(readOnly=false)
	public void guardarModelosFacturacionSubcarteras(
			EditModelosFacturacionSubcarterasItem gridItems) {
		List<SubCarteraItem> items = gridItems.getSubCarteraItems();
		
		Long idProcesoFacturacion = null;
		
		for (SubCarteraItem item : items){
			
				RecobroProcesoFacturacionSubcartera subcartera = getSubcarteraFacturacion(item.getIdSubcarteraFacturacion());
				if (!Checks.esNulo(item.getValor())){
					subcartera.setModeloFacturacionActual(proxyFactory.proxy(RecobroModeloFacturacionApi.class).getModeloFacturacion(item.getValor()));
				} else {
					subcartera.setModeloFacturacionActual(null);
				}
				genericDao.save(RecobroProcesoFacturacionSubcartera.class, subcartera);
				
				//Capturamos el proceso de facturación para luego pasarlo a pendiente
				idProcesoFacturacion = subcartera.getProcesoFacturacion().getId();
		}
		
		try {
			//Si tenemos capturado un id de proceso de facturación valido, lo pasamos al estado pendiente
			if (idProcesoFacturacion!=null) {
				this.cambiaEstadoProcesoFacturacion(idProcesoFacturacion,RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE);
			}
		} catch (BusinessOperationException e) {
			//No se ha podido cambiar a pendiente porque ya había otro proceso en este estado
			//Permitimos el cambio de subcarteras pero capturamos el error del cambio
		}
	}

	private RecobroProcesoFacturacionSubcartera getSubcarteraFacturacion(
			Long idSubcarteraFacturacion) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idSubcarteraFacturacion);
		return genericDao.get(RecobroProcesoFacturacionSubcartera.class, filtro);
	}
	
	private Boolean existenProcesosPtes() {
		Boolean existenMasProcesos = false;
		
		List<RecobroProcesoFacturacion> procesosPendientes = buscaProcesosFacturacionPendientes();
		if (!Checks.esNulo(procesosPendientes) && !Checks.estaVacio(procesosPendientes)){
			existenMasProcesos=true;
		}
		
		return existenMasProcesos;
	}

	private List<RecobroProcesoFacturacion> buscaProcesosFacturacionPendientes() {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "estadoProcesoFacturable.codigo",RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getList(RecobroProcesoFacturacion.class, filtro, filtroBorrado);
	}

}

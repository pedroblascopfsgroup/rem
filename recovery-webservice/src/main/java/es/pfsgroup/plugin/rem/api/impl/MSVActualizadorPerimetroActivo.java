package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.admision.evolucion.dao.ActivoAgendaEvolucionDao;
import es.pfsgroup.plugin.rem.activo.dao.impl.ActivoPatrimonioDaoImpl;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoGestionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSegmento;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class MSVActualizadorPerimetroActivo extends AbstractMSVActualizador implements MSVLiberator {

    protected final Log logger = LogFactory.getLog(getClass());
    
    private static final Integer CHECK_VALOR_SI = 1;
    private static final Integer CHECK_VALOR_NO = 0;
    private static final Integer CHECK_NO_CAMBIAR = -1;
    private static final String[] listaValidosPositivos = { "S", "SI" };
	private static final String[] listaValidosNegativos = { "N", "NO" };
	private static final String VALOR_NO = "2";

    @Autowired
    private ActivoAdapter activoAdapter;
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private UpdaterStateApi updaterState;
	
	@Autowired
	private ActivoPatrimonioDaoImpl activoPatrimonio;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;


	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PERIMETRO_ACTIVO;
	}
	

	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws JsonViewerException, IOException, ParseException, SQLException, Exception {
		return procesaFila(exc, fila, prmToken, new Object[0]);
	}

	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken, Object[] extraArgs) throws IOException, ParseException, JsonViewerException, SQLException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			// Variables temporales para asignar valores de filas excel
			Long numActivo = Long.parseLong(exc.dameCelda(fila, 0));
			Integer tmpIncluidoEnPerimetro = getCheckValue(exc.dameCelda(fila, 1));
			Integer tmpAplicaGestion = getCheckValue(exc.dameCelda(fila, 2));
			String tmpMotivoAplicaGestion = exc.dameCelda(fila, 3);
			Integer tmpAplicaComercializar = getCheckValue(exc.dameCelda(fila, 4));
			String tmpMotivoComercializacion = exc.dameCelda(fila, 5);
			String tmpMotivoNoComercializacion = exc.dameCelda(fila, 6);
			String tmpTipoComercializacion = exc.dameCelda(fila, 7);
			String tmpDestinoComercial = exc.dameCelda(fila, 8);
			String tmpTipoAlquiler = exc.dameCelda(fila, 9);
			Integer tmpAplicaFormalizar = getCheckValue(exc.dameCelda(fila, 10));
			String tmpMotivoAplicaFormalizar = exc.dameCelda(fila, 11);
			Integer tmpAplicaPublicar = getCheckValue(exc.dameCelda(fila, 12));
			String tmpMotivoAplicaPublicar = exc.dameCelda(fila, 13);
			String tmpEquipoGestion = exc.dameCelda(fila, 14);
			String tmpSegmento = exc.dameCelda(fila, 15);
			Integer tmpPerimetroMacc =  getCheckValue(exc.dameCelda(fila, 16));			
			String admision = exc.dameCelda(fila, 17);
			String motivoAdmision = exc.dameCelda(fila, 18);
			String checkOnEfectosComercializacion = exc.dameCelda(fila, 19);
			String visibleGestionComercial = exc.dameCelda(fila,20);
			String motivoGestionComercial = exc.dameCelda(fila,21);
			String exclusionValidaciones = exc.dameCelda(fila,22);
			String fechaCambio = exc.dameCelda(fila, 23);

			
			Activo activo = activoApi.getByNumActivo(numActivo);
			ActivoPatrimonio actPatrimonio = activoPatrimonio.getActivoPatrimonioByActivo(activo.getId());
			ActivoAgrupacionActivo activoAgrupacion = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId());

			
			// Evalua si ha encontrado un registro de perimetro para el activo
			// dado.
			// En caso de que no exista, crea uno nuevo relacionado sin datos
			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
			boolean propagarRestringida = false;
			
			// Perimetro Macc---------------------------
			if (CHECK_NO_CAMBIAR.equals(tmpPerimetroMacc) 
					&& DDTipoSegmento.CODIGO_SEGMENTO_MACC.equals(tmpSegmento)  
						&& (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tmpDestinoComercial)
								|| Checks.esNulo(tmpDestinoComercial) && !Checks.esNulo(activo.getActivoPublicacion()) && activo.getActivoPublicacion().getTipoComercializacion().getCodigo().equals(DDTipoComercializacion.CODIGO_SOLO_ALQUILER))){
												
				activo.setPerimetroMacc(CHECK_VALOR_SI);		
				
			}else if (!CHECK_NO_CAMBIAR.equals(tmpPerimetroMacc)) {
				activo.setPerimetroMacc(tmpPerimetroMacc);			
			}
			
			// Segmento---------------------------			
			if (!Checks.esNulo(tmpSegmento)) {
				activo.setTipoSegmento(genericDao.get(DDTipoSegmento.class, genericDao.createFilter(FilterType.EQUALS, "codigo" , tmpSegmento)));
			}else if(Checks.esNulo(tmpSegmento) && CHECK_VALOR_SI.equals(tmpPerimetroMacc) ) {
				activo.setTipoSegmento(genericDao.get(DDTipoSegmento.class, genericDao.createFilter(FilterType.EQUALS, "codigo" , DDTipoSegmento.CODIGO_SEGMENTO_MACC)));
			}
							
			perimetroActivo.setActivo(activo);
			
			// Incluido en perimetro ---------------------------
			if (!CHECK_NO_CAMBIAR.equals(tmpIncluidoEnPerimetro))
				perimetroActivo.setIncluidoEnPerimetro(tmpIncluidoEnPerimetro);

			// Si se quita del perimetro, forzamos el quitado de la gestión
			if (CHECK_VALOR_NO.equals(tmpIncluidoEnPerimetro)
					&& !CHECK_VALOR_NO.equals(perimetroActivo.getAplicaGestion()))
				tmpAplicaGestion = 0;

			// Aplica gestion ---------------------------
			if (!CHECK_NO_CAMBIAR.equals(tmpAplicaGestion)) {
				perimetroActivo.setAplicaGestion(tmpAplicaGestion);
				perimetroActivo.setFechaAplicaGestion(new Date());
			}
			if (!Checks.esNulo(tmpMotivoAplicaGestion))
				perimetroActivo.setMotivoAplicaGestion(tmpMotivoAplicaGestion);

			// Aplica comercializacion ---------------------------
			// Si se quita del perimetro, forzamos el quitado de
			// comercializacion y actualizar la situación comercial del activo a
			// No Comercializable
			if (CHECK_VALOR_NO.equals(tmpIncluidoEnPerimetro)
					&& !CHECK_VALOR_NO.equals(perimetroActivo.getAplicaComercializar()))
				tmpAplicaComercializar = 0;

			if (!CHECK_NO_CAMBIAR.equals(tmpAplicaComercializar)) {
				perimetroActivo.setAplicaComercializar(tmpAplicaComercializar);
				perimetroActivo.setFechaAplicaComercializar(new Date());
			}
			
			

			// Motivo para Si comercializar
			DDMotivoComercializacion ddmc = null;
			if (!Checks.esNulo(tmpMotivoComercializacion)) {
				ddmc = (DDMotivoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoComercializacion.class, tmpMotivoComercializacion.substring(0, 2));
				perimetroActivo.setMotivoAplicaComercializar(ddmc);
			}
			
			if(!Checks.esNulo(exc.dameCelda(fila, 4)) && DDCartera.isCarteraSareb(activo.getCartera()) && activoAgrupacion != null 
			&& DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(activoAgrupacion.getAgrupacion().getTipoAgrupacion().getCodigo())) {		
				List<ActivoAgrupacionActivo> activos= activoAgrupacion.getAgrupacion().getActivos();
				Date hoy =  new Date();
				for (ActivoAgrupacionActivo activoAgrupacionActivo : activos) {
					PerimetroActivo perimetroActivoAgrupacion = activoApi.getPerimetroByIdActivo(activoAgrupacionActivo.getActivo().getId());
					perimetroActivoAgrupacion.setAplicaComercializar(tmpAplicaComercializar);
					perimetroActivoAgrupacion.setFechaAplicaComercializar(hoy);
					if(ddmc != null) {
						perimetroActivoAgrupacion.setMotivoAplicaComercializar(ddmc);
					}
					activoApi.saveOrUpdatePerimetroActivo(perimetroActivoAgrupacion);
				}
			}
			
			
			// Motivo para No comercializar
			if (!Checks.esNulo(tmpMotivoNoComercializacion))
				perimetroActivo.setMotivoNoAplicaComercializar(tmpMotivoNoComercializacion);

			// Tipo de comercializacion en el activo
			if (!Checks.esNulo(tmpTipoComercializacion))
				activo.setTipoComercializar((DDTipoComercializar) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoComercializar.class, tmpTipoComercializacion.substring(0, 2)));

			// Perimetro de alquiler - Double Gestor
			if (!Checks.esNulo(tmpDestinoComercial)) {
				if (tmpDestinoComercial.substring(0, 2).equals(DDTipoComercializacion.CODIGO_VENTA)
						&& !Checks.esNulo(activo.getActivoPublicacion())
						&& (activo.getActivoPublicacion().getTipoComercializacion().getCodigo()
								.equals(DDTipoComercializacion.CODIGO_SOLO_ALQUILER)
								|| activo.getActivoPublicacion().getTipoComercializacion().getCodigo()
										.equals(DDTipoComercializacion.CODIGO_ALQUILER_VENTA))) {
					if (!Checks.esNulo(actPatrimonio)) {
						actPatrimonio.setCheckHPM(false);
					} else {
						// creamos el registro en la tabla si no existe.
						String username = genericAdapter.getUsuarioLogado().getUsername();
						Date fecha = new Date();
						actPatrimonio = new ActivoPatrimonio();
						actPatrimonio.setActivo(activo);
						actPatrimonio.setCheckHPM(false);
						Auditoria auditoria = new Auditoria();
						auditoria.setUsuarioCrear(username);
						auditoria.setFechaCrear(fecha);
						auditoria.setBorrado(false);
						actPatrimonio.setAuditoria(auditoria);
					}
					activoPatrimonio.save(actPatrimonio);
					// Actualizamos los gestores
					DtoActivoFichaCabecera dto = new DtoActivoFichaCabecera();
					dto.setTipoComercializacionCodigo(DDTipoComercializacion.CODIGO_VENTA);
					activoAdapter.updateGestoresTabActivoTransactional(dto, activo.getId());
				} else if ((tmpDestinoComercial.substring(0, 2).equals(DDTipoComercializacion.CODIGO_SOLO_ALQUILER)
						|| tmpDestinoComercial.substring(0, 2).equals(DDTipoComercializacion.CODIGO_ALQUILER_VENTA))
						&& !Checks.esNulo(activo.getActivoPublicacion()) && activo.getActivoPublicacion()
								.getTipoComercializacion().getCodigo().equals(DDTipoComercializacion.CODIGO_VENTA)) {
					if (!Checks.esNulo(actPatrimonio)) {
						actPatrimonio.setCheckHPM(true);
					} else {
						// creamos el registro en la tabla si no existe.
						String username = genericAdapter.getUsuarioLogado().getUsername();
						Date fecha = new Date();
						actPatrimonio = new ActivoPatrimonio();
						actPatrimonio.setActivo(activo);
						actPatrimonio.setCheckHPM(true);
						Auditoria auditoria = new Auditoria();
						auditoria.setUsuarioCrear(username);
						auditoria.setFechaCrear(fecha);
						auditoria.setBorrado(false);
						actPatrimonio.setAuditoria(auditoria);
					}
					activoPatrimonio.save(actPatrimonio);
					// Actualizamos los gestores
					DtoActivoFichaCabecera dto = new DtoActivoFichaCabecera();
					dto.setTipoComercializacionCodigo(DDTipoComercializacion.CODIGO_SOLO_ALQUILER);
					activoAdapter.updateGestoresTabActivoTransactional(dto, activo.getId());
				}
			}

			// Tipo de Destino comercial en el activo
			if (!Checks.esNulo(tmpDestinoComercial) && !Checks.esNulo(activo.getActivoPublicacion()))
				activo.getActivoPublicacion().setTipoComercializacion((DDTipoComercializacion) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoComercializacion.class, tmpDestinoComercial.substring(0, 2)));

			// Tipo de alquiler del activo
			if (!Checks.esNulo(tmpTipoAlquiler))
				activo.setTipoAlquiler((DDTipoAlquiler) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoAlquiler.class, tmpTipoAlquiler.substring(0, 2)));

			if (CHECK_VALOR_NO.equals(tmpAplicaComercializar)) {
				// Si Comercializar es NO, forzamos también a NO => Formalizar
				// (por si no venía informado)
				tmpAplicaFormalizar = CHECK_VALOR_NO;

				// Comprobamos si es necesario actualizar el estado de
				// publicación del activo.
			}
			
			
			if(activoAgrupacion != null && DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(activoAgrupacion.getAgrupacion().getTipoAgrupacion().getCodigo())
					&& (!Checks.esNulo(visibleGestionComercial) || !Checks.esNulo(exclusionValidaciones))) {
				
				Boolean checkGestorComercialAg = null;
				Date fecha = new Date();
				DDSinSiNo validacion = null;
				DDMotivoGestionComercial motivo = null;
				if(!Checks.esNulo(visibleGestionComercial)) {
					if(Arrays.asList(listaValidosPositivos).contains(visibleGestionComercial.toUpperCase())) {
						checkGestorComercialAg = true;
					}else {
						checkGestorComercialAg = false;
					}
					
					if(!Checks.esNulo(fechaCambio)) {
						SimpleDateFormat sdfSal = new SimpleDateFormat("dd/MM/yyyy"); 
						fecha = sdfSal.parse(fechaCambio);
					}
				}
						
				if(!Checks.esNulo(exclusionValidaciones)) {
					validacion = getCheckValueToDDSinSiNo(exclusionValidaciones);
					if(!Checks.esNulo(motivoGestionComercial) && validacion != null && DDSinSiNo.CODIGO_SI.equalsIgnoreCase(validacion.getCodigo())) {
						motivo = (DDMotivoGestionComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoGestionComercial.class, motivoGestionComercial);
					}
				}
					
				List<ActivoAgrupacionActivo> activos= activoAgrupacion.getAgrupacion().getActivos();
				
				for (ActivoAgrupacionActivo activoAgrupacionActivo : activos) {
					PerimetroActivo perimetroActivoAgrupacion = activoApi.getPerimetroByIdActivo(activoAgrupacionActivo.getActivo().getId());
					if(checkGestorComercialAg != null) {
						perimetroActivoAgrupacion.setCheckGestorComercial(checkGestorComercialAg);
						perimetroActivoAgrupacion.setFechaGestionComercial(fecha);
					}
					if(!Checks.esNulo(exclusionValidaciones)) {
						perimetroActivoAgrupacion.setExcluirValidaciones(validacion);
						perimetroActivoAgrupacion.setMotivoGestionComercial(motivo);
					}
						
					activoApi.saveOrUpdatePerimetroActivo(perimetroActivoAgrupacion);
				}
					

			}else if(!Checks.esNulo(visibleGestionComercial) || !Checks.esNulo(exclusionValidaciones)){
				if(!Checks.esNulo(visibleGestionComercial)) {
					if(Arrays.asList(listaValidosPositivos).contains(visibleGestionComercial.toUpperCase())) {
						perimetroActivo.setCheckGestorComercial(true);
					}else {
						perimetroActivo.setCheckGestorComercial(false);
					}
					Date fecha = new Date();
					if(!Checks.esNulo(fechaCambio)) {
						SimpleDateFormat sdfSal = new SimpleDateFormat("dd/MM/yyyy"); 
						fecha = sdfSal.parse(fechaCambio);
					}
					perimetroActivo.setFechaGestionComercial(fecha);
				}
						
				if(!Checks.esNulo(exclusionValidaciones)) {
					DDSinSiNo validacion = getCheckValueToDDSinSiNo(exclusionValidaciones);
					perimetroActivo.setExcluirValidaciones(validacion);
					if(validacion != null ) {
						if(DDSinSiNo.CODIGO_SI.equalsIgnoreCase(validacion.getCodigo())) {
							if(!Checks.esNulo(motivoGestionComercial)) {
								perimetroActivo.setMotivoGestionComercial((DDMotivoGestionComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoGestionComercial.class, motivoGestionComercial));
							}
						}else {
							perimetroActivo.setMotivoGestionComercial(null);
						}
					}
					if(DDSinSiNo.CODIGO_NO.equals(validacion.getCodigo())) {
						perimetroActivo.setMotivoGestionComercial(null);
					}
				}
			}

			// Aplica Formalizar ---------------------------
			if (!CHECK_NO_CAMBIAR.equals(tmpAplicaFormalizar)) {
				perimetroActivo.setAplicaFormalizar(tmpAplicaFormalizar);
				perimetroActivo.setFechaAplicaFormalizar(new Date());
			}

			if (!Checks.esNulo(tmpMotivoAplicaFormalizar))
				perimetroActivo.setMotivoAplicaFormalizar(tmpMotivoAplicaFormalizar);

			// Si se quita del perimetro, forzamos el quitado de la publicación
			if (CHECK_VALOR_NO.equals(tmpIncluidoEnPerimetro) && perimetroActivo.getAplicaPublicar())
				tmpAplicaPublicar = 0;

			// Aplica Publicar ---------------------------
			if (!CHECK_NO_CAMBIAR.equals(tmpAplicaPublicar)) {
				perimetroActivo.setAplicaPublicar(BooleanUtils.toBooleanObject(tmpAplicaPublicar));
				perimetroActivo.setFechaAplicaPublicar(new Date());
			}

			if (!Checks.esNulo(tmpMotivoAplicaPublicar))
				perimetroActivo.setMotivoAplicaPublicar(tmpMotivoAplicaPublicar);
			
			// Equipo de Gestion	
			if (!Checks.esNulo(tmpEquipoGestion))
				activo.setEquipoGestion((DDEquipoGestion) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDEquipoGestion.class, tmpEquipoGestion.substring(0, 2)));
			
			// ---------------------------
			// Persiste los datos, creando el registro de perimetro
			// Todos los datos son de PerimetroActivo, a excepcion del tipo
			// comercializacion que es del Activo
			if (!Checks.esNulo(tmpTipoComercializacion) || !Checks.esNulo(tmpDestinoComercial)
					|| !Checks.esNulo(tmpTipoAlquiler))
				activoApi.saveOrUpdate(activo);
			// Si en la excel se ha indicado que NO esta en perimetro,
			// desmarcamos sus checks
			if (CHECK_VALOR_NO.equals(perimetroActivo.getIncluidoEnPerimetro()))
				this.desmarcarChecksFromPerimetro(perimetroActivo);
			
			//Actualizar admision del activo

			if(admision != null && Arrays.asList(listaValidosPositivos).contains(admision.toUpperCase())) {
				DDEstadoAdmision estadoAdmision =  (DDEstadoAdmision) utilDiccionarioApi.dameValorDiccionarioByCod(
						DDEstadoAdmision.class, DDEstadoAdmision.CODIGO_NUEVA_ENTRADA);
				DDSubestadoAdmision subestadoAdmision =  (DDSubestadoAdmision) utilDiccionarioApi.dameValorDiccionarioByCod(
						DDSubestadoAdmision.class, DDSubestadoAdmision.CODIGO_PENDIENTE_REVISION_ALTAS);
				perimetroActivo.setAplicaAdmision(true);
				perimetroActivo.setMotivoAplicaAdmision(motivoAdmision);
				perimetroActivo.setFechaAplicaAdmision(new Date());
				
				activo.setEstadoAdmision(estadoAdmision);
				activo.setSubestadoAdmision(subestadoAdmision);
			}
			
			if(admision != null && Arrays.asList(listaValidosNegativos).contains(admision.toUpperCase())) {
				perimetroActivo.setAplicaAdmision(false);
				activo.setEstadoAdmision(null);
				perimetroActivo.setMotivoAplicaAdmision(motivoAdmision);
				activo.setSubestadoAdmision(null);
			}
			
			if(checkOnEfectosComercializacion!=null && !checkOnEfectosComercializacion.isEmpty()) {
			    DDSinSiNo diccionario =  null;
	    
			    if(Arrays.asList(listaValidosPositivos).contains(checkOnEfectosComercializacion.toUpperCase())) {
			    	diccionario = (DDSinSiNo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_SI);
			        activo.setTieneObraNuevaAEfectosComercializacion(diccionario);					
			    }else if(Arrays.asList(listaValidosNegativos).contains(checkOnEfectosComercializacion.toUpperCase())){
			    	diccionario = (DDSinSiNo) utilDiccionarioApi.dameValorDiccionarioByCod( DDSinSiNo.class, DDSinSiNo.CODIGO_NO);
			        activo.setTieneObraNuevaAEfectosComercializacion(diccionario);
			    }
			    activo.setObraNuevaAEfectosComercializacionFecha(new Date());
			}

			activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);

			// Actualizar disponibilidad comercial del activo
			updaterState.updaterStateDisponibilidadComercial(activo);

			// Actualizar registro historico destino comercial del activo
			activoApi.updateHistoricoDestinoComercial(activo, extraArgs);
			
			

			activoApi.saveOrUpdate(activo);
			resultado.setCorrecto(true);
		} catch (Exception e) {
			resultado.setCorrecto(false);
			resultado.setErrorDesc(e.getMessage());
			logger.error("Error en MSVActualizadorPerimetroActivo",e);
		}
		
		
		return resultado;
	}
	
	@Override
	public void postProcesado(MSVHojaExcel exc) throws Exception {
		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		Integer numFilas = exc.getNumeroFilas();
		ArrayList<Long> idList = new ArrayList<Long>();
		ArrayList<Long> idListSinVisibilidadComercial = new ArrayList<Long>();
		try{
			for (int fila = this.getFilaInicial(); fila < numFilas; fila++) {
				Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
				idList.add(activo.getId());
				if(Checks.esNulo(exc.dameCelda(fila,19)) && Checks.esNulo(exc.dameCelda(fila,22))) {
					idListSinVisibilidadComercial.add(activo.getId());
				}
			}
			activoAdapter.actualizarEstadoPublicacionSincronoPerimetro(idList, idListSinVisibilidadComercial);
			transactionManager.commit(transaction);
		}catch(Exception e){
			transactionManager.rollback(transaction);
			throw e;
		}
		
	}
	
	/**
	 * Método que evalua el valor de un check en funcion de las columnas S/N/<nulo>
	 * @param cellValue
	 * @return
	 */
	private Integer getCheckValue(String cellValue){
		if(!Checks.esNulo(cellValue)){
			if("S".equalsIgnoreCase(cellValue) || String.valueOf(CHECK_VALOR_SI).equalsIgnoreCase(cellValue))
				return CHECK_VALOR_SI;
			else
				return CHECK_VALOR_NO;
		}
		
		return CHECK_NO_CAMBIAR;
		
	}
	
	/**
	 * Si se indica que esta fuera del perímetro, se desmarcan todos los checks
	 * @param perimetro
	 */
	private void desmarcarChecksFromPerimetro(PerimetroActivo perimetro) {
		
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaAsignarMediador())) {
			perimetro.setAplicaAsignarMediador(CHECK_VALOR_NO);
			perimetro.setFechaAplicaAsignarMediador(new Date());
		}
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaComercializar())) {
			perimetro.setAplicaComercializar(CHECK_VALOR_NO);
			perimetro.setFechaAplicaComercializar(new Date());
		}
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaFormalizar())) {
			perimetro.setAplicaFormalizar(CHECK_VALOR_NO);
			perimetro.setFechaAplicaFormalizar(new Date());
		}
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaGestion())) {
			perimetro.setAplicaGestion(CHECK_VALOR_NO);
			perimetro.setFechaAplicaGestion(new Date());
		}
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaTramiteAdmision())) {
			perimetro.setAplicaTramiteAdmision(CHECK_VALOR_NO);
			perimetro.setFechaAplicaTramiteAdmision(new Date());
		}
		if(!perimetro.getCheckGestorComercial()) {
			perimetro.setCheckGestorComercial(false);
			perimetro.setFechaGestionComercial(new Date());
		}
		if(perimetro.getAplicaPublicar()) {
			perimetro.setAplicaPublicar(BooleanUtils.toBooleanObject(CHECK_VALOR_NO));
			perimetro.setFechaAplicaTramiteAdmision(new Date());
		}
	}

	private DDSinSiNo getCheckValueToDDSinSiNo(String cellValue){
		DDSinSiNo diccionario = null;
		if(!Checks.esNulo(cellValue)){
			if(Arrays.asList(listaValidosPositivos).contains(cellValue.toUpperCase())) {		
				diccionario =  (DDSinSiNo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_SI);
			}else if(Arrays.asList(listaValidosNegativos).contains(cellValue.toUpperCase())) {
				diccionario = (DDSinSiNo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_NO);
			}
		}

		return diccionario;
		
	}

}

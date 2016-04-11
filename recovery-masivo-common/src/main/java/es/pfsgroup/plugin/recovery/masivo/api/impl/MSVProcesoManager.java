package es.pfsgroup.plugin.recovery.masivo.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.RevisionProcedimientoCoreDto;
import es.pfsgroup.plugin.recovery.masivo.MSVExcelParser;
import es.pfsgroup.plugin.recovery.masivo.api.MSVAsuntoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVLoteGeneratorApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcedimientoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.MSVProcedimientoBackOfficeBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal.MSVImpulsoProcesalBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM.MSVLanzarETJdesdeFMBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.callbacks.redaccDem.MSVRedaccDemBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVCarterizacionAcreditadosDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesoDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVRevisionProcedimientoDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVCarterizarAcreditadosDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.factories.MSVLoteGeneratorFactory;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVInputFactory;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVSelectorTipoInput;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResituarProcedimiento;
//import es.pfsgroup.plugin.recovery.masivo.model.MSVRevisionProcedimiento;
import es.pfsgroup.plugin.recovery.masivo.model.altas.MSVAltaAsunto;
import es.pfsgroup.plugin.recovery.masivo.model.altas.MSVAltaAsuntoJudicializado;
import es.pfsgroup.plugin.recovery.masivo.model.altas.MSVAltaLote;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVUtils;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAltaContratosColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAltaLotesColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVCancelaAsuColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVEnviarImprimirColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVLanzaETJdesdeFMColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVParalizaAsuColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVReorganizaAsuColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.masivo.utils.liberators.MSVLiberator;
import es.pfsgroup.plugin.recovery.masivo.utils.liberators.MSVLiberatorsFactory;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;

@SuppressWarnings("deprecation")
@Component
@Transactional(readOnly = false)
public class MSVProcesoManager implements MSVProcesoApi {
	
	public static final String TIPO_PROCEDIMIENTO_BACK_OFFICE = "P71";
	public static final String TIPO_PROCEDIMIENTO_FIN_MONITORIO = "P70";
	public static final String TIPO_PROCEDIMIENTO_ETJ = "P72";
	
	public static final String ESTADO_ASUNTO_FM = "08";
	
	public static final String PRINCIPAL_RESTANTE_ADICIONALCONTRATO = "num_extra6";
	
	public static final String COLUMNA_NUMERO_FILA = "NUM_FILA";
	public static final String COLUMNA_CONTRATO_NO_DISPONIBLE = "Contrato no disponible";
	//public static final String COLUMNA_VALIDADO = "Validado";
	public static final String COLUMNA_PRESENTACION_MANUAL = "Presentacion manual";
	public final static String PEFIL_SUPERADMINISTRADOR = "SUPER ADMINISTRADOR";
	public final static String PEFIL_SUPERVISOR_OFICINA_PROCESAL = "SUPERVISOR OFI. PROCESAL";
	public final static String PEFIL_SUPERVISOR_BO = "SUPERVISOR BACK OFFICE";
	
	private final String[] cabecerasImpulsoProcesal = {"Num. Caso NOVA", "TIPO PROCEDIMIENTO", "FECHA NOTIFICACION", "FECHA RESOLUCION", "TEXTO"};
	private final String[] camposInputImpulsoProcesal = {"d_observaciones", "d_fecRecepResolImpulso", "d_fecResolucionImpulso", "idAsunto", "d_numAutos"};

	private final String[] cabecerasRedaccionDemanda = {"Num. Caso NOVA", "FECHA REDACCION"};
	private final String[] camposInputRedaccionDemanda = {"idAsunto", "d_numAutos", "d_fecRedaccDemand", "d_observaciones"};
	
	private final String[] cabecerasCarterizacionAcreditados = {"CIF/NIF Acreditado","Nombre o Razon social", "Apellido1", "Apellido2", "Usuario gestor"};

	private final static String CODIGO_ETJ = "P72";
	
	@Autowired
	private MSVProcesoDao procesoDao;
	
	@Autowired
	private MSVFicheroDao ficheroDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired(required=false)
	MSVRevisionProcedimientoDao msvRevisionProcedimientoDao;
	
	@Autowired(required=false)
	MSVCarterizacionAcreditadosDao msvCarterizacionAcreditadosDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVInputFactory factoria;
	
	@Autowired
	private MSVLoteGeneratorFactory msvLoteGeneratorFactory;
	
	@Autowired
	private MSVLiberatorsFactory factoriaLiberators;
	
//	@Autowired
//	private Executor executor;

	@Override
	@BusinessOperation(MSV_BO_ALTA_PROCESO_MASIVO)
	public Long iniciarProcesoMasivo(MSVDtoAltaProceso dto) throws Exception {
		MSVProcesoMasivo procesoMasivo=procesoDao.crearNuevoProceso();
		
		if (!Checks.esNulo(dto.getIdTipoOperacion())){
			MSVDDOperacionMasiva tipoOperacion=genericDao.get(MSVDDOperacionMasiva.class,genericDao.createFilter(FilterType.EQUALS,"id", dto.getIdTipoOperacion()));
			if (!Checks.esNulo(tipoOperacion)){
				procesoMasivo.setTipoOperacion(tipoOperacion);
			}else {
				throw new BusinessOperationException("Necesitamos un tipo de operación válido para dar de alta un proceso masivo");
			}
		}else{
			throw new BusinessOperationException("Necesitamos un tipo de operación válido para dar de alta un proceso masivo");
		}
		
		MSVDDEstadoProceso estadoProceso=genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_CARGANDO));
		
		procesoMasivo.setDescripcion(dto.getDescripcion());
		procesoMasivo.setEstadoProceso(estadoProceso);
		
		procesoMasivo.setToken(proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).getToken());
		
		procesoDao.save(procesoMasivo);
		
		return procesoMasivo.getId();
	}

	@Override
	@BusinessOperation(MSV_BO_MODIFICACION_PROCESO_MASIVO)
	public MSVProcesoMasivo modificarProcesoMasivo(MSVDtoAltaProceso dto) throws Exception {
		MSVProcesoMasivo procesoMasivo;
		if (Checks.esNulo(dto.getIdProceso())){
			throw new BusinessOperationException("Necesitamos un id de proceso a modificar");
		} else {
			procesoMasivo=procesoDao.mergeAndGet(dto.getIdProceso());
		}
		if (!Checks.esNulo(procesoMasivo)){
			if (!Checks.esNulo(dto.getIdEstadoProceso())){
				MSVDDEstadoProceso estadoProceso=genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdEstadoProceso()));
				if(!Checks.esNulo(estadoProceso)){
					procesoMasivo.setEstadoProceso(estadoProceso);
				}	
			}else
			if (!Checks.esNulo(dto.getCodigoEstadoProceso())){
				MSVDDEstadoProceso estadoProceso=genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoEstadoProceso()));
				if(!Checks.esNulo(estadoProceso)){
					procesoMasivo.setEstadoProceso(estadoProceso);
				}
			}
		}
		procesoDao.mergeAndUpdate(procesoMasivo);
		return procesoMasivo;
	}
	
	//TODO de momento se utiliza el método modificar proceso masivo
//	@Override
//	@BusinessOperation(MSV_BO_CAMBIO_ESTADO_PROCESO_MASIVO)
//   public String cambioEstado(long idProceso) {
//
//		//necesito saber como implementar las llamadas update al ProcesoDAO		
//	   return null;
//   }
	
	@Override
	@BusinessOperation(MSV_BO_ELIMINAR_PROCESO )
   public String eliminarProceso(long idProceso){
		String resultado="ok";
		if (Checks.esNulo(idProceso)){
			resultado="ko";
		}else {
			MSVDocumentoMasivo fichero = ficheroDao.findByIdProceso(idProceso);
			if (fichero != null) ficheroDao.delete(fichero);
			procesoDao.deleteById(idProceso);
		} 
		return resultado;
   }
	
	

	
	@Override
	@BusinessOperation(MSV_BO_MOSTRAR_PROCESOS )
   public List<MSVProcesoMasivo> mostrarProcesos(){

		//TODO: Incorporar filtro de estados de los procesos
		
		List <MSVProcesoMasivo> listaProcesos=procesoDao.dameListaProcesos(this.getUsername());
				
		return listaProcesos;
	   
   }

	private String getUsername() {
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		String username=usu.getUsername();
		return username;
	}

	@Override
	@BusinessOperation(MSV_BO_MOSTRAR_PROCESOS_PAGINATED)
	public Page mostrarProcesosPaginated(MSVDtoFiltroProcesos dto) {
		
		dto.setUsername(this.getUsername());
		if(this.esUsuarioSuperAdministrador()){
			dto.setEsSupervisor(true);
		}else{
			dto.setEsSupervisor(this.esUsuarioSupervisor());
		}
		
		this.parseaColumnasOrder(dto);

		return procesoDao.dameListaProcesos(dto);

	}
	
	/**
	 * Comprueba si el usuario logado tiene perfil super administrador.
	 * @return
	 */
	private Boolean esUsuarioSuperAdministrador() {
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		return this.tienePerfil(MSVProcesoManager.PEFIL_SUPERADMINISTRADOR,usu);
	}
	
	/**
	 * Comprueba si el usuario logado tiene perfil super administrador.
	 * @return
	 */
	private Boolean esUsuarioSupervisor() {
		Boolean result = false;
		String perfiles[] = {MSVProcesoManager.PEFIL_SUPERVISOR_BO, MSVProcesoManager.PEFIL_SUPERVISOR_OFICINA_PROCESAL};
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		for (int i = 0; i < perfiles.length; i++) {
			result = this.tienePerfil(perfiles[i],usu);
			if(result) return true;			
		}
		return result;
	}
	
    /**
     * Comprueba si un usuario tiene un perfil determinado.
     * @param descripcionPerfil descripción del perfil.
     * @param u usuario
     * @return
     */
    private Boolean tienePerfil(String descripcionPerfil, Usuario u) {

    	if (u == null || descripcionPerfil == null) {
            return false;
        }

        for (Perfil p : u.getPerfiles()) {
        	if(descripcionPerfil.equals(p.getDescripcion()))
        		return true;
        }

        return false;
    }

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi#liberarFichero(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_BO_LIBERAR_FICHERO )
	public	MSVProcesoMasivo liberarFichero(Long idProceso) throws Exception {
		
		// Nos generamos un método de liberar por tipo de operación, porque cada tipo de operación
		// tendrá que generar un tipo de input diferente
		MSVDocumentoMasivo fichero= ficheroDao.findByIdProceso(idProceso);
		MSVDDOperacionMasiva tipoOperacion = null;
		if(!Checks.esNulo(fichero)){
			tipoOperacion = fichero.getProcesoMasivo().getTipoOperacion();
			
			if( comprobarTipoOperacionProcedimientoBackOffice(tipoOperacion)) {
				this.liberarTipoOperacionProcedimientoBackOffice(fichero);
			} else if(comprobarTipoOperacionAlta(tipoOperacion)){
				this.liberarTipoOperacionAlta(fichero, tipoOperacion);
			} else if(comprobarTipoOperacionImpulsoProcesal(tipoOperacion)){
				this.liberarTipoOperacionImpulsoProcesal(fichero, tipoOperacion);
			} else if(comprobarTipoOperacionRedaccionDemanda(tipoOperacion)){
				this.liberarTipoOperacionRedaccionDemanda(fichero, tipoOperacion);
			} else if(comprobarTipoOperacionLanzarTramite(tipoOperacion)){
				this.liberarTipoOperacionLanzarTramite(fichero, tipoOperacion);
			} else if (comprobarTipoOperacionCarterizacionAcreditados(tipoOperacion)){ 
				this.liberarTipoOperacionCarterizacionAcreditados(fichero, tipoOperacion);
			} else {
				MSVLiberator lib = factoriaLiberators.dameLiberator(tipoOperacion);
				if (!Checks.esNulo(lib)) lib.liberaFichero(fichero);
			}
		}
		
		MSVDtoAltaProceso dto = new MSVDtoAltaProceso();
		dto.setIdProceso(idProceso);

		//El envio de impresión masivo ya se procesa al liberar el fichero y se updatea el proceso con el estado correcto,
		//por lo que no hay que volver a cambiar el estado
		if (!MSVDDOperacionMasiva.CODIGO_ENVIO_IMPRESION.equals(tipoOperacion.getCodigo())) {
			dto.setCodigoEstadoProceso(comprobarPendienteProcesar(tipoOperacion));
		}
		MSVProcesoMasivo proceso=this.modificarProcesoMasivo(dto);
		
		return proceso;
		
	}


	/**
	 * Libera el fichero para el tipo de operación de Lanzar trámites
	 * @param fichero
	 * @param tipoOperacion
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	private void liberarTipoOperacionLanzarTramite(MSVDocumentoMasivo fichero,
			MSVDDOperacionMasiva tipoOperacion) throws IllegalArgumentException, IOException {
		
		String codigoOperacion = tipoOperacion.getCodigo();
		Map<String, Object> map = new HashMap<String, Object>();
		MSVHojaExcel exc = this.getHojaExcel(fichero);
		if (!Checks.esNulo(exc)) {
			List<String> listaCabeceras = exc.getCabeceras();
			
			for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
				map.put(COLUMNA_NUMERO_FILA, fila);
				for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {	
					map.put(listaCabeceras.get(columna), exc.dameCelda(fila, columna));
				}
				
				if (MSVDDOperacionMasiva.CODIGO_LANZAMIENTO_ETJ_DESDE_FM.equals(codigoOperacion)){					
					this.setInputLanzaETJdesdeFM(map, fichero.getProcesoMasivo());
				}
				map.clear();
			}
		}
		
	}

	/**
	 * Añade al input de lanzar tramites los datos necesarios para ejecutarlo desde peticiones pentientes y lo programa
	 * @param map
	 * @param procesoMasivo
	 */
	private void setInputLanzaETJdesdeFM(Map<String, Object> map, MSVProcesoMasivo procesoMasivo) {
		//Nos creamos un dto por cada fila del fichero
		RecoveryBPMfwkInputDto input=new RecoveryBPMfwkInputDto();
		
		Long idContrato = getLong((String)map.get(MSVLanzaETJdesdeFMColumns.NUM_NOVA));
		BigDecimal principal = MSVUtils.getBigDecimal((String)map.get(MSVLanzaETJdesdeFMColumns.PRINCIPAL));
		
//		Long idProcesoMasivo = procesoMasivo.getId();
		MSVDDOperacionMasiva msvDDOperacionMasiva = procesoMasivo.getTipoOperacion();
		
		if ((!Checks.esNulo(idContrato))) {
			
			EXTContrato contrato = genericDao.get(EXTContrato.class, genericDao.createFilter(FilterType.EQUALS, "nroContrato", idContrato ));
			DDEstadoAsunto ddEstadoAsuntoFM = genericDao.get(DDEstadoAsunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ESTADO_ASUNTO_FM));
			TipoProcedimiento tipoProcedimientoMonitorio = genericDao.get(TipoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", TIPO_PROCEDIMIENTO_FIN_MONITORIO));
//			MSVProcesoMasivo msvProcesoMasivo = genericDao.get(MSVProcesoMasivo.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcesoMasivo));
			
			if ((!Checks.esNulo(contrato)) && (!Checks.esNulo(ddEstadoAsuntoFM)) && (!Checks.esNulo(tipoProcedimientoMonitorio))) {
				List<Asunto> asuntos = contrato.getAsuntosActivos();
				for (Asunto asunto : asuntos) {
					if (asunto.getEstadoAsunto().getId().equals(ddEstadoAsuntoFM.getId())) {
						Procedimiento ultimoMonitorio = null;
						for (Procedimiento prc : asunto.getProcedimientos()) {
							
							if ( prc.getTipoProcedimiento().getId().equals(tipoProcedimientoMonitorio.getId())){
								if (Checks.esNulo(ultimoMonitorio)){
									ultimoMonitorio = prc;
								} else {
									if (ultimoMonitorio.getId()< prc.getId()){
										ultimoMonitorio = prc;
									}
								}
							}	
						}
						if (!Checks.esNulo(ultimoMonitorio)) {

								/*Si no se informa el Principal se obtiene del saldo recuperación del prc*/
//								map.put(MSVLanzaETJdesdeFMColumns.PRINCIPAL, (Checks.esNulo(principal) ? prc.getSaldoRecuperacion() : principal));
								map.put(MSVLanzaETJdesdeFMColumns.PRINCIPAL, principal);
								
								//Programamos el input para que se ejecute desde el batch
								//TODO FALTARÍA SABER EL TIPO DE INPUT QUE QUEREMOS GENERAR
								String tipoInput=buscarTipoInput(msvDDOperacionMasiva, map);
								input.setDatos(map);
								
								// TODO HABRÁ QUE MODIFICARLO CUANDO TENGAMOS LA CLASE DE TIPOS DE INPUTS
								input.setCodigoTipoInput(tipoInput.toString());
								
								input.setIdProcedimiento(ultimoMonitorio.getId());
								
								// nos creamos el callback específico de este tipo de operación				
								MSVLanzarETJdesdeFMBPMCallback callback= new MSVLanzarETJdesdeFMBPMCallback();
								
							try {
								proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).programaProcesadoInput(procesoMasivo.getToken(), input, callback);
							} catch (RecoveryBPMfwkError e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
					}
				}
			}
		}
	}

	/**
	 * Comprueba si el tipo de operación es un lanzamiento de Trámite masivo
	 * @param tipoOperacion
	 * @return
	 */
	private boolean comprobarTipoOperacionLanzarTramite(
			MSVDDOperacionMasiva tipoOperacion) {

		boolean resultado = false;
		
		if (tipoOperacion != null && tipoOperacion.getCodigo() != null &&
				tipoOperacion.getCodigo().equals(MSVDDOperacionMasiva.CODIGO_LANZAMIENTO_ETJ_DESDE_FM)) {
			resultado = true;
		}
		
		return resultado;
	}

	/**
	 * Comprueba si el tipo de operación es un impulso procesal masivo.
	 * @param tipoOperacion tipo de operación {@link MSVDDOperacionMasiva}
	 * @return true o false.
	 */
	private boolean comprobarTipoOperacionImpulsoProcesal(
			MSVDDOperacionMasiva tipoOperacion) {

		boolean resultado = false;
		
		if (tipoOperacion != null && tipoOperacion.getCodigo() != null &&
				tipoOperacion.getCodigo().equals(MSVDDOperacionMasiva.CODIGO_IMPULSO_PROCESAL)) {
			resultado = true;
		}
		
		return resultado;
	}

	/**
	 * Genera inputs de este tipo de operación por cada fila del fichero
	 * @param fichero
	 * @throws IOException 
	 * @throws IllegalArgumentException 
	 */
	private void liberarTipoOperacionImpulsoProcesal(
				MSVDocumentoMasivo fichero, MSVDDOperacionMasiva tipoOperacion)
			throws IllegalArgumentException, IOException {
		
		MSVHojaExcel exc = getHojaExcel(fichero);
		List<String> listaCabeceras=exc.getCabeceras();
		
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
			String numNova = null;
			Long tipoPrc = null;
			//Nos creamos un dto por cada fila del fichero
			RecoveryBPMfwkInputDto input=new RecoveryBPMfwkInputDto();
			// mapeamos el  dto con los valores de las columnas
			Map<String, Object> map = new HashMap<String, Object>();
			map.put(COLUMNA_NUMERO_FILA, fila);
			for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
				String dato = exc.dameCelda(fila, columna);
				//cabecerasImpulsoProcesal[0] = 'Num. CASO NOVA'
				if (listaCabeceras.get(columna).equals(cabecerasImpulsoProcesal[0])){
					numNova = dato;
				} 
				//cabecerasImpulsoProcesal[1] = 'TIPO PROCEDIMIENTO'
				else if (listaCabeceras.get(columna).equals(cabecerasImpulsoProcesal[1])){
					tipoPrc = Long.parseLong(dato);
				}
				//cabecerasImpulsoProcesal[2] = 'FECHA NOTIFICACION'
				else if (listaCabeceras.get(columna).equals(cabecerasImpulsoProcesal[2])){
					//Se añade LA FECHA DE RECEPCION DE RESOLUCION DE IMPULSO
					// Corregido el formato y quitando la parte de la hora
					dato = dato.replaceAll(" ", "/").substring(0, dato.length());
					map.put(camposInputImpulsoProcesal[1],dato);
				}
				//cabecerasImpulsoProcesal[3] = 'FECHA RESOLUCION'
				else if (listaCabeceras.get(columna).equals(cabecerasImpulsoProcesal[3])){
					//Se añade LA FECHA DE RESOLUCION DE IMPULSO
					// Corregido el formato y quitando la parte de la hora
					dato = dato.replaceAll(" ", "/").substring(0, dato.length());
					map.put(camposInputImpulsoProcesal[2],dato);
				}
				//cabecerasImpulsoProcesal[4] = 'TEXTO'
				else if (listaCabeceras.get(columna).equals(cabecerasImpulsoProcesal[4])){
					//Se añaden las OBSERVACIONES
					map.put(camposInputImpulsoProcesal[0],dato);
				}
			}
			
			Procedimiento procedimiento=proxyFactory.proxy(MSVProcedimientoApi.class).buscaProcedimientoDelContrato(numNova, tipoPrc);
			if(Checks.esNulo(procedimiento)){
				throw new BusinessOperationException("No se ha encontrado ningún procedimiento activo del tipo esperado para este contrato "+ numNova);
			}
			input.setIdProcedimiento(procedimiento.getId());
			//Se añade el asunto por defecto.
			map.put(camposInputImpulsoProcesal[3],procedimiento.getAsunto().getId());
			//Se añade el nº de autos
			map.put(camposInputImpulsoProcesal[4],procedimiento.getCodigoProcedimientoEnJuzgado());
			
			
			String tipoInput=buscarTipoInput(fichero.getProcesoMasivo().getTipoOperacion(), map);
			input.setDatos(map);
			input.setCodigoTipoInput(tipoInput.toString());
			
			// nos creamos el callback específico de este tipo de operación
			MSVImpulsoProcesalBPMCallback callback = new MSVImpulsoProcesalBPMCallback();
			
			try {
				proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).programaProcesadoInput(fichero.getProcesoMasivo().getToken(), input, callback);
			} catch (RecoveryBPMfwkError e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}	
		
	}

	/**
	 * Cambia el nombre de las columnas de ordenación para que coincidan con las del objeto de Hibernate.
	 * @param dto
	 */
	private void parseaColumnasOrder(PaginationParams dto) {
		
		String sort = dto.getSort();
		if (sort == null || sort.trim().length() == 0) {
			
			dto.setSort(" proc.auditoria.fechaCrear ");
			dto.setDir("DESC");
		}else{

			sort = sort.trim();
	
			// Parseamos todas las posibles columnas que pueden llegar del Dto
			if ("id".equals(sort)) {
				dto.setSort(" proc.id ");
			}
			else if("id".equals(sort)){
				dto.setSort(" proc.auditoria.fechaCrear ");
			}
			else if("nombre".equals(sort)){
				dto.setSort(" proc.descripcion ");
			}
			else if("idTipoOperacion".equals(sort)){
				dto.setSort(" proc.tipoOperacion.id ");
			}
			else if("tipoOperacion".equals(sort)){
				dto.setSort(" proc.tipoOperacion.descripcion ");
			}
			else if("idEstado".equals(sort)){
				dto.setSort(" proc.estadoProceso.id ");
			}
			else if("estado".equals(sort)){
				dto.setSort(" proc.estadoProceso.descripcion ");
			}
			else if("fecha".equals(sort)){
				dto.setSort(" proc.auditoria.fechaCrear ");
			}
			else if("usuario".equals(sort)){
				dto.setSort(" proc.auditoria.usuarioCrear ");
			}
		}
	}
	
	/**
	 * Crea un objeto {@link MSVAltaLote} ó {@link MSVAltaAsunto} por cada línea del fichero, 
	 * en función del tipo de operación.
	 * 
	 * @param fichero fichero los datos.
	 * @param tipoOperacion tipo de operación. MSVDDOperacionMasiva.CODIGO_ALTA_ASUNTOS ó MSVDDOperacionMasiva.CODIGO_ALTA_LOTES
	 * @throws IllegalArgumentException
	 * @throws IOException
	 */
	private void liberarTipoOperacionAlta(MSVDocumentoMasivo fichero,	MSVDDOperacionMasiva tipoOperacion) throws IllegalArgumentException, IOException {
		
		String codigoOperacion = tipoOperacion.getCodigo();
		Map<String, Object> map = new HashMap<String, Object>();
		MSVHojaExcel exc = this.getHojaExcel(fichero);
		if (!Checks.esNulo(exc)) {
			List<String> listaCabeceras = exc.getCabeceras();
			
			//Generamos el número de lote.
			String numeroLote = null;
			if (MSVDDOperacionMasiva.CODIGO_ALTA_ASUNTOS.equals(codigoOperacion) || MSVDDOperacionMasiva.CODIGO_ALTA_LOTES.equals(codigoOperacion)
				||MSVDDOperacionMasiva.CODIGO_ALTA_CARTERA_JUDICIALIZADA.equals(codigoOperacion)){
				//numeroLote = this.creaLote(codigoOperacion, fichero.getId(), new Date());
				numeroLote = this.creaLote(exc, tipoOperacion);
			}
			
			for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
				
				for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {	
					map.put(listaCabeceras.get(columna), exc.dameCelda(fila, columna));
				}
				
				if (MSVDDOperacionMasiva.CODIGO_ALTA_ASUNTOS.equals(codigoOperacion)){
					map.put(MSVAltaContratosColumns.N_LOTE, numeroLote);
					map.put(MSVAltaContratosColumns.ID_PROCESO_MASIVO, fichero.getProcesoMasivo());
					this.altaAsunto(map);
				}else if (MSVDDOperacionMasiva.CODIGO_ALTA_LOTES.equals(codigoOperacion)){
					map.put(MSVAltaLotesColumns.N_LOTE, numeroLote);
					map.put(MSVAltaLotesColumns.ID_PROCESO_MASIVO, fichero.getProcesoMasivo());
					this.altaLote(map);
				}else if (MSVDDOperacionMasiva.CODIGO_ALTA_CARTERA_JUDICIALIZADA.equals(codigoOperacion)){
					map.put(MSVAltaContratosColumns.N_LOTE, numeroLote);
					map.put(MSVAltaContratosColumns.ID_PROCESO_MASIVO, fichero.getProcesoMasivo());
					this.altaAsuntoJudicializado(map);
				}
				else if (MSVDDOperacionMasiva.CODIGO_REORGANIZACION_ASUNTOS.equals(codigoOperacion)) {
					this.altaReorganizaAsunto(map, fichero.getProcesoMasivo().getId());
				}else if (MSVDDOperacionMasiva.CODIGO_CANCELACION_ASUNTOS.equals(codigoOperacion)) {
					this.cancelaAsunto(map);
				}else if (MSVDDOperacionMasiva.CODIGO_PARALIZACION_ASUNTOS.equals(codigoOperacion)) {
					this.paralizaAsunto(map);
				}
				map.clear();
			}
		}
	}

	private String creaLote(MSVHojaExcel exc, MSVDDOperacionMasiva tipoOperacion) {
		
		MSVLoteGeneratorApi loteGenerator =  msvLoteGeneratorFactory.getBusinessObject();
		return loteGenerator.getNumeroLote(exc, tipoOperacion);
	}



	private void cancelaAsunto(Map<String, Object> map) {
		Long idContrato = getLong((String)map.get(MSVCancelaAsuColumns.NUM_NOVA));
		Date fechaCancelacion = getDate((String)map.get(MSVCancelaAsuColumns.FECHA_CANCELA));
		
		if (!Checks.esNulo(idContrato)) {
			EXTContrato contrato = genericDao.get(EXTContrato.class, genericDao.createFilter(FilterType.EQUALS, "nroContrato", idContrato ));
			if (!Checks.esNulo(contrato)) {
				List<Asunto> asuntos = contrato.getAsuntosActivos();
				for (Asunto asunto : asuntos) {
					 if(!Checks.esNulo(map.get(MSVCancelaAsuColumns.MOTIVO_CANCELA))){
						 String motivoCancelacion=(String) map.get(MSVCancelaAsuColumns.MOTIVO_CANCELA);
						 if(motivoCancelacion.equals("Archivado") || motivoCancelacion.equals("Inadmision"))
							 proxyFactory.proxy(MSVAsuntoApi.class).cancelaAsuntoConMotivo(asunto, fechaCancelacion,motivoCancelacion);
						 else
							 proxyFactory.proxy(MSVAsuntoApi.class).cancelaAsunto(asunto, fechaCancelacion);
					 }
					 else
						 proxyFactory.proxy(MSVAsuntoApi.class).cancelaAsunto(asunto, fechaCancelacion);
				}
			}
		}
	}

	private void paralizaAsunto(Map<String, Object> map) {
		Long idContrato = getLong((String)map.get(MSVParalizaAsuColumns.NUM_NOVA));
		Date fechaParalizacion = getDate((String)map.get(MSVParalizaAsuColumns.FECHA_PARALIZA));
		
		if (!Checks.esNulo(idContrato)) {
			EXTContrato contrato = genericDao.get(EXTContrato.class, genericDao.createFilter(FilterType.EQUALS, "nroContrato", idContrato ));
			if (!Checks.esNulo(contrato)) {
				List<Asunto> asuntos = contrato.getAsuntosActivos();
				for (Asunto asunto : asuntos) {
					 proxyFactory.proxy(MSVAsuntoApi.class).paralizaAsunto(asunto, fechaParalizacion);
				}
			}
		}
		
	}
	
	private static Date getDate(String fecha) {
		Date fechaCancelacion;
		
		if (!"".equals(fecha)) {
			try {
//				SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
//				fechaCancelacion = df.parse(fecha);
			
				if (fecha.length() > 10) {
					fecha = fecha.substring(0, 10);
				}
				fecha = fecha.replaceAll(" ", "").replaceAll("-", "").replaceAll("/", "");
				fechaCancelacion = new SimpleDateFormat("ddMMyyyy").parse(fecha);
				
			} catch (ParseException e) {
				fechaCancelacion = new Date();				
			}
		} else {
			fechaCancelacion = new Date();
		}
		return fechaCancelacion;
	}
	/**
	 * Crea un lote a partir de un mapa.
	 * @param map
	 */
	private void altaLote(Map<String, Object> map) {
		MSVAltaLote altaLote = MSVAltaLote.create(map);
		genericDao.save(MSVAltaLote.class, altaLote);
	}

	/**
	 * Crea un asunto a partir de un mapa.
	 * @param map
	 */
	private void altaAsunto(Map<String, Object> map) {
		MSVAltaAsunto altaAsunto = MSVAltaAsunto.create(map);
		genericDao.save(MSVAltaAsunto.class, altaAsunto);

	}
	
	/**
	 * Crea un asunto judicializado a partir de un mapa.
	 * @param map
	 */
	private void altaAsuntoJudicializado(Map<String, Object> map) {
		MSVAltaAsuntoJudicializado altaAsuntoJudicializado = MSVAltaAsuntoJudicializado.create(map);
		genericDao.save(MSVAltaAsuntoJudicializado.class, altaAsuntoJudicializado);
		
	}

	private static Long getLong(String valor){
		try{
			return Long.valueOf(valor);
		}catch (Exception ex){
			return null;
		}
		
	}
	
	
//	private static BigDecimal getBigDecimal(String valor) {
//		DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("es"));
//		DecimalFormat format = new DecimalFormat("0.#", symbols);
//		String valorRpl = valor.replace(".", String.valueOf(symbols.getDecimalSeparator()));
//		valorRpl = valorRpl.replace(",", String.valueOf(symbols.getDecimalSeparator()));
//		try {
//			return BigDecimal.valueOf(format.parse((valorRpl)).doubleValue());
////			String valorRpl = valor.replaceAll(",", ".");
////			return BigDecimal.valueOf(getDouble(valorRpl));
//		} catch (Exception ex) {
//			return null;
//		}
//	}
	
	
	
	/**
	 * Añade a la tabla de reorganizaciones el asunto correspondiente al contrato
	 * @param map
	 */
	private void altaReorganizaAsunto(Map<String, Object> map, Long idProcesoMasivo) {
		
		RevisionProcedimientoCoreDto dto = new RevisionProcedimientoCoreDto();
		
		Long idContrato = getLong((String)map.get(MSVReorganizaAsuColumns.NUM_NOVA));
		Long idTapTarea = getLong((String)map.get(MSVReorganizaAsuColumns.TAP_ID));
		
		Long idTipoProcedimiento = null;

		boolean resituar = false;
		
		if ((!Checks.esNulo(idContrato)) && (!Checks.esNulo(idTapTarea))) {
		
			EXTTareaProcedimiento tareaProcedimiento = genericDao.get(EXTTareaProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idTapTarea ));
			TipoProcedimiento tipoProcedimiento = null;
			if (!Checks.esNulo(tareaProcedimiento)) {
				tipoProcedimiento = tareaProcedimiento.getTipoProcedimiento();
				idTipoProcedimiento = tipoProcedimiento.getId();
				dto.setIdTipoProcedimiento(idTipoProcedimiento);
				dto.setIdActuacion(tipoProcedimiento.getTipoActuacion().getId());
				dto.setIdTarea(idTapTarea);
			}

			boolean encontrado = false;
			EXTContrato contrato = genericDao.get(EXTContrato.class, genericDao.createFilter(FilterType.EQUALS, "nroContrato", idContrato ));
			if (!Checks.esNulo(contrato) && !Checks.esNulo(idTipoProcedimiento)) {
				List<Asunto> asuntos = contrato.getAsuntosActivos();
				for (Asunto asunto : asuntos) {
					dto.setIdAsunto(asunto.getId());
					dto.setNombreAsunto(asunto.getNombre());
					List<Procedimiento> procedimientos = asunto.getProcedimientos();
					for (Procedimiento procedimiento : procedimientos) {
						if (procedimiento.getTipoProcedimiento().getId().equals(idTipoProcedimiento)) {
							resituar = true;
							dto.setIdProcedimiento(procedimiento.getId());
							encontrado = true;
							break;
						} else {
							if (dto.getIdProcedimiento() == null) {
								dto.setIdProcedimiento(procedimiento.getId());
							}
						}
					}
					if (encontrado) {
						break;
					}
				}
			}
			
			if (resituar) {
				dto.setInstrucciones("Resituación masiva");
				saveResituacion(dto, idProcesoMasivo);
			} else {
				dto.setInstrucciones("Reorganización masiva");
				saveRevision(dto, idProcesoMasivo);
			}
		}
		
	}
	
	/**
	 * Guarda un registro de tipo ResituarProcedimiento (equivale a RevisionProcedimiento pero sin salir del proc actual) 
	 * @param dto
	 */
	private void saveResituacion(RevisionProcedimientoCoreDto dto, Long idProcesoMasivo) {

		MSVResituarProcedimiento rp = new MSVResituarProcedimiento();
		Procedimiento prc = new Procedimiento();
		
		boolean ok = true;
		
		try {
			rp.setProcMasivoId(idProcesoMasivo);
			rp.setAsuId(dto.getIdAsunto());
			rp.setInstrucciones(dto.getInstrucciones());
			prc = genericDao.get(
					Procedimiento.class,
					genericDao.createFilter(FilterType.EQUALS, "id",
							dto.getIdProcedimiento()));
			rp.setProcedimiento(prc);
			rp.setTarId(dto.getIdTarea());
			rp.setTpoId(prc.getTipoProcedimiento().getId());
			rp.setTacId(prc.getTipoActuacion().getId());

			// Primero guardamos el registro en la tabla de resituar procs
			genericDao.save(MSVResituarProcedimiento.class, rp);
		} catch (Exception e) {
			ok = false;
		}

		// Ahora cambiamos el estado del procedimiento a 'Pendiente resituar'
		if (ok) {
			actualizarProcedimientos(prc);
		} 
		
	}

	/**
	 * Metodo que actualiza el procedimiento a Pendiente reorganización
	 * 
	 * @param prc
	 * @author oscar
	 */
	private boolean actualizarProcedimientos(Procedimiento prc) {

		try {
			DDEstadoProcedimiento ep = genericDao.get(DDEstadoProcedimiento.class,
					genericDao.createFilter(FilterType.EQUALS, "id",8L));
			prc.setEstadoProcedimiento(ep);
			finalizarTareasAsociadas(prc.getId());
			genericDao.save(Procedimiento.class, prc);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
	}
	
	/**
	 * Busca y finaliza las tareas asociadas de un procedimiento
	 * @param id
	 */
	private void finalizarTareasAsociadas(Long id) {
		
		Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<TareaNotificacion> list = genericDao.getList(TareaNotificacion.class, fBorrado, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", id));
		for(TareaNotificacion n: list){
			n.setTareaFinalizada(true);
			n.setFechaFin(new Date());
			genericDao.save(TareaNotificacion.class, n);
			
		}		
	}

	/**
	 * Comprueba si el tipo de operación es un alta.
	 * @param tipoOperacion tipo de operación {@link MSVDDOperacionMasiva}
	 * @return true o false.
	 */
	private boolean comprobarTipoOperacionAlta(MSVDDOperacionMasiva tipoOperacion) {

		if (tipoOperacion == null)
			return false;
		String codigoTipoOperacion=tipoOperacion.getCodigo();
		if(MSVDDOperacionMasiva.CODIGO_ALTA_ASUNTOS.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_ALTA_LOTES.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_REORGANIZACION_ASUNTOS.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_ALTA_CARTERA_JUDICIALIZADA.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_CANCELACION_ASUNTOS.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_PARALIZACION_ASUNTOS.equals(codigoTipoOperacion)
				)
			return true;
		return false;
		
	}
	
	/**
	 * Devuelve el estado del proceso si ya ha realizado todas las funciones la operación o queda alguna pendiente de ejecutar por batch
	 * @param tipoOperacion
	 * @return
	 */
	private String comprobarPendienteProcesar(MSVDDOperacionMasiva tipoOperacion) {
		if (tipoOperacion == null)
			return MSVDDEstadoProceso.CODIGO_PTE_PROCESAR;
		String codigoTipoOperacion=tipoOperacion.getCodigo();
		if(MSVDDOperacionMasiva.CODIGO_CANCELACION_ASUNTOS.equals(codigoTipoOperacion) ||
			MSVDDOperacionMasiva.CODIGO_PARALIZACION_ASUNTOS.equals(codigoTipoOperacion))
			return MSVDDEstadoProceso.CODIGO_PROCESADO;
		return MSVDDEstadoProceso.CODIGO_PTE_PROCESAR;
	}

	/**
	 * Crea una hoja excel de un fichero.
	 * @param fichero fichero excel.
	 * @return Hoja excel {@link MSVHojaExcel}
	 */
	private MSVHojaExcel getHojaExcel(MSVDocumentoMasivo fichero) {
		MSVHojaExcel exc;
		checkFichero(fichero);
		if (fichero.getContenidoFichero().getFile() != null) {
			exc = excelParser.getExcel(fichero.getContenidoFichero().getFile() );
		} else {
			exc = excelParser.getExcel(fichero.getDirectorio());
		}
		return exc;
	}

	private boolean comprobarTipoOperacionProcedimientoBackOffice(
			MSVDDOperacionMasiva tipoOperacion) {
		String codigoTipoOperacion=tipoOperacion.getCodigo();
		if(MSVDDOperacionMasiva.CODIGO_CONFIRMAR_RECEPCION_DOCUMENTACION_IMPRESA.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_CONFIRMAR_RECEPCION_JUSTIFICANTE_TASAS.equals(codigoTipoOperacion)||
				MSVDDOperacionMasiva.CODIGO_CONFIRMAR_RECEPCION_ORIGINAL.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_CONFIRMAR_RECEPCION_TESTIMONIO.equals(codigoTipoOperacion)||
				MSVDDOperacionMasiva.CODIGO_ENVIO_JUZGADO.equals(codigoTipoOperacion)||
				MSVDDOperacionMasiva.CODIGO_GENERAR_FICHERO_TASAS.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_REGENERAR_DOCUMENTACION.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_IMPRESION_DOCUMENTACION.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_SOLICITAR_TESTIMONIO.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_VALIDAR_FICHERO_TASAS.equals(codigoTipoOperacion) ||
				MSVDDOperacionMasiva.CODIGO_SOLICITAR_PAGO_TASAS.equals(codigoTipoOperacion)){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * Genera inputs de este tipo de operación por cada fila del fichero
	 * @param fichero
	 * @throws IOException 
	 * @throws IllegalArgumentException 
	 */
	private void liberarTipoOperacionProcedimientoBackOffice (MSVDocumentoMasivo fichero) throws IllegalArgumentException, IOException {
		MSVHojaExcel exc = getHojaExcel(fichero);
		List<String> listaCabeceras=exc.getCabeceras();
		
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
			
			//Nos creamos un dto por cada fila del fichero
			RecoveryBPMfwkInputDto input=new RecoveryBPMfwkInputDto();
			// mapeamos el  dto con los valores de las columnas
			Map<String, Object> map = new HashMap<String, Object>();
			map.put(COLUMNA_NUMERO_FILA, fila);
			for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {	
				if (listaCabeceras.get(columna).equals(MSVEnviarImprimirColumns.NUM_NOVA )){
					Procedimiento procedimiento=buscaProcedimientoDelContrato(exc.dameCelda(fila, columna), TIPO_PROCEDIMIENTO_BACK_OFFICE);
					if(Checks.esNulo(procedimiento)){
						throw new BusinessOperationException("No se ha encontrado ningún procedimiento activo del tipo esperado para este contrato "+ exc.dameCelda(fila, columna));
					}
					input.setIdProcedimiento(procedimiento.getId());
					//Se añade el asunto por defecto.
					map.put("idAsunto",procedimiento.getAsunto().getId());
				}
				map.put(listaCabeceras.get(columna), exc.dameCelda(fila, columna));
				
			}
			//TODO FALTARÍA SABER EL TIPO DE INPUT QUE QUEREMOS GENERAR
			String tipoInput=buscarTipoInput(fichero.getProcesoMasivo().getTipoOperacion(), map);
			input.setDatos(map);
			
			// TODO HABRÁ QUE MODIFICARLO CUANDO TENGAMOS LA CLASE DE TIPOS DE INPUTS
			input.setCodigoTipoInput(tipoInput.toString());
			
			// nos creamos el callback específico de este tipo de operación
			
			MSVProcedimientoBackOfficeBPMCallback callback= new MSVProcedimientoBackOfficeBPMCallback();
			
			try {
				proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).programaProcesadoInput(fichero.getProcesoMasivo().getToken(), input, callback);
			} catch (RecoveryBPMfwkError e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}	
		
	}
	
	/**
	 * 
	 * @param tipoOperacion para elegir el tipo de input que se debe generar
	 * @param map mapa con los valores de las columnas por si influyen en el tipo de input a generar
	 * @return devolverá un tipo objeto de tipo diccionario que contendrá el tipo de input que se debe de generar
	 */
	private String buscarTipoInput(MSVDDOperacionMasiva tipoOperacion,
			Map<String, Object> map) {
		
		MSVSelectorTipoInput s = factoria.dameSelector(tipoOperacion, map);
		String codigoTipoInput=s.getTipoInput(map);
		return codigoTipoInput;
	}

	/**
	 * 
	 * @param tipoOperacion para elegir el tipo de resolucion del que procede el tipo de input
	 * @param map mapa con los valores de las columnas por si influyen en el tipo de input a generar
	 * @return devolverá el código de tipo de resolución
	 */
	@SuppressWarnings("unused")
	private String buscarTipoResolucion(MSVDDOperacionMasiva tipoOperacion,
			Map<String, Object> map) {
		
		MSVSelectorTipoInput s = factoria.dameSelector(tipoOperacion, map);
		String codigoTipoResolucion=s.getTipoResolucion();
		return codigoTipoResolucion;
	}

	/**
	 * Devuelve el procedimiento del contrato, en caso de pasarle el tipo de procedimiento devolverá un proc. activo de ese tipo,
	 * si no se quiere comprobar el tipo se pasará tipoProcedimiento: null
	 * 
	 * @param valorCelda se le pasa el identificador del contrato nova
	 * @param tipoProcedimiento El tipo de procedimiento que queremos devolver, en caso de encontrar ninguno devolvera null
	 * 
	 * @return procedimiento activo al que pertenece ese contrato
	 */
	private Procedimiento buscaProcedimientoDelContrato(String valorCelda, String tipoProcedimiento) {
		Procedimiento p = null;
		Long valorCeldaLong=null;
		try {
			valorCeldaLong=Long.parseLong(valorCelda);
		} catch (Exception e) {
			throw new BusinessOperationException("El número del contrato no es válido");
		}
		Contrato c= genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "nroContrato", valorCeldaLong));
		
		List<Procedimiento> listaProcedimientosActivos = new ArrayList<Procedimiento>();
		
		 for (ExpedienteContrato e : c.getExpedienteContratos()) {
			 for (Asunto a : e.getExpediente().getAsuntos()){
				 if ( a.getEstaAceptado() || ESTADO_ASUNTO_FM.equals(a.getEstadoAsunto().getCodigo())){
					 for (Procedimiento procedimiento : a.getProcedimientos()){
						 if (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO.equals(procedimiento.getEstadoProcedimiento().getCodigo()) || 
								 DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO
						.equals(procedimiento.getEstadoProcedimiento().getCodigo())){
							 listaProcedimientosActivos.add(procedimiento);
						 }
					 }
				 }
			 }
		 }
		 
	
		for(Procedimiento proc : listaProcedimientosActivos){
			if (!Checks.esNulo(tipoProcedimiento)) {
				if(tipoProcedimiento.equals(proc.getTipoProcedimiento().getCodigo())){
					p=proc;
					break;
				}
			} else {					
				p=proc;
				// Si está aceptado y tiene asunto y nº de autos, no hace falta que siga buscando
				if ( p.getAsunto() != null
						&& p.getCodigoProcedimientoEnJuzgado() != null) {
					break;
				}
			}
		}
		
		return p;
	}

	/**
	 * Busca procedimiento de tipo P72 (ETJ) correspondiente al contrato.
	 * Si no lo encientra devuelve null.
	 * 
	 * @param valorCelda se le pasa el identificador del contrato nova
	 * @return procedimiento activo al que pertenece ese contrato
	 */
	@SuppressWarnings("unused")
	@Deprecated
	private Procedimiento buscaProcedimientoDelContratoETJ(String valorCelda) {
		
		Procedimiento p = null;
		Long valorCeldaLong=null;
		try {
			valorCeldaLong=Long.parseLong(valorCelda);
		} catch (Exception e) {
			throw new BusinessOperationException("El número del contrato no es válido");
		}
		
		Contrato c= genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "nroContrato", valorCeldaLong));
		if(!Checks.esNulo(c)){
			for(Procedimiento proc : c.getProcedimientos()){
				//p=proc;
				// Si está aceptado y tiene asunto y nº de autos, no hace falta que siga buscando
				if ((proc.getEstaAceptado() || DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO
						.equals(proc.getEstadoProcedimiento().getCodigo()))
						&& proc.getAsunto() != null
						//&& p.getCodigoProcedimientoEnJuzgado() != null
						&& proc.getTipoProcedimiento().getCodigo().equals(CODIGO_ETJ )) {
					p=proc;
					break;
				}
			}
		}
		return p;
	}
	
	
	/**
	 * verifica que el fichero contiene todos los valores necesarios
	 * @param fichero
	 */
	private void checkFichero(MSVDocumentoMasivo fichero) {
		if (fichero == null) {
			throw new IllegalStateException("El objeto fichero es nulo");
		}

		if (fichero.getContenidoFichero() == null) {
			throw new IllegalStateException("El objeto fichero no contiene un FileItem");
		}

		if (fichero.getContenidoFichero().getFile() == null) {
			throw new IllegalStateException("El objeto fichero conteiene un FileItem sin un File asociado");
		}
	}
	
	@BusinessOperation(MSV_BO_GETBYTOKEN)
	public MSVProcesoMasivo getByToken(Long tokenProceso) {
		return procesoDao.getByToken(tokenProceso);		
	}


// MÉTODOS COPIADOS DE RevisionProcedimientoManager.java (no funcionaban bien allí)
// FIXME: LA REVISIÓN NO FUNCIONA EN EL BATCH, depende de mejoras	
	//Depende de mejoras, no pueder ir al batch.
	private boolean saveRevision(RevisionProcedimientoCoreDto rp, Long procMasivoId) {



		if (rp.getIdActuacion() != null && rp.getIdTipoProcedimiento() != null && rp.getIdTarea() != null && rp.getInstrucciones() != null && rp.getIdAsunto() != null
				&& rp.getIdProcedimiento() != null) {

			msvRevisionProcedimientoDao.saveRevision(rp, procMasivoId);
			
			Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", rp.getIdProcedimiento()));
			// Ahora cambiamos el estado del procedimiento a 'Pendiente
			// reorganización' y de sus prc derivados
			return actualizarProcedimientosRevision(prc);

		}
		return false;

	}

	/**
	 * Metodo que actualiza el procedimiento a Pendiente reorganizaciï¿½n y todos
	 * sus prc derivados
	 */
	private boolean actualizarProcedimientosRevision(Procedimiento prc) {

		// Buscamos los procedimientos derivados
		try {
			List<ProcedimientoDerivado> derivados = prc.getProcedimientoDerivado();

			// Actualizamos el estado de todos los derivados y del proceso padre
			DDEstadoProcedimiento ep = genericDao.get(DDEstadoProcedimiento.class,
					genericDao.createFilter(FilterType.EQUALS, "id",8L));
			prc.setEstadoProcedimiento(ep);
			for (ProcedimientoDerivado d : derivados) {
				d.getProcedimiento().setEstadoProcedimiento(ep);
				genericDao.save(ProcedimientoDerivado.class, d);
				//Además, tenemos que dar por finalizadas las tareas de cada procedimiento
				finalizarTareasAsociadas(d.getProcedimiento().getId());
			}

			//ahora el proceso padre
			prc.setEstadoProcedimiento(ep);
			finalizarTareasAsociadas(prc.getId());
			genericDao.save(Procedimiento.class, prc);
			
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
	}
	

	
	/**
	 * Comprueba si el tipo de operación es una redacción demanda masiva.
	 * @param tipoOperacion tipo de operación {@link MSVDDOperacionMasiva}
	 * @return true o false.
	 */
	private boolean comprobarTipoOperacionRedaccionDemanda(
			MSVDDOperacionMasiva tipoOperacion) {

		boolean resultado = false;
		
		if (tipoOperacion != null && tipoOperacion.getCodigo() != null &&
				tipoOperacion.getCodigo().equals(MSVDDOperacionMasiva.CODIGO_REDACCION_DEMANDA)) {
			resultado = true;
		}
		
		return resultado;
	}

	/**
	 * Genera inputs de este tipo de operación por cada fila del fichero
	 * @param fichero
	 * @throws IOException 
	 * @throws IllegalArgumentException 
	 */
	private void liberarTipoOperacionRedaccionDemanda(
				MSVDocumentoMasivo fichero, MSVDDOperacionMasiva tipoOperacion)
			throws IllegalArgumentException, IOException {
		
		MSVHojaExcel exc = getHojaExcel(fichero);
		List<String> listaCabeceras=exc.getCabeceras();
		
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
			
			//Nos creamos un dto por cada fila del fichero
			RecoveryBPMfwkInputDto input=new RecoveryBPMfwkInputDto();
			// mapeamos el  dto con los valores de las columnas
			Map<String, Object> map = new HashMap<String, Object>();
			map.put(COLUMNA_NUMERO_FILA, fila);
			for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
				String dato = exc.dameCelda(fila, columna);
				//cabecerasRedaccionDemanda[0] = 'Num. CASO NOVA'
				if (listaCabeceras.get(columna).equals(cabecerasRedaccionDemanda[0])){
					Procedimiento procedimiento=buscaProcedimientoDelContrato(dato,CODIGO_ETJ);
					if(Checks.esNulo(procedimiento)){
						throw new BusinessOperationException("No se ha encontrado ningún procedimiento activo del tipo esperado para este contrato "+ dato);
					}
					input.setIdProcedimiento(procedimiento.getId());
					//Se añade el asunto por defecto.
					map.put(camposInputRedaccionDemanda[0],procedimiento.getAsunto().getId());
					//Se añade el nº de autos
					map.put(camposInputRedaccionDemanda[1],procedimiento.getCodigoProcedimientoEnJuzgado());
					//Se añade observaciones vacío
					map.put(camposInputRedaccionDemanda[3],"");
				} 
				//cabecerasRedaccionDemanda[1] = 'FECHA REDACCION'
				else if (listaCabeceras.get(columna).equals(cabecerasRedaccionDemanda[1])){
					//Se añade LA FECHA DE RECEPCION DE RESOLUCION DE IMPULSO
					// Corregido el formato y quitando la parte de la hora
					dato = dato.replaceAll(" ", "/").substring(0, 10);
					map.put(camposInputRedaccionDemanda[2],dato);
				}
			}
			String tipoInput=buscarTipoInput(fichero.getProcesoMasivo().getTipoOperacion(), map);
			input.setDatos(map);
			input.setCodigoTipoInput(tipoInput.toString());
			
			// nos creamos el callback específico de este tipo de operación
			MSVRedaccDemBPMCallback callback = new MSVRedaccDemBPMCallback();
			
			try {
				proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).programaProcesadoInput(fichero.getProcesoMasivo().getToken(), input, callback);
			} catch (RecoveryBPMfwkError e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}	
		
	}
	
	/**
	 * Genera inputs de este tipo de operación por cada fila del fichero
	 * @param fichero
	 * @throws IOException 
	 * @throws IllegalArgumentException 
	 */
	private void liberarTipoOperacionCarterizacionAcreditados(
				MSVDocumentoMasivo fichero, MSVDDOperacionMasiva tipoOperacion)
			throws IllegalArgumentException, IOException {
		
		MSVHojaExcel exc = getHojaExcel(fichero);
		List<String> listaCabeceras=exc.getCabeceras();
		
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
			
			MSVCarterizarAcreditadosDto dto = new MSVCarterizarAcreditadosDto();

			for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
				String dato = exc.dameCelda(fila, columna);
				if(listaCabeceras.get(columna).equals(cabecerasCarterizacionAcreditados[0])) {
					dto.setAcreditadoCif(dato);
				}
				if(listaCabeceras.get(columna).equals(cabecerasCarterizacionAcreditados[4])) {
					dto.setGestorUsername(dato);
				}
			}
			
			dto.setUsuariocrear(getUsername());
			dto.setProcesoMasivoId(fichero.getProcesoMasivo().getId());
			boolean resultado=msvCarterizacionAcreditadosDao.insertarRegistroOPMCarterizacion(dto);

			
		}	
	}
	
	/**
	 * Comprueba si el tipo de operación es de Carterizar Acreditados de forma masiva
	 * @param tipoOperacion tipo de operación {@link MSVDDOperacionMasiva}
	 * @return true o false.
	 */
	private boolean comprobarTipoOperacionCarterizacionAcreditados(MSVDDOperacionMasiva tipoOperacion) {

		boolean resultado = false;
		
		if (tipoOperacion != null && tipoOperacion.getCodigo() != null &&
				tipoOperacion.getCodigo().equals(MSVDDOperacionMasiva.CODIGO_CARTERIZACION_ACREDITADOS)) {
			resultado = true;
		}
		
		return resultado;
		
	}

}

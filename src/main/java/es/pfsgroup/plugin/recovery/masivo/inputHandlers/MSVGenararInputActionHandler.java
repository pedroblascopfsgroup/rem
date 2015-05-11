package es.pfsgroup.plugin.recovery.masivo.inputHandlers;


// movido al plugin de lindorffProcedimientos-bpm
public class MSVGenararInputActionHandler /*extends PROBaseActionHandler implements PROJBPMLeaveEventHandler*/ {

	/*
	private static final long serialVersionUID = 8267323591337593883L;
	
	@Autowired
	private MSVInputsTarea input;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;
	

	@Override
	public void onLeave(ExecutionContext executionContext) {
		Procedimiento procedimiento = getProcedimiento(executionContext);
		
		MSVConfiguradorInputs dto = mapeaDtoBusquedaConfigurarorInput(executionContext, procedimiento);
		
		MSVConfiguradorInputs configuracionInputTarea= input.obtenerConfiguracionInputTarea(dto);
		
		if (!Checks.esNulo(configuracionInputTarea)){
		// obtengo el tipo de input a partir del código del input
			RecoveryBPMfwkDDTipoInput tipoInput = genericDao.get(RecoveryBPMfwkDDTipoInput.class, genericDao.createFilter(FilterType.EQUALS, "codigo", configuracionInputTarea.getCodigoInput()));
			// compruebo si el input es de tipo generar documentación
			
			// mapear dto de generación de input
			RecoveryBPMfwkInputDto inputEjecutar=new RecoveryBPMfwkInputDto();
			if (!Checks.esNulo(tipoInput)){
				if (!Checks.esNulo(procedimiento)){
					inputEjecutar.setIdProcedimiento(procedimiento.getId());
				}
				inputEjecutar.setCodigoTipoInput(tipoInput.getCodigo());
				inputEjecutar.setDatos(mapeaDatos(inputEjecutar, procedimiento, configuracionInputTarea));
				
				//si es de tipo generar documentación compruebo si la documentación se genera en directo o en diferido
				if (configuracionInputTarea.getEjecucionDirecta()){
					try {
						proxyFactory.proxy(RecoveryBPMfwkRunApi.class).procesaInput(inputEjecutar);
					} catch (RecoveryBPMfwkError e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				} else {
					// si es en diferido hago la llamada al generar input batch para que el batch lo ejecute después
					MSVDocumentoPendienteDto dtoDocumentoPendiente =new MSVDocumentoPendienteDto();
					dtoDocumentoPendiente.setCodigoTipoInput(inputEjecutar.getCodigoTipoInput());
					dtoDocumentoPendiente.setCodigoTipoProcedimiento(procedimiento.getTipoProcedimiento().getCodigo());
					dtoDocumentoPendiente.setIdProcedimiento(procedimiento.getId());
					dtoDocumentoPendiente.setIdAsunto(procedimiento.getAsunto().getId());
					dtoDocumentoPendiente.setNumeroCasoNova(buscaCasoNova(procedimiento));
					dtoDocumentoPendiente.setCodigoEstado(MSVDDEstadoProceso.CODIGO_PTE_PROCESAR);
					dtoDocumentoPendiente.setToken(dameNuevoToken());
					MSVDocumentoPendienteGenerar documentoPendiente= proxyFactory.proxy(MSVDocumentoPendienteGenerarApi.class).crearNuevoDocumentoPendiente(dtoDocumentoPendiente);
					Long idToken=documentoPendiente.getToken();
					MSVInputGenerarDocumentacionBPMCallback callback = new MSVInputGenerarDocumentacionBPMCallback();
					try {
						proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).programaProcesadoInput(idToken, inputEjecutar, callback);
					} catch (RecoveryBPMfwkError e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				}
			}
		}
		
	}


	private Long dameNuevoToken() {
		try {
			return proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).getToken();
		} catch (RecoveryBPMfwkError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}


	private Long buscaCasoNova(Procedimiento procedimiento) {
		Long numeroCasoNova=null;
		if (!Checks.esNulo(procedimiento)){
			if (!Checks.esNulo(procedimiento.getProcedimientosContratosExpedientes())){
				if (!Checks.esNulo(procedimiento.getProcedimientosContratosExpedientes().get(0).getExpedienteContrato())){
					if (!Checks.esNulo(procedimiento.getProcedimientosContratosExpedientes().get(0).getExpedienteContrato().getContrato())){
						numeroCasoNova=procedimiento.getProcedimientosContratosExpedientes().get(0).getExpedienteContrato().getContrato().getNroContrato();
					}
				}
			}
		}
		
		return numeroCasoNova;
	}


	private MSVConfiguradorInputs mapeaDtoBusquedaConfigurarorInput(
			ExecutionContext executionContext, Procedimiento procedimiento) {
		MSVConfiguradorInputs dto=new MSVConfiguradorInputs();
		dto.setCodigoTarea(executionContext.getNode().getName());
		TareaExterna tex=getTareaExterna(executionContext);
		// TODO MODIFICAR PARA UTILIAR EL APIPROXYFACTORY EN LUGAR DEL EXECUTOR
		List<TareaExternaValor> listaValores=(List<TareaExternaValor>) executor.execute("tareaExternaManager.obtenerValoresTarea", tex.getId());
        
		if (!Checks.esNulo(procedimiento)){
			if (!Checks.esNulo(procedimiento.getAsunto().getProcurador())){
				dto.setTieneProcurador(true);;
			}else {
				dto.setTieneProcurador(false);
			}
			
		}
		dto.setAdmitido(compruebaTareaAdmitido(listaValores));
		dto.setAveriguacionPositiva(compruebaAveriguacionPositiva(executionContext));
		dto.setAveriguacionRepetida(compruebaAveriguacionRepetida(executionContext));
		dto.setFinalizado(compruebaFinalizacionProcedimiento(listaValores));
		dto.setPagado(compruebaProcedimientoPagado(executionContext));
		dto.setRequerimientoPago(compruebaRequerimientoPago(executionContext));
		dto.setSolicitadaCuenta(compruebaSolicitadaCuenta(executionContext));
		
		return dto;
	}


	private Boolean compruebaSolicitadaCuenta(ExecutionContext executionContext) {
		Boolean cuentaSolicitada=false;
		// TODO analizar como puedo comprobar estos datos
		return cuentaSolicitada;
	}


	private Boolean compruebaRequerimientoPago(ExecutionContext executionContext) {
		Boolean requerimientoPago=false;
		// TODO analizar como puedo comprobar estos datos
		return requerimientoPago;
	}


	private Boolean compruebaProcedimientoPagado(ExecutionContext executionContext) {
		Boolean pagado=false;
		// TODO analizar como puedo comprobar estos datos
		return pagado;
	}


	private Boolean compruebaFinalizacionProcedimiento(List<TareaExternaValor> listaValores) {
		Boolean finalizado=false;
		if (!Checks.esNulo(listaValores) && !Checks.estaVacio(listaValores)){
			for (TareaExternaValor valor : listaValores){
				if ("fechaAutoFin".equals(valor.getNombre()) && StringUtils.hasText(valor.getValor())){
					finalizado=true;
					break;
				}
			}
		}
		return finalizado;
	}


	private Boolean compruebaAveriguacionRepetida(ExecutionContext executionContext) {
		Boolean averiguacionRepetida=false;
		// TODO analizar como puedo comprobar estos datos
		return averiguacionRepetida;
	}


	private Boolean compruebaAveriguacionPositiva(ExecutionContext executionContext) {
		Boolean averiguacionPositiva=false;
		// TODO analizar como puedo comprobar estos datos
		return averiguacionPositiva;
	}


	private Boolean compruebaTareaAdmitido(List<TareaExternaValor> listaValores) {
		Boolean admitido=false;
		if (!Checks.esNulo(listaValores) && !Checks.estaVacio(listaValores)){
			for (TareaExternaValor valor : listaValores){
				if ("comboAdmision".equals(valor.getNombre()) && DDSiNo.SI.equals(valor.getValor())){
					admitido=true;
					break;
				}
			}
		}
		return admitido;
	}


	private Map<String, Object> mapeaDatos(RecoveryBPMfwkInputDto inputEjecutar, Procedimiento procedimiento, MSVConfiguradorInputs configuracionInput) {
		Map<String, Object> mapaValores=new HashMap<String, Object>();
		mapaValores.put("idAsunto", procedimiento.getAsunto().getId());
		// TODO aquí habrá que mapear los valores que vengan en la configuración del tipo de input
		// es posible que estos datos no sea necesario mapearlos porque ya los puede recoger el proceso de otro sitio
		return  mapaValores;
	}*/


	/**
	 * Mï¿½todo que devuelve el procedimiento al que estÃ¡ asociado el BPM en
	 * ejecuciÃ³n.
	 * 
	 * @return El procedimiento al que estÃ¡ asociado el BPM
	 */
	/*
	protected Procedimiento getProcedimiento(ExecutionContext executionContext) {

		Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento((Long) getVariable(PROCEDIMIENTO_TAREA_EXTERNA, executionContext));

		// TODO :AquÃ­ podrÃ­a recuperarse de la BD en caso de que no estuviera
		// en el contexto
		// Esto se podrÃ­a hacer consultando el
		// executionContext.getProcessInstance().getId() y que coincidiera con
		// un PRC_PROCEDIMIENTOS

		// Si el procedimiento es null no podemos saber a que PRC_PROCEDIMIENTO
		// hace referencia este BPM y por tanto no podemos crear tareas
		if (procedimiento == null) {
			String nombreProcedimiento = getNombreProceso(executionContext);

			// Destruimos el proceso BPM porque no podemos averiguar a que
			// procedimiento pertenece
			proxyFactory.proxy(JBPMProcessApi.class).destroyProcess(executionContext.getProcessInstance().getId());

			// Mostramos un mensaje de error
			String mensajeError = "El BPM en ejecuciï¿½n para el procedimiento " + nombreProcedimiento + " no tiene asociado un PRC_PROCEDIMIENTO y por tanto no puede continuar su ejecuciï¿½n";
			logger.error(mensajeError);

			throw new UserException("bpm.error.procedimientoNoDefinido");
		}

		return procedimiento;
	}
	*/

}

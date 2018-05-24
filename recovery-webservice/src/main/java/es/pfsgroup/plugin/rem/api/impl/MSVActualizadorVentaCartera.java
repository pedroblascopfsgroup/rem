package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVVentaDeCarteraExcelValidator;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResultadoProcesarFila;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDataDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;

@Component
public class MSVActualizadorVentaCartera extends AbstractMSVActualizador implements MSVLiberator {

	public static final int EXCEL_FILA_INICIAL = 3;
	public static final int EXCEL_COL_NUMACTIVO = 0;
	public static final String NOMBRE_AGRUPACION = "masivo.vc.agrupacion.nombre";
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	ActivoAdapter activoAdapter;

	@Autowired
	AgrupacionAdapter agrupacionAdapter;

	@Autowired
	ParticularValidatorApi particularValidatorApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	AgendaAdapter agendaAdapter;

	@Autowired
	ActivoTramiteApi activoTramiteApi;

	@Autowired
	ActivoTareaExternaApi activoTareaExternaApi;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Autowired
	private UvemManagerApi uvemManagerApi;

	
	@Resource
	MessageService messageServices;

	private MSVHojaExcel excel;
	private HashMap<String, String> listaAgrupaciones;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VENTA_DE_CARTERA;
	}

	@Override
	public int getFilaInicial() {
		return MSVActualizadorVentaCartera.EXCEL_FILA_INICIAL;
	}

	@Override
	public void preProcesado(MSVHojaExcel exc)
			throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		logger.debug("OFERTA_CARTERA: preProcesado del fichero: " + exc.getRuta());
		excel = exc;
		calcularImporteOferta(excel);
	}

	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		ActivoAgrupacion agrupacion = null;
		String codigoOferta = null;
		logger.debug("--------------------- OFERTA_CARTERA: procesando fila: " + fila
				+ " -------------------------------------------");
		if (!Checks.esNulo(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_UNICO_OFERTA))) {
			// CÓDIGO ÚNICO OFERTA
			codigoOferta = exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_UNICO_OFERTA);
			String descripcionAgrupacion = codigoOferta + "-" + prmToken.toString();
			Integer activoPrincipal = null;
			if (!particularValidatorApi.existeAgrupacionByDescripcion(descripcionAgrupacion)) {
				logger.debug("OFERTA_CARTERA: creando agrupación: " + descripcionAgrupacion);
				crearAgrupcacion(descripcionAgrupacion);
				// Añadimos datos a la agrupacion
				// USUARIO GESTOR COMERCIALIZACIÓN (USERNAME)
				agrupacion = modificarAgrupacion(
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.USU_GESTOR_COMERCIALIZACION),
						descripcionAgrupacion);
				activoPrincipal = 1;
			} else {
				agrupacion = obtenerAgrupacion(descripcionAgrupacion);
			}

			// Añadimos el activo a la agrupación
			// NUMERO ACTIVO

			anyadirActivoAgrupacion(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUM_ACTIVO_HAYA),
					agrupacion.getId(), activoPrincipal);

			// Si es el último activo con ese 'CÓDIGO ÚNICO OFERTA' del excel
			if (esUltimoActivoAgrupacion(codigoOferta, fila)) {
				// Creamos la oferta sobre a agrupacion
				// PRECIO VENTA NOMBRE RAZON SOCIAL TIPO DOC NUM DOC CÓDIGO
				// PRESCRIPTOR ID AGRUPACION
				// idUvem
				crearOfertaAgrupcion(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_UNICO_OFERTA),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NOMBRE_TITULAR),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.RAZON_SOCIAL_TITULAR),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.TIPO_DOCUMENTO_TITULAR),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.DOC_IDENTIFICACION_TITULAR),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_PRESCRIPTOR),
						agrupacion.getId(),
						Long.valueOf(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_CARTERA)));

				// Creamos un tramite para la oferta, y con ello el
				// expedienteComercial
				crearTramiteOferta(agrupacion.getId());
				// Comprobamos el porcentaje de compra de todos los titulares
				// para continuar
				if (comprobarParticipacion(exc, fila)) {
					// Añadimos el porcentaje correcto al comprador principal,
					// por defecto esta el 100%.
					modificarPorcentajePrincipal(agrupacion.getId(), Double.parseDouble(
							exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR)));

					// Añadimos el resto de TITULARES (Comprador) 2, 3 y 4.
					anyadirRestoCompradores(exc, fila, agrupacion.getId());

					// guardamos los datos que hacen falta para avanzar el exp
					// comercial
					guardarDatosNecesariosExpedienteComercial(exc, agrupacion.getId(), fila);
					
					// Avanzar el tramite de la oferta, en este paso se llama al
					// ALTA de uvem si los activos son de bankia
					avanzaPrimeraTarea(agrupacion.getId(),exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.COMITE_SANCIONADOR));

					// Llamar al servicioweb Modi de Bankia
					llamadaSercivioWeb(agrupacion.getId());
					// Esperamos 15 segundos por Bankia
					logger.debug(
							"--------------------- OFERTA_CARTERA: fin -------------------------------------------");
					Thread.sleep(15000);
				} else {
					throw new Exception(" El porcentaje de los compradores no suma el 100%");
				}
			}
		}

		HashMap<String, String> resultadoPorcesar = new HashMap<String, String>();
		// NUMERO ACTIVO HAYA
		resultadoPorcesar.put(codigoOferta,
				exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUM_ACTIVO_HAYA));
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.sethMap(resultadoPorcesar);
		return resultado;
	}

	/**
	 * Comprueba que la suma de los % de participación sume 100
	 * 
	 * @param exc
	 * @param fila
	 * @return
	 * @throws NumberFormatException
	 * @throws IllegalArgumentException
	 * @throws IOException
	 * @throws ParseException
	 */
	private boolean comprobarParticipacion(MSVHojaExcel exc, int fila)
			throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		return (((Checks.esNulo(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR)))
				? 0
				: (Double.parseDouble(
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR))))
				+ ((Checks.esNulo(
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR_2)))
								? 0
								: (Double.parseDouble(exc.dameCelda(fila,
										MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR_2))))
				+ ((Checks.esNulo(
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR_3)))
								? 0
								: (Double.parseDouble(exc.dameCelda(fila,
										MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR_3))))
				+ ((Checks.esNulo(
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR_4))) ? 0
								: (Double.parseDouble(exc.dameCelda(fila,
										MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR_4))))) == 100;
	}

	/**
	 * Guarda en el expediente comercial los datos necesarios para finalizar el
	 * expediente
	 * 
	 * @param exc
	 * @param idAgrupacion
	 * @param fila
	 * @throws Exception
	 */
	private void guardarDatosNecesariosExpedienteComercial(MSVHojaExcel exc, Long idAgrupacion, int fila)
			throws Exception {
		logger.debug("OFERTA_CARTERA: Guardamos datos en el expediente comercial");
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(listaOfertas.get(0).getIdOferta())));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);

			DtoCondiciones condicionantes = new DtoCondiciones();
			condicionantes
					.setTipoImpuestoCodigo(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.TIPO_IMPUESTO));
			condicionantes.setTipoAplicable(
					Double.valueOf(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.TIPO_APLICABLE)));

			expedienteComercialApi.saveCondicionesExpediente(condicionantes, expedienteComercial.getId());
			transactionManager.commit(transaction);
			logger.debug("OFERTA_CARTERA:[fin] Guardamos datos en el expediente comercial");
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

	/**
	 * Llama a los servicios web de uvem necesarios
	 * 
	 * @param idAgrupacion
	 * @throws Exception
	 */
	private void llamadaSercivioWeb(Long idAgrupacion) throws Exception {
		logger.debug("OFERTA_CARTERA: llamando a uvem");
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(listaOfertas.get(0).getIdOferta())));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);

			Activo primerActivo = oferta.getActivoPrincipal();

			if (Checks.esNulo(primerActivo)) {
				throw new Exception("La oferta no tiene activos");
			}

			if (DDCartera.CODIGO_CARTERA_BANKIA.equals(primerActivo.getCartera().getCodigo())) {
				Long porcentajeImpuesto = null;
				if (!Checks.esNulo(expedienteComercial.getCondicionante())) {
					if (!Checks.esNulo(expedienteComercial.getCondicionante().getTipoAplicable())) {
						porcentajeImpuesto = expedienteComercial.getCondicionante().getTipoAplicable().longValue();
					}
				}
				InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi
						.expedienteComercialToInstanciaDecisionList(expedienteComercial, porcentajeImpuesto, null);

				// modificar
				uvemManagerApi.modificarInstanciaDecision(instanciaDecisionDto);
				// modificar_honorarios
				instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_HONORARIOS);
				uvemManagerApi.modificarInstanciaDecisionTres(instanciaDecisionDto);
				// modificar_titulares
				instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_TITULARES);
				uvemManagerApi.modificarInstanciaDecisionTres(instanciaDecisionDto);
				// modificar_condicionantes
				instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_CONDICIONANTES_ECONOMICOS);
				uvemManagerApi.modificarInstanciaDecisionTres(instanciaDecisionDto);

				logger.debug("OFERTA_CARTERA: [fin]llamando a uvem");
			}
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}

	}

	/**
	 * Avanza la tarea "definicion de oferta"
	 * 
	 * @param idAgrupacion
	 * @return
	 * @throws Exception
	 */
	private Long avanzaPrimeraTarea(Long idAgrupacion,String codigoComite) throws Exception {
		logger.debug("OFERTA_CARTERA: Avanzamos la tarea");
		TransactionStatus transaction = null;
		Long idTareaExterna = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

			// Recuperamos el ExpedienteComercial
			List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(listaOfertas.get(0).getIdOferta())));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
			// Obtenemos el tramite del expediente, y de este sus tareas.
			List<ActivoTramite> listaTramites = activoTramiteApi
					.getTramitesActivoTrabajoList(expedienteComercial.getTrabajo().getId());
			List<TareaExterna> tareasTramite = activoTareaExternaApi
					.getActivasByIdTramiteTodas(listaTramites.get(0).getId());
			idTareaExterna = tareasTramite.get(0).getId();

			Map<String, String[]> valoresTarea = new HashMap<String, String[]>();
			valoresTarea
					.put("comite",
							new String[] { expedienteComercialApi
									.comiteSancionadorByCodigo(codigoComite)
									.getDescripcion() });
			valoresTarea.put("comboConflicto", new String[] { "02" });
			valoresTarea.put("comboRiesgo", new String[] { "02" });
			valoresTarea.put("fechaEnvio", new String[] { new Date().toString() });
			valoresTarea.put("comiteSuperior", new String[] { "02" });
			valoresTarea.put("observaciones", new String[] { "Masivo Venta cartera" });
			valoresTarea.put("idTarea", new String[] { tareasTramite.get(0).getTareaPadre().getId().toString() });

			agendaAdapter.save(valoresTarea);
			transactionManager.commit(transaction);

		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}

		return idTareaExterna;
	}

	/**
	 * Anyade los compraderes 2,3 y 4
	 * 
	 * @param exc
	 * @param fila
	 * @param idAgrupacion
	 * @throws Exception
	 */
	private void anyadirRestoCompradores(MSVHojaExcel exc, int fila, Long idAgrupacion) throws Exception {
		logger.debug("OFERTA_CARTERA: añadimos compradores");
		VBusquedaDatosCompradorExpediente vDatosComprador = null;
		int contadorColumnas = 0;
		for (int i = 0; i < 3; i++) {
			if (!Checks.esNulo(
					exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NOMBRE_TITULAR_2 + contadorColumnas))
					|| !Checks.esNulo(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.RAZON_SOCIAL_TITULAR_2 + contadorColumnas))) {

				TransactionStatus transaction = null;
				try {
					// Crea el comprador y la relacion con el expediente
					transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
					// Recuperamos el ExpedienteComercial
					List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter
							.getListOfertasAgrupacion(idAgrupacion);
					Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
							Long.parseLong(listaOfertas.get(0).getIdOferta())));
					ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
					vDatosComprador = new VBusquedaDatosCompradorExpediente();
					String nombreRazonSocial = null;
					nombreRazonSocial = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.NOMBRE_TITULAR_2 + contadorColumnas);
					if (nombreRazonSocial == null || nombreRazonSocial.isEmpty()) {
						nombreRazonSocial = exc.dameCelda(fila,
								MSVVentaDeCarteraExcelValidator.COL_NUM.RAZON_SOCIAL_TITULAR_2 + contadorColumnas);
					}
					vDatosComprador.setNombreRazonSocial(nombreRazonSocial);
					vDatosComprador.setCodTipoDocumento(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.TIPO_DOCUMENTO_TITULAR_2 + contadorColumnas));
					vDatosComprador.setNumDocumento(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.DOC_IDENTIFICACION_TITULAR_2 + contadorColumnas));
					vDatosComprador.setNumeroClienteUrsus(Long.parseLong(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR_2 + contadorColumnas)));
					vDatosComprador.setDocumentoConyuge(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_2 + contadorColumnas));
					vDatosComprador.setPorcentajeCompra(Double.parseDouble(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR_2 + contadorColumnas)));

					expedienteComercialApi.createComprador(vDatosComprador, expedienteComercial.getId());
					transactionManager.commit(transaction);
				} catch (Exception e) {
					transactionManager.rollback(transaction);
					throw e;
				}
				contadorColumnas = contadorColumnas + 8;
			}
		}
	}

	/**
	 * Modifica el % del comprador principal
	 * 
	 * @param idAgrupacion
	 * @param nuevoPorcentaje
	 * @throws Exception
	 */
	private void modificarPorcentajePrincipal(Long idAgrupacion, double nuevoPorcentaje) throws Exception {
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			// Recuperamos el ExpedienteComercial
			List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					Long.parseLong(listaOfertas.get(0).getIdOferta())));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);

			VBusquedaDatosCompradorExpediente vDatosComprador = new VBusquedaDatosCompradorExpediente();
			vDatosComprador.setIdExpedienteComercial(expedienteComercial.getId().toString());
			vDatosComprador.setId(expedienteComercial.getCompradorPrincipal().getId().toString());
			vDatosComprador.setNombreRazonSocial(expedienteComercial.getCompradorPrincipal().getNombre());
			vDatosComprador.setPorcentajeCompra(nuevoPorcentaje);

			expedienteComercialApi.saveFichaComprador(vDatosComprador);
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

	/**
	 * Tramita la oferta, pasa a aceptada y crea el exp y tramite
	 * 
	 * @param idAgrupacion
	 * @throws JsonViewerException
	 * @throws Exception
	 */
	private void crearTramiteOferta(Long idAgrupacion) throws JsonViewerException, Exception {
		TransactionStatus transaction = null;
		logger.debug("OFERTA_CARTERA: Creamos el tramite y el expediente");
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoOfertaActivo dtoOferta = new DtoOfertaActivo();
			List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			dtoOferta.setIdOferta(Long.parseLong(listaOfertas.get(0).getIdOferta()));
			dtoOferta.setIdAgrupacion(idAgrupacion);
			dtoOferta.setCodigoEstadoOferta(DDEstadoOferta.CODIGO_ACEPTADA);

			agrupacionAdapter.saveOfertaAgrupacion(dtoOferta);
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

	/**
	 * Crea la oferta en la agrupación
	 * 
	 * @param codigoOferta
	 * @param nombre
	 * @param razonSocial
	 * @param tipoDoc
	 * @param numdoc
	 * @param codigoPrescriptor
	 * @param idAgrupacion
	 * @throws Exception
	 */
	private void crearOfertaAgrupcion(String codigoOferta, String nombre, String razonSocial, String tipoDoc,
			String numdoc, String codigoPrescriptor, Long idAgrupacion, Long idUvem) throws Exception {
		TransactionStatus transactionE = null;
		logger.debug("OFERTA_CARTERA: Creamos la oferta");
		try {
			transactionE = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoOfertasFilter dtoFilter = new DtoOfertasFilter();
			dtoFilter.setImporteOferta(listaAgrupaciones.get(codigoOferta));
			dtoFilter.setTipoOferta(DDTipoOferta.CODIGO_VENTA);
			dtoFilter.setNombreCliente(nombre);
			dtoFilter.setRazonSocialCliente(razonSocial);
			dtoFilter.setTipoDocumento(tipoDoc);
			dtoFilter.setNumDocumentoCliente(numdoc);
			dtoFilter.setCodigoPrescriptor(codigoPrescriptor);
			dtoFilter.setIdAgrupacion(idAgrupacion);
			dtoFilter.setVentaDirecta(true);
			dtoFilter.setIdUvem(idUvem);

			agrupacionAdapter.createOfertaAgrupacion(dtoFilter);
			transactionManager.commit(transactionE);
		} catch (Exception e) {
			transactionManager.rollback(transactionE);
			throw e;
		}
	}

	/**
	 * Añade un activo a la agrupación
	 * 
	 * @param numActivo
	 * @param idAgrupacion
	 * @param activoPrincipal
	 * @throws Exception
	 */
	private void anyadirActivoAgrupacion(String numActivo, Long idAgrupacion, Integer activoPrincipal)
			throws Exception {
		TransactionStatus transaction = null;
		try {
			logger.debug("OFERTA_CARTERA: añadimos activo : " + numActivo);
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

			agrupacionAdapter.createActivoAgrupacion(Long.parseLong(numActivo), idAgrupacion, activoPrincipal);
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

	/**
	 * Modifica la agrupación
	 * 
	 * @param gestorUsername
	 * @param descripcionAgrupacion
	 * @return
	 * @throws Exception
	 */
	private ActivoAgrupacion modificarAgrupacion(String gestorUsername, String descripcionAgrupacion) throws Exception {
		logger.debug("OFERTA_CARTERA: Modificamos la oferta");
		TransactionStatus transactionD = null;
		ActivoAgrupacion agrupacion = null;
		try {
			transactionD = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoAgrupaciones dtoAgrupacionMod = new DtoAgrupaciones();
			dtoAgrupacionMod.setIsFormalizacion(1);
			Usuario usuario = genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "username", gestorUsername));
			dtoAgrupacionMod.setCodigoGestorComercial(usuario.getId());
			agrupacion = genericDao.get(ActivoAgrupacion.class,
					genericDao.createFilter(FilterType.EQUALS, "descripcion", descripcionAgrupacion));
			List<ActivoAgrupacionActivo> listaActivoAgrupacionActivo = new ArrayList<ActivoAgrupacionActivo>();
			agrupacion.setActivos(listaActivoAgrupacionActivo);

			agrupacionAdapter.saveAgrupacion(dtoAgrupacionMod, agrupacion.getId());
			transactionManager.commit(transactionD);
		} catch (Exception e) {
			transactionManager.rollback(transactionD);
			throw e;
		}
		return agrupacion;
	}

	/**
	 * Obtiene la agrupacion
	 * 
	 * @param descripcionAgrupacion
	 * @return
	 * @throws Exception
	 */
	private ActivoAgrupacion obtenerAgrupacion(String descripcionAgrupacion) throws Exception {
		logger.debug("OFERTA_CARTERA: obtenemos la agrupación "+descripcionAgrupacion);
		TransactionStatus transaction = null;
		ActivoAgrupacion agrupacion = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			// Recuperamos la agrupcaion
			agrupacion = genericDao.get(ActivoAgrupacion.class,
					genericDao.createFilter(FilterType.EQUALS, "descripcion", descripcionAgrupacion));
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
		return agrupacion;
	}

	/**
	 * Crea la agrupación
	 * 
	 * @param descripcionAgrupacion
	 * @throws Exception
	 */
	private void crearAgrupcacion(String descripcionAgrupacion) throws Exception {
		logger.debug("OFERTA_CARTERA: creamos la agrupación "+descripcionAgrupacion);
		TransactionStatus transactionC = null;
		try {
			transactionC = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoAgrupacionesCreateDelete dtoAgrupacionCrear = new DtoAgrupacionesCreateDelete();
			dtoAgrupacionCrear.setNombre(messageServices.getMessage(NOMBRE_AGRUPACION));
			dtoAgrupacionCrear.setDescripcion(descripcionAgrupacion);
			dtoAgrupacionCrear.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL);
			dtoAgrupacionCrear.setFechaInicioVigencia(new Date());

			agrupacionAdapter.createAgrupacion(dtoAgrupacionCrear);
			transactionManager.commit(transactionC);
		} catch (Exception e) {
			transactionManager.rollback(transactionC);
			throw e;
		}
	}

	/**
	 * Es el ultimo acto de la agrupación?
	 * 
	 * @param codigoOferta
	 * @param fila
	 * @return
	 * @throws IllegalArgumentException
	 * @throws IOException
	 * @throws ParseException
	 */
	private boolean esUltimoActivoAgrupacion(String codigoOferta, int fila)
			throws IllegalArgumentException, IOException, ParseException {

		Boolean esUltimo = true;
		if (fila != excel.getNumeroFilas() - 1) {
			for (int i = fila + 1; i <= excel.getNumeroFilas() - 1; i++) {
				if (codigoOferta
						.equals(excel.dameCelda(i, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_UNICO_OFERTA))) {
					esUltimo = false;
				}
				;
			}
		}

		return esUltimo;
	}

	/**
	 * Calcula el importe de la oferta
	 * 
	 * @param exc
	 * @throws IllegalArgumentException
	 * @throws IOException
	 * @throws ParseException
	 */
	private void calcularImporteOferta(MSVHojaExcel exc) throws IllegalArgumentException, IOException, ParseException {
		listaAgrupaciones = new HashMap<String, String>();
		String codigoOferta = null;
		String precioVenta = null;
		// Comprobamos las distintas agrupaciones que hay
		for (int i = this.getFilaInicial(); i <= excel.getNumeroFilas() - 1; i++) {
			codigoOferta = exc.dameCelda(i, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_UNICO_OFERTA);
			precioVenta = exc.dameCelda(i, MSVVentaDeCarteraExcelValidator.COL_NUM.PRECIO_VENTA);
			if (!listaAgrupaciones.containsKey(codigoOferta)) {
				listaAgrupaciones.put(codigoOferta, precioVenta);
			} else {
				Double importe1 = Double.parseDouble(listaAgrupaciones.get(codigoOferta));
				Double importe2 = Double.parseDouble(precioVenta);
				listaAgrupaciones.put(codigoOferta, String.valueOf((importe1 + importe2)));
			}

		}
	}

}

package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import es.pfsgroup.framework.paradise.bulkUpload.model.ProcesoMasivoContext;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVVentaDeCarteraExcelValidator;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVVentaDeCarteraExcelValidator.COL_NUM;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TramitacionOfertasApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.listener.ActivoGenerarSaltoImpl;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.DtoSaltoTarea;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionIncAnuladas;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDataDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.service.UpdaterTransitionService;

@Component
public class MSVActualizadorVentaCartera extends AbstractMSVActualizador implements MSVLiberator {

	private static final int EXCEL_FILA_INICIAL = 3;
	private static final String NOMBRE_AGRUPACION = "masivo.vc.agrupacion.nombre";
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private AgrupacionAdapter agrupacionAdapter;

	@Autowired
	private ParticularValidatorApi particularValidatorApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private AgendaAdapter agendaAdapter;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Autowired
	private UvemManagerApi uvemManagerApi;

	@Autowired
	private UpdaterTransitionService updaterTransitionService;

	@Autowired
	private TareaActivoApi tareaActivoApi;

	@Autowired
	private ResolucionComiteApi resolucionComiteApi;
	
	
	@Resource
	private MessageService messageServices;

	private MSVHojaExcel excel;
	
	@Autowired
	private TramitacionOfertasApi tramitacionOfertasManager;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VENTA_DE_CARTERA;
	}

	@Override
	public int getFilaInicial() {
		return MSVActualizadorVentaCartera.EXCEL_FILA_INICIAL;
	}

	@Override
	public void preProcesado(MSVHojaExcel exc, ProcesoMasivoContext context) throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		logger.debug("OFERTA_CARTERA: preProcesado del fichero: " + exc.getRuta());
		excel = exc;
		HashMap<String, String> listaAgrupaciones = calcularImporteOferta(excel);
		context.put(ProcesoMasivoContext.LISTA_AGRUPACIONES, listaAgrupaciones);

		HashMap<String, ArrayList<DtoActivosExpediente>> listaActivosPorAgrupacion = obtenerActivosOferta(excel);
		context.put(ProcesoMasivoContext.ACTIVOS_AGRUPACION, listaActivosPorAgrupacion);
	}

	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws JsonViewerException, IOException, ParseException, SQLException, Exception {
		return procesaFila(exc, fila, prmToken, new ProcesoMasivoContext());
	}

	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken, ProcesoMasivoContext context) throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.addResultado("NUM ACTIVO",
				exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUM_ACTIVO_HAYA));
		ActivoAgrupacion agrupacion = null;
		String codigoOferta = null;
		logger.debug("--------------------- OFERTA_CARTERA: procesando fila: " + fila
				+ " -------------------------------------------");
		if (!Checks.esNulo(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_UNICO_OFERTA))) {
			// CÓDIGO ÚNICO OFERTA
			codigoOferta = exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_UNICO_OFERTA);

			String descripcionAgrupacion = codigoOferta + "-" + prmToken.toString();
			String keyAgrupacionFallida = ProcesoMasivoContext.AGRUPACION_FALLIDA.concat(descripcionAgrupacion);

			if (context.containsKey(keyAgrupacionFallida) && (Boolean) context.get(keyAgrupacionFallida)) {
				// si alguno de los activos de la agrupacion falla, no
				// procesamos ningun activo de la agrupacion
				resultado.setCorrecto(false);
				resultado.setErrorDesc("Alguno de los activos de la agrupación no se ha podido insertar");
				return resultado;
			}
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

			resultado.addResultado("NUM AGRUPACION", agrupacion.getNumAgrupRem().toString());

			// Añadimos el activo a la agrupación
			// NUMERO ACTIVO

			try {
				anyadirActivoAgrupacion(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUM_ACTIVO_HAYA),
						agrupacion.getId(), activoPrincipal);
			} catch (Exception e) {
				// anulamos agrupación y no procesamos el resto de activos
				context.put(keyAgrupacionFallida, true);
				darDeBajaAgrupacion(agrupacion.getId());
				throw e;
			}

			// Si es el último activo con ese 'CÓDIGO ÚNICO OFERTA' del excel
			if (esUltimoActivoAgrupacion(codigoOferta, fila)) {
				// Creamos la oferta sobre a agrupacion
				// PRECIO VENTA NOMBRE RAZON SOCIAL TIPO DOC NUM DOC CÓDIGO
				// PRESCRIPTOR ID AGRUPACION
				// idUvem
				Long idUvem = null;
				if (exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_CARTERA) != null
						&& !exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_CARTERA).isEmpty()) {
					idUvem = Long.valueOf(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_CARTERA));
				}
				crearOfertaAgrupcion(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_UNICO_OFERTA),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NOMBRE_TITULAR),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.RAZON_SOCIAL_TITULAR),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.TIPO_DOCUMENTO_TITULAR),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.DOC_IDENTIFICACION_TITULAR),
						exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_PRESCRIPTOR),
						agrupacion.getId(), idUvem, context);

				// Creamos un tramite para la oferta, y con ello el
				// expedienteComercial
				crearTramiteOferta(agrupacion.getId());
				// Comprobamos el porcentaje de compra de todos los titulares
				// para continuar
				if (comprobarParticipacion(exc, fila)) {
					// Añadimos el porcentaje correcto al comprador principal,
					// por defecto esta el 100%.
					String regimenMatrimonial = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.REGIMEN_MATRIMONIAL);
					String estadoCivil = DDEstadosCiviles.CODIGO_ESTADO_CIVIL_SOLTERO;
					if (regimenMatrimonial != null && !regimenMatrimonial.isEmpty()) {
						estadoCivil = DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO;
					}

					String nombreRazonSocial = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.NOMBRE_TITULAR);
					if (nombreRazonSocial == null || nombreRazonSocial.isEmpty()) {
						nombreRazonSocial = exc.dameCelda(fila,
								MSVVentaDeCarteraExcelValidator.COL_NUM.RAZON_SOCIAL_TITULAR);
					}
					String pais = exc.dameCelda(fila, COL_NUM.PAIS_TITULAR);
					String provincia = exc.dameCelda(fila, COL_NUM.PROVINCIA_TITULAR);
					String municipio = exc.dameCelda(fila, COL_NUM.MUNICIPIO_TITULAR);
					String direccion = exc.dameCelda(fila, COL_NUM.DIRECCION_TITULAR);
					
					String nombreRazonSocialRte = exc.dameCelda(fila, COL_NUM.NOMBRE_RTE_TITULAR);
					if (nombreRazonSocialRte == null || nombreRazonSocialRte.isEmpty()) {
						nombreRazonSocialRte = exc.dameCelda(fila,
								MSVVentaDeCarteraExcelValidator.COL_NUM.RAZON_SOCIAL_RTE_TITULAR);
					}
					
					String codTipoDocRte = exc.dameCelda(fila, COL_NUM.TIPO_DOCUMENTO_RTE_TITULAR);
					String numDocRte = exc.dameCelda(fila, COL_NUM.DOC_IDENTIFICACION_RTE_TITULAR);
					String paisRte = exc.dameCelda(fila, COL_NUM.PAIS_RTE_TITULAR);
					String provinciaRte = exc.dameCelda(fila, COL_NUM.PROVINCIA_RTE_TITULAR);
					String municipioRte = exc.dameCelda(fila, COL_NUM.MUNICIPIO_RTE_TITULAR);
					
					modificarCompradorPrincipal(agrupacion.getId(),
							Double.parseDouble(exc.dameCelda(fila,
									MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR)),
							Long.parseLong(
									exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR)),
							null, regimenMatrimonial, estadoCivil, nombreRazonSocial, codTipoDocRte, numDocRte,
							pais, provincia, municipio, direccion, nombreRazonSocialRte, paisRte, provinciaRte, municipioRte);

					// Añadimos el resto de TITULARES (Comprador) 2, 3 y 4.
					anyadirRestoCompradores(exc, fila, agrupacion.getId());

					// Setea el documento del conyuge para aquellos comprodores
					// que esten
					// casados en regimen de ganaciales
					setearConyuges(exc, fila, agrupacion.getId());
					
					// guardamos los datos que hacen falta para avanzar el exp
					// comercial
					guardarDatosNecesariosExpedienteComercial(exc, agrupacion.getId(), fila, context, resultado);

					// actualizamos los importes de los activos
					updateActivoExpediente(codigoOferta, agrupacion.getId(), context);

					// creamos un posicionamiento en el expediente
					crearPosicionamiento(agrupacion.getId());
					
					// Avanzar el tramite de la oferta, en este paso se llama al
					avanzaPrimeraTarea(agrupacion.getId(),
							exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.COMITE_SANCIONADOR), resultado);
					
					// Llamar al servicioweb Modi de Bankia
					llamadaSercivioWeb(agrupacion.getId());

					// simular llegada resolución
					simularResolucion(agrupacion.getId(),
							exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.COMITE_SANCIONADOR));
					
					//indica la fecha de venta
					indicarFechaVentaExpediente(exc, agrupacion.getId(), fila, context, resultado);
					
					// saltamos a cierre economico
					saltoCierreEconomico(agrupacion.getId());
					
					// Esperamos 15 segundos por Bankia
					logger.debug(
							"--------------------- OFERTA_CARTERA: fin -------------------------------------------");
					Thread.sleep(15000);
				} else {
					throw new Exception(" El porcentaje de los compradores no suma el 100%");
				}
			}
		}

		return resultado;
	}

	/**
	 * Setea el documento del conyuge para aquellos comprodores que esten
	 * casados en regimen de ganaciales
	 * 
	 * @param fila
	 * @param idAgrupacion
	 * @throws Exception
	 */
	private void setearConyuges(MSVHojaExcel exc, int fila, Long idAgrupacion) throws Exception {
		logger.debug("OFERTA_CARTERA: Modificamos los conyuges de los compradores principales");
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);

			if (expedienteComercial.getCompradores() != null && !expedienteComercial.getCompradores().isEmpty()) {
				for (CompradorExpediente comprador : expedienteComercial.getCompradores()) {
					if (comprador.getRegimenMatrimonial() != null && DDRegimenesMatrimoniales.COD_GANANCIALES
							.equals(comprador.getRegimenMatrimonial().getCodigo())) {
						String docConyuge = null;
						String ursusConyuge = null;
						int colComprador = obtenerColumnaComprador(exc, fila, comprador);
						if (colComprador > 0) {
							if (colComprador == 1) {
								ursusConyuge = exc.dameCelda(fila,
										MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR);
							} else if (colComprador == 2) {
								ursusConyuge = exc.dameCelda(fila,
										MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_2);
							} else if (colComprador == 3) {
								ursusConyuge = exc.dameCelda(fila,
										MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_3);
							} else if (colComprador == 4) {
								ursusConyuge = exc.dameCelda(fila,
										MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_4);
							}
						}

						if (ursusConyuge != null && !ursusConyuge.isEmpty()) {
							docConyuge = obtenerDocumentoByUrsus(ursusConyuge, exc, fila);
							if (docConyuge != null && !docConyuge.isEmpty()) {
								comprador.setDocumentoConyuge(docConyuge);
								genericDao.save(ExpedienteComercial.class, expedienteComercial);
							}
						}

					}
				}
			}
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

	/**
	 * Obtiene el documento dado un ursus
	 * 
	 * @param ursus
	 * @param exc
	 * @param fila
	 * @return
	 * @throws IllegalArgumentException
	 * @throws IOException
	 * @throws ParseException
	 */
	private String obtenerDocumentoByUrsus(String ursus, MSVHojaExcel exc, int fila)
			throws IllegalArgumentException, IOException, ParseException {
		if (ursus.equals(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR))) {
			return exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.DOC_IDENTIFICACION_TITULAR);
		} else if (ursus
				.equals(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR_2))) {
			return exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.DOC_IDENTIFICACION_TITULAR_2);
		} else if (ursus
				.equals(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR_3))) {
			return exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.DOC_IDENTIFICACION_TITULAR_3);
		} else if (ursus
				.equals(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR_4))) {
			return exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.DOC_IDENTIFICACION_TITULAR_4);
		}
		return null;
	}

	/**
	 * Obtiene la columna en el excel de un comprador
	 * 
	 * @param exc
	 * @param fila
	 * @param comprador
	 * @return
	 * @throws IllegalArgumentException
	 * @throws IOException
	 * @throws ParseException
	 */
	private int obtenerColumnaComprador(MSVHojaExcel exc, int fila, CompradorExpediente comprador)
			throws IllegalArgumentException, IOException, ParseException {
		Long ursusNumber = comprador.getPrimaryKey().getComprador().getIdCompradorUrsus();
		if (ursusNumber == null) {
			ursusNumber = comprador.getPrimaryKey().getComprador().getIdCompradorUrsusBh();
		}
		if (ursusNumber != null) {
			String ursus = ursusNumber.toString();
			if (ursus.equals(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR))) {
				return 1;
			} else if (ursus.equals(
					exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR_2))) {
				return 2;
			} else if (ursus.equals(
					exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR_3))) {
				return 3;
			} else if (ursus.equals(
					exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR_4))) {
				return 4;
			} else {
				return 0;
			}
		} else {
			return 0;
		}

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
	private void guardarDatosNecesariosExpedienteComercial(MSVHojaExcel exc, Long idAgrupacion, int fila,
			ProcesoMasivoContext context, ResultadoProcesarFila resultado) throws Exception {
		logger.debug("OFERTA_CARTERA: Guardamos datos en el expediente comercial");
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);

			DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
			String stringDate = exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.FECHA_INGRESO_CHEQUE);
			Date fechaContabilizacionPropietario = null;

			if (stringDate != null && !stringDate.isEmpty()) {
				fechaContabilizacionPropietario = format.parse(stringDate);
			}

			DtoCondiciones condicionantes = new DtoCondiciones();
			condicionantes
					.setTipoImpuestoCodigo(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.TIPO_IMPUESTO));
			condicionantes.setTipoAplicable(
					Double.valueOf(exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.TIPO_APLICABLE)));

			if (exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.OPERACION_EXENTA) != null
					&& !exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.OPERACION_EXENTA).isEmpty()
					&& exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.OPERACION_EXENTA).toLowerCase()
							.equals("si")) {
				condicionantes.setOperacionExenta(true);
			} else {
				condicionantes.setOperacionExenta(false);
			}

			if (exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.RENUNCIA_EXENCION) != null
					&& !exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.RENUNCIA_EXENCION).isEmpty()
					&& exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.RENUNCIA_EXENCION).toLowerCase()
							.equals("si")) {
				condicionantes.setRenunciaExencion(true);
			} else {
				condicionantes.setRenunciaExencion(false);
			}

			if (exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.INVERSION_SUJETO_PASIVO) != null
					&& !exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.INVERSION_SUJETO_PASIVO).isEmpty()
					&& exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.INVERSION_SUJETO_PASIVO)
							.toLowerCase().equals("si")) {
				condicionantes.setInversionDeSujetoPasivo(true);
			} else {
				condicionantes.setInversionDeSujetoPasivo(false);
			}

			DtoFichaExpediente dtoExp = new DtoFichaExpediente();
			dtoExp.setFechaContabilizacionPropietario(fechaContabilizacionPropietario);
			dtoExp.setEstadoPbc(1);
			dtoExp.setConflictoIntereses(0);
			dtoExp.setRiesgoReputacional(0);
			dtoExp.setCodigoComiteSancionador(
					exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.COMITE_SANCIONADOR));
			expedienteComercialApi.saveCondicionesExpediente(condicionantes, expedienteComercial.getId());
			expedienteComercialApi.saveFichaExpediente(dtoExp, expedienteComercial.getId());
			

			// modificamos los importes de participación de los activos

			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}
	
	/**
	 * Indica la fecha venta en el
	 * expediente
	 * 
	 * @param exc
	 * @param idAgrupacion
	 * @param fila
	 * @throws Exception
	 */
	private void indicarFechaVentaExpediente(MSVHojaExcel exc, Long idAgrupacion, int fila,
			ProcesoMasivoContext context, ResultadoProcesarFila resultado)throws Exception {
		logger.debug("OFERTA_CARTERA: Guardamos la fecha venta en el expediente comercial");
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);

			DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
			String stringDateVenta = exc.dameCelda(fila, MSVVentaDeCarteraExcelValidator.COL_NUM.FECHA_VENTA);
			Date fechaVenta = null;

			if (stringDateVenta != null && !stringDateVenta.isEmpty()) {
				fechaVenta = format.parse(stringDateVenta);
			}
			DtoFichaExpediente dtoExp = new DtoFichaExpediente();
			dtoExp.setFechaVenta(fechaVenta);

			expedienteComercialApi.saveFichaExpediente(dtoExp, expedienteComercial.getId());
			transactionManager.commit(transaction);
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
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);

			Activo primerActivo = oferta.getActivoPrincipal();

			if (Checks.esNulo(primerActivo)) {
				throw new Exception("La oferta no tiene activos");
			}

			if (DDCartera.CODIGO_CARTERA_BANKIA.equals(primerActivo.getCartera().getCodigo())) {
				Double porcentajeImpuesto = null;
				if (!Checks.esNulo(expedienteComercial.getCondicionante())) {
					if (!Checks.esNulo(expedienteComercial.getCondicionante().getTipoAplicable())) {
						porcentajeImpuesto = expedienteComercial.getCondicionante().getTipoAplicable();
					}
				}
				InstanciaDecisionDto instanciaDecisionDto = expedienteComercialApi
						.expedienteComercialToInstanciaDecisionList(expedienteComercial, porcentajeImpuesto, null);

				// modificar
				//uvemManagerApi.modificarInstanciaDecision(instanciaDecisionDto);
				// modificar_honorarios
				instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_HONORARIOS);
				uvemManagerApi.modificarInstanciaDecisionTres(instanciaDecisionDto);
				// modificar_titulares
				instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_TITULARES);
				uvemManagerApi.modificarInstanciaDecisionTres(instanciaDecisionDto);
				// modificar_condicionantes
				instanciaDecisionDto.setCodigoCOTPRA(InstanciaDecisionDataDto.PROPUESTA_CONDICIONANTES_ECONOMICOS);
				uvemManagerApi.modificarInstanciaDecisionTres(instanciaDecisionDto);

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
	private Long avanzaPrimeraTarea(Long idAgrupacion, String codigoComite, ResultadoProcesarFila resultado)
			throws Exception {
		logger.debug("OFERTA_CARTERA: Avanzamos la tarea");
		TransactionStatus transaction = null;
		Long idTareaExterna = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

			// Recuperamos el ExpedienteComercial
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
			resultado.addResultado("NUM OFERTA", oferta.getNumOferta().toString());
			resultado.addResultado("EXP comercial", expedienteComercial.getNumExpediente().toString());
			// Obtenemos el tramite del expediente, y de este sus tareas.
			List<ActivoTramite> listaTramites = activoTramiteApi
					.getTramitesActivoTrabajoList(expedienteComercial.getTrabajo().getId());
			List<TareaExterna> tareasTramite = activoTareaExternaApi
					.getActivasByIdTramiteTodas(listaTramites.get(0).getId());
			idTareaExterna = tareasTramite.get(0).getId();

			Map<String, String[]> valoresTarea = new HashMap<String, String[]>();
			valoresTarea.put("comite",
					new String[] { expedienteComercialApi.comiteSancionadorByCodigo(codigoComite).getDescripcion() });
			valoresTarea.put("comboConflicto", new String[] { "02" });
			valoresTarea.put("comboRiesgo", new String[] { "02" });
			DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
			valoresTarea.put("fechaEnvio", new String[] { format.format(new Date()) });
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
	 * Saltando a cierre economico
	 * 
	 * @param idAgrupacion
	 * @throws Exception
	 */
	private void saltoCierreEconomico(Long idAgrupacion) throws Exception {
		logger.debug("OFERTA_CARTERA: Saltamos a cierre economico");
		TransactionStatus transaction = null;
		ActivoTramite tramite = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
			List<ActivoTramite> listaTramites = activoTramiteApi
					.getTramitesActivoTrabajoList(expedienteComercial.getTrabajo().getId());
			if (Checks.esNulo(listaTramites) || listaTramites.size() == 0) {
				throw new Exception("No se ha podido recuperar el trámite de la oferta.");
			} else {
				tramite = listaTramites.get(0);
				if (Checks.esNulo(tramite)) {
					throw new Exception("No se ha podido recuperar el trámite de la oferta.");
				}
			}
			List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramite.getId());
			for (TareaExterna tarea : listaTareas) {
				if (!Checks.esNulo(tarea)) {
					DtoSaltoTarea salto = new DtoSaltoTarea();

					salto.setIdTramite(tramite.getId());
					salto.setPbcAprobado(1);
					salto.setFechaRespuestaComite(new Date());
					updaterTransitionService.updateT013_CierreEconomico(salto);

					tareaActivoApi.saltoDesdeTareaExterna(tarea.getId(), ActivoGenerarSaltoImpl.CODIGO_SALTO_CIERRE);

					break;
				}
			}
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}

	}

	/**
	 * Saltando a cierre economico
	 * 
	 * @param idAgrupacion
	 * @throws Exception
	 */
	private void simularResolucion(Long idAgrupacion, String codigoComite) throws Exception {
		logger.debug("OFERTA_CARTERA: Creando la resolución");
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ResolucionComiteDto resolucionComiteDto = new ResolucionComiteDto();
			resolucionComiteDto.setCodigoComite(codigoComite);
			resolucionComiteDto.setOfertaHRE(oferta.getNumOferta());
			resolucionComiteDto.setCodigoResolucion("1");
			resolucionComiteDto.setFechaComite(new java.sql.Date(new Date().getTime()));
			resolucionComiteDto.setCodigoTipoResolucion(DDTipoResolucion.CODIGO_TIPO_RESOLUCION);
			resolucionComiteApi.saveOrUpdateResolucionComite(resolucionComiteDto);
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}

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
					List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter
							.getListOfertasAgrupacion(idAgrupacion);
					Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
							listaOfertas.get(0).getIdOferta()));
					ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
					vDatosComprador = new VBusquedaDatosCompradorExpediente();
					String nombreRazonSocial = null;
					nombreRazonSocial = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.NOMBRE_TITULAR_2 + contadorColumnas);
					vDatosComprador.setCodTipoPersona(DDTiposPersona.CODIGO_TIPO_PERSONA_FISICA);
					if (nombreRazonSocial == null || nombreRazonSocial.isEmpty()) {
						nombreRazonSocial = exc.dameCelda(fila,
								MSVVentaDeCarteraExcelValidator.COL_NUM.RAZON_SOCIAL_TITULAR_2 + contadorColumnas);
						vDatosComprador.setCodTipoPersona(DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA);
					}
					vDatosComprador.setNombreRazonSocial(nombreRazonSocial);
					vDatosComprador.setApellidos("-");
					vDatosComprador.setCodTipoDocumento(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.TIPO_DOCUMENTO_TITULAR_2 + contadorColumnas));
					vDatosComprador.setNumDocumento(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.DOC_IDENTIFICACION_TITULAR_2 + contadorColumnas));

					if (DDSubcartera.CODIGO_BAN_BH.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())) {
						vDatosComprador.setNumeroClienteUrsusBh(Long.parseLong(exc.dameCelda(fila,
								MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR_2 + contadorColumnas)));
					} else {
						vDatosComprador.setNumeroClienteUrsus(Long.parseLong(exc.dameCelda(fila,
								MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_TITULAR_2 + contadorColumnas)));
					}

					vDatosComprador.setDocumentoConyuge(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.NUMERO_URSUS_CONYUGE_TITULAR_2 + contadorColumnas));
					vDatosComprador.setPorcentajeCompra(Double.parseDouble(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.PORCENTAJE_COMPRA_TITULAR_2 + contadorColumnas)));

					String regimenMatrimonial = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.REGIMEN_MATRIMONIAL_2 + contadorColumnas);
					if (regimenMatrimonial != null && !regimenMatrimonial.isEmpty()) {
						vDatosComprador.setCodEstadoCivil(DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO);
					} else {
						vDatosComprador.setCodEstadoCivil(DDEstadosCiviles.CODIGO_ESTADO_CIVIL_SOLTERO);
					}

					vDatosComprador.setCodigoRegimenMatrimonial(regimenMatrimonial);

					vDatosComprador.setCodigoPais(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.PAIS_TITULAR_2 + contadorColumnas));
					String codProvincia = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.PROVINCIA_TITULAR_2 + contadorColumnas);
					if(codProvincia != null && !codProvincia.isEmpty())
						vDatosComprador.setProvinciaCodigo(codProvincia);
					String codMunicipio = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.MUNICIPIO_TITULAR_2 + contadorColumnas);
					if(codMunicipio != null && !codMunicipio.isEmpty())
						vDatosComprador.setMunicipioCodigo(codMunicipio);
					vDatosComprador.setDireccion(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.DIRECCION_TITULAR_2 + contadorColumnas));
					String nombreRazonSocialRte = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.NOMBRE_RTE_TITULAR_2 + contadorColumnas);
					if(nombreRazonSocialRte != null && !nombreRazonSocialRte.isEmpty()) {
						vDatosComprador.setNombreRazonSocialRte(nombreRazonSocialRte);						
					}
					vDatosComprador.setApellidosRte("-");
					vDatosComprador.setCodTipoDocumentoRte(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.TIPO_DOCUMENTO_RTE_TITULAR_2 + contadorColumnas));
					vDatosComprador.setNumDocumentoRte(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.DOC_IDENTIFICACION_RTE_TITULAR_2 + contadorColumnas));
					vDatosComprador.setCodigoPaisRte(exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.PAIS_RTE_TITULAR_2 + contadorColumnas));
					String codProvinciaRte = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.PROVINCIA_RTE_TITULAR_2 + contadorColumnas);
					if(codProvinciaRte != null && !codProvinciaRte.isEmpty())
						vDatosComprador.setProvinciaRteCodigo(codProvinciaRte);
					String codMunicipioRte = exc.dameCelda(fila,
							MSVVentaDeCarteraExcelValidator.COL_NUM.MUNICIPIO_RTE_TITULAR_2 + contadorColumnas);
					if(codMunicipioRte != null && !codMunicipioRte.isEmpty())
						vDatosComprador.setMunicipioRteCodigo(codMunicipioRte);

					expedienteComercialApi.createCompradorAndSendToBC(vDatosComprador, expedienteComercial.getId());
					transactionManager.commit(transaction);
				} catch (Exception e) {
					transactionManager.rollback(transaction);
					throw e;
				}
				contadorColumnas = contadorColumnas + MSVVentaDeCarteraExcelValidator.COL_NUM.NUM_CAMPOS_COMPRADOR;
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
	private void modificarCompradorPrincipal(Long idAgrupacion, double nuevoPorcentaje, Long numeroUrsus,
			Long numeroUrsusConyuge, String codigoRegimenMatrimonial, String codEstadoCivil, String nombreRazonSocial,
			String codTipoDocumentoRte, String numDocumentoRte, String codPais, String codProvincia, String codMunicipio, 
			String direccion, String nombreRazonSocialRte, String codPaisRte, String codProvinciaRte, String codMunicipioRte)
			throws Exception {
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			// Recuperamos el ExpedienteComercial
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);

			VBusquedaDatosCompradorExpediente vDatosComprador = new VBusquedaDatosCompradorExpediente();
			vDatosComprador.setIdExpedienteComercial(expedienteComercial.getId());
			vDatosComprador.setId(expedienteComercial.getCompradorPrincipal().getId());
			vDatosComprador.setNumDocumento(expedienteComercial.getCompradorPrincipal().getDocumento());
			vDatosComprador.setPorcentajeCompra(nuevoPorcentaje);
			if (DDSubcartera.CODIGO_BAN_BH.equals(oferta.getActivoPrincipal().getSubcartera().getCodigo())) {
				vDatosComprador.setNumeroClienteUrsusBh(numeroUrsus);
			} else {
				vDatosComprador.setNumeroClienteUrsus(numeroUrsus);
			}

			vDatosComprador.setCodigoRegimenMatrimonial(codigoRegimenMatrimonial);
			vDatosComprador.setCodEstadoCivil(codEstadoCivil);
			if (codigoRegimenMatrimonial != null && !codigoRegimenMatrimonial.isEmpty()) {
				vDatosComprador.setCodEstadoCivil(DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO);
			} else {
				vDatosComprador.setCodEstadoCivil(DDEstadosCiviles.CODIGO_ESTADO_CIVIL_SOLTERO);
			}
			vDatosComprador.setNombreRazonSocial(nombreRazonSocial);
			// falta ursus conyuge

			vDatosComprador.setApellidos("-");
			vDatosComprador.setCodigoPais(codPais);
			if(codProvincia != null && !codProvincia.isEmpty())
				vDatosComprador.setProvinciaCodigo(codProvincia);
			if(codMunicipio != null && !codMunicipio.isEmpty())
				vDatosComprador.setMunicipioCodigo(codMunicipio);
			vDatosComprador.setDireccion(direccion);
			vDatosComprador.setCodTipoDocumentoRte(codTipoDocumentoRte);
			vDatosComprador.setNumDocumentoRte(numDocumentoRte);
			vDatosComprador.setNombreRazonSocialRte(nombreRazonSocialRte);
			vDatosComprador.setApellidosRte("-");
			vDatosComprador.setCodigoPaisRte(codPaisRte);
			if(codProvinciaRte != null && !codProvinciaRte.isEmpty())
				vDatosComprador.setProvinciaRteCodigo(codProvinciaRte);
			if(codMunicipioRte != null && !codMunicipioRte.isEmpty())
				vDatosComprador.setMunicipioRteCodigo(codMunicipioRte);
			
			expedienteComercialApi.saveFichaCompradorAndSendToBC(vDatosComprador);
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
	private void crearTramiteOferta(Long idAgrupacion) throws JsonViewerException, Exception, Error {
		TransactionStatus transaction = null;
		logger.debug("OFERTA_CARTERA: Creamos el tramite y el expediente");
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoOfertaActivo dtoOferta = new DtoOfertaActivo();
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			dtoOferta.setIdOferta(listaOfertas.get(0).getIdOferta());
			dtoOferta.setIdAgrupacion(idAgrupacion);
			dtoOferta.setCodigoEstadoOferta(DDEstadoOferta.CODIGO_ACEPTADA);

			tramitacionOfertasManager.saveOferta(dtoOferta, idAgrupacion != null,false);
			transactionManager.commit(transaction);
		} catch (Error err) {
			throw err;
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
	@SuppressWarnings("unchecked")
	private void crearOfertaAgrupcion(String codigoOferta, String nombre, String razonSocial, String tipoDoc,
			String numdoc, String codigoPrescriptor, Long idAgrupacion, Long idUvem, ProcesoMasivoContext context)
			throws Exception {
		TransactionStatus transactionE = null;
		logger.debug("OFERTA_CARTERA: Creamos la oferta");
		try {
			transactionE = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoOfertasFilter dtoFilter = new DtoOfertasFilter();
			dtoFilter.setImporteOferta(
					((HashMap<String, String>) context.get(ProcesoMasivoContext.LISTA_AGRUPACIONES)).get(codigoOferta));
			dtoFilter.setTipoOferta(DDTipoOferta.CODIGO_VENTA);
			if (nombre != null && !nombre.isEmpty()) {
				dtoFilter.setTipoPersona(DDTiposPersona.CODIGO_TIPO_PERSONA_FISICA);
			} else {
				dtoFilter.setTipoPersona(DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA);
			}
			dtoFilter.setNombreCliente(nombre);
			dtoFilter.setRazonSocialCliente(razonSocial);
			dtoFilter.setTipoDocumento(tipoDoc);
			dtoFilter.setNumDocumentoCliente(numdoc);
			dtoFilter.setCodigoPrescriptor(codigoPrescriptor);
			dtoFilter.setIdAgrupacion(idAgrupacion);
			dtoFilter.setVentaDirecta(true);
			dtoFilter.setIdUvem(idUvem);
			dtoFilter.setTipoPersona(DDTiposPersona.CODIGO_TIPO_PERSONA_FISICA);
			if (razonSocial != null && !razonSocial.isEmpty()) {
				dtoFilter.setTipoPersona(DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA);
			}

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

			agrupacionAdapter.createActivoAgrupacion(Long.parseLong(numActivo), idAgrupacion, activoPrincipal, true);
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
		logger.debug("OFERTA_CARTERA: obtenemos la agrupación " + descripcionAgrupacion);
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
		logger.debug("OFERTA_CARTERA: creamos la agrupación " + descripcionAgrupacion);
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
	private HashMap<String, String> calcularImporteOferta(MSVHojaExcel exc)
			throws IllegalArgumentException, IOException, ParseException {
		HashMap<String, String> listaAgrupaciones = new HashMap<String, String>();
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
		return listaAgrupaciones;
	}

	/**
	 * Calcula el importe de la oferta
	 * 
	 * @param exc
	 * @throws IllegalArgumentException
	 * @throws IOException
	 * @throws ParseException
	 */
	private HashMap<String, ArrayList<DtoActivosExpediente>> obtenerActivosOferta(MSVHojaExcel exc)
			throws IllegalArgumentException, IOException, ParseException {

		HashMap<String, ArrayList<DtoActivosExpediente>> activosAgrupaciones = new HashMap<String, ArrayList<DtoActivosExpediente>>();

		String codigoOferta = null;
		Long numActivoHaya = null;
		// Comprobamos las distintas agrupaciones que hay
		for (int i = this.getFilaInicial(); i <= excel.getNumeroFilas() - 1; i++) {
			codigoOferta = exc.dameCelda(i, MSVVentaDeCarteraExcelValidator.COL_NUM.CODIGO_UNICO_OFERTA);
			numActivoHaya = Long.valueOf(exc.dameCelda(i, MSVVentaDeCarteraExcelValidator.COL_NUM.NUM_ACTIVO_HAYA));
			Double precioVenta = Double
					.parseDouble(exc.dameCelda(i, MSVVentaDeCarteraExcelValidator.COL_NUM.PRECIO_VENTA));

			DtoActivosExpediente dtoActivoExpediente = new DtoActivosExpediente();
			dtoActivoExpediente.setNumActivo(numActivoHaya);
			dtoActivoExpediente.setImporteParticipacion(precioVenta);
			if (!activosAgrupaciones.containsKey(codigoOferta)) {
				activosAgrupaciones.put(codigoOferta, new ArrayList<DtoActivosExpediente>());
				activosAgrupaciones.get(codigoOferta).add(dtoActivoExpediente);
			} else {
				activosAgrupaciones.get(codigoOferta).add(dtoActivoExpediente);
			}

		}
		return activosAgrupaciones;
	}

	/**
	 * Actualiza los importes de cada activo de la agrupacion
	 * 
	 * @param codigoOferta
	 * @param idAgrupacion
	 * @param context
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked" })
	private void updateActivoExpediente(String codigoOferta, Long idAgrupacion, ProcesoMasivoContext context)
			throws Exception {
		logger.debug("OFERTA_CARTERA: actualizando importe de los activos");
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);

			ArrayList<DtoActivosExpediente> activosAgr = ((HashMap<String, ArrayList<DtoActivosExpediente>>) context
					.get(ProcesoMasivoContext.ACTIVOS_AGRUPACION)).get(codigoOferta);

			for (DtoActivosExpediente activoExpediente : activosAgr) {
				expedienteComercialApi.updateActivoExpediente(activoExpediente, expedienteComercial.getId());
			}

			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}

	}

	/**
	 * Crear un posicionamiento en el expediente
	 * 
	 * @param idExpedienteComercial
	 * @throws Exception
	 */
	private void crearPosicionamiento(Long idAgrupacion) throws Exception {
		logger.debug("OFERTA_CARTERA: creamos posicionamiento");
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			Date posDate = new Date();
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",
					listaOfertas.get(0).getIdOferta()));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
			DtoPosicionamiento posicionamiento = new DtoPosicionamiento();
			posicionamiento.setFechaPosicionamiento(posDate);
			posicionamiento.setHoraPosicionamiento(posDate);
			posicionamiento.setFechaHoraPosicionamiento(posDate);
			expedienteComercialApi.createPosicionamiento(posicionamiento, expedienteComercial.getId());
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

	/**
	 * En caso de fallo damos de baja la agrupacion
	 * 
	 * @param idAgrupacion
	 * @throws Exception
	 */
	private void darDeBajaAgrupacion(Long idAgrupacion) throws Exception {
		logger.debug("OFERTA_CARTERA: damos de baja la agrupacion");
		TransactionStatus transaction = null;
		try {
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			// Recuperamos la agrupcaion
			DtoAgrupaciones dtoAgrupacionMod = new DtoAgrupaciones();
			dtoAgrupacionMod.setFechaBaja(new Date());
			agrupacionAdapter.saveAgrupacion(dtoAgrupacionMod, idAgrupacion);

			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

}

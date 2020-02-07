package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInformeComercialHistoricoMediador;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRolMediador;

@Component
public class MSVActualizadorGestor extends AbstractMSVActualizador implements MSVLiberator {

	protected static final Log logger = LogFactory.getLog(MSVActualizadorGestor.class);

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private GenericABMDao genericDao;
	
	public static final String PONER_NULL_A_APIS = "0";
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_GESTORES;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			Activo activo = null;
			ActivoAgrupacion agrupacion = null;
			ExpedienteComercial expediente = null;
			Usuario usuario = null;
			EXTDDTipoGestor tipoGestor = null;
			DtoHistoricoMediador dtoMediador = null;

			if (!Checks.esNulo(exc.dameCelda(fila, 2))) {
				activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 2)));
			}
			if (!Checks.esNulo(exc.dameCelda(fila, 3))) {
				Long idAgrupacion = activoAgrupacionApi
						.getAgrupacionIdByNumAgrupRem(Long.parseLong(exc.dameCelda(fila, 3)));
				agrupacion = activoAgrupacionApi.get(idAgrupacion);
			}

			if (!Checks.esNulo(exc.dameCelda(fila, 4))) {
				expediente = expedienteComercialApi.findOneByNumExpediente(Long.parseLong(exc.dameCelda(fila, 4)));
			}

			if (!Checks.esNulo(exc.dameCelda(fila, 0))) {
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, 0));
				Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				tipoGestor = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor, filtroBorrado);
			}

			if (!Checks.esNulo(exc.dameCelda(fila, 1))) {
				Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "username", exc.dameCelda(fila, 1));
				Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				usuario = genericDao.get(Usuario.class, filtroUsuario, filtroBorrado);
			}
			
			//Insert y/o Update API Primario
			if (!Checks.esNulo(exc.dameCelda(fila, 5)) && !PONER_NULL_A_APIS.equals(exc.dameCelda(fila, 5))) {
				if (!Checks.esNulo(activo)) {
					Filter codProveedorFilter = genericDao.createFilter(FilterType.EQUALS,"codigoProveedorRem", Long.valueOf(exc.dameCelda(fila, 5)));
					ActivoProveedor apiPrimario = genericDao.get(ActivoProveedor.class, codProveedorFilter);
					
					if (Checks.esNulo(activo.getInfoComercial())) {
						ActivoInfoComercial infoComercial = new ActivoInfoComercial();
						infoComercial.setMediadorInforme(apiPrimario);
						infoComercial.setActivo(activo);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					} else {
						ActivoInfoComercial infoComercial = activo.getInfoComercial();
						infoComercial.setMediadorInforme(apiPrimario);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					}
					
					//Historico
					Filter codTRLFilter = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo", DDTipoRolMediador.CODIGO_TIPO_PRIMARIO);
					Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Filter fechaFilter = genericDao.createFilter(FilterType.NULL, "fechaHasta");
					ActivoInformeComercialHistoricoMediador historicoMediadorPrimario = genericDao.get(ActivoInformeComercialHistoricoMediador.class, codTRLFilter, activoFilter, fechaFilter);
					
					if (!Checks.esNulo(historicoMediadorPrimario)) {
						historicoMediadorPrimario.setFechaHasta(new Date());
						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimario);
					} 
					
					ActivoInformeComercialHistoricoMediador nuevoHistoricoMediadorPrimario = new ActivoInformeComercialHistoricoMediador();
					nuevoHistoricoMediadorPrimario.setActivo(activo);
					nuevoHistoricoMediadorPrimario.setMediadorInforme(apiPrimario);
					nuevoHistoricoMediadorPrimario.setFechaDesde(new Date());
					Filter trlFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoRolMediador.CODIGO_TIPO_PRIMARIO);
					DDTipoRolMediador tipoRolMediador = genericDao.get(DDTipoRolMediador.class, trlFilter);
					nuevoHistoricoMediadorPrimario.setTipoRolMediador(tipoRolMediador);
					genericDao.save(ActivoInformeComercialHistoricoMediador.class, nuevoHistoricoMediadorPrimario);
				}
			//Poner a null API Primario
			} else if (!Checks.esNulo(exc.dameCelda(fila, 5)) && PONER_NULL_A_APIS.equals(exc.dameCelda(fila, 5))) {
				if (!Checks.esNulo(activo)) {
					if (Checks.esNulo(activo.getInfoComercial())) {
						ActivoInfoComercial infoComercial = new ActivoInfoComercial();
						infoComercial.setActivo(activo);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					} else {
						ActivoInfoComercial infoComercial = activo.getInfoComercial();
						infoComercial.setMediadorInforme(null);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					}
					
					//Historico
					Filter codTRLFilter = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo", DDTipoRolMediador.CODIGO_TIPO_PRIMARIO);
					Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Filter fechaFilter = genericDao.createFilter(FilterType.NULL, "fechaHasta");
					ActivoInformeComercialHistoricoMediador historicoMediadorPrimario = genericDao.get(ActivoInformeComercialHistoricoMediador.class, codTRLFilter, activoFilter, fechaFilter);
					
					if (!Checks.esNulo(historicoMediadorPrimario)) {
						historicoMediadorPrimario.setFechaHasta(new Date());
						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimario);
					} 
					
				}
			}
			
			//Insert y/o Update API Espejo
			if (!Checks.esNulo(exc.dameCelda(fila, 6)) && !PONER_NULL_A_APIS.equals(exc.dameCelda(fila, 6))) {
				if (!Checks.esNulo(activo)) {
					Filter codProveedorFilter = genericDao.createFilter(FilterType.EQUALS,"codigoProveedorRem", Long.valueOf(exc.dameCelda(fila, 6)));
					ActivoProveedor apiEspejo = genericDao.get(ActivoProveedor.class, codProveedorFilter);
					
					if (Checks.esNulo(activo.getInfoComercial())) {
						ActivoInfoComercial infoComercial = new ActivoInfoComercial();
						infoComercial.setMediadorEspejo(apiEspejo);
						infoComercial.setActivo(activo);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					} else {
						ActivoInfoComercial infoComercial = activo.getInfoComercial();
						infoComercial.setMediadorEspejo(apiEspejo);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					}
					
					//Historico
					Filter codTRLFilter = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo", DDTipoRolMediador.CODIGO_TIPO_ESPEJO);
					Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Filter fechaFilter = genericDao.createFilter(FilterType.NULL, "fechaHasta");
					ActivoInformeComercialHistoricoMediador historicoMediadorPrimario = genericDao.get(ActivoInformeComercialHistoricoMediador.class, codTRLFilter, activoFilter, fechaFilter);
					
					if (!Checks.esNulo(historicoMediadorPrimario)) {
						historicoMediadorPrimario.setFechaHasta(new Date());
						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimario);
					} 
					
					ActivoInformeComercialHistoricoMediador nuevoHistoricoMediadorPrimario = new ActivoInformeComercialHistoricoMediador();
					nuevoHistoricoMediadorPrimario.setActivo(activo);
					nuevoHistoricoMediadorPrimario.setMediadorInforme(apiEspejo);
					nuevoHistoricoMediadorPrimario.setFechaDesde(new Date());
					Filter trlFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoRolMediador.CODIGO_TIPO_ESPEJO);
					DDTipoRolMediador tipoRolMediador = genericDao.get(DDTipoRolMediador.class, trlFilter);
					nuevoHistoricoMediadorPrimario.setTipoRolMediador(tipoRolMediador);
					genericDao.save(ActivoInformeComercialHistoricoMediador.class, nuevoHistoricoMediadorPrimario);
				}
			//Poner a null API Espejo
			} else if (!Checks.esNulo(exc.dameCelda(fila, 6)) && PONER_NULL_A_APIS.equals(exc.dameCelda(fila, 6))) {
				if (!Checks.esNulo(activo)) {
					if (Checks.esNulo(activo.getInfoComercial())) {
						ActivoInfoComercial infoComercial = new ActivoInfoComercial();
						infoComercial.setActivo(activo);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					} else {
						ActivoInfoComercial infoComercial = activo.getInfoComercial();
						infoComercial.setMediadorEspejo(null);
						genericDao.save(ActivoInfoComercial.class, infoComercial);
					}
					
					//Historico
					Filter codTRLFilter = genericDao.createFilter(FilterType.EQUALS, "tipoRolMediador.codigo", DDTipoRolMediador.CODIGO_TIPO_ESPEJO);
					Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Filter fechaFilter = genericDao.createFilter(FilterType.NULL, "fechaHasta");
					ActivoInformeComercialHistoricoMediador historicoMediadorPrimario = genericDao.get(ActivoInformeComercialHistoricoMediador.class, codTRLFilter, activoFilter, fechaFilter);
					
					if (!Checks.esNulo(historicoMediadorPrimario)) {
						historicoMediadorPrimario.setFechaHasta(new Date());
						genericDao.save(ActivoInformeComercialHistoricoMediador.class, historicoMediadorPrimario);
					} 
					
				}
			}
			
			if (!Checks.esNulo(tipoGestor) && !Checks.esNulo(usuario)) {
				if (!Checks.esNulo(activo)) {
					GestorEntidadDto dto = new GestorEntidadDto();
					dto.setIdEntidad(activo.getId());
					dto.setIdUsuario(usuario.getId());
					dto.setIdTipoGestor(tipoGestor.getId());
					activoAdapter.insertarGestorAdicional(dto);
				} else if (!Checks.esNulo(agrupacion) && !Checks.esNulo(agrupacion.getTipoAgrupacion())
						&& DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo())
						&& tipoGestor.getCodigo().equals(GestorExpedienteComercialApi.CODIGO_GESTOR_COMERCIAL)) {

					ActivoLoteComercial agrupacionTemp = (ActivoLoteComercial) agrupacion;
					agrupacionTemp.setUsuarioGestorComercial(usuario);
					activoAgrupacionApi.saveOrUpdate(agrupacionTemp);
				} else if (!Checks.esNulo(expediente)) {
					GestorEntidadDto dto = new GestorEntidadDto();
					dto.setIdEntidad(expediente.getId());
					dto.setIdUsuario(usuario.getId());
					dto.setIdTipoGestor(tipoGestor.getId());
					expedienteComercialApi.insertarGestorAdicional(dto);
				} else {
					throw new ParseException("Error al procesar la fila " + fila, 1);
				}
			}

		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}

}

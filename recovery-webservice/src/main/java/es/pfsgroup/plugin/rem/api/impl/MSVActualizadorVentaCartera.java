package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResultadoProcesarFila;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.recovery.api.UsuarioApi;

@Component
public class MSVActualizadorVentaCartera extends AbstractMSVActualizador implements MSVLiberator{

	public static final int EXCEL_FILA_INICIAL = 3;
	public static final int EXCEL_COL_NUMACTIVO = 0;
		
	
	@Autowired
	ActivoAdapter activoAdapter;
	
	@Autowired
	AgrupacionAdapter agrupacionAdapter;
	
	@Autowired
	ParticularValidatorApi particularValidatorApi;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	private MSVHojaExcel excel;
	
	
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
		excel = exc;
	}


	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		ActivoAgrupacion agrupacion = null;
		// Columna 'CÓDIGO ÚNICO OFERTA' 
		if(!Checks.esNulo(exc.dameCelda(fila, 7))){

			// Comprobamos si existe la agrupacion por descripcion
			String codigoOferta = exc.dameCelda(fila, 7);
			String descripcionAgrupacion = codigoOferta+"-"+prmToken.toString();
			Integer activoPrincipal = null;
			
			
			if (!particularValidatorApi.existeAgrupacionByDescripcion(descripcionAgrupacion)) {
				// Creamos la agrupacion
				DtoAgrupacionesCreateDelete dtoAgrupacionCrear = new DtoAgrupacionesCreateDelete();
				dtoAgrupacionCrear.setNombre("No esta definido");
				dtoAgrupacionCrear.setDescripcion(descripcionAgrupacion);
				dtoAgrupacionCrear.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL);
				dtoAgrupacionCrear.setFechaInicioVigencia(new Date());
				if (agrupacionAdapter.createAgrupacion(dtoAgrupacionCrear)){
					DtoAgrupaciones dtoAgrupacionMod = new DtoAgrupaciones();
					dtoAgrupacionMod.setIsFormalizacion(1);
					Usuario usuario = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username",exc.dameCelda(fila, 8)));// USUARIO GESTOR COMERCIALIZACIÓN (USERNAME)
					dtoAgrupacionMod.setCodigoGestorComercial(usuario.getId());
					agrupacion = genericDao.get(ActivoAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "descripcion",descripcionAgrupacion));
					List<ActivoAgrupacionActivo> listaActivoAgrupacionActivo = new ArrayList<ActivoAgrupacionActivo>();
					agrupacion.setActivos(listaActivoAgrupacionActivo);
					agrupacionAdapter.saveAgrupacion(dtoAgrupacionMod, agrupacion.getId());
				};
				activoPrincipal = 1;
			} else {
				agrupacion = genericDao.get(ActivoAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "descripcion",descripcionAgrupacion));
			}

			// Añadimos el activo a la agrupación	
			agrupacionAdapter.createActivoAgrupacion(Long.parseLong(exc.dameCelda(fila, 0)), agrupacion.getId(), activoPrincipal);	
			
			// Si es el último activo con ese 'CÓDIGO ÚNICO OFERTA' del excel
			if (esUltimoActivoAgrupacion(codigoOferta, fila)){
				// Creamos la oferta sobre a agrupacion
				DtoOfertasFilter dtoFilter = new DtoOfertasFilter();
				dtoFilter.setImporteOferta(exc.dameCelda(fila, 1));//PRECIO VENTA
				dtoFilter.setTipoOferta(DDTipoOferta.CODIGO_VENTA);
				dtoFilter.setNombreCliente(exc.dameCelda(fila, 10));//NOMBRE
				dtoFilter.setRazonSocialCliente(exc.dameCelda(fila, 11));//RAZON SOCIAL
				dtoFilter.setTipoDocumento(exc.dameCelda(fila, 12));
				dtoFilter.setNumDocumentoCliente(exc.dameCelda(fila, 13));
				dtoFilter.setCodigoPrescriptor(exc.dameCelda(fila, 9));//CÓDIGO PRESCRIPTOR
				dtoFilter.setIdAgrupacion(agrupacion.getId());
				dtoFilter.setVentaDirecta(true);
				agrupacionAdapter.createOfertaAgrupacion(dtoFilter);
				// Creamos un tramite para la oferta
				DtoOfertaActivo dtoOferta = new DtoOfertaActivo();
				List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(agrupacion.getId());
				dtoOferta.setIdOferta(Long.parseLong(listaOfertas.get(0).getIdOferta()));//La agrupacion solo tiene la oferta que acabamos de crear
				dtoOferta.setIdAgrupacion(agrupacion.getId());
				dtoOferta.setCodigoEstadoOferta(DDEstadoOferta.CODIGO_ACEPTADA);
				agrupacionAdapter.saveOfertaAgrupacion(dtoOferta); //Aqui crea el expediente
				
				// Creamos un expediente para la misma

				
				//Avanzar el tramite de la oferta
				
				
				//Llamar al servicioweb Modi de Bankia
				
				
			} else {
				
			}
			
		}
		
		return new ResultadoProcesarFila();
	}

	private boolean esUltimoActivoAgrupacion(String codigoOferta, int fila) throws IllegalArgumentException, IOException, ParseException {
		
		Boolean esUltimo =  true;
		if (fila != excel.getNumeroFilas()-1){ // si no es la ultima del archivo
			for (int i=fila+1; i<=excel.getNumeroFilas()-1;i++){
				if (codigoOferta.equals(excel.dameCelda(i, 7))){
					esUltimo = false;
				};
			}			
		}

		return esUltimo;
	}

}

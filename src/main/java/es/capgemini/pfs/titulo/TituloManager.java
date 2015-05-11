package es.capgemini.pfs.titulo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.titulo.dao.TituloDao;
import es.capgemini.pfs.titulo.dto.DtoTitulo;
import es.capgemini.pfs.titulo.model.DDSituacion;
import es.capgemini.pfs.titulo.model.DDTipoTitulo;
import es.capgemini.pfs.titulo.model.Titulo;

/**
 * Clase manager de la entidad Titulo.
 *
 */

@Service
public class TituloManager {

	@Autowired
    private Executor executor;

	@Autowired
    private TituloDao tituloDao;

    /**
     * Crea y retorna el dto para un titulo si existe o vacio si serï¿½ nuevo.
     * @param idContrato long
     * @param idTitulo long
     * @return DtoTitulo
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TITULO_MGR_GET_DTO)
    public DtoTitulo getDto(Long idContrato, Long idTitulo) {
        DtoTitulo dto = new DtoTitulo();
        // Si el id es -1 significa que se quiere crear un titulo
        if (idTitulo != -1) {
            dto.setTitulo(getTitulo(idTitulo));
        }
        Contrato contrato = (Contrato)executor.execute(
        		PrimariaBusinessOperation.BO_CNT_MGR_GET,
        		idContrato);
        dto.setContrato(contrato);
        return dto;
    }

    /**
     * Inserta un tÃ­tulo para un contrato determinado.
     *
     * @param titulo Titulo
     * @return Long
     */
     @BusinessOperation(PrimariaBusinessOperation.BO_TITULO_MGR_SAVE_TITULO)
    public Long saveTitulo(Titulo titulo) {
        return tituloDao.save(titulo);
    }

    /**
     * Retorna una lista de títulos para un contrato determinado.
     *
     * @param dtoBuscarContrato DtoBuscarContrato
     * @return DDTipoTitulo
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TITULO_MGR_FIND_TITULO_BY_CONTRATO_DTO)
    public List<Titulo> findTituloByContrato(DtoBuscarContrato dtoBuscarContrato) {
        return tituloDao.findTitulobyContrato(dtoBuscarContrato);
    }


    /**
     * Retorna una lista de títulos para un id de contrato determinado.
     *
     * @param idContrato Long
     * @return Titulos
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TITULO_MGR_FIND_TITULO_BY_CONTRATO)
    public Titulo findTituloByContrato(Long idContrato) {

        List<Titulo> titulos = tituloDao.findTitulobyContrato(idContrato);

        if (titulos.size() > 0) {
            return titulos.get(0);
        }
        return new Titulo();
    }

    /**
     * Busca titulos por id de contrato.
     * @param id Long
     * @return List lista de títulos
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TITULO_MGR_FIND_TITULOS_BY_CONTRATO)
    public List<Titulo> findTitulosByContrato(Long id) {
    	return tituloDao.findTitulobyContrato(id);
    }

    /**
     * Retorna una lista de títulos para un id de contrato determinado.
     *
     * @param idExpediente Long
     * @return Titulos
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TITULO_MGR_FIND_TITULOS_EXPEDIENTE)
    public List<Titulo> findTitulosExpediente(Long idExpediente) {
        Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);
        List<Titulo> titulos = new ArrayList<Titulo>();
        for (ExpedienteContrato expCnt : exp.getContratos()) {
            titulos.addAll(tituloDao.findTitulobyContrato(expCnt.getContrato().getId()));
        }
        return titulos;
    }

    /**
     * Inserta un tÃ­tulo.
     *
     * @param dto Titulo
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TITULO_MGR_SAVE_TITULO_DTO)
    @Transactional(readOnly = false)
    public void saveTitulo(DtoTitulo dto) {
        Titulo titulo = dto.getTitulo();
        if (titulo == null) {
            titulo = new Titulo();
            titulo.setContrato(dto.getContrato());
        }

        DDTipoTitulo tipoTitulo = (DDTipoTitulo)executor.execute(
        		ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        		DDTipoTitulo.class,
        		dto.getCodigoTipo());
        titulo.setTipoTitulo(tipoTitulo);
        DDSituacion situacion = (DDSituacion)executor.execute(
        		ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        		DDSituacion.class,
        		dto.getCodigoSituacion());
        titulo.setSituacion(situacion);
        titulo.setIntervenido(dto.getIntervenido());
        titulo.setComentario(dto.getComentario());

        tituloDao.saveOrUpdate(titulo);
    }

    /**
     * Devuelve un tÃ­tulo por su id.
     *
     * @param idTitulo Long
     * @return titulo Titulo
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TITULO_MGR_GET_TITULO)
    public Titulo getTitulo(Long idTitulo) {
        return tituloDao.get(idTitulo);
    }

    /**
     * Elimina un tÃ­tulo por su id.
     *
     * @param idTitulo Long
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TITULO_MGR_DELETE_TITULO)
    @Transactional(readOnly = false)
    public void deleteTitulo(Long idTitulo) {
        tituloDao.deleteById(idTitulo);
    }
}

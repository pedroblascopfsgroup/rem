package es.capgemini.pfs.web.clientes;

import org.springframework.stereotype.Component;

import es.capgemini.devon.web.DynamicElementAdapter;

@Component
public class HistoricoEventosTab extends DynamicElementAdapter {

    public HistoricoEventosTab() {
        super("clientes", "historicoEventos", "/WEB-INF/jsp/clientes/tabs/tabHistoricoEventos.jsp", 1100, 1);
    }

}

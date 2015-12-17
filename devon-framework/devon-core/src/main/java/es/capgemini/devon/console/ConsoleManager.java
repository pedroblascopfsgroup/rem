package es.capgemini.devon.console;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.console.dto.DtoConsole;

/**
 * @author Nicolás Cornaglia
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = true)
public class ConsoleManager {

    @Autowired(required = false)
    private ConsolePlugin[] plugins;

    @BusinessOperation
    @Transactional
    public List<ConsolePlugin> listConsoleItems(DtoConsole dto) {
        return Arrays.asList(plugins);
    }

}

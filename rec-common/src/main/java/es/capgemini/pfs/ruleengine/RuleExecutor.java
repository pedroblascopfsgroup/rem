  package es.capgemini.pfs.ruleengine;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Savepoint;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.dsm.EntityDataSource;
import es.capgemini.pfs.ruleengine.filter.RuleFilter;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */

public class RuleExecutor {

    @Autowired
    private EntityDataSource entityDataSource;

    @Autowired
    private RuleConverterUtil rcUtil;

    //@Autowired
    private RuleExecutorConfig config;

    private boolean cleanBeforeExcecution = true;

    private final Log logger = LogFactory.getLog(getClass());

    @BusinessOperation
    public RuleResult execRule(RuleEndState endState) {
        return execRule(endState, null);
    }

    private String generateBaseRule(String ruleDefinition, List<RuleFilter> filters) {
        StringBuffer sql = new StringBuffer();
        sql.append(" FROM " + getConfig().getTableFrom());
        sql.append(" WHERE ");
        if (!(getConfig().isJsonDefinition() || getConfig().isXmlDefinition())) {
            logger.error("No se ha encontrado forma de convertir el tipo:" + getConfig().getRuleDefinitionType());
            throw new ValidationException();
        }
        if (getConfig().isJsonDefinition()) {
            sql.append(rcUtil.JSONToRule(ruleDefinition, getConfig()).generateSQL());
        }
        if (getConfig().isXmlDefinition()) {
            sql.append(rcUtil.XMLToRule(ruleDefinition, getConfig()).generateSQL());
        }
        if (filters != null && filters.size() > 0) {
            sql.append(" AND ");
            Iterator<RuleFilter> rfI = filters.iterator();
            while (rfI.hasNext()) {
                sql.append(rfI.next().generateSQL());
                if (rfI.hasNext()) {
                    sql.append(" AND ");
                }
            }
        }

        return sql.toString();
    }
    
    @BusinessOperation
    public String generateMostPriorityBaseRule(String ruleDefinition) {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT " + getConfig().getColumnFromRef());
        sql.append(" FROM " + getConfig().getTableFrom());
        sql.append(" WHERE ");
        if (!(getConfig().isJsonDefinition() || getConfig().isXmlDefinition())) {
            logger.error("No se ha encontrado forma de convertir el tipo:" + getConfig().getRuleDefinitionType());
            throw new ValidationException();
        }
        if (getConfig().isJsonDefinition()) {
            sql.append(rcUtil.JSONToRule(ruleDefinition, getConfig()).generateSQL());
        }
        if (getConfig().isXmlDefinition()) {
            sql.append(rcUtil.XMLToRule(ruleDefinition, getConfig()).generateSQL());
        }
        
        return sql.toString();
    }
    
    

    public RuleResult execRule(RuleEndState endState, List<RuleFilter> filters) {
        RuleResult result = new RuleResult(endState.getName());
        result.start();

        if (endState.getRuleDefinition() == null) {
            String msg = "El END_STATE: " + endState.getName() + "_" + endState.getValue() + "  no ha definido ninguna regla!";
            logger.warn(msg);
            result.finishWithWarnings(msg);
            return result;
        }

        StringBuffer sql = new StringBuffer();
        try {
            sql.append("UPDATE " + getConfig().getTableToUpdate() + " ");
            sql.append(" SET " + getConfig().getColumnToUpdate() + " = " + endState.getValue());
            sql.append(" WHERE " + getConfig().getColumnToUpdate() + " IS NULL");
            sql.append(" AND " + getConfig().getColumnToRef() + " IN (");
            //Sub-query
            sql.append("SELECT DISTINCT(" + getConfig().getColumnFromRef() + ")");

            sql.append(generateBaseRule(endState.getRuleDefinition(), filters));

            sql.append(" ) ");

        } catch (Exception e) {
            logger.error(e);
            result.finishWithErrors(e);
            return result;
        }

        Connection connection = null;
        try {
            connection = entityDataSource.getConnection();
        } catch (SQLException e) {
            logger.error(e);
            result.finishWithErrors(e);
            return result;
        }

        Savepoint tx = null;
        int rows = -1;
        try {
            connection.setAutoCommit(false);
            tx = connection.setSavepoint("RULE_" + endState.getValue());

            logger.info("Implantando EndSate: \"" + endState.getName() + "\"");
            logger.debug("                [" + sql.toString() + "]");

            rows = connection.prepareStatement(sql.toString()).executeUpdate();
            connection.commit();

            result.finishOK(rows);
            logger.info("->\"" + endState.getName() + "\" implantado! - [Rows: " + rows + ", Tiempo: " + result.getTimeInSeconds() + " segs]");

        } catch (SQLException e) {
            logger.error(e);
            result.finishWithErrors(e);
            try {
                connection.rollback(tx);
            } catch (SQLException e1) {
                logger.error(e1);
            }
            return result;
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    logger.error(e);
                }
            }
        }
        return result;
    }

        
    @BusinessOperation
    public RuleResult checkRule(String ruleDefinition,List<String> morePriorityRules) {
        RuleResult result = new RuleResult("CHECK_RULE");
        result.start();

        StringBuffer sql = new StringBuffer();
        try {
            sql.append("SELECT COUNT(DISTINCT(" + getConfig().getColumnFromRef() + ")) ");
            sql.append(generateBaseRule(ruleDefinition, null));
        } catch (Exception e) {
            logger.error(e);
            result.finishWithErrors(e);
            return result;
        }
        
        //Filtramos los valores obtenido en las reglas con mas prioridad
        if(morePriorityRules != null && morePriorityRules.size() > 0){
        	for(String rule :morePriorityRules){
        		sql = sql.append(" AND ").append(getConfig().getColumnFromRef()).append(" NOT IN (").append(rule).append(")");
        	}
        }

        Connection connection = null;
        try {
            connection = entityDataSource.getConnection();
        } catch (SQLException e) {
            logger.error(e);
            result.finishWithErrors(e);
            return result;
        }

        int rows = -1;
        ResultSet rs = null;
        try {
            connection.setAutoCommit(false);
            logger.info("Comprobando regla");
            logger.info("                [" + sql.toString() + "]");
            rs = connection.prepareStatement(sql.toString()).executeQuery();
            rs.next();
            rows = rs.getInt(1);
            result.finishOK(rows);
            logger.info("-> Regla comprobada! - [Rows: " + rows + ", Tiempo: " + result.getTimeInSeconds() + " segs]");

        } catch (SQLException e) {
            logger.error(e);
            result.finishWithErrors(e);
            return result;
        } finally {
        	if (rs != null){
        		try {
					rs.close();
				} catch (SQLException e) {
					logger.error(e);
				}
        	}
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    logger.error(e);
                }
            }
        }
        return result;
    }

    public List<RuleResult> execRules(List<RuleEndState> endStates, List<RuleFilter> filters) {
        Collections.sort(endStates, new RuleSort());
        clearBeforeExcecution();
        Iterator<RuleEndState> i = endStates.iterator();
        List<RuleResult> results = new ArrayList<RuleResult>();
        while (i.hasNext()) {
            results.add(execRule(i.next()));
        }
        //Verificamos que se han actualizado la totalida de filas
        int nullRows=countNullRows(getConfig().getTableToUpdate(),getConfig().getColumnToUpdate());
        if(nullRows>0){
            //Hay filas nulas, no se ha definido regla por defecto
            logger.warn("La ejecucion ha dejado ["+nullRows+"] sin actualizar!! Se debera definir una regla por defecto que abarque a la totalidad de filas.");
        }
        return results;
    }

    public int clearBeforeExcecution() {
        StringBuffer sql = new StringBuffer();
        sql.append("UPDATE " + getConfig().getTableToUpdate() + " ");
        sql.append(" SET " + getConfig().getColumnToUpdate() + " = NULL");

        Connection connection = null;
        try {
            connection = entityDataSource.getConnection();
        } catch (SQLException e) {
            logger.error(e);
        }

        Savepoint tx = null;
        int rows = -1;
        try {
            connection.setAutoCommit(false);
            tx = connection.setSavepoint("CLEAR_RULES");

            logger.info("Limpiando valores previos para reglas...");
            rows = connection.prepareStatement(sql.toString()).executeUpdate();
            connection.commit();
            logger.info("->Limpieza finalizada! Se han actualizado [" + rows + "] filas");

        } catch (SQLException e) {
            logger.error(e);
            try {
                connection.rollback(tx);
            } catch (SQLException e1) {
                logger.error(e1);
            }
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    logger.error(e);
                }
            }
        }
        return rows;
    }
    
    public int countNullRows(String table, String columm) {
        StringBuffer sql = new StringBuffer();
        sql.append(" SElECT COUNT(*) AS ROWCOUNT FROM " + table + " WHERE "+columm+" IS NULL");
        int rows=-1;
        Connection connection = null;
        ResultSet resultSet = null;
        try {
            connection = entityDataSource.getConnection();
            resultSet = connection.createStatement().executeQuery(sql.toString());
            resultSet.next();
            rows = resultSet.getInt("ROWCOUNT");
        } catch (SQLException e) {
            logger.error(e);
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    logger.error(e);
                }
            }
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    logger.error(e);
                }
            }
        }
        return rows;
    }

    public List<RuleResult> execRules(List<RuleEndState> endStates) {
        return execRules(endStates, null);
    }

    /**
     * @return the getConfig()
     */
    public RuleExecutorConfig getConfig() {
        return config;
    }

    /**
     * @param getConfig() the getConfig() to set
     */
    public void setConfig(RuleExecutorConfig config) {
        this.config =config;
    }

    /**
     * @return the cleanBeforeExcecution
     */
    public boolean isCleanBeforeExcecution() {
        return cleanBeforeExcecution;
    }

    /**
     * @param cleanBeforeExcecution the cleanBeforeExcecution to set
     */
    public void setCleanBeforeExcecution(boolean cleanBeforeExcecution) {
        this.cleanBeforeExcecution = cleanBeforeExcecution;
    }

}

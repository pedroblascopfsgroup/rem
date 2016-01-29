package es.capgemini.devon.log;

import java.util.List;

public interface LoggerManager {

    public abstract String getLoggerLevel(String category);

    public abstract String setLoggerLevel(String category, String level);

    public abstract List<String> getCategories();

}
package es.capgemini.pfs.batch.common;

import java.io.File;
import java.util.Map;
import java.util.regex.Pattern;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.core.MessageChannel;
import org.springframework.integration.file.CompositeFileListFilter;
import org.springframework.integration.file.FileListFilter;
import org.springframework.integration.file.FileReadingMessageSource;
import org.springframework.integration.file.PatternMatchingFileListFilter;
import org.springframework.integration.file.config.FileReadingMessageSourceFactoryBean;
import org.springframework.util.Assert;

import es.capgemini.devon.batch.file.FolderFileSourceGenerator;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.devon.utils.IntegrationUtils;

public class FolderFileSourceGeneratorPFS extends FolderFileSourceGenerator{
    
    private final Log logger = LogFactory.getLog(getClass());
    
    
    public void initialize() {
        Assert.notNull(baseDirectoryToGenerate, "'baseDirectoryToGenerate' must not be null");

        Map<String, String> inDirs = FileUtils.generateDirectories(baseDirectoryToGenerate, patternToGenerate, inDir, backupSubDir);
        for (String code : inDirs.keySet()) {
            final String pattern = filePattern.replace(workingCodePlaceholder, code);
            logger.info("Creating fileSourceAdapter [" + inDirs.get(code) + File.separator + pattern + "] for use by [" + channel + "] every ["
                    + period + "ms.]");

            // Build FileReadingMessageSource
            FileReadingMessageSource source = buildFileReadingMessageSource(inDirs.get(code), pattern, true);

            // Get the correct Message Channel (one per folder if concurrent, one global otherwise)
            MessageChannel messageChannel = getChannel(code);

            // Build SourcePollingChannelAdapter
            IntegrationUtils.buildSourcePollingChannelAdapter(source, messageChannel, period, true);

            // Subscribe the bean to the channel if configured one channel per folder
            if (isEntityConcurrent()) {
                registerSubscription(injectTransformer(messageChannel));
            }

        }
    }
        
        
        
    public static FileReadingMessageSource buildFileReadingMessageSource(String directory, String pattern, boolean autoCreateDirectory) {
            FileReadingMessageSourceFactoryBean msFactory = new FileReadingMessageSourceFactoryBean();
            msFactory.setAutoCreateDirectory(autoCreateDirectory);
            msFactory.setDirectory("file:" + directory);
            msFactory.setResourceLoader(ApplicationContextUtil.getApplicationContext());

            FileListFilter aoflf = new AcceptOnceFileListFilterPFS();
            FileListFilter pmflf = new PatternMatchingFileListFilter(Pattern.compile(pattern));
            CompositeFileListFilter filter = new CompositeFileListFilter(pmflf, aoflf);
            msFactory.setFilter(filter);

            FileReadingMessageSource source;
            try {
                source = (FileReadingMessageSource) msFactory.getObject();
            } catch (Exception e) {
                throw new FrameworkException(e);
            }

            return source;
    }

}
